# 1. Overview

## 1.1. Name

## 1.2. Objective

## 1.3. Scope

## 1.4. Assumptions

## 1.5. Dependencies

## 1.6. Glossary of terms

# 2. Functional Requirements

## 2.1. Input

## 2.2. Ouput

## 2.3. Logic

## 2.4. Error handling

# 3. Technical Design

## 3.1. Component design

### 3.1.1. Purpose

### 3.1.2. Interfaces

### 3.1.3. Data structures

### 3.1.4. Algorithms

## 3.2. Data design

### 3.2.1. Flex sorter layout and locations
![[Pasted image 20260428111647.png]]
  
![[Pasted image 20260428111705.png]]
  

### 3.2.2. DCI location names

| Sorter                       | FlexSort Messages                       | WCS messages     | Type             | Name                             | Comments                                                                                                                       |
| ---------------------------- | --------------------------------------- | ---------------- | ---------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Ambient ST11                 | STAT<br><br>TUDR<br><br>TUEX            | STRQ<br><br>TUMI | Scanner / induct | STIA11IS01                       | The tray barcode is scanned. WCS selects DMS location for storage. The tray is diverted into lane depends on the aisle chosen. |
| STAT<br><br>TURP<br><br>TUEX | STRQ                                    | Divert lanes     | STLN110001       | Feeds Ambient Storage Aisle 6, 7 |                                                                                                                                |
| STLN110002                   | Feeds Ambient Storage Aisle 5, 4        |                  |                  |                                  |                                                                                                                                |
| STLN110003                   | Feeds Ambient Storage Aisle 3, 2        |                  |                  |                                  |                                                                                                                                |
| STLN110004                   | Feeds Ambient Storage Aisle 1           |                  |                  |                                  |                                                                                                                                |
| TURP<br><br>TUNO             |                                         | Recirculation    | STLN110099       |                                  |                                                                                                                                |
| Chilled ST61                 | STAT<br><br>TUDR<br><br>TUEX            | STRQ<br><br>TUMI | Scanner / induct | STIA61IS01                       | The tray barcode is scanned. WCS selects DMS location for storage. The tray is diverted into lane depends on the aisle chosen. |
| STAT<br><br>TURP<br><br>TUEX | STRQ                                    | Divert lanes     | STLN610001       | Feeds Chilled Storage Aisle 66   |                                                                                                                                |
| STLN610002                   | Feeds Chilled Storage Aisle 64, 65      |                  |                  |                                  |                                                                                                                                |
| STLN610003                   | Feeds Chilled Storage Aisle 62, 63      |                  |                  |                                  |                                                                                                                                |
| STLN610004 (future only)     | Feeds Chilled Storage Aisle 61 (future) |                  |                  |                                  |                                                                                                                                |
| TURP<br><br>TUNO             |                                         | Recirculation    | STLN610099       |                                  |                                                                                                                                |

  

### 3.2.3. Database schema

Key fields and the tables they are in

### 3.2.4. Data flow

Please see general description here, which described the ambient sorter only: [FMCF-RS TD: Flex Sorter#Datadesign](https://wiki.dematic.net/spaces/MP/pages/861932392/FMCF-RS+TD+Flex+Sorter#FMCFRSTD:FlexSorter-Datadesign)

  

#### 3.2.4.1. Example messaging (from New Balance)

##### 3.2.4.1.1. Happy path

| **17-Jun-2025 00:03:44.764** | **mh_dci_comms_STD1** | **Linear Sorter DCI Communications** | **MH_DCI_MSG** | **MFC <- STD1 : /.TUDRSTD1WES17525OK01NG0184[{"CURRLOC":"STIA01IS01","TUIDENT":"T0172354","TUTYPE":"TU01","TULENGTH":711,"TUWIDTH":501,"TUHEIGHT":325,"TUWEIGHT":3845,"TRACKID":"5874","EVCODE":"OK"}]##**          |
| ---------------------------- | --------------------- | ------------------------------------ | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **17-Jun-2025 00:03:45.220** | **mh_dci_comms_STD1** | **Linear Sorter DCI Communications** | **MH_DCI_MSG** | **MFC -> STD1 : /RTUMIWES1STD19767OK01NG0193[{"CURRLOC":"STIA01IS01","DESTLOC":"STLN010003","TUIDENT":"T0172354","TUTYPE":"TU01","TULENGTH":711,"TUHEIGHT":325,"TUWEIGHT":3845,"EVCODE":"OK","TRACKID":"5874"}]##** |
| **17-Jun-2025 00:04:18.688** | **mh_dci_comms_STM1** | **Linear Sorter DCI Communications** | **MH_DCI_MSG** | **MFC <- STM1 : /RTURPSTM1WES14977OK01NG0161[{"CURRLOC":"STLN010003","DESTLOC":"STLN010003","TUIDENT":"T0172354","TUTYPE":"TU01","TRACKID":"5874","DICODE":"ND","EVCODE":"OK"}]##**                                 |

  

##### 3.2.4.1.2. Lane full

| **17-Jun-2025 00:05:48.496** | **MFC <- STD1 : /.TUDRSTD1WES17533OK01NG0184[{"CURRLOC":"STIA01IS01","TUIDENT":"T0151870","TUTYPE":"TU01","TULENGTH":711,"TUWIDTH":501,"TUHEIGHT":325,"TUWEIGHT":3887,"TRACKID":"5879","EVCODE":"OK"}]##**          |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **17-Jun-2025 00:05:48.501** | **MFC -> STD1 : /RTUMIWES1STD19772OK01NG0193[{"CURRLOC":"STIA01IS01","DESTLOC":"STLN010001","TUIDENT":"T0151870","TUTYPE":"TU01","TULENGTH":711,"TUHEIGHT":325,"TUWEIGHT":3887,"EVCODE":"OK","TRACKID":"5879"}]##** |
| **17-Jun-2025 00:06:22.620** | **MFC <- STM1 : /RTUEXSTM1WES15004OK01NG0175[{"CURRLOC":"STLN010000","DESTLOC":"STLN010001","TUIDENT":"T0151870","TUTYPE":"TU01","TRACKID":"5879","DICODE":"NO","RECIRR":"LF","EVCODE":"DN"}]##**                   |
| **17-Jun-2025 00:10:52.680** | **MFC <- STD1 : /.TUDRSTD1WES17553OK01NG0184[{"CURRLOC":"STIA01IS01","TUIDENT":"T0151870","TUTYPE":"TU01","TULENGTH":698,"TUWIDTH":501,"TUHEIGHT":325,"TUWEIGHT":3895,"TRACKID":"5887","EVCODE":"OK"}]##**          |

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

# 4. Open Issues

# 5. Risk Register