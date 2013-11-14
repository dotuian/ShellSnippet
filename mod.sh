#!/bin/bash

# exctute
# ./mod.sh file_type input_folder output_folder
# ./mod.sh *.txt /tmp /data/

# paramater count 
if [ ! $# -eq 3 ]; then
    echo "[ERROR] error paramater."
    exit
fi

# file type
file_type="${1}"

# input foloder
if [ -d "${2}" ]; then  
    folder="${2}"
else
    echo "[ERROR] input folder is not exsit."
    exit 
fi

# output folder
if [ -d "${3}" ]; then
    output="${3}"
else
    echo "[ERROR] output folder is not exsit."
    exit
fi

# search file
find ${folder} -name "${file_type}" | while read filename ; 
do
    # file type
    file_type=`echo ${filename##*.}`

    # file size
    file_size=`stat "${filename}" | sed -n '2,1p' | awk '{print $2}' `
    # file modify time
    file_modify=`stat "${filename}" | sed -n '6,1p' | awk '{print $2, $3}' | sed -e 's/[-: ]//g' `

    # output folder 
    path="${output}/${file_modify:0:6}"
    if [ ! -d "${path}" ]; then
        mkdir -p ${path}
        echo "folder(${path}) is created . "
    fi

    # new file full name 
    new_file_name=`echo ${path}/${file_modify}_[${file_size}].${file_type}`

    if [ ! -f "${new_file_name}" ]; then
        mv "${filename}" "${new_file_name}"
    else
        echo "file(${new_file_name}) is exsit, can not be removed. "
    fi
done
echo "finished !"
exit


