#!/bin/bash

#TARFILE="(date +%Y%m%d_%H%M%S).tgz"


#delete previous tar file at first place
if [ -f "sendPack.tar.gz" ]; then 
rm -f sendPack.tar.gz
echo "----Removing old send package----"
fi

# Get all the file name and store in a txt file 
path=$1
files=$(ls $path)
for filename in $files
do echo $filename >> temp.txt
done

sort -n temp.txt | uniq>newFilename.txt
rm -rf temp.txt

#get all the new update file name and store in a new txt file
cat oldFilename.txt | sort |uniq|sort>old_u.txt
cat newFilename.txt | sort |uniq|sort>new_u.txt
comm -23 new_u.txt old_u.txt >c.txt
rm -r new_u.txt
rm -r old_u.txt


# Re scan the folder set new file to old file and keep track for next update use 
path=$1
files=$(ls $path)
for filename in $files
do echo $filename >> temp.txt
done

sort -n temp.txt | uniq>oldFilename.txt
rm -rf temp.txt

# scan update file list
cat c.txt | while read line
do 
			
	echo "New file need pack:  " $line

	sleep 1
done
#---------------------------NEED-------------MODIFY---------------PATH---------BELOW`---------------
#clean the temp folder for package use 
if [ ! -d "/usr/local/test4/packFolder/" ]; then
mkdir /usr/local/test4/packFolder
else
echo "Folder exist, need to be renew"
rm -rf /usr/local/test4/packFolder/*
fi

# copy new file in new file list to temp folder
for file in `cat c.txt`
do echo "---processing file is $file"
cp $file /usr/local/test4/packFolder/
echo "--------------------"
done
# tar temp folder and ready to send tar
tar -zcvf sendPack.tar.gz packFolder

