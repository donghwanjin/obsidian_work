# General

### Make New Branch
```
hg update Developments  
hg pull  
hg update  
hg branch P1948WCS-5794

( change code )

make fresh

hg diff ( see changed code )  
hg commit -u <user> -m "<commit message>"  
hg push --new-branch
```

### Close Branch
	 hg commit -u donghwan.jin --close-coupang_label -m "Resolved merge conflicts and closed branch"

### how to get log for the function
```
hg blame -ud <FileName>
hg blame -ud loc_nail_prod_lib_ref.c | grep -A 40 "MANUAL_LOC_NailProd"
```
# Project
## Release Procedure [[YoungNam]]

![[Pasted image 20240613113808.png]]

```
hg Merge
hg
df

```
- All site machines should be on the production branch
- All office dev should either be on default branch or a seperate branch but not on the production branch
- To do a release merge default into production
- Change version number in young_nam.plugin
- add a tag on the production branch with the release version

eg .

 `hg checkout production
 `hg merge default
 `hg commit -m "merge default into production"
 `vim young_nam.plugin (Change the "beta" version in the plugin)
 `make fresh
 `hg commit -m "release v1.0.0 beta-1"
 `hg tag -u jonathan.laver "v1.0.0 beta-1"
 `hg bundle --base "v1.0.0 beta-1" yn.bundle

- Note: the "--base" version used in hg bundle should not be the one you are currently releasing! Use an earlier base like "beta-1" as otherwise running hg unbundle on the production system will complain about unknown changesets.

 `hg unbundle yn.bundle

- Note: make sure the new "yn.bundle" file created by hg bundle above exists on the production system. I used vscode to drag and drop it to the /dai directory as I couldn't use the standard "scp" command from the production system.


## Release Procedure [[Chilsung]]

#### Build a Release

So, to build a release, start on production:
1. Check for any changes which might have been done on site. If any found bring them back to where you're releasing from.
    
    `hg diff`
    
2. Put changes to your PDE or where you want to get the code from
3. Do any pushing and pulling for all the changes from site.
4. Make sure we are releasing where we want to release from
5. Change version number at this point (usually increate SYS_ISSUE number by 1)
    
    `vi chilsung.plugin`
    
    `SYS_RELEASE`
    
    `SYS_ISSUE`
    
    `SYS_VERSION`
    
6. Commit the version change
    
    `hg commit -m "changed version to 1.0K"`
    
7. tag for the version (**please** be consistent with the format!)
    
    `hg tag -r tip v1.0K`

#### Release
1. From where you are releasing, make sure we are updated to the tag we are releasing
    
    `hg update v1.0K`
    
2. From Production find the changeset that is the most recent 
    
    `hg heads`
    
3. Bundle up the changes, if first time see below
    
    `hg bundle --base jjjjjjjjjjj Release_1.0K.hg`
    
4. Copy the file Release_1.0K.hg across to production...
5. On Production, TAKE A DB BACKUP!
6. Shutdown
    
    `sm_sysman`
    
7. Unbundle
    
    `hg unbundle Release_1.0K.hg`
    
8. Update to the tag
    
    `hg up v1.0K -C`
    
9. Make
    
    `make fresh`
    
10. Startup
    
    `sm_startup`

#### Force Alias Update using ARPing (Post Failover)
If post failover and start up WCS fails to connect to the ESS PLC, ARPing has not been sent out correctly on start up (Known issue, needs to be resolved). To re-enable the connection and force the ARPing update, run the following command:

`arping -I eno7 -c 1 -s 10.121.142.10 10.121.142.254`


#### Remove/Set Database Protections
On system start-up, the process may run database conversion operations in a situation where a field has been changed, added or removed in one of the Matflo databases. This can create multiple *.backup files in the ~/database/master directory, which can cause the system to fill up quickly. To remove these files, we need to remove the protections on the database files set by the software; when doing this, **BE VERY CAREFUL ON WHAT YOU DELETE! CHECK TWICE, DELETE ONCE! MAKE SURE TO SET THE PROTECTIONS BACK AFTER YOU ARE DONE!**

1. In the source directory, run the following:
    
    `make ut_db_protection`
    
2. Remove the database protections:
    
    `ut_db_protection remove`
    
3. Go to the database master directory:
    
    `cd ~/database/master`
    
4. CHECK what we are deleting first!
    
    `ls -haltr *.backup`
    
5. Delete the *.backup files:
    
    `rm *.backup`
    
6. SET the protections back:
    
    `ut_db_protection set`



647837