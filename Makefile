EXPORT_ALL_VARIABLES:
.ONESHELL:

NAMESPACE := kyverno
CHARTVERSION := 3.3.7


.PHONY: helm-prep
helm-prep:
ifeq ($(DEBUG), true)
	@echo
	@echo "Installing Helm Repo"
endif
	@helm repo add kyverno https://kyverno.github.io/kyverno/ $(QUIET)
	@helm repo update kyverno $(QUIET)

.PHONY: helm-template
helm-template: helm-prep
ifeq ($(DEBUG), true)
	@echo
	@echo "Templating Chart"
endif
	@helm template kyverno  \
	--namespace $(NAMESPACE) \
	--version $(CHARTVERSION) \
	kyverno/kyverno

# Suppress output if DEBUG is not enabled
QUIET := $(if $(DEBUG),,>/dev/null 2>&1)