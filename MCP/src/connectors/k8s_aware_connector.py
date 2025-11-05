import os 
from kubernetes import client, config
from typing import Optional

class KubernetesAwareConnector:
    def __init__(self):
        self.in_cluster = self._detect_enviroment()
        self.k8s_client = self._init_k8s_client()


    def _detect_enviroment(self) -> bool:
        """Detecta si se está ejecutando dentro de un cluster Kubernetes.

        Criterios:
        - Presencia de la variable de entorno KUBERNETES_SERVICE_HOST
        - Presencia del token de serviceaccount en el path estándar
        """
        if os.environ.get("KUBERNETES_SERVICE_HOST"):
            return True
        token_path = "/var/run/secrets/kubernetes.io/serviceaccount/token"
        return os.path.exists(token_path)

    def _init_k8s_client(self):
        try:
            if self.in_cluster:
                config.load_incluster_config()
            else:
                config.load_kube_config()
            return client.CoreV1Api()
        except Exception:
            # Propagar la excepción para que el llamador pueda diagnosticar
            raise

    async def get_service_endpoint(self, service_name: str, namespace: str = "default") -> str:
        """Obtiene un endpoint accesible dentro del cluster para un Service.

        Devuelve por defecto el DNS interno del servicio en el formato
        <service>.<namespace>.svc.cluster.local:<port>.

        Nota: el método sigue siendo async para compatibilidad con llamadores
        pero internamente usa la API síncrona del cliente Kubernetes.
        """
        try:
            service = self.k8s_client.read_namespaced_service(service_name, namespace)
            ports = getattr(service.spec, "ports", None) or []
            if not ports:
                raise RuntimeError(f"Service {service_name} in namespace {namespace} has no ports")
            port = ports[0].port

            # Preferir DNS sobre ClusterIP porque es más estable dentro del cluster
            dns = f"{service_name}.{namespace}.svc.cluster.local:{port}"
            return dns
        except Exception as e:
            raise RuntimeError(f"Error getting service endpoint for {service_name}: {e}") from e
            