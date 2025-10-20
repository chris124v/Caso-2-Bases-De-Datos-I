from pymongo import MongoClient

cliente = MongoClient('mongodb://mongouser:mongo123@localhost:30017/promptcontent?authSource=admin')

db = cliente['promptcontent']

coleccion = db['usuarios']


usuario = {'nombre': 'Juan', 'email': 'juan@ejemplo.com', 'edad': 25}

resultado = coleccion.insert_one(usuario)