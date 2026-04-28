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

## 3.1. Component design

### 3.1.1. Purpose

### 3.1.2. Interfaces

### 3.1.3. Data structures

### 3.1.4. Algorithms

#### 3.1.4.1. Dewrap Waste Bin Management

|   |   |   |   |
|---|---|---|---|
|**Chamber**|**Location**|**Destination**|**Description**|
|Ambient|Ambient Receiving Area|Ambient Highbay||
|Ambient Highbay|Ambient Pallet Conveyor Waste Positions|Select Empty location based on Tm Sub Type against Waste bin location on the pallet conveyor Loc|
|Ambient Pallet Conveyor Waste Positions|Waste Area Via Manual Outfeed (PCRE02OP11)|When operator on oi releases waste bin|
|Chilled|Chilled Receiving Area|Chilled Highbay|Select the highbay with the least number of the Tm Sub Type|
|Produce TMC Highbay|
|Chlled Highbay|Chilled Pallet Conveyor Waste Positions (AMCAP and Milk)|Select Empty location based on Tm Sub Type against Waste bin location on the pallet conveyor Loc|
|Chilled Pallet Conveyor Waste Positions|Manual Outfeed (PCCHDEOP11)|When operator on oi releases waste bin|
|Freezer|Manual Waste Bin Position|Waste Area|There is no receiving of these waste bins. When the operator presses the button to release a waste bin WCS generates a move. Scan the Location to confirm the operator has picked up the waste bin and is directed to the waste area, a new internal TM should be created in the location it's just been picked up from.   <br>WCS generates a TM on start up for these locations when empty.|
|Produce TMC|Produce TMC Highbay|Produce TMC Pallet Conveyor Waste Bin Positions|Select Empty location based on Tm Sub Type against Waste bin location on the pallet conveyor Loc|
|Produce TMC Pallet Conveyor Waste Bin Positions|Manual Outfeed (PCTMC0OP01)|When operator on oi releases waste bin|

Tramming move from Pallet Conveyor outfeed to waste area, where the bin is deleted.

#### 3.1.4.2. Slipsheet Waste Bin Management 

Alert on Scada when the bin is deemed full by the sensor.

An operator goes to check this alert;

- If the bin is not full, squash packaging to clear sensor and turn off alert
- If the bin is full, press the button to trigger a TUDR from the PLC
    - WCS generates an internal TM in the location of type waste bin Slipsheet
    - Generates a move to the waste area
    - Operator scans the location to confirm collection of the bin, directed to the waste area
    - Operator also replaces the bin with another in the area off WCS.
        
    - Operator takes the bin to the waste area, scans the barcode of the waste area to complete the move.
        
    - Operator returns the bin off WCS to the chamber it was collected from, to wait to be manually replenished to the end of slipsheet conveyor when required.

## 3.2. Data design

### 3.2.1. Database schema

Key fields and the tables they are in

### 3.2.2. Data Flow

Flow of data through the db

### 3.2.3. Oi State Flow

### 3.2.4. OI States

#### 3.2.4.1. Dewrap State

Milk / TMC always dewrap the full pallet regardless.

Normal dewrap is based on depall tasks.

#### 3.2.4.2. Problem State

Milk / TMC Problem difference to normal dewrap:

only show problems

- Incorrect sku
- Incorrect TiHi
- Incomplete top layer
- Damaged Cases within required
- Incorrect Qty
- Other - only one dest of QA

All result in going to QA for the chamber.

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

# 4. Open Issues

# 5. Risk Register