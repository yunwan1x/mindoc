 
# 登录admin 123456
build:
	go build -mod=vendor
run:
	test-f  conf/app.conf || cp conf/app.conf.example conf/app.conf; \
	./mindoc install ; \
	./mindoc