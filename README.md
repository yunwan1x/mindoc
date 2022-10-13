

# 安装与使用

**如果你的服务器上没有安装golang程序请手动设置一个环境变量如下：键名为 ZONEINFO，值为MinDoc跟目录下的/lib/time/zoneinfo.zip 。**

更多信息请查看手册： [MinDoc 使用手册](/wiki/docs/mindoc/mindoc-summary.md)

对于没有Golang使用经验的用户，可以从 [https://github.com/mindoc-org/mindoc/releases](https://github.com/mindoc-org/mindoc/releases) 这里下载编译完的程序。

如果有Golang开发经验，建议通过编译安装，要求golang版本不小于1.13(需支持`CGO`和`go mod`)。
> 注意: CentOS7上GLibC版本低，需要源码编译, 编译好的二进制文件无法运行。

## 常规编译
```bash
# 克隆源码
git clone https://github.com/mindoc-org/mindoc.git
# go包安装
go mod init github.com/mindoc-org/mindoc
go env -w GOPROXY=https://goproxy.cn,direct 
go mod tidy
# 编译(sqlite需要CGO支持)
go build -ldflags "-w"
# 数据库初始化(此步骤执行之前，需配置`conf/app.conf`)
./mindoc install
# 执行
./mindoc

# 如果编译错误，清空go.mod的所有require，go 1.18的版本要匹配。然后重新编译。
```

MinDoc 如果使用MySQL储存数据，则编码必须是`utf8mb4_general_ci`。请在安装前，把数据库配置填充到项目目录下的 `conf/app.conf` 中。

如果使用 `SQLite` 数据库，则直接在配置文件中配置数据库路径即可.

如果conf目录下不存在 `app.conf` 请重命名 `app.conf.example` 为 `app.conf`。

**默认程序会自动初始化一个超级管理员用户：admin 密码：123456 。请登录后重新设置密码。**

## Linux系统中不依赖gLibC的编译方式

### 安装 musl-gcc
```bash
wget -c http://www.musl-libc.org/releases/musl-1.2.2.tar.gz
tar -xvf musl-1.2.2.tar.gz
cd musl-1.2.2
./configure && make&&make install

```
### 使用 musl-gcc 编译 mindoc
```bash
go mod init github.com/mindoc-org/mindoc
go env -w GOPROXY=https://goproxy.cn,direct && go mod tidy -v

# 设置使用musl-gcc
export GOOS=linux;export GOARCH=amd64;export CC=/usr/local/musl/bin/musl-gcc;export TRAVIS_TAG=temp-musl-v`date +%y%m%d`

go build -o mindoc --ldflags="-linkmode external -extldflags '-static' -w -X 'github.com/mindoc-org/mindoc/conf.VERSION=$TRAVIS_TAG' -X 'github.com/mindoc-org/mindoc/conf.BUILD_TIME=`date`' -X 'github.com/mindoc-org/mindoc/conf.GO_VERSION=`go version`'"
# 验证
./mindoc version
```
# 初次运行
1. ./mindoc install 初始化数据库，初始账密admin 123456
2. 修改conf中的app.conf.example为app.conf
3. ./mindoc运行

# FAQ
1. 用idea 或者goland导入项目飘红，[参考这个解决](https://blog.csdn.net/qq_40677181/article/details/114283374)

