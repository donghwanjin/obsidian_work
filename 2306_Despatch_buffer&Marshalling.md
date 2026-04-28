# 1. Overview

## 1.1. Name

Despatch Buffer and Marshalling

## 1.2. Objective

## 1.3. Scope

## 1.4. Assumptions

## 1.5. Dependencies

## 1.6. Glossary of terms
| Abbreviation | Term                       |
| ------------ | -------------------------- |
| RL           | Route Load                 |
| ML           | Marshalling Lane/Loc       |
| MLG          | Marshalling Lane/Loc Group |

# 2. Functional Requirements

## 2.1. Input

## 2.2. Output

## 2.3. Logic

## 2.4. Error handling

# 3. Technical Design

## 3.1. Component design

### 3.1.1. Purpose

### 3.1.2. Interfaces - OMW

#### 3.1.2.1. Change Marshalling Area

WCS provides an action on OMW to manually assign or change the allocated outbound Marshalling Area before any pallet of the RL is heading towards or in its already allocated Ambient Despatch Buffer. (i.e. 1st ambient DDP built by palletiser. If not ambient DDP, when the move request has been generated to retrieve non-Ambient DDPs from the ASRS buffer or a Tramming Task has been generated to move an AUP to manual marshalling lane.)

Changing Marshalling Area will force WCS to change the Ambient Despatch Buffer allocation based on the new Marshalling Area.

#### 3.1.2.2. Manual Temperature Release

Action on Route load to release a certain temperature for marshalling.

Sets Released Time on the route load for the temperature. 

#### 3.1.2.3. Marshalling Temperature Lane Change

Change within a marshalling lane group

### 3.1.3. Data structures

#### 3.1.3.1. Route Load

Expand Route Load with the below

| Field                                          | Data Type     | Description                                                                                     |
| ---------------------------------------------- | ------------- | ----------------------------------------------------------------------------------------------- |
| Released NO_OF_WMS_DEFAULT_STORAGE_CLASS_TYPES | DAI_TIME_TYPE | Time each temp was release by host or manually released on WCS<br><br>Used for Sequencing temps |
| MarshallingArea                                | CHAIN_REC_NO  |                                                                                                 |



![[Pasted image 20260417115916.png]]

#### 3.1.3.2. Marshalling Area

Provided from the marshalling_area plugin.

| **Type** | **Order Type**          | **State**                                           | **Marshalling Area ID**                                                                                                                                                                         | **Comment**                                                                                                                                                                                                                               |
| -------- | ----------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Outbound | REPLEN<br><br>NEW STORE | **_Open_**<br><br>**_Closing_**<br><br>**_Closed_** | **MA81**<br><br>**MA82**<br><br>**_…_**<br><br>**MA90**                                                                                                                                         | 10 Marshalling Areas, each includes:<br><br>     1 aisle of Ambient Despatch Buffer<br><br>     4 Marshal Lane Group each of which has 3 lanes.<br><br>     Manual marshalling lanes.  (Setup 10 lanes initially each has capacity of 4 ) |
| Inbound  | HUB<br><br>ECOMM        | **_MA01_**                                          | 1 Marshalling Area at inbound, Setup initially:<br><br>   4 Manual marshalling Lane for Ambient.<br><br>   4 Manual marshalling lane for NonAmbient.<br><br>   Those lanes have capacity of 40. |                                                                                                                                                                                                                                           |

*Purge orders don't require a marshalling area

#### 3.1.3.3. Marshalling Loc

Provided from the marshalling_area plugin.

|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|**Type**|**Usage**|**Marshal**<br><br>**Area**|**Marshalling Loc ID**<br><br>Du Status DESPATCHED|**Capacity**|**Loc**<br><br>**State**|**Comment**|
|Auto<br><br>  <br><br>(Gravity<br><br>Lane)|Ambient|MA81<br><br>…<br><br>  <br><br>MA90|O-R1-001 ... O-R1-012<br><br>O-R2-001 ... O-R2-012<br><br>O-R3-001 ... O-R3-012<br><br>O-R4-001 ... O-R4-012<br><br>O-R5-001 ... O-R5-012<br><br>O-R6-001 ... O-R6-012<br><br>O-R7-001 ... O-R7-012<br><br>O-R8-001 ... O-R8-012<br><br>O-R9-001 ... O-R9-012<br><br>O-R0-001 ... O-R0-012|Fixed<br><br>24 DPs<br><br>  <br><br>PLC also report SFTI for lane fill status|AVAILABLE<br><br>LOCKED<br><br>BARRED|12 lanes per outbound marshalling area<br><br>001 is the right most flow lane<br><br>012 is the left most flow lane<br><br>In total 120 Flow Rack Marshalling lanes<br><br>Lane Temperature can be changed between Ambient and NonAmbient. It should only be used when equipment in fault. The current Active Load will carry on after the change. But the next Load will be de-assigned if MLG no longer contain 1 available Ambient and 1 available NonAmbient lanes.|
|NonAmbient  <br>(By default 3,6,9 and 12 are non ambient)|
|QA*|
|Manual|Mixed|O-R1-001-M ... O-R1-020-M<br><br>...<br><br>O-R0-001-M ... O-R0-020-M|configurable on WCS<br><br>for AUP (or DDP by exception)|20 Manual lanes per marshalling area.<br><br>Default capacity is 4.|
|Ambient|MA01|A-RI-001 … A-RI-004|Initially setup 4 manual lanes per temperature in inbound marshalling area.<br><br>Default capacity is 40.|
|Mixed|MA01|C-RI-001 … C-RI-004|

*Usage QA can be configured against one or more lanes to deal with problem pallets appeared on the Monorail. Operator must wait lane become empty and no more pallet coming before changing Lane to QA Usage. Operator can change LocState to LOCKED to allow the lane being emptied first.

If no QA lane is configured, the problem pallets will be sent into buffer for storage, operator can manually request it to any lane regardless of usage.

#### 3.1.3.4. Marshalling Lane Group

Project-specific additional table for grouping marshalling lanes.

|   |   |   |
|---|---|---|
|**Marshal Area**|**Marshalling Lane Group ID**<br><br>Estimated Containers ASSIGNED|**Lanes**|
|MA81|O-G1-001|001, 002, 003|
|O-G1-002|004, 005, 006|
|O-G1-003|007, 008, 009|
|O-G1-004|010, 011, 012|
|O-G1-001-M|Dummy MLG for non conveyable|
|MA82|O-G2-001 ... O-G2-004||
|O-G2-001-M|Dummy MLG for non conveyable|
|MA83|O-G3-001 ... O-G3-004||
||O-G3-001-M|Dummy MLG for non conveyable|
|MA84|O-G4-001 ... O-G4-004||
||O-G4-001-M|Dummy MLG for non conveyable|
|MA85|O-G5-001 ... O-G5-004||
||O-G5-001-M|Dummy MLG for non conveyable|
|MA86|O-G6-001 ... O-G6-004||
||O-G6-001-M|Dummy MLG for non conveyable|
|MA87|O-G7-001 ... O-G7-004||
||O-G7-001-M|Dummy MLG for non conveyable|
|MA88|O-G8-001 ... O-G8-004||
||O-G8-001-M|Dummy MLG for non conveyable|
|MA89|O-G9-001 ... O-G9-004||
||O-G9-001-M|Dummy MLG for non conveyable|
|MA90|O-G0-001 ... O-G0-004||
||O-G0-001-M|Dummy MLG for non conveyable|
|MA01|A-GI-001|Dummy MLG for inbound marshalling area ambient|
||C-GI-001|Dummy MLG for inbound marshalling area mixed temp|

#### 3.1.3.5. Despatch Buffer

Project-specific table.

|   |   |   |   |   |
|---|---|---|---|---|
|**Storage**<br><br>**Type**|**Storage Class**|**Despatch Buffer ID**|**Host ID**<br><br>Du Status BUFFERED|**Comment**|
|ASRS|Ambient|**_DBF-AMB81_**<br><br>**_DBF-AMB82_**<br><br>**_…_**<br><br>**_DBF-AMB90_**|**O-SB-001**<br><br>**O-SB-002**<br><br>**_…_**<br><br>**O-SB-000**|10 Ambient Despatch Buffers each associated with 1 highbay aisle.|
|Produce TMC|**_DBF-TMC_**|**T-SB-001**|1 buffer per temperature chamber each associated with 1 or more highbay aisles|
|Chilled|**_DBF-CHL_**|**C-SB-001**|
|Frozen|**_DBF-FRZ_**|**F-SB-001**|

#### 3.1.3.6. Staging

Project-specific table.

|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|**Usage**|**Storage Class**|**Type**|**Staging Loc Group ID**|**Host ID**<br><br>**Du Status BUFFERED**|**Comment**|**Notes**|
|Despatch|Ambient|**_Inbound_**|**_SLG-AMB-IB_**|A-WO-001-I|Those areas are located inside the chamber near inbound or outbound marshalling area, and each is associated with a despatch buffer.<br><br>  <br><br>Each area is associated with a number of Staging Locations (Setup 10 initially)<br><br>  <br><br>Normally AUPs are stored in those area. But sometimes DDPs are also allowed. E.g.<br><br>  - Manually picked DDP in Freezer<br><br>  - Low height DDPs from manual<br><br>  - When the Infeed to automation is LTOS  <br><br>  - anything else?||
|**_Outbound_**|**_SLG-AMB-OB_**|A-WO-001|
|Produce TMC|**_Inbound_**|**_SLG-TMC-IB_**|T-WO-001-I|
|**_Outbound_**|**_SLG-TMC-OB_**|T-WO-001|
|Chilled|**_Inbound_**|**_SLG-CHL-IB_**|C-WO-001-I|
|**_Outbound_**|**_SLG-CHL-OB_**|C-WO-001|
|Frozen|**_Inbound_**|**_SLG-FRZ-IB_**|F-WO-001-I|
|**_Outbound_**|**_SLG-FRZ-OB_**|F-WO-001|
|Prepick*|Ambient|**_Outbound_**|**_SLG-AMB-PP_**|_Not Buffered_|Those areas should be located inside the chamber near conveyor infeed. They are used to temporarily store manually prepicked DDPs before ASRS has space.<br><br>No pre-picking logic in freezer as there is no conveyor infeed in freezer manual area.|*CP040 - approved now|
|TMC|**_Outbound_**|**_SLG-TMC-PP_**|_Not Buffered_|
|Chilled|**_Outbound_**|**_SLG-CHL-PP_**|_Not Buffered_|

#### 3.1.3.7. Purge Order Handover

See Drop Loc usage PURGE [2306 TD: System Config - Matflo Projects - Global Site](https://wiki.dematic.net/spaces/MP/pages/861933068/2306+TD+System+Config#id-2306TD:SystemConfig-DropLoc)

#### 3.1.3.8. DU

We can't cancel already picked DUs that have been messaged to the host already.  For a DU that ends up stuck e.g. LTOS on a despatch buffer aisle, we have a 'PreventShipping' flag which rules out the DU from consideration during the marshalling lane group allocation processes below.

This is set/cleared manually via an action on the OM screens (same as Aldi Bardon).

### 3.1.4. Parameters

|||||
|---|---|---|---|
|**RELEASE_FOR_STAGING_DESPATCH_PICKING_WINDOW**|Allow picking of pallets going via despatch staging (see Automated despatch suitable logic)|240 mins||
|**RELEASE_FOR_STAGING_PREPICKING_ WINDOW**|Allow prepicking DDPs which require manual picking before despatch buffer has space.|360 mins|CP040|
|**RELEASE_FOR_MARSHALLING_DESPATCH_WINDOW**|Allow Automatically Release fully buffered Ambient pallets for Marshalling.<br><br>Allow Marshalling Lane Group being assigned.|210 mins||
|**URGENT_LOAD_DESPATCH_WINDOW**|Become urgent load which can use more space in ASRS Despatch Buffer|300 mins||
|**DESPATCH_BUFFER_MAX_FILL_PRCNT**|Maximum planning fill for the despatch buffer, allow for any generated mop ups|90%|Do we need to think about system pallet stacks in the temp despatch buffers?|
|**DESPATCH_BUFFER_NON_URGENT_MAX_FILL_PRCNT**|Maximum planning fill for the despatch buffer, for loads which are not within the urgent priority window|90%|Match above if host does strict sequencing|
|**DESPATCH_BUFFER_MAX_SAME_DESPATCH_TIME_RANGE**|Window in which the despatch times of a route load are treated equivalent|15 minutes||
|**DESPATCH_BUFFER_MAX_SAME_DESPATCH_TIME_ROUTE_LOADS**|Max number of loads with the same despatch time (as defined by **_SAME_DESP_TIME_RANGE_**) allowed to be allocated to the same ambient despatch buffer|||
|**ASSIGN_SAME_MLG_MIN_DESPATCH_GAP**|Difference between despatch times of route loads to assign to the same marshalling lane group, unless there is no option then WCS will pick the biggest gap|60mins||

### 3.1.5. DU Rules

#### 3.1.5.1. DU Ready for Despatch Buffer Allocation 

For a DU to be ready for despatch buffer allocation

1. RESERVED 
2. TODO - Post top up build 

#### 3.1.5.2. DU Suitable for Automated Despatch Buffer

For a DU to be suitable for the Automated Despatch Buffer it must satisfy the below:

1. D/DD Pallet
2. Pallet only has outbound conveyable items – Defined by suitable for automated despatch flag on the product hierarchy
3. The Manual Picking Infeed conveyor must be in service for the chamber.
    1. _Freezer has no manual infeed so manually picked pallets go to automated despatch_
4. DU has flag "Send via manual marshalling" to FALSE

#### 3.1.5.3. DU Suitable for Staging 

For a du to be suitable to go via staging

1. Not be suitable for Automated despatch buffer above
2. If Ambient/Chilled - not valid if Hub/Ecomm - These go direct to marshalling at the inbound outfeeds

#### 3.1.5.4. DU Ready for picking

If any of the below are true

1. Despatch buffer assigned
2. Staging Lane assigned 
3. Ecomm and is chilled/ambient from storage highbay - they go directly to marshalling from storage highbay
4. Order is PURGE - they go to an outfeed and then drop loc 

### 3.1.6. Despatch Manager

#### 3.1.6.1. Check Marshalling

##### 3.1.6.1.1. Marshalling Area

If the destinated Ambient Despatch Buffer aisle become LTOS, WCS will de-assign associated load if no pallet is in the buffer or reaching Monorail. WCS will need urgently assign the load to different Despatch Buffer with most space if pallets had been picked.

If the pallet is picked in the manual area, WCS will need to check whether it’s still suitable for automated despatch (if the infeed from manual picking is set out of service, then it won’t be). At this point the despatch buffer is unassigned and a despatch staging location then a pre-picked staging location is tried to be selected. If none is found, then WCS raises an alert and continues to try to assign one. If the picker has already started the pick run they are instead directed to the generic drop location to temporarily store the pallet before staging.

  

##### 3.1.6.1.2. Marshalling Lane Group

WCS will auto de-assign the next(un-started) load if equipment failure cause incorrect number of availed Ambient and Non-Ambient lanes associated with MLG. The de-assigned load will be assigned to next available MLG within the same Marshalling Area as it should have highest priority.

WCS provides action on OMW to manually assign, de-assign or change MLG before load is released for marshalling. If this load is assigned to a MLG already has loads, the un-started load will be auto de-assigned.

WCS will also auto de-assign MLG if Marshalling Area has been changed (LTOS or manual change). 

Except above mentioned, WCS will not auto de-assign MLG in any other situation to avoid ripple effect.

  

#### 3.1.6.2. Despatch Buffer Allocation

Host sends LoadRoute message which creates Load on WCS.

**Hub / Ecomm**

As Ecom/Hub orders are delivered to Inbound area while Replen orders go to Outbound area, WCS will reject the the LoadRoute message if Ecom/Hub orders are mixed with Replen orders on the same load. 

These order types don't get a despatch buffer allocated.

**Replen / New Store**

WCS assigns DUs to a ASRS **Despatch Buffer**s in all 4 chambers for pallets which are suitable for automated despatch when the DU is ready for despatch buffer allocation. 

The assignment and picking process in 4 temperature chambers is done independently when destination have space. Ambient doesn’t have to be done first.

There are 10 Ambient Despatch Buffers each associated with one ASRS aisle and it only suitable for assignment if associated Marshalling Area is OPEN.

The Chilled, Freezer and TMC chamber each has one Despatch Buffer which has one or multiple ASRS aisles. Destinated Despatch Buffer must have enough space (TotalLocs – OccupiedLocs – IncomingPlts) for all DD pallets of the matching temperature of the Load to allow assignment. (Note, DUs not suitable for automated despatch buffer will go to staging location afterwards instead ASRS despatch, so they will be excluded from the count.)

WCS will allocate a corresponding despatch buffer to the DU up to set parameters

- _DESPATCH_BUFFER_MAX_FILL_PRCNT_ (90-95% of the total despatch buffer locations) to allow for any mop up pallets generated by palletising.
- _DESPATCH_BUFFER_NON_URGENT_MAX_FILL_PRCNT_ (60/70/80%?) for any loads which are not within a URGENT_LOAD_PRORITY_WINDOW mins of the despatch time of a route load. This can be set to match the other parameter if the host will ensure strict sequencing of route loads to WCS.

WCS prefers the Despatch Buffer with most available space. If the available space is equal, the Despatch Buffer with least number of loads is preferred. 

Assignment is strictly based on the priority. At this stage, the priority is calculated from ShipTime. WCS will not assign lower priority load even it can fit in the buffer due to smaller size.

Assigning highest priority Load to the Buffer with most space will ensure despatch times evenly distributed across the buffers. Note, opening a new buffer will cause the uneven distribution for a few loads initially.

WCS does not allow more than _DESPATCH_BUFFER_MAX_SAME_DESPATCH_TIME_ROUTE_LOADS_ loads within same despatch time range (configurable _DESPATCH_BUFFER_MAX_SAME_DESPATCH_TIME_RANGE_e.g. 15 minutes ) assigned to the same Ambient Despatch Buffer. WCS will spread Loads by despatch time across Despatch Buffers evenly, so loads of same despatch time in same buffer will hardly ever happen. Only time it can happen is when a MarshallingArea was Closed for a few days then re-opened. The next priority load will wait to be assigned to other buffer. Please be aware that sometimes a deadlock can happen when only 1 MarshallingArea is open.

**Add a NONDB field on Load to display “Can’t Assign Str“ and add alert/alarm if it’s a blocker.**

Completion of the assignment to Despatch Buffer will release load for picking in that temperature chamber. 

Assigning a Ambient Despatch Buffer will automatically assign the associated outbound **_Marshalling Area_** to the load. If a Load has no Ambient DDP pallets, Marshalling Area will not be assigned later.

  

#### 3.1.6.3. Staging Lane Allocation Despatch

Picking of pallets destined for despatch staging in all temperature chambers can start after reaching **_RELEASE_FOR_STAGING_DESPATCH_PICKING _WINDOW_**.

Pallets in Replen/NewStore load will move towards Outbound Marshalling Area to meet up with other DDPs.

Pallets in Ecom/Hub load will move toward Inbound Marshalling Area. Unless Ambient or Chilled Storage Highbay stock which go directly to marshalling from highbay.

There are 8 Staging Lane Groups used to buffer pallets for despatch, one per temperature chamber per inbound vs outbound. Those Staging Lane Groups are linked with Staging Despatch Buffer.

For DUs not going directly to Ecom/Hub outfeed, they must be assigned to Staging Locations in each chamber to allow Picking (Case Picking, Full Pallet Picking and ASRS Retrieval). The rules are:

- Inbound vs Outbound matches
- Staging Location usage is for Despatch.
- Temperature matches
- Each Staging Location’s capacity is configurable which means multiple DUs can be assigned but they must belong to the same load. WCS always assign DU to a location already for the same load and only move onto to new location if all other locations of the same load are full.
- Assign DUs of Highest Priority Load first. Within the same Load assign highest priority DU first.
- WCS configure Sequence on location for assignment purpose?

  

#### 3.1.6.4. Staging Lane Allocation Pre-Picking - CP040 approved now

The DUs suitable for automated despatch buffer which require manual picking can start prepicking when reaching **_RELEASE_FOR_STAGING_PREPICKING_WINDOW,_** even though ASRS Despatch Buffer doesn’t have enough space for the load.

WCS can assign DUs which are suitable for automated despatch buffer and are manually picked pallets (exclude Topup pallet and Full pallet picking DPs) to staging locations first so picked pallet have got somewhere to go. Those staging locations are not associated with a Staging Lanes for despatch.

DU assignment follows below rules:

- Temperature matches
- Staging Location usage is for Pre-picking.
- Each Staging Location’s capacity is configurable which means multiple DUs can be assigned but they must belong to the same load. WCS always assign DU to a location already for the same load and only move onto to new location if all other locations of the same load are fully assigned.

The background process on WCS will monitor the space in ASRS Despatch Buffer and transfer the assignment whenever possible. E.g. When operator started picking, the DU is pointed to StagingLoc, but after 30 minutes’ of picking, the space in ASRS buffer becomes available to fit the whole load, WCS will transfer the assignment to Despatch Buffer. At the end of picking, WCS will instruct the picker to drop off at conveyor induct.

Tramming is required to move DDP at Staging to Conveyor Infeed after assignment transferred to ASRS Despatch Buffer.

  

#### 3.1.6.5. Allocate Marshalling Area

Route loads going to the outbound area (replen/new store) with Ambient pallets have their marshalling area set on the first DU to be allocated to a despatch buffer.

Route loads without Ambient pallets have the marshalling area assigned when within **_RELEASE_FOR_MARSHALLING_DESPATCH_WINDOW_**

- For Load going towards Outbound, an OPEN Marshalling Area with least number of Loads is assigned. If number of loads is the same, prefer area with most available Manual Marshalling Lanes. WCS does not allow more than _DESPATCH_BUFFER_MAX_SAME_DESPATCH_TIME_ROUTE_LOADS_ loads within same despatch time range being assigned to the same Marshalling Area

- For Load going towards Inbound, the one and only inbound Marshalling Area **_MA-01-IB_** is assigned. Its dummy MLG **_MLG-01-MAN-01_** is also assigned.

  

#### 3.1.6.6. Allocate Load to Marshalling Lane Group

WCS will assign MLG after Load has a Marshalling Area and within Despatch Window: **_RELEASE_FOR_MARSHALLING_DESPATCH_WINDOW_**.

WCS will look for the next highest priority route load for the marshalling area, excluding any route loads where all the DUs are flagged with PreventShipping as TRUE (These are skipped until they are unheld and then they will be the highest priority route load to be allocated again when the MHE is fixed).

Assignment to MLG within the same Marshalling Area is strictly based on ShipTime. When 2 loads have the same ShipTime, WCS prefer the load with earlier ReleasedTime (1st temperature).

The MLG must meet below condition to be suitable for assignment:

- At least 1 available Ambient and 1 available Non-Ambient Lane configured.
- Either has no load assigned, or previous load has been fully marshalled or started loading. So maximum 2 loads per MLG
- When assigning a Load to a MLG already has a Load, the despatch time difference should not be less than a configurable value **_ASSIGN_SAME_MLG_MIN_DESPATCH_GAP_** (e.g. 100 mins), unless the load already assigned to the marshalling lane group is the one with the greatest gap to this load

WCS then assigns a suitable MLG within the Marshalling Area to Load base below rules:

- Prefer Empty MLG
- Prefer Previous load with highest priority.
- Prefer 3 Lanes MLG over 2 Lanes MLG (1 lane with equipment failure)

Note, DUs not suitable for automated despatch will have a dummy MLG assigned.

_**WCS sends EstimatedContainers message with planningStage=ASSIGNED to host when MLG is initially assigned.**_

  

#### 3.1.6.7. Allocate Manual Marshalling Lanes

WCS assigns the next highest priority load within a marshalling area which has DUs requiring manual marshalling and is within despatch window **_RELEASE_FOR_MARSHALLING_DESPATCH_WINDOW_**

Ready for allocation as long as the temperature has been released if not ambient.

The rules to allocate are

- The Lane must belong to the Marshalling area already assigned to load
- Lane Temperature Type (Ambient, NonAmbient or Mixed) matches. In NonAmbient and Mixed lane, different temperature DUs can be assigned in the same lane.

- Lane‘s capacity is configurable which means multiple DUs can be assigned but they must belong to the same load. WCS always assign DU to a lane already for the same load and only move onto to new location if all other locations of the same load are full.
- Assign DUs of Highest Priority Load first. Within the same Load assign highest priority DU first. Note the priority of DU is based on ReleaseTime of different temperature then Reverse DropSeq.

## 3.2. Data design

### 3.2.1. Database schema

Key fields and the tables they are in

### 3.2.2. Data flow

Flow of data through the db

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

## 3.9. Use Cases

See [2306 TD: Despatch Buffer & Marshalling Use Cases](https://wiki.dematic.net/spaces/MP/pages/922455979/2306+TD+Despatch+Buffer+Marshalling+Use+Cases).

# 4. Open Issues

# 5. Risk Registe