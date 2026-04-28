# 1. Overview

## 1.1. Name

**mh_rbg_dci_fmcf.plugin**

## 1.2. Objective

The highbay optimiser component makes best use of the highbay cranes by swapping work between pallets in different aisles at the last possible moment.  The plugin supports swapping movements for various types of moves, but primarily is aimed at replenishment moves.

We aim to leave replenishment following the basic business rules, and then build on top of the move selection and optimise the highbay where possible.  Within replenishment, pallet selection is based on:

1. BBE Date / Receipt Date.  We follow FEFO / FIFO depending on whether the SKU is perishable.
2. Pallet Quantity.  If two pallets have the same date, we will take the lowest quantity first.

## 1.3. Scope

## 1.4. Assumptions

## 1.5. Dependencies

## 1.6. Glossary of terms

# 2. Functional Requirements

## 2.1. Input

The input data required is TMs with move requests with a reason of REPLEN.  Additionally, OP must run and sort highbay stock in to OP_BUCKETs.  The optimiser will only consider stock in the same OP_BUCKET.

## 2.2. Output

The output is a sorted list of move swap options across the highbay aisles.
![[Pasted image 20260428112929.png]]
## 2.3. Logic

## 2.4. Error handling

# 3. Technical Design

## 3.1. Component design

### 3.1.1. Purpose

The highbay optimiser component makes best use of the highbay cranes by swapping work between pallets in different aisles at the last possible moment.  The plugin supports swapping movements for various types of moves, but primarily is aimed at replenishment moves.

We aim to leave replenishment following the basic business rules, and then build on top of the move selection and optimise the highbay where possible.  Within replenishment, pallet selection is based on:

1. BBE Date / Receipt Date.  We follow FEFO / FIFO depending on whether the SKU is perishable.
2. Pallet Quantity.  If two pallets have the same date, we will take the lowest quantity first.

### 3.1.2. Interfaces

### 3.1.3. Data structures

  

### 3.1.4. Algorithms

We select a pallet according to the rules of the base component e.g. replenishment, and set up the move requests.  The highbay optimiser then starts from these move requests:

In a background process, for each storage area in turn, precalculate the move swap data (MH_RBG_MOVE_SWAP_GenerateList).  Loop through all pallets in highbay which have a replenishment move, and make a sorted list of replenishment moves in priority sequence.  For each pallet in the list, calculate alternative move options:

1. Loop through all other stock pallets which are in the same ‘stock bucket’ as the one being requested.
2. Same stock bucket means the same SKU, date, availability state and other distinguishing characteristics.
3. Consider only pallets stored in highbay, and which do not have any other current move reason.
4. Score the pallet according to the pallet selection rules below.  Check the alternative pallet’s aisle, and if this pallet gets a better score than the best alternative in that aisle, record this as the alternative for that aisle.
5. Save the alternative moves per aisle in a move swap table for use by the scheduler.

In the highbay scheduler, when a highbay aisle needs to start a new retrieval):

1. Make a sorted list of retrievals from the aisle, in move priority sequence (standard scheduler code).
2. Now consider the move swap table entries, starting from the highest priority (MH_RBG_MOVE_SWAP_SwapHighPrioRequestToAisle).
3. Only consider move swap entries where the move swap priority is a higher priority move than the top priority move found in step 1.
4. Only consider move swap entries with an alternative pallet available in the current aisle.
5. Only consider move swap entries where the alternative pallet is retrievable at the current moment.
6. If we find a move swap matching the above criteria, swap the pallet reserved for this replenishment to the alternative from this aisle.

Replenishment Pallet Selection Scoring Rules:

1. Pallets without any other replenishment request attached: +1000
2. Pallets in back locations: -10000
3. Pallets near to the P&D: -10 (calculated same way as storage with XY ratio included)

## 3.2. Data design

### 3.2.1. Database schema

#### 3.2.1.1. MH_RBG_MOVE_SWAP

This table contains potential move swap data for pallet movements.  The whole table is stored in memory only.

- StorageAreaRecNo - the storage area the move swap was calculated for.
- Index - the priority of this move swap within the storage area.
- TmRecNo - the original TM requested to be moved.
- MoveType - the type of move e.g. replenishment.  Controls which sub-algorithm is responsible for setting up the move swap data
- Swappable_TmRecNo - an array of the best possible move swaps, per highbay aisle.

### 3.2.2. Data flow

mh_rbg_move_swap_background maintains the table.  It reads in the TM move request data, and generates the move swap data from it.  The mh_rbg_dci_scheduler process consumes the data.

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

# 4. Open Issues

# 5. Risk Register