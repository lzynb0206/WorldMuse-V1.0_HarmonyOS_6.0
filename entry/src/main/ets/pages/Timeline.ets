import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

interface TimelineItem {
  id: number;
  year: string;
  period: string;
  title: string;
  description: string;
  type: 'museum' | 'artifact';
  museumId?: number;
  artifactId?: number;
}

@Entry
@Component
struct Timeline {
  @State selectedPeriod: string = 'all';
  @State isLandscape: boolean = false;
  @State preferencesStore: preferences.Preferences | null = null;

  @State timelineItems: TimelineItem[] = [
    {
      id: 1,
      year: '公元前30000年',
      period: 'prehistoric',
      title: '维伦多夫的维纳斯',
      description: '旧石器时代的小型女性雕像，发现于奥地利，是已知最早的人类艺术表现之一。制作于约2.5万年前，高11厘米，可能用于生殖崇拜或宗教仪式。',
      type: 'artifact',
      artifactId: 6
    },
    {
      id: 2,
      year: '公元前1323年',
      period: 'ancient',
      title: '图坦卡蒙黄金面具',
      description: '古埃及法老图坦卡蒙的葬礼面具，由纯金制成，镶嵌有宝石和彩色玻璃，是古埃及艺术的代表作。制作于公元前1323年，重达11公斤。',
      type: 'artifact',
      artifactId: 5
    },
    {
      id: 3,
      year: '公元前210年',
      period: 'ancient',
      title: '兵马俑',
      description: '秦始皇陵的陪葬坑中的陶俑，规模宏大，造型逼真，是中国古代雕塑艺术的杰作。每个兵马俑的面部表情、发型、服饰都各不相同。',
      type: 'artifact',
      artifactId: 4
    },
    {
      id: 4,
      year: '公元前196年',
      period: 'ancient',
      title: '罗塞塔石碑',
      description: '制作于公元前196年，刻有古埃及国王托勒密五世登基的诏书，是解密古埃及象形文字的关键。石碑上刻有三种文字：古埃及象形文字、古埃及草书和古希腊文。',
      type: 'artifact',
      artifactId: 2
    },
    {
      id: 5,
      year: '公元前450年',
      period: 'ancient',
      title: '掷铁饼者',
      description: '古希腊雕塑家米隆创作的大理石雕塑，创作于约公元前450年。描绘了运动员投掷铁饼的瞬间，展现了古希腊对人体美的追求。',
      type: 'artifact',
      artifactId: 15
    },
    {
      id: 6,
      year: '公元前130-100年',
      period: 'ancient',
      title: '断臂的维纳斯',
      description: '古希腊雕塑作品，创作于约公元前130-100年。高2.04米，现藏于法国卢浮宫，以其完美的比例和优雅的姿态而闻名，被誉为"美的象征"。',
      type: 'artifact',
      artifactId: 16
    },
    {
      id: 7,
      year: '公元1100-1200年',
      period: 'ancient',
      title: '清明上河图',
      description: '北宋画家张择端所作，描绘了北宋都城汴京的城市面貌和当时社会各阶层人民的生活状况。全长528.7厘米，高24.8厘米，是中国古代风俗画的巅峰之作。',
      type: 'artifact',
      artifactId: 1
    },
    {
      id: 8,
      year: '1350年',
      period: 'ancient',
      title: '富春山居图',
      description: '元代画家黄公望创作的山水画长卷，描绘了富春江两岸的山水景色。全长636.9厘米，高33厘米，是中国古代山水画的巅峰之作，被誉为"画中之兰亭"。',
      type: 'artifact',
      artifactId: 14
    },
    {
      id: 9,
      year: '1495-1498年',
      period: 'renaissance',
      title: '最后的晚餐',
      description: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的壁画，描绘了耶稣与十二门徒共进最后一餐的场景。现位于意大利米兰圣玛利亚感恩教堂。',
      type: 'artifact',
      artifactId: 12
    },
    {
      id: 10,
      year: '1501-1504年',
      period: 'renaissance',
      title: '大卫像',
      description: '意大利文艺复兴时期雕塑家米开朗基罗创作的大理石雕塑，高5.17米。描绘了《圣经》中大卫王准备与巨人歌利亚战斗的场景，是文艺复兴雕塑艺术的巅峰之作。',
      type: 'artifact',
      artifactId: 7
    },
    {
      id: 11,
      year: '1503-1519年',
      period: 'renaissance',
      title: '蒙娜丽莎',
      description: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，以其神秘的微笑而闻名于世。现藏于法国卢浮宫，是世界上最著名的绘画作品之一。',
      type: 'artifact',
      artifactId: 3
    },
    {
      id: 12,
      year: '1642年',
      period: 'renaissance',
      title: '夜巡',
      description: '荷兰巴洛克画家伦勃朗创作的油画，描绘了阿姆斯特丹民兵连队的群像。以其独特的光影效果和构图而闻名，是伦勃朗最具代表性的作品之一。',
      type: 'artifact',
      artifactId: 17
    },
    {
      id: 13,
      year: '1753年',
      period: 'ancient',
      title: '大英博物馆',
      description: '世界上规模最大、最著名的博物馆之一，收藏了世界各地的文物和珍品。成立于1753年，拥有超过800万件藏品，涵盖人类文明各个时期。',
      type: 'museum',
      museumId: 2
    },
    {
      id: 14,
      year: '1793年',
      period: 'ancient',
      title: '卢浮宫',
      description: '位于法国巴黎的世界著名艺术博物馆，以收藏古典绘画和雕刻而闻名。前身为法国王宫，现收藏有《蒙娜丽莎》、《维纳斯》等世界名作。',
      type: 'museum',
      museumId: 3
    },
    {
      id: 15,
      year: '1830年',
      period: 'renaissance',
      title: '自由引导人民',
      description: '法国浪漫主义画家欧仁·德拉克洛瓦创作的油画，描绘了1830年法国七月革命的场景。现藏于法国卢浮宫，是浪漫主义艺术的代表作。',
      type: 'artifact',
      artifactId: 13
    },
    {
      id: 16,
      year: '1870年',
      period: 'ancient',
      title: '大都会艺术博物馆',
      description: '美国最大的艺术博物馆，收藏了来自世界各地的200多万件艺术品。成立于1870年，涵盖从古代到现代的艺术作品，是纽约最重要的文化地标之一。',
      type: 'museum',
      museumId: 4
    },
    {
      id: 17,
      year: '1872年',
      period: 'ancient',
      title: '东京国立博物馆',
      description: '日本历史最悠久的博物馆，收藏了大量日本和亚洲的艺术品及文物。成立于1872年，是日本最大的博物馆，收藏有11万件文物，其中87件为国宝。',
      type: 'museum',
      museumId: 6
    },
    {
      id: 18,
      year: '1880年',
      period: 'renaissance',
      title: '思想者',
      description: '法国雕塑家奥古斯特·罗丹创作的青铜雕塑，创作于1880年。原本是为《地狱之门》设计的，后来成为独立的作品，展现了人类思考的深刻内涵。',
      type: 'artifact',
      artifactId: 10
    },
    {
      id: 19,
      year: '1888-1889年',
      period: 'renaissance',
      title: '向日葵',
      description: '荷兰后印象派画家文森特·梵高创作的系列油画作品，以向日葵为主题。梵高共创作了11幅向日葵作品，展现了其对生命力和自然美的追求。',
      type: 'artifact',
      artifactId: 9
    },
    {
      id: 20,
      year: '1889年',
      period: 'renaissance',
      title: '星夜',
      description: '荷兰后印象派画家文森特·梵高创作的油画，描绘了夜晚的星空和村庄。创作于1889年，现藏于纽约现代艺术博物馆，是梵高最具代表性的作品之一。',
      type: 'artifact',
      artifactId: 8
    },
    {
      id: 21,
      year: '1893年',
      period: 'renaissance',
      title: '呐喊',
      description: '挪威表现主义画家爱德华·蒙克创作的油画，描绘了一个在桥上呐喊的人物。创作于1893年，现藏于挪威国家美术馆，是表现主义艺术的代表作。',
      type: 'artifact',
      artifactId: 19
    },
    {
      id: 22,
      year: '1899-1926年',
      period: 'renaissance',
      title: '睡莲',
      description: '法国印象派画家克劳德·莫奈创作的系列油画作品，以睡莲为主题。共创作了250多幅，展现了莫奈对光影变化的敏锐观察，是印象派艺术的巅峰之作。',
      type: 'artifact',
      artifactId: 11
    },
    {
      id: 23,
      year: '1925年',
      period: 'ancient',
      title: '故宫博物院',
      description: '北京故宫博物院，世界上现存规模最大、保存最为完整的木质结构古建筑群。始建于明永乐十八年（1420年），是明清两朝的皇家宫殿，现为世界文化遗产。',
      type: 'museum',
      museumId: 1
    },
    {
      id: 24,
      year: '1931年',
      period: 'renaissance',
      title: '记忆的永恒',
      description: '西班牙超现实主义画家萨尔瓦多·达利创作的油画，描绘了融化的时钟和荒凉的风景。创作于1931年，现藏于纽约现代艺术博物馆，是超现实主义艺术的代表作。',
      type: 'artifact',
      artifactId: 18
    },
    {
      id: 25,
      year: '1937年',
      period: 'renaissance',
      title: '格尔尼卡',
      description: '西班牙立体主义画家巴勃罗·毕加索创作的油画，描绘了西班牙内战期间格尔尼卡镇被轰炸的场景。以其强烈的反战主题和独特的艺术风格而闻名。',
      type: 'artifact',
      artifactId: 20
    }
  ];

  @State filteredItems: TimelineItem[] = [];

  aboutToAppear() {
    this.filteredItems = this.timelineItems;
    this.sortTimeline();
    this.recordTimelineView();
  }

  async recordTimelineView() {
    try {
      const context = getContext(this) as Context;
      this.preferencesStore = await preferences.getPreferences(context, 'user_data');
      if (this.preferencesStore) {
        await this.preferencesStore.put('viewedTimeline', true);
        await this.preferencesStore.flush();
      }
    } catch (error) {
      console.error('记录浏览失败:', error);
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 导航栏
          this.NavBar()

          Column() {
            Text('历史时间线')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })

            Text('按时间顺序探索人类文明的发展历程')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .margin({ bottom: 30 })

            // 时代筛选
            this.PeriodFilter()

            // 统计信息
            Row() {
              Text(`共找到 ${this.filteredItems.length} 个历史事件`)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .layoutWeight(1)

              if (this.selectedPeriod !== 'all') {
                Button('清除筛选')
                  .type(ButtonType.Normal)
                  .backgroundColor('transparent')
                  .fontColor($r('app.color.primary_light'))
                  .fontSize(13)
                  .onClick(() => {
                    this.selectedPeriod = 'all';
                    this.applyFilter();
                  })
              }
            }
            .width('100%')
            .margin({ bottom: 20 })

            // 时间线
            this.TimelineView()
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 20, bottom: 20 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ top: 20, left: 16, right: 16, bottom: 20 })
        }
        .width('100%')
        .backgroundColor($r('app.color.app_background'))
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.isLandscape = newValue.width > newValue.height;
        })
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
          this.NavItem('首页', 'pages/Index', false)
          this.NavItem('创建新行程', 'pages/SelectMuseumsPage', false)
          this.NavItem('我的行程', 'pages/MyItineraryPage', false)
          this.NavItem('博物馆', 'pages/MuseumList', false)
          this.NavItem('藏品探索', 'pages/ArtifactExplore', false)
          this.NavItem('资讯中心', 'pages/News', false)
          this.NavItem('历史时间线', '', true)
          this.NavItem('知识问答', 'pages/Quiz', false)
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

  @Builder
  PeriodFilter() {
    Column() {
      Text('时代筛选')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1a237e')
        .margin({ bottom: 12 })

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
        this.PeriodButton('全部', 'all')
        this.PeriodButton('史前时期', 'prehistoric')
        this.PeriodButton('古代文明', 'ancient')
        this.PeriodButton('中世纪', 'medieval')
        this.PeriodButton('文艺复兴', 'renaissance')
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.divider_color'))
    .opacity(0.3)
    .borderRadius(12)
    .margin({ bottom: 25 })
  }

  @Builder
  PeriodButton(text: string, period: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedPeriod === period ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedPeriod === period ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedPeriod = period;
        this.applyFilter();
      })
  }

  @Builder
  TimelineView() {
    Column() {
      ForEach(this.filteredItems, (item: TimelineItem, index: number) => {
        this.TimelineItem(item, index)
      })
    }
    .width('100%')
  }

  @Builder
  TimelineItem(item: TimelineItem, index: number) {
    Row() {
      // 时间轴
      Column() {
        Circle()
          .width(18)
          .height(18)
          .fill(item.type === 'museum' ? '#1a237e' : '#3949ab')
          .margin({ bottom: 4 })
          .shadow({
            radius: 4,
            color: item.type === 'museum' ? '#1a237e' : '#3949ab',
            offsetX: 0,
            offsetY: 2
          })

        if (index < this.filteredItems.length - 1) {
          Column()
            .width(3)
            .height(100)
            .backgroundColor($r('app.color.divider_color'))
            .margin({ top: 4 })
        }
      }
      .width(24)
      .alignItems(HorizontalAlign.Center)

      // 内容卡片
      Column() {
        Row() {
          Text(item.year)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(item.type === 'museum' ? $r('app.color.text_primary') : $r('app.color.primary_light'))
            .layoutWeight(1)

          Text(item.type === 'museum' ? '🏛️ 博物馆' : '🎨 藏品')
            .fontSize(12)
            .fontColor(item.type === 'museum' ? $r('app.color.text_primary') : $r('app.color.primary_light'))
            .backgroundColor(item.type === 'museum' ? $r('app.color.primary_light') : $r('app.color.primary_light'))
            .opacity(0.2)
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(12)
        }
        .width('100%')
        .margin({ bottom: 10 })

        Text(item.title)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 8 })
          .width('100%')

        Text(item.description)
          .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
          .lineHeight(22)
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 14 })
          .width('100%')

        Button('查看详情')
          .type(ButtonType.Normal)
          .backgroundColor('#3949ab')
          .fontColor('#ffffff')
          .fontSize(13)
          .height(32)
          .width('100%')
          .borderRadius(16)
          .onClick(() => {
            if (item.type === 'museum' && item.museumId) {
              router.pushUrl({
                url: 'pages/MuseumDetail',
                params: {
                  id: item.museumId,
                  name: item.title,
                  description: item.description,
                  image: this.getMuseumImageById(item.museumId)
                }
              } as router.RouterOptions)
            } else if (item.type === 'artifact' && item.artifactId) {
              router.pushUrl({
                url: 'pages/ArtifactDetail',
                params: {
                  id: item.artifactId,
                  name: item.title,
                  description: item.description,
                  image: this.getArtifactImageById(item.artifactId)
                }
              } as router.RouterOptions)
            }
          })
      }
      .layoutWeight(1)
      .padding(16)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(12)
      .margin({ left: 12, bottom: 20 })
      .shadow({
        radius: 8,
        color: 'rgba(0, 0, 0, 0.1)',
        offsetX: 0,
        offsetY: 2
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }

  applyFilter() {
    if (this.selectedPeriod === 'all') {
      this.filteredItems = this.timelineItems;
    } else {
      this.filteredItems = this.timelineItems.filter(item => item.period === this.selectedPeriod);
    }
    this.sortTimeline();
  }

  sortTimeline() {
    // 按年份排序，正确处理公元前和公元后的年份
    this.filteredItems.sort((a, b) => {
      const parseYear = (yearStr: string): number => {
        // 处理公元前年份
        if (yearStr.includes('公元前')) {
          const match = yearStr.match(/公元前(\d+)/);
          if (match) {
            return -parseInt(match[1]); // 公元前年份为负数
          }
        }
        // 处理年份范围（取开始年份）
        if (yearStr.includes('-')) {
          const match = yearStr.match(/(\d+)/);
          if (match) {
            return parseInt(match[1]);
          }
        }
        // 处理单个年份
        const match = yearStr.match(/(\d+)/);
        if (match) {
          return parseInt(match[1]);
        }
        return 0;
      };

      const yearA = parseYear(a.year);
      const yearB = parseYear(b.year);
      return yearA - yearB;
    });
    this.filteredItems = [...this.filteredItems];
  }

  // 根据博物馆ID获取图片名称
  getMuseumImageById(museumId: number): string {
    const museumImageMap: Record<number, string> = {
      1: '故宫',
      2: '大英博物馆',
      3: '卢浮宫',
      4: '大都会艺术博物馆',
      5: '艾尔米塔什博物馆',
      6: '东京国立博物馆',
      7: '中国国家博物馆',
      8: '上海博物馆',
      9: '梵蒂冈博物馆',
      10: '普拉多博物馆',
      11: '乌菲兹美术馆',
      12: '埃及博物馆',
      13: '古根海姆博物馆',
      14: '泰特现代美术馆',
      15: '奥赛博物馆',
      16: '芝加哥艺术博物馆',
      17: '柏林国家博物馆',
      18: '阿姆斯特丹国家博物馆',
      19: '首尔国立中央博物馆',
      20: '印度国家博物馆',
      21: '巴西国家博物馆',
      22: '墨西哥国家人类学博物馆',
      23: '澳大利亚国家博物馆',
      24: '开普敦南非博物馆',
      25: '陕西历史博物馆',
      26: '南京博物院',
      27: '台北故宫博物院',
      28: '维多利亚与阿尔伯特博物馆',
      29: '奥赛博物馆',
      30: '波士顿美术博物馆'
    };
    return museumImageMap[museumId] || '故宫';
  }

  // 根据藏品ID获取图片名称
  getArtifactImageById(artifactId: number): string {
    const artifactImageMap: Record<number, string> = {
      1: '清明上河图',
      2: '罗塞塔石碑',
      3: '蒙娜丽莎',
      4: '兵马俑',
      5: '图坦卡蒙黄金面具',
      6: '维伦多夫的维纳斯',
      7: '大卫像',
      8: '星夜',
      9: '向日葵',
      10: '思想者',
      11: '睡莲',
      12: '最后的晚餐',
      13: '自由引导人民',
      14: '富春山居图',
      15: '掷铁饼者',
      16: '断臂的维纳斯',
      17: '夜巡',
      18: '记忆的永恒',
      19: '呐喊',
      20: '格尔尼卡'
    };
    return artifactImageMap[artifactId] || '兵马俑';
  }
}
