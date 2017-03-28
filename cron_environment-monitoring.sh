#!/bin/sh

DIR="/home/tel/git/sample_wio_iot"
DIR_RUBY="/home/tel/.rbenv/shims"

cd $DIR
$DIR_RUBY/ruby app_enviroment-monitoring.rb 0e0d033a76a2389311a3fa237eb35e75 HSD8CQ7O8NH646YH field3 field4 >> ./tmp_output11.txt 2>> ./tmp_output12.txt
sleep 20 
$DIR_RUBY/ruby app_enviroment-monitoring.rb e828e0e062e5cdb10a526c4951b91184 HSD8CQ7O8NH646YH field1 field2 >> ./tmp_output21.txt 2>> ./tmp_output22.txt 

