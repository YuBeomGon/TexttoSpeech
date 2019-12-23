#!/bin/bash
# Copyright 2019  YuBeomGon
# Apache 2.0

# bash part
# first, make a transcription using number.txt and dental.txt 
# then paste id to the above transcription, example of id, male_speed_slow_pitch_m5_1, so make a text.scp file

#python and google cloud API
# second, using python and google texttospeech api, make a audio for various transcription
# and wav.scp

# bash and morfessor
# third, do the segmentation with themorfessor.seg for text.scp, and update segmodel for ASR, and change wav to pcm format using ffmpeg

# c++
# 4th, do the ASR for wav file, and make a decoded.txt(ked id + text)
# 5th, compute the wer

date=$(date +'%F-%H-%M')
echo start at $date

testflag=1

dir=~/TexttoSpeech
voicedir=$dir/audio
scriptdir=$dir/TestMode
asrdir=$dir/Asr

cd ~/kaldi/egs/zeroth/s5
. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh
cd $dir

required="$dir/wav.scp $dir/text.scp $asrdir/zeroth_morfessor.seg"
for f in $required; do
  [ ! -f $f ] && echo "mkgraph.sh: expected $f to exist" && exit 1;
done

# bash part
# first, make a transcription using number.txt and dental.txt 
# then paste id to the above transcription, example of id, male_speed_slow_pitch_m5_1, so make a text.scp file

##### make wav.scp and transcription for comparing ######
#python and google cloud API
# second, using python and google texttospeech api, make a audio for various transcription
# and wav.scp

# bash and morfessor
# third, do the segmentation with themorfessor.seg for text.scp, and update segmodel for ASR, and change wav to pcm format using ffmpeg
$scriptdir/test_seg.sh $dir $asrdir

#get decoded text data using kaldi test mode

echo "test mode is doing"
#decode and make decode.txt
$scriptdir/web_decode_testmode.sh $dir $asrdir

~/kaldi/src/bin/compute-wer --text --mode=present ark:$dir/text.scp ark:$dir/decode.txt

date=$(date +'%F-%H-%M')
echo ends at $date

exit 1
#gdb ../../../src/online2bin/beom-test core

