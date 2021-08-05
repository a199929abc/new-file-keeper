#!/bin/bash

#TARFILE="(date +%Y%m%d_%H%M%S).tgz"
cd /home/kaiheng

#delete previous tar file at first place
if [ -f "sendPack.tar.gz" ]; then 
rm -f sendPack.tar.gz
echo "----Removing old send package----"
fi


rm -rf c.txt
if [ ! -d "/home/kaiheng/packFolder" ]; then
mkdir /home/kaiheng/packFolder
else
echo "Folder exist, need to be renew"
rm -rf /home/kaiheng/packFolder/*
fi   

# Get all the file name and store in a txt file 
#path=$1
#files=$(ls $path)
#for filename in $files
#do echo $filename >> temp.txt
#done

function read_dir(){
  for file in `ls $1`
  do  
    if [ -d $1"/"$file ]
    then
    read_dir $1"/"$file
    else
    echo $1$"/"$file >>temp.txt
    fi
done
}
read_dir /home/kaiheng


sort -n temp.txt | uniq>newFilename.txt
rm -rf temp.txt

#get all the new update file name and store in a new txt file
cat oldFilename.txt | sort |uniq|sort>old_u.txt
cat newFilename.txt | sort |uniq|sort>new_u.txt
comm -23 new_u.txt old_u.txt >c.txt
rm -r new_u.txt
rm -r old_u.txt


# Re scan the folder set new file to old file and keep track for next update use
read_dir /home/kaiheng

sort -n temp.txt | uniq>oldFilename.txt
rm -rf temp.txt

 

echo "------------------------------------------"
cat c.txt | while read line
do 
			
	echo "New file need pack:  " $line
done
echo "-----------------------------------------"
#---------------------------NEED-------------MODIFY---------------PATH---------BELOW`---------------
#clean the temp folder for package use

# copy new file in new file list to temp folder
for line in `cat c.txt`
do
cp $line /home/kaiheng/packFolder/
done


# tar temp folder and ready to send tar
currentDate=$(date "+%m-%d-%H_%M_%S")
tar -zcvf ${currentDate}.tar.gz packFolder
cp ${currentDate}.tar.gz /home/result
rm -rf ${currentDate}.tar.gz
