#https://git.oru.se/bioinfoPublic/16s_bootstrapping/-/blob/master/script100.bash
#https://github-wiki-see.page/m/picrust/picrust2/wiki/Hidden-state-prediction
#https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7641418/
#https://eprints.gla.ac.uk/281516/1/281516.pdf

conda install q2-picrust2=2024.5 \
-c conda-forge \
-c bioconda \
-c picrust 

#as porposed in the tutorial
qiime picrust2 full-pipeline \
   --i-table table14.qza \
   --i-seq rep-seqs14.qza \
   --output-dir q2-picrust2_output \
   --p-placement-tool sepp \
   --p-threads 16 \
   --p-hsp-method pic \
   --p-max-nsti 2 \
   --verbose

#as suggested by the tutorial
qiime picrust2 full-pipeline \
   --i-table table14.qza \
   --i-seq rep-seqs14.qza \
   --output-dir q2-picrust2_output2 \
   --p-placement-tool epa-ng \
   --p-threads 24 \
   --p-hsp-method mp \
   --p-max-nsti 2 \
   --p-edge-exponent 0.5 \
   --o-ec-metagenome ec-metagenome.qza \
   --o-ko-metagenome ko-metagenome.qza \
   --o-pathway-abundance pathway-abundance.qza\
   --verbose