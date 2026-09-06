docker-build:
	git pull
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 327319898773.dkr.ecr.us-east-1.amazonaws.com
	docker build -t 327319898773.dkr.ecr.us-east-1.amazonaws.com/analytics-service:$(image_tag) .
	docker push 327319898773.dkr.ecr.us-east-1.amazonaws.com/analytics-service:$(image_tag)

eks-deploy:
	aws eks update-kubeconfig --name dev
	helm upgrade -i analytics-service ./helm -f helm/values/analytics-service.yml --set image_tag=$(image_tag)

argocd-deploy:
	argocd login a7213ecbc3cc54d73afa7025ac69d22d-402813493.us-east-1.elb.amazonaws.com --insecure --username admin --password cZENgz7gW1q13kcI
	argocd app create analytics-service --sync-policy manual --repo https://github.com/WMP-App/wmp-helm-v1.git --path . --dest-server https://kubernetes.default.svc   --dest-namespace default --helm-set-string image_tag=$(image_tag) --values values/analytics-service.yml