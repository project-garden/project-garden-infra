# ArgoCD Cannot Pull Repositories

## 😲 Issue

ArgoCD goes nuts when it try to pull the target repositories but cannot do so.


## 💡 Solution / Workaround

* There are firewall rules that need to enabled. k8s cluster need to eggress to internet. We don't know the implication, but let's make it happen first

* [Fixed in this commit](https://github.com/project-garden/project-garden-infra/commit/df4ba6b76ed420d3f3e4eb215f0c1855cfa20434)

## 🚀 Improvment Ideas

## 📖 References

* [argocd-initial-admin-secret password invalid](https://github.com/argoproj/argo-cd/issues/10708)