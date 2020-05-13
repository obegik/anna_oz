
#!/usr/bin/env python3
desc= "Calculate mean current analysis per position from nanopolish event align output."

# Import required libraries:
import argparse
import pandas as pd

def parse_input(file, size_chunks):
    
    df_chunk = pd.read_csv(file, sep='\t', chunksize=size_chunks, compression='gzip', error_bad_lines=False)
    chunk_list = list()

    # Process each portion of input file:
    for chunk in df_chunk:  
        
        # Perform data filtering: 
        chunk_filter = chunk.iloc[:,[0,1,2,3,6]]

        # Once the data filtering is done, append to list
        chunk_list.append(chunk_filter)
        print('Partition {}: Processed'.format(len(chunk_list)))

    # Generate raw_input
    raw_data = pd.concat(chunk_list)
    print('Concatenating partitions')

    return raw_data


def mean_perpos (sliced_data, output):
    
    #Calculate mean per positions:
    print('Analysing data - position level - mean')
    sliced_data['read_name'] = 1
    mean_perpos = sliced_data.groupby(['contig', 'position','reference_kmer', 'read_name']).agg({'event_level_mean':['mean', 'count']}).reset_index()
    mean_perpos.columns =  mean_perpos.droplevel(-1)

    #Output .csv files:
    print('Saving results to: {}_processed_perpos_mean.tsv'.format(output))
    mean_perpos.to_csv('{}_processed_perpos_mean.tsv'.format(output), sep='\t', index = False)

def median_perpos (sliced_data, output):
    
    #Calculate mean per positions:
    print('Analysing data - position level - median')
    sliced_data['read_name'] = 1
    median_perpos = sliced_data.groupby(['contig', 'position','reference_kmer', 'read_name']).agg({'event_level_mean':['median', 'count']}).reset_index()
    median_perpos.columns =  mean_perpos.droplevel(-1)

    #Output .csv files:
    print('Saving results to: {}_processed_perpos_median.tsv'.format(output))
    median_perpos.to_csv('{}_processed_perpos_median.tsv'.format(output), sep='\t', index = False)

def mean_perpos_perread (raw_data, output):

    #Calculate mean per positions:
    print('Analysing data - read level - mean')
    mean_perpos_perread = raw_data.groupby(['contig', 'position','reference_kmer', 'read_name']).agg({'event_level_mean':['mean', 'count']}).reset_index()
    mean_perpos_perread.columns =  mean_perpos_perread.droplevel(-1)

    #Output .csv files:
    print('Saving results to: {}_processed_perpos_perread_mean.tsv'.format(output))
    mean_perpos_perread.to_csv('{}_processed_perpos_perread_mean.tsv'.format(output), sep='\t', index = False)

def median_perpos_perread (raw_data, output):

    #Calculate mean per positions:
    print('Analysing data - read level - median')
    median_perpos_perread = raw_data.groupby(['contig', 'position','reference_kmer', 'read_name']).agg({'event_level_mean':['median', 'count']}).reset_index()
    median_perpos_perread.columns =  mean_perpos_perread.droplevel(-1)

    #Output .csv files:
    print('Saving results to: {}_processed_perpos_perread_median.tsv'.format(output))
    median_perpos_perread.to_csv('{}_processed_perpos_perread_median.tsv'.format(output), sep='\t', index = False)

def main():
    parser  = argparse.ArgumentParser(description=desc)

    parser.add_argument('-i', '--input', help='Input file to process.')
    parser.add_argument('-o', '--output', help='Output filename')
    parser.add_argument("-s", "--chunk_size", default=100000, type=int, help='Size for input subsetting [%(default)s]')
    parser.add_argument("--read_level", action='store_true', help='Analysis at per read level')

    a = parser.parse_args()

    #Process input:
    raw_import = parse_input(a.input, a.chunk_size)

    #Analysis:
    if a.read_level:
        mean_perpos_perread(raw_import, a.output)
        median_perpos_perread(raw_import, a.output)

    mean_perpos(raw_import.iloc[:,[0,1,2,4]], a.output)
    median_perpos(raw_import.iloc[:,[0,1,2,4]], a.output)

if __name__=='__main__': 
    main()
