from .mongo_connector import MongoDBConnector
from .k8s_aware_connector import KubernetesAwareConnector

class MongoDBK8sConnector(MongoDBConnector, KubernetesAwareConnector):
    def __init__(self, service_name: str, database: str, namespace: str = "default", use_k8s_service: bool = True):
        KubernetesAwareConnector.__init__(self)
        

        if use_k8s_service:
            endpoint = self.get_service_endpoint(service_name, namespace)
            connection_string = f"mongodb://{endpoint}"
        else:
            connection_string = service_name

        MongoDBConnector.__init__(self, connection_string, database)