# GoRTMP build entry.
# Default target builds the library and all demo binaries into build/.

GO       ?= go
BUILD    ?= build
GOFILES  := $(wildcard *.go)
MODFILES := go.mod go.sum

.PHONY: all build lib demo test vet fmt clean help

all: build

build: lib demo

lib: $(BUILD)/libgortmp.a

$(BUILD)/libgortmp.a: $(GOFILES) $(MODFILES)
	@mkdir -p $(BUILD)
	$(GO) build -o $@ .

demo: $(BUILD)/rtmp_publisher $(BUILD)/rtmp_player $(BUILD)/rtmp_server $(BUILD)/rtmp_proxy

$(BUILD)/rtmp_publisher: $(wildcard demo/publisher/*.go) $(GOFILES) $(MODFILES)
	@mkdir -p $(BUILD)
	$(GO) build -o $@ ./demo/publisher

$(BUILD)/rtmp_player: $(wildcard demo/player/*.go) $(GOFILES) $(MODFILES)
	@mkdir -p $(BUILD)
	$(GO) build -o $@ ./demo/player

$(BUILD)/rtmp_server: $(wildcard demo/server/*.go) $(GOFILES) $(MODFILES)
	@mkdir -p $(BUILD)
	$(GO) build -o $@ ./demo/server

$(BUILD)/rtmp_proxy: $(wildcard demo/proxy/*.go) $(GOFILES) $(MODFILES)
	@mkdir -p $(BUILD)
	$(GO) build -o $@ ./demo/proxy

test:
	$(GO) test ./...

vet:
	$(GO) vet ./...

fmt:
	$(GO) fmt ./...

clean:
	rm -rf $(BUILD)

help:
	@echo "Targets:"
	@echo "  make          - build library and all demos into $(BUILD)/"
	@echo "  make lib      - build library only"
	@echo "  make demo     - build all demo binaries"
	@echo "  make test     - go test ./..."
	@echo "  make vet      - go vet ./..."
	@echo "  make fmt      - gofmt all packages"
	@echo "  make clean    - remove $(BUILD)/"
