# 1. Overview

## 1.1. Name

Host Interface

## 1.2. Objective

Create the following messaging

- Heartbeat Message
- Product Master Data Message (IN to WCS)
- Product Hold Message (IN to WCS)
- Stock Notification Message (IN to WCS)
- Receiving Status Message (OUT from WCS)
- Stock Delivered Message (OUT from WCS)
- Host Order Message (IN to WCS)
- Order Status Update Message (OUT from WCS)
- Host Load Route Message (IN to WCS)
- DU Status Message (OUT from WCS)
- Stock Data Adjust Message (OUT from WCS)
- Stock Balance Request Message (IN to WCS)
- Stock Balance Message (OUT from WCS)

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

Implement the core messaging from the following spec. Install any core plugins there are to do this, but don't include any of the project specific changes to these. 

\[daifls01.daiad.dai.co.uk](http://daifls01.daiad.dai.co.uk/)\DAI_Projects\2306 Aldi Victoria\Documentation\Working Masters\HIS

### 3.1.2. Interfaces

### 3.1.3. Data structures

### 3.1.4. Algorithms

## 3.2. Data design

### 3.2.1. Database schema

Key fields and the tables they are in

### 3.2.2. Data flow

#### 3.2.2.1. Heartbeat Message

#### 3.2.2.2. Product Master Data Message (IN to WCS)

temperatureClass 

storageArea - This is a product field for using whether the stock will be in the handover location. Add in an enum on product for this.

productHierarchyId - Find or create a product hierarchy record for ID and link to product 

  

Aldi doesn't track SKU, Sku ID will be the same as Product ID. Add function which decides if a new SKU should be created or latest one is updated.

Create a new SKU when

1. Dims/Weight changes
2. TiHi changes

#### 3.2.2.3. Product Hold Message (IN to WCS)

Create / Delete a product Hold record on receipt of this message.

Hold = true create a new record

Hold = false look for a matching record to delete

#### 3.2.2.4. Stock Notification Message (IN to WCS)

Create TM and Stock from message

TM ID = Container ID

Tm Sub Type = add a host field string to Tm Sub Type and match based on that

Use below table to create TM in a location based on the product fields, if no drop loc found then TM doesn't have a location (to be seen on the conveyor)


| Drop Loc            | Temperature Class | Storage Area |
| ------------------- | ----------------- | ------------ |
| DL-AMB-MAN-INBOUND  | AMBIENT           | MANUAL       |
| DL-AMB-AUTO-INBOUND | AMBIENT           | DMS          |
| DL-FRZ-MAN-INBOUND  | FROZEN            | MANUAL       |
| DL-FRZ-AUTO-INBOUND | FROZEN            | DMS          |

> [!warning]
> countryOfOrigin = Just add this from a project plugin, no need for sku_country


#### 3.2.2.5. Receiving Status Message (OUT from WCS)

#### 3.2.2.6. Stock Delivered Message (OUT from WCS)

#### 3.2.2.7. Host Order Message (IN to WCS)

orderType have a field on the order type table for the host string and match the order type record.

#### 3.2.2.8. Order Status Update Message (OUT from WCS)

#### 3.2.2.9. Host Load Route Message (IN to WCS)

#### 3.2.2.10. DU Status Message (OUT from WCS)

**Status** - Need to a conversion function from DU status to host DU status. Matflo will have DU in state MARSHALLED for the DESPATCHED du status message

**ContainerId** - TM ID ![(warning)](https://wiki.dematic.net/s/-95tr7d/9111/1hjr1ir/_/images/icons/emoticons/warning.svg)  TBC

#### 3.2.2.11. Stock Data Adjust Message (OUT from WCS)

**Sku** **ID** - this will be the produce Id

#### 3.2.2.12. Stock Balance Request Message (IN to WCS)

#### 3.2.2.13. Stock Balance Message (OUT from WCS)

**Sku** **ID** - this will be the produce Id

  

## 3.3. Security considerations

## 3.4. Performance considerations

## 3.5. Scalability considerations

## 3.6. Extensibility considerations

## 3.7. Testing strategy

## 3.8. Deployment strategy

# 4. Open Issues

# 5. Risk Register