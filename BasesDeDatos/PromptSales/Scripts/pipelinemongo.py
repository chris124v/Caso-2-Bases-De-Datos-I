"""
// ================================================================
// AGGREGATION PIPELINE MAESTRA ETL - PromptContent
// Contiene TODOS los datos necesarios para PromptSales
// ================================================================

db.PCmedia.aggregate([
  // ============================================
  // FILTRO DELTA
  // ============================================
  {
    $match: {
      updatedAt: { $gt: ISODate("@lastETLDate") },
      campaignId: { $exists: true, $ne: null, $ne: "" }
    }
  },
  
  // ============================================
  // LOOKUP: Relacionar con requests
  // ============================================
  {
    $lookup: {
      from: "PC_Content_Requests",
      localField: "requestId",
      foreignField: "requestId",
      as: "request"
    }
  },
  
  // ============================================
  // UNWIND REQUESTS (si existe)
  // ============================================
  {
    $unwind: {
      path: "$request",
      preserveNullAndEmptyArrays: true
    }
  },
  
  // ============================================
  // LOOKUP: Relacionar con AI logs
  // ============================================
  {
    $lookup: {
      from: "PCAi_Model_Logs",
      let: { reqId: "$requestId" },
      pipeline: [
        {
          $match: {
            $expr: {
              $eq: ["$logId", "$$reqId"]
            }
          }
        }
      ],
      as: "aiLogs"
    }
  },
  
  // ============================================
  // PROYECCIÓN FINAL
  // ============================================
  {
    $project: {
      _id: 0,
      
      // IDs principales
      mediaId: "$mediaId",
      campaignId: "$campaignId",
      clientId: "$clientId",
      requestId: "$requestId",
      adId: "$adId",
      strategyId: "$strategyId",
      userId: "$userId",
      
      // Contenido
      mediaUrl: "$mediaUrl",
      fileName: "$fileName",
      format: "$format",
      size: "$size",
      description: "$description",
      hashtags: "$hashtags",
      
      // Clasificación
      category: "$category",
      platform: "$platform",
      
      // Uso
      usageCount: { $ifNull: ["$usageCount", 0] },
      deliveryStatus: "$deliveryStatus",
      
      // Request info
      requestDescription: "$request.requestDescription",
      targetAudience: "$request.targetAudience",
      campaignDescription: "$request.campaignDescription",
      requestStatus: "$request.status",
      requestProcessingTime: "$request.processingTime",
      requestCreatedAt: "$request.createdAt",
      requestCompletedAt: "$request.completedAt",
      
      // AI info
      aiModelUsed: {
        $cond: {
          if: { $gt: [{ $size: "$aiLogs" }, 0] },
          then: { $arrayElemAt: ["$aiLogs.modelId", 0] },
          else: null
        }
      },
      aiProcessingTime: {
        $cond: {
          if: { $gt: [{ $size: "$aiLogs" }, 0] },
          then: { $arrayElemAt: ["$aiLogs.processingTime", 0] },
          else: null
        }
      },
      aiTokenUsage: {
        $cond: {
          if: { $gt: [{ $size: "$aiLogs" }, 0] },
          then: { $arrayElemAt: ["$aiLogs.tokenUsage", 0] },
          else: null
        }
      },
      
      // Vector embedding (para búsquedas)
      vectorEmbedding: "$vectorEmbedding",
      
      // Derechos
      rights: "$rights",
      
      // Timestamps
      createdAt: "$createdAt",
      updatedAt: "$updatedAt"
    }
  },
  
  // ============================================
  // ORDENAR
  // ============================================
  {
    $sort: {
      campaignId: 1,
      updatedAt: -1
    }
  }
]);

"""


