NAME=alpine
VERSION=$(shell cat VERSION)

build:
	docker build -t malice/$(NAME):$(VERSION) .
	sed -i.bu 's/docker image-.*-blue/docker image-$(shell docker images --format "{{.Size}}" malice/$(NAME):$(VERSION))-blue/g' README.md

release:
	rm -rf release && mkdir release
	go get github.com/progrium/gh-release/...
	cp build/* release
	gh-release create maliceio/$(NAME) $(VERSION) \
		$(shell git rev-parse --abbrev-ref HEAD) $(VERSION)
	# glu hubtag maliceio/malice-$(NAME) $(VERSION)

circleci:
	rm -f ~/.gitconfig
	go get -u github.com/gliderlabs/glu
	glu circleci

.PHONY: build release
