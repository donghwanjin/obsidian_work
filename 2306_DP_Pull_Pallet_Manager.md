# 1. Overview

## 1.1. Name

DP Full Pallet Manager

## 1.2. Objective

## 1.3. Scope

## 1.4. Assumptions

## 1.5. Dependencies

## 1.6. Glossary of terms

# 2. Functional Requirements

## 2.1. Input

1. OP Rsvn Reserves picks to D Pallet stock in the Highbay

## 2.2. Output

1. DUs created from the DPs reserved
2. Stock from the highbay replenished to manual locs for picking

## 2.3. Logic

## 2.4. Error handling

# 3. Technical Design

## 3.1. Component design

### 3.1.1. Purpose

1. Replenish DPs from highbay into manual loc
2. Pair up DPs into a DU to be picked 

### 3.1.2. Process

**DU Creation**

1. Pick Despatch Group is ready for DU creation when all picks been through rsvn (> WAIT_ALLOCATION)
2. Pair up the DPs into DUs, 2 DPs in a DU of type DDP. If there is an odd number then the final one remains on it's own. Prefer same product together
    1. Look for Picks where
        1. Pick Type == FULL PALLET
        2. No DU
        3. Stock == DP
    2. Try to keep the same product together in the DU.

**Highbay DP replenishment**

1. DP Full Pallet Replen triggers replen of the D Pallets from highbay to a manual loc
2. Only valid for Pick task build once in a manual loc

### 3.1.3. Interfaces

### 3.1.4. Data structures

### 3.1.5. Algorithms

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