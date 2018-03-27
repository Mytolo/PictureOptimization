#!/bin/bash

curDir=$(pwd|rev|cut -d "/" -f1 |rev)
ConvertDir="../${curDir}Converted"
CORES=$(nproc)
mkdir -p $ConvertDir
ls $ConvertDir
#right settings for printf
export LC_NUMERIC="en_US.UTF-8"

optimiseJpg() {
for i in $(find . -iname "*.jpg" -type f | grep -v Unoptimized)
 do 
   name=$(echo $i|cut -d "/" -f2-)
   if [ ! -d $(dirname $ConvertDir/$name) ]
   then
     mkdir -p $(dirname $ConvertDir/$name)
   fi
   load=$(ps aux | grep guetzli | wc -l)
   let load=$load-1
   while [[ $load -ge $CORES ]]
   do
      load=$(ps aux | grep guetzli | wc -l)
      let load=$load-1
      printf "\rload to high ($load)"
      sleep 0.1 
   done
   if [ ! -f $ConvertDir/$name ]
   then
   	#echo guetzli --nomemlimit $i $ConvertDir/$name
        printf "\noptimizing $name in $(dirname $i)"
        guetzli --nomemlimit $i $ConvertDir/$name&
   fi
done
}

optimisePng() {
  for i in $(find . -iname "*.png" -type f | grep -v Unoptimized)
  do 
   name=$(echo $i|cut -d "/" -f2-)
   if [ ! -d $(dirname $ConvertDir/$name) ]
   then
     mkdir -p $(dirname $ConvertDir/$name)
   fi
   # use all cores equally
   load=$(ps aux | grep guetzli | wc -l)
   let load=$load-1 # one line additional false pos.
   while [[ $load -ge $CORES ]]
   do
      load=$(ps aux | grep guetzli | wc -l)
      let load=$load-1
      printf "\rload to high ($load)"
      sleep 0.1 
   done
   if [ ! -f $ConvertDir/$name ]
   then
    	#echo pngquant --skip-if-larger -o $ConvertDir/$name --strip 256 $i
        printf "\noptimizing $name in $(dirname $i)"
	pngquant --skip-if-larger -o $ConvertDir/$name --strip 256 $i
   fi
  done
}

#echo "Want to do optimisation?"
optimiseJpg
optimisePng
