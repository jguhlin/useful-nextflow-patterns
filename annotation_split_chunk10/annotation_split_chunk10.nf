genomes_channel = channel.fromPath("genomes/*.fasta")

// Chunk into 10
chunked_channel = genomes_channel.collate(10)

process annotateGenomesChunked {
    input:
        file fastas from chunked_channel
    output:
        file "annotations/*.gff" into annotations
    // Uncomment and set for SLURM scripts
    // cpus: 10 // See: https://www.nextflow.io/docs/latest/process.html#cpus
    // memory: '10GB' // See: https://www.nextflow.io/docs/latest/process.html#memory
    // time: '6h' // See: https://www.nextflow.io/docs/latest/process.html#time
    // module "prodigal/2.6.3" // Set to NeSI module and what you are using: 
        // See: https://www.nextflow.io/docs/latest/process.html#module
        // I just guessed at that version and such, it probably won't work
    """
    # Create output director
    mkdir annotations

    for fasta in $fastas; do
        prodigal -i \$fasta -o annotations/\$(basename \$fasta .fasta).gff
    done


    """
}