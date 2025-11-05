import os
import base64
from kubernetes import client, config
from typing import Dict, Any


class K8sConfigManager:
    def __init__(self):
        # Detectar si estamos dentro de un Pod en el cluster
        if os.environ.get("KUBERNETES_SERVICE_HOST"):
            self.in_cluster = True
        else:
            token_path = "/var/run/secrets/kubernetes.io/serviceaccount/token"
            self.in_cluster = os.path.exists(token_path)

        if self.in_cluster:
            config.load_incluster_config()
        else:
            config.load_kube_config()

        self.v1 = client.CoreV1Api()

    def get_secret(self, secret_name: str, namespace: str = "default") -> Dict[str,str]:
        # Obtener secretos de K8s
        
        try:
            secret = self.v1.read_namespaced_secret(secret_name, namespace)
            return {key: base64.b64decode(value).decode('utf-8') 
                    for key, value in secret.data.items()}
        except Exception as e:
            raise Exception(f"Error reading secret {secret_name}: {str(e)}")
        
    def get_config_map(self, config_map_name: str, namespace: str = "default") -> Dict[str, str]:
        # Obtener config map de k8s

        try:
            config_map = self.v1.read_namespaced_config_map(config_map_name, namespace)
            return config_map.data or {}
        except Exception as e:
            raise Exception(f"Error reading config map {config_map_name}: {str(e)}")