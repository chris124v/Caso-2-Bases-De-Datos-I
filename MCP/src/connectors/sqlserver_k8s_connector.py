from .sqlserver_connector import SQLServerConnector
from .k8s_aware_connector import KubernetesAwareConnector


class SQLServerK8sConnector(SQLServerConnector, KubernetesAwareConnector):
    def __init__(self, service_name: str, database: str, username: str, password: str, namespace: str = "default" , use_k8s_service: bool = True):
        KubernetesAwareConnector.__init__(self)

        if use_k8s_service:
            server = self.get_service_endpoint(service_name, namespace)
        else:
            # support passing host:port and convert to the format accepted by ODBC (host,port)
            if ":" in service_name:
                host, port = service_name.rsplit(":", 1)
                server = f"{host},{port}"
            else:
                server = service_name

        SQLServerConnector.__init__(self, server, database, username, password)

