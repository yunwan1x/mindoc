download:
	wget -c https://dl.google.com/go/go1.21.3.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local; \
	echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

# 登录admin 123456,需要go>=1.18。-w表示不需要调试信息

commit:
	git add . && git commit -m 'add'&& git push 
build:
	GOOS=linux GOARCH=amd64 go build -o mindoc --ldflags=" -w -X 'github.com/mindoc-org/mindoc/conf.VERSION=`git rev-parse --short HEAD`' -X 'github.com/mindoc-org/mindoc/conf.BUILD_TIME=`date`' -X 'github.com/mindoc-org/mindoc/conf.GO_VERSION=`go version`'" -mod=vendor
	 
run:
	test -f  conf/app.conf || cp conf/app.conf.example conf/app.conf; \
	test -f  runtime || mkdir runtime; \
	./mindoc install ; \
	./mindoc

deploy:
	@ssh -p 28246 root@www.vs2010wy.top "cd /root/mindoc;git pull && echo pull success"
	@ssh -p 28246 root@www.vs2010wy.top "systemctl stop mindocd && echo stop success"
	@scp -P 28246 mindoc  root@www.vs2010wy.top:/root/mindoc
	@ssh -p 28246 root@www.vs2010wy.top "systemctl start mindocd&& echo start success" 