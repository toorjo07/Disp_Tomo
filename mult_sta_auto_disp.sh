#!/bin/bash



for dir in 20*
do
rm tmp*
cd ${dir}
mode=0

echo $dir > ../tmp
ls MFA_v*Z >> ../tmp1

cat ../tmp1  | tr " " "\n" >> ../tmp2 && mv ../tmp2 ../tmp1
cat ../tmp1 >> ../tmp

nol=`cat ../tmp | wc -l`


for file in MFA_v_*BHZ
do

#rm *?H?.${mode}.dsp *?H??.${mode}.dsp

echo "inside directory $dir"

sta=`echo $file | awk -F"_" '{print $5}' | awk -F"." '{print $1}'`
echo $sta
net=`echo $file | awk -F"_" '{print $4}'`
echo $net
#cha=`echo $file | awk -F"." '{print $2}'`
#root_file=${dir}_${net}_${sta}

#file=MFA_v_${dir}_${net}_${sta}.BHZ

#== checking the alpha based on distance ======
dist=`sachead ${file} DIST | awk -F"=" '{print $2}'`
echo $dist
if [ 1 -eq `echo "${dist} < 500 "| bc` ] ;
then
a=300
elif [ 1 -eq `echo "${dist} > 500 "| bc` ]  &&  [ 1 -eq `echo "${dist} < 1000 "| bc` ] ;
then
a=360
elif [ 1 -eq `echo "${dist} > 1000 "| bc` ]  &&  [ 1 -eq `echo "${dist} < 2000 "| bc` ] ;
then
a=480
elif [ 1 -eq `echo "${dist} > 2000 "| bc` ]  &&  [ 1 -eq `echo "${dist} < 4000 "| bc` ] ;
then
a=560
elif [ 1 -eq `echo "${dist} > 4000 "| bc` ] ;
then
a=650
else
echo "improper distance"
fi
b=592


echo $a $b


twid=$(xdotool search --name test)
xdotool windowactivate $twid
echo $twid
echo $file

loc=$(pwd)
sleep 0.2
loc=$(echo "$loc" | sed 's/.\{1\}/& /g')
sleep 0.2
loc=`echo $loc | sed 's/\//'slash'/g'`
sleep 0.2
loc=`echo $loc | sed 's/\_/'underscore'/g'`
echo $loc
sleep 0.2
p=`echo $file | fold -w1 | paste -sd' ' -`

# open a new window to run do_mft
xdotool key ctrl+alt+t
sleep 0.6
#nwid=$(xdotool getactivewindow)
#xdotool windowactivate $nwid
# Entering the directory
xdotool key c d space $loc Return
sleep 0.6
nwid=$(xdotool getactivewindow)



# Operations in new tab
#====================================#====================================
#====================================#====================================

sleep 0.4
xdotool key $nwid a equal grave s e d space minus n space apostrophe 1 p apostrophe space period period slash t m p grave Return
sleep 0.4
xdotool key $nwid b equal grave s e d space minus n space apostrophe 2 p apostrophe space period period slash t m p grave Return
sleep 0.4
xdotool key $nwid d o underscore m f t space dollar b Return
sleep 0.4



dwid=$(xdotool search --name do_mft)
echo dwid is $dwid
sleep 0.3
xdotool getactivewindow windowmove 0 100
sleep 0.3

xdotool windowactivate $dwid 

sleep 0.6
# clicking on the beg rectangular box displaying the file prop.
xdotool mousemove 200 280
sleep 0.6
xdotool click 1
sleep 0.5
# parameter selection window- selcting Units
xdotool mousemove 150 260
xdotool click 1
sleep 0.4
# selecting m/s
xdotool mousemove 420 710
xdotool click 1
sleep 0.5
# clicking back do_mft on the top
xdotool mousemove 280 180
xdotool click 1
sleep 0.5
# selecting the Type - Rayleigh
xdotool mousemove 140 405
xdotool click 1
xdotool click 1
sleep 0.5
# hovering on the MaxPer
xdotool mousemove 140 300
xdotool click 1
sleep 0.5
# clicking on 100
xdotool mousemove 680 590
xdotool click 1
sleep 0.5
# clicking on 1.2
xdotool mousemove 280 590
xdotool click 1
sleep 0.5
# clicking Verbose
xdotool mousemove 530 520
#xdotool click 1
# selecting alpha
xdotool mousemove 130 325
xdotool click 1
sleep 0.5
# moving the cursor to the app alpha based on distance calculation
xdotool mousemove $a $b
xdotool click 1
sleep 0.7
# clicking on do_mft
xdotool mousemove 280 180
xdotool click 1
sleep 0.7
# clicking on Automatic button
xdotool mousemove 420 670
xdotool click 1
#xdotool click 1
#sleep 0.1
xdotool mousemove 180 725
xdotool click 1
sleep 0.1

xdotool windowactivate $twid
read -p "Press Enter after done" 
xdotool windowclose $nwid
xdotool windowactivate $twid


sed -i '2d' ../tmp

# writing the output dispersion file with the name of the data file
mv ${sta}${cha}.dsp out_${file}.${mode}.dsp

# PLOTTING THE MFA CONTOUR OUTPUT for the particular data file
plotnps -K < MFT96.PLT > contour_${file}_out.ps
plotnps -n < MFT96.PLT > plot6_${root_file}.ps


done

echo "*****************************"
echo "***** ATTENTION ************"
echo "*****************************"
echo "*****************************"
echo "MOVING ONTO MATCHED FILES"
echo "*****************************"
echo "*****************************"
sleep 2


# Second for signal part of the trace in signal_*.?H? to compare the two
# OR for the matched signal file (stored in MFA_*.BHZs).

rm ../tmp*
echo $dir > ../tmp
ls MFA_v*Zs >> ../tmp1
cat ../tmp1  | tr " " "\n" >> ../tmp2 && mv ../tmp2 ../tmp1
cat ../tmp1 >> ../tmp
nol=`cat ../tmp | wc -l`


for files in MFA_v_${dir}_*.?HZs
do

echo " working on file $files .."

# preparing the output file name
#stas=`echo $files | awk -F"." '{print $1}' | awk -F"_" '{print $4}'`

stas=`echo $files | awk -F"_" '{print $5}' | awk -F"." '{print $1}'`
nets=`echo $files | awk -F"_" '{print $4}'`
chas=`echo $files | awk -F"_" '{print $5}' | awk -F"." '{print $2}' | cut -c1-3`
root_files=${dir}_${nets}_${stas}

# Plotting the matched data for viewing with sac to decide on multipathing
sac << !
window 1 x 0.0 0.95
r $files
qdp off
ppk
q
!


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

dist=`sachead ${files} DIST | awk -F"=" '{print $2}'`
echo $dist
if [ 1 -eq `echo "${dist} < 500 "| bc` ] ;
then
a=300
elif [ 1 -eq `echo "${dist} > 500 "| bc` ]  &&  [ 1 -eq `echo "${dist} < 1000 "| bc` ] ;
then
a=360
elif [ 1 -eq `echo "${dist} > 1000 "| bc` ]  &&  [ 1 -eq `echo "${dist} < 2000 "| bc` ] ;
then
a=480
elif [ 1 -eq `echo "${dist} > 2000 "| bc` ]  &&  [ 1 -eq `echo "${dist} < 4000 "| bc` ] ;
then
a=560
elif [ 1 -eq `echo "${dist} > 4000 "| bc` ] ;
then
a=650
else
echo "improper distance"
fi
b=592


echo $a $b

twid=$(xdotool search --name test)
xdotool windowactivate $twid
echo $twid
echo $files

loc=$(pwd)
sleep 0.2
loc=$(echo "$loc" | sed 's/.\{1\}/& /g')
sleep 0.2
loc=`echo $loc | sed 's/\//'slash'/g'`
sleep 0.2
loc=`echo $loc | sed 's/\_/'underscore'/g'`
echo $loc
sleep 0.2
p=`echo $files | fold -w1 | paste -sd' ' -`

# open a new window to run do_mft
xdotool key ctrl+alt+t
sleep 0.7
#nwid=$(xdotool getactivewindow)
#xdotool windowactivate $nwid
# Entering the directory
xdotool key c d space $loc Return
sleep 0.6
nwid=$(xdotool getactivewindow)


# Operations in new tab
#====================================#====================================
#====================================#====================================

sleep 0.4
xdotool key $nwid a equal grave s e d space minus n space apostrophe 1 p apostrophe space period period slash t m p grave Return
sleep 0.6
xdotool key $nwid b equal grave s e d space minus n space apostrophe 2 p apostrophe space period period slash t m p grave Return
sleep 0.6
xdotool key $nwid d o underscore m f t space dollar b Return
sleep 0.6


dwid=$(xdotool search --name do_mft)
echo dwid is $dwid
sleep 0.3
xdotool getactivewindow windowmove 0 100
sleep 0.3

xdotool windowactivate $dwid 

sleep 0.7
# clicking on the beg rectangular box displaying the file prop.
xdotool mousemove 200 280
sleep 0.7
xdotool click 1
sleep 0.5
# parameter selection window- selcting Units
xdotool mousemove 150 260
xdotool click 1
sleep 0.4
# selecting m/s
xdotool mousemove 420 710
xdotool click 1
sleep 0.5
# clicking back do_mft on the top
xdotool mousemove 280 180
xdotool click 1
sleep 0.5
# selecting the Type - Rayleigh
xdotool mousemove 140 405
xdotool click 1
xdotool click 1
sleep 0.5
# hovering on the MaxPer
xdotool mousemove 140 300
xdotool click 1
sleep 0.5
# clicking on 100
xdotool mousemove 680 590
xdotool click 1
sleep 0.5
# clicking on 1.2
xdotool mousemove 280 590
xdotool click 1
sleep 0.5
# clicking Verbose
xdotool mousemove 530 520
#xdotool click 1
# selecting alpha
xdotool mousemove 130 325
xdotool click 1
sleep 0.5
# moving the cursor to the app alpha based on distance calculation
xdotool mousemove $a $b
xdotool click 1
sleep 0.8
# clicking on do_mft
xdotool mousemove 280 180
xdotool click 1
sleep 0.8
# clicking on Automatic button
xdotool mousemove 420 670
xdotool click 1
#xdotool click 1
#sleep 0.1
xdotool mousemove 180 725
xdotool click 1
sleep 0.1

xdotool windowactivate $twid
read -p "Press Enter after done" 
xdotool windowclose $nwid
xdotool windowactivate $twid


sed -i '2d' ../tmp

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


# writing the output dispersion file with the name of the data file
mv ${stas}${chas}.dsp out_${files}.${mode}.dsp 

# PLOTTING THE MFA CONTOUR OUTPUT for the particular data file
plotnps -K < MFT96.PLT > contour_${files}_out.ps
plotnps -n < MFT96.PLT > plot7_${root_files}.ps

done

# cleaning up
rm -f MFT96CMP mft96.ctl mft96.DSP MFT96.PLT

###############################################################

# moving out of directory
echo " Moving out of directory $dir"
cd ..
done




#  ALPHA values chart for $a and $b
#++++++++++++++++++++++++++++++++++++
#				    +
# 3.00				    +
#xdotool mousemove 133 592   	    +
# 6.25				    +
# xdotool mousemove 183 592	    +
# 12.5				    +
#xdotool mousemove 300 592	    +
# 25				    +
#xdotool mousemove 360 592	    +
# 50				    +
#xdotool mousemove 480 592	    +
# 100				    +
#xdotool mousemove 560 592	    +
# 200				    +
#xdotool mousemove 650 592          +
#++++++++++++++++++++++++++++++++++++









