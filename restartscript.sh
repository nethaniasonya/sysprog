#!/bin/bash
### BEGIN INIT INFO
#Provides:	restartscript
#Required-Start:	$all
#Required-Stop:
#Default-Start:		2 3 4 5
#Default-Stop:
#Short-Description: 	run app
### END INIT INFO

usr/bin/python3 home/user/restart/sysprog/python3 manage.py runserver 0:8000

