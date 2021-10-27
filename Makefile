.DEFAULT_GOAL := help

.PHONY: help run build testdeploy
help:
	@grep -E '^[a-z0-9A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build
	rm -rf move_jismeshcode.egg-info/* dist/* build/*
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/core --from markdown --to rst README.md -o README.rst
	python setup.py sdist bdist_wheel

testdeploy: ## deploy to test environment
	twine upload --repository testpypi dist/*

deploy: ## deploy to production environment
	twine upload --repository pypi dist/*
