#!/bin/bash

#for line in `cat number.txt`
#do
#    for line2 in `cat number.txt`
#    do
#        echo $line $line2
#
#    done
#
#done > number_mixed.txt
file1=$1
file2=$2
name="number_dental_"
sex="male femail neutral"
speed="speed_0p8 speed_1p0 speed_1p2"
pitch="pitch_m5 pitch_zero pitch_p5"
SET=$(seq 01 25)

for pi in $pitch
do
    for person in `seq 01 25`
    do 
        echo $pi"_"$person
    done
done > pitch_person.txt

for sp in $speed
do
    for line in `cat pitch_person.txt`
    do
        echo $sp"_"$line

    done
done > speed_pitch_person.txt

for s in $sex
do
    for line in `cat speed_pitch_person.txt`
    do
        echo $s"_"$line

    done
done > sex_speed_pitch_person.txt
rm pitch_person.txt
rm speed_pitch_person.txt
