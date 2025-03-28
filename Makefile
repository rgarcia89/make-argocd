EXPORT_ALL_VARIABLES:
.ONESHELL:

CHARTVERSION := 0.27.0
ENV ?= $(or $(ARGOCD_ENV_ENV),staging)
NAMESPACE := trivy

.PHONY: render
render: helm-template

# .PHONY: deploy
# deploy: helm-install

.PHONY: deploy-app
deploy-app:
	kubectl apply -n argocd -k ./environments/$(ENV)

.PHONY: helm-prep
helm-prep:
ifeq ($(DEBUG), true)
	@echo
	@echo "Installing Helm Repo"
endif
	@helm repo add aqua https://aquasecurity.github.io/helm-charts/ $(QUIET)
	@helm repo update aqua $(QUIET)

.PHONY: helm-crds
helm-crds: helm-prep
ifeq ($(DEBUG), true)
	@echo
	@echo "Installing CRDs"
	@helm show crds --version $(CHARTVERSION) aqua/trivy-operator | kubectl apply -f -
endif
	@helm show crds --version $(CHARTVERSION) aqua/trivy-operator

.PHONY: helm-template
helm-template: helm-prep helm-crds
ifeq ($(DEBUG), true)
	@echo
	@echo "Templating Chart for $(ENV) environment"
endif
	@helm template trivy \
	--namespace $(NAMESPACE) \
	--values base/values.yaml \
	--values environments/$(ENV)/values.yaml \
	--api-versions monitoring.coreos.com/v1 \
	--version $(CHARTVERSION) \
	aqua/trivy-operator

# Suppress output if DEBUG is not enabled
QUIET := $(if $(DEBUG),,>/dev/null 2>&1)
