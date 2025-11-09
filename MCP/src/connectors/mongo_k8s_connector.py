from .mongo_connector import MongoDBConnector
from .k8s_aware_connector import KubernetesAwareConnector


class MongoDBK8sConnector(MongoDBConnector, KubernetesAwareConnector):
    def __init__(self, service_name: str, database: str, username: str = None, password: str = None,
                 namespace: str = "default", use_k8s_service: bool = True):
        """Kubernetes-aware MongoDB connector.

        If username/password are provided, they will be included in the connection string.
        If omitted, the connector will try to connect without authentication.
        """
        KubernetesAwareConnector.__init__(self)

        if use_k8s_service:
            endpoint = self.get_service_endpoint(service_name, namespace)
            host_port = endpoint
        else:
            host_port = service_name

        # Build connection string; include credentials only if provided.
        if username and password:
            connection_string = f"mongodb://{username}:{password}@{host_port}/{database}?authSource=admin"
        else:
            connection_string = f"mongodb://{host_port}/{database}"

        MongoDBConnector.__init__(self, connection_string, database)