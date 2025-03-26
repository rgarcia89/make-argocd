EXPORT_ALL_VARIABLES:
.ONESHELL:

NAMESPACE := kyverno
CHARTVERSION := 3.3.7


.PHONY: helm-prep
helm-prep:
	@echo
	@echo Installing Helm Repo
	helm repo add kyverno https://kyverno.github.io/kyverno/
	helm repo update kyverno

.PHONY: helm-template
helm-template: helm-prep
	@echo
	@echo Templating Chart
	helm template kyverno  \
	--namespace $(NAMESPACE) \
	--version $(CHARTVERSION) \
	kyverno/kyverno