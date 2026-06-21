docker-build:
	git pull
	docker build -t analytics-service .