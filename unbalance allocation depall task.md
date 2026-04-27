---
project: Chilsung
tags:
  - issue
---
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


#### mh_de_dci_depal_task_manager.c
```
int main(int argc, char *argv[])
{
  GL_INITIALISE_SERVER_PROCESS;

  if (argc == 3) PCB_SetPcbDebug( GL_MyPcb, LOG_SCREEN );

  InitialiseProcess ();

  DYN_LIST_TYPE      *TaskList = NULL;
  DYN_LIST_TYPE      *GroupList = NULL;

  if( TaskList == NULL )
    TaskList = DYN_LIST_New( sizeof( REC_NO ), 10, 10 );

  if( GroupList == NULL )
    GroupList = DYN_LIST_New( sizeof( REC_NO ), 10, 10 );

  while ( GL_CheckSystem ())
  {
    GL_WaitForGlobalTrigger ( REPEAT_DELAY, NULL_TIME, MyEf );
    SendTasks ( TaskList, GroupList );
    TidyUpTasks();
  }

  DYN_LIST_Free( TaskList );
  DYN_LIST_Free( GroupList );

  GL_Exit( FALSE, PROCESS_STOPPED );

} /* end of main */

```

```
static void SendTasks(
  DYN_LIST_TYPE *TaskList,
  DYN_LIST_TYPE  *GroupList )
{
  gKickDepalArea = FALSE;

  GL_WriteDebug( "SendTasks" );

  GL_EnqLock( LOCKS, MH_DEPAL_ALLOCATION_LOCK );

  SendTasksForRobot( LOC_Rb1Loc, Robot1PalletPosList,
                     TaskList, GroupList );

  SendTasksForRobot( LOC_Rb2Loc, Robot2PalletPosList,
                     TaskList, GroupList );

  GL_DeqLock( LOCKS, MH_DEPAL_ALLOCATION_LOCK );

  if ( gKickDepalArea )
    GL_SetEventFlag( EVENTS, WAKE_MH_DEPAL_AREA );

} /* SendTasks */

```

```
static void SendTasksForRobot(
  LOCATION_TYPE    StnLoc,
  DYN_LIST_TYPE    *PosList,
  DYN_LIST_TYPE    *TaskList,
  DYN_LIST_TYPE    *GroupList )
{
  LOCATION_STRING_TYPE      LocStr;
  REC_NO                    MhPcLocRecNo, TmRecNo;
  REC_NO                    MhDepalTaskRecNo, InProgressRecNo = NULL_REC_NO;
  LOCATION_TYPE             Loc;
  int                       Index;

  GL_WriteDebug( "Stn %s", LOC_ToString( StnLoc ) );

  if( PosList == NULL )
    return;

  if( TaskList == NULL )
    TaskList = DYN_LIST_New( sizeof( REC_NO ), 10, 10 );
  else
    DYN_LIST_Reset( TaskList );

  InProgressRecNo = NULL_REC_NO;

  for( Index = 0; Index < DYN_LIST_GetCount( PosList ); Index++ )
  {
    MhPcLocRecNo = DYN_LIST_GetRecNo( PosList, Index );

    if( !MH_PC_LOC_ValidRecNo( MhPcLocRecNo ) )
      continue;

    Loc = LOC_MakeLoc( LOC_CLASS_MH_PC, MhPcLocRecNo );

    GL_WriteDebug( " Loc %s", LOC_LocToString( Loc, LocStr ) );


    LOOP_ALL_LOC_TMS( FALSE, NULL_REC_NO )
    {
      GL_WriteDebug( "  TM %s", TM_GetTmId( TmRecNo ) );

      MhDepalTaskRecNo = FindInProgressDestTask( StnLoc, TmRecNo );

      if( MH_DEPAL_TASK_ValidRecNo( MhDepalTaskRecNo ) )
      {
        InProgressRecNo = MhDepalTaskRecNo;
        break;
      }

      if( BP_AnyBitSet( TM_GetRejectReason( TmRecNo ) ) )
        continue;

      if( TM_GetTmState( TmRecNo ) != TM_STATE_NO_MOVE ||
          !LOC_IsNullLoc( TM_GetFinalDestination( TmRecNo ) ) )
      {
        MhDepalTaskRecNo = FindInProgressSourceTask( StnLoc, TmRecNo );
        if( MH_DEPAL_TASK_ValidRecNo( MhDepalTaskRecNo ) )
        {
          InProgressRecNo = MhDepalTaskRecNo;
          break;
        }
        else
        {
          GL_WriteDebug( "    TM %s moving %s",
                         TM_GetTmId( TmRecNo ),
                         ENUM_TmStateType( TM_GetTmState( TmRecNo ) ) );
          continue;
        }
      }

/* PLUGINSTART (mh_de_dci_depal.SendTasksForRobot.pre.plugin.inc)     */
/*pi*/  /* content from file: mh_depal.plugin... */
/*pi*/
/*pi*/    /* Merge any tasks into single robot moves */
/*pi*/    MH_DEPAL_MergeSourceTmTasks( TmRecNo );
/*pi*/    MH_DEPAL_SetupNegativePickForTm( TmRecNo );
/*pi*/
/*pi*/  /* content from file: mh_depal_replen_request.plugin... */
/*pi*/    MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( TmRecNo, StnLoc );
/* PLUGINEND - end of plugin - edit keyline do not alter              */

      MhDepalTaskRecNo = FindNextSourceTask( StnLoc, TmRecNo );


      if( MH_DEPAL_TASK_GetMhDepalTaskState( MhDepalTaskRecNo ) == MH_DEPAL_TASK_STATE_IN_PROGRESS )
        InProgressRecNo = MhDepalTaskRecNo;
      if( MH_DEPAL_TASK_ValidRecNo( MhDepalTaskRecNo ) )
        DYN_LIST_AddUniqueRecNo( TaskList, MhDepalTaskRecNo );
    }

    if( MH_DEPAL_TASK_ValidRecNo( InProgressRecNo ) )
      break;
  }

  if( MH_DEPAL_TASK_ValidRecNo( InProgressRecNo ) )
  {
    GL_WriteDebug( "   InProgress (%d)", InProgressRecNo );
    MhDepalTaskRecNo = InProgressRecNo;
  }
  else if( DYN_LIST_GetCount( TaskList ) > 0 )
  {
    GL_WriteDebug( "   %d Tasks", DYN_LIST_GetCount( TaskList ) );

    DYN_LIST_Sort( TaskList, MH_DEPAL_TASK_Compare );

    BOOLEAN ValidTaskFound = FALSE;

    for( int i = 0; i < DYN_LIST_GetCount( TaskList ) && !ValidTaskFound; i++ )
    {
      MhDepalTaskRecNo = DYN_LIST_GetRecNo( TaskList, i );

      /* We need to check where we are going and make sure the plan
       * still works. If it doesn't split tasks to a new TM */
      MH_DEPAL_CheckDestTm( MhDepalTaskRecNo, FALSE );

      if( MH_DEPAL_TASK_GetMhDepalTaskState( MhDepalTaskRecNo ) !=
          MH_DEPAL_TASK_STATE_NEGATIVE_PICK )
      {
        REC_NO Dest_TmRecNo = MH_DEPAL_TASK_GetDest_TmRecNo( MhDepalTaskRecNo );

        if( TM_ValidRecNo( Dest_TmRecNo ) &&
            TM_IsInternal( Dest_TmRecNo ) )
        {
          REC_NO EmptyTmRecNo = EmptyTmForStn( StnLoc );
          if( TM_ValidRecNo( EmptyTmRecNo ) &&
              EmptyTmWaitingForMove( EmptyTmRecNo ) )
          {
            CreateEmptyPalletMove( MhDepalTaskRecNo,
                                   StnLoc, Dest_TmRecNo,
                                   EmptyTmRecNo,
                                   &MhDepalTaskRecNo,
                                   NULL );

            ValidTaskFound = TRUE;
          }
        }
        else
          ValidTaskFound = TRUE;
      }
      else
      {
        /* we shouldn't have a negative pick :( */
        break;
      }
    }

    if( !ValidTaskFound )
      MhDepalTaskRecNo = NULL_REC_NO;
  }
  else
  {
    GL_WriteDebug( "   No Task - Checking empty pallet to sandwich" );
    MhDepalTaskRecNo = CreateEmptyTmDepalTask( StnLoc, PosList, GroupList );
  }

  if( MH_DEPAL_TASK_ValidRecNo( MhDepalTaskRecNo ) &&
      MH_DEPAL_TASK_GetMhDepalTaskState( MhDepalTaskRecNo ) == MH_DEPAL_TASK_STATE_PENDING &&
      MH_DEPAL_SetNextTaskData( MhDepalTaskRecNo ) &&
      MH_DE_DCI_MissionRequired(
          MH_DEPAL_TASK_GetSource_Loc( MhDepalTaskRecNo ),
                                                     MhDepalTaskRecNo, NULL ) )
  {
    GL_WriteDebug( "   MH_DE_DCI_RequestDepalMission( %d )", MhDepalTaskRecNo );

    if( MH_DE_DCI_RequestDepalMission( MhDepalTaskRecNo ) )
    {
      POS_INT    Picker;
      gKickDepalArea = TRUE;

      Picker = StnToPicker( StnLoc );

      if( Picker != NULL_POS_INT )
        gLastTaskReplen[Picker] = !TM_ValidRecNo( MH_DEPAL_TASK_GetDest_TmRecNo( MhDepalTaskRecNo ) );
    }
  }
  else
  {
    if (MH_DEPAL_TASK_ValidRecNo( MhDepalTaskRecNo ))
      GL_WriteDebug( "   Don't send Task (%d) - %s", MhDepalTaskRecNo,
                     ENUM_MhDepalTaskStateType(
                      MH_DEPAL_TASK_GetMhDepalTaskState( MhDepalTaskRecNo ) ) );
    /* no work so lets kick the depal area to move some pallets for us then */
    else
      gKickDepalArea = TRUE;
  }

} /* SendTasksForRobot */

```


#### mh_depal_replen_request_lib.c
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

#### mh_pc_loc_proj_lib.c
```
GLOBAL BOOLEAN MH_PC_LOC_CHILSUNG_SetTmLocation(
  REC_NO TmRecNo,
  LOCATION_TYPE Location,
  TM_STATE_TYPE *TmState )
{
  BOOLEAN        ResetSelDest = FALSE;
  BOOLEAN        ResetFinalDest = FALSE;

  if ( !TM_ValidRecNo( TmRecNo ) )
    return FALSE;

  if ( Location.LocClass != LOC_CLASS_MH_PC )
    return FALSE;


  // TODO: Expand to include selected destination as well
  LOCATION_TYPE Dest = TM_GetFinalDestination(TmRecNo);
  LOCATION_TYPE SelDest = TM_GetSelectedDestination(TmRecNo);

  // Set TmState to NO MOVE if TM is at a buffer location

  if (GL_InList(Location.LocRecNo, MH_PC_NO_MOVE_POINTS))
  {
    // Don't nullify destination if we haven't reached it yet
    //
    // OR
    //
    // For Waste Bin buffers, clear it back to NO MOVE as the pallet
    // could have been moved by the PLC and would cause it to get stuck.

    if( LOC_EQUAL( Location, Dest ) ||
        LOC_EQUAL( Location, SelDest ) ||
        LOC_EQUAL( Dest, LOC_NullLocation ) ||
        ( GL_InList( Location.LocRecNo, MH_PC_WASTE_BUFFER_LOCS ) &&
          !TM_IsStretchwrapBin( TmRecNo ) ) )
    {
      *TmState = TM_STATE_NO_MOVE;
    }
  }
 
  /* Code to reroute pallet at PCP3 back to SWAP after failed SWAP check */
  if (LOC_EQUAL(Location, LOC_P2203PCP3Loc))
  {
    /* If pallet has a reject reason, should be routed to SWAP station to be checked */

  }

  // Set TmState to IN STORE if in a destacker location

  if (GL_InList(Location.LocRecNo, MH_PC_DESTACKER_LOCS))
  {
    *TmState = TM_STATE_IN_STORE;
  }

  switch ( Dest.LocClass )
  {
    case LOC_CLASS_HIGHBAY:
    case LOC_CLASS_STORAGE_AREA:
    case LOC_CLASS_MH_DE:
    case LOC_CLASS_MH_PC:
    {
      if( Location.LocClass == LOC_CLASS_MH_PC )
      {
        switch(Location.LocRecNo)
        {
          case MH_PC_LOC_P1006HBLS:
            ResetSelDest = TRUE;
            break;

          default: break;
        }
      }
    }
    break;

    case LOC_CLASS_ESS:
    {
      if (LOC_EQUAL(Location, LOC_P1214L1MLSLoc))
      {
        /* Check if we need to reallocate ESS location */
        /* Check DU allocation status and reset final destination if incorrect */
        MH_PC_LOC_CHILSUNG_CompareDuFinalDestWithAllocLoc( TmRecNo,
                                                           &ResetFinalDest,
                                                           &ResetSelDest);
      }
    }
    break;

    default: break;
  }

  if ( ResetSelDest )
  {
    MH_PC_LogEvent( EVENT, "%s cleared Sel dest in MH_PC_LOC_CHILSUNG_SetTmLocation",
                    TM_GetTmId( TmRecNo ) );
    TM_SetSelectedDestination( TmRecNo, LOC_NullLocation );
  }

  if ( ResetFinalDest )
  {
    MH_PC_LogEvent( EVENT, "%s cleared final dest in MH_PC_LOC_CHILSUNG_SetTmLocation",
                    TM_GetTmId( TmRecNo ) );
    TM_SetFinalDestination( TmRecNo, LOC_NullLocation );
  }

  /* Set Sequencing Loc and time for Depal.
   */
  if (LOC_Compare( Location, LOC_P1101L1LS2Loc, 1 ))
  {
    TM_SetDepalSequencingLoc( TmRecNo, Location );
    TM_SetDepalSequencingTime( TmRecNo, TIME_CurrentDaiTime() );

    GL_SetEventFlag( EVENTS, WAKE_MH_DEPAL_MANAGER );
  }

  if( LOC_IsDepalSourceLoc( Location ) )
  {
    LOCATION_TYPE    StnLoc;
    StnLoc = LOC_GetDepalStnLoc( Location );

    MH_DEPAL_REPLEN_REQUEST_SetupSourceTmTasksForStn( TmRecNo, StnLoc );
  }

  if( GL_InList( Location.LocRecNo,
                 MH_PC_LOC_P1101L1LS2,
                 MH_PC_LOC_P1108LIFT2,
                 MH_PC_LOC_P1109LIFT1,
                 MH_PC_LOC_P2013L2WLS2,
                 END_LIST ) )
  {
    GL_SetEventFlag( EVENTS, WAKE_MH_PC_PALLET );
  }

  return TRUE;

} /* MH_PC_LOC_CHILSUNG_SetTmLocation */
                               
```