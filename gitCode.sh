#!/bin/bash

# 使用方法
# sh test.sh -p [文件地址] -n [要统计的git用户名字]


function tryRecord() {
    path=$1
    name=$2
    if [ ! -n "$path" ];then
        path=`pwd`
        echo "没有传入-p默认为当前目录：${path}"
    fi
    # path=`pwd`
    # 
    # 
     echo ${path}

    filelist=`ls $path`
    outfile="build.sh"
    for file in ${filelist}:
    do

        echo "----------------------------------> ${file}"
        cd ${path}/$file
        echo `pwd`

        if [[ ${name} ]]; then
            # 统计单个人的
            # printf "%s:" ${name}
            echo "${name}:"
            git log --author=${name} --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END {  printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
        else
             # 统计每个人的
            git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
        fi
        cd ./..

      # echo $file
    done
    echo $1
}


PATH_=''
NAME_=''
# 读取参数
while [ -n "$1" ]; do
    case "$1" in
    -p)
        PATH_=$2
        shift
        ;;
    -n)
        NAME_=$2
        shift
        ;;
    --lib)
        PATH_="NO"
        ;;
    *)

        # helpInfo $1
        ;;
    esac
    shift
done

tryRecord ${PATH_} ${NAME_}
