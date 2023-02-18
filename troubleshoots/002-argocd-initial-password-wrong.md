# ArgoCD Initial Password sometimes (mostly) wrong

## 😲 Issue

When initialize ArgoCD, the default `admin` password sometimes (and mostly) is not sync with the `argocd-intial-admin-secret` secret in k8s


## 💡 Solution / Workaround

* After ArgoCD initilaization, access the right initial password with this command (assuming argocd is initialize in `argocd` namespace)
```bash
kubectl get secret -n argocd argocd-initial-admin-secret  --template={{.data.password}} | base64 -D
```

## 🚀 Improvment Ideas

## 📖 References

* [argocd-initial-admin-secret password invalid](https://github.com/argoproj/argo-cd/issues/10708)