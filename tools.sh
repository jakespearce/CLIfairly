#!bin/bash

# changes a key value in a config file to a value we specify.
# usage: change_conf_value $config_file_path $key_to_change $new_value
# eg. change_conf_value /.../gui/character.cfg "level" 99
change_conf_value(){

	config_file_path=$1
  	key_to_change=$2
  	new_value=$3

  	sed -i "s/\($key_to_change *= *\).*/\1$new_value/" $config_file_path
}
