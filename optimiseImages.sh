#!/bin/bash

curDir=$(pwd|rev|cut -d "/" -f1 |rev)
ConvertDir="../ConvertedImages$curDir"
mkdir -p $ConvertDir
ls $ConvertDir

optimise() {
for i in $(find . -iname "*.jpg" -type f | grep -v Unoptimized)
 do 
   name=$(echo $i|cut -d "/" -f2)
   echo guetzli --nomemlimit $i $ConvertDir/$name
   guetzli --nomemlimit $i $ConvertDir/$name
done
}

#echo "Want to do optimisation?"
optimise
