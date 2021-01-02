from django.shortcuts import render
import os

s = os.system

# Create your views here.
def index(request):
	res = get_table()

	context = {
		"result": res,
	}
	return render(request, 'index.html', context)

def detail(request):
    return render(request, 'detail.html')

# def detail(request, id):
#     berat = Entry.objects.get(id=id)
#     context = {
#         'data': berat,
#     }
#     return render(request, 'detail.html', context)


#####################################
# Additional Code For USB Partition #
#                                   #
#   "temp" File Will Be Uses As A   #
# Temporary Log for Every Function  #
#####################################

# Function to get table
# Also to check if there are any usb drive plugged in
# Always call this function after make or deleting partition
# The table will be save to result as a list
# With part_no, start_memory, end_memory, size, partition_type, file_system, flag
# In this function, result only have part_no and size
def get_table():
	s('./partition.sh 1 > temp')
	with open('temp', 'r') as f:
		result = []
		for line in f:
			print(line)
			if (line == "No USB detected\n"):
				return # Show Landing Page
			result.append(line.split())



		device_size = result[len(result) - 1][3]
		for line in result:
			if ("primary" not in line):
				result.remove(line)
			result[result.index(line)] = [result[0], result[3]]

# Function to make partition
# Max partition that USB drive can hold are 4
# size parameter can be filled with [0-9]*[K|M|G]*B
# Ex. 120MB
# Try to mitigate any error that can be cause in JS file
def make_part(size):
	s('./partition.sh 2 ' + size)

# Function to delete partition
# Parameted used are the part_no
# Try to mitigate any error that can be cause in JS file
def delete(partition):
	s('.partition 3.sh ' + partition)
