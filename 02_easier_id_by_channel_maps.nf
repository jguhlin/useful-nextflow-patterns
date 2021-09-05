#!/usr/bin/env nextflow

mapped_ch = Channel.fromPath("./markdup/*.cram")

process do_nothing_for_mapped {
  input:
    file(x) from mapped_ch
  output:
    file "${x}" into output_ch

  """
  touch blank_action
  """

}

// Run a function on each input to the output_ch channel, and return the new one as a
// channel called "renamed_ch"
renamed_ch = output_ch.map { 
  [
    it.baseName,
    it
  ]
}

renamed_ch.println()

// So to process it as a process
// input:
//    tuple val(id), file(x) from renamed_ch
// should work

