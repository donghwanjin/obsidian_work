# 1. Overview

## 1.1. Name

## 1.2. Objective

## 1.3. Scope

## 1.4. Assumptions

## 1.5. Dependencies

## 1.6. Glossary of terms

# 2. Functional Requirements

## 2.1. Input

## 2.2. Output

## 2.3. Logic

## 2.4. Error handling

# 3. Technical Design

Please refer to the FMCF reference system page initially: [FMCF-RS TD: Highbay](https://wiki.dematic.net/spaces/MP/pages/861932406/FMCF-RS+TD+Highbay)

## 3.1. Component design

### 3.1.1. Purpose

### 3.1.2. Interfaces

### 3.1.3. Data structures

### 3.1.4. Algorithms

#### 3.1.4.1. Highbay Aisle Selection

The highbay aisle selection is handled by "MH_PC_HIGHBAY_FMCF_SelectAisle()" using the following strategies:

| Highbay Group       | Aisles  | Decision point(s)            | Strategy                                                               |
| ------------------- | ------- | ---------------------------- | ---------------------------------------------------------------------- |
| HB-AMBIENT          | 1 - 9   | MRMR11DP01                   | ROUND ROBIN SKIP FULLEST                                               |
| HB-CHILLED          | 61 - 66 | PCCHDEDP06<br><br>PCCHDEDP02 |                                                                        |
| HB-FROZEN           | 41 - 42 | PCRE03HBLS<br><br>PCFRDECC02 |                                                                        |
| HB-TMC              | 21 - 22 | PCRE03HBLS                   |                                                                        |
| HB-DESPATCH FROZEN  | 43      | PCFRZ0CC01                   |                                                                        |
| HB-OUTBOUND AMBIENT | 81 - 90 | MRMR81DP81-90                |                                                                        |
| HB-DESPATCH CHILLED | 67 - 70 | PCAI67BP02<br><br>PCAI67HB02 | MOST CAPACITY<br><br>(or PICK STN LEAST IN TRANSIT for "pass through") |
| HB-DESPATCH TMC     | 23 - 24 | PCTMC0BP23                   |                                                                        |

See also: [Routing-Selecteddestinationdecisionpoints](https://wiki.dematic.net/spaces/MP/pages/898095568/2306+TD+Highbay#)

##### 3.1.4.1.1. Chilled/TMC despatch buffer aisle selection

New strategy to MH_RBG_DCI_FMCF_AISLE_SELECTION_STRATEGY_TYPE: MH_RBG_DCI_FMCF_AISLE_SELECTION_STRATEGY_MOST_CAPACITY. This is applied to the chilled and TMC despatch buffers. The strategy is described in the simulation report:

> _If this is the first pallet of a pair, then this pallet is diverted to the aisle with the most capacity. The capacity of an aisle is calculated by adding together the number of pallets currently in the aisle and the number of pallets on the conveyor enroute to the aisle._
> 
> _If there has been a single pallet previously, then this makes the second of a pair and is diverted to the same aisle and is stored alongside the first pallet in the same bay._

The strategy applies to the following decision points:

- Chilled aisles 67-70: PCAI67BP02 and PCAI67HB02
- TMC aisles 23-24: PCTMC0BP23

Following TUEX in chilled, the aisle selection will also occur at the blockade points only considering downstream aisles.

Following TUEX at PCTMC0BP24 (TMC), the pallet (and paired pallet) can be re-circulated via the QA station. Recirculation is not possible for chilled.

##### 3.1.4.1.2. Chilled - route from L2 to PQA-CHL-OUT via highbay crane

If the pallet is on L2 in chilled outbound area (PLC 4203), and the final destination is PQA-CHL-OUT, then the aisle should be selected based purely on the transit queue to the pick station, not on the capacity of the aisle.

The pallet will "pass through", meaning that the mission will be direct from the pick station to the drop station.

For these pallets, strategy "MH_RBG_DCI_FMCF_AISLE_SELECTION_STRATEGY_PICK_STN_LEAST_IN_TRANSIT" is used.

##### 3.1.4.1.3. Paired DUs and despatch buffer aisle selection

When selecting highbay aisles in MH_PC_HIGHBAY_SelectAisle / MH_PC_HIGHBAY_FMCF_SelectAisle, check if the TM is a DU which is paired with another.  If so, and the other pallet has a highbay aisle selected, choose that aisle if it is possible.

#### 3.1.4.2. Highbay Location Selection

For TMC, frozen and chilled despatch buffers, we need to check if the TMs in a putaway tour are paired.  A number of weighting parameters are needed to optimise the putaway behaviour.

- HIGHBAY_LOC_SELECT_PAIRING_WEIGHT - default 200,000.
- HIGHBAY_LOC_SELECT_UNPAIRED_WEIGHT - default 100,000.

These weightings are applied for a location following the pairing logic defined below.

In HIGHBAY_LOC_SelectLocation, for DUs we first need to calculate the pairing type:

- NEW_PAIR - the TM is in a pair, and the other TM in the pair doesn't yet have a selected destination in the appropriate highbay aisle.  In this case, we will apply the pairing weight to a location where the PairedLocRecNo is available and can be used to store the pallet on the other LHD.  Note that generally LH11 will serve the odd bay numbers and LH21 will serve the even bay numbers.  This weighting should only be applied to the appropriate bays - LH11 storing to bay 10 and LH12 storing to bay 9 is not a valid paired movement.
- STORED_PAIR - the TM is in a pair, and the other TM is either already stored or has a selected destination in the highbay aisle.  This should be the calculated pairing type when calculating the second TM for a pair being putaway together.  In this case we will apply the pairing weight ONLY to the PairedLocRecNo attached to the other TMs highbay location.  We will apply the unpaired weight to all locations unsuitable for pairing (because the location's PairedLocRecNo is unavailable for storage, or contains an unpaired TmRecNo).
- UNPAIRED - the TM is not part of a pair.  Apply the pairing weight to any location where the PairedLocRecNo contains a TM which is currently unpaired, but _could_ be built into a pair with this TM.  We will apply the unpaired weight to all locations unsuitable for pairing (because the location's PairedLocRecNo is unavailable for storage, or contains an unpaired TmRecNo).

After selection of a location for an UNPAIRED TM, we should then create the PAIR_DU_REC_TYPE and add the two TMs.

For system pallet stacks we can't use the PAIR_DU_REC_TYPE structure.  We can check a pseudo-pair status by checking the TM on the 'other' pick station position.  If this is also a pallet stack, and it doesn't already have a highbay loc destination, treat this as a NEW_PAIR.  If it is a pallet stack with a destination already selected, this is a STORED_PAIR.  If there is no pallet stack this is UNPAIRED.

#### 3.1.4.3. Highbay Retrievals

mh_rbg_dci_scheduler.c → GenerateRetrievalTourMoves is responsible for setting up tours out of the highbay.  For TMC, frozen and chilled despatch buffers, we need to generate paired retrieval tours.  Once the RetrievalLhdPtr for the first move has been set up, if we are in the aisles for those despatch buffers:

- Check if the selected TM is part of a pair.  If so, iterate through the remainder of the move chain, looking for the move for it's paired TM.  If found, re-order the chain and set that TM as the new StartPtr.  Ensure we're not leaving hanging pointers here - we can't just reset the StartPtr!
- Except for the paired TM, remove all other moves which ARE part of a pair from the list.

The intended behaviour is whenever the top priority move is part of a pair, we move that pair together.  If the top priority move is unpaired, we will only allow moving it with another unpaired TM.  If only 1 unpaired TM is ready to move, we will therefore move that TM in a tour by itself.

If we have selected two unpaired TMs, consider whether those can now be paired.

## 3.2. Data design

### 3.2.1. Highbay layout

#### 3.2.1.1. Highbay aisles and location

| Storage Zone           | Highbay Aisles       | Highbay Locs                                                                                                | Height classes                                                                  | Notes                                                                                                                  |
| ---------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Configure via MDS      | HIGHBAY_AISLE_Exists | HIGHBAY_LOC_Exists                                                                                          |                                                                                 |                                                                                                                        |
| **SZ-AMB-HIGHBAY**     | - Aisles: 1 - 7      | - Max levels: 14<br>- Max bays: 64<br>- Pos is always 1<br>- Depth is double-deep                           | - Levels 1, 12-14: 2200<br>- Levels 2-3, 5, 9-11: 1650<br>- Levels 4, 6-8: 1200 |                                                                                                                        |
| **SZ-TMC-AMB-HIGHBAY** | - Aisles: 8 - 9      | - Max levels: 14<br>- Max bays: 64<br>- Pos is always 1<br>- Depth is double-deep                           | - Levels 1, 12-14: 2200<br>- Levels 2-3, 5, 9-11: 1650<br>- Levels 4, 6-8: 1200 | Products which are suitable for this aisle are:<br><br>1. Storage Class == AMBIENT<br>2. Temperature Sensitive == TRUE |
| **SZ-TMC-HIGHBAY**     | - Aisles: 21 - 22    | - Max levels: 8<br>- Max bays: 48 (24 bays, 2 slots per bay)<br>- Pos is always 1<br>- Depth is single-deep | - Levels 1-8: 1650                                                              |                                                                                                                        |
| **SZ-FRZ-HIGHBAY**     | - Aisles: 41 - 42    | - Max levels: 9<br>- Max bays: 52<br>- Pos is always 1<br>- Depth is double-deep                            | - Level 1, 9: 1650<br>- Levels 2-8: 1200                                        |                                                                                                                        |
| **SZ-CHL-HIGHBAY**     | - Aisles 61 - 66     | - Max levels: 14<br>- Max bays: 30<br>- Pos is always 1<br>- Depth is double-deep                           | - Levels 1, 12-14: 2200<br>- Levels 2-3, 5, 9-11: 1650<br>- Levels 4, 6-8: 1200 |                                                                                                                        |

| Despatch Buffer                                  | Highbay Aisles                                                                                           | Highbay Locs                                                                                                                                 | Height classes       | Notes                                                                                                                  |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Configure via MDS                                | HIGHBAY_AISLE_Exists                                                                                     | HIGHBAY_LOC_Exists                                                                                                                           |                      |                                                                                                                        |
| **DBF-AMB81-OB  <br>..  <br>DBF-AMB90-OB  <br>** | - Aisles: 81 - 90<br>- Note - for these, the Despatch Buffer ↔ Highbay Aisle relationship should be 1-1. | - Max levels: 8<br>- Max bays: 12 (6 bays, 2 slots per bay)<br>- Pos is always 1<br>- Depth is single deep<br>- Maximum pallet load: 1000KG  | - Levels 1 - 8: 2000 | These are distinct Despatch Buffer entities, each linked to a single Highbay Aisle.                                    |
| **DBF-TMC-OB**                                   | - Aisles: 23 - 24                                                                                        | - Max levels: 7<br>- Max bays: 14 (7 bays, 2 slots per bay)<br>- Pos is always 1<br>- Depth is single deep<br>- Maximum pallet load: 1000KG  | - Levels 1 - 7: 2000 | Products which are suitable for this aisle are:<br><br>1. Storage Class == AMBIENT<br>2. Temperature Sensitive == TRUE |
| **DBF-FRZ-OB**                                   | - Aisles: 43                                                                                             | - Max levels: 7<br>- Max bays: 16 (8 bays, 2 slots per bay)<br>- Pos is always 1<br>- Depth is single deep<br>- Maximum pallet load: 1000KG  | - Levels 1 - 7: 2000 |                                                                                                                        |
| **DBF-CHL-OB**                                   | - Aisles 67 - 70                                                                                         | - Max levels: 7<br>- Max bays: 24 (12 bays, 2 slots per bay)<br>- Pos is always 1<br>- Depth is single deep<br>- Maximum pallet load: 1000KG | - Levels 1 - 7: 2000 |                                                                                                                        |


#### 3.2.1.2. Highbay Location Pairing

The TMC, freezer, and chilled despatch buffers are made up of fixed location pairs which are used together whenever possible.  The paired locations are the 2 slots in a 'physical bay' (i.e. between the rack uprights) on the same aisle, level and side.  The WCS doesn't track the physical bays - the 'Bay' field in WCS is just the slot number.  So the location pairs are just the WCS bay numbers (1, 2), (3, 4), (5, 6) ...

Highbay locations need an extra location 'PairedLocRecNo' which points to the paired location in the bay.  This will be used by the location selection logic described in the Algorithms section.  It should be set up in the HIGHBAY_LOC_PostStartup, and set to NULL_REC_NO for highbay locations that are not in the relevant despatch buffers.

#### 3.2.1.3. Crane and conveyor locations

|   |   |   |   |   |   |
|---|---|---|---|---|---|
|Aisle range|Cranes|Pick stations|Drop stations|Weight Restrictions|Miscellaneous|
||MH_RBG_DCI_LhdLocExists<br><br>MH_RBG_DCI_DS_LhdAndPosToDsPos|MH_RBG_DCI_PsExists|MH_RBG_DCI_DsExists||highbay_dci_fmcf_rs.plugin|
|1 - 9|- Pos: MH_RBG_LHD_POS_CENTRE<br>- LhdType: MH_RBG_LHD_TYPE_SINGLE_LOAD<br><br>- Pos: MH_RBG_LHD_POS_CENTRE<br>- LhdType: MH_RBG_LHD_TYPE_SINGLE_LOAD|- Group 11:<br>    - Left side<br>    - DC Level 1<br>    - Max In Transit: 9|- Group 11:<br>    - Right side<br>    - DC Level 1|- Maximum LHD load: 2400KG|- MH_RBG_IO_GROUP_TYPE<br>    - 11<br>    - 12<br>- HIGHBAY_LHD_MAX = 2<br>- HB_CONV_MAX_TMS = 2<br>- HB_CONV_POS_MIN = 1<br>- HIGHBAY_GROUP_MAX_NUM_DIGITS = 2<br>- HBDS_GROUP_MIN = 11<br>- HBDS_GROUP_MAX = 11<br>- HBPS_GROUP_MIN = 11<br>- HBPS_GROUP_MAX = 12<br>- HIGHBAY_CRANE_PICKUP_LEVEL_DEFAULT = 1<br>- HIGHBAY_CRANE_DROPDOWN_LEVEL_DEFAULT= 1<br><br>  <br>**TBC: Pickup and Dropdown rack-levels.**|
|21 - 22|- Group 11<br>    - Right side<br>    - DC level 0<br>    - Max In Transit: 5<br>- Group 22<br>    - Left side<br>    - DC level 1<br>    - Max In Transit:<br>        - Aisle 21: 9<br>        - Aisle 22: 5<br>- Group 31:<br>    - DC level 0<br>    - Max In Transit: 5<br>    - Aisle 21:<br>        - Left side<br>    - Aisle 22:<br>        - Right side|- Group 11<br>    - Left side<br>    - DC level 0<br>- Group 12<br>    - Right side<br>    - DC level 1<br>- Group 31:<br>    - DC level 0<br>    - Aisle 21:<br>        - Left side<br>    - Aisle 22:<br>        - Right side|- Maximum LHD load: 2400KG|Group 31 is the "IAT" between the two aisles, which is a pick/drop station on DC level 0.<br><br>- MH_RBG_IO_GROUP_TYPE<br>    - 11<br>    - 12<br>    - 22<br>    - 31<br>- HIGHBAY_LHD_MAX = 2<br>- HB_CONV_MAX_TMS = 2<br>- HB_CONV_POS_MIN = 1<br>- HIGHBAY_GROUP_MAX_NUM_DIGITS = 2<br>- HBDS_GROUP_MIN = 11<br>- HBDS_GROUP_MAX = 31<br>- HBPS_GROUP_MIN = 11<br>- HBPS_GROUP_MAX = 31<br>- HIGHBAY_CRANE_PICKUP_LEVEL_DEFAULT = 1<br>- HIGHBAY_CRANE_DROPDOWN_LEVEL_DEFAULT= 1|
|23 - 24|- Group 11:<br>    - Left side<br>    - DC Level 0<br>    - Max In Transit: 6|- Group 11:<br>    - Right side<br>    - DC Level 1|- Maximum LHD load: 2000KG|(same as aisle 1-9)|
|41 - 42|- Group 11:<br>    - Left side<br>    - Level 1<br>    - Max In Transit: 11<br><br>- Group 12:<br>    - Left side<br>    - Level 1<br>    - Max In Transit: 15|- Group 11:<br>    - Right side<br>    - Level 1|- Maximum LHD load: 2400KG|
|43|- Group 11:<br>    - Left side<br>    - DC Level 0<br>    - Max In Transit: 10<br>- Group 12:<br>    - Left side<br>    - DC Level 1<br>    - Max In Transit: 10|- Group 11:<br>    - Right side<br>    - DC Level 0  <br>          <br>        <br>- Group 12:<br>    - Right side<br>    - DC Level 1|- Maximum LHD load: 2000KG|
|61 - 66|- Group 11:<br>    - Left side<br>    - Level 1<br>    - Max In Transit: 7|- Group 11:<br>    - Right side<br>    - Level 1|- Maximum LHD load: 2400KG|
|67 - 70|- Group 11:<br>    - Left side<br>    - DC Level 2<br>    - Max In Transit: 11|- Group 11:<br>    - Right side<br>    - DC Level 1|- Maximum LHD load: 2000KG|
|81 - 90|- Group 11, 21, 31, 41:<br>    - Right side.<br>    - Single LHD.<br>    - DC Level 1<br>    - Max In Transit: 4|N/A (these Outbound Despatch Buffers do not have Drop Stations).<br><br>Instead, particular locations (physically linked to gravity lanes) are linked to corresponding Marshalling Lanes.  <br>  <br>When a TURP is received confirming the drop of a pallet in the linked location, WCS moves it to the mapped Marshalling Lane.|- Maximum LHD load: 1000KG|- MH_RBG_IO_GROUP_TYPE<br>    - 11<br>    - 21<br>    - 31<br>    - 41<br>- HIGHBAY_LHD_MAX = 1<br>- HB_CONV_MAX_TMS = 2<br>- HB_CONV_POS_MIN = 1<br>- HIGHBAY_GROUP_MAX_NUM_DIGITS = 2<br>- HBDS_GROUP_MIN = N/A<br>- HBDS_GROUP_MAX = N/A<br>- HBPS_GROUP_MIN = 11<br>- HBPS_GROUP_MAX = 41<br>- HIGHBAY_CRANE_PICKUP_LEVEL_MAX = 1<br>- HIGHBAY_CRANE_DROPDOWN_LEVEL_MAX = 1<br>- **TBC: Pickup and Dropdown rack-levels.**|

### 3.2.2. Database schema

#### 3.2.2.1. Milk SKUs

Milk skus need to be kept on level 1 in the highbay. This effects all milk skus not just ones flagged for milk crate picking. This logic is based on Sub Commodity Group field Milk.

Product Hierarchy should have a field of Milk which drives this functionality.

Changing this after a pallet has been stored has no effect on the current stock, it only effects the decision on the next time it happens. 

### 3.2.3. Data flow

Flow of data through the db

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

# 4. Open Issues

# 5. Risk Register