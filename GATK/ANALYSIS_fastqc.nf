#!/usr/bin/env nextflow

reads_ch = Channel.fromFilePairs("./OG5453.1/OG5453_fastq/*{1,2}_001.fastq.gz")

process FastQC {
  input:
    tuple val(id), val(files) from reads_ch
  output:
    file "*.zip"

  publishDir 'fastqc'
  cpus 16
  conda 'bioconda::fastqc'

  """
    fastqc -o . ${files[0]} ${files[1]}
  """
}

