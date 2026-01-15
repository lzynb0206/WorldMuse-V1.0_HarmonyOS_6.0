/**
 * 游戏数据模型
 */

/**
 * 寻宝题目
 */
export interface TreasureQuestion {
  id: number;
  clue: string;
  options: number[]; // 藏品ID数组
  answer: number; // 正确答案的藏品ID
  explain: string; // 解析说明
}

/**
 * 测验题目
 */
export interface QuizQuestion {
  id: number;
  type: 'single' | 'multiple' | 'judge';
  category: string;
  question: string;
  options: string[];
  correctAnswer: number | number[];
  explanation: string;
  difficulty: 'easy' | 'medium' | 'hard';
  theme?: string; // 主题：博物馆、藏品、历史等
}

/**
 * 游戏结果
 */
export interface GameResult {
  score: number;
  totalQuestions: number;
  correctCount: number;
  comboCount: number; // 连击数
  coins: number; // 获得金币
  timestamp: number;
}

/**
 * 徽章类型
 */
export type BadgeType = 'treasure_novice' | 'treasure_expert' | 'treasure_master' | 'quiz_novice' | 'quiz_expert' | 'quiz_master';

/**
 * 徽章信息
 */
export interface Badge {
  id: BadgeType;
  name: string;
  description: string;
  icon: string;
  unlocked: boolean;
  unlockCondition: string;
}

