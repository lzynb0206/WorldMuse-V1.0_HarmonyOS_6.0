/**
 * 博物馆数据模型
 */
export interface Museum {
  id: number;
  name: string;
  location: string;
  image: string;
  description?: string;
}

/**
 * 行程项模型（按博物馆分组）
 */
export interface ItineraryMuseum {
  museumId: number;
  museumName: string;
  artifactIds: number[]; // 藏品ID数组
}

/**
 * 完整行程数据
 */
export interface ItineraryData {
  museums: ItineraryMuseum[];
  createdAt: number;
  updatedAt: number;
}

