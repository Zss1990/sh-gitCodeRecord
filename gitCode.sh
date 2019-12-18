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


function tryTotalCord() {
    path=$1
    name=$2
    if [ ! -n "$path" ];then
        path=`pwd`
        echo "没有传入-p默认为当前目录：${path}"
    fi
    echo ${path}

    declare -i ADDED=0
    declare -i REMODVED=0
    declare -i TOTAL=0

    filelist=`ls $path`
    outfile="build.sh"
    for file in ${filelist}:
    do
        echo "----------------------------------> ${file}"
        cd ${path}/$file
        if [[ ${name} ]]; then
            # 统计单个人的
            echo "${name}:"
            # git log --author=${name} --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { ${ADDED} += add; $REMODVED += subs; $TOTAL += loc; printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
            # git log --author=${name} --pretty=tformat: --numstat | awk -v ADDED_=$ADDED '{ add += $1; subs += $2; loc += $1 - $2 } END {  printf "added lines: %s, removed lines: %s, total lines: %s\n all: %s\n", add, subs, loc ,ADDED_}' -
            # git log --author=${name} --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
            eval `git log --author=${name} --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "_add=%s; _subs=%s; _loc=%s", add, subs, loc }' -`
            
            echo " added lines: $_add, removed lines: $_subs, total lines: $_loc "

            if [[ $_add ]]; then
                ADDED=`expr $ADDED + $_add`
            fi
            if [[ $_subs ]]; then
                REMODVED=`expr $REMODVED + $_subs`
            fi
            if [[ $_loc ]]; then
                TOTAL=`expr $TOTAL + $_loc`
            fi

        else
             # 统计每个人的
            git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
        fi
        cd ./..
    done
    echo ""
    echo " <------------------------------------------------------------------------------------>  "
    echo "${name}:总代码总量："
    echo "-----> added lines: $ADDED, removed lines: $REMODVED, total lines: $TOTAL "
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

# tryRecord ${PATH_} ${NAME_}
tryTotalCord ${PATH_} ${NAME_}

