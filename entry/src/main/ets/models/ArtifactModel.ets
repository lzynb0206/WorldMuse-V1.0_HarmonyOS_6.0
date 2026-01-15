/**
 * 藏品数据模型
 */
export interface Artifact {
  id: number;
  title: string;
  museumId: number; // 所属博物馆ID
  museumName: string; // 所属博物馆名称
  desc: string;
  image: string;
  tags: string[];
  duration: number; // 预计游览时长（分钟）
  isPopular?: boolean; // 是否为热门藏品
}

/**
 * 兴趣标签模型
 */
export interface InterestTag {
  id: string;
  name: string;
  icon?: string;
}

/**
 * 推荐结果模型
 */
export interface RecommendResult {
  artifact: Artifact;
  matchScore: number; // 匹配分数（交集数量）
}

/**
 * 行程项模型
 */
export interface ItineraryItem {
  artifactId: number;
  artifact: Artifact;
  order: number; // 排序序号
}

