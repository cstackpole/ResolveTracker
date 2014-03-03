#!/bin/bash -
#
# Copyright (C) 2014  cstackpole
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# See COPYRIGHT file for full notice.
#
#
#
# This program is to help me stay focused on a resolution and track how
# frequently I perform the task. I have tried to abstract everything such that 
# it can be used to track anything. 
#
# This is the v1.0 re-write. The original was completly written in Bash and
# saved all data in a text file which caused numerous parsing errors on a 
# regular basis.
#
# The fields tracked are: Date, StartTime, TimeInvested, Tags, Score, Notes
# Date: The day of the event. (20140128)
# StartTime: When the event began in HH:MM format (eg: 15:30)
# TimeInvested: The amount of time invested in the event in minutes. (eg: 70)
# Tags: Originally "Title", this field allows for comma seperated list of tags
#       for sorting, statistics, and whatnot.
# Score: Was the effort and time invested worth it? Feel free to leave this 0
#        I am experimenting with its usefulness.
# Notes: Any details you might want to associate with this event.
#
# Exit Codes:
#  1: Function usage called
#  2: Wrong binary
#  3: Need version 3 or better of sqlite
#  4: User bailed on creating a new database
#  5: Found a database file that does not appear to be a SQLite 3.x database
#  6: Found a file the user doesn't want to overwrite.
#  7: Found a database without the RslvTrkr table
#  8: Database entry failed
#
# TODO: Clean up DisplayEvents output to make it look pretty.
# TODO: Enable option 3
#       Most common time of day (morning afternoon) 
#       Most common day of week
#       Most common tags
#	All tag activity
# TODO: Enable option 4
# TODO: Enable option 5
# TODO: Add GUI frontend
#
################################################################################
# Default variables and source our functions
################################################################################
sqliteapp="sqlite3"
rtdb="${HOME}/.ResolveTracker/ResolveTracker.db"
createdb="False"
. `pwd`/ResolveTracker.functions
################################################################################
# Process arguments
################################################################################
while getopts "cd:hj:s:" opt
do
	case "$opt" in
		c) createdb="True" ;;
		d) rtdb=$OPTARG ;;
		h) usage ;;
		j) selectionjump=$OPTARG ;;
		s) sqliteapp=$OPTARG ;;
		*) usage ;;
	esac
done

# Test to see if we have a working sqlite binary
if type -p $sqliteapp
then
	echo "Found $sqliteapp."
else
	echo ""
	echo "$sqliteapp does not appear to be a valid program."
	echo ""
	echo "Please ensure that SQLite is installed on your system and try"
	echo "again. You may want/need to pass in the full path with the -s"
	echo "flag. If you did this and get this error, it may mean that the"
	echo "path is incorrect, the path is not a valid binary, or this"
	echo "program does not have access rights to run it."
	echo ""
	echo ""
	exit 2
fi

# Verify we have sqlite version 3 or better.
sqliteversion=`$sqliteapp -version | cut -c 1`
if [ "$sqliteversion" -lt 3 ]
then
	echo "Sorry, but this program only works with sqlite3."
	echo ""
	exit 3
fi

# Verify that the database file exists and is a file
if [ -f $rtdb -a "$createdb" == "False" ]
then
	if [ "`file -b $rtdb`" == "SQLite 3.x database" ]
	then
		echo "Found the database file: $rtdb"
		if [ "`$sqliteapp $rtdb '.tables' | grep RslvTrkr`" == "" ]
		then
			echo "Doesn't appear to have the ReslvTrkr table."
			echo "Bailing."
			echo ""
			exit 7
		fi
	else
		echo "Found the database file: $rtdb"
		echo "But it doesn't appear to be the right type. Don't want to"
		echo "break anything, so I am bailing here. Please verify that"
		echo "this is the right database file. It should be a"
		echo "SQLite 3.x database, but this file appears to be a"
		file -b $rtdb
		echo "Sorry."
		echo ""
		exit 5
	fi
elif [ "$createdb" == "True" ]
then
	echo "User asked to create a new DB."
else
	echo "$rtdb does not appear to be a file. Do you want to create a new"
	echo "database in ${rtdb}? [y/n]"
	read usercreate
	case "$usercreate" in
		y|Y) createdb="True" ;;
		n|N) echo "OK. Stopping program."; exit 4 ;;	
		*) echo "Not sure what that means. Try looking at the usage." ;
		   usage ;;
	esac
fi

# Create a DB if need be.
if [ "$createdb" == "True" ]
then
	echo "Creating new db $rtdb"
	if [ -f $rtdb ]
	then
		echo "Err...Found a file by that name. Overwrite? [y|n]"
		read useroverwrite
		# I am too scared to delete, so I am just moving instead.
		# This might bite me later, but I think it best at the moment.
		case "$useroverwrite" in
			y|Y) mv $rtdb{,.bkp_`date '+%F-%H-%M'`} ;;
			*) echo "Bailing!" ; exit 6 ;;
		esac
	fi
	$sqliteapp $rtdb "create table RslvTrkr\
			 (id INTEGER PRIMARY KEY,\
			 date DATE,
			 time INTEGER,
			 tags TEXT,
			 score INTEGER,
			 notes TEXT);"
fi

# If we have made it this far then everything should be good to fire up the
# menu and do stuff with the database. Can't forget to pass in the 
# selectionjump variable in case the user wants to jump to a section.
menu $selectionjump
