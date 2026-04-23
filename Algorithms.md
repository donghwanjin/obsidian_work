#### 3.1.4.1. Replenishment Demand Pre-calculation

replen_demand_manager calls REPLEN_DEMAND_FMCF_CalcReplenSkuDataPerProd at the start of each pass.  This function does the following (essentially implements strategy 2.1.1 SKU Replenished Next):

- Calculate the RPOP task pool (REPLEN_DEMAND_FMCF_CalcRpopMcapTaskPool):
    - Calculate the pool size - this is the palletiser hourly rate, multiplied by the number oif in-service palletisers, multiplied by the RPOP hours value.
    - Loop all MCAP tasks and list all that exist, and are not already hard-allocated to stock.  Sort the list by priority.
    - Count up the total cases needed by MCAP tasks in priority order, until we reach the calculated pool size.  Truncate the task list at that point.
- Wipe the gMsReplenSkuList contents and start regenerating.
- Now loop through the RPOP task pool.  Add each pick on these tasks to an entry for the product in gMsReplenSkuList.
    - Sum up the OrderDemandQty for each product, and save the earliest PriorityTime from the picks.
- Now loop through each product:
    - Count up the total number of available cases in DMS, and subtract the number of picks from hard-allocated tasks.  Add any stock that is not fully reserved to the replen SKU list.
    - Add an products with no stock in to the list as well
- At the end of this, gMsReplenSkuList is populated with a list of all products, with the total CasesInDmsQty and TraysInDmsQty from stock, and the OrderDemandQty and PriorityTime from the picks.

#### 3.1.4.2. Replenishment Demand Creation

replen_demand_manager in the background creates and manages demand records.  Each pass CalcDemandForProducts is called:

- Firstly call REPLEN_DEMAND_FMCF_CalcAllReplenSkuDataPerProd to pre-calculate data for replen.
- Check if products 'require' replen demand - requires replen demand if the product has any UOM-based demand, or has stock.
    - NB REPLEN_DEMAND_ProdRequiresReplenDemand is really just saying the product is eligible for replen demand.
- For any products that don't require replen demand, any 'unused' demand records are deleted - these are demands which are not already linked to a replen request.
- Any others are added to a list and we call REPLEN_DEMAND_CalcProductDemand.
- For FMCF we are using REPLEN demand type so REPLEN_DEMAND_CalcProductReplenDemand is called.
- For FMCF we are using FMCF demand reason so REPLEN_DEMAND_FMCF_CalcReplenDemand is called.
    - BACKGROUND demand reason is disabled for storage area types of MS.  We still use it but it is created elsewhere.
- REPLEN_DEMAND_FMCF_CalcReplenDemand uses the entry in gMsReplenSkuList to set up the replen demand.
    - If OrderDemandQty > CasesInDmsQty, the demand reason is set to FMCF, otherwise it is set to BACKGROUND.
    - Replen demand quantity is created ignoring any cases on route to DMS - these are handled in the replen requests.
    - Find a replen demand we can update - just one where the destination / product / unit all match
    - If we found it, update the demand reason, quantity and priority time. 
    - If switching it to background, we also reset all the replen request priorities to NULL_TIME at that point (they all use the replen demand time).
    - If switching it to FMCF, we also loop through and recalculate request priority times at this point (REPLEN_DEMAND_FMCF_RecalcMsReplenRequestPriorities)

- TODO from WOW ReplenLocked - locks out replen after finishing a replen request, until OP RSVN has finished a new pass - check with Matt.

#### 3.1.4.3. Replenishment Request Creation

replen_request_ms loops through checking and creating replen requests

- REPLEN_REQUEST_FMCF_CheckRequests checks the existing replen requests:
    - Sets Finished any requests where the stock reached a satisfactory location (when LOC_IsInStorageArea gives the destination storage area).
    - If the replen request is not valid (REPLEN_REQUEST_FMCF_Valid) then cancel it.  This includes due to stock held, or locations we can't retrieve from.
- REPLEN_REQUEST_FMCF_GenerateRequests generates new requests where needed:
    - Loop through each storage area of type MS.
    - Firstly call REPLEN_DEMAND_FMCF_CalcReplenSkuDataPerProd to pre-calculate data for replen.
    - Then loop through the replen demands for the storage area, looking for ones where the replen request quantity is lower than the demand quantity, and add those to a list.
    - Calculate the next replen request priority time for each of these (REPLEN_DEMAND_FMCF_CalcNextReplenRequestPriorityTime).
    - Sort the list by the replen request priority time.
    - Take the top priority order from the list, and call REPLEN_REQUEST_FMCF_ReplenProductForDemand to create a new replen request.
    - Update the replen list by either removing the now satisfied demand from the list, or updating the next priority time for it, and repeat, until the list is empty.
- REPLEN_REQUEST_FMCF_ReplenProductForDemand amends or createa a replen request for the demand:,
    - Firstly it calculates the initial replen quantity needed.
    - Looks for existing request that can be amended e.g. the stock has additional quantity available (REPLEN_REQUEST_FMCF_FindAmendableRequest).
    - If we find one, recalculate the override replen quantity, and then set the quantity and priority time.
    - If not, find a new stock record to replenish (REPLEN_REQUEST_FMCF_ReplenStockForDemand).
- Finally the process checks which requests are executable in this moment (REPLEN_REQUEST_FMCF_CheckExecutableRequests):
    - For each storage area, make a list of replen requests for this area, and sort by priority.
    - Check how much space is left in the DMS (REPLEN_REQUEST_FMCF_SpaceInDms)
    - Step through the replen list in priority sequence.
    - For each request, subtract the quantity from the available DMS space and add the request to the executable list.
    - Stop adding requests once we have reached param REPLEN_QTY_FOR_RETRIEVAL requests.
    - As a safeguard, ensure at least REPLEN_QTY_FOR_AUTO_RETRIEVAL_ONLY auto-compatible requests have been added to the list.
    - If we have run out of space remaining in DMS, stop flagging requests executable at that point.


Step 1) Handled in REPLEN_DEMAND_FMCF_CalcRpopMcapTaskPool.
Add Mcap Tasks to TaskPool, sort by Priority then total up Cases until the number
reaches the max number of cases as determined in REPLEN_REQUEST_FMCF_CalcRpopSize.
Once max number has been reached truncate list to exlude less urgent tasks from Replen.
Picks, Stock and Prod added to gMsReplenSkuList for valid Mcap Tasks

Step 2 & 3) Handled in UpdateAndCreateDemandFromList
Calculate the Order Replen Demand + StockEnRoute
StockEnRoute = Stock that we have created a replen request for
OrderReplenDemand (OrderDemand - StockInDms - StockEnRoute) =
                   REPLEN_DEMAND_GetPickQty - REPLEN_DEMAND_GetReplenRequestQty

Step 4) Handled in replen_request_ms inside of REPLEN_REQUEST_FMCF_GenerateRequests >
REPLEN_REQUEST_CalcNextReplenRequestPriorityTimeForDemand > SortReplenListByPriority

Step 5 & 6) Handled in UpdateAndCreateDemandFromList > REPLEN_DEMAND_FMCF_CalcSkuRefillForParam.
If OrderDemandQty > CasesInDmsQty then calculate Background Refill Demand based on ADU etc.
If ReplenDemandQty is still < 1 then skip this Prod. N.B. Nominal Priority e.g. LOW/HIGH is not set.

Step 7) SortReplenListByPriority determines which Replen Demand / Prod to sort Replen for first.
In addition to Priority Time it considers Reple Demand Reason, Qty and
Cases Per Pallet (Prefer Fewer Cases)

Step 8) EASY/MEDIUM/HARD Retrieval not considered.

Step 9) Further checks handled in Step 7

Step 10) No Priority Set.