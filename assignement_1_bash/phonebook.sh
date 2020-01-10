 #! /bin/bash 

function insert {
 read -p "Enter the contact name: " name
 #chech if the contact exists already
 result=$(grep -w "${name}" database.text)
 if [[ ! -z ${result} ]] 
   then 
     read -p "This name already exists.Enter a nother name: " name
 elif [ name = ' ' ]
    then
     read -p "Please enter a  valid name , Do not start with space : " name
 fi
 read -p "Enter the contact number: " number

 # check if the number consists of only digits
 if [[ ! $number =~ ^[0-9]+$ ]]
   then
     read -p "please enter a correct number: " number
 fi
 echo $name $number >> database.text 
}

function viewAll {
 #chech if file is empty 
 if [ ! -s database.text ]
   then 
     echo "The file is already empty"
 else
     echo " Available contacts "
     cat database.text    
 fi

}

function search {
 if [ ! -s database.text ]
   then 
     echo "The file is already empty"
 else
  read -p "Enter your contact name: " name 
  result=$(grep "${name}" database.text)
  if [[ -z $result ]]
    then
      echo "This contact can not be found"
  else
    grep "${name}" database.text
  fi
 fi
}

function deleteAll {
 if [ ! -s database.text ]
   then 
     echo "The file is already empty"
 else
   echo "The file has been deleted"
   sed -i "$!d" database.text
   sed -i "$d"  database.text
 fi
}

function delete {
 if [ ! -s database.text ]
   then 
     echo "The file is already empty"
 else
   read -p "Enter your contact name: " name 
   result=$(grep -w "${name}" database.text)
   lines=$(grep -r -w "${name}" database.text | wc -l)
   if [[ -z ${result} ]]
    then
      echo "This contact can not be found"

   elif [ $lines == 1 ]
     then
       echo "The contact is deleted"
       sed -i "/$result/ d" database.text
   else 
    while [ $lines -gt 1 ]
     do
     read -p "There is more one that contact with that name,please specify the correct name : " name 
     result=$(grep "$name" database.text) 
     lines=$(grep -r "${name}" database.text | wc -l) 
    done 
      echo "The contact is deleted"
      sed -i "/$result/ d" database.text  
   fi

 fi
}

#Check if the file exists and create it if not.
if [ ! -f database.text ]
 then
  touch database.text
fi

parameters_no=$#

if [ $parameters_no == 0 ]
 then
  echo "please choose an option"
  echo "-i For inserting new contact name and number"
  echo "-v For viewing all saved contacts details"
  echo "-s For searching by contact name"
  echo "-e For deleting all records"
  echo "-d For deleting only one contact name"

elif [ $parameters_no == 1 ]
 then
 if [[ $1 == '-i' ]]
   then
     insert
 elif [ $1 = '-v' ]
    then
      viewAll
 elif [ $1 = '-s' ]
    then
      search
 elif [ $1 = '-e' ]
    then
      deleteAll
 elif [ $1 = '-d' ]
    then
      delete
 else
   echo "please enter correct option"
  fi
else 
  echo "Please enter one option at time"
fi

