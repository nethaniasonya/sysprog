#!/bin/bash

options="Options:\n
1. Check storage\n
2. Make partition\n
3. Delete partition\n
4. Exit\n
"
dev=/dev/sdb

if !(ls /dev | grep "sdb") > /dev/null ;
then
	echo "No USB detected"
	exit
fi

function get_last {
	declare -i last=0
	while read line
	do
		if [[ ! $line =~ ^[0-9]+$ ]];
		then
			continue
		fi
		last=$line
	done < <(parted --script $dev print free | sed -n '/Number/,$p' | cut -d " " -f 2)
	return $last
}


function last_part_end {
	get_last
	last_part=$?
	if [[ $last_part -eq 0 ]];
	then
		echo "512B"
		return
	fi

	last=$(parted --script $dev print free | sed -n '/Number/,$p' | grep "^ $last_part" | awk '{print $3}')
	echo $last
	return
}


function check_storage {
	parted --script $dev print free | sed -n '/Number/,$p'
}

function to_byte {
	declare -i size=$1
	declare -i unit_limit=1000
	units="B KB MB GB"
	for i in $units
	do
		if [[ $size -lt $unit_limit ]];
		then
			echo $size$i
			return
		fi

		if [[ $i == "GB" ]];
		then
			echo $size$i
			return
		fi
		((size=size/1000))
	done
}

function to_num {
	unit=$(echo $1 | grep -o "[K|M|G]*B$")
	declare -i size=$(echo $1 | grep -o "^[0-9]*")
	if [[ $unit == "GB" ]];
	then
		((size=size*1000000000))
	elif [[ $unit == "MB" ]];
	then
		((size=size*1000000))
	elif [[ $unit == "KB" ]];
	then
		((size=size*1000))
	fi
	echo $size
}

function get_end {
	declare -i end=$(to_num $1)
	declare -i size=$(to_num $2)
	((end=end+size))
	byte_size=$(to_byte $end)
	echo $byte_size
}

function make_part {
	part_start=$(last_part_end)
	part_end=$(get_end $part_start $1)
	parted --script $dev mkpart primary ntfs $part_start $part_end
	get_last
	last=$?
	mkfs.ntfs /dev/sdb$last
	mkdir -p /mnt/sdb$last
}

function rm_part {
	parted --script $dev rm $1
}

function selection {
	if [[ $1 == "1" ]]
	then
		check_storage
	fi
	if [[ $1 == "2" ]]
	then
		if [ -z "$2" ];
		then
			echo "Size required"
			exit
		fi
		make_part $2
	fi
	if [[ $1 == "3" ]]
	then
		if [ -z "$2" ];
		then
			echo "Part required"
			exit
		fi
		rm_part $2
	fi
	if [[ $1 == "4" ]]
	then
		exit
	fi
}

if [ -z "$1" ];
then
	while true
	do
		echo -e $options
		read opt
		selection $opt
	done
fi

selection $*
exit
