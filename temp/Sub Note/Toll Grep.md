#### check send carton to GTP 8 to GTP15
```bash
grep -E "Dest GTP(0[8-9]|1[0-5])" mh_ms_dci_2{5..9}_debug_log_30_jun_2025.log
```