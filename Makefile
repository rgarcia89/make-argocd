EXPORT_ALL_VARIABLES:
.ONESHELL:

NAMESPACE := aqua
CHARTVERSION := 0.27.0

.PHONY: helm-prep
helm-prep:
ifeq ($(DEBUG), true)
	@echo
	@echo "Installing Helm Repo"
endif
	@helm repo add aqua https://aquasecurity.github.io/helm-charts/ $(QUIET)
	@helm repo update aqua $(QUIET)

.PHONY: helm-template
helm-template: helm-prep
ifeq ($(DEBUG), true)
	@echo
	@echo "Templating Chart"
endif
	@helm template trivy  \
	--namespace $(NAMESPACE) \
	--version $(CHARTVERSION) \
	aqua/trivy-operator

# Suppress output if DEBUG is not enabled
QUIET := $(if $(DEBUG),,>/dev/null 2>&1)