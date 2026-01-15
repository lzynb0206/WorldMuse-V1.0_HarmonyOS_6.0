import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

// 题目类型
type QuestionType = 'single' | 'multiple' | 'judge';

// 题目接口
interface Question {
  id: number;
  type: QuestionType;
  category: string; // 分类：博物馆、藏品、历史等
  question: string;
  options: string[]; // 选项（判断题只有两个选项：正确、错误）
  correctAnswer: number | number[]; // 正确答案索引（单选为单个数字，多选为数组，判断为0或1）
  explanation: string; // 解析
  difficulty: 'easy' | 'medium' | 'hard'; // 难度
}

// 题库模块接口
interface QuizModule {
  id: string; // 模块ID
  name: string; // 模块名称
  icon?: string; // 图标（可选）
  description: string; // 模块描述
  questions: Question[]; // 该模块的题目列表
}

@Entry
@Component
struct Quiz {
  @State selectedCategory: string = 'all'; // 当前选择的分类
  @State currentQuestionIndex: number = 0; // 当前题目索引
  @State selectedAnswers: number[] = []; // 用户选择的答案（单选为单个元素数组，多选为多个元素数组，判断为单个元素数组）
  @State showResult: boolean = false; // 是否显示结果
  @State isAnswered: boolean = false; // 是否已回答
  @State score: number = 0; // 得分
  @State totalQuestions: number = 0; // 总题数
  @State quizStarted: boolean = false; // 是否开始答题
  @State preferencesStore: preferences.Preferences | null = null;
  @State selectedModuleId: string = ''; // 当前选中的模块ID
  @State showSidebar: boolean = true; // 是否显示侧边栏
  @State sidebarExpanded: boolean = true; // 侧边栏是否展开

  // 题库模块列表
  @State quizModules: QuizModule[] = [
    {
      id: 'forbidden_city',
      name: '故宫博物院',
      description: '关于故宫的历史、建筑、藏品等知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '故宫始建于哪个朝代？',
          options: ['明朝', '清朝', '元朝', '宋朝'],
          correctAnswer: 0,
          explanation: '故宫始建于明永乐十八年（1420年），是明朝第三位皇帝朱棣（明成祖）下令建造的。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '建筑',
          question: '故宫有多少间房屋？',
          options: ['9999间', '8704间', '8000间', '10000间'],
          correctAnswer: 1,
          explanation: '故宫共有8704间房屋，这个数字来源于古代建筑的计算方式，包括各种大小不同的房间。',
          difficulty: 'medium'
        },
        {
          id: 3,
          type: 'multiple',
          category: '建筑',
          question: '故宫的三大殿包括哪些？（多选）',
          options: ['太和殿', '中和殿', '保和殿', '乾清宫'],
          correctAnswer: [0, 1, 2],
          explanation: '故宫的三大殿是指太和殿、中和殿、保和殿，这三座大殿位于故宫的中轴线上，是故宫最重要的建筑。',
          difficulty: 'easy'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '故宫是明清两朝的皇家宫殿。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。故宫是明清两朝的皇家宫殿，明朝从1420年使用到1644年，清朝从1644年使用到1912年。',
          difficulty: 'easy'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《清明上河图》是哪个朝代的作品？',
          options: ['唐朝', '宋朝', '元朝', '明朝'],
          correctAnswer: 1,
          explanation: '《清明上河图》是北宋画家张择端所作，描绘了北宋都城汴京的城市面貌，现藏于故宫博物院。',
          difficulty: 'medium'
        },
        {
          id: 6,
          type: 'multiple',
          category: '历史',
          question: '以下哪些皇帝曾在故宫居住过？（多选）',
          options: ['明成祖朱棣', '清康熙帝', '清乾隆帝', '明太祖朱元璋'],
          correctAnswer: [0, 1, 2],
          explanation: '明成祖朱棣建造了故宫并在此居住，清康熙帝和清乾隆帝都在故宫居住过。明太祖朱元璋是明朝开国皇帝，但他在南京建都，未在故宫居住。',
          difficulty: 'hard'
        },
        {
          id: 7,
          type: 'judge',
          category: '建筑',
          question: '故宫是世界上现存规模最大、保存最为完整的木质结构古建筑群。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。故宫是世界上现存规模最大、保存最为完整的木质结构古建筑群，1987年被列为世界文化遗产。',
          difficulty: 'easy'
        },
        {
          id: 8,
          type: 'single',
          category: '建筑',
          question: '故宫的午门有几个门洞？',
          options: ['3个', '5个', '7个', '9个'],
          correctAnswer: 1,
          explanation: '午门有5个门洞，中间的门洞是皇帝专用的，两侧的门洞是文武百官和宗室王公使用的。',
          difficulty: 'medium'
        },
        {
          id: 9,
          type: 'multiple',
          category: '藏品',
          question: '故宫博物院收藏的珍贵文物包括哪些？（多选）',
          options: ['《清明上河图》', '《千里江山图》', '《富春山居图》', '《五牛图》'],
          correctAnswer: [0, 1, 3],
          explanation: '故宫博物院收藏有《清明上河图》、《千里江山图》、《五牛图》等珍贵文物。《富春山居图》现藏于台北故宫博物院和浙江省博物馆。',
          difficulty: 'hard'
        },
        {
          id: 10,
          type: 'judge',
          category: '历史',
          question: '故宫在1925年正式对外开放，成为博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。1925年10月10日，故宫正式对外开放，成立了故宫博物院，这是中国历史上第一个公共博物馆。',
          difficulty: 'medium'
        },
        {
          id: 11,
          type: 'single',
          category: '建筑',
          question: '故宫的占地面积约为多少？',
          options: ['50万平方米', '72万平方米', '100万平方米', '120万平方米'],
          correctAnswer: 1,
          explanation: '故宫占地面积约72万平方米，建筑面积约15万平方米，有大小宫殿七十多座，房屋九千余间。',
          difficulty: 'medium'
        },
        {
          id: 12,
          type: 'single',
          category: '历史',
          question: '故宫的建造历时多少年？',
          options: ['10年', '14年', '18年', '20年'],
          correctAnswer: 1,
          explanation: '故宫的建造从1406年开始，到1420年完成，历时14年，动用了数十万工匠和百万民工。',
          difficulty: 'hard'
        },
        {
          id: 13,
          type: 'multiple',
          category: '建筑',
          question: '故宫的主要建筑特点包括哪些？（多选）',
          options: ['中轴线对称布局', '黄色琉璃瓦屋顶', '红色宫墙', '木结构建筑'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '故宫的主要建筑特点包括：中轴线对称布局、黄色琉璃瓦屋顶（象征皇权）、红色宫墙（象征吉祥）、木结构建筑（中国传统建筑特色）。',
          difficulty: 'easy'
        },
        {
          id: 14,
          type: 'judge',
          category: '藏品',
          question: '故宫博物院收藏的文物总数超过180万件。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。故宫博物院收藏的文物总数超过180万件，包括绘画、书法、陶瓷、玉器、青铜器等各类文物。',
          difficulty: 'medium'
        },
        {
          id: 15,
          type: 'single',
          category: '历史',
          question: '故宫在1987年被列入什么名录？',
          options: ['世界文化遗产', '世界自然遗产', '国家文物保护单位', '国家5A级景区'],
          correctAnswer: 0,
          explanation: '故宫在1987年被联合国教科文组织列入《世界文化遗产名录》，是中国第一批世界文化遗产之一。',
          difficulty: 'easy'
        },
        {
          id: 16,
          type: 'single',
          category: '建筑',
          question: '故宫的正门是哪个门？',
          options: ['午门', '神武门', '东华门', '西华门'],
          correctAnswer: 0,
          explanation: '午门是故宫的正门，位于故宫的南端，是皇帝举行重大典礼和接受朝拜的地方。',
          difficulty: 'easy'
        },
        {
          id: 17,
          type: 'multiple',
          category: '建筑',
          question: '故宫的后三宫包括哪些？（多选）',
          options: ['乾清宫', '交泰殿', '坤宁宫', '养心殿'],
          correctAnswer: [0, 1, 2],
          explanation: '故宫的后三宫是指乾清宫、交泰殿、坤宁宫，是皇帝和皇后居住的地方。养心殿是清朝皇帝的寝宫，不属于后三宫。',
          difficulty: 'medium'
        },
        {
          id: 18,
          type: 'judge',
          category: '历史',
          question: '故宫在明朝时被称为"紫禁城"。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。故宫在明清两朝都被称为"紫禁城"，"紫"指紫微垣（天帝居所），"禁"指禁地，象征这里是皇帝的居所。',
          difficulty: 'easy'
        },
        {
          id: 19,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《千里江山图》是哪位画家的作品？',
          options: ['王希孟', '张择端', '顾恺之', '吴道子'],
          correctAnswer: 0,
          explanation: '《千里江山图》是北宋画家王希孟的作品，创作于18岁，是青绿山水画的代表作，现藏于故宫博物院。',
          difficulty: 'hard'
        },
        {
          id: 20,
          type: 'single',
          category: '建筑',
          question: '故宫的太和殿有多少根柱子？',
          options: ['72根', '84根', '96根', '108根'],
          correctAnswer: 0,
          explanation: '太和殿共有72根大柱，其中6根是沥粉贴金蟠龙柱，位于殿内中央，是皇帝宝座所在的位置。',
          difficulty: 'hard'
        },
        {
          id: 21,
          type: 'multiple',
          category: '历史',
          question: '以下哪些是故宫的别称？（多选）',
          options: ['紫禁城', '大内', '皇城', '宫城'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '故宫有多种别称：紫禁城（因紫微垣而得名）、大内（指皇宫）、皇城（指皇帝居住的城池）、宫城（指宫殿建筑群）。',
          difficulty: 'medium'
        },
        {
          id: 22,
          type: 'judge',
          category: '建筑',
          question: '故宫的建筑布局严格遵循"前朝后寝"的原则。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。故宫的建筑布局严格遵循"前朝后寝"的原则，前朝是皇帝处理政务的地方（三大殿），后寝是皇帝和皇后居住的地方（后三宫）。',
          difficulty: 'easy'
        },
        {
          id: 23,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《五牛图》是哪个朝代的文物？',
          options: ['唐代', '宋代', '元代', '明代'],
          correctAnswer: 0,
          explanation: '《五牛图》是唐代画家韩滉的作品，是中国现存最早的纸本绘画作品，现藏于故宫博物院。',
          difficulty: 'medium'
        },
        {
          id: 24,
          type: 'single',
          category: '建筑',
          question: '故宫的角楼共有几座？',
          options: ['2座', '4座', '6座', '8座'],
          correctAnswer: 1,
          explanation: '故宫的角楼共有4座，分别位于故宫的四个角落，是故宫建筑群的重要组成部分，具有防御和装饰的双重功能。',
          difficulty: 'easy'
        },
        {
          id: 25,
          type: 'multiple',
          category: '藏品',
          question: '故宫博物院收藏的陶瓷精品包括哪些？（多选）',
          options: ['汝窑瓷器', '官窑瓷器', '哥窑瓷器', '定窑瓷器'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '故宫博物院收藏有宋代五大名窑（汝、官、哥、定、钧）的瓷器，以及明清两朝的官窑瓷器，是中国陶瓷艺术的宝库。',
          difficulty: 'hard'
        },
        {
          id: 26,
          type: 'judge',
          category: '历史',
          question: '故宫在清朝时是24位皇帝居住和办公的地方。',
          options: ['正确', '错误'],
          correctAnswer: 1,
          explanation: '错误。清朝共有10位皇帝，从顺治到宣统，都在故宫居住和办公。明朝有16位皇帝，但明太祖朱元璋和建文帝朱允炆未在故宫居住。',
          difficulty: 'medium'
        },
        {
          id: 27,
          type: 'single',
          category: '建筑',
          question: '故宫的保和殿主要用于什么？',
          options: ['皇帝举行大典', '皇帝宴请群臣', '皇帝居住', '皇帝处理政务'],
          correctAnswer: 1,
          explanation: '保和殿主要用于皇帝宴请群臣，也是举行殿试的地方。太和殿用于举行大典，乾清宫用于处理政务。',
          difficulty: 'medium'
        },
        {
          id: 28,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《兰亭序》是哪个朝代的书法作品？',
          options: ['东晋', '唐代', '宋代', '元代'],
          correctAnswer: 0,
          explanation: '《兰亭序》是东晋书法家王羲之的作品，被誉为"天下第一行书"。故宫博物院收藏的是唐代摹本。',
          difficulty: 'hard'
        },
        {
          id: 29,
          type: 'multiple',
          category: '建筑',
          question: '故宫的东六宫包括哪些？（多选）',
          options: ['景仁宫', '承乾宫', '钟粹宫', '延禧宫'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '故宫的东六宫包括景仁宫、承乾宫、钟粹宫、延禧宫、永和宫、景阳宫，是后妃居住的地方。',
          difficulty: 'hard'
        },
        {
          id: 30,
          type: 'judge',
          category: '历史',
          question: '故宫在明朝时只有皇帝和皇后可以居住，其他妃嫔住在其他地方。',
          options: ['正确', '错误'],
          correctAnswer: 1,
          explanation: '错误。故宫在明清两朝都是皇帝、皇后、妃嫔、皇子、公主等皇室成员的居住地，后宫的东六宫和西六宫就是妃嫔的住所。',
          difficulty: 'medium'
        },
        {
          id: 31,
          type: 'single',
          category: '建筑',
          question: '故宫的神武门位于哪个方向？',
          options: ['南', '北', '东', '西'],
          correctAnswer: 1,
          explanation: '神武门位于故宫的北端，是故宫的北门，原名玄武门，清朝时改名为神武门。',
          difficulty: 'easy'
        },
        {
          id: 32,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《韩熙载夜宴图》是哪个朝代的绘画作品？',
          options: ['五代', '宋代', '元代', '明代'],
          correctAnswer: 0,
          explanation: '《韩熙载夜宴图》是五代南唐画家顾闳中的作品，描绘了南唐大臣韩熙载的夜宴场景，现藏于故宫博物院。',
          difficulty: 'hard'
        },
        {
          id: 33,
          type: 'multiple',
          category: '历史',
          question: '以下哪些皇帝在故宫居住时间最长？（多选）',
          options: ['清康熙帝', '清乾隆帝', '明成祖朱棣', '清雍正帝'],
          correctAnswer: [0, 1],
          explanation: '清康熙帝在位61年，清乾隆帝在位60年，都是在故宫居住时间最长的皇帝。明成祖朱棣在位22年，清雍正帝在位13年。',
          difficulty: 'hard'
        },
        {
          id: 34,
          type: 'judge',
          category: '建筑',
          question: '故宫的建筑全部采用木结构，没有使用任何石材。',
          options: ['正确', '错误'],
          correctAnswer: 1,
          explanation: '错误。故宫虽然以木结构为主，但也使用了大量石材，如汉白玉石阶、石栏杆、石雕等，特别是在重要的宫殿建筑中。',
          difficulty: 'medium'
        },
        {
          id: 35,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《步辇图》描绘的是什么历史事件？',
          options: ['文成公主入藏', '昭君出塞', '文成公主和亲', '玄奘西行'],
          correctAnswer: 0,
          explanation: '《步辇图》是唐代画家阎立本的作品，描绘了唐太宗接见吐蕃使臣禄东赞，商议文成公主入藏和亲的场景。',
          difficulty: 'hard'
        },
        {
          id: 36,
          type: 'single',
          category: '建筑',
          question: '故宫的养心殿主要用于什么？',
          options: ['皇帝处理政务', '皇帝居住', '皇帝读书', '皇帝举行典礼'],
          correctAnswer: 1,
          explanation: '养心殿是清朝皇帝的寝宫，从雍正皇帝开始，清朝的皇帝都在养心殿居住和处理日常政务。',
          difficulty: 'medium'
        },
        {
          id: 37,
          type: 'multiple',
          category: '藏品',
          question: '故宫博物院收藏的玉器精品包括哪些？（多选）',
          options: ['大禹治水图玉山', '桐荫仕女图玉山', '会昌九老图玉山', '秋山行旅图玉山'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '故宫博物院收藏有清代四大玉山：大禹治水图玉山、桐荫仕女图玉山、会昌九老图玉山、秋山行旅图玉山，都是清代玉雕艺术的杰作。',
          difficulty: 'hard'
        },
        {
          id: 38,
          type: 'judge',
          category: '历史',
          question: '故宫在明朝时被称为"北京紫禁城"，在清朝时改名为"紫禁城"。',
          options: ['正确', '错误'],
          correctAnswer: 1,
          explanation: '错误。故宫在明清两朝都称为"紫禁城"，没有改名。1925年成立故宫博物院后，才正式使用"故宫"这个名称。',
          difficulty: 'medium'
        },
        {
          id: 39,
          type: 'single',
          category: '建筑',
          question: '故宫的乾清宫主要用于什么？',
          options: ['皇帝居住', '皇帝处理政务', '皇帝举行大典', '皇后居住'],
          correctAnswer: 1,
          explanation: '乾清宫是皇帝处理日常政务的地方，也是皇帝批阅奏章、召见大臣的地方。明朝时皇帝也在此居住，清朝时皇帝移居养心殿。',
          difficulty: 'medium'
        },
        {
          id: 40,
          type: 'single',
          category: '藏品',
          question: '故宫博物院收藏的《快雪时晴帖》是哪位书法家的作品？',
          options: ['王羲之', '王献之', '颜真卿', '柳公权'],
          correctAnswer: 0,
          explanation: '《快雪时晴帖》是东晋书法家王羲之的作品，与《中秋帖》、《伯远帖》并称为"三希"，现藏于故宫博物院。',
          difficulty: 'hard'
        },
        {
          id: 41,
          type: 'multiple',
          category: '建筑',
          question: '故宫的三大殿屋顶都使用什么颜色的琉璃瓦？（多选）',
          options: ['黄色', '绿色', '蓝色', '红色'],
          correctAnswer: [0],
          explanation: '故宫的三大殿（太和殿、中和殿、保和殿）都使用黄色琉璃瓦，黄色象征皇权，是皇帝专用的颜色。',
          difficulty: 'easy'
        },
        {
          id: 42,
          type: 'judge',
          category: '藏品',
          question: '故宫博物院收藏的文物中，陶瓷类文物数量最多。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。故宫博物院收藏的文物中，陶瓷类文物数量最多，约有35万件，占文物总数的近20%。',
          difficulty: 'medium'
        },
        {
          id: 43,
          type: 'single',
          category: '历史',
          question: '故宫在哪个皇帝在位时开始建造？',
          options: ['明成祖朱棣', '明太祖朱元璋', '明仁宗朱高炽', '明宣宗朱瞻基'],
          correctAnswer: 0,
          explanation: '故宫在明成祖朱棣（永乐皇帝）在位时开始建造，1406年动工，1420年建成，是朱棣迁都北京的重要工程。',
          difficulty: 'easy'
        },
        {
          id: 44,
          type: 'single',
          category: '建筑',
          question: '故宫的坤宁宫主要用于什么？',
          options: ['皇后居住', '皇帝居住', '皇帝处理政务', '举行大典'],
          correctAnswer: 0,
          explanation: '坤宁宫是皇后的正宫，是皇后居住和处理后宫事务的地方。清朝时，坤宁宫也用于举行萨满教祭祀活动。',
          difficulty: 'medium'
        },
        {
          id: 45,
          type: 'multiple',
          category: '藏品',
          question: '故宫博物院收藏的青铜器精品包括哪些？（多选）',
          options: ['毛公鼎', '大盂鼎', '散氏盘', '虢季子白盘'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '故宫博物院收藏有毛公鼎、大盂鼎、散氏盘、虢季子白盘等青铜器精品，其中毛公鼎、大盂鼎、散氏盘被称为"海内三宝"。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'national_museum',
      name: '中国国家博物馆',
      description: '关于国家博物馆的文物和历史知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆成立于哪一年？',
          options: ['1912年', '1949年', '1959年', '2003年'],
          correctAnswer: 2,
          explanation: '中国国家博物馆成立于1959年，是在原中国历史博物馆和中国革命博物馆的基础上组建的。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆位于哪个城市？',
          options: ['上海', '北京', '西安', '南京'],
          correctAnswer: 1,
          explanation: '中国国家博物馆位于北京市天安门广场东侧，与人民大会堂相对。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '中国国家博物馆收藏的珍贵文物包括哪些？（多选）',
          options: ['后母戊鼎', '四羊方尊', '人面鱼纹彩陶盆', '兵马俑'],
          correctAnswer: [0, 1, 2],
          explanation: '中国国家博物馆收藏有后母戊鼎、四羊方尊、人面鱼纹彩陶盆等珍贵文物。兵马俑主要收藏在陕西历史博物馆和秦始皇兵马俑博物馆。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '中国国家博物馆是世界上单体建筑面积最大的博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆总建筑面积近20万平方米，是世界上单体建筑面积最大的博物馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '后母戊鼎（原名司母戊鼎）是哪个朝代的青铜器？',
          options: ['商朝', '周朝', '秦朝', '汉朝'],
          correctAnswer: 0,
          explanation: '后母戊鼎是商朝晚期的青铜器，是中国目前已发现的最重的青铜器，现藏于中国国家博物馆。',
          difficulty: 'hard'
        },
        {
          id: 6,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆的前身包括哪些？（多选）',
          options: ['中国历史博物馆', '中国革命博物馆', '故宫博物院', '北京历史博物馆'],
          correctAnswer: [0, 1],
          explanation: '中国国家博物馆是在原中国历史博物馆和中国革命博物馆的基础上组建的，2003年正式更名为中国国家博物馆。',
          difficulty: 'medium'
        },
        {
          id: 7,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆的总建筑面积约为多少？',
          options: ['10万平方米', '15万平方米', '20万平方米', '25万平方米'],
          correctAnswer: 2,
          explanation: '中国国家博物馆总建筑面积近20万平方米，是世界上单体建筑面积最大的博物馆。',
          difficulty: 'medium'
        },
        {
          id: 8,
          type: 'judge',
          category: '历史',
          question: '中国国家博物馆于2003年正式更名为现名。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆于2003年2月28日正式挂牌成立，由原中国历史博物馆和中国革命博物馆合并组建。',
          difficulty: 'easy'
        },
        {
          id: 9,
          type: 'single',
          category: '藏品',
          question: '四羊方尊是哪个朝代的青铜器？',
          options: ['商朝', '周朝', '春秋', '战国'],
          correctAnswer: 0,
          explanation: '四羊方尊是商朝晚期的青铜礼器，是中国现存商代青铜方尊中最大的一件，现藏于中国国家博物馆。',
          difficulty: 'medium'
        },
        {
          id: 10,
          type: 'single',
          category: '藏品',
          question: '人面鱼纹彩陶盆属于哪个文化时期？',
          options: ['仰韶文化', '龙山文化', '良渚文化', '红山文化'],
          correctAnswer: 0,
          explanation: '人面鱼纹彩陶盆属于仰韶文化半坡类型，是新石器时代彩陶艺术的代表作品，现藏于中国国家博物馆。',
          difficulty: 'hard'
        },
        {
          id: 11,
          type: 'multiple',
          category: '藏品',
          question: '中国国家博物馆收藏的"十大镇馆之宝"包括哪些？（多选）',
          options: ['后母戊鼎', '四羊方尊', '人面鱼纹彩陶盆', '金缕玉衣'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆的"十大镇馆之宝"包括后母戊鼎、四羊方尊、人面鱼纹彩陶盆、金缕玉衣等珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 12,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆的建立时间是在哪个历史时期？',
          options: ['新中国成立初期', '改革开放初期', '新世纪初期', '建国前'],
          correctAnswer: 0,
          explanation: '中国国家博物馆的前身中国历史博物馆和中国革命博物馆成立于1959年，正值新中国成立初期。',
          difficulty: 'easy'
        },
        {
          id: 13,
          type: 'judge',
          category: '建筑',
          question: '中国国家博物馆的建筑设计融合了传统与现代元素。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆的建筑设计由德国GMP建筑事务所和北京市建筑设计研究院共同完成，融合了中国传统建筑元素和现代设计理念。',
          difficulty: 'easy'
        },
        {
          id: 14,
          type: 'single',
          category: '藏品',
          question: '金缕玉衣主要出现在哪个朝代？',
          options: ['汉朝', '唐朝', '宋朝', '明朝'],
          correctAnswer: 0,
          explanation: '金缕玉衣是汉代皇帝和高级贵族死后穿用的殓服，用金丝将玉片编缀而成，现藏于中国国家博物馆。',
          difficulty: 'medium'
        },
        {
          id: 15,
          type: 'single',
          category: '展览',
          question: '中国国家博物馆的常设展览不包括以下哪个？',
          options: ['古代中国', '复兴之路', '专题陈列', '世界艺术'],
          correctAnswer: 3,
          explanation: '中国国家博物馆的常设展览主要包括"古代中国"、"复兴之路"等，以及各类专题陈列，但不包括世界艺术展览。',
          difficulty: 'medium'
        },
        {
          id: 16,
          type: 'multiple',
          category: '藏品',
          question: '中国国家博物馆收藏的青铜器包括哪些？（多选）',
          options: ['后母戊鼎', '四羊方尊', '大盂鼎', '毛公鼎'],
          correctAnswer: [0, 1],
          explanation: '中国国家博物馆收藏有后母戊鼎、四羊方尊等青铜器。大盂鼎和毛公鼎主要收藏在上海博物馆和台北故宫博物院。',
          difficulty: 'hard'
        },
        {
          id: 17,
          type: 'judge',
          category: '历史',
          question: '中国国家博物馆是免费向公众开放的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆自2011年3月起免费向公众开放，但需要提前预约。',
          difficulty: 'easy'
        },
        {
          id: 18,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆新馆的改扩建工程完成于哪一年？',
          options: ['2009年', '2011年', '2012年', '2013年'],
          correctAnswer: 1,
          explanation: '中国国家博物馆新馆的改扩建工程于2011年3月完成并重新开放，新馆建筑面积比原来增加了近一倍。',
          difficulty: 'medium'
        },
        {
          id: 19,
          type: 'single',
          category: '藏品',
          question: '明孝端皇后凤冠是哪个朝代的文物？',
          options: ['明朝', '清朝', '元朝', '宋朝'],
          correctAnswer: 0,
          explanation: '明孝端皇后凤冠是明朝万历皇帝孝端皇后的凤冠，是明代皇后礼服的冠饰，现藏于中国国家博物馆。',
          difficulty: 'medium'
        },
        {
          id: 20,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆的藏品总数约为多少？',
          options: ['100万件', '120万件', '140万件', '160万件'],
          correctAnswer: 2,
          explanation: '中国国家博物馆收藏有超过140万件文物，涵盖从远古到当代的各个历史时期。',
          difficulty: 'medium'
        },
        {
          id: 21,
          type: 'judge',
          category: '展览',
          question: '"古代中国"是中国国家博物馆的基本陈列展览。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。"古代中国"是中国国家博物馆的基本陈列，展示了从远古到1840年的中国古代历史。',
          difficulty: 'easy'
        },
        {
          id: 22,
          type: 'multiple',
          category: '藏品',
          question: '中国国家博物馆收藏的陶瓷器包括哪些类型？（多选）',
          options: ['彩陶', '青瓷', '白瓷', '唐三彩'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆收藏有各个历史时期的陶瓷器，包括新石器时代的彩陶、汉代的青瓷、唐代的三彩、宋代的青白瓷等。',
          difficulty: 'hard'
        },
        {
          id: 23,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆的"复兴之路"展览主要展示什么内容？',
          options: ['中国古代历史', '中国近现代历史', '世界历史', '艺术发展史'],
          correctAnswer: 1,
          explanation: '"复兴之路"展览主要展示1840年鸦片战争以来中国人民为实现民族复兴进行的探索和奋斗历程。',
          difficulty: 'easy'
        },
        {
          id: 24,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆新馆的设计理念主要体现什么？',
          options: ['传统与现代结合', '完全现代化', '完全传统化', '西方风格'],
          correctAnswer: 0,
          explanation: '中国国家博物馆新馆的设计理念体现了传统与现代的结合，既保留了中国传统建筑元素，又融入了现代设计理念。',
          difficulty: 'medium'
        },
        {
          id: 25,
          type: 'judge',
          category: '藏品',
          question: '后母戊鼎的重量超过800公斤。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。后母戊鼎重达832.84公斤，是中国目前已发现的最重的青铜器。',
          difficulty: 'hard'
        },
        {
          id: 26,
          type: 'single',
          category: '藏品',
          question: '中国国家博物馆收藏的古代书画作品主要来自哪个时期？',
          options: ['唐宋时期', '元明时期', '明清时期', '各个时期'],
          correctAnswer: 3,
          explanation: '中国国家博物馆收藏有各个历史时期的书画作品，包括唐宋元明清各个朝代的珍贵书画。',
          difficulty: 'medium'
        },
        {
          id: 27,
          type: 'multiple',
          category: '展览',
          question: '中国国家博物馆的展览类型包括哪些？（多选）',
          options: ['基本陈列', '专题展览', '临时展览', '国际交流展'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆的展览类型包括基本陈列（如"古代中国"）、专题展览、临时展览和国际交流展览等。',
          difficulty: 'easy'
        },
        {
          id: 28,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆在国际博物馆界的地位如何？',
          options: ['世界一流博物馆', '亚洲重要博物馆', '中国重要博物馆', '地方性博物馆'],
          correctAnswer: 0,
          explanation: '中国国家博物馆是世界一流的博物馆，与卢浮宫、大英博物馆、大都会艺术博物馆并称为世界四大博物馆。',
          difficulty: 'medium'
        },
        {
          id: 29,
          type: 'judge',
          category: '藏品',
          question: '四羊方尊的四个角上各有一只羊头装饰。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。四羊方尊的四个角上各有一只卷角羊头，羊头与羊颈伸出器外，是商代青铜器的精品。',
          difficulty: 'easy'
        },
        {
          id: 30,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆新馆的展厅面积约为多少？',
          options: ['6万平方米', '8万平方米', '10万平方米', '12万平方米'],
          correctAnswer: 0,
          explanation: '中国国家博物馆新馆的展厅面积约6万平方米，共有48个展厅，是世界上最大的博物馆之一。',
          difficulty: 'hard'
        },
        {
          id: 31,
          type: 'single',
          category: '藏品',
          question: '人面鱼纹彩陶盆上的图案主要表达了什么含义？',
          options: ['原始宗教信仰', '日常生活场景', '战争场面', '狩猎活动'],
          correctAnswer: 0,
          explanation: '人面鱼纹彩陶盆上的图案可能表达了原始宗教信仰，反映了新石器时代人们对自然和神灵的崇拜。',
          difficulty: 'hard'
        },
        {
          id: 32,
          type: 'multiple',
          category: '历史',
          question: '中国国家博物馆的职能包括哪些？（多选）',
          options: ['收藏', '研究', '展示', '教育'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆的主要职能包括收藏、研究、展示、阐释和教育，是中华文化的守护者和传承者。',
          difficulty: 'easy'
        },
        {
          id: 33,
          type: 'judge',
          category: '展览',
          question: '中国国家博物馆每年都会举办多场临时展览。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆每年都会举办多场临时展览，包括国内外的文物展览、艺术展览等。',
          difficulty: 'easy'
        },
        {
          id: 34,
          type: 'single',
          category: '藏品',
          question: '中国国家博物馆收藏的玉器主要来自哪个历史时期？',
          options: ['新石器时代', '商周时期', '汉唐时期', '各个时期'],
          correctAnswer: 3,
          explanation: '中国国家博物馆收藏有各个历史时期的玉器，从新石器时代的玉器到明清时期的玉器都有收藏。',
          difficulty: 'medium'
        },
        {
          id: 35,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆的前身之一"中国历史博物馆"成立于哪一年？',
          options: ['1912年', '1949年', '1959年', '1961年'],
          correctAnswer: 2,
          explanation: '中国历史博物馆成立于1959年，是在原北京历史博物馆的基础上扩建而成的。',
          difficulty: 'hard'
        },
        {
          id: 36,
          type: 'multiple',
          category: '藏品',
          question: '中国国家博物馆收藏的古代钱币包括哪些类型？（多选）',
          options: ['贝币', '刀币', '铜钱', '银元'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆收藏有各个历史时期的钱币，包括早期的贝币、春秋战国的刀币、历代的铜钱和近现代的银元等。',
          difficulty: 'medium'
        },
        {
          id: 37,
          type: 'judge',
          category: '建筑',
          question: '中国国家博物馆新馆采用了先进的文物保护技术。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆新馆采用了先进的恒温恒湿系统、安防系统等文物保护技术，确保文物的安全保存。',
          difficulty: 'easy'
        },
        {
          id: 38,
          type: 'single',
          category: '藏品',
          question: '后母戊鼎的"后"字在古代的含义是什么？',
          options: ['王后', '君主', '祭祀', '尊贵'],
          correctAnswer: 1,
          explanation: '后母戊鼎的"后"字在古代指君主、帝王，这个鼎是商王为祭祀其母戊而铸造的。',
          difficulty: 'hard'
        },
        {
          id: 39,
          type: 'single',
          category: '展览',
          question: '中国国家博物馆的"古代中国"展览共分为几个部分？',
          options: ['6个', '8个', '10个', '12个'],
          correctAnswer: 1,
          explanation: '"古代中国"展览共分为8个部分，按照历史朝代顺序展示从远古到1840年的中国古代历史。',
          difficulty: 'hard'
        },
        {
          id: 40,
          type: 'multiple',
          category: '历史',
          question: '中国国家博物馆收藏的文物类别包括哪些？（多选）',
          options: ['青铜器', '陶瓷器', '书画', '玉器'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆收藏的文物类别非常丰富，包括青铜器、陶瓷器、书画、玉器、钱币、印章等各个门类。',
          difficulty: 'easy'
        },
        {
          id: 41,
          type: 'judge',
          category: '藏品',
          question: '四羊方尊是1938年在湖南宁乡出土的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。四羊方尊于1938年在湖南省宁乡县黄材镇月山铺转耳仑山出土，现藏于中国国家博物馆。',
          difficulty: 'hard'
        },
        {
          id: 42,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆新馆的建筑风格主要属于什么类型？',
          options: ['新古典主义', '现代主义', '后现代主义', '折衷主义'],
          correctAnswer: 0,
          explanation: '中国国家博物馆新馆的建筑风格主要属于新古典主义，融合了中国传统建筑元素和现代设计理念。',
          difficulty: 'hard'
        },
        {
          id: 43,
          type: 'single',
          category: '藏品',
          question: '金缕玉衣的制作工艺主要体现了哪个方面的技术水平？',
          options: ['玉器加工', '金属工艺', '纺织技术', '综合工艺'],
          correctAnswer: 3,
          explanation: '金缕玉衣的制作工艺体现了古代玉器加工、金属工艺和纺织技术的综合水平，是汉代工艺技术的代表。',
          difficulty: 'medium'
        },
        {
          id: 44,
          type: 'multiple',
          category: '展览',
          question: '中国国家博物馆的专题展览主题包括哪些？（多选）',
          options: ['青铜艺术', '陶瓷艺术', '书画艺术', '玉器艺术'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆经常举办各类专题展览，包括青铜艺术、陶瓷艺术、书画艺术、玉器艺术等主题。',
          difficulty: 'medium'
        },
        {
          id: 45,
          type: 'judge',
          category: '历史',
          question: '中国国家博物馆是国家级综合性历史博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆是国家级综合性历史博物馆，代表国家收藏、研究、展示、阐释中华优秀传统文化。',
          difficulty: 'easy'
        },
        {
          id: 46,
          type: 'single',
          category: '藏品',
          question: '人面鱼纹彩陶盆的出土地点是哪里？',
          options: ['陕西西安', '河南郑州', '甘肃天水', '山东泰安'],
          correctAnswer: 0,
          explanation: '人面鱼纹彩陶盆出土于陕西省西安市半坡遗址，是仰韶文化半坡类型的典型器物，现藏于中国国家博物馆。',
          difficulty: 'hard'
        },
        {
          id: 47,
          type: 'single',
          category: '历史',
          question: '中国国家博物馆在国际交流方面的主要活动是什么？',
          options: ['举办国际展览', '文物外展', '学术交流', '以上都是'],
          correctAnswer: 3,
          explanation: '中国国家博物馆在国际交流方面积极开展活动，包括举办国际展览、文物外展、学术交流等多种形式。',
          difficulty: 'easy'
        },
        {
          id: 48,
          type: 'multiple',
          category: '藏品',
          question: '中国国家博物馆收藏的古代印章包括哪些类型？（多选）',
          options: ['官印', '私印', '肖形印', '封泥'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆收藏有丰富的古代印章，包括官印、私印、肖形印、封泥等各种类型。',
          difficulty: 'medium'
        },
        {
          id: 49,
          type: 'judge',
          category: '建筑',
          question: '中国国家博物馆新馆的改扩建工程历时约5年。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。中国国家博物馆新馆的改扩建工程从2007年开始，到2011年完成，历时约5年。',
          difficulty: 'medium'
        },
        {
          id: 50,
          type: 'single',
          category: '展览',
          question: '中国国家博物馆的"复兴之路"展览主要分为几个部分？',
          options: ['3个', '5个', '7个', '9个'],
          correctAnswer: 1,
          explanation: '"复兴之路"展览主要分为5个部分，展示了从1840年鸦片战争到新中国成立，再到改革开放的历程。',
          difficulty: 'hard'
        },
        {
          id: 51,
          type: 'single',
          category: '藏品',
          question: '明孝端皇后凤冠上装饰的主要宝石是什么？',
          options: ['红宝石', '蓝宝石', '珍珠', '翡翠'],
          correctAnswer: 2,
          explanation: '明孝端皇后凤冠上装饰有大量的珍珠，以及红宝石、蓝宝石等宝石，是明代宫廷工艺的精品。',
          difficulty: 'hard'
        },
        {
          id: 52,
          type: 'multiple',
          category: '历史',
          question: '中国国家博物馆的教育功能体现在哪些方面？（多选）',
          options: ['举办讲座', '开展研学活动', '出版图书', '数字教育'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '中国国家博物馆的教育功能体现在多个方面，包括举办讲座、开展研学活动、出版图书、数字教育等。',
          difficulty: 'easy'
        },
        {
          id: 53,
          type: 'judge',
          category: '藏品',
          question: '后母戊鼎的铸造工艺代表了商代青铜器制作的最高水平。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。后母戊鼎的铸造工艺精湛，纹饰精美，代表了商代青铜器制作的最高水平。',
          difficulty: 'medium'
        },
        {
          id: 54,
          type: 'single',
          category: '建筑',
          question: '中国国家博物馆新馆的设计师主要来自哪个国家？',
          options: ['中国', '德国', '法国', '美国'],
          correctAnswer: 1,
          explanation: '中国国家博物馆新馆的设计主要由德国GMP建筑事务所和北京市建筑设计研究院共同完成。',
          difficulty: 'hard'
        },
        {
          id: 55,
          type: 'single',
          category: '展览',
          question: '中国国家博物馆每年接待的观众数量约为多少？',
          options: ['500万人次', '700万人次', '900万人次', '1000万人次以上'],
          correctAnswer: 3,
          explanation: '中国国家博物馆每年接待的观众数量超过1000万人次，是世界上参观人数最多的博物馆之一。',
          difficulty: 'medium'
        }
      ]
    },
    {
      id: 'louvre',
      name: '卢浮宫',
      description: '关于卢浮宫的艺术品和历史文化',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '卢浮宫位于哪个城市？',
          options: ['巴黎', '伦敦', '罗马', '马德里'],
          correctAnswer: 0,
          explanation: '卢浮宫位于法国巴黎，是世界上最著名的博物馆之一，也是法国最大的王宫建筑群。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '卢浮宫最著名的藏品《蒙娜丽莎》是哪位画家的作品？',
          options: ['达·芬奇', '米开朗基罗', '拉斐尔', '提香'],
          correctAnswer: 0,
          explanation: '《蒙娜丽莎》是意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，现藏于卢浮宫。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '卢浮宫三大镇馆之宝包括哪些？（多选）',
          options: ['《蒙娜丽莎》', '《断臂的维纳斯》', '《胜利女神像》', '《最后的晚餐》'],
          correctAnswer: [0, 1, 2],
          explanation: '卢浮宫三大镇馆之宝是《蒙娜丽莎》、《断臂的维纳斯》（米洛的维纳斯）和《胜利女神像》。《最后的晚餐》现藏于意大利米兰。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '卢浮宫最初是作为法国王宫建造的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。卢浮宫最初建于12世纪末，是法国王室的城堡和宫殿，1793年才正式对外开放成为博物馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '建筑',
          question: '卢浮宫前的玻璃金字塔是由哪位建筑师设计的？',
          options: ['贝聿铭', '安藤忠雄', '扎哈·哈迪德', '弗兰克·盖里'],
          correctAnswer: 0,
          explanation: '卢浮宫前的玻璃金字塔是由美籍华裔建筑师贝聿铭设计的，于1989年建成，是卢浮宫的主要入口。',
          difficulty: 'hard'
        },
        {
          id: 6,
          type: 'single',
          category: '历史',
          question: '卢浮宫最初建于哪个世纪？',
          options: ['11世纪', '12世纪', '13世纪', '14世纪'],
          correctAnswer: 1,
          explanation: '卢浮宫最初建于12世纪末（1190年左右），最初是作为防御性城堡建造的。',
          difficulty: 'medium'
        },
        {
          id: 7,
          type: 'single',
          category: '历史',
          question: '卢浮宫正式对外开放成为博物馆是在哪一年？',
          options: ['1789年', '1793年', '1800年', '1815年'],
          correctAnswer: 1,
          explanation: '卢浮宫于1793年8月10日正式对外开放成为博物馆，当时名为"中央艺术博物馆"。',
          difficulty: 'medium'
        },
        {
          id: 8,
          type: 'judge',
          category: '藏品',
          question: '《断臂的维纳斯》也被称为"米洛的维纳斯"。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《断臂的维纳斯》因在希腊米洛斯岛被发现而得名"米洛的维纳斯"，是卢浮宫三大镇馆之宝之一。',
          difficulty: 'easy'
        },
        {
          id: 9,
          type: 'single',
          category: '藏品',
          question: '《胜利女神像》创作于哪个时期？',
          options: ['古希腊时期', '古罗马时期', '文艺复兴时期', '巴洛克时期'],
          correctAnswer: 0,
          explanation: '《胜利女神像》创作于古希腊时期（约公元前190年），是卢浮宫三大镇馆之宝之一。',
          difficulty: 'medium'
        },
        {
          id: 10,
          type: 'multiple',
          category: '建筑',
          question: '卢浮宫的建筑风格包括哪些？（多选）',
          options: ['哥特式', '文艺复兴式', '巴洛克式', '新古典主义'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '卢浮宫的建筑风格融合了多个历史时期，包括哥特式、文艺复兴式、巴洛克式和新古典主义等。',
          difficulty: 'hard'
        },
        {
          id: 11,
          type: 'single',
          category: '历史',
          question: '卢浮宫曾经居住过多少位法国国王和王后？',
          options: ['30位', '40位', '50位', '60位'],
          correctAnswer: 2,
          explanation: '卢浮宫曾经居住过50位法国国王和王后，是法国历史上最重要的王宫之一。',
          difficulty: 'hard'
        },
        {
          id: 12,
          type: 'judge',
          category: '建筑',
          question: '卢浮宫前的玻璃金字塔是卢浮宫的主要入口。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。玻璃金字塔于1989年建成，是卢浮宫的主要入口，也是卢浮宫现代化改造的标志性建筑。',
          difficulty: 'easy'
        },
        {
          id: 13,
          type: 'single',
          category: '藏品',
          question: '卢浮宫收藏的艺术品总数约为多少？',
          options: ['30万件', '35万件', '40万件', '45万件'],
          correctAnswer: 2,
          explanation: '卢浮宫收藏有超过40万件艺术品，包括绘画、雕塑、古代文物等各个门类。',
          difficulty: 'medium'
        },
        {
          id: 14,
          type: 'single',
          category: '藏品',
          question: '《蒙娜丽莎》的另一个名称是什么？',
          options: ['《乔康达夫人》', '《微笑的女人》', '《神秘的微笑》', '《达芬奇的肖像》'],
          correctAnswer: 0,
          explanation: '《蒙娜丽莎》的另一个名称是《乔康达夫人》（La Gioconda），因为画中人物可能是佛罗伦萨商人弗朗切斯科·德尔·乔康达的妻子。',
          difficulty: 'hard'
        },
        {
          id: 15,
          type: 'multiple',
          category: '藏品',
          question: '卢浮宫收藏的著名绘画作品包括哪些？（多选）',
          options: ['《蒙娜丽莎》', '《自由引导人民》', '《加冕礼》', '《梅杜萨之筏》'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '卢浮宫收藏有大量著名绘画作品，包括《蒙娜丽莎》、《自由引导人民》、《加冕礼》、《梅杜萨之筏》等。',
          difficulty: 'medium'
        },
        {
          id: 16,
          type: 'single',
          category: '历史',
          question: '卢浮宫在法国大革命期间发生了什么变化？',
          options: ['被毁坏', '被改建为博物馆', '被废弃', '被出售'],
          correctAnswer: 1,
          explanation: '在法国大革命期间，卢浮宫被改建为博物馆，向公众开放，成为世界上最早的公共博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 17,
          type: 'judge',
          category: '建筑',
          question: '卢浮宫是法国最大的王宫建筑群。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。卢浮宫是法国最大的王宫建筑群，占地面积约19.8公顷。',
          difficulty: 'easy'
        },
        {
          id: 18,
          type: 'single',
          category: '藏品',
          question: '《汉谟拉比法典》现藏于哪个博物馆？',
          options: ['卢浮宫', '大英博物馆', '大都会艺术博物馆', '柏林国家博物馆'],
          correctAnswer: 0,
          explanation: '《汉谟拉比法典》是古巴比伦的珍贵文物，现藏于卢浮宫，是古代法律的重要见证。',
          difficulty: 'medium'
        },
        {
          id: 19,
          type: 'single',
          category: '建筑',
          question: '卢浮宫玻璃金字塔的高度约为多少米？',
          options: ['18米', '21米', '24米', '27米'],
          correctAnswer: 1,
          explanation: '卢浮宫玻璃金字塔的高度为21.65米，由603块菱形玻璃和70块三角形玻璃组成。',
          difficulty: 'hard'
        },
        {
          id: 20,
          type: 'multiple',
          category: '藏品',
          question: '卢浮宫收藏的古埃及文物包括哪些？（多选）',
          options: ['木乃伊', '法老雕像', '古埃及石碑', '古埃及壁画'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '卢浮宫收藏有丰富的古埃及文物，包括木乃伊、法老雕像、古埃及石碑、古埃及壁画等。',
          difficulty: 'medium'
        },
        {
          id: 21,
          type: 'single',
          category: '历史',
          question: '卢浮宫在哪个国王统治时期开始大规模扩建？',
          options: ['弗朗索瓦一世', '路易十四', '拿破仑', '路易·菲利普'],
          correctAnswer: 0,
          explanation: '卢浮宫在弗朗索瓦一世（1515-1547年）统治时期开始大规模扩建，并开始收藏艺术品。',
          difficulty: 'hard'
        },
        {
          id: 22,
          type: 'judge',
          category: '藏品',
          question: '《蒙娜丽莎》曾经被盗过。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《蒙娜丽莎》在1911年曾经被盗，两年后才被找回，这一事件使其更加闻名于世。',
          difficulty: 'medium'
        },
        {
          id: 23,
          type: 'single',
          category: '藏品',
          question: '《自由引导人民》是哪位画家的作品？',
          options: ['德拉克洛瓦', '安格尔', '大卫', '库尔贝'],
          correctAnswer: 0,
          explanation: '《自由引导人民》是法国浪漫主义画家欧仁·德拉克洛瓦的作品，现藏于卢浮宫。',
          difficulty: 'medium'
        },
        {
          id: 24,
          type: 'single',
          category: '建筑',
          question: '卢浮宫的主要建筑风格是什么？',
          options: ['巴洛克式', '新古典主义', '文艺复兴式', '混合式'],
          correctAnswer: 3,
          explanation: '卢浮宫的建筑风格是混合式的，融合了多个历史时期的建筑风格，反映了其悠久的历史。',
          difficulty: 'medium'
        },
        {
          id: 25,
          type: 'multiple',
          category: '历史',
          question: '卢浮宫在不同历史时期的功能包括哪些？（多选）',
          options: ['防御性城堡', '王宫', '博物馆', '艺术学校'],
          correctAnswer: [0, 1, 2],
          explanation: '卢浮宫在不同历史时期曾作为防御性城堡、王宫和博物馆，但从未作为艺术学校使用。',
          difficulty: 'medium'
        },
        {
          id: 26,
          type: 'single',
          category: '藏品',
          question: '《加冕礼》描绘的是哪位皇帝的加冕仪式？',
          options: ['拿破仑一世', '路易十六', '查理十世', '路易·菲利普'],
          correctAnswer: 0,
          explanation: '《加冕礼》是雅克-路易·大卫的作品，描绘了拿破仑一世在巴黎圣母院的加冕仪式，现藏于卢浮宫。',
          difficulty: 'hard'
        },
        {
          id: 27,
          type: 'judge',
          category: '建筑',
          question: '卢浮宫玻璃金字塔的设计在当时引起了很大争议。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。贝聿铭设计的玻璃金字塔在当时引起了很大争议，许多人认为现代建筑与古典建筑不协调，但现在已成为卢浮宫的标志。',
          difficulty: 'easy'
        },
        {
          id: 28,
          type: 'single',
          category: '藏品',
          question: '卢浮宫收藏的古代东方文物主要来自哪些地区？',
          options: ['美索不达米亚', '古埃及', '古希腊', '以上都是'],
          correctAnswer: 3,
          explanation: '卢浮宫收藏的古代东方文物来自多个地区，包括美索不达米亚、古埃及、古希腊等。',
          difficulty: 'medium'
        },
        {
          id: 29,
          type: 'single',
          category: '历史',
          question: '卢浮宫在哪个时期成为欧洲最大的王宫？',
          options: ['文艺复兴时期', '巴洛克时期', '路易十四时期', '拿破仑时期'],
          correctAnswer: 2,
          explanation: '卢浮宫在路易十四时期（1643-1715年）成为欧洲最大的王宫，但路易十四后来将宫廷迁至凡尔赛宫。',
          difficulty: 'hard'
        },
        {
          id: 30,
          type: 'multiple',
          category: '藏品',
          question: '卢浮宫收藏的雕塑作品包括哪些类型？（多选）',
          options: ['古希腊雕塑', '古罗马雕塑', '文艺复兴雕塑', '现代雕塑'],
          correctAnswer: [0, 1, 2],
          explanation: '卢浮宫收藏有丰富的雕塑作品，包括古希腊雕塑、古罗马雕塑、文艺复兴雕塑等，但现代雕塑较少。',
          difficulty: 'medium'
        },
        {
          id: 31,
          type: 'single',
          category: '建筑',
          question: '卢浮宫的总面积约为多少公顷？',
          options: ['15公顷', '18公顷', '20公顷', '22公顷'],
          correctAnswer: 2,
          explanation: '卢浮宫的总面积约为20公顷，是法国最大的王宫建筑群。',
          difficulty: 'hard'
        },
        {
          id: 32,
          type: 'judge',
          category: '藏品',
          question: '《梅杜萨之筏》是法国浪漫主义绘画的代表作。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《梅杜萨之筏》是泰奥多尔·席里柯的作品，是法国浪漫主义绘画的代表作，现藏于卢浮宫。',
          difficulty: 'medium'
        },
        {
          id: 33,
          type: 'single',
          category: '历史',
          question: '卢浮宫在哪个时期开始大量收藏意大利文艺复兴时期的艺术品？',
          options: ['弗朗索瓦一世时期', '路易十四时期', '拿破仑时期', '第三共和国时期'],
          correctAnswer: 0,
          explanation: '卢浮宫在弗朗索瓦一世时期开始大量收藏意大利文艺复兴时期的艺术品，包括达·芬奇的作品。',
          difficulty: 'hard'
        },
        {
          id: 34,
          type: 'single',
          category: '藏品',
          question: '《断臂的维纳斯》是在哪个岛屿被发现的？',
          options: ['米洛斯岛', '克里特岛', '罗德岛', '塞浦路斯岛'],
          correctAnswer: 0,
          explanation: '《断臂的维纳斯》于1820年在希腊米洛斯岛被发现，因此也被称为"米洛的维纳斯"。',
          difficulty: 'medium'
        },
        {
          id: 35,
          type: 'multiple',
          category: '建筑',
          question: '卢浮宫的主要建筑部分包括哪些？（多选）',
          options: ['叙利馆', '德农馆', '黎塞留馆', '玻璃金字塔'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '卢浮宫的主要建筑部分包括叙利馆、德农馆、黎塞留馆和玻璃金字塔等。',
          difficulty: 'medium'
        },
        {
          id: 36,
          type: 'single',
          category: '藏品',
          question: '卢浮宫收藏的《蒙娜丽莎》画作的尺寸是多少？',
          options: ['53cm × 77cm', '60cm × 80cm', '70cm × 90cm', '80cm × 100cm'],
          correctAnswer: 0,
          explanation: '《蒙娜丽莎》的画作尺寸为53cm × 77cm，是一幅相对较小的油画作品。',
          difficulty: 'hard'
        },
        {
          id: 37,
          type: 'judge',
          category: '历史',
          question: '卢浮宫在拿破仑时期被称为"拿破仑博物馆"。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。卢浮宫在拿破仑时期（1803-1815年）被称为"拿破仑博物馆"，拿破仑从欧洲各地掠夺了大量艺术品充实馆藏。',
          difficulty: 'medium'
        },
        {
          id: 38,
          type: 'single',
          category: '藏品',
          question: '《胜利女神像》原本是放置在什么地方的？',
          options: ['神庙', '广场', '海边的悬崖', '王宫'],
          correctAnswer: 2,
          explanation: '《胜利女神像》原本是放置在希腊萨莫色雷斯岛海边悬崖上的，用来纪念海战的胜利。',
          difficulty: 'hard'
        },
        {
          id: 39,
          type: 'single',
          category: '建筑',
          question: '卢浮宫玻璃金字塔使用了多少块玻璃？',
          options: ['600块', '650块', '673块', '700块'],
          correctAnswer: 2,
          explanation: '卢浮宫玻璃金字塔使用了673块玻璃，包括603块菱形玻璃和70块三角形玻璃。',
          difficulty: 'hard'
        },
        {
          id: 40,
          type: 'multiple',
          category: '藏品',
          question: '卢浮宫收藏的达·芬奇作品包括哪些？（多选）',
          options: ['《蒙娜丽莎》', '《岩间圣母》', '《施洗者圣约翰》', '《最后的晚餐》'],
          correctAnswer: [0, 1, 2],
          explanation: '卢浮宫收藏有达·芬奇的多幅作品，包括《蒙娜丽莎》、《岩间圣母》、《施洗者圣约翰》等。《最后的晚餐》在意大利米兰。',
          difficulty: 'hard'
        },
        {
          id: 41,
          type: 'single',
          category: '历史',
          question: '卢浮宫每年接待的游客数量约为多少？',
          options: ['800万人次', '900万人次', '1000万人次', '1100万人次'],
          correctAnswer: 2,
          explanation: '卢浮宫每年接待的游客数量超过1000万人次，是世界上参观人数最多的博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 42,
          type: 'judge',
          category: '建筑',
          question: '卢浮宫的建筑群包括多个庭院和花园。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。卢浮宫的建筑群包括多个庭院和花园，如拿破仑庭院、卡鲁塞尔庭院等。',
          difficulty: 'easy'
        },
        {
          id: 43,
          type: 'single',
          category: '藏品',
          question: '《汉谟拉比法典》是用什么材料制成的？',
          options: ['大理石', '玄武岩', '花岗岩', '石灰岩'],
          correctAnswer: 1,
          explanation: '《汉谟拉比法典》是用黑色玄武岩制成的石碑，上面刻有古巴比伦的法律条文，现藏于卢浮宫。',
          difficulty: 'hard'
        },
        {
          id: 44,
          type: 'single',
          category: '展览',
          question: '卢浮宫的展览区域主要分为几个部分？',
          options: ['6个', '8个', '10个', '12个'],
          correctAnswer: 1,
          explanation: '卢浮宫的展览区域主要分为8个部分，包括古埃及文物、古希腊和古罗马文物、绘画、雕塑等。',
          difficulty: 'medium'
        }
      ]
    },
    {
      id: 'british_museum',
      name: '大英博物馆',
      description: '关于大英博物馆的收藏和历史',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '大英博物馆成立于哪一年？',
          options: ['1753年', '1800年', '1850年', '1900年'],
          correctAnswer: 0,
          explanation: '大英博物馆成立于1753年，是世界上历史最悠久、规模最宏伟的综合性博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '大英博物馆最著名的藏品之一《罗塞塔石碑》来自哪个国家？',
          options: ['埃及', '希腊', '意大利', '土耳其'],
          correctAnswer: 0,
          explanation: '《罗塞塔石碑》是古埃及的文物，1799年在埃及罗塞塔镇被发现，现藏于大英博物馆，是解读古埃及文字的关键。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的著名文物包括哪些？（多选）',
          options: ['《罗塞塔石碑》', '《埃尔金大理石雕》', '《女史箴图》', '《蒙娜丽莎》'],
          correctAnswer: [0, 1, 2],
          explanation: '大英博物馆收藏有《罗塞塔石碑》、《埃尔金大理石雕》（帕特农神庙雕塑）、《女史箴图》等著名文物。《蒙娜丽莎》在卢浮宫。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '大英博物馆是世界上第一个国家公共博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆是世界上第一个向公众开放的国家博物馆，对所有"好学求知的人"免费开放。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '建筑',
          question: '大英博物馆的标志性建筑"大中庭"的玻璃穹顶是由哪位建筑师设计的？',
          options: ['诺曼·福斯特', '扎哈·哈迪德', '理查德·罗杰斯', '伦佐·皮亚诺'],
          correctAnswer: 0,
          explanation: '大英博物馆的大中庭（Great Court）及其玻璃穹顶是由英国建筑师诺曼·福斯特设计的，于2000年开放。',
          difficulty: 'hard'
        },
        {
          id: 6,
          type: 'single',
          category: '历史',
          question: '大英博物馆的建立是基于谁的收藏？',
          options: ['汉斯·斯隆', '罗伯特·科顿', '罗伯特·哈利', '以上都是'],
          correctAnswer: 3,
          explanation: '大英博物馆的建立基于汉斯·斯隆爵士、罗伯特·科顿爵士和罗伯特·哈利伯爵的收藏，这些收藏构成了博物馆最初的核心。',
          difficulty: 'medium'
        },
        {
          id: 7,
          type: 'single',
          category: '历史',
          question: '大英博物馆正式对公众开放是在哪一年？',
          options: ['1753年', '1759年', '1760年', '1765年'],
          correctAnswer: 1,
          explanation: '大英博物馆于1759年1月15日正式对公众开放，是世界上第一个向公众开放的国家博物馆。',
          difficulty: 'medium'
        },
        {
          id: 8,
          type: 'judge',
          category: '历史',
          question: '大英博物馆自成立以来一直免费向公众开放。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆自成立以来一直免费向公众开放，对所有"好学求知的人"免费开放，这一传统延续至今。',
          difficulty: 'easy'
        },
        {
          id: 9,
          type: 'single',
          category: '藏品',
          question: '《罗塞塔石碑》上刻有几种文字？',
          options: ['2种', '3种', '4种', '5种'],
          correctAnswer: 1,
          explanation: '《罗塞塔石碑》上刻有三种文字：古埃及象形文字、古埃及草书和古希腊文，是解读古埃及文字的关键。',
          difficulty: 'medium'
        },
        {
          id: 10,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的古希腊文物包括哪些？（多选）',
          options: ['帕特农神庙雕塑', '埃尔金大理石雕', '古希腊陶器', '古希腊雕塑'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的古希腊文物，包括帕特农神庙雕塑（埃尔金大理石雕）、古希腊陶器、古希腊雕塑等。',
          difficulty: 'medium'
        },
        {
          id: 11,
          type: 'single',
          category: '历史',
          question: '《埃尔金大理石雕》是从哪里运到英国的？',
          options: ['希腊雅典', '意大利罗马', '土耳其伊斯坦布尔', '埃及开罗'],
          correctAnswer: 0,
          explanation: '《埃尔金大理石雕》是从希腊雅典的帕特农神庙运到英国的，由英国驻奥斯曼帝国大使埃尔金伯爵在19世纪初运回英国。',
          difficulty: 'hard'
        },
        {
          id: 12,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的《女史箴图》是哪个朝代的绘画作品？',
          options: ['东晋', '唐朝', '宋朝', '元朝'],
          correctAnswer: 0,
          explanation: '《女史箴图》是东晋画家顾恺之的作品，是中国现存最早的卷轴画之一，现藏于大英博物馆。',
          difficulty: 'hard'
        },
        {
          id: 13,
          type: 'judge',
          category: '建筑',
          question: '大英博物馆的大中庭是欧洲最大的有顶广场。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆的大中庭是欧洲最大的有顶广场，面积约2英亩，由诺曼·福斯特设计的玻璃穹顶覆盖。',
          difficulty: 'medium'
        },
        {
          id: 14,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的文物总数约为多少？',
          options: ['600万件', '700万件', '800万件', '900万件'],
          correctAnswer: 2,
          explanation: '大英博物馆收藏有超过800万件文物，是世界上规模最大、藏品最丰富的博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 15,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的古埃及文物包括哪些？（多选）',
          options: ['木乃伊', '法老雕像', '古埃及石碑', '古埃及纸草'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的古埃及文物，包括木乃伊、法老雕像、古埃及石碑、古埃及纸草等，是世界上收藏古埃及文物最多的博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 16,
          type: 'single',
          category: '历史',
          question: '大英博物馆最初位于哪个建筑？',
          options: ['蒙塔古宫', '白金汉宫', '威斯敏斯特宫', '汉普顿宫'],
          correctAnswer: 0,
          explanation: '大英博物馆最初位于蒙塔古宫（Montagu House），这是一座17世纪的建筑，后来被拆除重建。',
          difficulty: 'hard'
        },
        {
          id: 17,
          type: 'single',
          category: '建筑',
          question: '大英博物馆现在的建筑主要建于哪个时期？',
          options: ['18世纪', '19世纪', '20世纪', '21世纪'],
          correctAnswer: 1,
          explanation: '大英博物馆现在的建筑主要建于19世纪，由罗伯特·斯默克设计，采用新古典主义风格。',
          difficulty: 'medium'
        },
        {
          id: 18,
          type: 'judge',
          category: '藏品',
          question: '《罗塞塔石碑》的发现帮助学者解读了古埃及象形文字。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《罗塞塔石碑》的发现是解读古埃及象形文字的关键，法国学者商博良通过对比石碑上的三种文字，成功解读了古埃及象形文字。',
          difficulty: 'easy'
        },
        {
          id: 19,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的亚述文物主要来自哪个地区？',
          options: ['美索不达米亚', '古埃及', '古希腊', '古罗马'],
          correctAnswer: 0,
          explanation: '大英博物馆收藏的亚述文物主要来自美索不达米亚地区（今伊拉克），包括亚述王宫的浮雕和雕塑。',
          difficulty: 'medium'
        },
        {
          id: 20,
          type: 'single',
          category: '历史',
          question: '大英博物馆的建立与哪个法案有关？',
          options: ['《大英博物馆法》', '《1753年法案》', '《公共博物馆法》', '《国家收藏法》'],
          correctAnswer: 1,
          explanation: '大英博物馆的建立与《1753年法案》有关，该法案批准了博物馆的建立和汉斯·斯隆爵士收藏的收购。',
          difficulty: 'hard'
        },
        {
          id: 21,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的中国文物包括哪些类型？（多选）',
          options: ['绘画', '陶瓷', '青铜器', '玉器'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的中国文物，包括绘画、陶瓷、青铜器、玉器等各个门类，是海外收藏中国文物最多的博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 22,
          type: 'single',
          category: '建筑',
          question: '大英博物馆大中庭的玻璃穹顶面积约为多少平方米？',
          options: ['6000平方米', '7000平方米', '8000平方米', '9000平方米'],
          correctAnswer: 0,
          explanation: '大英博物馆大中庭的玻璃穹顶面积约6000平方米，由3312块三角形玻璃板组成。',
          difficulty: 'hard'
        },
        {
          id: 23,
          type: 'judge',
          category: '历史',
          question: '大英博物馆在19世纪进行了大规模扩建。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆在19世纪进行了大规模扩建，包括新建了圆形阅览室和多个展厅，形成了现在的建筑规模。',
          difficulty: 'easy'
        },
        {
          id: 24,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的《亚述王宫浮雕》主要描绘了什么内容？',
          options: ['战争场面', '狩猎活动', '宫廷生活', '以上都是'],
          correctAnswer: 3,
          explanation: '大英博物馆收藏的《亚述王宫浮雕》描绘了战争场面、狩猎活动和宫廷生活等多种内容，是研究亚述文明的重要资料。',
          difficulty: 'medium'
        },
        {
          id: 25,
          type: 'single',
          category: '历史',
          question: '大英博物馆的圆形阅览室曾经被哪些著名人物使用过？',
          options: ['马克思', '列宁', '萧伯纳', '以上都是'],
          correctAnswer: 3,
          explanation: '大英博物馆的圆形阅览室曾经被许多著名人物使用过，包括马克思、列宁、萧伯纳等，马克思在这里完成了《资本论》的写作。',
          difficulty: 'medium'
        },
        {
          id: 26,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的古代近东文物包括哪些？（多选）',
          options: ['美索不达米亚文物', '波斯文物', '巴比伦文物', '亚述文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的古代近东文物，包括美索不达米亚、波斯、巴比伦、亚述等各个文明的文物。',
          difficulty: 'medium'
        },
        {
          id: 27,
          type: 'single',
          category: '建筑',
          question: '大英博物馆的建筑风格主要是什么？',
          options: ['新古典主义', '哥特式', '巴洛克式', '现代主义'],
          correctAnswer: 0,
          explanation: '大英博物馆的建筑风格主要是新古典主义，由罗伯特·斯默克设计，体现了19世纪英国建筑的特色。',
          difficulty: 'medium'
        },
        {
          id: 28,
          type: 'judge',
          category: '藏品',
          question: '大英博物馆是世界上收藏古埃及文物最多的博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆收藏有超过10万件古埃及文物，是世界上收藏古埃及文物最多的博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 29,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的《拉美西斯二世雕像》来自哪个国家？',
          options: ['埃及', '希腊', '土耳其', '伊拉克'],
          correctAnswer: 0,
          explanation: '《拉美西斯二世雕像》是古埃及的文物，来自埃及，现藏于大英博物馆，是古埃及艺术的杰作。',
          difficulty: 'medium'
        },
        {
          id: 30,
          type: 'single',
          category: '历史',
          question: '大英博物馆在哪个时期将自然历史藏品分离出去？',
          options: ['19世纪80年代', '19世纪90年代', '20世纪初', '20世纪20年代'],
          correctAnswer: 0,
          explanation: '大英博物馆在19世纪80年代将自然历史藏品分离出去，成立了自然历史博物馆，使大英博物馆专注于人类历史和艺术。',
          difficulty: 'hard'
        },
        {
          id: 31,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的欧洲文物包括哪些？（多选）',
          options: ['中世纪文物', '文艺复兴艺术品', '古代钱币', '古代珠宝'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的欧洲文物，包括中世纪文物、文艺复兴艺术品、古代钱币、古代珠宝等。',
          difficulty: 'medium'
        },
        {
          id: 32,
          type: 'single',
          category: '建筑',
          question: '大英博物馆大中庭的改造完成于哪一年？',
          options: ['1998年', '2000年', '2002年', '2004年'],
          correctAnswer: 1,
          explanation: '大英博物馆大中庭的改造完成于2000年，由诺曼·福斯特设计，是博物馆现代化改造的重要项目。',
          difficulty: 'medium'
        },
        {
          id: 33,
          type: 'judge',
          category: '藏品',
          question: '《女史箴图》是大英博物馆收藏的最重要的中国绘画作品之一。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《女史箴图》是大英博物馆收藏的最重要的中国绘画作品之一，是东晋画家顾恺之的代表作。',
          difficulty: 'easy'
        },
        {
          id: 34,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的《亚述王宫浮雕》主要来自哪个亚述王宫？',
          options: ['尼尼微', '尼姆鲁德', '霍尔萨巴德', '以上都是'],
          correctAnswer: 3,
          explanation: '大英博物馆收藏的《亚述王宫浮雕》来自多个亚述王宫，包括尼尼微、尼姆鲁德、霍尔萨巴德等。',
          difficulty: 'hard'
        },
        {
          id: 35,
          type: 'single',
          category: '历史',
          question: '大英博物馆每年接待的游客数量约为多少？',
          options: ['500万人次', '600万人次', '700万人次', '800万人次'],
          correctAnswer: 1,
          explanation: '大英博物馆每年接待的游客数量超过600万人次，是世界上参观人数最多的博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 36,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的非洲文物包括哪些类型？（多选）',
          options: ['雕塑', '面具', '纺织品', '金属工艺品'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的非洲文物，包括雕塑、面具、纺织品、金属工艺品等各个类型。',
          difficulty: 'medium'
        },
        {
          id: 37,
          type: 'single',
          category: '建筑',
          question: '大英博物馆的圆形阅览室直径约为多少米？',
          options: ['40米', '42米', '44米', '46米'],
          correctAnswer: 2,
          explanation: '大英博物馆的圆形阅览室直径约为44米，曾经是世界上最大的圆形阅览室。',
          difficulty: 'hard'
        },
        {
          id: 38,
          type: 'judge',
          category: '历史',
          question: '大英博物馆的建立标志着现代博物馆制度的开始。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆的建立标志着现代博物馆制度的开始，其免费向公众开放的理念影响了世界各地的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 39,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的《古埃及木乃伊》数量约为多少？',
          options: ['100具', '120具', '140具', '160具'],
          correctAnswer: 1,
          explanation: '大英博物馆收藏有约120具古埃及木乃伊，是世界上收藏木乃伊最多的博物馆之一。',
          difficulty: 'hard'
        },
        {
          id: 40,
          type: 'single',
          category: '展览',
          question: '大英博物馆的展览区域主要分为几个部分？',
          options: ['8个', '10个', '12个', '14个'],
          correctAnswer: 1,
          explanation: '大英博物馆的展览区域主要分为10个部分，包括古埃及、古希腊、古罗马、亚洲、非洲等各个区域。',
          difficulty: 'medium'
        },
        {
          id: 41,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的美洲文物包括哪些？（多选）',
          options: ['玛雅文物', '阿兹特克文物', '印加文物', '北美原住民文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的美洲文物，包括玛雅、阿兹特克、印加和北美原住民等各个文明的文物。',
          difficulty: 'medium'
        },
        {
          id: 42,
          type: 'single',
          category: '历史',
          question: '大英博物馆在哪个时期开始收藏亚洲文物？',
          options: ['18世纪', '19世纪', '20世纪', '21世纪'],
          correctAnswer: 1,
          explanation: '大英博物馆在19世纪开始大量收藏亚洲文物，随着大英帝国的扩张，大量亚洲文物被运到英国。',
          difficulty: 'hard'
        },
        {
          id: 43,
          type: 'judge',
          category: '建筑',
          question: '大英博物馆的大中庭曾经是博物馆的阅览室所在地。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆的大中庭曾经是博物馆的阅览室所在地，圆形阅览室就位于大中庭的中心。',
          difficulty: 'medium'
        },
        {
          id: 44,
          type: 'single',
          category: '藏品',
          question: '大英博物馆收藏的《古埃及纸草》数量约为多少？',
          options: ['1000件', '2000件', '3000件', '4000件'],
          correctAnswer: 2,
          explanation: '大英博物馆收藏有约3000件古埃及纸草，是世界上收藏古埃及纸草最多的博物馆之一。',
          difficulty: 'hard'
        },
        {
          id: 45,
          type: 'single',
          category: '历史',
          question: '大英博物馆的建立者汉斯·斯隆爵士是什么职业？',
          options: ['医生', '收藏家', '商人', '以上都是'],
          correctAnswer: 3,
          explanation: '汉斯·斯隆爵士是医生、收藏家和商人，他的收藏构成了大英博物馆最初的核心。',
          difficulty: 'medium'
        },
        {
          id: 46,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的古代钱币包括哪些？（多选）',
          options: ['古希腊钱币', '古罗马钱币', '古代中国钱币', '古代印度钱币'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的古代钱币，包括古希腊、古罗马、古代中国、古代印度等各个文明的钱币。',
          difficulty: 'medium'
        },
        {
          id: 47,
          type: 'single',
          category: '建筑',
          question: '大英博物馆大中庭的玻璃穹顶使用了多少块玻璃板？',
          options: ['3000块', '3200块', '3312块', '3500块'],
          correctAnswer: 2,
          explanation: '大英博物馆大中庭的玻璃穹顶使用了3312块三角形玻璃板，每块玻璃板都是独特的形状。',
          difficulty: 'hard'
        },
        {
          id: 48,
          type: 'judge',
          category: '藏品',
          question: '《埃尔金大理石雕》的归属问题一直是国际争议的焦点。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《埃尔金大理石雕》的归属问题一直是国际争议的焦点，希腊政府一直要求英国归还这些雕塑。',
          difficulty: 'easy'
        },
        {
          id: 49,
          type: 'single',
          category: '展览',
          question: '大英博物馆的"古埃及展厅"是世界上最大的古埃及文物展厅之一。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大英博物馆的"古埃及展厅"是世界上最大的古埃及文物展厅之一，收藏有丰富的古埃及文物。',
          difficulty: 'easy'
        },
        {
          id: 50,
          type: 'single',
          category: '历史',
          question: '大英博物馆在哪个时期将人类学藏品分离出去？',
          options: ['19世纪70年代', '19世纪80年代', '19世纪90年代', '20世纪初'],
          correctAnswer: 0,
          explanation: '大英博物馆在19世纪70年代将人类学藏品分离出去，成立了人类学博物馆（现为皮特·里弗斯博物馆）。',
          difficulty: 'hard'
        },
        {
          id: 51,
          type: 'multiple',
          category: '藏品',
          question: '大英博物馆收藏的古代印章包括哪些？（多选）',
          options: ['美索不达米亚印章', '古埃及印章', '古希腊印章', '古罗马印章'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大英博物馆收藏有丰富的古代印章，包括美索不达米亚、古埃及、古希腊、古罗马等各个文明的印章。',
          difficulty: 'medium'
        },
        {
          id: 52,
          type: 'single',
          category: '建筑',
          question: '大英博物馆的建筑设计师罗伯特·斯默克还设计了哪个著名建筑？',
          options: ['英国国家美术馆', '大英图书馆', '维多利亚和阿尔伯特博物馆', '以上都是'],
          correctAnswer: 3,
          explanation: '罗伯特·斯默克是19世纪英国著名建筑师，设计了英国国家美术馆、大英图书馆、维多利亚和阿尔伯特博物馆等多个著名建筑。',
          difficulty: 'hard'
        },
        {
          id: 53,
          type: 'judge',
          category: '藏品',
          question: '大英博物馆收藏的《罗塞塔石碑》是博物馆最重要的藏品之一。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《罗塞塔石碑》是大英博物馆最重要的藏品之一，是解读古埃及文字的关键，也是博物馆的象征。',
          difficulty: 'easy'
        },
        {
          id: 54,
          type: 'single',
          category: '历史',
          question: '大英博物馆在哪个时期开始收藏日本文物？',
          options: ['18世纪', '19世纪', '20世纪', '21世纪'],
          correctAnswer: 1,
          explanation: '大英博物馆在19世纪开始大量收藏日本文物，随着日本与西方的交流，大量日本文物被运到英国。',
          difficulty: 'hard'
        },
        {
          id: 55,
          type: 'single',
          category: '展览',
          question: '大英博物馆的"中国展厅"主要展示哪个时期的文物？',
          options: ['古代中国', '近现代中国', '各个时期', '主要是明清时期'],
          correctAnswer: 2,
          explanation: '大英博物馆的"中国展厅"展示各个时期的中国文物，从新石器时代到近现代都有涵盖。',
          difficulty: 'medium'
        }
      ]
    },
    {
      id: 'metropolitan',
      name: '大都会艺术博物馆',
      description: '关于大都会艺术博物馆的藏品知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆位于哪个城市？',
          options: ['纽约', '波士顿', '芝加哥', '洛杉矶'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆位于美国纽约市曼哈顿，是美国最大的艺术博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆成立于哪一年？',
          options: ['1870年', '1880年', '1890年', '1900年'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆成立于1870年，由一群美国公民发起，旨在为美国人民提供艺术教育。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆的著名收藏包括哪些？（多选）',
          options: ['古埃及艺术', '欧洲绘画', '亚洲艺术', '现代艺术'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏了来自世界各地的艺术品，包括古埃及艺术、欧洲绘画、亚洲艺术和现代艺术等。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '大都会艺术博物馆收藏有完整的古埃及神庙。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆收藏有完整的丹铎神庙（Temple of Dendur），这是古埃及托勒密王朝时期的神庙，于1978年正式展出。',
          difficulty: 'hard'
        },
        {
          id: 5,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆的主馆位于纽约的哪个公园附近？',
          options: ['中央公园', '高线公园', '布鲁克林大桥公园', '展望公园'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆的主馆位于纽约曼哈顿的中央公园东侧，第五大道上，是纽约的标志性建筑之一。',
          difficulty: 'medium'
        },
        {
          id: 6,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆正式对公众开放是在哪一年？',
          options: ['1872年', '1880年', '1890年', '1900年'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆于1872年2月20日正式对公众开放，最初位于第五大道681号的一栋建筑内。',
          difficulty: 'medium'
        },
        {
          id: 7,
          type: 'judge',
          category: '历史',
          question: '大都会艺术博物馆是由一群美国公民发起的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆是由一群美国公民在1870年发起的，旨在为美国人民提供艺术教育和文化资源。',
          difficulty: 'easy'
        },
        {
          id: 8,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的文物总数约为多少？',
          options: ['150万件', '200万件', '250万件', '300万件'],
          correctAnswer: 1,
          explanation: '大都会艺术博物馆收藏有超过200万件文物，涵盖从古代到现代各个时期和地区的艺术品。',
          difficulty: 'medium'
        },
        {
          id: 9,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的欧洲绘画包括哪些画家的作品？（多选）',
          options: ['梵高', '莫奈', '毕加索', '达芬奇'],
          correctAnswer: [0, 1, 2],
          explanation: '大都会艺术博物馆收藏有梵高、莫奈、毕加索等欧洲画家的作品。达芬奇的作品主要收藏在卢浮宫。',
          difficulty: 'medium'
        },
        {
          id: 10,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆现在的建筑主要建于哪个时期？',
          options: ['19世纪末', '20世纪初', '20世纪中期', '以上都是'],
          correctAnswer: 3,
          explanation: '大都会艺术博物馆的建筑经历了多个时期的扩建，从19世纪末开始，一直持续到20世纪中期。',
          difficulty: 'hard'
        },
        {
          id: 11,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的丹铎神庙来自哪个国家？',
          options: ['埃及', '希腊', '意大利', '土耳其'],
          correctAnswer: 0,
          explanation: '丹铎神庙来自埃及，是古埃及托勒密王朝时期的神庙，于1965年由埃及政府赠送给美国，现收藏在大都会艺术博物馆。',
          difficulty: 'medium'
        },
        {
          id: 12,
          type: 'judge',
          category: '藏品',
          question: '大都会艺术博物馆收藏有完整的中国古典园林。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆收藏有完整的中国古典园林"明轩"，这是按照苏州园林风格建造的。',
          difficulty: 'hard'
        },
        {
          id: 13,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆的建立者中包括哪位著名银行家？',
          options: ['J.P.摩根', '约翰·洛克菲勒', '安德鲁·卡内基', '以上都是'],
          correctAnswer: 3,
          explanation: '大都会艺术博物馆的建立和早期发展得到了J.P.摩根、约翰·洛克菲勒、安德鲁·卡内基等著名银行家和慈善家的支持。',
          difficulty: 'hard'
        },
        {
          id: 14,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的亚洲艺术包括哪些？（多选）',
          options: ['中国艺术', '日本艺术', '印度艺术', '韩国艺术'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的亚洲艺术，包括中国、日本、印度、韩国等各个国家的艺术品。',
          difficulty: 'medium'
        },
        {
          id: 15,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆的主入口位于哪条街道？',
          options: ['第五大道', '麦迪逊大道', '公园大道', '百老汇大道'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆的主入口位于第五大道，面向中央公园，是纽约最著名的文化地标之一。',
          difficulty: 'easy'
        },
        {
          id: 16,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《星月夜》是哪位画家的作品？',
          options: ['梵高', '莫奈', '毕加索', '塞尚'],
          correctAnswer: 0,
          explanation: '《星月夜》是荷兰后印象派画家梵高的作品，现收藏在大都会艺术博物馆，是博物馆最著名的藏品之一。',
          difficulty: 'medium'
        },
        {
          id: 17,
          type: 'judge',
          category: '历史',
          question: '大都会艺术博物馆是世界上参观人数最多的艺术博物馆之一。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆每年接待超过600万游客，是世界上参观人数最多的艺术博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 18,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的古埃及文物数量约为多少？',
          options: ['2.6万件', '3.6万件', '4.6万件', '5.6万件'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆收藏有约2.6万件古埃及文物，是世界上收藏古埃及文物最多的博物馆之一。',
          difficulty: 'hard'
        },
        {
          id: 19,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的美国艺术包括哪些类型？（多选）',
          options: ['绘画', '雕塑', '装饰艺术', '摄影'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的美国艺术，包括绘画、雕塑、装饰艺术、摄影等各个类型。',
          difficulty: 'medium'
        },
        {
          id: 20,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆的建筑风格主要是什么？',
          options: ['新古典主义', '哥特式', '现代主义', '折衷主义'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆的建筑风格主要是新古典主义，体现了19世纪末20世纪初美国建筑的特色。',
          difficulty: 'medium'
        },
        {
          id: 21,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《睡莲》系列是哪位画家的作品？',
          options: ['莫奈', '梵高', '毕加索', '马蒂斯'],
          correctAnswer: 0,
          explanation: '《睡莲》系列是法国印象派画家莫奈的作品，大都会艺术博物馆收藏有多幅《睡莲》系列作品。',
          difficulty: 'medium'
        },
        {
          id: 22,
          type: 'judge',
          category: '藏品',
          question: '大都会艺术博物馆收藏有完整的古埃及神庙丹铎神庙。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆收藏有完整的古埃及神庙丹铎神庙，这是博物馆最著名的藏品之一，位于专门的展厅中。',
          difficulty: 'easy'
        },
        {
          id: 23,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆在哪个时期进行了大规模扩建？',
          options: ['20世纪初', '20世纪中期', '20世纪末', '以上都是'],
          correctAnswer: 3,
          explanation: '大都会艺术博物馆在20世纪进行了多次大规模扩建，包括20世纪初、中期和末期的扩建项目。',
          difficulty: 'hard'
        },
        {
          id: 24,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的古代近东文物包括哪些？（多选）',
          options: ['美索不达米亚文物', '波斯文物', '巴比伦文物', '亚述文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的古代近东文物，包括美索不达米亚、波斯、巴比伦、亚述等各个文明的文物。',
          difficulty: 'medium'
        },
        {
          id: 25,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的中国古典园林"明轩"是按照哪个城市的园林风格建造的？',
          options: ['苏州', '杭州', '北京', '扬州'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆收藏的中国古典园林"明轩"是按照苏州园林风格建造的，是博物馆最著名的中国艺术藏品之一。',
          difficulty: 'hard'
        },
        {
          id: 26,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆的展览面积约为多少平方米？',
          options: ['15万平方米', '18万平方米', '20万平方米', '22万平方米'],
          correctAnswer: 1,
          explanation: '大都会艺术博物馆的展览面积约为18万平方米，是世界上展览面积最大的艺术博物馆之一。',
          difficulty: 'hard'
        },
        {
          id: 27,
          type: 'judge',
          category: '历史',
          question: '大都会艺术博物馆最初是作为教育机构建立的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆最初是作为教育机构建立的，旨在为美国人民提供艺术教育和文化资源。',
          difficulty: 'easy'
        },
        {
          id: 28,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《华盛顿横渡特拉华河》是哪位画家的作品？',
          options: ['伊曼纽尔·洛伊策', '约翰·辛格·萨金特', '温斯洛·霍默', '托马斯·伊肯斯'],
          correctAnswer: 0,
          explanation: '《华盛顿横渡特拉华河》是德国裔美国画家伊曼纽尔·洛伊策的作品，现收藏在大都会艺术博物馆。',
          difficulty: 'hard'
        },
        {
          id: 29,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的装饰艺术包括哪些？（多选）',
          options: ['家具', '陶瓷', '玻璃器皿', '纺织品'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的装饰艺术，包括家具、陶瓷、玻璃器皿、纺织品等各个类型。',
          difficulty: 'medium'
        },
        {
          id: 30,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆每年接待的游客数量约为多少？',
          options: ['500万人次', '600万人次', '700万人次', '800万人次'],
          correctAnswer: 1,
          explanation: '大都会艺术博物馆每年接待的游客数量超过600万人次，是世界上参观人数最多的艺术博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 31,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《舞蹈课》是哪位画家的作品？',
          options: ['德加', '雷诺阿', '马奈', '莫奈'],
          correctAnswer: 0,
          explanation: '《舞蹈课》是法国印象派画家德加的作品，现收藏在大都会艺术博物馆，是博物馆最著名的印象派作品之一。',
          difficulty: 'medium'
        },
        {
          id: 32,
          type: 'judge',
          category: '建筑',
          question: '大都会艺术博物馆的建筑采用了折衷主义风格。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆的建筑采用了折衷主义风格，融合了多种建筑元素，体现了博物馆的包容性。',
          difficulty: 'medium'
        },
        {
          id: 33,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《自画像》是哪位画家的作品？',
          options: ['梵高', '伦勃朗', '毕加索', '以上都是'],
          correctAnswer: 3,
          explanation: '大都会艺术博物馆收藏有梵高、伦勃朗、毕加索等多位画家的《自画像》作品。',
          difficulty: 'medium'
        },
        {
          id: 34,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的伊斯兰艺术包括哪些？（多选）',
          options: ['陶瓷', '纺织品', '金属工艺品', '书法作品'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的伊斯兰艺术，包括陶瓷、纺织品、金属工艺品、书法作品等各个类型。',
          difficulty: 'medium'
        },
        {
          id: 35,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆在哪个时期开始收藏现代艺术？',
          options: ['19世纪末', '20世纪初', '20世纪中期', '20世纪末'],
          correctAnswer: 1,
          explanation: '大都会艺术博物馆在20世纪初开始收藏现代艺术，建立了专门的现代艺术部门。',
          difficulty: 'hard'
        },
        {
          id: 36,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《大碗岛的星期天下午》是哪位画家的作品？',
          options: ['修拉', '塞尚', '高更', '梵高'],
          correctAnswer: 0,
          explanation: '《大碗岛的星期天下午》是法国新印象派画家修拉的作品，现收藏在大都会艺术博物馆，是点彩画的代表作。',
          difficulty: 'hard'
        },
        {
          id: 37,
          type: 'judge',
          category: '藏品',
          question: '大都会艺术博物馆收藏有完整的古埃及神庙。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆收藏有完整的古埃及神庙丹铎神庙，这是博物馆最著名的藏品之一。',
          difficulty: 'easy'
        },
        {
          id: 38,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆的"大中庭"改造完成于哪一年？',
          options: ['2000年', '2005年', '2010年', '2015年'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆的"大中庭"改造完成于2000年，增加了更多的展览空间和公共设施。',
          difficulty: 'hard'
        },
        {
          id: 39,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的非洲艺术包括哪些？（多选）',
          options: ['雕塑', '面具', '纺织品', '金属工艺品'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的非洲艺术，包括雕塑、面具、纺织品、金属工艺品等各个类型。',
          difficulty: 'medium'
        },
        {
          id: 40,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《麦田与柏树》是哪位画家的作品？',
          options: ['梵高', '莫奈', '塞尚', '高更'],
          correctAnswer: 0,
          explanation: '《麦田与柏树》是荷兰后印象派画家梵高的作品，现收藏在大都会艺术博物馆。',
          difficulty: 'medium'
        },
        {
          id: 41,
          type: 'single',
          category: '历史',
          question: '大都会艺术博物馆的分馆"修道院博物馆"位于哪里？',
          options: ['曼哈顿上城', '布鲁克林', '皇后区', '布朗克斯'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆的分馆"修道院博物馆"位于曼哈顿上城的特赖恩堡公园，专门展示中世纪艺术。',
          difficulty: 'hard'
        },
        {
          id: 42,
          type: 'judge',
          category: '藏品',
          question: '大都会艺术博物馆收藏有完整的中国古典园林。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆收藏有完整的中国古典园林"明轩"，这是按照苏州园林风格建造的。',
          difficulty: 'easy'
        },
        {
          id: 43,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《圣母与圣婴》是哪位画家的作品？',
          options: ['达芬奇', '拉斐尔', '米开朗基罗', '提香'],
          correctAnswer: 1,
          explanation: '大都会艺术博物馆收藏有拉斐尔的《圣母与圣婴》作品，是博物馆最著名的文艺复兴作品之一。',
          difficulty: 'medium'
        },
        {
          id: 44,
          type: 'multiple',
          category: '藏品',
          question: '大都会艺术博物馆收藏的古代希腊和罗马艺术包括哪些？（多选）',
          options: ['雕塑', '陶器', '珠宝', '钱币'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '大都会艺术博物馆收藏有丰富的古代希腊和罗马艺术，包括雕塑、陶器、珠宝、钱币等各个类型。',
          difficulty: 'medium'
        },
        {
          id: 45,
          type: 'single',
          category: '建筑',
          question: '大都会艺术博物馆的建筑设计师包括哪位？',
          options: ['理查德·莫里斯·亨特', '卡尔弗特·沃克斯', '弗雷德里克·劳·奥姆斯特德', '以上都是'],
          correctAnswer: 0,
          explanation: '大都会艺术博物馆的建筑设计师包括理查德·莫里斯·亨特，他设计了博物馆的主要建筑。',
          difficulty: 'hard'
        },
        {
          id: 46,
          type: 'judge',
          category: '历史',
          question: '大都会艺术博物馆是世界上最大的艺术博物馆之一。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。大都会艺术博物馆是世界上最大的艺术博物馆之一，收藏有超过200万件文物，展览面积约18万平方米。',
          difficulty: 'easy'
        },
        {
          id: 47,
          type: 'single',
          category: '藏品',
          question: '大都会艺术博物馆收藏的《自画像与草帽》是哪位画家的作品？',
          options: ['梵高', '伦勃朗', '毕加索', '马蒂斯'],
          correctAnswer: 0,
          explanation: '《自画像与草帽》是荷兰后印象派画家梵高的作品，现收藏在大都会艺术博物馆。',
          difficulty: 'medium'
        }
      ]
    },
    {
      id: 'hermitage',
      name: '艾尔米塔什博物馆',
      description: '关于艾尔米塔什博物馆的艺术品和历史文化',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '艾尔米塔什博物馆位于哪个城市？',
          options: ['莫斯科', '圣彼得堡', '基辅', '明斯克'],
          correctAnswer: 1,
          explanation: '艾尔米塔什博物馆位于俄罗斯圣彼得堡，前身为沙皇冬宫，是世界四大博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '艾尔米塔什博物馆最初是什么建筑？',
          options: ['教堂', '沙皇冬宫', '剧院', '图书馆'],
          correctAnswer: 1,
          explanation: '艾尔米塔什博物馆最初是沙皇的冬宫，由叶卡捷琳娜二世女皇于1764年建立。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '艾尔米塔什博物馆的著名收藏包括哪些？（多选）',
          options: ['印象派绘画', '古埃及文物', '文艺复兴艺术品', '中国古代文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '艾尔米塔什博物馆收藏有印象派绘画、古埃及文物、文艺复兴艺术品和中国古代文物等，藏品超过300万件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '艾尔米塔什博物馆是世界四大博物馆之一。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。艾尔米塔什博物馆与卢浮宫、大英博物馆、大都会艺术博物馆并称为世界四大博物馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '艾尔米塔什博物馆收藏的《达娜厄》是哪位画家的作品？',
          options: ['伦勃朗', '提香', '鲁本斯', '维米尔'],
          correctAnswer: 0,
          explanation: '《达娜厄》是荷兰画家伦勃朗的作品，是艾尔米塔什博物馆的重要藏品之一。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'tokyo_national',
      name: '东京国立博物馆',
      description: '关于东京国立博物馆的文物和艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '东京国立博物馆成立于哪一年？',
          options: ['1872年', '1882年', '1892年', '1902年'],
          correctAnswer: 0,
          explanation: '东京国立博物馆成立于1872年，是日本历史最悠久的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '东京国立博物馆收藏有多少件国宝？',
          options: ['87件', '100件', '150件', '200件'],
          correctAnswer: 0,
          explanation: '东京国立博物馆收藏有87件国宝，是日本收藏国宝最多的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '东京国立博物馆的主要收藏包括哪些？（多选）',
          options: ['日本古代文物', '中国文物', '朝鲜文物', '东南亚文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '东京国立博物馆收藏有日本古代文物、中国文物、朝鲜文物和东南亚文物等，是研究亚洲艺术的重要机构。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '东京国立博物馆是日本最大的博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。东京国立博物馆是日本最大的博物馆，收藏有11万件文物。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '东京国立博物馆收藏的《松林图屏风》是哪位画家的作品？',
          options: ['长谷川等伯', '狩野永德', '雪舟', '俵屋宗达'],
          correctAnswer: 0,
          explanation: '《松林图屏风》是日本安土桃山时代的画家长谷川等伯的作品，是东京国立博物馆的国宝级藏品。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'shanghai_museum',
      name: '上海博物馆',
      description: '关于上海博物馆的古代艺术品知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '上海博物馆成立于哪一年？',
          options: ['1952年', '1960年', '1970年', '1980年'],
          correctAnswer: 0,
          explanation: '上海博物馆成立于1952年，是中国重要的古代艺术博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '上海博物馆以收藏哪类文物而闻名？',
          options: ['青铜器', '玉器', '陶瓷', '以上都是'],
          correctAnswer: 3,
          explanation: '上海博物馆以收藏中国古代青铜器、陶瓷、书画、玉器而闻名，馆藏文物超过100万件。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '上海博物馆的著名收藏包括哪些？（多选）',
          options: ['大克鼎', '晋侯苏钟', '商鞅方升', '《高逸图》'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '上海博物馆收藏有大克鼎、晋侯苏钟、商鞅方升、《高逸图》等珍贵文物，其中珍贵文物14万件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '建筑',
          question: '上海博物馆的建筑外形设计灵感来源于中国古代的青铜器。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。上海博物馆的建筑外形设计灵感来源于中国古代的青铜器，体现了"天圆地方"的哲学思想。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '上海博物馆收藏的《高逸图》是哪个朝代的作品？',
          options: ['唐代', '宋代', '元代', '明代'],
          correctAnswer: 0,
          explanation: '《高逸图》是唐代画家孙位的作品，描绘了竹林七贤中的四位人物，是上海博物馆的重要藏品。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'vatican_museums',
      name: '梵蒂冈博物馆',
      description: '关于梵蒂冈博物馆的艺术品和历史文化',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '梵蒂冈博物馆位于哪个国家？',
          options: ['意大利', '梵蒂冈', '法国', '西班牙'],
          correctAnswer: 1,
          explanation: '梵蒂冈博物馆位于梵蒂冈城内，是世界上最小的国家，但拥有世界级的艺术收藏。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '梵蒂冈博物馆最著名的艺术品是什么？',
          options: ['《最后的审判》', '《创世纪》', '《西斯廷圣母》', '以上都是'],
          correctAnswer: 3,
          explanation: '梵蒂冈博物馆收藏有米开朗基罗的《最后的审判》和《创世纪》壁画，以及拉斐尔的《西斯廷圣母》等世界名作。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '梵蒂冈博物馆的著名收藏包括哪些？（多选）',
          options: ['拉斐尔房间', '西斯廷教堂', '古代雕塑', '埃及文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '梵蒂冈博物馆收藏有拉斐尔房间的壁画、西斯廷教堂的米开朗基罗作品、古代雕塑和埃及文物等。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '西斯廷教堂的《创世纪》天顶画是米开朗基罗独自完成的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。米开朗基罗在1508-1512年间独自完成了西斯廷教堂天顶的《创世纪》壁画，这是艺术史上的杰作。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '梵蒂冈博物馆收藏的《拉奥孔群雕》是哪个时期的作品？',
          options: ['古希腊', '古罗马', '文艺复兴', '巴洛克'],
          correctAnswer: 0,
          explanation: '《拉奥孔群雕》是古希腊时期的雕塑作品，约创作于公元前1世纪，是梵蒂冈博物馆的重要藏品。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'prado',
      name: '普拉多博物馆',
      description: '关于普拉多博物馆的西班牙艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '普拉多博物馆位于哪个城市？',
          options: ['马德里', '巴塞罗那', '塞维利亚', '瓦伦西亚'],
          correctAnswer: 0,
          explanation: '普拉多博物馆位于西班牙首都马德里，是西班牙最重要的艺术博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '普拉多博物馆成立于哪一年？',
          options: ['1819年', '1829年', '1839年', '1849年'],
          correctAnswer: 0,
          explanation: '普拉多博物馆成立于1819年，最初是作为皇家绘画和雕塑博物馆对外开放的。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '普拉多博物馆收藏的著名画家包括哪些？（多选）',
          options: ['戈雅', '委拉斯开兹', '埃尔·格列柯', '提香'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '普拉多博物馆收藏有戈雅、委拉斯开兹、埃尔·格列柯、提香等大师的作品，是研究西班牙黄金时代艺术的重要场所。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '普拉多博物馆收藏有委拉斯开兹的《宫娥》。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《宫娥》是西班牙画家委拉斯开兹的代表作，现藏于普拉多博物馆，是西班牙艺术的杰作。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '普拉多博物馆收藏的《1808年5月3日》是哪位画家的作品？',
          options: ['戈雅', '委拉斯开兹', '埃尔·格列柯', '穆里略'],
          correctAnswer: 0,
          explanation: '《1808年5月3日》是西班牙画家戈雅的作品，描绘了西班牙人民反抗拿破仑军队的场景，是普拉多博物馆的重要藏品。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'uffizi',
      name: '乌菲兹美术馆',
      description: '关于乌菲兹美术馆的文艺复兴艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '乌菲兹美术馆位于哪个城市？',
          options: ['罗马', '佛罗伦萨', '威尼斯', '米兰'],
          correctAnswer: 1,
          explanation: '乌菲兹美术馆位于意大利佛罗伦萨，是意大利最著名的艺术博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '乌菲兹美术馆最初是什么建筑？',
          options: ['教堂', '市政厅', '美第奇家族的办公大楼', '剧院'],
          correctAnswer: 2,
          explanation: '乌菲兹美术馆最初是美第奇家族的办公大楼（Uffizi在意大利语中意为"办公室"），建于1560-1581年。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '乌菲兹美术馆收藏的著名画家包括哪些？（多选）',
          options: ['波提切利', '达·芬奇', '拉斐尔', '米开朗基罗'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '乌菲兹美术馆收藏有波提切利、达·芬奇、拉斐尔、米开朗基罗等文艺复兴大师的作品，是文艺复兴艺术的宝库。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '乌菲兹美术馆收藏有波提切利的《维纳斯的诞生》。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《维纳斯的诞生》是意大利文艺复兴时期画家波提切利的代表作，现藏于乌菲兹美术馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '乌菲兹美术馆收藏的《春》是哪位画家的作品？',
          options: ['波提切利', '达·芬奇', '拉斐尔', '提香'],
          correctAnswer: 0,
          explanation: '《春》是意大利文艺复兴时期画家波提切利的作品，与《维纳斯的诞生》一起，是乌菲兹美术馆的镇馆之宝。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'egyptian_museum',
      name: '埃及博物馆',
      description: '关于埃及博物馆的古埃及文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '埃及博物馆位于哪个城市？',
          options: ['开罗', '亚历山大', '卢克索', '阿斯旺'],
          correctAnswer: 0,
          explanation: '埃及博物馆位于埃及首都开罗，是世界上收藏古埃及文物最丰富的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '埃及博物馆最著名的藏品是什么？',
          options: ['图坦卡蒙黄金面具', '罗塞塔石碑', '拉美西斯二世雕像', '纳芙蒂蒂半身像'],
          correctAnswer: 0,
          explanation: '图坦卡蒙黄金面具是埃及博物馆最著名的藏品，是古埃及艺术的代表作。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '埃及博物馆收藏的著名文物包括哪些？（多选）',
          options: ['图坦卡蒙黄金面具', '图坦卡蒙木乃伊', '纳芙蒂蒂半身像', '拉美西斯二世雕像'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '埃及博物馆收藏有图坦卡蒙黄金面具、图坦卡蒙木乃伊、纳芙蒂蒂半身像、拉美西斯二世雕像等珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '图坦卡蒙的陵墓是在1922年被发现的。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。1922年，英国考古学家霍华德·卡特在帝王谷发现了图坦卡蒙的陵墓，这是20世纪最重要的考古发现之一。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '图坦卡蒙黄金面具是哪个朝代的文物？',
          options: ['古王国时期', '中王国时期', '新王国时期', '托勒密王朝'],
          correctAnswer: 2,
          explanation: '图坦卡蒙黄金面具是古埃及新王国时期（约公元前1323年）的文物，是古埃及艺术的巅峰之作。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'guggenheim',
      name: '古根海姆博物馆',
      description: '关于古根海姆博物馆的现代艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '古根海姆博物馆位于哪个城市？',
          options: ['纽约', '洛杉矶', '芝加哥', '波士顿'],
          correctAnswer: 0,
          explanation: '古根海姆博物馆位于美国纽约，是世界上最著名的现代艺术博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '建筑',
          question: '纽约古根海姆博物馆的建筑是由哪位建筑师设计的？',
          options: ['弗兰克·劳埃德·赖特', '勒·柯布西耶', '密斯·凡·德·罗', '路易斯·康'],
          correctAnswer: 0,
          explanation: '纽约古根海姆博物馆的建筑是由美国建筑师弗兰克·劳埃德·赖特设计的，其螺旋形设计是建筑艺术的杰作。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '古根海姆博物馆收藏的著名艺术家包括哪些？（多选）',
          options: ['康定斯基', '毕加索', '蒙德里安', '波洛克'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '古根海姆博物馆收藏有康定斯基、毕加索、蒙德里安、波洛克等现代艺术大师的作品。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '建筑',
          question: '古根海姆博物馆的建筑采用螺旋形设计，参观者可以沿着螺旋坡道欣赏艺术品。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。古根海姆博物馆采用螺旋形设计，参观者可以沿着连续的螺旋坡道从底层一直走到顶层，这是赖特的创新设计。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '历史',
          question: '古根海姆博物馆成立于哪一年？',
          options: ['1937年', '1947年', '1957年', '1967年'],
          correctAnswer: 0,
          explanation: '古根海姆博物馆成立于1937年，由所罗门·R·古根海姆基金会建立，致力于收藏和展示现代艺术。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'tate_modern',
      name: '泰特现代美术馆',
      description: '关于泰特现代美术馆的现代艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '泰特现代美术馆位于哪个城市？',
          options: ['伦敦', '曼彻斯特', '爱丁堡', '利物浦'],
          correctAnswer: 0,
          explanation: '泰特现代美术馆位于英国伦敦泰晤士河畔，是英国最重要的现代艺术博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '建筑',
          question: '泰特现代美术馆的前身是什么建筑？',
          options: ['发电站', '火车站', '工厂', '仓库'],
          correctAnswer: 0,
          explanation: '泰特现代美术馆的前身是班克赛德发电站，由瑞士建筑师赫尔佐格和德梅隆改造设计。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '泰特现代美术馆收藏的著名艺术家包括哪些？（多选）',
          options: ['毕加索', '达利', '安迪·沃霍尔', '草间弥生'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '泰特现代美术馆收藏有毕加索、达利、安迪·沃霍尔、草间弥生等现代艺术大师的作品。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '泰特现代美术馆于2000年正式对外开放。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。泰特现代美术馆于2000年5月正式对外开放，是世界上参观人数最多的现代艺术博物馆之一。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '建筑',
          question: '泰特现代美术馆的改造设计是由哪两位建筑师完成的？',
          options: ['赫尔佐格和德梅隆', '诺曼·福斯特', '扎哈·哈迪德', '伦佐·皮亚诺'],
          correctAnswer: 0,
          explanation: '泰特现代美术馆的改造设计是由瑞士建筑师雅克·赫尔佐格和皮埃尔·德梅隆完成的，他们将发电站改造成了现代艺术博物馆。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'orsay',
      name: '奥赛博物馆',
      description: '关于奥赛博物馆的印象派艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '奥赛博物馆位于哪个城市？',
          options: ['巴黎', '里昂', '马赛', '波尔多'],
          correctAnswer: 0,
          explanation: '奥赛博物馆位于法国巴黎，是专门收藏19世纪艺术作品的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '建筑',
          question: '奥赛博物馆的前身是什么建筑？',
          options: ['火车站', '剧院', '工厂', '仓库'],
          correctAnswer: 0,
          explanation: '奥赛博物馆的前身是奥赛火车站，建于1900年，1986年被改造成博物馆。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '奥赛博物馆收藏的著名画家包括哪些？（多选）',
          options: ['莫奈', '梵高', '雷诺阿', '德加'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '奥赛博物馆收藏有莫奈、梵高、雷诺阿、德加等印象派和后印象派大师的作品，是研究19世纪艺术的重要机构。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '奥赛博物馆收藏有梵高的《星夜》。',
          options: ['正确', '错误'],
          correctAnswer: 1,
          explanation: '错误。《星夜》现藏于纽约现代艺术博物馆。奥赛博物馆收藏有梵高的其他作品，如《自画像》等。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '奥赛博物馆收藏的《睡莲》系列是哪位画家的作品？',
          options: ['莫奈', '梵高', '雷诺阿', '塞尚'],
          correctAnswer: 0,
          explanation: '《睡莲》系列是法国印象派画家克劳德·莫奈的作品，奥赛博物馆收藏有部分《睡莲》作品。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'chicago_art',
      name: '芝加哥艺术博物馆',
      description: '关于芝加哥艺术博物馆的艺术品知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '芝加哥艺术博物馆成立于哪一年？',
          options: ['1879年', '1889年', '1899年', '1909年'],
          correctAnswer: 0,
          explanation: '芝加哥艺术博物馆成立于1879年，是美国重要的艺术博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '芝加哥艺术博物馆最著名的藏品是什么？',
          options: ['《美国哥特式》', '《夜巡》', '《星夜》', '《睡莲》'],
          correctAnswer: 0,
          explanation: '《美国哥特式》是美国画家格兰特·伍德的作品，是芝加哥艺术博物馆最著名的藏品之一。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '芝加哥艺术博物馆收藏的著名艺术家包括哪些？（多选）',
          options: ['格兰特·伍德', '爱德华·霍珀', '乔治·修拉', '文森特·梵高'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '芝加哥艺术博物馆收藏有格兰特·伍德、爱德华·霍珀、乔治·修拉、文森特·梵高等艺术家的作品。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '芝加哥艺术博物馆收藏有修拉的《大碗岛的星期天下午》。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《大碗岛的星期天下午》是法国点彩派画家乔治·修拉的代表作，现藏于芝加哥艺术博物馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '建筑',
          question: '芝加哥艺术博物馆的建筑风格主要是什么？',
          options: ['新古典主义', '现代主义', '后现代主义', '哥特式'],
          correctAnswer: 0,
          explanation: '芝加哥艺术博物馆的建筑采用新古典主义风格，由建筑师谢普利、鲁坦和库利奇设计。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'berlin_state',
      name: '柏林国家博物馆',
      description: '关于柏林国家博物馆的欧洲艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '柏林国家博物馆群由多少个博物馆组成？',
          options: ['10个', '15个', '20个', '25个'],
          correctAnswer: 1,
          explanation: '柏林国家博物馆群由15个博物馆和4个研究所组成，分布在柏林市的多个区域。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '柏林国家博物馆群的核心是什么？',
          options: ['博物馆岛', '波茨坦广场', '勃兰登堡门', '国会大厦'],
          correctAnswer: 0,
          explanation: '柏林国家博物馆群的核心是"博物馆岛"，是世界文化遗产，包括5座博物馆。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '柏林国家博物馆的著名收藏包括哪些？（多选）',
          options: ['纳芙蒂蒂半身像', '佩加蒙祭坛', '伊什塔尔门', '古希腊雕塑'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '柏林国家博物馆收藏有纳芙蒂蒂半身像、佩加蒙祭坛、伊什塔尔门、古希腊雕塑等珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '柏林博物馆岛是世界文化遗产。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。柏林博物馆岛于1999年被联合国教科文组织列入《世界文化遗产名录》。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '纳芙蒂蒂半身像收藏在柏林国家博物馆的哪个分馆？',
          options: ['新博物馆', '老博物馆', '佩加蒙博物馆', '博德博物馆'],
          correctAnswer: 0,
          explanation: '纳芙蒂蒂半身像收藏在柏林国家博物馆群的新博物馆（Neues Museum），是古埃及艺术的杰作。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'rijksmuseum',
      name: '阿姆斯特丹国家博物馆',
      description: '关于阿姆斯特丹国家博物馆的荷兰艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '阿姆斯特丹国家博物馆成立于哪一年？',
          options: ['1800年', '1808年', '1815年', '1820年'],
          correctAnswer: 0,
          explanation: '阿姆斯特丹国家博物馆成立于1800年，是荷兰最大的国家博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '阿姆斯特丹国家博物馆最著名的藏品是什么？',
          options: ['《夜巡》', '《倒牛奶的女仆》', '《戴珍珠耳环的少女》', '《向日葵》'],
          correctAnswer: 0,
          explanation: '《夜巡》是荷兰画家伦勃朗的代表作，是阿姆斯特丹国家博物馆的镇馆之宝。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '阿姆斯特丹国家博物馆收藏的著名画家包括哪些？（多选）',
          options: ['伦勃朗', '维米尔', '弗兰斯·哈尔斯', '扬·维米尔'],
          correctAnswer: [0, 1, 2],
          explanation: '阿姆斯特丹国家博物馆收藏有伦勃朗、维米尔、弗兰斯·哈尔斯等荷兰黄金时代大师的作品。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '阿姆斯特丹国家博物馆收藏有维米尔的《倒牛奶的女仆》。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。《倒牛奶的女仆》是荷兰画家维米尔的作品，现藏于阿姆斯特丹国家博物馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '历史',
          question: '《夜巡》最初是为哪个组织创作的？',
          options: ['阿姆斯特丹民兵连队', '荷兰海军', '荷兰王室', '阿姆斯特丹市政府'],
          correctAnswer: 0,
          explanation: '《夜巡》是伦勃朗受阿姆斯特丹民兵连队委托创作的，描绘了连队出巡的场景，是巴洛克艺术的杰作。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'seoul_national',
      name: '首尔国立中央博物馆',
      description: '关于首尔国立中央博物馆的韩国文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '首尔国立中央博物馆成立于哪一年？',
          options: ['1945年', '1950年', '1955年', '1960年'],
          correctAnswer: 0,
          explanation: '首尔国立中央博物馆成立于1945年，是韩国最大的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '首尔国立中央博物馆收藏有多少件文物？',
          options: ['超过31万件', '超过50万件', '超过100万件', '超过200万件'],
          correctAnswer: 0,
          explanation: '首尔国立中央博物馆收藏有超过31万件文物，涵盖了从史前到近代的韩国历史和文化。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '首尔国立中央博物馆的著名收藏包括哪些？（多选）',
          options: ['高丽青瓷', '新罗金冠', '百济金铜大香炉', '朝鲜王朝文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '首尔国立中央博物馆收藏有高丽青瓷、新罗金冠、百济金铜大香炉、朝鲜王朝文物等珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '首尔国立中央博物馆是研究韩国文明的重要机构。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。首尔国立中央博物馆收藏了大量韩国和亚洲的文物和艺术品，是研究韩国文明的重要机构。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '新罗金冠是哪个朝代的文物？',
          options: ['新罗王朝', '高丽王朝', '百济王朝', '朝鲜王朝'],
          correctAnswer: 0,
          explanation: '新罗金冠是新罗王朝（公元前57年-935年）的文物，是韩国古代工艺的杰作，现藏于首尔国立中央博物馆。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'india_national',
      name: '印度国家博物馆',
      description: '关于印度国家博物馆的印度文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '印度国家博物馆位于哪个城市？',
          options: ['新德里', '孟买', '加尔各答', '班加罗尔'],
          correctAnswer: 0,
          explanation: '印度国家博物馆位于印度首都新德里，是印度最大的博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '印度国家博物馆成立于哪一年？',
          options: ['1949年', '1959年', '1969年', '1979年'],
          correctAnswer: 0,
          explanation: '印度国家博物馆成立于1949年，是研究印度文明的重要机构。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '印度国家博物馆的著名收藏包括哪些？（多选）',
          options: ['哈拉帕文明文物', '佛教雕塑', '莫卧儿细密画', '印度教雕塑'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '印度国家博物馆收藏有哈拉帕文明文物、佛教雕塑、莫卧儿细密画、印度教雕塑等珍贵文物，收藏超过20万件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '印度国家博物馆收藏有大量古代钱币。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。印度国家博物馆收藏有大量古代钱币，是研究印度经济史的重要资料。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '哈拉帕文明是哪个时期的印度文明？',
          options: ['公元前2500-1900年', '公元前1500-1000年', '公元前1000-500年', '公元前500-200年'],
          correctAnswer: 0,
          explanation: '哈拉帕文明是印度河流域的古代文明，存在于约公元前2500-1900年，是印度最早的文明之一。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'brazil_national',
      name: '巴西国家博物馆',
      description: '关于巴西国家博物馆的自然历史和人类学知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '巴西国家博物馆位于哪个城市？',
          options: ['里约热内卢', '圣保罗', '巴西利亚', '萨尔瓦多'],
          correctAnswer: 0,
          explanation: '巴西国家博物馆位于里约热内卢，是巴西历史最悠久的科学机构之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '巴西国家博物馆成立于哪一年？',
          options: ['1818年', '1828年', '1838年', '1848年'],
          correctAnswer: 0,
          explanation: '巴西国家博物馆成立于1818年，最初是作为自然历史博物馆建立的。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '巴西国家博物馆的著名收藏包括哪些？（多选）',
          options: ['古生物化石', '印第安文物', '古埃及木乃伊', '陨石'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '巴西国家博物馆收藏有古生物化石、印第安文物、古埃及木乃伊、陨石等，收藏超过2000万件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '巴西国家博物馆收藏有美洲最古老的人类化石"卢西亚"。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。巴西国家博物馆收藏有"卢西亚"（Luzia），这是美洲最古老的人类化石，距今约1.2万年。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '历史',
          question: '巴西国家博物馆在2018年发生了什么重大事件？',
          options: ['火灾', '扩建', '搬迁', '关闭'],
          correctAnswer: 0,
          explanation: '2018年9月，巴西国家博物馆发生严重火灾，大部分藏品被毁，这是世界文化遗产的重大损失。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'mexico_anthropology',
      name: '墨西哥国家人类学博物馆',
      description: '关于墨西哥国家人类学博物馆的中美洲文明知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '墨西哥国家人类学博物馆位于哪个城市？',
          options: ['墨西哥城', '瓜达拉哈拉', '蒙特雷', '普埃布拉'],
          correctAnswer: 0,
          explanation: '墨西哥国家人类学博物馆位于墨西哥首都墨西哥城，是墨西哥最大、最著名的博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '墨西哥国家人类学博物馆成立于哪一年？',
          options: ['1964年', '1974年', '1984年', '1994年'],
          correctAnswer: 0,
          explanation: '墨西哥国家人类学博物馆成立于1964年，是研究中美洲文明的重要机构。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '墨西哥国家人类学博物馆的著名收藏包括哪些？（多选）',
          options: ['阿兹特克太阳石', '玛雅文物', '奥尔梅克巨石头像', '特奥蒂瓦坎文物'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '墨西哥国家人类学博物馆收藏有阿兹特克太阳石、玛雅文物、奥尔梅克巨石头像、特奥蒂瓦坎文物等，收藏超过60万件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '阿兹特克太阳石是墨西哥国家人类学博物馆的镇馆之宝。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。阿兹特克太阳石（日历石）是阿兹特克文明的重要文物，是墨西哥国家人类学博物馆的镇馆之宝。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '奥尔梅克文明是哪个时期的中美洲文明？',
          options: ['公元前1200-400年', '公元前400-200年', '公元前200-公元200年', '公元200-600年'],
          correctAnswer: 0,
          explanation: '奥尔梅克文明是公元前1200-400年的中美洲文明，被认为是中美洲文明的"母文化"，其巨石头像是重要文物。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'australia_national',
      name: '澳大利亚国家博物馆',
      description: '关于澳大利亚国家博物馆的原住民文化知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '澳大利亚国家博物馆位于哪个城市？',
          options: ['堪培拉', '悉尼', '墨尔本', '布里斯班'],
          correctAnswer: 0,
          explanation: '澳大利亚国家博物馆位于澳大利亚首都堪培拉，是澳大利亚最重要的博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '澳大利亚国家博物馆成立于哪一年？',
          options: ['1980年', '1990年', '2000年', '2010年'],
          correctAnswer: 0,
          explanation: '澳大利亚国家博物馆成立于1980年，展现了澳大利亚独特的历史、文化和自然环境。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '澳大利亚国家博物馆的著名收藏包括哪些？（多选）',
          options: ['原住民艺术品', '霍恩斯比号蒸汽机车', '澳大利亚历史文物', '自然历史标本'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '澳大利亚国家博物馆收藏有原住民艺术品、霍恩斯比号蒸汽机车、澳大利亚历史文物、自然历史标本等，收藏超过20万件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '澳大利亚国家博物馆重点展示原住民文化。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。澳大利亚国家博物馆重点展示原住民文化、殖民时期文物和自然历史，是了解澳大利亚文化的重要场所。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '澳大利亚原住民艺术的历史可以追溯到多少年前？',
          options: ['超过4万年', '超过3万年', '超过2万年', '超过1万年'],
          correctAnswer: 0,
          explanation: '澳大利亚原住民艺术的历史可以追溯到超过4万年前，是世界上现存最古老的艺术传统之一。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'cape_town_museum',
      name: '开普敦南非博物馆',
      description: '关于开普敦南非博物馆的非洲文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '开普敦南非博物馆成立于哪一年？',
          options: ['1825年', '1835年', '1845年', '1855年'],
          correctAnswer: 0,
          explanation: '开普敦南非博物馆成立于1825年，是南非历史最悠久的博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '开普敦南非博物馆收藏有多少件藏品？',
          options: ['超过150万件', '超过200万件', '超过300万件', '超过400万件'],
          correctAnswer: 0,
          explanation: '开普敦南非博物馆收藏有超过150万件藏品，包括自然历史和人类学标本。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '开普敦南非博物馆的著名收藏包括哪些？（多选）',
          options: ['布隆伯斯洞穴文物', '古人类化石', '非洲岩画', '海洋生物标本'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '开普敦南非博物馆收藏有布隆伯斯洞穴文物、古人类化石、非洲岩画、海洋生物标本等珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '开普敦南非博物馆是研究非洲文明和自然历史的重要机构。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。开普敦南非博物馆收藏了大量自然历史和人类学标本，是研究非洲文明和自然历史的重要机构。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '布隆伯斯洞穴位于哪个国家？',
          options: ['南非', '肯尼亚', '坦桑尼亚', '埃塞俄比亚'],
          correctAnswer: 0,
          explanation: '布隆伯斯洞穴位于南非，是重要的考古遗址，发现了早期人类的工具和艺术品，距今约7.7万年。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'shaanxi_history',
      name: '陕西历史博物馆',
      description: '关于陕西历史博物馆的中国古代文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '陕西历史博物馆位于哪个城市？',
          options: ['西安', '咸阳', '宝鸡', '延安'],
          correctAnswer: 0,
          explanation: '陕西历史博物馆位于中国古都西安，是中国第一座大型现代化国家级博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '陕西历史博物馆成立于哪一年？',
          options: ['1991年', '1995年', '2000年', '2005年'],
          correctAnswer: 0,
          explanation: '陕西历史博物馆成立于1991年，馆藏文物达37万余件。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '陕西历史博物馆的著名收藏包括哪些？（多选）',
          options: ['镶金兽首玛瑙杯', '舞马衔杯纹银壶', '杜虎符', '皇后之玺'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '陕西历史博物馆收藏有镶金兽首玛瑙杯、舞马衔杯纹银壶、杜虎符、皇后之玺等珍贵文物，馆藏文物37万余件。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '陕西历史博物馆收藏的文物时间跨度长达一百多万年。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。陕西历史博物馆馆藏文物上起远古人类初始阶段使用的简单石器，下至1840年前社会生活中的各类器物，时间跨度长达一百多万年。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '镶金兽首玛瑙杯是哪个朝代的文物？',
          options: ['唐代', '汉代', '秦代', '周代'],
          correctAnswer: 0,
          explanation: '镶金兽首玛瑙杯是唐代的文物，是陕西历史博物馆的镇馆之宝之一，展现了唐代精湛的工艺水平。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'nanjing_museum',
      name: '南京博物院',
      description: '关于南京博物院的中国文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '南京博物院成立于哪一年？',
          options: ['1933年', '1943年', '1953年', '1963年'],
          correctAnswer: 0,
          explanation: '南京博物院成立于1933年，是中国创建最早的博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '南京博物院收藏有多少件文物？',
          options: ['超过43万件', '超过50万件', '超过60万件', '超过70万件'],
          correctAnswer: 0,
          explanation: '南京博物院收藏有超过43万件文物，是中国第二大博物馆。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '南京博物院的著名收藏包括哪些？（多选）',
          options: ['金兽', '广陵王玺', '竹林七贤与荣启期砖画', '青瓷莲花尊'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '南京博物院收藏有金兽、广陵王玺、竹林七贤与荣启期砖画、青瓷莲花尊等珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '南京博物院是中国大型综合性历史艺术博物馆。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。南京博物院是中国大型综合性历史艺术博物馆，馆藏文物涵盖了从史前到近现代的各类珍贵文物。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '《竹林七贤与荣启期砖画》是哪个朝代的文物？',
          options: ['南朝', '北朝', '唐代', '宋代'],
          correctAnswer: 0,
          explanation: '《竹林七贤与荣启期砖画》是南朝的文物，是南京博物院的国宝级藏品，展现了魏晋时期的文化风貌。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'taipei_palace',
      name: '台北故宫博物院',
      description: '关于台北故宫博物院的中华文物知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '台北故宫博物院成立于哪一年？',
          options: ['1965年', '1975年', '1985年', '1995年'],
          correctAnswer: 0,
          explanation: '台北故宫博物院成立于1965年，位于台北市士林区。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '台北故宫博物院收藏有多少件文物？',
          options: ['近70万件', '近80万件', '近90万件', '近100万件'],
          correctAnswer: 0,
          explanation: '台北故宫博物院收藏了近70万件中华文物，大部分是原北京故宫博物院、南京国立中央博物院筹备处和热河、沈阳两行宫的旧藏。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '台北故宫博物院的著名收藏包括哪些？（多选）',
          options: ['翠玉白菜', '肉形石', '毛公鼎', '散氏盘'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '台北故宫博物院收藏有翠玉白菜、肉形石、毛公鼎、散氏盘等珍贵文物，是中华民族的文化瑰宝。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '台北故宫博物院收藏有《富春山居图》的《无用师卷》。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。台北故宫博物院收藏有《富春山居图》的《无用师卷》，前半段《剩山图》现藏于浙江省博物馆。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '翠玉白菜是哪个朝代的文物？',
          options: ['清代', '明代', '元代', '宋代'],
          correctAnswer: 0,
          explanation: '翠玉白菜是清代的文物，是台北故宫博物院最著名的藏品之一，以其精湛的雕刻工艺而闻名。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'vam',
      name: '维多利亚与阿尔伯特博物馆',
      description: '关于维多利亚与阿尔伯特博物馆的装饰艺术知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '维多利亚与阿尔伯特博物馆位于哪个城市？',
          options: ['伦敦', '曼彻斯特', '爱丁堡', '利物浦'],
          correctAnswer: 0,
          explanation: '维多利亚与阿尔伯特博物馆位于英国伦敦，是世界领先的艺术、设计和表演博物馆。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '历史',
          question: '维多利亚与阿尔伯特博物馆成立于哪一年？',
          options: ['1852年', '1862年', '1872年', '1882年'],
          correctAnswer: 0,
          explanation: '维多利亚与阿尔伯特博物馆成立于1852年，是全球最大的装饰艺术和设计博物馆。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '维多利亚与阿尔伯特博物馆的著名收藏包括哪些？（多选）',
          options: ['拉斐尔漫画', '蒂森雕塑', '时尚展品', '珠宝收藏'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '维多利亚与阿尔伯特博物馆收藏有拉斐尔漫画、蒂森雕塑、时尚展品、珠宝收藏等，收藏超过230万件物品。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '历史',
          question: '维多利亚与阿尔伯特博物馆涵盖了5000年的艺术和设计历史。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。维多利亚与阿尔伯特博物馆收藏了超过230万件物品，涵盖了5000年的艺术和设计历史。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '拉斐尔漫画是哪个时期的作品？',
          options: ['文艺复兴时期', '巴洛克时期', '新古典主义时期', '浪漫主义时期'],
          correctAnswer: 0,
          explanation: '拉斐尔漫画是意大利文艺复兴时期画家拉斐尔的作品，是维多利亚与阿尔伯特博物馆的重要藏品。',
          difficulty: 'hard'
        }
      ]
    },
    {
      id: 'boston_mfa',
      name: '波士顿美术博物馆',
      description: '关于波士顿美术博物馆的艺术品知识',
      questions: [
        {
          id: 1,
          type: 'single',
          category: '历史',
          question: '波士顿美术博物馆成立于哪一年？',
          options: ['1870年', '1880年', '1890年', '1900年'],
          correctAnswer: 0,
          explanation: '波士顿美术博物馆成立于1870年，是美国最大的博物馆之一。',
          difficulty: 'easy'
        },
        {
          id: 2,
          type: 'single',
          category: '藏品',
          question: '波士顿美术博物馆收藏有多少件艺术品？',
          options: ['超过50万件', '超过60万件', '超过70万件', '超过80万件'],
          correctAnswer: 0,
          explanation: '波士顿美术博物馆收藏了超过50万件艺术品，涵盖了从古埃及到现代的各个时期和文化。',
          difficulty: 'easy'
        },
        {
          id: 3,
          type: 'multiple',
          category: '藏品',
          question: '波士顿美术博物馆的著名收藏包括哪些？（多选）',
          options: ['古埃及文物', '日本浮世绘', '莫奈《睡莲》', '美国艺术品'],
          correctAnswer: [0, 1, 2, 3],
          explanation: '波士顿美术博物馆收藏有古埃及文物、日本浮世绘、莫奈《睡莲》、美国艺术品等，以其丰富的亚洲艺术收藏和印象派绘画而闻名。',
          difficulty: 'medium'
        },
        {
          id: 4,
          type: 'judge',
          category: '藏品',
          question: '波士顿美术博物馆收藏有雷诺阿的《划船午宴》。',
          options: ['正确', '错误'],
          correctAnswer: 0,
          explanation: '正确。波士顿美术博物馆收藏有雷诺阿的《划船午宴》，这是印象派艺术的代表作之一。',
          difficulty: 'medium'
        },
        {
          id: 5,
          type: 'single',
          category: '藏品',
          question: '波士顿美术博物馆的日本浮世绘收藏在世界上排名如何？',
          options: ['世界第一', '世界第二', '世界第三', '世界第四'],
          correctAnswer: 0,
          explanation: '波士顿美术博物馆的日本浮世绘收藏在世界上排名第一，收藏有超过5万件浮世绘作品。',
          difficulty: 'hard'
        }
      ]
    }
  ];

  // 当前模块的题目（从选中的模块中获取）
  @State questions: Question[] = [];

  @State filteredQuestions: Question[] = [];
  @State currentQuestion: Question | null = null;

  aboutToAppear() {
    this.loadQuizHistory();
    // 获取传递的参数
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params && params['moduleId']) {
      const moduleId = params['moduleId'] as string;
      if (moduleId && this.quizModules.find(m => m.id === moduleId)) {
        // 如果传递了有效的moduleId，自动选择该模块
        this.switchModule(moduleId);
      }
    }
    // 如果没有传递moduleId，显示初始提示页面
  }

  // 加载指定模块的题目
  loadModuleQuestions(moduleId: string) {
    const module = this.quizModules.find(m => m.id === moduleId);
    if (module) {
      this.questions = module.questions;
      this.filteredQuestions = this.questions;
      // 重置答题状态
      this.resetQuiz();
    }
  }

  // 重置答题状态
  resetQuiz() {
    this.quizStarted = false;
    this.showResult = false;
    this.currentQuestionIndex = 0;
    this.selectedAnswers = [];
    this.isAnswered = false;
    this.score = 0;
    this.totalQuestions = 0;
    this.currentQuestion = null;
    // 重置时展开侧边栏
    this.sidebarExpanded = true;
  }

  // 重置并清除选中的模块（用于选择其他模块）
  resetAndClearModule() {
    this.resetQuiz();
    this.selectedModuleId = '';
    this.questions = [];
    this.filteredQuestions = [];
  }

  // 切换模块
  switchModule(moduleId: string) {
    if (this.selectedModuleId !== moduleId) {
      this.selectedModuleId = moduleId;
      this.loadModuleQuestions(moduleId);
    }
  }

  async loadQuizHistory() {
    try {
      const context = getContext(this) as Context;
      this.preferencesStore = await preferences.getPreferences(context, 'user_data');
      if (this.preferencesStore) {
        const history = await this.preferencesStore.get('quizHistory', JSON.stringify({ total: 0, correct: 0, accuracy: 0 }));
        console.log('答题历史:', history);
      }
    } catch (error) {
      console.error('加载答题历史失败:', error);
    }
  }

  async saveQuizResult(correct: number, total: number) {
    try {
      if (this.preferencesStore) {
        const historyStr = await this.preferencesStore.get('quizHistory', JSON.stringify({ total: 0, correct: 0, accuracy: 0 }));
        interface QuizHistory {
          total: number;
          correct: number;
          accuracy: number;
        }
        const history = JSON.parse(historyStr as string) as QuizHistory;
        history.total += total;
        history.correct += correct;
        history.accuracy = history.total > 0 ? Math.round((history.correct / history.total) * 100) : 0;
        await this.preferencesStore.put('quizHistory', JSON.stringify(history));
        await this.preferencesStore.flush();
      }
    } catch (error) {
      console.error('保存答题结果失败:', error);
    }
  }

  build() {
    Stack() {
      Column() {
        // 顶部导航栏
        this.NavBar()

        // 主内容区域：侧边栏 + 答题区域
        Row() {
          // 侧边导航栏（答题时收缩，其他时候根据sidebarExpanded显示）
          if (this.sidebarExpanded && (!this.quizStarted || this.showResult)) {
            this.Sidebar()
          }

          // 答题内容区域
          Stack() {
            Column() {
              // 如果没有选中模块，显示初始提示页面
              if (!this.selectedModuleId) {
                this.InitialPrompt()
              } else if (!this.quizStarted) {
                // 开始页面
                this.QuizStart()
              } else if (this.showResult) {
                // 结果页面
                this.QuizResult()
              } else {
                // 答题页面
                this.QuizContent()
              }
            }
            .layoutWeight(1)
            .width('100%')
            .backgroundColor($r('app.color.app_background'))

          }
          .layoutWeight(1)
          .width('100%')
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  NavBar() {
    Column() {
      // 顶部标题栏
      Row() {
        Image($r('app.media.startIcon'))
          .width(24)
          .height(24)
          .margin({ right: 8 })
        Text('云览天下')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      // 可滑动的导航菜单
      Scroll() {
        Row() {
          // 题库分类按钮（常驻，用于展开/收缩侧边栏）
          if (!this.quizStarted || this.showResult) {
            Row() {
              Text('📚')
                .fontSize(16)
                .margin({ right: 4 })
              Text('题库分类')
                .fontSize(14)
                .fontColor($r('app.color.text_inverse'))
            }
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .margin({ right: 8 })
            .backgroundColor(this.sidebarExpanded ? $r('app.color.primary_light') : $r('app.color.primary_color'))
            .borderRadius(16)
            .onClick(() => {
              this.sidebarExpanded = !this.sidebarExpanded;
            })
          }

          this.NavItem('首页', 'pages/Index', false)
          this.NavItem('创建新行程', 'pages/SelectMuseumsPage', false)
          this.NavItem('我的行程', 'pages/MyItineraryPage', false)
          this.NavItem('博物馆', 'pages/MuseumList', false)
          this.NavItem('藏品探索', 'pages/ArtifactExplore', false)
          this.NavItem('资讯中心', 'pages/News', false)
          this.NavItem('历史时间线', 'pages/Timeline', false)
          this.NavItem('知识问答', '', true)
          this.NavItem('寻宝游戏', 'pages/TreasureHuntPage', false)
          this.NavItem('成就系统', 'pages/Achievements', false)
          this.NavItem('小工具集', 'pages/ToolsPage', false)
        }
        .height(48)
        .padding({ left: 16, right: 16 })
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Auto)
      .width('100%')
      .height(48)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  NavItem(text: string, url: string, active: boolean) {
    Text(text)
      .fontSize(14)
      .fontColor(active ? $r('app.color.primary_light') : $r('app.color.text_secondary'))
      .fontWeight(active ? FontWeight.Medium : FontWeight.Normal)
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .margin({ right: 8 })
      .onClick(() => {
        if (url) {
          router.pushUrl({ url: url } as router.RouterOptions)
        }
      })
  }

  // 侧边导航栏
  @Builder
  Sidebar() {
    Stack() {
      Column() {
        // 侧边栏标题
        Row() {
          Text('题库分类')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
          
          Blank()
          
          // 收缩按钮
          Text('◀')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .onClick(() => {
              this.sidebarExpanded = false;
            })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('app.color.card_background'))

        // 模块列表
        Scroll() {
          Column() {
            ForEach(this.quizModules, (module: QuizModule) => {
              this.ModuleItem(module)
            }, (module: QuizModule) => module.id)
          }
          .width('100%')
          .padding({ top: 0, bottom: 8 })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
        }
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Auto)
      }
      .width(200)
      .height('100%')
      .backgroundColor($r('app.color.card_background'))
    }
    .width(200)
    .height('100%')
    .shadow({
      radius: 8,
      color: $r('app.color.shadow_color'),
      offsetX: 2,
      offsetY: 0
    })
  }

  // 模块项
  @Builder
  ModuleItem(module: QuizModule) {
    Column() {
      Row() {
        // 模块图标（可选）
        if (module.icon) {
          Image(module.icon)
            .width(20)
            .height(20)
            .margin({ right: 8 })
        } else {
          // 默认图标占位
          Blank()
            .width(20)
            .height(20)
            .margin({ right: 8 })
        }

        Column() {
          Row() {
            Text(module.name)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.selectedModuleId === module.id ? $r('app.color.text_primary') : $r('app.color.text_primary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)

            // 题目数量标签
            Text(`${module.questions.length}题`)
              .fontSize(11)
              .fontColor('#ffffff')
              .fontWeight(FontWeight.Medium)
              .backgroundColor(this.selectedModuleId === module.id ? $r('app.color.primary_light') : $r('app.color.text_tertiary'))
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(10)
          }
          .width('100%')
          .margin({ bottom: 4 })

          Text(module.description)
            .fontSize(11)
            .fontColor($r('app.color.text_secondary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .backgroundColor(this.selectedModuleId === module.id ? $r('app.color.primary_lighter') : $r('app.color.card_background'))
    .borderRadius(8)
    .margin({ left: 8, right: 8, top: 0, bottom: 4 })
    .onClick(() => {
      this.switchModule(module.id)
    })
  }

  // 初始提示页面
  @Builder
  InitialPrompt() {
    Scroll() {
      Column() {
        Column() {
          Text('📖')
            .fontSize(60)
            .margin({ bottom: 16 })

          Text('探索知识，开启智慧之旅！')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 8 })
            .textAlign(TextAlign.Center)

          Text('从左侧题库分类中选择一个模块开始答题')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 20 })
            .textAlign(TextAlign.Center)

          // 提示信息
          Column() {
            Row() {
              Text('💡')
                .fontSize(16)
                .margin({ right: 8 })
              Text('每次答题将随机抽取5道题目')
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .margin({ bottom: 10 })

            Row() {
              Text('📚')
                .fontSize(16)
                .margin({ right: 8 })
              Text('涵盖历史、建筑、藏品等多个分类')
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .margin({ bottom: 10 })

            Row() {
              Text('🎯')
                .fontSize(16)
                .margin({ right: 8 })
              Text('答题过程中可以随时查看解析')
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.background_secondary'))
          .borderRadius(12)
        }
        .width('100%')
        .constraintSize({ maxWidth: 600 })
        .padding(20)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(12)
        .margin({ top: 16, left: 'auto', right: 'auto', bottom: 16 })
        .shadow({
          radius: 8,
          color: $r('app.color.shadow_color_light'),
          offsetX: 0,
          offsetY: 2
        })
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
  }

  @Builder
  QuizStart() {
    Scroll() {
      Column() {
        Column() {
        Text('📚')
          .fontSize(50)
          .margin({ bottom: 12 })

        // 显示当前选中模块的名称
        Text(this.getCurrentModuleName())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 6 })
          .textAlign(TextAlign.Center)

        // 显示当前选中模块的描述
        Text(this.getCurrentModuleDescription())
          .fontSize(13)
          .fontColor('#666666')
          .margin({ bottom: 16 })
          .textAlign(TextAlign.Center)
          .lineHeight(20)

          // 题目统计
          Row() {
            // 抽取数
            Column() {
              Text('5')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.primary_light'))
              Text('抽取数')
                .fontSize(10)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 2 })
            }
            .layoutWeight(1)
            .padding({ top: 12, bottom: 12 })

            Divider()
              .vertical(true)
              .height(30)
              .color($r('app.color.divider_color'))
              .margin({ left: 8, right: 8 })

            // 题型
            Column() {
              Text('3种')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.primary_light'))
              Text('题型')
                .fontSize(10)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 2 })
            }
            .layoutWeight(1)
            .padding({ top: 12, bottom: 12 })

            Divider()
              .vertical(true)
              .height(30)
              .color($r('app.color.divider_color'))
              .margin({ left: 8, right: 8 })

            // 分类
            Column() {
              Text(`${this.getQuestionCategories().length}类`)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.primary_light'))
              Text('分类')
                .fontSize(10)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 2 })
            }
            .layoutWeight(1)
            .padding({ top: 12, bottom: 12 })
          }
          .width('100%')
          .padding({ left: 12, right: 12 })
          .backgroundColor($r('app.color.background_secondary'))
          .borderRadius(12)
          .margin({ bottom: 20 })
          .justifyContent(FlexAlign.SpaceEvenly)

          // 分类说明
          Column() {
            Text('题目分类')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })

            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
              ForEach(this.getQuestionCategories(), (category: string) => {
                this.CategoryTag(category, this.getCategoryCount(category))
              }, (category: string) => category)
            }
            .width('100%')
          }
          .width('100%')
          .padding(12)
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 开始答题按钮
          Button('开始答题')
            .type(ButtonType.Normal)
            .backgroundColor('#3949ab')
            .fontColor('#ffffff')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.startQuiz();
            })
        }
        .width('100%')
        .constraintSize({ maxWidth: 600 })
        .padding(18)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(12)
        .margin({ top: 12, left: 'auto', right: 'auto', bottom: 12 })
        .shadow({
          radius: 12,
          color: $r('app.color.shadow_color_light'),
          offsetX: 0,
          offsetY: 4
        })
      }
      .width('100%')
      .padding({ top: 12, bottom: 12 })
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
  }

  @Builder
  CategoryTag(name: string, count: number) {
    Row() {
      Text(name)
        .fontSize(12)
        .fontColor($r('app.color.primary_light'))
      Text(`${count}题`)
        .fontSize(10)
        .fontColor('#666666')
        .margin({ left: 4 })
    }
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .backgroundColor($r('app.color.primary_lighter'))
    .borderRadius(14)
    .margin({ right: 6, bottom: 6 })
  }

  startQuiz() {
    // 随机抽取5道题
    const allQuestions = [...this.questions];
    const shuffled = allQuestions.sort(() => Math.random() - 0.5);
    const selectedQuestions = shuffled.slice(0, Math.min(5, allQuestions.length));
    
    this.filteredQuestions = selectedQuestions;
    this.currentQuestionIndex = 0;
    this.totalQuestions = this.filteredQuestions.length;
    this.score = 0;
    this.selectedAnswers = [];
    this.isAnswered = false;
    this.showResult = false;
    this.quizStarted = true;
    this.currentQuestion = this.filteredQuestions[0];
    
    // 开始答题时收缩侧边栏
    this.sidebarExpanded = false;
  }

  @Builder
  QuizContent() {
    if (this.currentQuestion) {
      Scroll() {
        Column() {
          Column() {
        // 进度条
        Row() {
          Text(`第 ${this.currentQuestionIndex + 1} / ${this.totalQuestions} 题`)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .layoutWeight(1)

          Text(this.currentQuestion.category)
            .fontSize(12)
            .fontColor($r('app.color.primary_light'))
            .backgroundColor($r('app.color.primary_lighter'))
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(10)
        }
        .width('100%')
        .margin({ bottom: 16 })

        // 进度条
        Progress({ value: (this.currentQuestionIndex + 1) / this.totalQuestions * 100, total: 100, type: ProgressType.Linear })
          .width('100%')
          .height(6)
          .color($r('app.color.primary_light'))
          .backgroundColor($r('app.color.divider_color'))
          .margin({ bottom: 24 })

        // 题目类型标签
        Row() {
          if (this.currentQuestion.type === 'single') {
            Text('单选题')
              .fontSize(12)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor($r('app.color.badge_new'))
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(8)
          } else if (this.currentQuestion.type === 'multiple') {
            Text('多选题')
              .fontSize(12)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor('#ff9800')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(8)
          } else {
            Text('判断题')
              .fontSize(12)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor('#2196f3')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(8)
          }

          Blank()

          Text(this.getDifficultyText(this.currentQuestion.difficulty))
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .margin({ bottom: 20 })

        // 题目内容
        Text(this.currentQuestion.question)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(28)
          .margin({ bottom: 24 })
          .width('100%')

        // 选项列表
        Column() {
          ForEach(this.currentQuestion.options, (option: string, index: number) => {
            this.OptionItem(option, index)
          })
        }
        .width('100%')
        .margin({ bottom: 24 })

        // 解析（已回答后显示）
        if (this.isAnswered) {
          Column() {
            Row() {
              Text('📖')
                .fontSize(16)
                .margin({ right: 8 })
              Text('解析')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .margin({ bottom: 12 })

            Text(this.currentQuestion.explanation)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.background_secondary'))
          .borderRadius(12)
          .margin({ bottom: 24 })
        }

        // 按钮区域
        Row() {
          if (this.currentQuestionIndex > 0) {
            Button('上一题')
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.button_secondary'))
              .fontColor($r('app.color.text_primary'))
              .fontSize(14)
              .layoutWeight(1)
              .height(44)
              .borderRadius(22)
              .onClick(() => {
                this.previousQuestion();
              })
          }

          if (!this.isAnswered) {
            Button(this.currentQuestion.type === 'multiple' ? '提交答案' : '确认答案')
              .type(ButtonType.Normal)
              .backgroundColor('#3949ab')
              .fontColor('#ffffff')
              .fontSize(14)
              .layoutWeight(this.currentQuestionIndex > 0 ? 1 : 2)
              .height(44)
              .borderRadius(22)
              .margin({ left: this.currentQuestionIndex > 0 ? 12 : 0 })
              .onClick(() => {
                this.submitAnswer();
              })
          } else {
            if (this.currentQuestionIndex < this.totalQuestions - 1) {
              Button('下一题')
                .type(ButtonType.Normal)
                .backgroundColor('#3949ab')
                .fontColor($r('app.color.text_inverse'))
                .fontSize(14)
                .layoutWeight(2)
                .height(44)
                .borderRadius(22)
                .margin({ left: this.currentQuestionIndex > 0 ? 12 : 0 })
                .onClick(() => {
                  this.nextQuestion();
                })
            } else {
              Button('查看结果')
                .type(ButtonType.Normal)
                .backgroundColor('#4caf50')
                .fontColor($r('app.color.text_inverse'))
                .fontSize(14)
                .layoutWeight(2)
                .height(44)
                .borderRadius(22)
                .margin({ left: this.currentQuestionIndex > 0 ? 12 : 0 })
                .onClick(() => {
                  this.showResult = true;
                })
            }
          }
        }
        .width('100%')
        }
        .width('100%')
        .padding(24)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(12)
        .margin({ top: 20, left: 16, right: 16, bottom: 20 })
        .shadow({
          radius: 8,
          color: $r('app.color.shadow_color_light'),
          offsetX: 0,
          offsetY: 2
        })
      }
      .width('100%')
      .padding({ top: 20, bottom: 20 })
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
    }
  }

  @Builder
  OptionItem(option: string, index: number) {
    if (this.currentQuestion) {
      Row() {
        // 选项标识
        Text(String.fromCharCode(65 + index)) // A, B, C, D
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isAnswered ? (this.isAnswerCorrect(index) ? '#ffffff' : (this.selectedAnswers.includes(index) ? '#ffffff' : '#666666')) : (this.selectedAnswers.includes(index) ? '#ffffff' : '#666666'))
          .width(32)
          .height(32)
          .textAlign(TextAlign.Center)
          .borderRadius(16)
          .backgroundColor(this.isAnswered ? (this.isAnswerCorrect(index) ? '#4caf50' : (this.selectedAnswers.includes(index) ? '#f44336' : '#e0e0e0')) : (this.selectedAnswers.includes(index) ? '#3949ab' : '#e0e0e0'))
          .margin({ right: 12 })

        // 选项内容
        Text(option)
          .fontSize(15)
          .fontColor(this.isAnswered ? (this.isAnswerCorrect(index) ? '#4caf50' : (this.selectedAnswers.includes(index) ? '#f44336' : '#333333')) : '#333333')
          .layoutWeight(1)
          .lineHeight(22)

        // 结果图标
        if (this.isAnswered) {
          if (this.isAnswerCorrect(index)) {
            Text('✓')
              .fontSize(20)
              .fontColor('#4caf50')
              .fontWeight(FontWeight.Bold)
              .margin({ left: 8 })
          } else if (this.selectedAnswers.includes(index) && !this.isAnswerCorrect(index)) {
            Text('✗')
              .fontSize(20)
              .fontColor('#f44336')
              .fontWeight(FontWeight.Bold)
              .margin({ left: 8 })
          }
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.isAnswered ? (this.isAnswerCorrect(index) ? '#e8f5e9' : (this.selectedAnswers.includes(index) ? '#ffebee' : '#f5f5f5')) : (this.selectedAnswers.includes(index) ? '#e8eaf6' : '#f5f5f5'))
      .borderRadius(12)
      .border({
        width: this.isAnswered ? (this.isAnswerCorrect(index) ? 2 : (this.selectedAnswers.includes(index) ? 2 : 0)) : (this.selectedAnswers.includes(index) ? 2 : 0),
        color: this.isAnswered ? (this.isAnswerCorrect(index) ? '#4caf50' : '#f44336') : '#3949ab'
      })
      .margin({ bottom: 12 })
      .onClick(() => {
        if (!this.isAnswered) {
          this.toggleOption(index);
        }
      })
    }
  }

  toggleOption(index: number) {
    if (!this.currentQuestion) {
      return;
    }

    if (this.currentQuestion.type === 'single' || this.currentQuestion.type === 'judge') {
      // 单选或判断：直接替换
      this.selectedAnswers = [index];
    } else {
      // 多选：切换选择
      if (this.selectedAnswers.includes(index)) {
        this.selectedAnswers = this.selectedAnswers.filter(i => i !== index);
      } else {
        this.selectedAnswers.push(index);
      }
    }
    this.selectedAnswers = [...this.selectedAnswers];
  }

  submitAnswer() {
    if (this.selectedAnswers.length === 0) {
      return;
    }

    this.isAnswered = true;

    // 检查答案
    const isCorrect = this.checkAnswer();
    if (isCorrect) {
      this.score++;
    }
  }

  checkAnswer(): boolean {
    if (!this.currentQuestion) {
      return false;
    }

    const correctAnswer = this.currentQuestion.correctAnswer;
    const userAnswer = this.selectedAnswers;

    if (Array.isArray(correctAnswer)) {
      // 多选题：答案必须完全匹配
      if (userAnswer.length !== correctAnswer.length) {
        return false;
      }
      const sortedCorrect = [...correctAnswer].sort((a, b) => a - b);
      const sortedUser = [...userAnswer].sort((a, b) => a - b);
      return JSON.stringify(sortedCorrect) === JSON.stringify(sortedUser);
    } else {
      // 单选或判断
      return userAnswer.length === 1 && userAnswer[0] === correctAnswer;
    }
  }

  isAnswerCorrect(index: number): boolean {
    if (!this.currentQuestion) {
      return false;
    }

    const correctAnswer = this.currentQuestion.correctAnswer;
    if (Array.isArray(correctAnswer)) {
      return correctAnswer.includes(index);
    } else {
      return index === correctAnswer;
    }
  }

  previousQuestion() {
    if (this.currentQuestionIndex > 0) {
      this.currentQuestionIndex--;
      if (this.filteredQuestions && this.filteredQuestions.length > this.currentQuestionIndex) {
        this.currentQuestion = this.filteredQuestions[this.currentQuestionIndex];
        this.selectedAnswers = [];
        this.isAnswered = false;
      }
    }
  }

  nextQuestion() {
    if (this.currentQuestionIndex < this.totalQuestions - 1) {
      this.currentQuestionIndex++;
      if (this.filteredQuestions && this.filteredQuestions.length > this.currentQuestionIndex) {
        this.currentQuestion = this.filteredQuestions[this.currentQuestionIndex];
        this.selectedAnswers = [];
        this.isAnswered = false;
      }
    }
  }

  getDifficultyText(difficulty: string): string {
    switch (difficulty) {
      case 'easy':
        return '简单';
      case 'medium':
        return '中等';
      case 'hard':
        return '困难';
      default:
        return '';
    }
  }

  @Builder
  QuizResult() {
    Scroll() {
      Column() {
        Column() {
          // 结果图标
          Text(this.getAccuracy() >= 80 ? '🎉' : this.getAccuracy() >= 60 ? '👍' : '💪')
            .fontSize(60)
            .margin({ bottom: 16 })

          Text(this.getAccuracy() >= 80 ? '优秀！' : this.getAccuracy() >= 60 ? '良好！' : '继续加油！')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 12 })
            .textAlign(TextAlign.Center)

          // 得分
          Row() {
            Column() {
              Text(`${this.score}`)
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.primary_light'))
              Text('答对题数')
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 4 })
            }
            .layoutWeight(1)

            Divider()
              .vertical(true)
              .height(50)
              .color($r('app.color.divider_color'))

            Column() {
              Text(`${this.totalQuestions}`)
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.primary_light'))
              Text('总题数')
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 4 })
            }
            .layoutWeight(1)

            Divider()
              .vertical(true)
              .height(50)
              .color($r('app.color.divider_color'))

            Column() {
              Text(`${this.getAccuracy()}%`)
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor('#4caf50')
              Text('正确率')
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 4 })
            }
            .layoutWeight(1)
          }
          .width('100%')
          .height(100)
          .justifyContent(FlexAlign.SpaceEvenly)
          .margin({ bottom: 20 })

          // 评价
          Text(this.getEvaluation(this.getAccuracy()))
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .lineHeight(22)
            .margin({ bottom: 20 })
            .width('100%')

        // 按钮
        Row() {
          Button('再来一次')
            .type(ButtonType.Normal)
            .backgroundColor('#e0e0e0')
            .fontColor('#333333')
            .fontSize(14)
            .layoutWeight(1)
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.startQuiz();
            })

          Blank()
            .width(12)

          Button('选择其他模块')
            .type(ButtonType.Normal)
            .backgroundColor('#3949ab')
            .fontColor('#ffffff')
            .fontSize(14)
            .layoutWeight(1)
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.resetAndClearModule();
            })
        }
        .width('100%')
        }
        .width('100%')
        .constraintSize({ maxWidth: 600 })
        .padding(20)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(12)
        .margin({ top: 16, left: 'auto', right: 'auto', bottom: 16 })
        .shadow({
          radius: 8,
          color: $r('app.color.shadow_color_light'),
          offsetX: 0,
          offsetY: 2
        })
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
    .onAppear(() => {
      // 保存答题结果
      this.saveQuizResult(this.score, this.totalQuestions);
    })
  }

  getAccuracy(): number {
    return this.totalQuestions > 0 ? Math.round((this.score / this.totalQuestions) * 100) : 0;
  }

  getEvaluation(accuracy: number): string {
    const moduleName = this.getCurrentModuleName();
    if (accuracy >= 90) {
      return `太棒了！你对${moduleName}的了解非常深入，是真正的专家！`;
    } else if (accuracy >= 80) {
      return `优秀！你对${moduleName}有很好的了解，继续保持！`;
    } else if (accuracy >= 60) {
      return `不错！你对${moduleName}有一定了解，还有提升空间。`;
    } else {
      return `继续努力！多了解${moduleName}的相关知识，相信你会做得更好！`;
    }
  }

  // 获取当前模块名称
  getCurrentModuleName(): string {
    const module = this.quizModules.find(m => m.id === this.selectedModuleId);
    return module ? module.name : '知识问答';
  }

  // 获取当前模块描述
  getCurrentModuleDescription(): string {
    const module = this.quizModules.find(m => m.id === this.selectedModuleId);
    return module ? module.description : '测试你的知识水平';
  }

  // 获取题目分类列表
  getQuestionCategories(): string[] {
    const categories = new Set<string>();
    this.questions.forEach(q => {
      categories.add(q.category);
    });
    return Array.from(categories);
  }

  // 获取指定分类的题目数量
  getCategoryCount(category: string): number {
    return this.questions.filter(q => q.category === category).length;
  }
}