### why more task assign to RB02

```bash
grep -h DEPAL_TASK_SetStnLoc *
```
MH_DEPAL_TASK_SetStnLoc( MhDepalTaskRecNo, StnLoc );
if( !MH_DEPAL_TASK_SetStnLoc( MhDepalTaskRecNo, LOC_NullLocation ) )



```bash
grep MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn *
```
mh_de_dci_depal_task_manager.c:/*pi*/    MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( TmRecNo, StnLoc );
mh_depal_replen_request_lib.c:GLOBAL BOOLEAN MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn(
mh_depal_replen_request_lib.c:        if (MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( BestTmRecNo,
mh_depal_replen_request.plugin:  MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( TmRecNo, StnLoc );
mh_pc_loc_proj_lib.c:    MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( TmRecNo, StnLoc );
