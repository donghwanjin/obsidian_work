![[Pasted image 20240919150106.png]]
instead of DU Area pick change to Pick Task area 



# DU_MostPickedAreaId


static BOOLEAN SortByPickArea( REC_NO Rec1, REC_NO Rec2 )

{

  return ( PICK_GetPickAreaRecNo ( Rec2 ) < PICK_GetPickAreaRecNo ( Rec1 ) );

}



GLOBAL const volatile char* DU_MostPickedAreaId( REC_NO DuRecNo )

{

  REC_NO         PickRecNo;

  REC_NO         PreviousAreaRecNo, CurrentAreaRecNo;

  DYN_LIST_TYPE *PickList;

  POS_INT        MaxPickCount = 0;

  POS_INT        CurrentPickCount = 0;

  REC_NO         MostPickedAreaRecNo = NULL_REC_NO;

  

  if( !DU_ValidRecNo( DuRecNo ) )

    return "";

  PickList = DYN_LIST_New( sizeof( REC_NO ), 10, 20 );

  

  LOOP_ALL_DU_PICKS

  {

    DYN_LIST_AddRecNo( PickList, PickRecNo );

  }

  

  DYN_LIST_Sort( PickList, SortByPickArea );

  

  LOOP_ALL_DYN_LIST_REC_NOS ( PickList, PickRecNo )

  {

    CurrentAreaRecNo = PICK_ZONE_GetPickAreaRecNo( PICK_GetPickZoneRecNo( PickRecNo ));

    if( CurrentAreaRecNo == PreviousAreaRecNo )

      CurrentPickCount++;

    else

    {

      if( CurrentPickCount > MaxPickCount )

      {

        MaxPickCount = CurrentPickCount;

        MostPickedAreaRecNo = PreviousAreaRecNo;

      }

  

      PreviousAreaRecNo = CurrentAreaRecNo;

      CurrentPickCount = 1;

    }

  }

  

  DYN_LIST_Free( PickList );

  

  if( CurrentPickCount > MaxPickCount )

    MostPickedAreaRecNo = PreviousAreaRecNo;

  

  if( PICK_AREA_ValidRecNo( MostPickedAreaRecNo ))

    return PICK_AREA_GetPickAreaId( MostPickedAreaRecNo );

  

  return "";

}/* DU_MostPickedAreaId */