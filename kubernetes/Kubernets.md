### Estructura Visual del Entorno de Kubernetes

## `kubernetes/databases/`
Contiene las **subcarpetas de cada base de datos**.

Cada subcarpeta tiene los archivos YAML que definen:
1. **Cómo crear la base de datos** (Deployment)
2. **Dónde guardar los datos** (PVC - Persistent Volume Claim)
3. **Cómo acceder a ella** (Service)

**Estructura:**
```
databases/
├── postgresql/         ← Archivos para crear PostgreSQL
├── mongodb/           ← Archivos para crear MongoDB
├── sqlserver-ads/     ← Archivos para crear SQL Server Ads
├── sqlserver-crm/     ← Archivos para crear SQL Server CRM
└── redis/             ← Archivos para crear Redis
```

Cada carpeta es independiente, así Dylan puede trabajar en `mongodb/` mientras tú trabajas en `postgresql/` sin conflictos.

---

## Resumen visual:
```
kubernetes/               → Carpeta organizativa del proyecto
│
├── namespaces/          → "Carpetas virtuales" para separar recursos
│   └── all-namespaces.yaml   (crea: promptsales, promptads, etc.)
│
├── secrets/             → Contraseñas y datos sensibles
│   └── all-secrets.yaml      (usuarios y passwords de cada BD)
│
└── databases/           → Configuración de cada base de datos
    ├── postgresql/      → 3 archivos: PVC, Deployment, Service
    ├── mongodb/         → 3 archivos: PVC, Deployment, Service
    ├── sqlserver-ads/   → 3 archivos: PVC, Deployment, Service
    ├── sqlserver-crm/   → 3 archivos: PVC, Deployment, Service
    └── redis/           → 3 archivos: ConfigMap, Deployment, Service