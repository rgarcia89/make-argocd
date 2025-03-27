EXPORT_ALL_VARIABLES:
.ONESHELL:

NAMESPACE := trivy
CHARTVERSION := 0.27.0

.PHONY: render
render: helm-template

# .PHONY: deploy
# deploy: helm-install

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
	@echo "Templating Chart"
endif
	@helm template trivy \
	--namespace $(NAMESPACE) \
	--values values.yaml \
	--version $(CHARTVERSION) \
	aqua/trivy-operator

# Suppress output if DEBUG is not enabled
QUIET := $(if $(DEBUG),,>/dev/null 2>&1)