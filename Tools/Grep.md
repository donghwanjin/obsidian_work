---
tags:
  - tools
  - grep
  - bash
  - linux
  - tool
type: reference
---

# Grep

## Options

| Flag | Description |
|------|-------------|
| `-i` | Ignore case |
| `-w` | Match whole word |
| `-n` | Show line numbers |
| `-c` | Count matching lines |
| `-v` | Invert match (show non-matching lines) |
| `-r` | Recursive search in subdirectories |
| `-l` | Show only filenames of matching files |
| `-h` | Suppress filenames in output |
| `-o` | Print only the matched part |
| `-e pattern` | Specify pattern explicitly |
| `-f file` | Read pattern from file |
| `-E` | Extended regular expression (ERE) |
| `-P` | Perl-compatible regular expression (PCRE) |
| `-m num` | Stop after `num` matches |
| `-A num` | Show `num` lines after match |
| `-B num` | Show `num` lines before match |
| `-C num` | Show `num` lines before and after match |

## Regular Expressions

| Pattern | Description |
|---------|-------------|
| `.` | Any single character |
| `^` | Beginning of line |
| `$` | End of line |
| `[abc]` | Any character inside brackets |
| `[^abc]` | Any character NOT inside brackets |
| `(...)` | Capture group |
| `\|` | Either/or (e.g. `cat\|dog`) |
| `*` | Zero or more of preceding |
| `+` | One or more of preceding |
| `?` | Zero or one of preceding |
| `{n,m}` | Between n and m occurrences |

## Common Patterns

### Extract unique values with count
```bash
grep -Eo "PATTERN" file.log | sort | uniq -c | sort -nr
```

### Filter include, exclude
```bash
cat file.log | grep INCLUDE | grep -v EXCLUDE
```

### Extract field with PCRE lookbehind
```bash
grep -Po "key: '\K[^']+"
```

### Top N entries by frequency
```bash
cut -d ' ' -f5 file.log | sort | uniq -c | sort -rn | head -n 20
```

### Find files by timestamp containing a string
```bash
find . -type f -newermt "YYYY-MM-DD HH:MM" -exec grep -l "PATTERN" {} +
```

### Sed — replace whole line with first captured group
```bash
sed -E 's/.*(MS[2][5-9]).*/\1/'
```
- `.*` — matches any chars before/after
- `(MS[2][5-9])` — captures `MS25`–`MS29`
- `\1` — back-reference to captured group

---

## WCS Log Snippets

### Filter TU by ID, exclude TUDR
```bash
cat mh_cc_dci_log_dai-wcs02_30_dec_2024.log | grep TU-051-773892 | grep -v TUDR
```

### Find TUEX with BF flag
```bash
cat mh_cc_dci_log_dai-wcs02_30_dec_2024.log | grep BF | grep TUEX
```

### Count unique TUs in RTURP messages
```bash
cat mh_ms_dci_24_log_dai-wcs01_17_jan_2025.log | grep RTURP | grep -Eo "TU-WCS-[0-9]{7}" | sort | uniq -c
```

### Last N TURP messages for a device
```bash
grep PCMA01NP13 mh_pc_dci_log_dai-wcs01_22_jan_2025.log | grep TURP | tail -n 10
```

### Count MSAI aisle cluster occurrences
```bash
cat mh_ms_dci_*_log_dai-wcs02_08_feb_2025.log | grep -Eo "MSAI[0-9]{2}CL01DS12" | sort | uniq -c
```

### Contour sort — extract field from TUDR messages
```bash
grep "TUDR.*##" mh_cc_dci_*_log_*.log \
  | awk -F'/' '{raw="/" $2; print substr(raw,119,14)}' \
  | sort | uniq -c | sort -nr
```

### Extract aisle from BO/CA messages
```bash
grep BO *01_sep* | grep CA02 | sed -E 's/.*(MS[2][5-9]).*/\1/' | sort -tS -k2n | uniq -c
```

### Misc WCS queries
```bash
grep -i locks *26_jul_2024.log
grep -i sm_watch_locks *26_jul_2024.log > t.t
grep -i sm_watch_locks *25_jul_2024.log | grep -i scheduler > t.t
grep "Generating retrieval for aisle" *25_jul_2024.log > t.t
grep "clearing dest at shuttle pickup" *24_jul* -h | sort | grep -Eo "clearing dest at shuttle pickup.+" | sort | uniq -c
grep "RTUCA" *24_jul* -h
grep MFC *24-Jul*
```

---

## TM Field Change Events

### Count all changed fields
```bash
grep TM_FIELD_CHANGE OEL_dai-wcs01_*.log | grep -Eo "change_field: '[A-Za-z_ ]+'" | sort | uniq -c | sort -hr
```

### Count changes for a specific device
```bash
grep TM_FIELD_CHANGE OEL_dai-wcs01_14-Mar-2025.log | grep "mh_dci_plc_CC63_1" \
  | grep -Eo "change_field: '[A-Za-z_ ]+'" | sort | uniq -c | sort -hr
```

### Find top TUs by Mcap Task Id changes
```bash
grep "change_field: 'Mcap Task Id'" OEL_dai-wcs01_08-Jul-2025.log \
  | grep -Po "from_value: '\K[^']+" | sort | uniq -c | sort -nr | head -n 10
```

---

## Barcode Search

Find files modified after a given time that contain a barcode:
```bash
find . -type f -newermt "today 15:30" -exec grep -l "795120000000939728" {} +
find . -type f -newermt "1day ago 15:30" -exec grep -l "795120000000939728" {} +
```

---

## Site: Aldi

### PLM1 — print field at offset 127 (Y pairing number)
```bash
grep "RPLM1.*##" *2_apr* | awk -F'/' '{raw="/" $2; print substr(raw,127,2)}' | sort | uniq -c | sort -nr
```

### check highbay balancing

```bash
grep "TUMI.*MRMR11DP01....MRAI.*##" *23_oct* | perl -nE 'push @a, /MRAI(\d{2})DS01/g; END { say join(",", @a) }'
```

 🟢 `-n`

Tells Perl: _“read input line by line and apply the code to each line.”_

 🟢 `-E`

Enables **modern Perl features**, such as `say` (which automatically adds a newline).

 🟢 `'push @a, /MRAI(\d{2})DS01/g; ...'`

- `/MRAI(\d{2})DS01/g` is a **regular expression**:
    
    - `MRAI` — matches the literal text “MRAI”.
        
    - `(\d{2})` — captures two digits (like `08`, `09`, etc.).
        
    - `DS01` — matches the literal text “DS01”.
        
    - `/g` — global flag (find _all_ matches in the line).
        
- `push @a, ...` means:  
    → Add every matched 2-digit number into array `@a`.


```bash
grep "TUMI.*MRMR11DP01....MRAI.*##" *23_oct* | \
perl -nE '
    push @a, /MRAI(\d{2})DS01/g;
    if (@a >= 9) {
        say join(",", splice(@a, 0, 9)) . ",";
    }
    END {
        say join(",", @a) . "," if @a;
    }
'

```

- `splice(@a, 0, 9)` → takes 9 numbers at a time from the array.
- 
    
- `say join(",", ...) . ","` → prints them with commas and a newline
### two pallet check.
```base
grep -h -E '4013231251125041027243|4013231251125041053705' ~/logging/master/mh_pc_dci*25_nov*

```

```base
grep -h -E '00000000000000000901|4120000000000000000001' ~/logging/master/mh_pc_dci*25_nov* \

| awk '{

    gsub(/00000000000000000901/, "\033[31m&\033[0m");  # Red

    gsub(/4120000000000000000001/, "\033[32m&\033[0m");  # Green

    print

}'
```


```base
grep -h -E '00000000000000000903|4120000000000000000002' ~/logging/master/mh_pc_dci*3_dec* | awk '{gsub(/00000000000000000903/, "\033[31m&\033[0m"); gsub(/4120000000000000000002/, "\033[32m&\033[0m"); print}'
```




---
## Site: Wow

### PTL disconnection
```base
grep "DDI Q database full" *10_jan*
```

---

## Site: Toll

### Check cartons sent to GTP 8–15
```bash
grep -E "Dest GTP(0[8-9]|1[0-5])" mh_ms_dci_2{5..9}_debug_log_30_jun_2025.log
```