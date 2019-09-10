#!/bin/bash

rm -f mode/SM_*_sta.txt

for dir in 19* 20*
do
cd $dir

for file in MFA_v_*?HZ
do
net=`echo $file | awk -F"_" '{print $4}'`
sta=`echo $file | awk -F"_" '{print $5}' | awk -F"." '{print $1}'`
#comp=`echo $file | awk -F"." '{print $2}'`


stla=`sachead $file STLA | awk -F"=" '{print $2}'`
stlo=`sachead $file STLO | awk -F"=" '{print $2}'`
year=`tail -n +2 ${dir}.txt | awk -F" " '{print $1}'`
month=`tail -n +2 ${dir}.txt | awk -F" " '{print $3}'`
day=`tail -n +2 ${dir}.txt | awk -F" " '{print $4}'`
timea=`tail -n +2 ${dir}.txt | awk -F" " '{print $5}'`
timeb=`tail -n +2 ${dir}.txt | awk -F" " '{print $6}'`
timec=`tail -n +2 ${dir}.txt | awk -F" " '{print $7}'`
elev=`cat ../masterfile | grep "$net" | grep -Fwe "$sta" | head -n +1 | awk '{print $5}'`
noc_elev=`cat ../masterfile | grep "$net" | grep -Fwe "$sta" |  head -n +1 | awk '{print $5}' | wc -l`


if [ $noc_elev == 0 ] ; then 
elev=10
#echo $net $sta $stlo $stla $elev $year-$month-$day $timea:$timeb:$timec | awk '{printf("%3s %5s\t %10.7f\t %10.7f\t %2s %10s %10s\n", $1, $2, $3, $4, "10", $6, $7)}' >> ../SM_stations.txt
echo $net $sta $stlo $stla $elev $year-$month-$day $timea:$timeb:$timec | awk '{printf("%3s %5s\t %10.7f\t %10.7f\t %2s %10s %10s\n", $1, $2, $3, $4, $5, $6, $7)}' >> ../mode/SM_${net}_${sta}_sta.txt
else

echo $net $sta $stlo $stla $elev $year-$month-$day $timea:$timeb:$timec | awk '{printf("%3s %5s\t %10.7f\t %10.7f\t %6.1f %10s %10s\n", $1, $2, $3, $4, $5, $6, $7)}' >> ../mode/SM_${net}_${sta}_sta.txt
fi

#else

#echo $net $sta $stlo $stla $elev $year-$month-$day $timea:$timeb:$timec | awk '{printf("%3s %5s\t %10.7f\t %10.7f\t %6.1f\t %10s %10s\n", $1, $2, $3, $4, $5, $6, $7)}' >> ../SM_stations.txt

#echo $net $sta $nol $start_yr $start_jdy $end_yr $end_jdy | awk '{printf("%3s\t %5s\t %10.7f\t %10.7f\t %10s\t %10s\n", $1, $2, $3, $4, $5, $6)}'  >> chart
#fi

done
cd ..
done

cd mode


rm -f final_station.dat
for file in SM_*txt
do
net=`echo $file | awk -F"_" '{print $2}'`
sta=`echo $file | awk -F"_" '{print $3}'`

lon=`head -n +1 ${file} | awk -F" " '{print $3}'`
lat=`head -n +1 ${file} | awk -F" " '{print $4}'`
elev=`head -n +1 ${file} | awk -F" " '{print $5}'`

stryr=`head -n +1 ${file} | awk -F" " '{print $6}'`
strtim=`head -n +1 ${file} | awk -F" " '{print $7}'`

endyr=`tail -1 ${file} | awk -F" " '{print $6}'`
endtim=`tail -1 ${file} | awk -F" " '{print $7}'`

echo $net $sta $lat $lon $elev ${stryr} $strtim $endyr $endtim | awk '{printf("%3s %5s %10.7f %10.7f %6.1f %10s %10s %10s %10s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9)}' >> final_station.dat
done



