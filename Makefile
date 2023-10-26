test:
	go mod init github.com/mindoc-org/mindoc; \
	go mod tidy ;\
	go build -ldflags "-w"