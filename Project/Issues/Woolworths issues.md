---
type: issue
tags:
  - issue
project: Woolworths
---

### not able to login and error
![[Pasted image 20240702125719.png]]
solution : added line on profile.sh
- *export JWT_AUTHORIZED_PARTY=dm1948

### [P1948WCS-5263 : ERGOPAL > MCAP REMAINDER TASK - Causing issues with Stock Problem](https://jira.dematic.net/browse/P1948WCS-5263)

Tim : can you test Ergopall and check the pallet full functionality. I don't think it's working by assigning the remaining picks to the new task and du properly

MCAP REMAINDER Tasks after Pallet full causing issues.
**MCAP0000002972**
Example task where operator did a stock problem and revoked stock from screen and could not confirm completing the task. 
Tim seen on site.

# GTP 
- empty shipper
```
ut_send_tm_away <TmId>
```
- something in shipper then DU rebuild.

## Manual 
### we had to missing tm 
![[Pasted image 20240819022841.png]]

## PO number is not showing on all TM's to track PO it was taken from
[[P1948WCS-5981] ](https://jira.dematic.net/browse/P1948WCS-5981)![[Pasted image 20240920102509.png]]
![[Pasted image 20240920102458.png]]

![[Pasted image 20240920102528.png]]