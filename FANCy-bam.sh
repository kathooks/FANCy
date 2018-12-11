#!/bin/bash

# get command line inputs

# expected input:
# FANCy-otu.sh otuTableFile otuSeqsFile matchfilesDir logDir outDir metaDataVectorFile pval normalizationOption condA condB
# example:
# FANCy-otu.sh otudir/otuTable.txt otudir/otuSeqs.fasta matchfilesDir log_H output_H HumanApeMetadata.csv 0.05 "tss" "no" "yes"

# normalization -> "tss" for Total Sum Scaling, "uqs" for Upper Quartile Scaling, any other value for no scaling.

# Condition A and B MUST be the exact values desired, as written in the metadataVector File.

# The Metadata file must be a 2 column vector, one column containing the names of the samples,
#  the other containing the category that sample is in (ex: human -> yes, no)

pipeline="$(dirname '$BASH_SOURCE')";
snake="$pipeline""/snakefile-bam"
taxa="ncbiDB/taxa.sqlite"
db="$pipeline""/UNITEid"
bamzip=$1
match=$2
log=$3
out=$4
meta=$5
pval=$6
option=$7
grp1=$8
grp2=$9

# make any directories not automatically generated by the Snakemake pipeline, and copy the two otu files into the otu directory for processing.

# replace the "." in file.zip with a space, then make into a list.
bamDir=(${bamzip//./ })
# use the fist element ("file" in "file.zip") as name of the BamDirectory
mkdir $bamDir
unzip $bamzip -d $bamDir

rm $bamzip


mkdir ncbiDB
touch ncbiDB/taxa.sqlite

mkdir $out
mkdir $out/tango

# execute the snakemake pipeline using the OTU processing path, and the above options, directories and files.

snakemake -s $snake --config tango="$pipeline" cur_dir="$pipeline" bamdir="$bamDir"  output="$out" log="$log" ncbiDB="$taxa" pval="$pval" matchfiles="$match" metadata="$meta" option="$option" uniteDB="$db" GRP1="$grp1" GRP2="$grp2";


#
