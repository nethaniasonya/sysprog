#!/bin/bash

cd /restart/sysprog
source env/bin/activate
python3 manage.py runserver 0:8000
