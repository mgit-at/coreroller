export GOROOT := /opt/go
export GOPATH := $(shell pwd)/gopath
export SRCDIR := $(shell pwd)
export PATH   := $(GOROOT)/bin:$(PATH)

all: build

build:
	mkdir -p $(GOPATH)
	go get -v -u github.com/constabulary/gb/...
	cd $(SRCDIR)/backend/ && $(GOPATH)/bin/gb build cmd/rollerd && $(GOPATH)/bin/gb build cmd/initdb
	mv $(SRCDIR)/backend/bin/initdb $(SRCDIR)/backend/bin/coreroller-initdb
	cd $(SRCDIR)/frontend && npm install && npm run build
	find $(SRCDIR)/frontend/built -type f -exec chmod -x {} \;

clean:
	rm -rf $(GOPATH)

run:
	LOGXI="rollerd=DBG,omaha=DBG,syncer=DBG" LOGXI_FORMAT="text" $(SRCDIR)/backend/bin/rollerd -http-static-dir $(SRCDIR)/frontend/built

.PHONY: all clean
