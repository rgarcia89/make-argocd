# ArgoCD Multi-Environment Deployment

This repository contains the configuration for deploying Trivy across multiple environments using ArgoCD and GitLab CI.

## Directory Structure

```
make-argocd/
├── base/
│   ├── application.yaml     # Base ArgoCD application template
│   ├── kustomization.yaml   # Base kustomization config
│   └── values.yaml         # Base values for all environments
├── environments/
│   ├── staging/
│   │   ├── kustomization.yaml  # Staging-specific customizations
│   │   └── values.yaml         # Staging-specific values
│   └── production/
│       ├── kustomization.yaml  # Production-specific customizations
│       └── values.yaml         # Production-specific values
└── Makefile                 # Build and deployment automation
```

## How It Works

### Deployment Flow

1. **GitLab Runner Setup**
   - Each cluster has a GitLab runner installed
   - Runners are configured with the `ENV` variable set to their respective environment (staging/production)

2. **Initial Deployment**
   - GitLab CI triggers the runner in the target cluster
   - Runner executes `make deploy-app ENV="$ENV"`
   - Deploys the ArgoCD application manifest for that environment

3. **Continuous Deployment**
   - Once the ArgoCD application is deployed, ArgoCD takes over
   - ArgoCD calls make-template using the make-render plugin which by using the `ARGOCD_ENV_ENV` variable determines the environment
   - ArgoCD monitors the Git repository for changes
   - When changes are detected, ArgoCD automatically syncs the application state

### Environment Configuration

- `base/` contains the template ArgoCD application and common configurations
- `environments/<env>/` contains environment-specific customizations
- Kustomize is used to patch the base configuration for each environment
- Each environment can specify its own values and configurations while inheriting from the base

### Usage

To deploy to a specific environment:
```bash
# Deploy to staging
make deploy-app ENV=staging

# Deploy to production
make deploy-app ENV=production
```

When running in GitLab CI, the environment is automatically determined by the `ENV` variable set in the runner.

## Prerequisites

- Kubernetes cluster
- ArgoCD installed in the cluster
- GitLab runner configured with appropriate environment variables
- `kubectl` and `kustomize` installed

## Notes

- The Makefile automatically handles the `ARGOCD_ENV` prefix required by ArgoCD
- Environment-specific configurations are managed through Kustomize overlays
- Base configurations are synchronized to environment directories during deployment