image := groventure/uchiwa:latest

default: build

build: Dockerfile
	docker build --rm -t '$(image)' .
