---
type: reference
tags:
  - tool
---

#Git 

### PAT
```
🔐β 6cWKn8ChIKoH+ZYmaYdGJBsuoWGtPOBYPnk0YieeOdx5N/Rk/LtqsrG3z1tcv9OKh2uBWCnGuGwnMfdXCpv0LYbDz6t2I+/pxCDaGrxD6HlTwU4w6kWicy/XhpsQFZFRPAG3w3fuXSPEnHBRVNI= 🔐
```
### test
```
git branch
```
```
git log
```

```
git diff --stat
```
```
git blame -L '/LABEL_PrintLabelByType/,/^}/' label_toll_hive_lib.c | head -n 100
```

```
git log --grep="P2301TH-2227" --name-only
```
then you can grab < commit id > 
```
git show 34d4997379e767356ad415426f086694a3fd078d
```

Delete remote branch
```
git push origin --delete uc-gen/CHL-INB-UC320-UC321
```

### Create personal project

![[Pasted image 20260427111513.png]]

```
git init
```

```
git add .
```

```
git commit -m "Initial commit"
```

```
ssh-keygen -t ed25519 -C "donghwan.jin"
```

```
cat ~/.ssh/id_ed25519.pub
```

copy and paste keygen to your gitlab

```
git config --global user.email "donghwan.jin@dematic.com"
```

```
git config --global user.name "donghwan.jin"
```

```
git remote set-url origin https://gitlab.com/donghwan.jin/testrailhelper.git
```

```
git push origin master
```

