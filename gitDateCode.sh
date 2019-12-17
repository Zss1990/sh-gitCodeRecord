#!/bin/bash
# 统计某段时间内新增的代码行数 
# 例如：sh gitDateCode.sh -p [path] -s [beginDate] -e [endDate]


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
    	perDate=`date -v-7d +%Y-%m-%d`
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


PATH_=''
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
    *)

        # helpInfo $1
        ;;
    esac
    shift
done

tryDateCode ${PATH_} ${BEGINDATE_} ${ENDDATE_}