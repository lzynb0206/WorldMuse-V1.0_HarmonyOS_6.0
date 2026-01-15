/**
 * 兴趣标签常量定义
 */
export interface InterestTag {
  id: string;
  name: string;
  icon?: string;
}

export const INTEREST_TAGS: InterestTag[] = [
  { id: 'ancient_china', name: '古代中国', icon: '🇨🇳' },
  { id: 'western_painting', name: '西方绘画', icon: '🖼️' },
  { id: 'sculpture', name: '雕塑', icon: '🗿' },
  { id: 'ceramic', name: '陶瓷', icon: '🏺' },
  { id: 'family_friendly', name: '亲子友好', icon: '👨‍👩‍👧‍👦' },
  { id: 'tech_artifact', name: '科技文物', icon: '🔬' },
  { id: 'revolution_history', name: '革命历史', icon: '🚩' },
  { id: 'jade', name: '玉器', icon: '💎' },
  { id: 'calligraphy', name: '书法', icon: '✍️' },
  { id: 'bronze', name: '青铜器', icon: '⚱️' },
  { id: 'renaissance', name: '文艺复兴', icon: '🎨' },
  { id: 'impressionism', name: '印象派', icon: '🌅' }
];

