# SSH login
1Password

### New jira
[[P1948WCS-6695] New JIRA Template - Dematic Global JIRA](https://jira.dematic.net/browse/P1948WCS-6695)

[1948 WoW WAT tracker - Agile Board - Dematic Global JIRA](https://jira.dematic.net/secure/RapidBoard.jspa?projectKey=P1948WCS&useStoredSettings=true&rapidView=10348)
[DirectorView.gdfx - AnyGlass by ICONICS, Inc.](http://10.82.197.241/anyglass/pubdisplay/SCADA/DirectorView.gdfx)
### reset PTL server
PTL server ( must connect to Dematic-MMS )
10.82.202.10
Admin / no password

then restart server

check services and make sure dematic......4 systems are running.

StopPTL.bat > StartPTL.bat > StartPTLMessenger.bat

### RCC call : +44 333 344 3083

## Voice Console 
[Honeywell International, Inc. VoiceConsole - Login](http://10.82.201.10:9090/VoiceConsole/login.action)
dematic / Dematic@123

MSPS32:2R02:1 MSCV32:2R15I2
# loc
[TollHiveLoc](Toll%20Hive%20Locs.md)
### IAT for Ergo
MS02:01L022:1:2 .. MS11:26R025:1:1
### IAT for GTP
MS21:01L006:1:2 .. MS24:26R009:1:1   4 aisles
MS25:01L006:1:2 .. MS28:26R009:1:1   4 aisles
MS29:01L006:1:2 .. MS32:26R009:1:1   4 aisles
MS33:01L006:1:2 .. MS38:26R009:1:1   6 aisles   

will merge 33 to 38 near in the future
current | 21    26| 27    32 | 33    38 |
before  | 21    24 | 25    28 | 29    32 | 33     38 |

All manual loc
X* = 1095
Y* = 2936
A* = 5933


[[MMAT-4309] Awaiting Teach in Request to PD04 - Woolworths Agile Jira (atlassian.net)](https://woolworths-agile.atlassian.net/issues/MMAT-4309?filter=-4&jql=project%20%3D%20MMAT%20ORDER%20BY%20created%20DESC)

# **Steps to import Pre-Teach:

master file => cvs file( copy and paste only requires data ) => txt file
import_teach_kala pre_teach_batch_2_txt.txt overwrite >> batch_2_outcome
vim batch_2_outcome : check result 


1. **SKU Exists as SKU-01 in Production:**
    - **Pre-Teach Flow:**
        - If all necessary information for the SKU is present in the pre-teach CSV file, a DIQ Measurement record is created for each SKU unit of measure (UOM).
        - For split case items, separate records are created for both the CASE and OUTER CASE UOMs. For non-split case items, only one record is created for the OUTER CASE.
        - After all SKUs are successfully imported and no errors are detected, the production update is sent to the host system.
        
2. **SKU Does Not Exist (Using Missing Functionality):**
    - A new SKU is created only if SKU-01 already exists in the system. SKUs without a matching original SKU will not be created.
    - If the new SKU is not created, the script will identify the SKU and notify the WMS team to provide any missing information.
    - Once the new SKU is created, the data import follows the same steps as Scenario 
    
3. **Teach Height is 0 for Any Imported SKU:**
    - If the teach height is 0 for any SKU, the script identifies and reports the affected SKU.
    - The previously created DIQ measurement record for this SKU will be deleted, and the SKU will need to be re-taught once in production.
    - 
4. **Area Config is CLS (SGS or Manual):**
    - The old naming convention in the pre-teach file is automatically updated to match the new production naming, with "(Case)" added at the end.
    - The rest of the data import follows the steps outlined in Scenario 1.
    - 
5. **Preferred Area Config is Rack/ASRS, but Current Config is Ergopall/ASRS:**
    - In this case, the area config is converted to the preferred Rack/ASRS only for this specific instance to address a pre-teach download issue. This does not affect other import functionality.
    - 
6. **Units per Tote is Blank in the CSV File (GTP Area Config):**
    - If the area config is GTP and the units per tote field is blank in the CSV file, the script automatically calculates and fills in this field based on the standard calculations run during the normal teach-in process..
print issue 

## Receiving

this is the note i left for myself for the difference in manual and auto receiving for anyone who is wondering

***auto receiving: requires just delivery message then pallet on conveyor then we send pallet details request then wms replies

***manual receiving: delivery received and delivery container received all before pallet on conveyor this is preadvised!!!!

### TM_SUB_TYPE Calculated Max Volume
checking Max Contents Volume

stock balance message 7.6.2.1 find parameter and change to 20 for sandbox...


## MIS server full
554499
1. Please tell the RCC to engage **Managed Services/Infrastructure Team** ( same thing ) and NOT the on-call engineer;
2. Please tell them that the transaction log for prodwcsmis is full and needs "**housekeeping tasks performed**" by the infrastructure team;
3. Please tell them that this is urgent as it will impact replen on site ( customer won't be able to push their order forecast data );
4. Please keep the customer in the loop;
5. Please also escalate as this is the 2nd ( !!! ) time this is happening in a space of 3 weeks and there appear to be no alerts/pre-warnings configured for it...
6. Also, as a follow-up, please take this up with PM re setting up housekeeping tasks ( auotamted ) to prevent this...

### after release

1. In support directory: 
```
ut_build *.sh
```
2. in support/tails directory: 
```
ut_build *.sh
```

### ergopall_manager delay
 ps -ef | grep ergopall_man
 kill -9 <process>
 nohup /daiapp/bin/ergopall_manager ergopall_manager &


ut_update_move_priority_tm_final_dest_depall_area_provided_prod_x_and_time_to_subtract_y 89596 8 

ut_update_move_priority_tm_final_dest_depall_area_provided_prod_x_and_time_to_subtract_y 166702 8





OP_RSVN_SetPickBucketRecNo

SetPickStateFromBuckets