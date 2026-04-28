# 1. Overview

## 1.1. Name

lpa.plugin - "Label Print and Apply"

## 1.2. Objective

An entity to represent LPA devices. To be a mapping between a logical location (e.g. conveyor location) and Printer record.

- The Printer represents the physical printer, should have a print queue configured on the server
- The LPA is a parent entity that maps the printer to a location. There may be multiple printers per LPA if we are applying multiple labels to the same TM simultaneously. E.g. on Aldi Victoria, all LPAs have two printers.

## 1.3. Scope

## 1.4. Assumptions

## 1.5. Dependencies

- printer.plugin

## 1.6. Glossary of terms

# 2. Functional Requirements

## 2.1. Input

## 2.2. Output

## 2.3. Logic

## 2.4. Error handling

# 3. Technical Design

## 3.1. Component design

### 3.1.1. Purpose

### 3.1.2. Interfaces

### 3.1.3. Data structures

#### 3.1.3.1. Extension to other plugins

##### 3.1.3.1.1. Printer

The lpa plugin adds the following field to Printer:

- PRINTER_REC_TYPE: CHAIN_REC_NO LpaRecNo;
- PRINTER_PrintFileToPrinter : PRINTER_PrintFileToPrinter
    - If the printer has an LPA and flag PrintTestMode is TRUE, then set "TestMode" to TRUE so that function returns before print command is triggered

##### 3.1.3.1.2. tpl

- TPL_PrintOutput
    - Set RemoveFile to FALSE if the printer has an LPA and RemoveFile is FALSE

  

#### 3.1.3.2. Creating LPA records

LPA records are fixed in code as they map to specific locations. They can be created using function LPA_DefineLpa(). If required, MDS can be used to configure any additional fields, track changes to "Description" etc.

The link between Printer → LPA is best managed by Printer.mds file.

**LPA_DefineLpa** Expand source

  

#### 3.1.3.3. Mapping from location to LPA record

The function "LPA_FindByLocation()" will find an LpaRecNo based on the LOCATION_TYPE passed into it.

**LPA_FormIdFromLocation** Expand source

  

**LPA_FindByLocation** Expand source

#### 3.1.3.4. Printing labels

Add function "LPA_PrintLabelsForTm()"

**LPA_PrintLabelsForTm()** Expand source

### 3.1.4. Algorithms

e.g. extension / plug in to mh_conv_dci_scheduler.

## 3.2. Data design

### 3.2.1. Database schema

The following table lists the key fields in the "LPA" entity:

| Type                             | Name          | Purpose / Notes                                                                                                                                                                                                                         |
| -------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Str LPA_ID_TYPE                  | Lpa Id        | ID (and index) of the Mh Route, in the form "LPA-<Location Name>".<br><br>E.g. if location is PCRE01LP01 then the LPA ID is: LPA-PCRE01LP01                                                                                             |
| enum LPA_STATE_TYPE              | State         | IN SERVICE<br><br>LTOS = "long term out of service"                                                                                                                                                                                     |
| Str LPA_DESC_TYPE                | Description   | The description of the LPA, e.g. "Ambient inbound pallet LPA"                                                                                                                                                                           |
| LOCATION_TYPE                    | Location      | Location that the LPA is linked to                                                                                                                                                                                                      |
| enum LPA_MODE_TYPE               | LpaMode       | Values:<br><br>- LABEL - print and apply the label as standard<br>- TEST_LABEL - print and apply a test label<br>- BYPASS - do not print any label, bypass the LPA<br>- (plugin point for additional modes as per project requirements) |
| enum LPA_TEST_MODE_TYPE          | RemoveFile    | If TRUE, the label file will be deleted following the print command                                                                                                                                                                     |
| BOOLEAN                          | PrintTestMode | If TRUE, no print command will be sent to the printer (label generated only)                                                                                                                                                            |
| (non DB) MH_DCI_FAULT_STATE_TYPE | DciFaultState | If "mh_conv_dci" is included, maps to the fault state of the "Location" if it is a DCI location (e.g. due to STAT), using function MH_CONV_DCI_GetFaultState().                                                                         |

### 3.2.2. Data flow

Flow of data through the db

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

# 4. Open Issues

# 5. Risk Register