---
project: Woolworths
tags:
  - issue
Jira: P1948WCS-7482
---
this is core logic. so need to follow up with UK team and make sure it update

![[Pasted image 20260427102019.png]]

![[Pasted image 20260427102027.png]]

You could and you're thinking along the right lines. I actually put the lock later on but I included validation checks when I did. The problem is that between the creation you highlighted and the function call below, something was deleting the tramming task. (probably TM_CancelMove)

![[Pasted image 20260427102144.png]]