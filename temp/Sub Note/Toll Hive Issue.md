---
type: issue
project: Toll Hive
tags:
  - issue
  - project
---

### CMC dummy label not printing
commented 3 conditions

![[Pasted image 20250702153303.png]]


![[Pasted image 20250702153305.png]]


![[Pasted image 20250702153310.png]]

### modified: shared_repo (new commits)
![[Pasted image 20250711090058.png]]
``` bash
cd ~/shared_repo/Plugin

git restore .

cd ~

git submodule update
```

### IAT issue
RetrievalCanBeDone
DetermineTmDestination
TM_MHE_CalcSelectedDestination
TM_CalcSelectedDestination
MS_LOC_CalcSelectedDestination
MS_DCI_IAT_OutfeedPathOk
![[Pasted image 20250711090359.png]]

![[Pasted image 20250711132645.png]]The process was making the move request, waking the various shuttle and elevator processes, then clearing the selected destination due to the if statement above. 

However, by clearing the selected destination too early, the shuttle and elevator processes then failed to complete the move.

### Unexpected Item
```sql
SELECT * FROM mi_tm
WHERE event_time > '2025-12-11'
AND to_value = 'Unexpected Item'
ORDER BY event_time
```

60007826 : mh_cc_dci_07_log_cusapaup028_11_dec_2025.log:11-Dec 19:21:26.482 mh_dci_comms_CC07 MH_DCI_MSG MFC <- CC07 : /RTUCACC07WCS17236OK01NG0228..........................................70002512..................00000000000000000000UD..............00......000000................................................................................##

7000849 : OB manager

7000675 : mh_ms_dci_27_log_cusapaup028_11_dec_2025.log:11-Dec 07:24:05.480 mh_dci_comms_MS27 MH_DCI_MSG MFC <- MS27 : /RTUCAMS27WCS12979OK01NG0144..............MSAI27CL02PS12??????????????70006752..............TT0100000000000000000000MA000000000000000000000000##

60007530 : mh_cc_dci_04_log_cusapaup028_11_dec_2025.log:11-Dec 16:44:05.880 mh_dci_comms_CC04 MH_DCI_MSG MFC -> CC04 : /RTUMIWCS1CC048325OK01NG0228..............CCOB03DP01....CCOB03DP02....60007530..............CA0106000400037000010800OK......................000000................................................................................##
mh_cc_dci_04_log_cusapaup028_11_dec_2025.log:11-Dec 16:44:46.125 mh_dci_comms_CC04 MH_DCI_MSG MFC <- CC04 : /.TUDRCC04WCS14813OK01NG0228..............CCOB03DP02..................60007530..................00000000000000000000OK..............00......000000................................................................................##
mh_cc_dci_04_log_cusapaup028_11_dec_2025.log:11-Dec 16:44:57.313 mh_dci_comms_CC04 MH_DCI_MSG MFC <- CC04 : /.TUDRCC04WCS14814OK01NG0228..............CCOB03DP03..................60007530..................00000000000000000000OK..............00......000000................................................................................##
mh_cc_dci_04_log_cusapaup028_11_dec_2025.log:11-Dec 16:46:58.106 mh_dci_comms_CC04 MH_DCI_MSG MFC <- CC04 : /.TUDRCC04WCS14815OK01NG0228..............CCOB03DP01..................60007530..................00000000000000000000OK..............00......000000................................................................................##
mh_cc_dci_04_log_cusapaup028_11_dec_2025.log:11-Dec 16:46:58.110 mh_dci_comms_CC04 MH_DCI_MSG MFC -> CC04 : /RTUMIWCS1CC048331OK01NG0228..............CCOB03DP01....CCOB03DP02....60007530..............CA0106000400037000010800OK......................000000................................................................................##

50004722:/RTUCAMS27WCS18293OK01NG0144..............MSAI27CL03PS12??????????????50004722..............TT0100000000000000000000MA000000000000000000000000##

60007530
50004722
7000745
7000251
7000906
60007845
60007847
60007096
60007824