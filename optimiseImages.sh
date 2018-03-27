#!/bin/bash

curDir=$(pwd|rev|cut -d "/" -f1 |rev)
ConvertDir="../${curDir}Converted"
mkdir -p $ConvertDir
ls $ConvertDir

optimiseJpg() {
for i in $(find . -iname "*.jpg" -type f | grep -v Unoptimized)
 do 
   name=$(echo $i|cut -d "/" -f2-)
   echo guetzli --nomemlimit $i $ConvertDir/$name
   if [ ! -d $(dirname $ConvertDir/$name) ]
   then
     mkdir -p $(dirname $ConvertDir/$name)
   fi
   if [ ! -f $ConvertDir/$name ]
   then
        guetzli --nomemlimit $i $ConvertDir/$name
   fi
done
}

optimisePng() {
  for i in $(find . -iname "*.png" -type f | grep -v Unoptimized)
  do 
    name=$(echo $i|cut -d "/" -f2-)
    echo pngquant $i 128 $ConvertDir/$name 
  done
}

#echo "Want to do optimisation?"
optimiseJpg
optimisePng
