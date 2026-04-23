
### how to enable debug op_rsvn process

![[Pasted image 20250718113246.png]]
Set debug level
![[Pasted image 20250718113249.png]]
![[Pasted image 20250718113302.png]]
### unpickable
OP_RSVN_GetPickRsvnSteps
OP_RSVN_UpdatePick -> pick state is unpickable already
![[Pasted image 20250716170752.png]]
```gdb
(gdb) p *RsvnStep
$11 = {SeqNo = 9998, OpRsvnStepRecNo = 67, ReservationType = OP_RSVN_STEP_TYPE_NORMAL, AllocationState = OP_STATE_UNPICKABLE,
  ReservationState = OP_STATE_UNPICKABLE, ReservationLoc = {LocClass = LOC_CLASS_UNKNOWN, LocRecNo = -1}, BucketDims = {
    StockType = SKU_POOL_STOCK_TYPE_UNKNOWN, PurgeOrder_OrderRecNo = -1, StockArea = SKU_POOL_STOCK_AREA_UNKNOWN, Uom = SKU_UNIT_EACH,
    StockAccessibility = SKU_POOL_STOCK_ACCESSIBILITY_OK, StockAvailability = SKU_POOL_STOCK_AVAILABILITY_OK}}
```

```
18-Jul 02:56:06.227 op_rsvn_09_10 SW_LOG  ProdList
18-Jul 02:56:06.228 op_rsvn_09_10 SW_LOG    Prod 910521190000.00.1 (59)
18-Jul 02:56:06.231 op_rsvn_09_10 SW_LOG  OP_RSVN_ProcessProd( Prod 910521190000.00.1 (59) )
18-Jul 02:56:06.232 op_rsvn_09_10 SW_LOG   AllocateStockToBuckets( Prod 910521190000.00.1 (59) )
18-Jul 02:56:06.232 op_rsvn_09_10 SW_LOG    Stock (1) 1 of 910521190000.00.1 (59) >> [DMS,EACH,OK,OK,NORMAL]
18-Jul 02:56:06.232 op_rsvn_09_10 SW_LOG  CheckLockedPicks
18-Jul 02:56:06.233 op_rsvn_09_10 SW_LOG   Picks by Priority
18-Jul 02:56:06.233 op_rsvn_09_10 SW_LOG    Ord Accent-941326 Line 001 (1) - UNPICKABLE 1 of 910521190000.00.1 (Seq=4/1)
18-Jul 02:56:06.239 op_rsvn_09_10 SW_LOG   SetPickStatesFromBuckets( Prod 910521190000.00.1 (59) )
18-Jul 02:56:06.239 op_rsvn_09_10 SW_LOG    SetPickStateFromBuckets( Ord Accent-941326 Line 001 (1) - UNPICKABLE 1 of 910521190000.00.1 )
18-Jul 02:56:06.239 op_rsvn_09_10 SW_LOG     Reservation Sequence
18-Jul 02:56:06.240 op_rsvn_09_10 SW_LOG      Step 9998 - UNPICKABLE UNPICKABLE - [(ANY),EACH,OK,OK,(ANY)] - NORMAL
18-Jul 02:56:06.240 op_rsvn_09_10 SW_LOG       Step 9998 - UNPICKABLE UNPICKABLE - [(ANY),EACH,OK,HELD,(ANY)] - NORMAL
18-Jul 02:56:06.240 op_rsvn_09_10 SW_LOG        ... (5 more)
18-Jul 02:56:06.240 op_rsvn_09_10 SW_LOG      NoStock Allocation  = UNSATISFIABLE
18-Jul 02:56:06.240 op_rsvn_09_10 SW_LOG      NoStock Reservation = UNSATISFIABLE
18-Jul 02:56:06.240 op_rsvn_09_10 SW_LOG    Step 9998 - UNPICKABLE UNPICKABLE - [(ANY),EACH,OK,OK,(ANY)] - NORMAL
18-Jul 02:56:06.252 op_rsvn_09_10 SW_LOG     Buckets
18-Jul 02:56:06.252 op_rsvn_09_10 SW_LOG      Bucket [DMS,EACH,OK,OK,NORMAL] (1) (FreeQty=1)
18-Jul 02:56:06.252 op_rsvn_09_10 SW_LOG     Unchanged : Ord Accent-941326 Line 001 (1) - UNPICKABLE 1 of 910521190000.00.1
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG  OP_RSVN_DebugMemory
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_ConfigRsvnConfig = 2001 (8004 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_ProdList = 50 (200 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_BucketList = 8, 0 (320, 0 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_BucketRecNoList = 64 (256 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_BucketQtyRecNoList = 8 (32 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_PickList = 256 (1024 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_RsvnSteps = 1024 (53248 bytes)
18-Jul 02:56:06.253 op_rsvn_09_10 SW_LOG   OP_RSVN_RsvnConfigData = 101, 1024 (1616, 53248 bytes)

```



1. [ ] 
2. [ ] 