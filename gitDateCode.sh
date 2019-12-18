#!/bin/bash
# 统计某段时间内新增的代码行数 
# 例如：sh gitDateCode.sh -p [path] -s [beginDate] -e [endDate]
# sh gitDateCode.sh -p /Users/shuaishuai/zhushuaishuai/CodeStorage/git.evun/ADMP-repository -n shuaishuai.zhu
# sh gitDateCode.sh -p /Users/shuaishuai/zhushuaishuai/CodeStorage/git.evun/ADMP-repository -n shuaishuai.zhu -s 2019-12-01 -e 2019-12-18

function tryDateCode ()
{
	path=$1
	beginDate=$2
	endDate=$3
	 if [ ! -n "$path" ];then
        path=`pwd`
        echo "没有传入-p默认为当前目录：${path}"
    fi
    if [ ! -n "$beginDate" ];then
    	#上个月的年月
    	# perDate=$(date -d last-month +%Y-%m-%d)
    	#七天前的时间 https://www.jibing57.com/2017/08/03/date-command-on-Linux-and-Mac/
    	# perDate=$(date --date="7 days ago +%Y-%m-%d")
    	perDate=`date -v-1d +%Y-%m-%d`
    	beginDate=$perDate
        echo "没有传入-s 默认为七天前：${beginDate}"
    fi
    if [ ! -n "$endDate" ];then
    	#今天的时间
    	curDate=$(date "+%Y-%m-%d")
    	endDate=$curDate
        echo "没有传入-e 默认为今天的：${endDate}"
    fi
    cd ${path}
    echo "----->当前目录`pwd`<----"

    echo "----->从${beginDate}到${endDate}期间的代码<----"
    git log  --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat:  --since=${beginDate} --until=${endDate} --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done

    cd ./..
}


function tryDateTotalCord() {
    path=$1
    name=$2
    beginDate=$3
    endDate=$4

    if [ ! -n "$path" ];then
        path=`pwd`
        echo "没有传入-p默认为当前目录：${path}"
    fi
    if [ ! -n "$beginDate" ];then
        perDate=`date -v-1d +%Y-%m-%d`
        beginDate=$perDate
        echo "没有传入-s 默认为七天前：${beginDate}"
    fi
    if [ ! -n "$endDate" ];then
        #今天的时间
        curDate=$(date "+%Y-%m-%d")
        endDate=$curDate
        echo "没有传入-e 默认为今天的：${endDate}"
    fi

    echo "--->开始统计${name}从${beginDate}到${endDate}的代码量<---"

    echo "在目录地址：${path} 下各个仓库"

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
            # eval `git log  --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat:  --since=${beginDate} --until=${endDate} --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "_add=%s; _subs=%s; _loc=%s", add, subs, loc }' -; done`

            eval `git log --author=${name} --pretty=tformat: --since=${beginDate} --until=${endDate} --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "_add=%s; _subs=%s; _loc=%s", add, subs, loc }' -`
            
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
BEGINDATE_=''
ENDDATE_=''
# 读取参数
while [ -n "$1" ]; do
    case "$1" in
    -p)
        PATH_=$2
        shift
        ;;
    -s)
        BEGINDATE_=$2
        shift
        ;;
    -e)
        ENDDATE_=$2
        shift
        ;;
    -n)
        NAME_=$2
        shift
        ;;
    *)

        # helpInfo $1
        ;;
    esac
    shift
done

# tryDateCode ${PATH_} ${BEGINDATE_} ${ENDDATE_}

tryDateTotalCord  ${PATH_} ${NAME_} ${BEGINDATE_} ${ENDDATE_}



