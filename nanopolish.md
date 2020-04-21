# Analysis for the Nanopolish Output

## Processing the Nanopolish output
We will use the Nanopolish raw output to produce three types of files

  * Per position : Calculated Mean values per position
  * Per Read : Calculated Mean values per read (Collapse multiple observations per read)
  * Per position-15nt window : Calculated mean values per 15 nt window
  * Per read-15nt window : Calculated per-read values per 15 nt window (For Stoichometry)


### Creating Mean files 
required: python3

#### For Per-Position Mean 
```bash
python3 perpos.py input
#example input x.reads-ref.eventalign.txt
```


#### For Per- Mean
```bash
python3 perread_mean_pos.py input
#example input x.reads-ref.eventalign.txt
```



### Creating per-15nt values
required: python3

#### For Per-position (Take less time)
```bash
python3 sliding_window_nanopolish_processedinput.py input -w 15
#example input x.processed_perpos_mean.csv
```

#### Creating per-read values per 15 nt window (For Stoichometry)
required: python3

##### First approach, use the very raw nanopolish output (TAKES LONGER)
```bash
python -f sliding_window_nanopolish_rawinput.py input -w 15 > output
#example input x.reads-ref.eventalign.txt
```

##### Second approach, use the Per Read Mean file 
```bash
python -f sliding_window_nanopolish_processedinput.py input -w 15 > output
#example input x.processed_perread_mean.csv
```