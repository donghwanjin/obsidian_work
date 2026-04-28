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

#### 3.1.4.1. Ambient Despatch Buffer Retrieval to Marshalling Lane Group

A despatch_pull process for the marshalling lanes is responsible for setting up and managing the move requests to the marshalling lane groups for the ambient pallets.  The scheduler is then responsible for executing the move requests when marshalling lane space is available.  This doesn't fit very easily into the tm_pull mechanism, so it should be a custom process.

Iterate through each marshalling lane group:

- Consider all the pallets for the current route load in reverse drop sequence order.  Once all earlier drop sequence pallets have been moved to the marshalling lanes, or reached at least the crane, the move requests for pallets of the next retrieval sequence can be placed.
- When placing move requests, use the current time as the move priority time so the scheduler will execute the moves in the same order they are placed.
- If both of the ambient lanes in the group are available and have space, WCS round robins the pallets across the lanes.  Otherwise WCS just sends to the available lane.

In the above, ignore any pallets where the DU is flagged as PreventShipping.

#### 3.1.4.2. Non-Ambient Despatch Buffer Retrieval to Marshalling Lane

In happy path, moves should be placed on pallets in the temperature zone despatch buffers to the marshalling lane for non-ambient pallets.  These pallets should not normally be stored in the ambient despatch buffer.

Iterate through each marshalling lane group:

- Consider all the pallets for the current route load where the temperature class has been released, sorted first by the temperature class Released timestamp on the route load, and within a temperature class, in reverse drop sequence order. If the temperature class released timestamp are the same, then do the order Produce TMC > Chilled > Frozen. Once all earlier drop sequence or earlier temperature class pallets have reached a certain point, the move requests for pallets of the next retrieval sequence or temperature class can be placed:
    - When switching drop sequences within a temperature class, ensure all pallets have at least reached the highbay drop station of the temperature class's despatch buffer.
    - TBC: should we delay for drop sequences as well as temperature class?
    - When switching temperature classes, ensure all pallets have been dropped off by the outbound monorail to the marshalling area.
        - Freezer should retrieve freeze thaw separately to non freeze thaw pallets (on pick despatch group) - once all **non** freeze thaw pallets reached highbay drop sttaion pull out freeze thaw ones
- When placing move requests, use the current time as the move priority time so the scheduler will execute the moves in the same order they are placed.

If the non-ambient marshalling lane is made unavailable, or has filled up, non-ambient pallets still on route to that lane should be redirected to be routed to the despatch buffer.  Based on expected truck sizes the non-ambient lane wouldn't be filled, so this is an extreme exception.

For exception cases, the despatch_pull should watch for any non-ambient pallets that end up stored in the buffer, and if there is a non-ambient lane available, set up requests to that lane.  In this situation the sequencing is already broken, so just request all pallets to get the pallets moved as quickly as possible.  Also check for non-ambient pallets destined to the despatch buffer, and redirect to an available marshalling lane when possible.

**Performance:** In order to keep the flow moving, despatch_pull should be kicked whenever a pallet is picked up by the ambient despatch buffer cranes.

**Transit queues:** Create MH_DEST entries for each of the marshalling lanes to avoid over-filling.  We ignore the lane full STFI message in terms of routing, as this is sent when the lane is at 22 of 24 pallets.

#### 3.1.4.3. Monitor Move Requests

If a marshalling lane becomes unavailable, the despatch_pull process should cancel the move requests to that lane where possible.

#### 3.1.4.4. Marshalling Lane Fill Level Alerts

**Auto flow lanes** 

If a marshalling lane is logically full and the back pallet has been in the lane for over a minute, but the PLC has not sent a STFI saying the lane is full, raise an alert that the marshalling lane is unexpectedly not full.   
If the STFI says the lane is full, but WCS thinks there are less than 22 pallets (configuration on the marshalling loc) and nothing has been removed in the last minute, raise an alert that the marshalling lane is unexpectedly full.

#### 3.1.4.5. Ambient Despatch Buffers to Marshalling Lane integration

Link up the despatch buffer HBW locations and the marshalling lanes.

The bottom level of highbay locations on one side is the gravity lane for the marshalling lane.  Add a location type to the HIGHBAY_LOC and set to MARSHALLING_LANE or STORAGE as appropriate.  Modify HIGHBAY_LOC_SelectLocation to only allow STORAGE locations.

To get moves to marshalling lanes working, it likely needs TMs with a final destination of a marshalling lane to be given a selected destination of the equivalent highbay location.  Then the scheduler will just be moving between highbay locations.

On arrival in a location mapped to a marshalling lane, teleport the TM into the marshalling lane.

TUEX handling will need changing.  We shouldn't create dummies in the marshalling lane highbay locations.  We should flag the lane as full if we can't putaway into it.  Retrieving anything should un-flag the lane as full.

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

# 4. Open Issues

# 5. Risk Register