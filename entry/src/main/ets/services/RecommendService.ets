/**
 * 推荐服务
 */
import { Artifact, RecommendResult } from '../models/ArtifactModel';
import { ArtifactService } from './ArtifactService';

export class RecommendService {
  private static instance: RecommendService;
  private artifactService: ArtifactService = ArtifactService.getInstance();

  private constructor() {}

  public static getInstance(): RecommendService {
    if (!RecommendService.instance) {
      RecommendService.instance = new RecommendService();
    }
    return RecommendService.instance;
  }

  /**
   * 根据选择的博物馆和兴趣标签推荐藏品
   * @param museumIds 选择的博物馆ID数组
   * @param selectedTags 选择的兴趣标签数组
   * @param minPerMuseum 每个博物馆最少推荐数量
   * @param maxPerMuseum 每个博物馆最多推荐数量
   */
  public getRecommendations(
    museumIds: number[],
    selectedTags: string[],
    minPerMuseum: number = 3,
    maxPerMuseum: number = 8
  ): RecommendResult[] {
    const allArtifacts = this.artifactService.getAllArtifacts();
    const results: RecommendResult[] = [];

    // 按博物馆分组推荐
    for (let i = 0; i < museumIds.length; i++) {
      const museumId = museumIds[i];
      
      // 筛选该博物馆的藏品
      const museumArtifacts = allArtifacts.filter(
        artifact => artifact.museumId === museumId
      );

      // 计算匹配分数
      const museumResults: RecommendResult[] = [];
      for (let j = 0; j < museumArtifacts.length; j++) {
        const artifact = museumArtifacts[j];
        const matchTags = artifact.tags.filter(tag => selectedTags.includes(tag));
        
        if (matchTags.length > 0) {
          const result: RecommendResult = {
            artifact: artifact,
            matchScore: matchTags.length
          };
          museumResults.push(result);
        }
      }

      // 按匹配分数排序
      museumResults.sort((a, b) => b.matchScore - a.matchScore);

      // 如果匹配的藏品不足，补充热门藏品
      if (museumResults.length < minPerMuseum) {
        const recommendedIds = new Set<number>();
        for (let k = 0; k < museumResults.length; k++) {
          recommendedIds.add(museumResults[k].artifact.id);
        }

        const popularArtifacts = museumArtifacts
          .filter(item => item.isPopular === true && !recommendedIds.has(item.id))
          .slice(0, minPerMuseum - museumResults.length);

        for (let k = 0; k < popularArtifacts.length; k++) {
          const result: RecommendResult = {
            artifact: popularArtifacts[k],
            matchScore: 0
          };
          museumResults.push(result);
        }
      }

      // 限制每个博物馆的推荐数量
      const limitedResults = museumResults.slice(0, maxPerMuseum);
      results.push(...limitedResults);
    }

    return results;
  }
}

