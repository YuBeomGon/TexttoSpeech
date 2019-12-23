
#cat number.txt | sort -R > ran_num.txt

#for line in `cat ran_num.txt`
#do
#    echo $line
#    for line1 in `cat ran_num.txt`
#    do
#        echo $line1
##        if [ $line -ne $line1 ]; then 
##            echo $line" "$line1
##        fi
#    done
#done > random_number.txt

while read line
do
#    echo $line
    while read line2
    do
#        echo $line" "$line2
        if [ "$line" != "$line2" ]; then
            echo $line" "$line2
        fi 
    done < number.txt

done < number.txt | sort -R | head -n 100 > numbers.txt

cp numbers.txt numbers.txt.old

while read line
do
    while read line2
    do
        echo $line" "$line2

    done < numbers.txt.old

done < number.txt | sort -R | head -n 1000 > numbers.txt

