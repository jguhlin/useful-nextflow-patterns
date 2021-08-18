#!/usr/bin/env nextflow

mapped_ch = Channel.fromPath("./mapped_reads/*.cram")

process markdups {
  input:
    file(file) from mapped_ch

  output:
    file "*_markdup.cram"

  publishDir "markdup", mode: 'move', overwrite: true

  cpus 2

  """
    samtools sort --threads 2 -n ${file} -o ${file.baseName}.nsorted.cram -O CRAM --reference /mnt/data/stonefly/assembly.fna
    samtools fixmate --threads 2 -r -m -c -O CRAM --reference /mnt/data/stonefly/assembly.fna \
      ${file.baseName}.nsorted.cram ${file.baseName}_fixmate.cram
    samtools sort --threads 2 -o ${file.baseName}_sorted.cram -O CRAM --reference /mnt/data/stonefly/assembly.fna ${file.baseName}_fixmate.cram
    samtools markdup --threads 2 -O CRAM --reference /mnt/data/stonefly/assembly.fna \
      ${file.baseName}_sorted.cram ${file.baseName}_markdup.cram
#    samtools sort -o ${file.baseName}_sorted.cram -O CRAM \
#      --reference /mnt/data/stonefly/assembly.fna ${file.baseName}_markdup.cram 
    rm ${file.baseName}.nsorted.cram ${file.baseName}_fixmate.cram ${file.baseName}_sorted.cram
  """
}
