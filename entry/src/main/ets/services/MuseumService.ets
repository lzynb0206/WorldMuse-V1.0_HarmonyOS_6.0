/**
 * 博物馆数据服务
 */
import { Museum } from '../models/MuseumModel';

export class MuseumService {
  private static instance: MuseumService;
  private museums: Museum[] = [];

  private constructor() {
    this.loadMuseums();
  }

  public static getInstance(): MuseumService {
    if (!MuseumService.instance) {
      MuseumService.instance = new MuseumService();
    }
    return MuseumService.instance;
  }

  /**
   * 加载本地数据
   */
  private loadMuseums(): void {
    this.museums = [
      {
        id: 1,
        name: '故宫博物院',
        location: '中国·北京',
        image: '故宫.png',
        description: '世界上现存规模最大、保存最为完整的木质结构古建筑群'
      },
      {
        id: 2,
        name: '大英博物馆',
        location: '英国·伦敦',
        image: '大英博物馆.png',
        description: '世界上规模最大、最著名的博物馆之一'
      },
      {
        id: 3,
        name: '卢浮宫',
        location: '法国·巴黎',
        image: '卢浮宫.png',
        description: '世界著名艺术博物馆，以收藏古典绘画和雕刻而闻名'
      },
      {
        id: 4,
        name: '大都会艺术博物馆',
        location: '美国·纽约',
        image: '大都会艺术博物馆.png',
        description: '美国最大的艺术博物馆，收藏了来自世界各地的200多万件艺术品'
      },
      {
        id: 5,
        name: '中国国家博物馆',
        location: '中国·北京',
        image: '中国国家博物馆.webp',
        description: '中国最大的综合性历史博物馆'
      },
      {
        id: 6,
        name: '上海博物馆',
        location: '中国·上海',
        image: '上海博物馆.jpg',
        description: '中国重要的古代艺术博物馆'
      },
      {
        id: 7,
        name: '陕西历史博物馆',
        location: '中国·西安',
        image: '陕西历史博物馆.webp',
        description: '中国重要的历史博物馆，以收藏周、秦、汉、唐等朝代的文物而闻名'
      },
      {
        id: 8,
        name: '埃及博物馆',
        location: '埃及·开罗',
        image: '埃及博物馆.webp',
        description: '世界上收藏古埃及文物最丰富的博物馆'
      },
      {
        id: 9,
        name: '东京国立博物馆',
        location: '日本·东京',
        image: '东京国立博物馆.jpg',
        description: '日本历史最悠久、规模最大的博物馆，收藏了大量日本和亚洲艺术品'
      },
      {
        id: 10,
        name: '乌菲兹美术馆',
        location: '意大利·佛罗伦萨',
        image: '乌菲兹美术馆.jpg',
        description: '世界最著名的艺术博物馆之一，以收藏文艺复兴时期的绘画而闻名'
      },
      {
        id: 11,
        name: '南京博物院',
        location: '中国·南京',
        image: '南京博物馆.jpg',
        description: '中国三大博物馆之一，以收藏明清文物和古代艺术品而著称'
      },
      {
        id: 12,
        name: '梵蒂冈博物馆',
        location: '梵蒂冈',
        image: '梵蒂冈博物馆.jpg',
        description: '世界上最重要的艺术收藏之一，以收藏文艺复兴时期的杰作而闻名'
      },
      {
        id: 13,
        name: '奥赛博物馆',
        location: '法国·巴黎',
        image: '奥赛博物馆.webp',
        description: '以收藏印象派和后印象派作品而闻名的世界级艺术博物馆'
      },
      {
        id: 14,
        name: '普拉多博物馆',
        location: '西班牙·马德里',
        image: '普拉多博物馆.webp',
        description: '西班牙最重要的艺术博物馆，收藏了大量西班牙和欧洲绘画杰作'
      },
      {
        id: 15,
        name: '泰特现代美术馆',
        location: '英国·伦敦',
        image: '泰特现代美术馆.webp',
        description: '世界最著名的现代艺术博物馆之一，展示20世纪至今的艺术作品'
      },
      {
        id: 16,
        name: '艾尔米塔什博物馆',
        location: '俄罗斯·圣彼得堡',
        image: '艾尔米塔什博物馆.webp',
        description: '世界四大博物馆之一，以收藏欧洲艺术和俄罗斯艺术品而闻名'
      },
      {
        id: 17,
        name: '芝加哥艺术博物馆',
        location: '美国·芝加哥',
        image: '芝加哥艺术博物馆.jpg',
        description: '美国重要的艺术博物馆，收藏了来自世界各地的艺术珍品'
      },
      {
        id: 18,
        name: '阿姆斯特丹国家博物馆',
        location: '荷兰·阿姆斯特丹',
        image: '阿姆斯特丹国家博物馆.webp',
        description: '荷兰最重要的艺术和历史博物馆，以收藏荷兰黄金时代的绘画而闻名'
      },
      {
        id: 19,
        name: '古根海姆博物馆',
        location: '美国·纽约',
        image: '古根海姆博物馆.jpg',
        description: '世界著名的现代艺术博物馆，以其独特的建筑和现代艺术收藏而闻名'
      },
      {
        id: 20,
        name: '柏林国家博物馆',
        location: '德国·柏林',
        image: '柏林国家博物馆.webp',
        description: '德国最重要的博物馆群，收藏了从古代到现代的艺术和历史文物'
      },
      {
        id: 21,
        name: '首尔国立中央博物馆',
        location: '韩国·首尔',
        image: '首尔国立中央博物馆.webp',
        description: '韩国最大的博物馆，展示韩国历史和文化的珍贵文物'
      },
      {
        id: 22,
        name: '台北故宫博物院',
        location: '中国·台北',
        image: '台北故宫博物院.jpg',
        description: '收藏了大量中国古代艺术珍品，是中华文化的重要宝库'
      },
      {
        id: 23,
        name: '墨西哥国家人类学博物馆',
        location: '墨西哥·墨西哥城',
        image: '墨西哥国家人类学博物馆.webp',
        description: '拉丁美洲最重要的博物馆之一，展示墨西哥古代文明和人类学藏品'
      },
      {
        id: 24,
        name: '维多利亚与阿尔伯特博物馆',
        location: '英国·伦敦',
        image: '维多利亚与阿尔伯特博物馆.webp',
        description: '世界最大的装饰艺术和设计博物馆，收藏了来自世界各地的艺术品'
      },
      {
        id: 25,
        name: '波士顿美术博物馆',
        location: '美国·波士顿',
        image: '波士顿美术博物馆.jpg',
        description: '美国重要的艺术博物馆，收藏了从古代到现代的艺术作品'
      }
    ];
  }

  /**
   * 获取所有博物馆
   */
  public getAllMuseums(): Museum[] {
    return this.museums;
  }

  /**
   * 根据ID获取博物馆
   */
  public getMuseumById(id: number): Museum | undefined {
    return this.museums.find(item => item.id === id);
  }

  /**
   * 根据ID数组获取博物馆列表
   */
  public getMuseumsByIds(ids: number[]): Museum[] {
    return this.museums.filter(item => ids.includes(item.id));
  }
}

