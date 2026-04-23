# virtual server issue
vim dai-wcs01.sh
traceroute 10.82.169.93
vim dai-wcs01.sh
echo $WMS_IP_ADDRESS
sudo tail -400 /var/dmesg
sudo journalctl --since="2024-08-02 12:00:00"
sudo journalctl --since="2024-08-02 16:02:24" | grep ens10f0
sudo journalctl --since="2024-08-02 16:02:24"
dmesg | grep -i usb
sudo journalctl -u NetworkManager 
tail -f /var/log/syslog
tail -f /var/log/messages
sudo tail -n 200 /var/log/messages

## Symbolic link
[Link](https://www.liquidweb.com/help-docs/creating-and-removing-symbolic-links-symlinks/#:~:text=A%20symbolic%20link%2C%20sometimes%20called,or%20folders%20with%20long%20paths. "https://www.liquidweb.com/help-docs/creating-and-removing-symbolic-links-symlinks/#:~:text=a%20symbolic%20link%2c%20sometimes%20called,or%20folders%20with%20long%20paths.")

ln -s /daiapp/database_backups db_archive

## tcp dump
```
screen -S tcpdump
sudo tcpdump src or dst 10.82.202.10 -w logging/master/ptl_cap_0110.pcap &

screen -r tcpdump
exit
back up pcap file
delete file
screen -S tcpdump
sudo tcpdump src or dst 10:82.202.10 -w ../logging/master/ptl_cap_0110.pcap &
```

## GDB
```
screen 
gdb /daiapp/binmh_cc_gtp
attach <processID>
where
detach
quit
exit
```

PTL disconnection
```
grep "DDI Q database full" *10_jan*
```


C tags

``` bash
view .vimrc  
map <F8> :!ut_ctags<CR>  
map! <F8> <ESC>:!ut_ctags<CR>  
" It's probably better to put your tags into a file called ".tags" rather than "tags" so  
" that commands like "grep xxx *" don't search through the .tags file.  
set tags=./tags,./TAGS,tags,TAGS,.tags,$SRC/.tags,$ROOTDIR/.tags,$ROOTDIR/.TAGS,~/.tags,~/.TAGS
```