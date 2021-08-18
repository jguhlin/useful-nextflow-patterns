#!/usr/bin/env nextflow

markdup_ch = Channel.fromPath("./markdup/*.cram")
ref = "/mnt/data/stonefly/assembly.fna"
gatk = "/home/josephguhlin/software/gatk-4.2.1.0/gatk"

process haplotypecaller {
  input:
    file(file) from markdup_ch

  output:
    file "*.gvcf.gz"

  publishDir "gvcfs", mode: 'move', overwrite: true

  cpus 4
  memory '16 GB'

  """
    samtools index ${file}
    ${gatk} --java-options "-Xmx8g" HaplotypeCaller -I ${file} \
      -R ${ref} \
      -O ${file.baseName}.gvcf.gz \
      -ERC GVCF
  """
}
