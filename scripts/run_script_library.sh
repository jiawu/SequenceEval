#!/bin/sh

MOTIFS="ELK1_09
ELK1_08
ELK1_01
ELK1_02
ELK1_03
ELK1_04
ELK1_05
ELK1_06
ELK1_Q6
GATA3_02
GATA3_03
GATA3_Q4
GATA3_05
GATA3_07
GATA3_01
GATA4_Q5_01
GATA4_Q3
GATA6_01
GATA6_Q5
MEF3_B
NEUROD_01
NEUROD_02
PIT1_01
PIT1_Q6_01
PIT1_Q6
TWIST_Q6
WT1_Q6_01
WT1_Q6_02
WT1_Q6
OG2_01
OG2_02"

COUNTER="1"

for run_counter in {1..10}
do
  COUNTER="$run_counter"
  for motif_name in $MOTIFS
  do
    cat <<EOS | msub -

    #!/bin/bash
    #MSUB -A p20519
    #MSUB -M jiawu@u.northwestern.edu
    #MSUB -e seqGen_error_file.err
    #MSUB -o seqGen_log_file.log
    #MSUB -l walltime=24:00:00
    #MSUB -l nodes=1:ppn=1
    #MSUB -j oe
    #MSUB -m bae
    #MSUB -V
    #MSUB -N ${motif_name}_${COUNTER}

    module load boost
    module load gcc
    module load utilities
    
    /home/jjw036/SequenceGenerator/bin/seqGen /projects/p20519/jia_output/SequenceGenerator/${motif_name}_${COUNTER}_10000000.txt /home/jjw036/SequenceGenerator/TRANSFAC2FIMO.txt $motif_name 10000000 100
    7za a -t7z /projects/p20519/jia_output/SequenceGenerator/${motif_name}_${COUNTER}.7z /projects/p20519/jia_output/SequenceGenerator/${motif_name}_${COUNTER}_10000000.txt
    rm /projects/p20519/jia_output/SequenceGenerator/${motif_name}_${COUNTER}_10000000.txt

EOS
  done
  jobs_running=true
done
