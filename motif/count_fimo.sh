#!/bin/bash
set -e

if [ "$#" -eq 0 ]; then
    echo "Usage: bash count_fimo.sh file1.tsv file2.tsv ..." >&2
    exit 1
fi

printf 'file\tmotif_id\tsites\tgenes_with_hit\n'

for file in "$@"
do
    echo "Processing $file" >&2

    awk -F '\t' '
    NR == 1 { next }
    /^#/ || NF < 9 { next }

    {
        motif = $1
        gene = $3

        sites[motif]++

        if (!seen[motif, gene]++)
            genes[motif]++
    }

    END {
        for (motif in sites)
            printf "%s\t%s\t%d\t%d\n",
                   FILENAME, motif, sites[motif], genes[motif]
    }
    ' "$file"
done