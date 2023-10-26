init:
	go mod init github.com/mindoc-org/mindoc;
	cp conf/app.conf.example conf/app.conf; \
# 登录admin 123456
run:
	./mindoc install
	./mindoc