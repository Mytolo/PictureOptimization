#!/bin/bash

curDir=$(pwd|rev|cut -d "/" -f1 |rev)
ConvertDir="../${curDir}Converted"
CORES=$(nproc)
# If you want it faster :D
let CORES=$CORES*2


numJpg=$(find -iname "*.jpg" -type f| grep -v Unoptimized | wc -l)
optJpg=$(find $ConvertDir -iname "*.jpg" -type f | wc -l)
numPng=$(find -iname "*.png" -type f| grep -v Unoptimized | wc -l)
optPng=$(find $ConvertDir -iname "*.png" -type f | wc -l)


mkdir -p $ConvertDir

# ls $ConvertDir
#right settings for printf

export LC_NUMERIC="en_US.UTF-8"
#echo "$((optJpg*100 / numJpg))"

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
      printf "load to high ($load) status: $((optJpg*100/numJpg)) percent of jpg\r"
      sleep 0.1 
   done
   if [ ! -f $ConvertDir/$name ]
   then
   	#echo guetzli --nomemlimit $i $ConvertDir/$name
        echo "optimizing $name in $(dirname $i)"
	guetzli --nomemlimit $i $ConvertDir/$name&
	let optJpg=$optJpg+1
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
      printf "load to high ($load) status: $((optPng*100/numPng)) percent of png\r"
      sleep 0.1 
   done
   if [ ! -f $ConvertDir/$name ]
   then
    	#echo pngquant --skip-if-larger -o $ConvertDir/$name --strip 256 $i
        echo "optimizing $name in $(dirname $i)"
	pngquant --skip-if-larger -o $ConvertDir/$name --strip 256 $i
	let optPng=$optPng+1
   fi
  done
}

#echo "Want to do optimisation?"
optimiseJpg
optimisePng
echo "unconverted:"
du -sh ./
echo "converted:"
du -sh $ConvertDir
