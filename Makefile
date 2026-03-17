.PHONY: lint bootstrap build deploy

lint:
	@chmod +x .scripts/lint.sh
	.scripts/lint.sh
	
bootstrap: lint
	@chmod +x .scripts/bootstrap.sh
	.scripts/bootstrap.sh

build: lint
	@chmod +x .scripts/build.sh
	.scripts/build.sh

deploy: build
	@chmod +x .scripts/deploy.sh
	.scripts/deploy.sh
