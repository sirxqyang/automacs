#!/bin/bash
## run macs callpeak to every 
## sam file in the folder
## < 1-3-2013 xiaoqin yang>

for bam in *.bam; do
        terms=$(echo $bam | sed -e 's/.bam//g')
        pileupbdg=$(echo $bam | sed -e 's/.bam/_treat_pileup.bdg/g')
        bdg=$(echo $bam | sed -e 's/.bam/_treat.bdg/g')
        bdgtmp=$(echo $bam | sed -e 's/.bam/_treat.bdg.tmp/g')
        bw=$(echo $bam | sed -e 's/.bam/_treat.bw/g')
        wig=$(echo $bam | sed -e 's/.bam/_treat.wig/g')

        macs2 callpeak -t $bam -f BAM -g hs -B -n $terms -p 0.01 --shiftsize=73 --nomodel --keep-dup 1 --broad
        mv $pileupbdg $bdg
        intersectBed -a $bdg -b /mnt/Storage/home/yangxq/doc/chr_limit_hg19.bed -wa -f 1.00 > $bdgtmp
        bedGraphToBigWig $bdgtmp /mnt/Storage/home/yangxq/doc/chromInfo_hg19.txt $bw
        bigWigToWig $bw $wig
done


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Inform myself that mission accomplished
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/usr/sbin/sendmail -t <<EOF
From: Mail testing <xiaoqinyang@yeah.net>                                                                                      
To: sirxqyang@gmail.com
Subject: Misson accomplished!                                                  
----------------------------------
Sweet heart,

MACS2 callpeak finished!
Further analysis could be perform.

me
---------------------------------
EOF
man sendmail