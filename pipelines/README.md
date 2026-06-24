# Pipelines — Kubernetes & On-Premise

Pipelines para desplegar aplicaciones en **Kubernetes on-premise** y en
**servidores Linux** vía Ansible. Sin dependencia de Azure.

Todos siguen el mismo flujo:

```
build → plan/diff (visible) → aprobación manual → deploy
```

---

## Ficheros

| Pipeline | GitHub Actions | Azure DevOps | Jenkins |
|---|---|---|---|
| Kubernetes On-Premise | `.github/workflows/k8s-onpremise.yml` | `pipelines/azure-devops/k8s-onpremise.yml` | `pipelines/jenkins/Jenkinsfile-k8s-onpremise` |
| Ansible (VMs) | `.github/workflows/ansible-deploy.yml` | `pipelines/azure-devops/ansible-deploy.yml` | `pipelines/jenkins/Jenkinsfile-ansible` |

---

## Kubernetes On-Premise

Autenticación: **kubeconfig guardado como secreto** (base64-encoded).
Sin dependencia de Azure — válido para cualquier cluster k8s (Rancher, RKE2,
k3s, OpenShift, vanilla kubeadm...).

### Generar el secreto

```bash
# Con acceso al cluster:
base64 -w0 ~/.kube/config

# Guardar en:
#   GitHub  → Settings → Secrets → KUBECONFIG_DEV / _PRE / _PROD
#   AzDevOps → Library → Variable Group → KUBECONFIG_B64 (marcar secreto)
#   Jenkins  → Credentials → Secret file → KUBECONFIG_DEV / _PRE / _PROD
```

**Recomendación**: no uses el kubeconfig de admin. Crea un ServiceAccount
con permisos mínimos (get/list/update Deployments en el namespace concreto).

### Secrets/variables necesarias

| Variable | Descripción |
|---|---|
| `REGISTRY_HOST` | Hostname del registry (Harbor, Nexus, etc.) |
| `REGISTRY_USER` | Usuario del registry |
| `REGISTRY_PASSWORD` | Contraseña del registry |
| `APP_NAME` | Nombre de la aplicación |
| `KUBECONFIG_DEV/PRE/PROD` | kubeconfig en base64, uno por entorno |

---

## Ansible On-Premise

Para servidores Linux que corren Docker directamente.

### Estructura esperada

```
ansible/
  inventories/
    dev/hosts.ini
    pre/hosts.ini
    prod/hosts.ini
  playbooks/
    deploy.yml
```

### Secrets/variables necesarias

| Variable | Descripción |
|---|---|
| `REGISTRY_HOST` | Hostname del registry |
| `REGISTRY_USER` | Usuario del registry |
| `REGISTRY_PASSWORD` | Contraseña del registry |
| `APP_NAME` | Nombre de la aplicación |
| `SSH_PRIVATE_KEY` | Clave privada SSH del usuario de deploy |

### Flujo

1. **Build** — construye la imagen y la sube al registry
2. **Plan** — `ansible-playbook --check --diff` (dry-run, sin cambios reales)
3. **Approval** — muestra el diff y espera confirmación humana
4. **Deploy** — ejecuta el playbook real

El playbook incluido (`ansible/playbooks/deploy.yml`):
- Verifica que Docker está instalado
- `docker pull` de la nueva imagen
- Stop graceful del contenedor anterior (30 s)
- Start del nuevo contenedor
- Health check en `/healthz` (configurable)

---

## Recomendaciones de seguridad

- Usa un kubeconfig de ServiceAccount con permisos mínimos, no el de admin
- Crea un usuario `deploy` sin contraseña en los servidores; autoriza solo su clave pública
- En prod: habilita `StrictHostKeyChecking` con un `known_hosts` explícito
- Marca siempre KUBECONFIG y SSH_PRIVATE_KEY como secretos en el sistema de CI
