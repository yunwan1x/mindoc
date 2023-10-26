init:
	cp conf/app.conf.example conf/app.conf; \
# 登录admin 123456
build:
	go build -mod=vendor
run:
	./mindoc install
	./mindoc