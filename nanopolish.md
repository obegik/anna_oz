# Analysis for the Nanopolish Output

## Processing the Nanopolish output
We will use the Nanopolish raw output to produce three types of files

  * Per position : Calculated Mean values per position
  * Per position-15nt window : Calculated mean values per 15 nt window
  * Per read-15nt window : Calculated per-read values per 15 nt window (For Stoichometry)


### Creating per-position values
required: python3

```bash
python3 perpos.py input
#example input x.reads-ref.eventalign.txt
```


### Creating per-15nt values
required: python3

```bash
python3 sliding_window_nanopolish_processedinput.py input -w 15
#example input x.processed_perpos_mean.csv
```



### Creating per-read values per 15 nt window (For Stoichometry)
required: python3

```bash
python3 sliding_window_nanopolish_rawinput.py input -w 15
#example input x.reads-ref.eventalign.txt
```

