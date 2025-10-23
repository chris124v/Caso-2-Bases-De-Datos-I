
Listado de colecciones:

PCUsers:
Almacena información de todos los usuarios que acceden al sistema PromptContent

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'userId',
      'email',
      'name',
      'role',
      'createdAt'
    ],
    properties: {
      userId: {
        bsonType: 'string'
      },
      email: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      role: {
        bsonType: 'string',
        'enum': [
          'admin',
          'marketer',
          'agent',
          'client'
        ]
      },
      platform: {
        bsonType: 'string',
        'enum': [
          'promptcontent',
          'promptads',
          'promptcrm',
          'web'
        ]
      },
      createdAt: {
        bsonType: 'date'
      },
      lastLogin: {
        bsonType: 'date'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'active',
          'inactive',
          'suspended'
        ]
      }
    }
  }
}

PCExternal_Services:
Registra todos los servicios externos (APIs de terceros) con los que PromptContent se integra, como OpenAI, Canva, Adobe, etc.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'serviceId',
      'name',
      'baseUrl',
      'authMethod',
      'createdAt'
    ],
    properties: {
      serviceId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      baseUrl: {
        bsonType: 'string'
      },
      authMethod: {
        bsonType: 'string',
        'enum': [
          'OAuth2',
          'API_KEY',
          'Bearer',
          'Basic',
          'Custom'
        ]
      },
      encryptedCredentials: {
        bsonType: 'string'
      },
      secretKey: {
        bsonType: 'string'
      },
      apiKey: {
        bsonType: 'string'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'active',
          'inactive',
          'testing'
        ]
      },
      lastTestedAt: {
        bsonType: 'date'
      },
      createdAt: {
        bsonType: 'date'
      },
      updatedAt: {
        bsonType: 'date'
      }
    }
  }
}

PCApi_Call_Logs_
Bitácora completa de TODAS las llamadas realizadas a servicios externos.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'logId',
      'serviceId',
      'timestamp'
    ],
    properties: {
      logId: {
        bsonType: 'string'
      },
      serviceId: {
        bsonType: 'string'
      },
      endpoint: {
        bsonType: 'string'
      },
      method: {
        bsonType: 'string'
      },
      request: {
        bsonType: 'object'
      },
      response: {
        bsonType: 'object'
      },
      statusCode: {
        bsonType: 'int'
      },
      responseTime: {
        bsonType: 'int'
      },
      result: {
        bsonType: 'string'
      },
      userId: {
        bsonType: 'string'
      },
      platform: {
        bsonType: 'string'
      },
      timestamp: {
        bsonType: 'date'
      },
      processedAt: {
        bsonType: 'date'
      },
      errorDetails: {
        bsonType: 'string'
      }
    }
  }
}

PCAi_Models_Catalog:
Catálogo de los modelos de IA PROPIOS de PromptContent (no externos). Define qué modelos IA están disponibles, sus versiones y configuraciones.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'modelId',
      'name',
      'version',
      'createdAt'
    ],
    properties: {
      modelId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      description: {
        bsonType: 'string'
      },
      createdAt: {
        bsonType: 'date'
      },
      updatedAt: {
        bsonType: 'date'
      }
    }
  }
}

PCAi_Model_Logs:
Bitácora de TODAS las veces que se usa un modelo de IA propio. Similar a api_call_logs pero para modelos internos.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'logId',
      'modelId',
      'timestamp'
    ],
    properties: {
      logId: {
        bsonType: 'string'
      },
      modelId: {
        bsonType: 'string'
      },
      versionId: {
        bsonType: 'string'
      },
      input: {
        bsonType: 'string'
      },
      output: {
        bsonType: 'object'
      },
      parameters: {
        bsonType: 'object'
      },
      userId: {
        bsonType: 'string'
      },
      timestamp: {
        bsonType: 'date'
      },
      processingTime: {
        bsonType: 'int'
      },
      status: {
        bsonType: 'string'
      },
      mcpServerUsed: {
        bsonType: 'bool'
      },
      mcpServerName: {
        bsonType: 'string'
      }
    }
  }
}

PC_Content_Types:
Define los tipos de contenido que PromptContent puede crear (texto, imagen, video, audio, etc.) y sus especificaciones técnicas.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'contentTypeId',
      'name',
      'createdAt'
    ],
    properties: {
      contentTypeId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string',
        'enum': [
          'text',
          'image',
          'video',
          'audio',
          'carousel',
          'story'
        ]
      },
      description: {
        bsonType: 'string'
      },
      supportedPlatforms: {
        bsonType: 'array'
      },
      createdAt: {
        bsonType: 'date'
      }
    }
  }
}

PCimages:
Almacena todas las imágenes creadas con sus descripciones amplias, hashtags y vectores para búsqueda avanzada.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'imageId',
      'imageUrl',
      'description',
      'hashtags',
      'createdAt'
    ],
    properties: {
      imageId: {
        bsonType: 'string'
      },
      imageUrl: {
        bsonType: 'string'
      },
      fileName: {
        bsonType: 'string'
      },
      format: {
        bsonType: 'string',
        'enum': [
          'jpg',
          'png',
          'gif',
          'webp'
        ]
      },
      size: {
        bsonType: 'int'
      },
      description: {
        bsonType: 'string'
      },
      hashtags: {
        bsonType: 'array'
      },
      category: {
        bsonType: 'string',
        'enum': [
          'social',
          'ads',
          'web',
          'email',
          'other'
        ]
      },
      platform: {
        bsonType: 'array'
      },
      vectorEmbedding: {
        bsonType: 'array'
      },
      createdAt: {
        bsonType: 'date'
      },
      updatedAt: {
        bsonType: 'date'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'draft',
          'approved',
          'archived'
        ]
      },
      usageCount: {
        bsonType: 'int'
      },
      rights: {
        bsonType: 'string'
      }
    }
  }
}

PC_Content_Requests:
Registra solicitudes de clientes para generar contenido

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'requestId',
      'clientId',
      'contentType',
      'createdAt'
    ],
    properties: {
      requestId: {
        bsonType: 'string'
      },
      clientId: {
        bsonType: 'string'
      },
      contentType: {
        bsonType: 'string'
      },
      description: {
        bsonType: 'string'
      },
      targetAudience: {
        bsonType: 'string'
      },
      campaignDescription: {
        bsonType: 'string'
      },
      generatedContent: {
        bsonType: 'array'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'pending',
          'processing',
          'completed',
          'failed'
        ]
      },
      createdAt: {
        bsonType: 'date'
      },
      completedAt: {
        bsonType: 'date'
      },
      processingTime: {
        bsonType: 'int'
      }
    }
  }
}

PC_Clients:
Almacena información de los clientes de PromptContent (las empresas/personas que contratan el servicio).

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'clientId',
      'email',
      'name',
      'createdAt'
    ],
    properties: {
      clientId: {
        bsonType: 'string'
      },
      email: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      company: {
        bsonType: 'string'
      },
      phone: {
        bsonType: 'string'
      },
      createdAt: {
        bsonType: 'date'
      },
      updatedAt: {
        bsonType: 'date'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'active',
          'inactive',
          'suspended'
        ]
      }
    }
  }
}

PCSubscription_Plans:
Define los planes de suscripción disponibles (Básico, Premium, Enterprise) con sus características y precios.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'planId',
      'name',
      'price',
      'createdAt'
    ],
    properties: {
      planId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      description: {
        bsonType: 'string'
      },
      price: {
        bsonType: 'double'
      },
      currency: {
        bsonType: 'string'
      },
      billingCycle: {
        bsonType: 'string',
        'enum': [
          'monthly',
          'quarterly',
          'annual'
        ]
      },
      status: {
        bsonType: 'string',
        'enum': [
          'active',
          'discontinued'
        ]
      },
      createdAt: {
        bsonType: 'date'
      },
      updatedAt: {
        bsonType: 'date'
      }
    }
  }
}

PCFeatures:
Catálogo maestro de todas las características/funcionalidades que PromptContent ofrece. Los planes hacen referencia a estas features.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'featureId',
      'name',
      'createdAt'
    ],
    properties: {
      featureId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      description: {
        bsonType: 'string'
      },
      metricsTracked: {
        bsonType: 'array'
      },
      createdAt: {
        bsonType: 'date'
      }
    }
  }
}

PCPayment_Methods:
Define los métodos de pago aceptados por PromptContent (tarjetas de crédito, PayPal, transferencias).

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'methodId',
      'name',
      'type',
      'createdAt'
    ],
    properties: {
      methodId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string',
        'enum': [
          'credit_card',
          'debit_card',
          'paypal',
          'stripe',
          'wire_transfer'
        ]
      },
      type: {
        bsonType: 'string'
      },
      description: {
        bsonType: 'string'
      },
      isActive: {
        bsonType: 'bool'
      },
      createdAt: {
        bsonType: 'date'
      }
    }
  }
}

PCPayment_Schedules:
Programa/calendario de pagos futuros para cada suscripción. Define CUÁNDO se debe cobrar a cada cliente.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'scheduleId',
      'subscriptionId',
      'amount',
      'dueDate'
    ],
    properties: {
      scheduleId: {
        bsonType: 'string'
      },
      subscriptionId: {
        bsonType: 'string'
      },
      amount: {
        bsonType: 'double'
      },
      currency: {
        bsonType: 'string'
      },
      dueDate: {
        bsonType: 'date'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'pending',
          'paid',
          'overdue',
          'cancelled'
        ]
      },
      paymentMethodId: {
        bsonType: 'string'
      },
      createdAt: {
        bsonType: 'date'
      }
    }
  }
}

PCPayment_Transactions:
Registro histórico de TODAS las transacciones de pago ejecutadas.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'transactionId',
      'subscriptionId',
      'amount',
      'timestamp'
    ],
    properties: {
      transactionId: {
        bsonType: 'string'
      },
      subscriptionId: {
        bsonType: 'string'
      },
      clientId: {
        bsonType: 'string'
      },
      amount: {
        bsonType: 'double'
      },
      currency: {
        bsonType: 'string'
      },
      paymentMethodId: {
        bsonType: 'string'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'success',
          'failed',
          'pending',
          'refunded'
        ]
      },
      externalTransactionId: {
        bsonType: 'string'
      },
      details: {
        bsonType: 'object'
      },
      timestamp: {
        bsonType: 'date'
      },
      processedAt: {
        bsonType: 'date'
      },
      errorMessage: {
        bsonType: 'string'
      }
    }
  }
}

PCCampaigns:
Almacena las campañas de contenido creadas. Agrupa múltiples imágenes/textos bajo una misma campaña con versiones y aprobaciones.

{
  $jsonSchema: {
    bsonType: 'object',
    required: [
      'campaignId',
      'name',
      'description',
      'createdAt'
    ],
    properties: {
      campaignId: {
        bsonType: 'string'
      },
      name: {
        bsonType: 'string'
      },
      description: {
        bsonType: 'string'
      },
      targetAudience: {
        bsonType: 'string'
      },
      campaignMessage: {
        bsonType: 'string'
      },
      contentVersions: {
        bsonType: 'array'
      },
      usedImages: {
        bsonType: 'array'
      },
      status: {
        bsonType: 'string',
        'enum': [
          'draft',
          'active',
          'completed',
          'archived'
        ]
      },
      startDate: {
        bsonType: 'date'
      },
      endDate: {
        bsonType: 'date'
      },
      createdAt: {
        bsonType: 'date'
      },
      updatedAt: {
        bsonType: 'date'
      }
    }
  }
}
