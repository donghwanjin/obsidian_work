---
type: project
tags:
  - project
project: Aldi Vic
---

### Git
[Lillian Ryan Uhl / Matflo Perl Testing · GitLab](https://gitlab.com/A0105372/matflo_perl_testing)


### Shared folder
[Dematic AU SCS CT APAC P11858 ALDI DC VIC - Documents - APAC Testing - All Documents](https://kion.sharepoint.com/sites/DematicAUSCSCTAPACP11858ALDIDCVIC/Freigegebene%20Dokumente/Forms/AllItems.aspx?csf=1&web=1&e=pwD0af&clickparams=eyAiWC1BcHBOYW1lIiA6ICJNaWNyb3NvZnQgT3V0bG9vayIsICJYLUFwcFZlcnNpb24iIDogIjE2LjAuMTc5MjguMjA3MDAiLCAiT1MiIDogIldpbmRvd3MiIH0%3D&CID=1616d0a1%2Dc09e%2De000%2D42eb%2D92df5e635ffc&cidOR=SPO&FolderCTID=0x0120004EC4E8FD10D60540A4CE276499003D69&id=%2Fsites%2FDematicAUSCSCTAPACP11858ALDIDCVIC%2FFreigegebene%20Dokumente%2FSoftware%2FAPAC%20Testing)

[Aldi Victoria | All Bugs Report List - Dataplane Reports - Dematic Global JIRA](https://jira.dematic.net/secure/DataplaneReport!default.jspa?report=e24e9d43-a0a9-45f9-b6e6-f9219c021ddd)


[https://app.powerbi.com/links/nVgXVARWDD?ctid=13c728e0-bb0c-4cf7-8e10-5b327279d6d9&pbi_source=linkShare](https://eur02.safelinks.protection.outlook.com/?url=https%3A%2F%2Fapp.powerbi.com%2Flinks%2FnVgXVARWDD%3Fctid%3D13c728e0-bb0c-4cf7-8e10-5b327279d6d9%26pbi_source%3DlinkShare&data=05%7C02%7Cdonghwan.jin%40dematic.com%7C53328ed7160240db106508de0b136b9a%7C13c728e0bb0c4cf78e105b327279d6d9%7C0%7C0%7C638960375350439156%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=lDh5sdV6tSU2QX1g7uhPtVEWagW3LpBefreaZGLHWMc%3D&reserved=0)

### issue
[[DVF issue performance test due to lack of cpu]]

### Belrose machine

RD connection
```
PCDAU35QWGZH.d400.MH.GRP
```

then my window credential

ssh dm2306@192.168.2.20

### Off site testing

[[off-site testing plan]]
### sample
[[paring]]
### Volume test
[[Performance test procedure]]
[[DVF issue performance test due to lack of cpu]]

### MIS

RDB_CONN_STRING=dm2306:MaisieKelly0914~@AldiVic
### Grep
[[Aldi grep]]

### Use case

* TEST PROCEDURE
 * Start WCS with MHE_MODE set to SIMULATION
 * Start ATF
 * Run http://e3r1v03ivdm0295.gsoent-dev.tld:8080/TestCentre.Development.UcProdConf
 * Run http://e3r1v03ivdm0295.gsoent-dev.tld:8080/TestCentre.Development.UcStockConf
 * Ensure source/mh_pc_dci_sim.c, source/mh_mr_dci_sim.c, and shared_repo/Plugins/mh_rbg_dci_processes/source/mh_rbg_dci_sim.c were compiled with Automatic = FALSE in SetupData
 * Run support    ./dci_sim_screens.sh
 * Run atf_script MH_DCI_CONNECT_PLCS SIMULATION
 * Run this program

#### Ambient inbound


#### Replen


All exception depalletizer



happy path first then

exception delayring... exception de-wrap

requires 5 layer and pallet has only 3 layer stock audit then we should call out other pallet has 2 layer.

storage protection

get hardware earliest possible and test on office...
- resolution change on monitor and test...
- voice picking create on office

```bash
make ut_load_sim_skus
ut_load_sim_skus SKU_master_data.csv 
```

#### check highbay balancing

```bash
grep "TUMI.*MRMR11DP01....MRAI.*##" *23_oct* | perl -nE 'push @a, /MRAI(\d{2})DS01/g; END { say join(",", @a) }'
```

 🟢 `-n`

Tells Perl: _“read input line by line and apply the code to each line.”_

 🟢 `-E`

Enables **modern Perl features**, such as `say` (which automatically adds a newline).

 🟢 `'push @a, /MRAI(\d{2})DS01/g; ...'`

- `/MRAI(\d{2})DS01/g` is a **regular expression**:
    
    - `MRAI` — matches the literal text “MRAI”.
        
    - `(\d{2})` — captures two digits (like `08`, `09`, etc.).
        
    - `DS01` — matches the literal text “DS01”.
        
    - `/g` — global flag (find _all_ matches in the line).
        
- `push @a, ...` means:  
    → Add every matched 2-digit number into array `@a`.


```bash
grep "TUMI.*MRMR11DP01....MRAI.*##" *23_oct* | \
perl -nE '
    push @a, /MRAI(\d{2})DS01/g;
    if (@a >= 9) {
        say join(",", splice(@a, 0, 9)) . ",";
    }
    END {
        say join(",", @a) . "," if @a;
    }
'

```

- `splice(@a, 0, 9)` → takes 9 numbers at a time from the array.
- 
    
- `say join(",", ...) . ","` → prints them with commas and a newline.
#### Deno 
```perl
for my $DepalId ( 'DE01', 'DE02' )
{
  my $DenoMsg = $DefaultDenoMsg->Copy(  );
  my $Block = $DenoMsg->{ 'MessageBody' }{ 'Blocks' }[ 0 ];
  $Block->{ 'SourceLocation' }->Format( "${DepalId}PC01" );
  $Block->{ 'LayerCount' }->Format( 1 );
  $Block->{ 'NrLayersInGripper' }->Format( 1 );
  $Block->{ 'LayersToPick' }->Format( 1 );
  $Block->{ 'NumberOfItemsDeposited' }->Format( 10 );
  $Block->{ 'ManualOperation' }->Format( '.' );
  $Block->{ 'DestinationLocation' }->Format( "${DepalId}CC01" );

  print $DenoMsg->PrettyPrint(  );
  print $DenoMsg->Stringify(  ), "\n";
}

```

#### TURP
```perl
my $MsgBlock = $Msg->{ 'MessageBody' }{ 'Blocks' }[ 0 ];
$MsgBlock->{ 'SourceLocation' }->Format( 'PCRE02CC03' );
$MsgBlock->{ 'CurrentLocation' }->Format( 'PCRE02CC03' );
# $MsgBlock->{ 'DestinationLocation' }->Format( '??????????????' );
# $MsgBlock->{ 'TuIdentifier' }->Format( '00000000000000001312' );
$MsgBlock->{ 'TuType' }->Format( 'AU01' );
$MsgBlock->{ 'TuLength' }->Format( 1165 );
$MsgBlock->{ 'TuWidth' }->Format( 1165 );
$MsgBlock->{ 'TuHeight' }->Format( 1500 );
$MsgBlock->{ 'TuWeight' }->Format( 1500 );
$MsgBlock->{ 'EventCode' }->Format( 'OK' );
$MsgBlock->{ 'Contour' }->Format( '..R' );
$MsgBlock->{ 'HeightClass' }->Format( '04' );
$MsgBlock->{ 'SortId' }->Format( '.' );
$MsgBlock->{ 'SortSeq' }->Format( '.' );
$MsgBlock->{ 'SortInfo' }->Format( '.' );
$MsgBlock->{ 'ReasonCode' }->Format( '.' );
$MsgBlock->{ 'TuOrientation' }->Format( '.' );
$MsgBlock->{ 'Barcode1' }->Format( '.' );
$MsgBlock->{ 'Barcode2' }->Format( 'L<T' );
$MsgBlock->{ 'EquipmentId' }->Format( '102445' );
$MsgBlock->{ 'LpaPrint' }->Format( 0 );
$MsgBlock->{ 'WrapPattern' }->Format( 0 );

```


### Reject scenario

#### TUID too short 16 digits required 20 digit with 00 pre fix
```
12-Nov 07:21:06.996 mh_dci_comms_4102 MH_DCI_MSG MFC <- PC4102 : /.TUDR4102WCS10015OK01NG0210..............PCRE04CC01..................0012384018292821......AU0100000000000000000000OK..............01......000000......0012384018292821    ....................RX4121451.......##
12-Nov 07:21:07.000 mh_dci_comms_4102 MH_DCI_MSG MFC -> PC4102 : /RTUMIWCS141021449OK01NG0210..............PCRE04CC01....PCRE04RP01....0012384018292821......????00000000000000000000OK......................000000............................................................00##
12-Nov 07:21:07.262 mh_dci_comms_4102 MH_DCI_MSG MFC <- PC4102 : /ATUMI4102WCS11449OK00NG0030##
12-Nov 07:21:23.450 mh_dci_comms_4102 MH_DCI_MSG MFC <- PC4102 : /RTURP4102WCS10016OK01NG0210..............PCRE04RP01....PCRE04RP01....0012384018292821......????00000000000000000000OK..............01......000000......0012384018292821    ....................CT4121321.......##

```

#### reject because no height or weight
```
12-Nov 07:58:26.458 mh_dci_comms_4102 MH_DCI_MSG MFC <- PC4102 : /.TUDR4102WCS10030OK01NG0210..............PCRE04CC01..................00162953768336162355..AU0100000000000000000000OK..............01......000000......00162953768336162355....................RX4121451.......##
12-Nov 07:58:26.463 mh_dci_comms_4102 MH_DCI_MSG MFC -> PC4102 : /RTUMIWCS141021524OK01NG0210..............PCRE04CC01....PCRE04RP01....00162953768336162355..AU0100000000000000000000OK......................000000............................................................00##
```

#### example message from Joe

```c
Tray arrives at decision point  
18-Nov-2025 10:46:22.976 mh_dci_comms_4104 Case Conveyor DCI Communications MH_DCI_MSG   
MFC <- CC4104 : /RTUDR4104WCS10012OK01NG0186CCCHL1DP01....CCCHL1DP01....??????????????10002617..............TRL907000500010000000000OK......................000000......0000............................##

Missioned to linear sorter  
18-Nov-2025 10:46:22.979 mh_dci_comms_4104 Case Conveyor DCI Communications MH_DCI_MSG   
MFC -> CC4104 : /RTUMIWCS141041785OK01NG0186..............CCCHL1DP01....CCCHL1SPED....10002617..............TRL900000000005500024000OK..............00......000000......0000............................##

<< TURP at CCCHL1SPED missing - likely DVF issue >>

TUDR at sorter scanner loc  
18-Nov-2025 10:47:08.016 mh_dci_comms_SD61 Linear Sorter DCI Communications MH_DCI_MSG   
MFC <- STD61 : /RTUDRSD61WCS10013OK01NG0227[{"CURRLOC":"STIA61IS01","DESTLOC":"","TUIDENT":"10002617","TUTYPE":"TRL9","TULENGTH":700,"TUWIDTH":500,"TUHEIGHT":100,"TUWEIGHT":0,"EVCODE":"OK","TRACKID":"2","DICODE":"","TUDADS":"","RECIRR":""}]##

TUMI to sorter lane/chute  
18-Nov-2025 10:47:08.051 mh_dci_comms_SD61 Linear Sorter DCI Communications MH_DCI_MSG   
MFC -> STD61 : /RTUMIWCS1SD611766OK01NG0233[{"CURRLOC":"STIA61IS01","DESTLOC":"STLN610001","TUIDENT":"10002617..............","TUTYPE":"TRL9","TULENGTH":"0000","TUWIDTH":"0000","TUHEIGHT":"0000","TUWEIGHT":"00000000","EVCODE":"OK","TRACKID":"2"}]##

Arrival on sorter lane  
18-Nov-2025 10:47:08.810 mh_dci_comms_SM61 Linear Sorter DCI Communications MH_DCI_MSG   
MFC <- STM61 : /RTURPSM61WCS10018OK01NG0239[{"CURRLOC":"STLN610001","DESTLOC":"STLN610001","TUIDENT":"10002617","TUTYPE":"TRL9","TULENGTH":700,"TUWIDTH":500,"TUHEIGHT":100,"TUWEIGHT":0,"EVCODE":"OK","TRACKID":"2","DICODE":"ND","TUDADS":"","RECIRR":""}]##

TUDR at MS aisle selection point  
18-Nov-2025 10:47:14.218 mh_dci_comms_4201 Case Conveyor DCI Communications MH_DCI_MSG   
MFC <- CC4201 : /RTUDR4201WCS10013OK01NG0186..............CCCHL2B66R....??????????????10002617..............TRL907000500010000000000OK......................000000......0000............................##

TUMI to the DMS pick stn  
18-Nov-2025 10:47:14.235 mh_dci_comms_4201 Case Conveyor DCI Communications MH_DCI_MSG   
MFC -> CC4201 : /RTUMIWCS142012004OK01NG0186..............CCCHL2B66R....MSAI66CR02PS1110002617..............TRL900000000005500024000OK..............00......000000......0000............................##

"Exit TURP" on diverting into the DMS - tray location updating to CCAI66CR02PS11  
18-Nov-2025 10:47:16.380 mh_dci_comms_4201 Case Conveyor DCI Communications MH_DCI_MSG   
MFC <- CC4201 : /RTURP4201WCS10014OK01NG0186CCCHL2B66R....MSAI66CR02PS11MSAI66CR02PS1110002617..............TRL905000700010000000000OK..............00......000000......0000............................##

Arrival at the DMS pick station. TUMI can now be sent to the DMS elevator  
18-Nov-2025 10:51:30.348 mh_dci_comms_MS66 Multi Shuttle PLC 66 Communications MH_DCI_MSG   
MFC <- MS66 : /RTUDRMS66WCS10415OK01NG0158CCCHL2B66R....MSAI66CR02PS12MSAI66CR02PS1110002617..............TRL907000500010000000000OK000000000000000000000000..............##
```

two pallet check.
```
grep -h -E '4013231251125041027243|4013231251125041053705' ~/logging/master/mh_pc_dci*25_nov*

```

```
grep -h -E '00000000000000000901|4120000000000000000001' ~/logging/master/mh_pc_dci*25_nov* \

| awk '{

    gsub(/00000000000000000901/, "\033[31m&\033[0m");  # Red

    gsub(/4120000000000000000001/, "\033[32m&\033[0m");  # Green

    print

}'
```


```
grep -h -E '00000000000000000903|4120000000000000000002' ~/logging/master/mh_pc_dci*3_dec* | awk '{gsub(/00000000000000000903/, "\033[31m&\033[0m"); gsub(/4120000000000000000002/, "\033[32m&\033[0m"); print}'
```




question to UK 

1. DExx ?????? with NR => case conveyor sorter create NR-xxx-xxxx then wcs route to QA
2. are we expected TLRP when last case loaded?
3. at the QA high possible candidate sku will be first page for operator to select?
4. after reidentify stock and infeed to mhe tote will store in ms loc and depal task will be complated?


**Problem Statement:**
- **Replenishment Demand**
    
    - System requests **10 cases** for replenishment.
    - A pallet with **10 cases per layer** is available.
- **Depalletizing**
    
    - Pallet goes to **Auto Depall Station**.
    - Cases are loaded onto trays.
    - **4 cases** are unsuccessfully loaded and notified to TLNO with NR
    - 6 cases are successfully loaded and store in ms loc.
- **Expectation**
    
    - Because the full quantity (10) was not loaded, **TLRP (Tray Load Report)** is **not expected**
- **Exception Handling**
    
    - The 4 cases have issues:
        - Either **NR-xxx-xxxx** 
        - Or  **possibly read TM** 
    - These cases are routed to **QA station**.
- **QA Process**
    
    - Operator scans the **TM** (tray or case identifier).
    - Operator selects **SKU**:
        - SKU list may have a **score or ranking** so the most likely SKU appears first (to speed up selection).
    - Operator enters **quantity** and confirms.
    - **Amends stock** (updates inventory).
    - **Clears the problem**.
    - **Inducts tray back into the system**.
    - 4 cases store in ms loc.




TRAY_LOADING_PATTERN_GetNumberOfCases( SKU_UOM_GetTrayLoadingPatternRecNo( STOCK_GetSkuUomRecNo( TM_GetStockRecNo( STEP1_TmRecNo ) ), TRAY_LOADING_PATTERN_GROUP_AUTO  ));

SKU_UOM_GetTrayLoadingPatternRecNo( STOCK_GetSkuUomRecNo( TM_GetStockRecNo( STEP1_TmRecNo ) ), TRAY_LOADING_PATTERN_GROUP_AUTO  );

DiqRecNo = TM_GetDiqMeasurementRecNo( TmRecNo );

DIQ_MEASUREMENT_GetHeight( DiqRecNo )


MH_CC_LOC_GetMemMhDciPlcLoc


REC_NO SkuRecNo = SKU_FindSkuId( STEP_01__SkuId_1 )


   case  :
    return MH_DCI_PLC_MR_11;

   case MH_MR_DCI_SCHEDULER_MR81:
    return MH_DCI_PLC_MR_81;

I would suggest adding it to your profile so it can be run simply as 'HostInterfaceHelper.py' though.
```bash
export PATH="$PATH:/home/data/path/to/folder/hostinterfacehelper"
```
```bash
source ~/.bashrc
```
```
HostInterfaceHelper.py <structure> <data>
```


modify

4things

Struct
Handling Type
Action Type 



check with Joe tonight

- De-wrap station repeat send TUDR is off. 
  because TUDR is un ack message if PLC sent and wcs not recieved tm will be stuck.
- HOLD state list QC CHECK and QUARANTINED are missing or do we need to update HIS ? where can I check HOLD STATE list for Aldi project? 
- how to enable Historical view for TM?

### uc gen tooling 
pros saving a lot of time 
cons still time consuming and it requires understand matflo code base.



```
 Start-Process powershell -Verb RunAs
```

```bash
powercfg /powerthrottling disable /path "C:\Users\a0006235\Documents\Aldi\Emulation 2024.09.20\148869_MDI.exe"
```

this command check
```
powercfg /powerthrottling list
```




● (feat/uc_collater) (venv) [dm2306@e3r1v03ivdm0295 uc_collater]$ perl uc_collater.pl -?  
  
DESCRIPTION  
   Used to collate and process use case zips and manifests  
   Can be used to collate, compile, and run test cases, with optional TestRail integration  
  
USAGE  
   perl uc_collater.pl [ ARGS ]  
  
ARGS  
   Info:  
     --help ( Aliased: -h, -? )  
       Prints this help message and exits  
     --version ( Aliased: -v )  
       Prints version info and exits  
     --verbosity n  
       Sets the verbosity level to n  
       Value passed to UC Processor  
       Levels ( Default: 0 )  
        -1: Disables all INFO print statements  
         0: Prints UC Processor standard output  
         1: Additionally prints unzip and CSV Consumer standard output  
         2: Additionally prints JSON Consumer standard output  
     --verbose [n]  
       Sets verbosity level to n if given otherwise increments the verbosity level  
     --debug n  
       Sets debug print level to n  
       Levels ( Default: 1 )  
         0: No extra output  
         1: Basic info on command calls and file system side effects  
         2: Full command call info  
   Build Control:  
     --manifest Path/To/Test/Manifest [ ... ]  
       A use case test manifest to be used for collation and processing  
       The manifest is used to identify all test dependencies which are processed via the CSV Consumer, JSON Consumer, and UC Processor  
       Path to CSV Consumer: /home/data/dm2306/matflo_perl_testing/use_case_suite/generation_scripts/csv_consumer/uc_csv_consumer.pl  
       Path to JSON Consumer: /home/data/dm2306/matflo_perl_testing/use_case_suite/generation_scripts/json_consumer/uc_json_consumer.pl  
       Path to UC Processor: /home/data/dm2306/matflo_perl_testing/use_case_suite/aldi_victoria/scripts/ProcessUcs.pl  
     --zip Path/To/Zip [ ... ]  
       A use case zip file which is unpacked ( via unzip ) and whose contents are processed  
       The zip is expected to contain a test or stub manifest  
       The manifest's pathing is used as the zip unpacking target directory  
       Searches for all other use case manifests which are then scanned for imports matching any files from the given zip  
         The base search directory is the concatenation of the use case suite directory and the first two manifest pathing elements  
         Use case suite directory: /home/data/dm2306/matflo_perl_testing/use_case_suite  
         Sym links are not followed  
       All dependent use cases have their manifests processed via the --manifest facility  
     --testrail ( Aliased: -t )  
       Unimplemented  
     --dry-run ( Aliased: --dryrun, --dry, -d )  
       Lists but does not execute build steps/actions  
     --process FlagBundle  
       Flag bundle passed to UC Processor as first argument like -FlagBundle during manifest processing  
     --tidy  
       Enables tidying of zips and sym links  
     --no-tidy  
       Disables tidying of zips and sym links  
     --tidy-zips ( Aliased: --tidyzips )  
       Removes zips after processing  
       Enabled by default  
     --no-tidy-zips ( Aliased: --no-tidyzips )  
       Keeps zips after processing  
     --tidy-sym-links ( Aliased: --tidy-symlinks, --tidysymlinks )  
       Removes sym links after processing  
       Enabled by default  
     --no-tidy-sym-links ( Aliased: --no-tidy-symlinks, --no-tidysymlinks )  
       Keeps sym links after processing
