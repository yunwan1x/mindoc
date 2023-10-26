test:
	go mod init github.com/mindoc-org/mindoc; \
	go mod tidy ;\
	go build -ldflags "-w"
# 初始化，只需要做一次
init:
	cp conf/app.conf.example conf/app.conf; \
	./mindoc install
# 登录admin 123456
run:
	./mindoc