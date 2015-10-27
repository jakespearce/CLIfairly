#!bin/bash

# changes a key value in a config file to a value we specify.
change_conf_value(){
  config_file_path=$1
  key_to_change=$2
  new_value=$3
  sed -i "s/\($key_to_change *= *\).*/\1$new_value/" $config_file_path
}
