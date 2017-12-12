#!/bin/bash

#kill -9 $(ps -ef | grep deliver_stdout | grep -v grep | awk '{print $2}')

## remove old logs
printf "\n Cleanup the logs"
rm -rf log*.txt

C_LIMIT=100
CLIENTS=${1:-$C_LIMIT}
printf "\n Total Client requested : $CLIENTS\n"
for ((c=0;c<$CLIENTS;c++))
do
 	# printf "\n--------- START Index: $c\n"
 	./deliver_stdout --channelID mychannel --quiet --seek -2 >& log$c.txt &
	 printf ""
 	# printf "\n--------- END Index: $c\n"
done
printf "\n\n Wait for 20 secs ..."
sleep 20

counter=0
for ((c=0;c<$CLIENTS;c++))
do
	lineCount=$(cat log$c.txt | wc -l)
	if [ $lineCount -ne 5 ]; then
		printf "\n #### Client $c failed to fetch all the blocks, could fetch only $lineCount blocks\n"
		counter=` expr $counter + 1 `
	fi 
done

if [ $counter -ne 0 ]; then
	printf "\n ###### $counter Clients failed to fetch all the blocks ####### \n"
	exit 0
fi

echo
echo "===================== All GOOD, execution completed ===================== "
echo

exit 0
