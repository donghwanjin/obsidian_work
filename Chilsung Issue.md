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




```
GLOBAL BOOLEAN MH_DEPAL_REPLEN_REQUEST_RqstRetrievalsToStns(
  MH_DEPAL_STN_TYPE             *Stn  )
{
  POS_INT                       LimitParam = PAR_Int( MH_DEPAL_MS_ONLY_RQST_LIMIT );
  LOCATION_STRING_TYPE          LocStr;
  BOOLEAN                       MoveRqsted = FALSE;
  POS_INT                       TmsInRqst = 0;
  REC_NO                        TmRecNo;

  GL_WriteDebug( "MH_DEPAL_REPLEN_REQUEST_RqstRetrievalsToStns( %s )",
                 LOC_LocToString( Stn->Loc, LocStr ) );

  LOOP_ALL_TM_STATE_TMS( TM_STATE_MHE_REQUEST )
  {
    LOCATION_TYPE               StnLoc, TmDest;

    TmDest = TM_GetFinalDestination( TmRecNo );

    StnLoc =  LOC_GetDepalStnLoc( TmDest );

    if (LOC_Compare( StnLoc, Stn->Loc, 1 ))
    {
      REC_NO                    StockRecNo;

      if( ( TmIsSingleStock( TmRecNo, &StockRecNo, NULL )) &&
          ( StockHasLayerPickerReplenRqst( StockRecNo ) ) )
      {
        GL_WriteDebug( " %s in Rqst", DebugTmStr( TmRecNo, NULL ) );
        TmsInRqst++;
      }
    }
  }

   /*
   * Limit the number of TMs we request. We usually request everything we
   * need and let the in-trnasit queue deal with it. It's better here just
   * to request a few as we will cope with change better.
   */
  if (TmsInRqst < LimitParam)
  {
    REC_NO              BestTmRecNo = NULL_REC_NO, TmRecNo;

    LOOP_ALL_TM_TYPE_TMS( TM_TYPE_PALLET )
    {
      REC_NO                    StockRecNo;

      if( ( TM_GetTmState( TmRecNo ) == TM_STATE_IN_STORE ) &&
          ( TmIsSingleStock( TmRecNo, &StockRecNo, NULL ) ) &&
          ( StockHasLayerPickerReplenRqst( StockRecNo ) ) )
      {
        if ((BestTmRecNo == NULL_REC_NO) ||
            (BetterTmForRetrieval( TmRecNo, BestTmRecNo )))
          BestTmRecNo = TmRecNo;
      }
    }

    if (BestTmRecNo != NULL_REC_NO)
    {
      LOCATION_TYPE         BestLoc = LOC_NullLocation;

      GL_WriteDebug( " %s is best", DebugTmStr( BestTmRecNo, NULL ) );

      /*  Look for a source loc. Only needed on Chilsung so no need
       *  for buffer locs.
       */
      for (POS_INT P = 0; P < DYN_LIST_GetCount( Stn->Positions ); P++)
      {
        MH_DEPAL_POS_TYPE      *Pos;

        Pos = DYN_LIST_GetAddr( Stn->Positions, P );

        if ((Pos->InService) &&
            (Pos->Usage == MH_DEPAL_POS_USAGE_SOURCE))
        {
          if (LOC_Compare( BestLoc, LOC_NullLocation, 1 ))
            BestLoc = Pos->Loc;
        }
      }

      if (!LOC_Compare( BestLoc, LOC_NullLocation, 1 ))
      {
        if (MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( BestTmRecNo,
                                                              Stn->Loc ))
        {
          MH_DEPAL_Debug( 0, "   TM_RequestMheMove( %s, %s )",
                          DebugTmStr( BestTmRecNo, NULL ),
                          LOC_LocToString( BestLoc, LocStr ) );

          GRAB_Get( DEFAULT_FLAG );

          if ((TM_ValidRecNo( BestTmRecNo )) &&
              (TM_GetTmState( BestTmRecNo ) == TM_STATE_IN_STORE))
          {
            DAI_TIME_TYPE    ReplenPriorityTime;
            REC_NO    RequestRecNo;

            RequestRecNo = TM_GetFirstReplenRequestRecNo( BestTmRecNo );

            ReplenPriorityTime = REPLEN_REQUEST_GetPriorityTime( RequestRecNo );

            if (TM_RequestMheMove( BestTmRecNo,
                                   BestLoc,
                                   MOVE_REASON_REPLEN,
                                   NULL_REC_NO,
                                   ReplenPriorityTime,
                                   NULL_POS_INT ))
              MoveRqsted = TRUE;
          }

          GRAB_Free( DEFAULT_FLAG );

          if (MoveRqsted)
            MH_DEPAL_Event( LOG_FILE, Stn->Loc,
                            "Source %s Requested to %s",
                            DebugTmStr( BestTmRecNo, NULL ),
                            LOC_LocToString( BestLoc, LocStr ) );
        }
      }
    }
  }
  else
    GL_WriteDebug( " %s over in rqst limit", LOC_LocToString( Stn->Loc, LocStr ) );

  return( MoveRqsted );
}

```