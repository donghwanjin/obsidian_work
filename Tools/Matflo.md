[[PICK_SetUnsatisfiable.canvas|PICK_SetUnsatisfiable]]
[[SAD Send process.canvas|SAD Send process]]
[[New project]]

### vault request 1password
https://kion.sharepoint.com/sites/KION1Password

### request Gitlab permission
https://jira.dematic.net/servicedesk/customer/portal/2/create/77
if you fill it out and include this link [https://gitlab.com/dematic/matflo/matflo-c/aldi/aldi-victoria-2306-wcs](https://gitlab.com/dematic/matflo/matflo-c/aldi/aldi-victoria-2306-wcs "https://gitlab.com/dematic/matflo/matflo-c/aldi/aldi-victoria-2306-wcs")
you should be able to get access by tomorrow

TM_HasPutawayProblems
[[Issue]]
### Jumping others PDE
![[Pasted image 20240702103857.png]]
### how to increase para more then max value
```c
REC_NO ParRecNo = ParMemRec [ GTP_WEIGHT_CHECK_TOLERANCE ].ParameterRecNo;

ParRec [ ParRecNo ].Format.IntegerValue = 100000;
```
### Clear msg queue
```
ut_clear_msg_queue <MSG_QUEUE_INDEX>
ut_clear_msg_queue ALL
```
### ut_ipcremove
Don`t ever use in site
```
make
make fresh : always do 
sm_sysman; make fresh; sm_startup -y


make web_api_cgi

make tramming_task_manager
sm_stop_start tramming_task_manager

sm_sysman.old
```

### Reject logic
[[Untitled 9.canvas|Reject logic]]

#### C tags
support /support directory
```

added "$ROOTDIR/support/.tags,$ROOTDIR/support/tags"
map <F8> :!ut_ctags<CR>
map! <F8> <ESC>:!ut_ctags<CR>
" It's probably better to put your tags into a file called ".tags" rather than "tags" so
" that commands like "grep xxx *" don't search through the .tags file.
set tags=./tags,./TAGS,tags,TAGS,.tags,$SRC/.tags,$ROOTDIR/.tags,$ROOTDIR/.TAGS,~$ROOTDIR/support/.tags,$ROOTDIR/support/tags,/.tags,~/.TAGS

```

### how to increase db size

check 
```
env | grep DB
end | grep SMALL
```
download 
```
compile_commands.json
```
make fresh from other terminal
upload 
```
compile_commands.json
```

## how to snap shot the DB
- /support
    sh ut_db_backup.sh <name>
    sh ut_db_restore.sh <name>
source
- ./ut_db.sh archive -o <name> --pigz it is smaller

# Crash report

./support/crash_report_parse.awk ../err/<log name>

bt-web_api_cgi_dm19483946407-3946407.log.1722494456.seen

  ../../home/core
  cd ../../home/core
  ls -ltrh
  file core-6-8004-700-850973-1743815232
  gdb -tui /daiapp/bin/mh_dci_plc_CC64_2  core-6-8004-700-3349151-1744178446

# Restart virtual server
1. sm_if_online
2. manually remove the virtual ip
3. sm_if_online

# Label log
daiapp@dai-wcs02:~/work/tmp> pwd  
/daiapp/work/tmp
*.tplout are the label files

# Site issue procedure
- Check the alarms and alerts page for
    - failed/gone processes - try to restart if they don't restart then debug to see why
    - delayed processes - debug - could be lock/grab issue use printlocks 
    - file system space
- Check DCI connection
- alarm and events log
- Msg queues
# check data


### resend host message
wow_host_interface_lib.c
LOAD_SendLoadStatus


Lock first and Glab after

GL_EnqLock (LOCKS, )

