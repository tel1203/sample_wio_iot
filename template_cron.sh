#!/bin/sh

DIR="..."
DIR_RUBY="..."

cd $DIR
$DIR_RUBY/ruby app_enviroment-monitoring.rb TOKEN_WIONODE TOKEN_THINGSPEAK FIELDNAME1 FIELDNAME2 >> RESULT_STDOUT.txt 2>> RESULT_STDERR.txt

