
#!/usr/bin/env python3
desc= "Calculate mean current analysis per position from nanopolish event align output."

# Import required libraries:
import argparse
import pandas as pd

def parse_input(file, size_chunks):
    
    df_chunk = pd.read_csv(file, sep='\t', chunksize=size_chunks)
    chunk_list = list()

    # Process each portion of input file:
    for chunk in df_chunk:  
        
        # Perform data filtering: 
        chunk_filter = chunk.iloc[:,[0,1,2,6]]

        # Once the data filtering is done, append to list
        chunk_list.append(chunk_filter)
        print('Partition {}: Processed'.format(len(chunk_list)))

    # Generate raw_input
    raw_data = pd.concat(chunk_list)
    print('Concatenating partitions')

    return raw_data

def mean_perpos (raw_data, output):
    
    #Calculate mean per positions:
    print('Analysing data')
    mean_perpos = raw_data.groupby(['contig', 'position','reference_kmer']).agg({'event_level_mean':['mean']}).reset_index()

    #Output .csv files:
    print('Saving results to: {}_processed_perpos_mean.csv'.format(output))
    mean_perpos.to_csv('{}_processed_perpos_mean.csv'.format(output), sep='\t', index = False)



def main():
    parser  = argparse.ArgumentParser(description=desc)

    parser.add_argument('-i', '--input', help='Input file to process.')
    parser.add_argument('-o', '--output', help='Output filename')
    parser.add_argument("-s", "--chunk_size", default=100000, type=int, help='Size for input subsetting [%(default)s]')

    a = parser.parse_args()

    #Process input:
    raw_import = parse_input(a.input, a.chunk_size)

    #Analysis:
    mean_perpos(raw_import, a.output)

if __name__=='__main__': 
    main()
