bcftools convert --gvcf2vcf -f ../assembly.fna stonefly_pop.gvcf.bcf -O bcf -o stonefly_pop.bcf
bcftools index stonefly_pop.bcf
bcftools stats --threads 16 -F ../assembly.fna stonefly_pop.bcf > vcf-stats/stonefly_pop_unfiltered.stats
