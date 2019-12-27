# gitCode.sh

会默认统计指定该文件夹目录下,各个下一级目录文件每一个的文件夹（代码库）的代码行数

### 统计某个文件夹下所有git仓库,某人总行数
` sh gitCode.sh -p [需要统计代码文件夹上级目录地址] -n [要统计的git用户名字]`

### 统计某个文件夹下所有git仓库,某段时间内新增的代码总行数
`sh gitDateCode.sh -p [path] -n [gitName] -s [beginDate] -e [endDate]`

#### 示例 
`sh gitDateCode.sh -p /Users/.../CodeStorage/git.evun/ADMP-repository -n shuai`
`sh gitDateCode.sh -p /Users/.../CodeStorage/git.evun/ADMP-repository -n shuai -s 2019-12-01 -e 2019-12-18`
