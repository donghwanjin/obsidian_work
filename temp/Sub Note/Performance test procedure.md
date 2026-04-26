---
type: note
---

upload snapshot 
```bash
bash ut_db.sh restore dvf_volume_test_v1.tar.xz --force
```
startup recovery mode
```bash
sm_startup --y --recovery
```
setup user
```bash
ut_create_backdoor djin djin
```
setup parameter for MH_EMU_REMOTE_HOST
get IP at Zaclare client tunnel IP

switch to active mode
```
sm_sysman
A
Y 
```

run script srm
```
dj
```

run script oi sim
```
oi_sim_screens
```




```
grep -a -E "TURP|DTMI" *dt*30_mar* | awk '
{
   if (match($0,/([0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]+)/,t)) {

       time=t[1]

       split(time,a,":")
       split(a[3],b,".")
       ts=a[1]*3600 + a[2]*60 + b[1] + b[2]/1000

       if (match($0,/\.[0-9]{8}\./)) {
           id=substr($0,RSTART+1,8)

           if ($0 ~ /TURP/) {
               req[id]=ts
               req_time[id]=time
           }

           if ($0 ~ /DTMI/ && id in req) {
               delay=ts-req[id]
               printf "%-10s %-15s %-15s %.3f\n",id,req_time[id],time,delay
           }
       }
   }
}'

```