---
type: project
tags:
  - project
project: Aldi Vic
---

### Git
[https://gitlab.com/dematic/matflo/matflo-c/aldi/aldi-victoria-2306-wcs](https://gitlab.com/dematic/matflo/matflo-c/aldi/aldi-victoria-2306-wcs "https://gitlab.com/dematic/matflo/matflo-c/aldi/aldi-victoria-2306-wcs")

### Wiki
[[2306_TechnicalDesign]]
[[FMCF]]
### Jira

[P2306 Aldi Victoria - Dematic Global JIRA](https://jira.dematic.net/projects/P2306/summary)

[[https://wiki.dematic.net/spaces/MP/pages/907118888/2306+-+Defect+Reporting+Process#id-2306DefectReportingProcess-StandardDefectReportingTemplate|Jira guideline]]


TMC ( temperature monitoring control )
- Banana one of biggest sku
- Pineapple

### question

- [x] Contour W is triggered when the weight is below the minimum or above the maximum limit via PLC....have we define that value? ✅ 2025-10-21
 >**Answer:** ask controls to set Max : 2200 and Min : 0


- [x] is WCS monitoring actual temp and humidity? ✅ 2025-10-17
 >**Answer:** just time outside of the wrong chamber, defined by different conveyor points etc
> **Answer:** the building will handle that. the controls system will log the temp/RH in scada so we can attribute faults etc if needed
### DCI

- Unknowns on Monorail/Pallet Conveyor
1. If the location we get an unknown tu type (????) in has just 1 default route WCS uses that
2. If it's got multiple then WCS won't reply
3. PLC to send known TU type for all locations which there is only a single type? - EG PCAMB1HB13 - (to be confirmed)
4. Monorail - WCS will route unknown Tu Type From PS to DP but never onwards from a DP. ECS to handle unknowns from then. 
5. Unknowns going through the crane will need to be identified by the PLC in the ambient highbay crane - (to be confirmed and spec update needed)

#### DMS replen
[[Replen Algorithms]]

https://wiki.dematic.net/spaces/MP/pages/853113358/FMCF-RS+TD+System+Configuration#FMCFRSTD%3ASystemConfiguration-TmSubTypeconfiguration

| Tm Sub Type ID          | Type       | Depth | Width | Height | Max Height | Packbuilder Overhang width/length | Empty Weight | Max Weight | DCI TuType                      | Barcode Length | Barcode Prefix | Notes                                                                                                                                                                                                                                                                                                                                                           |
| ----------------------- | ---------- | ----- | ----- | ------ | ---------- | --------------------------------- | ------------ | ---------- | ------------------------------- | -------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **AUS Pallet**          | Pallet     | 1165  | 1165  | 150    | 2200       | 50/50                             | 35000        | 1250000    | AU01                            | 20             | 00             |                                                                                                                                                                                                                                                                                                                                                                 |
| **AUS Pallet Stack**    | Pallet     | 1165  | 1165  | 1500   | 2200       |                                   | 35000        | 1250000    | AU99                            |                |                | This is the AUP Mixed stack type from aldi victoria                                                                                                                                                                                                                                                                                                             |
| **TRL1**                | Tray       | 700   | 500   | 55     | 428        |                                   | 2000         | 30000      | TRL1                            | 8              | 1,2,3          |                                                                                                                                                                                                                                                                                                                                                                 |
| **TRL1 Stack**          | As TRL1    |       |       |        | 418        |                                   | 24000        | As TRL1    | TRL9<br><br>(TRL1 to detraying) | As TRL1        |                | Tray stacks are just tracked by the tray ID. The PLC scans the 2nd from bottom tray to make sure it's a stack, but only the bottom tray barcode is reported, along with the TU Type                                                                                                                                                                             |
| **Stock Case**          | Case       |       |       |        |            |                                   |              |            | CS01                            | 22             | P              | Rapidpal 2024 Spec<br><br>  <br>P<pp>T<ttttttttttt>R<rrrr><nn><br><br><pp>: the palletizer number (01-99)<br><br><ttttttttttt>: 11-digit tray barcode<br><br><rrrr>: recurring number to distinguish the detraying processes originating from the same source tray.<br><br><nn>: running number starting with 1 and being incremented for each decremented case |
| **Plastic Waste Bin**   | Pallet     | 1265  | 1165  | 1600   |            |                                   |              | 1250       | AU50                            | 20             | 06             | Waste Bin for Plastic Waste                                                                                                                                                                                                                                                                                                                                     |
| **Cardboard Waste Bin** | Pallet     | 1265  | 1165  | 1600   |            |                                   |              | 1250       | AU50                            | 20             | 05             | Waste Bin for Carboard waste                                                                                                                                                                                                                                                                                                                                    |
| **DCI DUMMY**           | DCI UKNOWN |       |       |        |            |                                   |              |            |                                 |                |                |                                                                                                                                                                                                                                                                                                                                                                 |
| **DCI NOREAD**          | DCI UKNOWN |       |       |        |            |                                   |              |            |                                 |                | NR             |                                                                                                                                                                                                                                                                                                                                                                 |
| **DCI MULTI READ**      | DCI UKNOWN |       |       |        |            |                                   |              |            |                                 |                | MR             |                                                                                                                                                                                                                                                                                                                                                                 |
| **DCI UNKNOWN**         | DCI UKNOWN |       |       |        |            |                                   |              |            |                                 |                | UF             |                                                                                                                                                                                                                                                                                                                                                                 |
| **DCI DUPLICATE**       | DCI UKNOWN |       |       |        |            |                                   |              |            |                                 |                | DR             |                                                                                                                                                                                                                                                                                                                                                                 |

#### Contour

| **Contour Byte** | **Description**                                                                                                                                                                                                                    |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1                | “F” = Fault front length, “.” = no fault                                                                                                                                                                                           |
| 2                | “B” = Fault back length, “.” = no fault                                                                                                                                                                                            |
| 3                | “R” = Fault width right, “.” = no fault                                                                                                                                                                                            |
| 4                | “L” = Fault width left, “.” = no fault                                                                                                                                                                                             |
| 5                | “H” = Fault height, “.” = no fault                                                                                                                                                                                                 |
| 6                | “S” = Fault fork space, “.” = no fault, “X” = Type B                                                                                                                                                                               |
| 7                | “U” = Fault runner, “.” = no fault, “Y” = Type B                                                                                                                                                                                   |
| 8                | “W” = Fault weight, “.” = no fault                                                                                                                                                                                                 |
| 9                | “N” = Fault No Read, “.” = no fault                                                                                                                                                                                                |
| 10               | “T” = Fault wrong TU number, “.” = no fault                                                                                                                                                                                        |
| 11               | “M” = Multiple barcodes, “.” = no fault                                                                                                                                                                                            |
| 12               | “P” = Unsuccessful Wrap or Label application, “.” = no fault                                                                                                                                                                       |
| 13 - 14          | Contour faults sent by WCS with a TUMI message:<br><br>“01” = General reject<br><br>“02” = Bin occupied<br><br>“03” = No read<br><br>“04” = Height bin<br><br>“05” = Weight<br><br>“06” = No TU data<br><br>“07” = Wrong TU number |
Different to the Global specification and previous projects, Contour Byte 6 and 7 are also to be used to signify a ‘Type B’ pallet where there is not enough detection to outright reject the pallet, but a small level of inconsistency was detected. In this scenario the default letters of Byte 6 will be “X” and for Byte 7 “Y”.

Type B pallets are then to be stored on the lower levels of ASRS. TBC
#### TUID
**NNNNNNPYYMMDDHHIISSLLL**

| **Item** | **Datatype**  | **Length** | **Description**                                                |
| -------- | ------------- | ---------- | -------------------------------------------------------------- |
| NNNNNN   | Alpha Numeric | 6          | Physical Equipment Id where this TUid is originally generated. |
| P        | Numeric       | 1          | Position on physical equipment                                 |
| YY       | Numeric       | 2          | Last two digits of the year                                    |
| MM       | Numeric       | 2          | Month                                                          |
| DD       | Numeric       | 2          | Day                                                            |
| HH       | Numeric       | 2          | Hour                                                           |
| II       | Numeric       | 2          | Minute                                                         |
| SS       | Numeric       | 2          | Second                                                         |
| LLL      | Numeric       | 3          | Millisecond                                                    |

**UF-<'pppp'>-<'nnnnnn'>** (18 bytes) where:

<'pppp'> = Unique control cabinet number

<'nnnnnn'> = Running number (1 - 999999)

UF - unkown 
NR - No read
MR - Multiple read
### High bay

| Height Class | Pallet Maximum Height |   Applicable High Bay    |
| :----------: | :-------------------: | :----------------------: |
|      1       |         1200          | Ambient, Chilled, Frozen |
|      2       |         1650          |           All            |
|      3       |         2200          |     Ambient, Chilled     |

| **Aisles** | **Levels** | **Bays** | **Storage Depth**             | **Bay Width (Pallets)** | **Total Positions**                                                                                    | **Pallets Stored**                      | **Occupancy**                               |
| ---------- | ---------- | -------- | ----------------------------- | ----------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------- | ------------------------------------------- |
| 10         | 14         | 32       | 2 AUP<br><br>Or<br><br>3 DDPs | 2                       | 35,840 AUP’s<br><br>Or<br><br>53,760 DDP’s<br><br>Nominal Split:<br><br>27,168 AUPs<br><br>13,007 DDPs | 24,995 AUPs<br><br>+<br><br>11,056 DDPs | 92% (AUP)<br><br>85% (DDP)<br><br>90% (Avg) |

|                 | **Required Throughput**<br><br>**(PPH)** |         | **Required Cycles**<br><br>**(Cycles/ Hr)** |         |              | **FEM 9.851 Cycle times**<br><br>**(sec)** |         |              | **Utilisation** |
| --------------- | ---------------------------------------- | ------- | ------------------------------------------- | ------- | ------------ | ------------------------------------------ | ------- | ------------ | --------------- |
|                 | **In**                                   | **Out** | **In**                                      | **Out** | **Combined** | **In**                                     | **Out** | **Combined** |                 |
| **Ambient HBW** | 26                                       | 29      | 0                                           | 1.2     | 13.2         | 106                                        | 178.8   | 202          | 80%             |


### Delayering and traying

- **Traying process:**
    
    - WCS determines how many cases per tray.
        
    - Automated tray destacker provides trays.
        
    - Trayed cases sent to the **multi-shuttle** for temporary storage.
        
- **Quality control:**
    
    - Empty trays or failed diverts are flagged for **Case QA station**.
        
    - Recirculation loops manage failed trays.

![[Pasted image 20251015112035.png]]
Single sku multi cases...not multi sku....

if stock only 3 cases per tray and 1 case per tray in the dms buffers
and requires 2 cases per palletize then wcs will retrieval 3 cases tray and use 2 cases and 1case will traying and get back to dms ...


#### **Automatic Delayer Utilisation**

| **Considerations**          |                                        |
| --------------------------- | -------------------------------------- |
| Average Cases per Tray      | 1.75 Cases/Tray                        |
| Design Requirement          | 1,475 Cases/Hour<br><br>843 Trays/Hour |
| Subsystem Performance @100% | 1,100 Trays/Hour                       |
| **Subsystem Utilisation**   | **77%**                                |


#### **Manual Delayer Utilisation**

| **Considerations**                    |                  |
| ------------------------------------- | ---------------- |
| Pallet Cycle Time                     | 141.2 seconds    |
| Process Fatigue Factor                | 15%              |
| Case per Cycle                        | 57               |
| Cases/Hour                            | 1,235 Cases/Hour |
| Peak Design Requirement (incl. surge) | 781 Cases/Hour   |
| **Subsystem Utilisation**             | **63%**          |

#### **Tray buffer**

| **Aisle Configuration** | **Aisles** | **Levels** | **Bays** | **Storage Depth** | **Bay Width (Trays)** | **Total Tray Positions** | **Trays Stored** | **Occupancy** |
| ----------------------- | ---------- | ---------- | -------- | ----------------- | --------------------- | ------------------------ | ---------------- | ------------- |
| **Ambient**             | 8          | 28         | 20+1     | 2                 | 4                     | 72,128                   | 66,358           | 92%           |

| **Cases Per Tray** | **Average** | **Maximum** |
| ------------------ | ----------- | ----------- |
| **Cases / Tray**   | 1.64        | 1.75        |
| **Cases Stored**   | 108,827     | 116,126     |

| **Shuttle Utilisation**      |         |
| ---------------------------- | ------- |
| Shuttle Cycles / Hr          | 58      |
| Aisle Cycles / Hr            | 1,634   |
| Required Cycles / Hr / Aisle | 998     |
| **Utilisation**              | **61%** |

| **Lift Utilisation**         |         |
| ---------------------------- | ------- |
| Lift Cycles / Hr             | 371     |
| Trays / Cycle                | 2       |
| Trays / Hr / Lift            | 742     |
| Aisle Cycles / Hr            | 1,484   |
| Required Cycles / Hr / Aisle | 998     |
| **Utilisation**              | **67%** |

### overview
## 🧾 **Summary of the ALDI Victoria Training (Part 1)**

**Presenter:** Kathy Buchema – Lead Designer  
**Project:** ALDI Victoria (Project #2306)  
**Location:** Tarneit, Victoria, Australia  
**Date Reference:** Design submitted 31 July 2023; contract under ALDI review as of 10 August 2023.  
**Comparison:** Similar to the ALDI Barden (UK) project #2133, but larger and with more mechatronics.

---

### 🏗 **Project Overview**

- **Four main temperature-controlled chambers**:
    
    - **Ambient (TMC Non-Produce)**
        
    - **TMC Produce**
        
    - **Freezer**
        
    - **Chill**
        
- Each chamber has specific automation, with consistent design principles across them.
    
- The **SketchUp Version J** layout shows inbound receiving, automation inducts, and outbound dispatch buffers.
    
- Managed collaboratively by **Dematic Australia**, with main contacts **Philip Artlett** and **Jason Hill**.

---

### 📦 **Inbound & Induct Process**

- **Receiving zones:**
    
    - Ambient & TMC Non-Produce on the left (ambient zone).
        
    - Chill, Freezer, and TMC Produce on the right (chill zone).
        
- **Pallet Induction:**
    
    - All induct stations operate similarly; differences depend on pallet type and loading orientation.
        
    - Two pallet standards:
        
        - **Australian pallet** ≈ Euro pallet.
            
        - **AD pallet** = ⅓ of an Australian pallet; two AD pallets combined form a **Double D (DD) pallet**.
            
    - **WCS (Warehouse Control System)** handles tracking of DD pallets as one unit while maintaining individual attributes.
        
    - Pallets are validated at a **SWAP station** (size, weight, profile check). Rejected if:
        
        - Incorrect size or weight.
            
        - Missing WCS record.
            
        - Inducted into wrong temperature zone.
            
        - Mismatched SKUs on a DD pallet.
    - **Optical scanners** detect pallet color (blue or non-blue), tracked for later pallet stacking.
        
    - Valid pallets go via **elevator to the mezzanine** for routing to **ASRS (Automated Storage & Retrieval System)** or manual storage zones.
        

---

### ❄️ **Chill Area**

- Only **Australian pallets** are inducted (no DD pallets).
    
- Two rework zones: **Long Life** and **Short Life**, managed by the host system (not WCS).
    
- Pallets validated and elevated to conveyors for storage in the correct temperature ASRS.
    
- **Recirculation loops** handle blocked or missed diverts for continuous operation.
    

---

### 🚛 **Ambient Area**

- Includes ASRS aisles, multi-shuttle tray storage, delayering robots, manual picking, and monorail RGV (Rail-Guided Vehicle) transport.
    
- **Monorail RGV system:**
    
    - Moves inbound and outbound pallets.
        
    - Transfers between ASRS, pallet QA, and DRAP (de-wrapping) stations.
        
    - Has parking areas and recirculation loops for fault handling.
        

---

### 🦾 **DE-WRAP & Depalletizing Stations**

- **8 DRAP stations** (automated or manual) handle pallet unwrapping and preparation for depalletizing.
    
- Operators perform controlled unwrapping using a 2-step process (safety gate + control button).
    
- **Trash management:** plastic and cardboard separated; WCS handles bin replacement.
    
- **Delayering Robots:** remove product layers from pallets to descrambling platforms and traying conveyors.
    
- **Manual depalletizing:** two-operator stations feeding cases to conveyors.
    

---

### 🧺 **Traying and Multi-Shuttle Storage**

- **Traying process:**
    
    - WCS determines how many cases per tray.
        
    - Automated tray destacker provides trays.
        
    - Trayed cases sent to the **multi-shuttle** for temporary storage.
        
- **Quality control:**
    
    - Empty trays or failed diverts are flagged for **Case QA station**.
        
    - Recirculation loops manage failed trays.
        

---

### 📤 **Outbound and Pallet Building**

- Once orders are received and processed by **Pack Builder**, WCS initiates case retrieval and pallet builds.
    
- **Automated palletizing (Rapid PAL)** and **manual palletizing (Ergo PAL)** both use **DD pallets**.
    
- **D-traying devices** remove cases from trays for pallet build; unused cases are returned to the multi-shuttle.
    
- **Rapid PAL robots** form pallet layers automatically, while **Ergo PAL operators** build pallets manually using on-screen LOI instructions.
    

---

## 🧩 **Key Takeaways**

- ALDI Victoria (Tarneit) is a **large, multi-temperature automated warehouse** modeled on a proven ALDI UK design.
    
- Strong focus on **pallet standardization (AUS, AD, DD)** and **automation integration** via WCS.
    
- Detailed **pallet validation, routing, and QA** processes ensure correct storage and dispatch handling.
    
- **Automation Highlights:**
    
    - ASRS for pallets and trays.
        
    - RGV monorail transport system.
        
    - DRAP delayering and traying automation.
        
    - Rapid PAL / Ergo PAL palletization.
        
- **Safety and control layers** separate WCS decisions from operator actions.




## Project Overview and Status

The discussion centers on a massive Australian automated warehouse project for **Aldi**, which, at an estimated cost of **$607 million Australian** ($420 million US), is the largest project of its kind by over two times. However, the current design does not meet Aldi's business case hurdle rate. The key objective is to **reduce costs without adding labor**.

The project is currently three weeks before an **IT workshop**, with work being done to lay out a "Frankensteined" design. The design is functionally similar to the proposal from December, with two big functional changes. The project is on track to be the **biggest automated warehouse project in the world**, even after a projected 20% cost reduction.

---

## Key Design and Functional Changes

The design is a **flow-through design** with inbound on the top side and outbound on the bottom side.

### Cost Reduction and Design Modifications

- The original design was based on **21-hour operation** and not allowing for any "smoothing" (like manual picking on peak days), which drove the high cost. The new plan involves operating **24 hours**.
    
- The **TMC (Temperature Control) chamber** was previously an automated system with a tray buffer and automated palletizing. This didn't pay back, so it has been converted to a **mechanized solution** (a "peak tunnel") and will no longer have a DMS buffer.
    

### Pallets and Picking

- **D Pallets are gone for inbound**: Aldi has decided to no longer handle small Australian display pallets (D pallets) on the inbound side. They will only handle Australian pallets for storage. However, the system must **still build to D pallets** on the outbound side, converting volume from Australian to D pallets.
    
- The system heavily uses **wrapper pals** and **ergo pals** to pick almost every case. It also features **multiple cases per tray** (MCAP).
    

### New Robotic/Mechanized Solutions

- **TMC Produce Robot**: The TMC Produce chamber is for "warm produce" like bananas and tropical fruits. Bananas alone account for 20% of the annual volume through this chamber. A **specific robot** is proposed to automatically pick the top **four SKUs** (bananas and others), which represent **55% of the volume**. This is a much cheaper alternative to the original $30 million automated system.
    
- **Milk Crate Picking Robot**: Aldi is moving away from metal milk trolleys to **plastic milk crates**. A robot will be used in the chilled area to pick four milk SKUs from full Australian pallet replenishments to build **DD (Double D) pallets** for outbound.
    

### Dispatch Buffers

- Dispatch buffers are located across the dock. They use fast, double-motor UL 1200 cranes for high performance.
    
- The **main purpose is speed**. Sequencing is for **route order** and primarily to group by **temperature zone** (frozen first, then chilled, etc.) to meet temperature holding criteria on multi-temperature trailers. **Reverse drop sequencing** is **not promised** due to cost and limited value on multi-temperature trailers.
    
- **Pallet Flow**:
    
    - **Frozen, Chilled, and Produce** pallets (the "colorful pallets") **never go through the racking** in the dock dispatch buffer; they go straight to the line.
        
    - **Ambient and TMC** pallets (the "blue pallets") **always go through the racking** for buffering.
        

### Pallet Pairing

- A pairing logic is used to keep two pallets traveling together on the double load handling carriers and cranes to maximize transport efficiency.
    
- The **simplest proposal** is to treat it as one large assignment (e.g., 80 cases) to build two pallets consecutively for the same store, ensuring the pair is never broken.
    

---

## Costs and Negotiations

- The initial design cost was $607 million AUD, or $420 million US.
    
- The goal is to get the project cost down to around **$450-$480 million** AUD.
    
- The project is subject to an **Aldi Global Rebate** of 5.5% if their total spending with the company exceeds $200 million euros in a calendar year on a second project. This has caused regional uncertainty, with each region adding 5.5% to its margin.
    
- The company has received a **Letter of Intent (LOI)** and **$5 million** in payment for the project.

**APAC Test Team Suggestion**

Create an **APAC test branch** for WCS.

- The UK team can merge updates into the APAC test branch from time to time.
    
- The APAC team will then pull the latest updates and continue testing.
    
- We can also add **AFT preconditions** for the Use Case Tests.
    
- This will be beneficial for everyone, ensuring a **consistent testing environment**.


SKU_UOM_GetTrayLoadingPatternMaxNumberOfCases

SkuUomRecNo = SKU_GetSkuUomRecNo( SkuRecNo, SKU_UNIT_OUTER_CASE, SKU_DIMS_BASE );


**Problem Statement:**

TLNO with LE( Loading error ) expected move reason set to REJECT and reject reason as LOADING ERROR and tray routing dest should be  set to STLN110099 which towards to QA.
but TUDR at sorter induction loc STIA11IS01 does not set routing dest

  

**Steps to Reproduce:**

 TEST PROCEDURE                                                              
  1. Start WCS with MHE_MODE set to SIMULATION                                
  2. Ensure                                                                   
           source/mh_pc_dci_sim.c,                                            
           source/mh_mr_dci_sim.c,                                            
           shared_repo/Plugins/mh_rbg_dci_processes/source/mh_rbg_dci_sim.c,  
       and shared_repo/Plugins/mh_depall_dci/source/mh_depall_dci_sim.c       
       were compiled with Automatic = FALSE in SetupData                      
  3. Run support/dci_sim_screens.sh                                           
  4. Run atf_script MH_DCI_CONNECT_PLCS SIMULATION                            
  5. Run this program   AMB-REP-UC140

  

**Actual Result:**

[What actually happened - include specific error messages,  screenshots, logs in the attachments.]

  

**Expected Results:**

[What you expected to happen.]