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