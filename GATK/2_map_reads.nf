#!/usr/bin/env nextflow

reads_ch = Channel.fromFilePairs("./trimmed_fastq/*{r1,r2,singles}.f*.gz", size: 3)
// reads_ch.println()

process map_reads {
  input:
    tuple val(id), val(files) from reads_ch

  output:
    file "*.cram"

  publishDir "mapped_reads"

  cpus 16

  """
    bwa mem \
      -o ${id}.sam \
      -t 16 \
      -R '@RG\\tID:${id}_pair\\tSM:${id}' \
      /mnt/data/stonefly/assembly.fna \
      ${files[0]} ${files[1]}

    samtools sort ${id}.sam -l 1 -o ${id}.sorted.bam -O bam

    bwa mem \
      -o ${id}_singles.sam \
      -t 16 \
      -R '@RG\\tID:${id}_single\\tSM:${id}' \
      /mnt/data/stonefly/assembly.fna \
      ${files[2]}
   
    samtools sort ${id}_singles.sam -l 1 -o ${id}_singles.sorted.bam -O bam
    samtools merge -O CRAM --reference /mnt/data/stonefly/assembly.fna \
      -o ${id}.cram *.bam
    rm *.sam
    rm *.bam
  """
}
