#!/usr/bin/env nextflow

mapped_ch = Channel.fromPath("./markdup/*.cram")

process markdups {
  input:
    file(file) from mapped_ch

  output:
    file "*.stats"
    file "*.txt"

  publishDir "stats_processed", mode: 'move', overwrite: true

  cpus 2

  """
    samtools index ${file}
    samtools stats ${file} > ${file.baseName}.stats
    mosdepth -n --fasta /mnt/data/stonefly/assembly.fna ${file.baseName} ${file} 
  """
}
