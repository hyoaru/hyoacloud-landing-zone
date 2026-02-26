.PHONY: lint bootstrap deploy

lint:
	@echo "Linting the project"
	.scripts/lint.sh
	@echo "Successfully linted the project"

bootstrap:
	@echo "Bootstrapping the project"
	.scripts/bootstrap.sh
	@echo "Successfully bootstrapped the project"

deploy:
	@echo "Deploying the project"
	.scripts/deploy.sh
	@echo "Successfully deployed the project"


