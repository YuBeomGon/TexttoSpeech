#!/bin/bash

# Copyright 2017 Lucas Jo (Atlas Guide)
# Apache 2.0

# do this when the segmentation rule is changed
# $KALDI_ROOT/tools/extras/install_morfessor.sh is merged
# at revision 5e6bd39e0ec0e510cb7202990c22fe8b8b9d817c

echo "$0 $@"  # Print the command line for logging

datadir=$1
asrdir=$2


exists(){
	command -v "$1" >/dev/null 2>&1
}

# check morfessor installation
if ! exists morfessor; then
	echo "Morfessor is not installed, so install it"
    wd=`pwd`
    cd $KALDI_ROOT/tools
    ./extras/install_morfessor.sh
    cd $wd
    . ./path.sh
fi

if [ ! -f $datadir/text.scp ]; then
	echo "text.scp file is not found in "$dataDir
	exit 1
fi

#its already done in the original code
# cat $$datadir/text.scp | awk '{print $1}' > $scriptdir/tmpid.txt
# cat $$datadir/text.scp | awk '{$1=""; print $0}' > $scriptdir/tmptext.txt
# trans=$scriptdir/tmptext.txt

trans=$datadir/text.scp
echo "Re-segment transcripts: $trans --------------------------------------------"
if [ ! -f $trans ]; then
	echo "transcription file is not found in "$dataDir
	exit 1
fi

cp $trans $trans".old"
awk '{print $1}' $trans".old" > $trans"_tmp_index"
#cut -d' ' -f2- $trans".old" |\
cat $trans".old" | tr '[:blank:]' ' ' |\
cut -d ' ' -f2- |\
	sed -E 's/\s+/ /g; s/^\s//g; s/\s$//g' |\
	morfessor -l $asrdir/zeroth_morfessor.seg -T - -o - \
	--output-format '{analysis} ' --output-newlines \
	--nosplit-re '[0-9\[\]\(\){}a-zA-Z&.,\-]+' \
	| paste -d" " $trans"_tmp_index" - > $trans
#rm -f $trans"_tmp_index"

