download:
	wget -c https://dl.google.com/go/go1.21.3.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local; \
	export PATH=$PATH:/usr/local/go/bin

# 登录admin 123456,需要go>=1.18。-w表示不需要调试信息


build:
	GOOS=linux GOARCH=amd64 go build -o mindoc --ldflags=" -w -X 'github.com/mindoc-org/mindoc/conf.VERSION=`git rev-parse --short HEAD`' -X 'github.com/mindoc-org/mindoc/conf.BUILD_TIME=`date`' -X 'github.com/mindoc-org/mindoc/conf.GO_VERSION=`go version`'" -mod=vendor
	 
run:
	test-f  conf/app.conf || cp conf/app.conf.example conf/app.conf; \
	./mindoc install ; \
	./mindoc