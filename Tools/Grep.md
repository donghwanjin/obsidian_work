# useful
cat mh_cc_dci_log_dai-wcs02_30_dec_2024.log | grep TU-051-773892 | grep -v -e TUDR
cat mh_cc_dci_log_dai-wcs02_30_dec_2024.log | grep BF | grep TUEX
cat mh_ms_dci_24_log_dai-wcs01_17_jan_2025.log | grep RTURP | grep -Eo "TU-WCS-[0-9]{7}" | sort | uniq -c

grep PCMA01NP13 mh_pc_dci_log_dai-wcs01_22_jan_2025.log | grep TURP | tail -n 10

cat mh_ms_dci_*_log_dai-wcs02_08_feb_2025.log | grep -Eo "MSAI[0-9]{2}CL01DS12" | sort | uniq -c

Contour sort
```bash
grep "TUDR.*##" mh_cc_dci_*_log_*.log \

| awk -F'/' '{raw="/" $2; print substr(raw,119,14)}' \

| sort | uniq -c | sort -nr
```

```
grep BO *01_sep* | grep CA02 | sed -E 's/.*(MS[2][5-9]).*/\1/' | sort -tS -k2n | uniq -c
```

replace the whole line with just the first `MS25–MS29` found.
```
sed -E 's/.*(MS[2][5-9]).*/\1/' 
``` 
1. `s/.../.../` → this is the **substitute command** in `sed` (replace pattern).
    
    - Format: `s/<pattern>/<replacement>/`
        
2. `.*(MS[2][5-9]).*` → this is the **pattern**:
    
    - `.*` → matches any characters **before** the MS code.
        
    - `(MS[2][5-9])` → the parentheses **capture** the first occurrence of `MS25–MS29`.
        
    - `.*` → matches any characters **after** the MS code.
        
3. `\1` → refers to the **first captured group**, i.e., whatever was matched inside `( )`.



```
cut -d ' ' -f5 OEL_dai-wcs01_03-Mar-2025.log | sort | uniq -c | sort -rn | head -n20
```
```
grep TM_FIELD_CHANGE OEL_dai-wcs01_25-Feb-2025.log | cut -d ' ' -f11| sort | uniq -c | sort -rn | head -n20
```
```
grep TM_FIELD_CHANGE OEL_dai-wcs01_14-Mar-2025.log | grep "mh_dci_plc_CC63_1" | grep -Eo "change_field: '[A-Za-z_ ]+'" | sort | uniq -c | sort -hr
```


### TM field change event
```
grep TM_FIELD_CHANGE OEL_dai-wcs01_08-Jul-2025.log | grep -Eo "change_field: '[A-Za-z_ ]+'" | sort | uniq -c | sort -hr
```

● daiapp@dai-wcs01:~/oel/master> grep TM_FIELD_CHANGE OEL_dai-wcs01_08-Jul-2025.log | grep -Eo "change_field: '[A-Za-z_ ]+'" | sort | uniq -c | sort -hr  
598688 change_field: 'Location'  
163780 change_field: 'Move Priority'  
125080 change_field: 'Mcap Task Id'  
  41946 change_field: 'Mh Cc Ret Group Id'  
  41688 change_field: 'Mh Ms Ret Group Id'  
  34975 change_field: 'Measured Height'  
  26783 change_field: 'Measured Width'  
  26783 change_field: 'Measured Depth'  
  26437 change_field: 'Height Band'
```
grep "change_field: 'Mcap Task Id'" OEL_dai-wcs01_08-Jul-2025.log  | grep -Po "from_value: '\K[^']+" | sort | uniq -c | sort -nr | head -n 10
```
● daiapp@dai-wcs01:~/oel/master> grep "change_field: 'Mcap Task Id'" OEL_dai-wcs01_08-Jul-2025.log  | grep -Po "from_value: '\K[^']+" | sort | uniq -c | sort -nr | head -n 10  
   8870 DU-2900715  
   2223 DU-2901684  
   1764 DU-2901263  
   1589 DU-2903506  
   1136 DU-2904170  
   1111 DU-2903128  
   1097 DU-2903620  
   1000 DU-2903706  
    979 DU-2903760  
    922 DU-2903595

### Barcode template /work/tmp
first find tm barcode loc update time
'YYYY-MM-DD HH:MM'
'1day ago'
```
find . -type f -newermt "today 15:30" -exec grep -l "795120000000939728" {} +
```
```
find . -type f -newermt "1day ago 15:30" -exec grep -l "795120000000939728" {} +
```

101942
 # Options:

- `-i` : Ignore case (case-insensitive search)
- `-w` : Match whole word
- `-n` : Show line numbers
- `-c` : Count the number of matching lines
- `-v` : Invert match, show lines that do not match
- `-r` : Search files recursively in subdirectories
- `-l` : Show only the filenames of matching files
- `-h` : Do not show filenames in output
- `-e pattern` : Use pattern as the search pattern
- `-f file` : Read the search pattern from a file
- `-E` : Interpret the pattern as an extended regular expression
- `-P` : Interpret the pattern as a Perl-compatible regular expression
- `-m num` : Stop after finding num matches
- `-A num` : Show num lines of trailing context after the match
- `-B num` : Show num lines of leading context before the match
- `-C num` : Show num lines of context before and after the match

# Regular Expressions:

- `.` : Match any single character
- `^` : Match the beginning of a line
- `$` : Match the end of a line
- `[]` : Match any character inside the brackets
- `[^]` : Match any character NOT inside the brackets
- `()` : Group characters together
- `|` : Match either/or (e.g. `cat|dog`)
- `*` : Match zero or more of the preceding character
- `+` : Match one or more of the preceding character
- `?` : Match zero or one of the preceding character
- `{}` : Match a range of occurrences (e.g. `a{1,3}` matches "a", "aa", or "aaa")

# Examples:

- `grep "hello" file.txt` : Search for the string "hello" in file.txt
- `grep -i "hello" file.txt` : Search for the string "hello" in file.txt (case-insensitive)
- `grep -w "hello" file.txt` : Search for the whole word "hello" in file.txt
- `grep -n "hello" file.txt` : Search for the string "hello" in file.txt and show line numbers
- `grep -c "hello" file.txt` : Count the number of lines in file.txt that contain the string "hello"
- `grep -v "hello" file.txt` : Search for lines in file.txt that do not contain the string "hello"
- `grep -r "hello" /path/to/dir` : Search for the string "hello" recursively in the directory `/path/to/dir`
- `grep -e "hello|world" file.txt` : Search for the string "hello" or "world" in file.txt
- `grep -f pattern.txt file.txt` : Search for the patterns in pattern.txt in file.txt
- `grep -E "[0-9]{3}" file.txt` : Search for any three consecutive digits in file.txt
- `grep -P "\d{3}" file.txt` : Search for any three consecutive digits in file.txt (Perl-compatible regex syntax)
- `grep “hello” file.txt | head -n 5

# example

- grep -i locks *26_jul_2024.log
- grep -i sm_watch_locks *26_jul_2024.log > t.t
- grep -i sm_watch_locks *25_jul_2024.log |grep -i scheduler > t.t
- grep "Generating retrieval for aisle" *25_jul_2024.log > t.t
- grep "clearing dest at shuttle pickup" *24_jul* -h | sort | grep -Eo "clearing dest at shuttle pickup.+" | sort | uniq -c
-  grep "RTUCA" *24_jil" -h
-  grep "RTUCA" *24_jul* -h
-  grep "RTUCA" *24_jul*
-  grep "RTUCA" *22_jul*
-  grep *04_jul*
- grep MFC *
- grep MFC *24-Jul*
- grep "RTUCA & (CCPA10|CCPA09|CCPA08|CCPA07|CCPA06|CCPA05)" 26_jul -h

# Aldi

PLM1 message print 127 which is Y pairing number field in 2-Apr
```bash
grep "RPLM1.*##" *2_apr* | awk -F'/' '{raw="/" $2; print substr(raw,127,2)}' | sort | uniq -c | sort -nr