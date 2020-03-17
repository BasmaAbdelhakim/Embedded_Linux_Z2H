#! /bin/sh

#pin 17 -> start button
if [ ! -d /sys/class/gpio/gpio17 ]
 then
   echo "17" >/sys/class/gpio/export
   echo "in" >/sys/class/gpio/gpio17/direction
fi

#pin 18 -> stop button
if [ ! -d /sys/class/gpio/gpio18 ]
 then
   echo "18" >/sys/class/gpio/export
   echo "in" >/sys/class/gpio/gpio18/direction
fi

#pin 23 -> next button
if [ ! -d /sys/class/gpio/gpio23 ]
 then
  echo "23" >/sys/class/gpio/export
  echo "in" >/sys/class/gpio/gpio23/direction
fi

#pin 24 -> pre button
if [ ! -d /sys/class/gpio/gpio24 ]
 then
 echo "24" >/sys/class/gpio/export
 echo "in" >/sys/class/gpio/gpio24/direction
fi

number_of_songs=$(wc -l <songs.txt)
song_index=1

while true
do
   if [ $(cat /sys/class/gpio/gpio17/value) -eq 1 ];
     then
       nohup mpg123 -l $song_index -@  songs.txt >out.txt 2>err.txt &
     fi
   if [ $(cat /sys/class/gpio/gpio23/value) -eq 1 ];
     then
        sleep 1s
        song_index=$(($song_index+1))
        if [ $song_index -gt $number_of_songs ];
           then
              song_index=1
        fi
       pidof mpg123 | xargs kill -9
       nohup mpg123 -l $song_index -@  songs.txt >out.txt 2>err.txt &
    fi
   if [ $(cat /sys/class/gpio/gpio24/value) -eq 1 ];
       then
          sleep 1s
          song_index=$(($song_index-1))
          if  [ $song_index -lt 1 ]
            then
               song_index=$number_of_songs
           fi
          pidof mpg123 | xargs kill -9
          nohup mpg123 -l $song_index -@  songs.txt >out.txt 2>err.txt &
     fi
     if [ $(cat /sys/class/gpio/gpio18/value) -eq 1 ];
        then
           pidof mpg123 | xargs kill -9 $RESULT &> /dev/null
     fi

done

