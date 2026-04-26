---
project: Toll
tags:
  - support
---
### Gtp Empty Carton decision
```c
#include "cd_declarations.h"
#include "lib_headers.h"
#include "web_headers.h"
#include "mh_cc_test_proj_lib_gen_global.h"

  #define MAX_RUNS 20
  #define MH_CC_TEST_POINT_DESIRED_ROUTES \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP15DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP14DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP13DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP12DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP11DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP10DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP09DST9, \
    MH_CC_TEST_POINT_CCGA02GPLS_TO_CCGP08DST9, \
    END_LIST

int main( int argc, char* argv[] )
{
  GL_INITIALISE_CMDLINE_PROCESS

  MH_CC_TEST_POINT_CCGA02GPLS_TYPE CurrentRoute = PAR_Enum( MH_CC_TEST_POINT_CCGA02GPLS );

  MH_CC_TEST_POINT_CCGA02GPLS_TYPE CurrentIndex;
  POS_INT Counter = 0;
  BOOLEAN Result;
  REC_NO UserRecNo;
  POS_INT TimeDelay;
  
  if( argc < 2 )
    printf( "Usage: <steve UserId TimeDelay>, for example: <steve DAI 1>" );

  UserRecNo = USER_FindUid( argv[ 1 ] );
  if( !USER_ValidRecNo( UserRecNo ) )
  {
    printf( "Invalid User\n" );
    return 0;
  }

  TimeDelay = atoi( argv[ 2 ] );
  if( TimeDelay < 0 || TimeDelay > 10000 )
  {
    printf( "Invalid Delay\n" );
    return 0;
  }

  for( CurrentIndex = CurrentRoute;
        Counter < MAX_RUNS; )
  {
    Counter++;
    CurrentIndex++;
    
    if( CurrentIndex >= NO_OF_MH_CC_TEST_POINT_CCGA02GPLS_TYPES )
      CurrentIndex = MH_CC_TEST_POINT_CCGA02GPLS_OFF;
    if( !GL_InList( CurrentIndex, MH_CC_TEST_POINT_DESIRED_ROUTES ) )
      continue;

  if( CurrentIndex >= MH_CC_TEST_POINT_CCGA02GPLS_OFF && CurrentIndex < NO_OF_MH_CC_TEST_POINT_CCGA02GPLS_TYPES )
  {
    Result = PAR_SetParameterValue(
        UserRecNo,
        MH_CC_TEST_POINT_CCGA02GPLS,
        NULL_POS_INT,
        ENUM_MhCcTestPointCcga02gplsType( CurrentIndex ),
        NULL_POS_INT,
        NULL,
        NULL_TIME_OF_DAY,
        NULL );

      if( Result )
        printf( "Success: %s\n", ENUM_MhCcTestPointCcga02gplsType( PAR_Enum( MH_CC_TEST_POINT_CCGA02GPLS ) ) );
      else
        printf( "Fail\n" );
    }
    sleep( TimeDelay );
  }
  GL_Exit( TRUE, PROCESS_STOPPED );
}
```