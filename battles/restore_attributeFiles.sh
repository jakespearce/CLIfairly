#!/bin/bash

tmp_file_path="${HOME}/pokemon/gui/battles/tmp_files"

cd "$tmp_file_path"

rm *.pokemon

cp "${tmp_file_path}/clean_files/"* ..


