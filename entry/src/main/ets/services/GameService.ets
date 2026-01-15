/**
 * 游戏服务类
 */
import { TreasureQuestion, QuizQuestion, GameResult, Badge, BadgeType } from '../models/GameModel';
import { ArtifactService } from './ArtifactService';
import { Artifact } from '../models/ArtifactModel';

export class GameService {
  private static instance: GameService;
  private treasureQuestions: TreasureQuestion[] = [];
  private quizQuestions: QuizQuestion[] = [];
  private artifactService: ArtifactService = ArtifactService.getInstance();

  private constructor() {
    this.loadQuestions();
  }

  public static getInstance(): GameService {
    if (!GameService.instance) {
      GameService.instance = new GameService();
    }
    return GameService.instance;
  }

  /**
   * 加载题目数据
   */
  private loadQuestions(): void {
    // 寻宝题目数据
    this.treasureQuestions = [
      {
        id: 1,
        clue: '我是明成祖下西洋的见证，瓷器中的蓝色珍品',
        options: [3, 7, 15, 22],
        answer: 15,
        explain: '这是青花瓷，明代郑和下西洋带回的钴料制成的青花瓷器，是中外文化交流的见证。'
      },
      {
        id: 2,
        clue: '这件文物是秦始皇统一度量衡的见证',
        options: [1, 5, 8, 12],
        answer: 8,
        explain: '这是秦代的度量衡器，秦始皇统一六国后，统一了全国的度量衡标准，这件文物就是历史的见证。'
      },
      {
        id: 3,
        clue: '我描绘了北宋都城的繁华景象，是古代风俗画的巅峰之作',
        options: [1, 4, 9, 11],
        answer: 1,
        explain: '这是《清明上河图》，北宋画家张择端所作，描绘了汴京的繁华景象，是中国古代风俗画的代表作。'
      },
      {
        id: 4,
        clue: '我是古埃及法老的黄金面具，重达11公斤',
        options: [5, 6, 10, 14],
        answer: 5,
        explain: '这是图坦卡蒙黄金面具，由纯金制成，镶嵌宝石，是古埃及艺术的杰作。'
      },
      {
        id: 5,
        clue: '我以神秘的微笑闻名于世，现藏于法国卢浮宫',
        options: [3, 7, 13, 15],
        answer: 3,
        explain: '这是《蒙娜丽莎》，达·芬奇的杰作，以其神秘的微笑而闻名，是世界上最著名的绘画作品之一。'
      },
      {
        id: 6,
        clue: '我是秦始皇陵的陪葬品，每个都表情不同',
        options: [4, 8, 12, 16],
        answer: 4,
        explain: '这是兵马俑，秦始皇陵的陪葬品，每个兵马俑的面部表情、发型、服饰都各不相同。'
      },
      {
        id: 7,
        clue: '我是解密古埃及文字的关键，刻有三种文字',
        options: [2, 6, 9, 11],
        answer: 2,
        explain: '这是罗塞塔石碑，刻有古埃及象形文字、草书和古希腊文，是解密古埃及文字的关键。'
      },
      {
        id: 8,
        clue: '我是文艺复兴时期的雕塑，高5.17米，描绘了大卫王',
        options: [7, 10, 13, 15],
        answer: 7,
        explain: '这是《大卫像》，米开朗基罗创作的大理石雕塑，描绘了《圣经》中大卫王准备战斗的场景。'
      },
      {
        id: 9,
        clue: '我描绘了夜晚的星空，是后印象派的代表作',
        options: [8, 12, 14, 16],
        answer: 8,
        explain: '这是《星夜》，梵高创作的油画，以其独特的笔触和色彩运用而闻名。'
      },
      {
        id: 10,
        clue: '我是旧石器时代的女性雕像，是已知最早的人类艺术表现之一',
        options: [6, 9, 11, 13],
        answer: 6,
        explain: '这是维伦多夫的维纳斯，制作于约2.5万年前，是已知最早的人类艺术表现之一。'
      },
      {
        id: 11,
        clue: '我是唐代的彩色釉陶器，以黄、绿、白三色为主',
        options: [10, 12, 14, 15],
        answer: 10,
        explain: '这是唐三彩，唐代彩色釉陶器的统称，造型生动，色彩绚丽，是唐代陶瓷工艺的代表作。'
      },
      {
        id: 12,
        clue: '我是中国古代青铜器，是中华文明的重要标志',
        options: [11, 13, 15, 16],
        answer: 11,
        explain: '这是青铜器，包括礼器、兵器、乐器等，制作工艺精湛，反映了古代中国的铸造技术。'
      }
    ];

    // 测验题目数据
    this.quizQuestions = [
      {
        id: 1,
        type: 'single',
        category: '历史',
        question: '故宫始建于哪个朝代？',
        options: ['明朝', '清朝', '元朝', '宋朝'],
        correctAnswer: 0,
        explanation: '故宫始建于明永乐十八年（1420年），是明朝第三位皇帝朱棣（明成祖）下令建造的。',
        difficulty: 'easy',
        theme: '博物馆'
      },
      {
        id: 2,
        type: 'single',
        category: '藏品',
        question: '《清明上河图》是哪个朝代的作品？',
        options: ['唐朝', '宋朝', '元朝', '明朝'],
        correctAnswer: 1,
        explanation: '《清明上河图》是北宋画家张择端所作，描绘了北宋都城汴京的城市面貌。',
        difficulty: 'medium',
        theme: '藏品'
      },
      {
        id: 3,
        type: 'multiple',
        category: '建筑',
        question: '故宫的三大殿包括哪些？（多选）',
        options: ['太和殿', '中和殿', '保和殿', '乾清宫'],
        correctAnswer: [0, 1, 2],
        explanation: '故宫的三大殿是指太和殿、中和殿、保和殿，这三座大殿位于故宫的中轴线上。',
        difficulty: 'easy',
        theme: '博物馆'
      },
      {
        id: 4,
        type: 'judge',
        category: '历史',
        question: '兵马俑是秦始皇陵的陪葬品。',
        options: ['正确', '错误'],
        correctAnswer: 0,
        explanation: '正确。兵马俑是秦始皇陵的陪葬坑中的陶俑，规模宏大，造型逼真。',
        difficulty: 'easy',
        theme: '历史'
      },
      {
        id: 5,
        type: 'single',
        category: '艺术',
        question: '《蒙娜丽莎》的作者是谁？',
        options: ['达·芬奇', '米开朗基罗', '拉斐尔', '梵高'],
        correctAnswer: 0,
        explanation: '《蒙娜丽莎》是意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画。',
        difficulty: 'medium',
        theme: '艺术'
      },
      {
        id: 6,
        type: 'single',
        category: '历史',
        question: '罗塞塔石碑刻有几种文字？',
        options: ['一种', '两种', '三种', '四种'],
        correctAnswer: 2,
        explanation: '罗塞塔石碑上刻有三种文字：古埃及象形文字、古埃及草书和古希腊文。',
        difficulty: 'medium',
        theme: '历史'
      },
      {
        id: 7,
        type: 'multiple',
        category: '艺术',
        question: '以下哪些是印象派画家？（多选）',
        options: ['莫奈', '梵高', '达·芬奇', '雷诺阿'],
        correctAnswer: [0, 1, 3],
        explanation: '莫奈、梵高、雷诺阿都是印象派或后印象派画家，达·芬奇是文艺复兴时期的画家。',
        difficulty: 'hard',
        theme: '艺术'
      },
      {
        id: 8,
        type: 'judge',
        category: '历史',
        question: '图坦卡蒙黄金面具重达11公斤。',
        options: ['正确', '错误'],
        correctAnswer: 0,
        explanation: '正确。图坦卡蒙黄金面具由纯金制成，重达11公斤，是古埃及艺术的代表作。',
        difficulty: 'medium',
        theme: '历史'
      },
      {
        id: 9,
        type: 'single',
        category: '艺术',
        question: '《星夜》是哪位画家的作品？',
        options: ['梵高', '莫奈', '毕加索', '达利'],
        correctAnswer: 0,
        explanation: '《星夜》是荷兰后印象派画家文森特·梵高创作的油画，创作于1889年。',
        difficulty: 'easy',
        theme: '艺术'
      },
      {
        id: 10,
        type: 'single',
        category: '历史',
        question: '维伦多夫的维纳斯制作于什么时代？',
        options: ['新石器时代', '旧石器时代', '青铜时代', '铁器时代'],
        correctAnswer: 1,
        explanation: '维伦多夫的维纳斯制作于旧石器时代，约2.5万年前，是已知最早的人类艺术表现之一。',
        difficulty: 'hard',
        theme: '历史'
      },
      {
        id: 11,
        type: 'multiple',
        category: '藏品',
        question: '以下哪些是中国的文物？（多选）',
        options: ['清明上河图', '兵马俑', '蒙娜丽莎', '富春山居图'],
        correctAnswer: [0, 1, 3],
        explanation: '《清明上河图》、兵马俑、《富春山居图》都是中国的文物，《蒙娜丽莎》是意大利的作品。',
        difficulty: 'easy',
        theme: '藏品'
      },
      {
        id: 12,
        type: 'judge',
        category: '艺术',
        question: '《大卫像》是米开朗基罗创作的雕塑作品。',
        options: ['正确', '错误'],
        correctAnswer: 0,
        explanation: '正确。《大卫像》是意大利文艺复兴时期雕塑家米开朗基罗创作的大理石雕塑。',
        difficulty: 'medium',
        theme: '艺术'
      }
    ];
  }

  /**
   * 获取寻宝题目
   */
  public getTreasureQuestions(count: number = 10): TreasureQuestion[] {
    const shuffled = [...this.treasureQuestions].sort(() => Math.random() - 0.5);
    return shuffled.slice(0, Math.min(count, this.treasureQuestions.length));
  }

  /**
   * 获取测验题目
   */
  public getQuizQuestions(theme?: string, difficulty?: string, count: number = 10): QuizQuestion[] {
    let filtered = [...this.quizQuestions];
    
    if (theme && theme !== 'all') {
      filtered = filtered.filter(q => q.theme === theme);
    }
    
    if (difficulty && difficulty !== 'all') {
      filtered = filtered.filter(q => q.difficulty === difficulty);
    }
    
    const shuffled = filtered.sort(() => Math.random() - 0.5);
    return shuffled.slice(0, Math.min(count, filtered.length));
  }

  /**
   * 根据藏品ID获取藏品信息
   */
  public getArtifactById(id: number): Artifact | undefined {
    return this.artifactService.getArtifactById(id);
  }

  /**
   * 计算游戏得分
   */
  public calculateScore(correctCount: number, totalQuestions: number, comboCount: number): number {
    const baseScore = (correctCount / totalQuestions) * 100;
    const comboBonus = comboCount * 5; // 连击加分
    return Math.round(baseScore + comboBonus);
  }

  /**
   * 计算获得金币
   */
  public calculateCoins(correctCount: number, comboCount: number): number {
    const baseCoins = correctCount * 10;
    const comboBonus = comboCount * 5;
    return baseCoins + comboBonus;
  }

  /**
   * 检查是否解锁徽章
   */
  public checkBadges(score: number, gameType: 'treasure' | 'quiz'): BadgeType[] {
    const unlocked: BadgeType[] = [];
    
    if (gameType === 'treasure') {
      if (score >= 80) {
        unlocked.push('treasure_master');
      } else if (score >= 60) {
        unlocked.push('treasure_expert');
      } else if (score >= 40) {
        unlocked.push('treasure_novice');
      }
    } else {
      if (score >= 80) {
        unlocked.push('quiz_master');
      } else if (score >= 60) {
        unlocked.push('quiz_expert');
      } else if (score >= 40) {
        unlocked.push('quiz_novice');
      }
    }
    
    return unlocked;
  }
}

