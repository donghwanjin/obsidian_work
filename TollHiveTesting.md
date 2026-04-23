2025-07-14
![[Pasted image 20250714142007.png]]
 T23_02_02ErrorChecksInStockToteRemoval



## CMC test
 
 
 ### [ x ]Single tote happy path 
### no read ( retest required )

Expected
1|ACK|25|11:27:47|0|6|

Received = time missing and after 6 should be no more information
1|ACK|21||0|6|60|258|303|267432|131|8719|

1. issue with parameter force to go destination.
2. no read  then manually removed...
|14-Jul-2025 15:54:29.338|cmc_interface|Cmc Interface 1 Events|ALARM|Tote Removed, Tote 7000014 manually removed|
![[Pasted image 20250714155842.png]]

3. no read 
![[Pasted image 20250714160335.png]]


### [ x ]Wrong ID ( Carton )
![[Pasted image 20250714160704.png]]

### [  ] Multiple 3 order totes

1. 3 TMs. 1 of tm was no record on WCS

Created 3rd tm

2. 3 TMs. 
####
```
|14-Jul-2025 16:44:30.869|cmc_interface|Cmc Interface 1 Debug|SW_LOG|end, MachineId: 1 \| MsgCounter: 50 \| Reference: 7000006_16 \||
|14-Jul-2025 16:44:30.868|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|end\|50\|7000006_16\||
|14-Jul-2025 16:44:30.788|cmc_interface|Cmc Interface 1 Debug|SW_LOG|END, MachineId: 1 \| MsgCounter: 50 \| Reference: 7000006_16 \| Status: 1 \| Message Event 0: NOT CLASSIFIED \| Height: 121 \| Length: 314 \| Width: 300 \| Area: 419070 \| WeightCarton: 205 \| WeightScale: 0 \| ToteDestination: 0 \||
|14-Jul-2025 16:44:30.788|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000006 new state: COMPLETED|
|14-Jul-2025 16:44:30.787|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|END\|50\|7000006_16\|1\|000\|121\|314\|300\|419070\|205\|0\|0\||
|14-Jul-2025 16:44:30.553|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|hbt|
|14-Jul-2025 16:44:30.473|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|HBT|
|14-Jul-2025 16:44:25.898|cmc_interface|Cmc Interface 1 Debug|SW_LOG|lab, MachineId: 1 \| MsgCounter: 49 \| Reference: 7000006_16 \| Result: 1 \| MatchLab: 003CMC00000004784827 \|Sorter: \||
|14-Jul-2025 16:44:25.897|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|lab\|49\|7000006_16\|1\|003CMC00000004784827\||
|14-Jul-2025 16:44:25.817|cmc_interface|Cmc Interface 1 Debug|SW_LOG|LAB, MachineId: 1 \| MsgCounter: 49 \| Reference: 7000006_16 \| Status: 1 \| MessageEvent 0: NOT CLASSIFIED \| WeightScale: 0 \||
|14-Jul-2025 16:44:25.817|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000006 new state: LABELLING|
|14-Jul-2025 16:44:25.817|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Reference 7000006_16:, Created dummy label for parcel|
|14-Jul-2025 16:44:25.794|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Reference 7000006_16:, Order Tote did not have valid DU so couldn't be linked with the parcel|
|14-Jul-2025 16:44:25.794|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Parcel, Reference 7000006_16: Parcel CMC000000047 created|
|14-Jul-2025 16:44:25.793|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|LAB\|49\|7000006_16\|1\|000\|0\||
|14-Jul-2025 16:44:25.320|cmc_interface|Cmc Interface 1 Debug|SW_LOG|end, MachineId: 1 \| MsgCounter: 48 \| Reference: 7000014_6 \||
|14-Jul-2025 16:44:25.320|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|end\|48\|7000014_6\||
|14-Jul-2025 16:44:25.239|cmc_interface|Cmc Interface 1 Debug|SW_LOG|END, MachineId: 1 \| MsgCounter: 48 \| Reference: 7000014_6 \| Status: 1 \| Message Event 0: NOT CLASSIFIED \| Height: 99 \| Length: 296 \| Width: 322 \| Area: 383510 \| WeightCarton: 187 \| WeightScale: 0 \| ToteDestination: 0 \||
|14-Jul-2025 16:44:25.239|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000014 new state: COMPLETED|
|14-Jul-2025 16:44:25.239|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|END\|48\|7000014_6\|1\|000\|99\|296\|322\|383510\|187\|0\|0\||
|14-Jul-2025 16:44:20.552|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|hbt|
|14-Jul-2025 16:44:20.472|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|HBT|
|14-Jul-2025 16:44:20.349|cmc_interface|Cmc Interface 1 Debug|SW_LOG|lab, MachineId: 1 \| MsgCounter: 47 \| Reference: 7000014_6 \| Result: 1 \| MatchLab: 003CMC00000004611208 \|Sorter: \||
|14-Jul-2025 16:44:20.349|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|lab\|47\|7000014_6\|1\|003CMC00000004611208\||
|14-Jul-2025 16:44:20.269|cmc_interface|Cmc Interface 1 Debug|SW_LOG|LAB, MachineId: 1 \| MsgCounter: 47 \| Reference: 7000014_6 \| Status: 1 \| MessageEvent 0: NOT CLASSIFIED \| WeightScale: 0 \||
|14-Jul-2025 16:44:20.269|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000014 new state: LABELLING|
|14-Jul-2025 16:44:20.269|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Reference 7000014_6:, Created dummy label for parcel|
|14-Jul-2025 16:44:20.246|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Reference 7000014_6:, Order Tote did not have valid DU so couldn't be linked with the parcel|
|14-Jul-2025 16:44:20.246|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Parcel, Reference 7000014_6: Parcel CMC000000046 created|
|14-Jul-2025 16:44:20.245|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|LAB\|47\|7000014_6\|1\|000\|0\||
|14-Jul-2025 16:44:20.221|cmc_interface|Cmc Interface 1 Debug|SW_LOG|out, MachineId: 1 \| MsgCounter: 46 \| Reference: 7000006_16 \||
|14-Jul-2025 16:44:20.221|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|out\|46\|7000006_16\||
|14-Jul-2025 16:44:20.141|cmc_interface|Cmc Interface 1 Debug|SW_LOG|OUT, MachineId: 1 \| MsgCounter: 46 \| Reference: 7000006_16 \| Result 1: EMPTY TOTE \| Barcode: 70000061 \| WeightIn: 8682 \| WeightOut: 4614 \||
|14-Jul-2025 16:44:20.140|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|OUT\|46\|7000006_16\|1\|70000061\|08682\|04614\||
|14-Jul-2025 16:44:19.785|cmc_interface|Cmc Interface 1 Debug|SW_LOG|end, MachineId: 1 \| MsgCounter: 45 \| Reference: 7000012_1 \||
|14-Jul-2025 16:44:19.785|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|end\|45\|7000012_1\||
|14-Jul-2025 16:44:19.705|cmc_interface|Cmc Interface 1 Debug|SW_LOG|END, MachineId: 1 \| MsgCounter: 45 \| Reference: 7000012_1 \| Status: 1 \| Message Event 0: NOT CLASSIFIED \| Height: 170 \| Length: 295 \| Width: 320 \| Area: 512100 \| WeightCarton: 250 \| WeightScale: 0 \| ToteDestination: 0 \||
|14-Jul-2025 16:44:19.705|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000012 new state: COMPLETED|
|14-Jul-2025 16:44:19.704|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|END\|45\|7000012_1\|1\|000\|170\|295\|320\|512100\|250\|0\|0\||
|14-Jul-2025 16:44:11.794|cmc_interface|Cmc Interface 1 Debug|SW_LOG|out, MachineId: 1 \| MsgCounter: 44 \| Reference: 7000014_6 \||
|14-Jul-2025 16:44:11.794|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|out\|44\|7000014_6\||
|14-Jul-2025 16:44:11.714|cmc_interface|Cmc Interface 1 Debug|SW_LOG|OUT, MachineId: 1 \| MsgCounter: 44 \| Reference: 7000014_6 \| Result 1: EMPTY TOTE \| Barcode: 70000141 \| WeightIn: 8790 \| WeightOut: 4624 \||
|14-Jul-2025 16:44:11.714|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|OUT\|44\|7000014_6\|1\|70000141\|08790\|04624\||
|14-Jul-2025 16:44:11.543|cmc_interface|Cmc Interface 1 Debug|SW_LOG|lab, MachineId: 1 \| MsgCounter: 43 \| Reference: 7000012_1 \| Result: 1 \| MatchLab: 003CMC00000004511775 \|Sorter: \||
|14-Jul-2025 16:44:11.542|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|lab\|43\|7000012_1\|1\|003CMC00000004511775\||
|14-Jul-2025 16:44:11.462|cmc_interface|Cmc Interface 1 Debug|SW_LOG|LAB, MachineId: 1 \| MsgCounter: 43 \| Reference: 7000012_1 \| Status: 1 \| MessageEvent 0: NOT CLASSIFIED \| WeightScale: 0 \||
|14-Jul-2025 16:44:11.462|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000012 new state: LABELLING|
|14-Jul-2025 16:44:11.462|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Reference 7000012_1:, Created dummy label for parcel|
|14-Jul-2025 16:44:11.441|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Reference 7000012_1:, Order Tote did not have valid DU so couldn't be linked with the parcel|
|14-Jul-2025 16:44:11.441|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Parcel, Reference 7000012_1: Parcel CMC000000045 created|
|14-Jul-2025 16:44:11.440|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|LAB\|43\|7000012_1\|1\|000\|0\||
|14-Jul-2025 16:44:10.553|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|hbt|
|14-Jul-2025 16:44:10.472|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|HBT|
|14-Jul-2025 16:44:04.788|cmc_interface|Cmc Interface 1 Debug|SW_LOG|out, MachineId: 1 \| MsgCounter: 42 \| Reference: 7000012_1 \||
|14-Jul-2025 16:44:04.788|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|out\|42\|7000012_1\||
|14-Jul-2025 16:44:04.707|cmc_interface|Cmc Interface 1 Debug|SW_LOG|OUT, MachineId: 1 \| MsgCounter: 42 \| Reference: 7000012_1 \| Result 1: EMPTY TOTE \| Barcode: 70000121 \| WeightIn: 8594 \| WeightOut: 4624 \||
|14-Jul-2025 16:44:04.707|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|OUT\|42\|7000012_1\|1\|70000121\|08594\|04624\||
|14-Jul-2025 16:44:00.552|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|hbt|
|14-Jul-2025 16:44:00.472|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|HBT|
|14-Jul-2025 16:43:53.822|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ack, MachineId: 1 \| MsgCounter: 41 \| Reference: 7000006_16 \| ToteValid: 1 \||
|14-Jul-2025 16:43:53.822|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|ack\|41\|7000006_16\|1\||
|14-Jul-2025 16:43:53.742|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ACK, MachineId: 1 \| MsgCounter: 41 \| Reference: 7000006_16 \| Result: 1 \| Message Reason 0: ITEM ACCEPTED \| Height: 121 \| Length: 314 \| Width: 301 \| Area: 419070 \| WeightCarton: 205 \| WeightScale: 6387 \||
|14-Jul-2025 16:43:53.742|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000006 new state: VALIDATED|
|14-Jul-2025 16:43:53.741|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Cmc commissioning params, Reference 7000006_16:Tote forced valid on ack|
|14-Jul-2025 16:43:53.741|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000006 new state: NOT VALIDATED|
|14-Jul-2025 16:43:53.741|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|ACK\|41\|7000006_16\|1\|0\|121\|314\|301\|419070\|205\|6387\||
|14-Jul-2025 16:43:50.553|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|hbt|
|14-Jul-2025 16:43:50.472|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|HBT|
|14-Jul-2025 16:43:47.512|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ack, MachineId: 1 \| MsgCounter: 40 \| Reference: 7000014_6 \| ToteValid: 1 \||
|14-Jul-2025 16:43:47.511|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|ack\|40\|7000014_6\|1\||
|14-Jul-2025 16:43:47.431|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ACK, MachineId: 1 \| MsgCounter: 40 \| Reference: 7000014_6 \| Result: 1 \| Message Reason 0: ITEM ACCEPTED \| Height: 99 \| Length: 296 \| Width: 323 \| Area: 383510 \| WeightCarton: 188 \| WeightScale: 6478 \||
|14-Jul-2025 16:43:47.431|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000014 new state: VALIDATED|
|14-Jul-2025 16:43:47.431|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Cmc commissioning params, Reference 7000014_6:Tote forced valid on ack|
|14-Jul-2025 16:43:47.431|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000014 new state: NOT VALIDATED|
|14-Jul-2025 16:43:47.431|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|ACK\|40\|7000014_6\|1\|0\|99\|296\|323\|383510\|188\|6478\||
|14-Jul-2025 16:43:43.893|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ack, MachineId: 1 \| MsgCounter: 39 \| Reference: 7000012_1 \| ToteValid: 1 \||
|14-Jul-2025 16:43:43.893|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|ack\|39\|7000012_1\|1\||
|14-Jul-2025 16:43:43.813|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ACK, MachineId: 1 \| MsgCounter: 39 \| Reference: 7000012_1 \| Result: 1 \| Message Reason 0: ITEM ACCEPTED \| Height: 170 \| Length: 295 \| Width: 321 \| Area: 512100 \| WeightCarton: 251 \| WeightScale: 6345 \||
|14-Jul-2025 16:43:43.813|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000012 new state: VALIDATED|
|14-Jul-2025 16:43:43.813|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Cmc commissioning params, Reference 7000012_1:Tote forced valid on ack|
|14-Jul-2025 16:43:43.813|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 7000012 new state: NOT VALIDATED|
|14-Jul-2025 16:43:43.813|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|ACK\|39\|7000012_1\|1\|0\|170\|295\|321\|512100\|251\|6345\||
|14-Jul-2025 16:43:41.421|cmc_interface|Cmc Interface 1 Debug|SW_LOG|enq, MachineId: 1 \| MsgCounter: 38 \| Reference: 7000006_16 \| Result: 1 \| Sorter: \| Barcode: 70000061 \| MatchLab: MatchLabTxt \| Description: Barcode:70000061;Reference:7000006_16 \| Hazmat: \| ToteWeight: 2500 \| Packvertizing: \||
|14-Jul-2025 16:43:41.421|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|enq\|38\|7000006_16\|1\|70000061\|MatchLabTxt\|Barcode:70000061;Reference:7000006_16\|2500\||
|14-Jul-2025 16:43:41.341|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ENQ, MachineId: 1 \| MsgCounter: 38 \| Barcode: 70000061 \||
|14-Jul-2025 16:43:41.341|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 70000061 new state: STARTED|
|14-Jul-2025 16:43:41.341|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Cmc commissioning params, Reference 7000006_16: Tote forced valid on enq|
|14-Jul-2025 16:43:41.340|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|ENQ\|38\|70000061\||
|14-Jul-2025 16:43:40.552|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|hbt|
|14-Jul-2025 16:43:40.472|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|HBT|
|14-Jul-2025 16:43:36.908|cmc_interface|Cmc Interface 1 Debug|SW_LOG|enq, MachineId: 1 \| MsgCounter: 37 \| Reference: 7000014_6 \| Result: 1 \| Sorter: \| Barcode: 70000141 \| MatchLab: MatchLabTxt \| Description: Barcode:70000141;Reference:7000014_6 \| Hazmat: \| ToteWeight: 2500 \| Packvertizing: \||
|14-Jul-2025 16:43:36.908|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|enq\|37\|7000014_6\|1\|70000141\|MatchLabTxt\|Barcode:70000141;Reference:7000014_6\|2500\||
|14-Jul-2025 16:43:36.828|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ENQ, MachineId: 1 \| MsgCounter: 37 \| Barcode: 70000141 \||
|14-Jul-2025 16:43:36.828|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 70000141 new state: STARTED|
|14-Jul-2025 16:43:36.828|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Cmc commissioning params, Reference 7000014_6: Tote forced valid on enq|
|14-Jul-2025 16:43:36.827|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|ENQ\|37\|70000141\||
|14-Jul-2025 16:43:33.404|cmc_interface|Cmc Interface 1 Debug|SW_LOG|enq, MachineId: 1 \| MsgCounter: 36 \| Reference: 7000012_1 \| Result: 1 \| Sorter: \| Barcode: 70000121 \| MatchLab: MatchLabTxt \| Description: Barcode:70000121;Reference:7000012_1 \| Hazmat: \| ToteWeight: 2500 \| Packvertizing: \||
|14-Jul-2025 16:43:33.404|cmc_interface|Cmc Interface 1 Communications|EVENT|WCS->CMC1: 1\|enq\|36\|7000012_1\|1\|70000121\|MatchLabTxt\|Barcode:70000121;Reference:7000012_1\|2500\||
|14-Jul-2025 16:43:33.324|cmc_interface|Cmc Interface 1 Debug|SW_LOG|ENQ, MachineId: 1 \| MsgCounter: 36 \| Barcode: 70000121 \||
|14-Jul-2025 16:43:33.324|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Tm, 70000121 new state: STARTED|
|14-Jul-2025 16:43:33.323|cmc_interface|Cmc Interface 1 Debug|SW_LOG|Cmc commissioning params, Reference 7000012_1: Tote forced valid on enq|
|14-Jul-2025 16:43:33.323|cmc_interface|Cmc Interface 1 Communications|EVENT|CMC1->WCS: 1\|ENQ\|36\|70000121\||
```
### no status message to WCS sent when machine in fault
