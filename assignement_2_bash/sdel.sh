#! /bin/bash

files_no=$#
files_name="$@"

#Check if the TRASH dir exists and create it if not.
if [ ! -d TRASH ]
 then
  mkdir TRASH
fi

# find zipped files modified two days ago and delete them
find TRASH -type f -atime +2 -exec rm -f {} \;

#Find number of files entered as parameters
if [ $files_no == 0 ]
  then
   echo "No new input files to delete"
   echo " Files in TRASH dir for more than two days will be deleted"
fi


for i in $files_name
 do
   #if the input parameter exists
     if [ -e $i ]
       then
         #if input parameter is file and zipped then move it to trash
       if [[ -f $i && $i =~ \.gz$ ]]
          then 
          mv $i TRASH
         #if input parameter is file and not zipped then zip it first then move it  to trash
       elif [[ -f $i && ! $i =~ \.gz$ ]]
          then
            tar czf $i.tar.gz $i
            mv $i.tar.gz TRASH
        #if input parameter is direcrorty then zip all the files ,then move it  to trash
       elif [[ -d $i ]]
          then
            gzip -r $i
            tar czf $i.tar.gz $i
            mv $i.tar.gz TRASH    
       fi
     else
        echo "file does not exists"
     fi
 
 done


