---
type: reference
tags:
  - tool
---

#Git 

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
git config --global user.email "donghwan.jin@dematic.com"
```

```
git config --global user.name "donghwan.jin"
```

```
git remote add origin https://gitlab.com/donghwan.jin/testrailhelper.git
```

Issue 
djin@NBDAU25VXDTL:/mnt/c/Users/a0006235/Documents/Aldi/test_rail/Scripts/testrail$ git push origin master
Username for 'https://gitlab.com': donghwan.jin
Password for 'https://donghwan.jin@gitlab.com':
remote: HTTP Basic: Access denied. If a password was provided for Git authentication, the password was incorrect or you're required to use a token instead of a password. If a token was provided, it was either incorrect, expired, or improperly scoped. See https://gitlab.com/help/topics/git/troubleshooting_git.md#error-on-git-fetch-http-basic-access-denied
fatal: Authentication failed for 'https://gitlab.com/donghwan.jin/testrailhelper.git/'

