/**
 * 藏品数据服务
 */
import { Artifact, RecommendResult } from '../models/ArtifactModel';

export class ArtifactService {
  private static instance: ArtifactService;
  private artifacts: Artifact[] = [];

  private constructor() {
    this.loadArtifacts();
  }

  public static getInstance(): ArtifactService {
    if (!ArtifactService.instance) {
      ArtifactService.instance = new ArtifactService();
    }
    return ArtifactService.instance;
  }

  /**
   * 加载本地数据
   */
  private loadArtifacts(): void {
    this.artifacts = [
      {
        id: 1,
        title: '清明上河图',
        museumId: 1,
        museumName: '故宫博物院',
        desc: '北宋画家张择端所作，描绘了北宋都城汴京的城市面貌和当时社会各阶层人民的生活状况。全长528.7厘米，高24.8厘米，是中国古代风俗画的巅峰之作。',
        image: '清明上河图.png',
        tags: ['古代中国', '绘画', '热门'],
        duration: 10,
        isPopular: true
      },
      {
        id: 2,
        title: '千里江山图',
        museumId: 1,
        museumName: '故宫博物院',
        desc: '北宋画家王希孟创作的青绿山水画长卷，描绘了壮丽的江山景色。是中国古代青绿山水画的代表作，色彩绚丽，气势磅礴。',
        image: '千里江山图文创.png',
        tags: ['古代中国', '绘画', '书法'],
        duration: 9,
        isPopular: false
      },
      {
        id: 3,
        title: '富春山居图',
        museumId: 1,
        museumName: '故宫博物院',
        desc: '元代画家黄公望创作的山水画长卷，被誉为"画中之兰亭"。描绘了富春江两岸的秀丽景色，是中国古代山水画的巅峰之作。',
        image: '富春山居图.webp',
        tags: ['古代中国', '绘画', '书法'],
        duration: 11,
        isPopular: false
      },
      {
        id: 4,
        title: '青花瓷',
        museumId: 1,
        museumName: '故宫博物院',
        desc: '明代青花瓷器，是中外文化交流的见证。郑和下西洋带回的钴料制成的青花瓷器，色彩鲜艳，工艺精湛。',
        image: '唐三彩复刻.png',
        tags: ['古代中国', '陶瓷', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 5,
        title: '书法作品',
        museumId: 1,
        museumName: '故宫博物院',
        desc: '中国古代书法作品，展现了汉字书法的艺术魅力。包括楷书、行书、草书等多种书体，是中华文化的重要组成部分。',
        image: '千里江山图文创.png',
        tags: ['古代中国', '书法', '热门'],
        duration: 7,
        isPopular: false
      },
      {
        id: 6,
        title: '罗塞塔石碑',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '制作于公元前196年，刻有古埃及国王托勒密五世登基的诏书，是解密古埃及象形文字的关键。石碑上刻有三种文字：古埃及象形文字、古埃及草书和古希腊文。',
        image: '罗塞塔石碑.png',
        tags: ['科技文物', '热门'],
        duration: 12,
        isPopular: true
      },
      {
        id: 7,
        title: '维伦多夫的维纳斯',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '旧石器时代的小型女性雕像，发现于奥地利，是已知最早的人类艺术表现之一。制作于约2.5万年前，高11厘米。',
        image: '维伦多夫的维纳斯.png',
        tags: ['雕塑', '热门'],
        duration: 6,
        isPopular: true
      },
      {
        id: 8,
        title: '大卫像',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '意大利文艺复兴时期雕塑家米开朗基罗创作的大理石雕塑，高5.17米，创作于1501-1504年。描绘了《圣经》中大卫王准备与巨人歌利亚战斗的场景。',
        image: '大卫像.webp',
        tags: ['雕塑', '文艺复兴', '热门'],
        duration: 10,
        isPopular: true
      },
      {
        id: 9,
        title: '思想者',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '法国雕塑家奥古斯特·罗丹创作的大理石雕塑，描绘了一个沉思的男性形象。创作于1880年，是罗丹最著名的作品之一。',
        image: '思想者.webp',
        tags: ['雕塑', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 10,
        title: '最后的晚餐',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的壁画，描绘了耶稣与门徒共进最后一餐的场景。是达·芬奇最著名的作品之一。',
        image: '最后的晚餐.webp',
        tags: ['西方绘画', '文艺复兴', '热门'],
        duration: 10,
        isPopular: true
      },
      {
        id: 11,
        title: '格尔尼卡',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '西班牙立体主义画家巴勃罗·毕加索创作的油画，描绘了西班牙内战期间格尔尼卡镇被轰炸的场景。创作于1937年，是反战艺术的代表作。',
        image: '格尔尼卡.webp',
        tags: ['西方绘画', '革命历史', '热门'],
        duration: 9,
        isPopular: true
      },
      {
        id: 12,
        title: '掷铁饼者',
        museumId: 2,
        museumName: '大英博物馆',
        desc: '古希腊雕塑作品，创作于公元前5世纪。描绘了一个准备投掷铁饼的运动员，展现了古希腊对人体美的追求。',
        image: '掷铁饼者.jpg',
        tags: ['雕塑', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 13,
        title: '蒙娜丽莎',
        museumId: 3,
        museumName: '卢浮宫',
        desc: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，以其神秘的微笑而闻名于世。创作于1503-1519年，现藏于法国卢浮宫。',
        image: '蒙娜丽莎.png',
        tags: ['西方绘画', '文艺复兴', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 14,
        title: '断臂的维纳斯',
        museumId: 3,
        museumName: '卢浮宫',
        desc: '古希腊雕塑作品，创作于公元前2世纪。虽然失去了双臂，但依然展现了完美的女性美，是古希腊雕塑艺术的杰作。',
        image: '断臂的维纳斯.jpg',
        tags: ['雕塑', '文艺复兴'],
        duration: 10,
        isPopular: false
      },
      {
        id: 15,
        title: '自由引导人民',
        museumId: 3,
        museumName: '卢浮宫',
        desc: '法国浪漫主义画家欧仁·德拉克洛瓦创作的油画，描绘了1830年法国七月革命的场景。创作于1830年，是法国浪漫主义绘画的代表作。',
        image: '自由引导人民.png',
        tags: ['西方绘画', '革命历史', '热门'],
        duration: 9,
        isPopular: true
      },
      {
        id: 16,
        title: '睡莲',
        museumId: 3,
        museumName: '卢浮宫',
        desc: '法国印象派画家克劳德·莫奈创作的系列油画作品，描绘了他在吉维尼花园中的睡莲池。是印象派绘画的代表作之一。',
        image: '睡莲.webp',
        tags: ['西方绘画', '印象派'],
        duration: 7,
        isPopular: false
      },
      {
        id: 17,
        title: '星夜',
        museumId: 4,
        museumName: '大都会艺术博物馆',
        desc: '荷兰后印象派画家文森特·梵高创作的油画，描绘了夜晚的星空和村庄。创作于1889年，以其独特的笔触和色彩运用而闻名。',
        image: '星夜.webp',
        tags: ['西方绘画', '印象派', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 18,
        title: '夜巡',
        museumId: 4,
        museumName: '大都会艺术博物馆',
        desc: '荷兰画家伦勃朗创作的油画，描绘了阿姆斯特丹民兵队的场景。创作于1642年，是伦勃朗最著名的作品之一。',
        image: '夜巡.webp',
        tags: ['西方绘画', '热门'],
        duration: 9,
        isPopular: true
      },
      {
        id: 19,
        title: '向日葵',
        museumId: 4,
        museumName: '大都会艺术博物馆',
        desc: '荷兰后印象派画家文森特·梵高创作的系列油画作品，以向日葵为主题。是梵高最具代表性的作品之一。',
        image: '向日葵.jpg',
        tags: ['西方绘画', '印象派', '热门'],
        duration: 7,
        isPopular: true
      },
      {
        id: 20,
        title: '记忆的永恒',
        museumId: 4,
        museumName: '大都会艺术博物馆',
        desc: '西班牙超现实主义画家萨尔瓦多·达利创作的油画，描绘了融化的时钟等超现实元素。创作于1931年，是超现实主义艺术的代表作。',
        image: '记忆的永恒.webp',
        tags: ['西方绘画', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 21,
        title: '呐喊',
        museumId: 4,
        museumName: '大都会艺术博物馆',
        desc: '挪威表现主义画家爱德华·蒙克创作的油画，描绘了一个在桥上呐喊的人物。创作于1893年，是表现主义艺术的代表作。',
        image: '呐喊.webp',
        tags: ['西方绘画', '热门'],
        duration: 7,
        isPopular: true
      },
      {
        id: 22,
        title: '青铜器',
        museumId: 5,
        museumName: '中国国家博物馆',
        desc: '中国古代青铜器是中华文明的重要标志，包括礼器、兵器、乐器等。制作工艺精湛，纹饰精美，反映了古代中国的铸造技术和文化水平。',
        image: '青铜器复刻.png',
        tags: ['古代中国', '青铜器', '热门'],
        duration: 12,
        isPopular: true
      },
      {
        id: 23,
        title: '玉器',
        museumId: 5,
        museumName: '中国国家博物馆',
        desc: '中国古代玉器是中华文明的重要标志，包括礼器、装饰品等。制作工艺精湛，纹饰精美，反映了古代中国的玉雕技术和文化水平。',
        image: '青铜器复刻.png',
        tags: ['古代中国', '玉器', '热门'],
        duration: 9,
        isPopular: true
      },
      {
        id: 24,
        title: '革命文物',
        museumId: 5,
        museumName: '中国国家博物馆',
        desc: '中国国家博物馆收藏的革命历史文物，包括革命时期的物品和文献。展现了中国人民的革命历程。',
        image: '青铜器复刻.png',
        tags: ['革命历史', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 25,
        title: '上海博物馆青铜器',
        museumId: 6,
        museumName: '上海博物馆',
        desc: '上海博物馆收藏的青铜器，包括礼器、兵器、乐器等。制作工艺精湛，纹饰精美，反映了古代中国的铸造技术。',
        image: '青铜器复刻.png',
        tags: ['古代中国', '青铜器', '热门'],
        duration: 11,
        isPopular: true
      },
      {
        id: 26,
        title: '上海博物馆陶瓷',
        museumId: 6,
        museumName: '上海博物馆',
        desc: '上海博物馆收藏的陶瓷器，包括青瓷、白瓷、彩瓷等。造型优美，釉色丰富，反映了中国古代陶瓷工艺的发展。',
        image: '唐三彩复刻.png',
        tags: ['古代中国', '陶瓷', '热门'],
        duration: 9,
        isPopular: true
      },
      {
        id: 27,
        title: '上海博物馆书画',
        museumId: 6,
        museumName: '上海博物馆',
        desc: '上海博物馆收藏的书画作品，包括历代名家的书法和绘画。展现了中华文化的艺术魅力。',
        image: '千里江山图文创.png',
        tags: ['古代中国', '绘画', '书法'],
        duration: 8,
        isPopular: false
      },
      {
        id: 28,
        title: '兵马俑',
        museumId: 7,
        museumName: '陕西历史博物馆',
        desc: '秦始皇陵的陪葬坑中的陶俑，规模宏大，造型逼真，是中国古代雕塑艺术的杰作。每个兵马俑的面部表情、发型、服饰都各不相同。',
        image: '兵马俑.png',
        tags: ['古代中国', '雕塑', '热门'],
        duration: 15,
        isPopular: true
      },
      {
        id: 29,
        title: '唐三彩',
        museumId: 7,
        museumName: '陕西历史博物馆',
        desc: '唐代彩色釉陶器的统称，以黄、绿、白三色为主，造型生动，色彩绚丽。是唐代陶瓷工艺的代表作，反映了盛唐时期的文化艺术水平。',
        image: '唐三彩复刻.png',
        tags: ['古代中国', '陶瓷', '热门'],
        duration: 8,
        isPopular: true
      },
      {
        id: 30,
        title: '图坦卡蒙黄金面具',
        museumId: 8,
        museumName: '埃及博物馆',
        desc: '古埃及法老图坦卡蒙的葬礼面具，由纯金制成，镶嵌有宝石和彩色玻璃，是古埃及艺术的代表作。制作于公元前1323年，重达11公斤。',
        image: '图坦卡蒙黄金面具.png',
        tags: ['科技文物', '热门'],
        duration: 10,
        isPopular: true
      },
      {
        id: 31,
        title: '古埃及木乃伊',
        museumId: 8,
        museumName: '埃及博物馆',
        desc: '古埃及法老的木乃伊，保存完好，展现了古埃及的防腐技术。是研究古埃及文明的重要文物。',
        image: '古埃及文明.png',
        tags: ['科技文物', '热门'],
        duration: 12,
        isPopular: true
      },
      {
        id: 32,
        title: '古埃及壁画',
        museumId: 8,
        museumName: '埃及博物馆',
        desc: '古埃及墓室壁画，描绘了古埃及人的生活场景和宗教信仰。色彩鲜艳，内容丰富，是古埃及艺术的重要代表。',
        image: '古埃及文明.png',
        tags: ['科技文物', '绘画'],
        duration: 10,
        isPopular: false
      }
    ];
  }

  /**
   * 获取所有藏品
   */
  public getAllArtifacts(): Artifact[] {
    return this.artifacts;
  }

  /**
   * 根据ID获取藏品
   */
  public getArtifactById(id: number): Artifact | undefined {
    return this.artifacts.find(item => item.id === id);
  }

  /**
   * 根据博物馆ID获取藏品列表
   */
  public getArtifactsByMuseumId(museumId: number): Artifact[] {
    return this.artifacts.filter(item => item.museumId === museumId);
  }

  /**
   * 根据ID数组获取藏品列表
   */
  public getArtifactsByIds(ids: number[]): Artifact[] {
    return this.artifacts.filter(item => ids.includes(item.id));
  }
}
