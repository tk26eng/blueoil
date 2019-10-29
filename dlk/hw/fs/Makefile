IMAGE_NAME:=fs_work

build:
	docker build -t $(IMAGE_NAME) .
run:
	docker run -v `pwd`/work:/work -it $(IMAGE_NAME) /bin/bash
