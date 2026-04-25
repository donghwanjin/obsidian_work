#matflo
[Setting up a new instance of Matflo for an existing project - Matflo - Global Site](https://wiki.dematic.net/pages/viewpage.action?spaceKey=MATFLO&title=Setting+up+a+new+instance+of+Matflo+for+an+existing+project#SettingupanewinstanceofMatfloforanexistingproject-DevelopmentEnvironmentOptions)
```
sudo gcp-admin-create-user dmxxxx
```

```
ssh dmxxxx@e3r1v03ivdm0059
```

## kallithea 
```
hg https://kallithea.daiad.dai.co.uk/Woolworths/dm1948
```
```
cd dmxxxx
```
```
mv .git* .vim* .hg* .gdb* .server* * ..
```
```
ls -la
```
make sure nothing left
```
cd ..
```
```
ls -la
```
```
rmdir dmxxxx
```
