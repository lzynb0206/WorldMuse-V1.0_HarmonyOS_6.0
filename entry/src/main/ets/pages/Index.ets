import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State isLandscape: boolean = false; // 横屏状态
  @State carouselImages: string[] = [
    '故宫博物院',
    '大英博物馆',
    '卢浮宫',
    '大都会艺术博物馆'
  ];

  // 推荐博物馆数据
  @State recommendedMuseums: Museum[] = [
    {
      id: 1,
      name: '故宫博物院',
      description: '北京故宫博物院，世界上现存规模最大、保存最为完整的木质结构古建筑群。始建于明永乐十八年（1420年），是明清两朝的皇家宫殿，现为世界文化遗产。',
      image: '故宫',
      badge: '热门'
    },
    {
      id: 2,
      name: '大英博物馆',
      description: '世界上规模最大、最著名的博物馆之一，收藏了世界各地的文物和珍品。成立于1753年，拥有超过800万件藏品，涵盖人类文明各个时期。',
      image: '大英博物馆',
      badge: '推荐'
    },
    {
      id: 3,
      name: '卢浮宫',
      description: '位于法国巴黎的世界著名艺术博物馆，以收藏古典绘画和雕刻而闻名。前身为法国王宫，现收藏有《蒙娜丽莎》、《维纳斯》等世界名作。',
      image: '卢浮宫',
      badge: '新上线'
    },
    {
      id: 4,
      name: '大都会艺术博物馆',
      description: '美国最大的艺术博物馆，收藏了来自世界各地的200多万件艺术品。成立于1870年，涵盖从古代到现代的艺术作品，是纽约最重要的文化地标之一。',
      image: '大都会艺术博物馆',
      badge: '推荐'
    },
    {
      id: 5,
      name: '艾尔米塔什博物馆',
      description: '位于俄罗斯圣彼得堡，世界四大博物馆之一，以收藏印象派和后印象派作品闻名。前身为沙皇冬宫，现拥有超过300万件藏品，是俄罗斯最重要的艺术博物馆。',
      image: '艾尔米塔什博物馆',
      badge: '热门'
    },
    {
      id: 6,
      name: '东京国立博物馆',
      description: '日本历史最悠久的博物馆，收藏了大量日本和亚洲的艺术品及文物。成立于1872年，是日本最大的博物馆，收藏有11万件文物，其中87件为国宝。',
      image: '东京国立博物馆',
      badge: '新上线'
    }
  ];

  // 推荐藏品数据
  @State recommendedArtifacts: Artifact[] = [
    {
      id: 1,
      name: '清明上河图',
      era: 'ancient',
      region: 'asia',
      material: 'paper',
      theme: 'court',
      tags: ['宋代', '中国', '绢本', '绘画'],
      description: '北宋画家张择端所作，描绘了北宋都城汴京的城市面貌和当时社会各阶层人民的生活状况。全长528.7厘米，高24.8厘米，是中国古代风俗画的巅峰之作。',
      image: '清明上河图',
      badge: '热门'
    },
    {
      id: 3,
      name: '蒙娜丽莎',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'renaissance',
      tags: ['文艺复兴', '意大利', '油画', '肖像'],
      description: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，以其神秘的微笑而闻名于世。创作于1503-1519年，现藏于法国卢浮宫。',
      image: '蒙娜丽莎',
      badge: '推荐'
    },
    {
      id: 4,
      name: '兵马俑',
      era: 'ancient',
      region: 'asia',
      material: 'terracotta',
      theme: 'war',
      tags: ['秦代', '中国', '陶器', '雕塑'],
      description: '秦始皇陵的陪葬坑中的陶俑，规模宏大，造型逼真，是中国古代雕塑艺术的杰作。每个兵马俑的面部表情、发型、服饰都各不相同。',
      image: '兵马俑',
      badge: '热门'
    },
    {
      id: 7,
      name: '大卫像',
      era: 'renaissance',
      region: 'europe',
      material: 'stone',
      theme: 'renaissance',
      tags: ['文艺复兴', '意大利', '大理石', '雕塑'],
      description: '意大利文艺复兴时期雕塑家米开朗基罗创作的大理石雕塑，高5.17米，创作于1501-1504年。描绘了《圣经》中大卫王准备与巨人歌利亚战斗的场景。',
      image: '大卫像',
      badge: '推荐'
    },
    {
      id: 8,
      name: '星夜',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'daily',
      tags: ['后印象派', '荷兰', '油画', '风景'],
      description: '荷兰后印象派画家文森特·梵高创作的油画，描绘了夜晚的星空和村庄。创作于1889年，现藏于纽约现代艺术博物馆，是梵高最具代表性的作品之一。',
      image: '星夜',
      badge: '新上线'
    },
    {
      id: 13,
      name: '自由引导人民',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'war',
      tags: ['浪漫主义', '法国', '油画', '历史画'],
      description: '法国浪漫主义画家欧仁·德拉克洛瓦创作的油画，描绘了1830年法国七月革命的场景。创作于1830年，现藏于法国卢浮宫，是法国浪漫主义绘画的代表作。',
      image: '自由引导人民',
      badge: '推荐'
    }
  ];

  // 历史时间线数据（首页展示用）
  @State timelineItems: TimelineItem[] = [
    {
      id: 1,
      year: '公元前30000年',
      period: 'prehistoric',
      title: '维伦多夫的维纳斯',
      description: '旧石器时代的小型女性雕像，发现于奥地利，是已知最早的人类艺术表现之一。',
      type: 'artifact',
      artifactId: 6
    },
    {
      id: 4,
      year: '公元前196年',
      period: 'ancient',
      title: '罗塞塔石碑',
      description: '制作于公元前196年，刻有古埃及国王托勒密五世登基的诏书，是解密古埃及象形文字的关键。',
      type: 'artifact',
      artifactId: 2
    },
    {
      id: 7,
      year: '公元1100-1200年',
      period: 'ancient',
      title: '清明上河图',
      description: '北宋画家张择端所作，描绘了北宋都城汴京的城市面貌和当时社会各阶层人民的生活状况。',
      type: 'artifact',
      artifactId: 1
    },
    {
      id: 10,
      year: '1503-1519年',
      period: 'renaissance',
      title: '蒙娜丽莎',
      description: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，以其神秘的微笑而闻名于世。',
      type: 'artifact',
      artifactId: 3
    }
  ];

  // 最新资讯数据
  @State newsItems: NewsItem[] = [
    {
      id: 1,
      title: '2024年全国博物馆接待观众14.9亿人次创历史新高',
      category: 'industry',
      date: '2025-05-18',
      views: 3256,
      tags: ['行业新闻', '国家文物局', '统计数据'],
      description: '国家文物局发布数据显示，2024年全国博物馆举办陈列展览4.3万个、教育活动51.1万场，接待观众14.9亿人次，创历史新高。这一数据充分体现了我国博物馆事业的蓬勃发展，博物馆已成为人民群众精神文化生活的重要组成部分。',
      image: '博物馆统计'
    },
    {
      id: 2,
      title: '全国备案博物馆总数达7046家 免费开放率91.46%',
      category: 'industry',
      date: '2025-05-18',
      views: 2845,
      tags: ['行业新闻', '博物馆发展', '免费开放'],
      description: '截至2024年底，全国备案博物馆总数达7046家，较上一年增加213家，实现每20万人拥有一家博物馆，博物馆免费开放率达91.46%。这意味着全国有超过6400家博物馆免费向公众开放，让更多人能够享受到博物馆的文化服务。',
      image: '博物馆发展'
    },
    {
      id: 3,
      title: '香港故宫文化博物馆举办"古埃及文明大展"',
      category: 'exhibition',
      date: '2025-10-28',
      views: 1892,
      tags: ['展览预告', '香港故宫', '古埃及'],
      description: '香港故宫文化博物馆与埃及最高文物委员会联合主办的"古埃及文明大展"将于2025年11月20日开幕，展出250件古埃及珍贵文物。这是香港故宫文化博物馆自开馆以来规模最大的国际展览之一，展品包括法老雕像、木乃伊、珠宝、壁画等。',
      image: '古埃及展览'
    },
    {
      id: 4,
      title: '2024年度全国百大热门博物馆榜单发布',
      category: 'industry',
      date: '2025-01-13',
      views: 2156,
      tags: ['行业新闻', '博物馆榜单', '中博热搜榜'],
      description: '中国文物交流中心指导发布的"中博热搜榜"公布了2024年度全国热门博物馆百强榜单，同时发布了全国美术馆和纪念馆的年度热门百强榜单。榜单显示，故宫博物院、中国国家博物馆、上海博物馆等知名博物馆位居前列。',
      image: '博物馆榜单'
    },
    {
      id: 5,
      title: '上海博物馆推出"金字塔之巅：古埃及文明大展"',
      category: 'exhibition',
      date: '2024-07-15',
      views: 3421,
      tags: ['展览预告', '上海博物馆', '古埃及'],
      description: '上海博物馆于2024年7月推出"金字塔之巅：古埃及文明大展"，并创新打造"一站式文旅体验新场景"，包括允许观众携带宠物猫参观的"博物馆奇喵夜"活动。展览通过沉浸式体验、多媒体展示等方式，让观众深入了解古埃及文明。',
      image: '古埃及大展'
    },
    {
      id: 6,
      title: '梵蒂冈博物馆2023年参观人数达680万人次',
      category: 'industry',
      date: '2024-12-20',
      views: 1678,
      tags: ['行业新闻', '梵蒂冈博物馆', '参观数据'],
      description: '2023年，梵蒂冈博物馆的参观人数达到680万人次，位居全球第二，仅次于卢浮宫，展现了世界顶级博物馆的吸引力。梵蒂冈博物馆收藏了大量珍贵的艺术品和文物，包括米开朗基罗的《创世纪》和《最后的审判》等世界名作。',
      image: '梵蒂冈博物馆'
    }
  ];

  // 按日期排序，最新的在前
  sortNewsByDate(newsArray: NewsItem[]): NewsItem[] {
    return newsArray.sort((a, b) => {
      // 日期格式：'YYYY-MM-DD'，可以直接字符串比较
      return b.date.localeCompare(a.date);
    });
  }

  @StorageLink('hasSeenOnboarding') hasSeenOnboarding: boolean = false;

  aboutToAppear() {
    // 初始化时对资讯进行排序
    this.newsItems = this.sortNewsByDate(this.newsItems);
    
    // 检查是否首次启动，如果是则跳转到引导页
    if (!this.hasSeenOnboarding) {
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/OnboardingPage'
        } as router.RouterOptions);
      }, 100);
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 导航栏
          this.NavBar()

          // 轮播图
          this.CarouselSection()

          // 今日推荐博物馆
          this.RecommendedMuseums()

          // 今日推荐藏品
          this.RecommendedArtifacts()

          // 最新资讯
          this.NewsSection()

          // 历史时间线
          this.TimelineSection()

          // 快捷入口
          this.QuickLinks()

          // 联系信息
          this.ContactSection()
        }
        .width('100%')
        .backgroundColor($r('app.color.app_background'))
        .onAreaChange((oldValue: Area, newValue: Area) => {
          // 通过区域尺寸判断横竖屏
          this.isLandscape = newValue.width > newValue.height;
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  // 导航栏组件
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
          this.NavItem('首页', '', true)
          this.NavItem('创建新行程', 'pages/SelectMuseumsPage', false)
          this.NavItem('我的行程', 'pages/MyItineraryPage', false)
          this.NavItem('博物馆', 'pages/MuseumList', false)
          this.NavItem('藏品探索', 'pages/ArtifactExplore', false)
          this.NavItem('资讯中心', 'pages/News', false)
          this.NavItem('历史时间线', 'pages/Timeline', false)
          this.NavItem('知识问答', 'pages/Quiz', false)
          this.NavItem('寻宝游戏', 'pages/TreasureHuntPage', false)
          this.NavItem('成就系统', 'pages/Achievements', false)
          this.NavItem('小工具集', 'pages/ToolsPage', false)
          this.NavItem('设置', 'pages/SettingsPage', false)
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

  // 轮播图组件
  @Builder
  CarouselSection() {
    Stack() {
      Swiper() {
        ForEach(this.carouselImages, (item: string, index: number) => {
          Stack() {
            Image(this.getMuseumImage(item))
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
              .alt(item)
              .syncLoad(true)
              .onError(() => {
                // 图片加载失败时的处理
              })
          }
          .width('100%')
          .height('100%')
        })
      }
      .index(this.currentIndex)
      .indicator(true)
      .duration(600)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .autoPlay(true)
      .interval(4000)
      .itemSpace(0)

      Column() {
        Text('探索全球博物馆，开启文化之旅')
          .fontSize(this.isLandscape ? 26 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_inverse'))
          .lineHeight(this.isLandscape ? 36 : 30)
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textShadow({ radius: 8, color: '#000000', offsetX: 2, offsetY: 2 })
          .width('100%')
          .padding({ left: this.isLandscape ? 20 : 16, right: this.isLandscape ? 20 : 16 })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
    }
    .width('100%')
    .height(this.isLandscape ? 400 : 350)
    .margin({ top: 0, bottom: 30 })
  }


  // 推荐博物馆组件
  @Builder
  RecommendedMuseums() {
    Column() {
      Row() {
        Text('今日推荐博物馆')
          .fontSize(this.isLandscape ? 26 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 36 : 30)
          .layoutWeight(1)
        
        Text('更多')
          .fontSize(14)
          .fontColor($r('app.color.primary_light'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/MuseumList' } as router.RouterOptions)
          })
      }
      .width('100%')
      .margin({ bottom: this.isLandscape ? 20 : 16 })
      .alignItems(VerticalAlign.Center)

      Grid() {
        ForEach(this.recommendedMuseums, (museum: Museum) => {
          GridItem() {
            this.MuseumCard(museum)
          }
        })
      }
      .columnsTemplate(this.isLandscape ? '1fr 1fr 1fr' : '1fr 1fr')
      .columnsGap(this.isLandscape ? 16 : 12)
      .rowsGap(this.isLandscape ? 16 : 12)
      .width('100%')
    }
    .width('100%')
    .padding({ 
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16, 
      top: this.isLandscape ? 24 : 20, 
      bottom: this.isLandscape ? 32 : 24 
    })
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 12, left: 16, right: 16 })
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(57, 73, 171, 0.08)',
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 18,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 4
    })
  }

  // 推荐藏品组件
  @Builder
  RecommendedArtifacts() {
    Column() {
      Row() {
        Text('今日推荐藏品')
          .fontSize(this.isLandscape ? 26 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 36 : 30)
          .layoutWeight(1)
        
        Text('更多')
          .fontSize(14)
          .fontColor($r('app.color.primary_light'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/ArtifactExplore' } as router.RouterOptions)
          })
      }
      .width('100%')
      .margin({ bottom: this.isLandscape ? 20 : 16 })
      .alignItems(VerticalAlign.Center)

      Grid() {
        ForEach(this.recommendedArtifacts, (artifact: Artifact) => {
          GridItem() {
            this.ArtifactCard(artifact)
          }
        })
      }
      .columnsTemplate(this.isLandscape ? '1fr 1fr 1fr' : '1fr 1fr')
      .columnsGap(this.isLandscape ? 16 : 12)
      .rowsGap(this.isLandscape ? 16 : 12)
      .width('100%')
    }
    .width('100%')
    .padding({ 
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16, 
      top: this.isLandscape ? 24 : 20, 
      bottom: this.isLandscape ? 32 : 24 
    })
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 12, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  MuseumCard(museum: Museum) {
    Column() {
      Stack() {
        // 图片占位，可以根据museum.image加载对应图片
        Image(this.getMuseumImage(museum.image))
          .width('100%')
          .height(this.isLandscape ? 180 : 130)
          .objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: 12, topRight: 12 })
          .alt(museum.name)
          .syncLoad(true)
          .onError(() => {
            // 图片加载失败时的处理
          })

        if (museum.badge) {
          Row() {
            Blank()
            Text(museum.badge)
              .fontSize(this.isLandscape ? 11 : 10)
              .fontColor($r('app.color.text_inverse'))
              .fontWeight(FontWeight.Medium)
              .backgroundColor($r('app.color.accent_color'))
              .padding({ left: this.isLandscape ? 10 : 8, right: this.isLandscape ? 10 : 8, top: this.isLandscape ? 5 : 4, bottom: this.isLandscape ? 5 : 4 })
              .borderRadius(12)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({ maxWidth: '50%' })
          }
          .width('100%')
          .height('100%')
          .padding({ top: this.isLandscape ? 10 : 8, right: this.isLandscape ? 10 : 8 })
          .justifyContent(FlexAlign.End)
          .alignItems(VerticalAlign.Top)
        }
      }
      .width('100%')
      .height(this.isLandscape ? 180 : 130)
      .clip(true)

      Column() {
        Text(museum.name)
          .fontSize(this.isLandscape ? 18 : 15)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 24 : 20)
          .margin({ bottom: this.isLandscape ? 8 : 5, top: this.isLandscape ? 12 : 8 })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(museum.description)
          .fontSize(this.isLandscape ? 13 : 11)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(this.isLandscape ? 20 : 16)
          .maxLines(this.isLandscape ? 3 : 2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 12 : 8 })

        Button('查看详情')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_inverse'))
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .height(this.isLandscape ? 38 : 32)
          .fontSize(this.isLandscape ? 14 : 12)
          .borderRadius(19)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/MuseumDetail',
              params: {
                id: museum.id,
                name: museum.name,
                description: museum.description,
                image: museum.image
              }
            } as router.RouterOptions)
          })
      }
      .width('100%')
      .padding({ 
        left: this.isLandscape ? 16 : 12, 
        right: this.isLandscape ? 16 : 12, 
        bottom: this.isLandscape ? 16 : 12 
      })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .border({
      width: 1,
      color: $r('app.color.border_color'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 16,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 4
    })
  }

  @Builder
  ArtifactCard(artifact: Artifact) {
    Column() {
      Stack() {
        Image(this.getArtifactImage(artifact.image))
          .width('100%')
          .height(this.isLandscape ? 180 : 130)
          .objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: 12, topRight: 12 })
          .alt(artifact.name)
          .syncLoad(true)
          .onError(() => {
            // 图片加载失败时的处理
          })

        if (artifact.badge) {
          Row() {
            Blank()
            Text(artifact.badge)
              .fontSize(this.isLandscape ? 11 : 10)
              .fontColor($r('app.color.text_inverse'))
              .fontWeight(FontWeight.Medium)
              .backgroundColor($r('app.color.accent_color'))
              .padding({ left: this.isLandscape ? 10 : 8, right: this.isLandscape ? 10 : 8, top: this.isLandscape ? 5 : 4, bottom: this.isLandscape ? 5 : 4 })
              .borderRadius(12)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({ maxWidth: '50%' })
          }
          .width('100%')
          .height('100%')
          .padding({ top: this.isLandscape ? 10 : 8, right: this.isLandscape ? 10 : 8 })
          .justifyContent(FlexAlign.End)
          .alignItems(VerticalAlign.Top)
        }
      }
      .width('100%')
      .height(this.isLandscape ? 180 : 130)
      .clip(true)

      Column() {
        Text(artifact.name)
          .fontSize(this.isLandscape ? 18 : 15)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 24 : 20)
          .margin({ bottom: this.isLandscape ? 8 : 5, top: this.isLandscape ? 12 : 8 })
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(artifact.description)
          .fontSize(this.isLandscape ? 13 : 11)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(this.isLandscape ? 20 : 16)
          .maxLines(this.isLandscape ? 3 : 2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 12 : 8 })

        Button('查看详情')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_inverse'))
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .height(this.isLandscape ? 38 : 32)
          .fontSize(this.isLandscape ? 14 : 12)
          .borderRadius(19)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ArtifactDetail',
              params: {
                id: artifact.id,
                name: artifact.name,
                description: artifact.description,
                image: artifact.image
              }
            } as router.RouterOptions)
          })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(this.isLandscape ? 360 : 280)
    .padding({ left: this.isLandscape ? 12 : 10, right: this.isLandscape ? 12 : 10, bottom: this.isLandscape ? 12 : 10 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .border({
      width: 1,
      color: $r('app.color.border_color'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 16,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 4
    })
  }

  getMuseumImage(imageName: string): Resource | string {
    // 使用本地图片资源，与images文件夹中的图片对应
    const imageMap: Record<string, Resource> = {
      '故宫': $rawfile('故宫.png'),
      '大英博物馆': $rawfile('大英博物馆.png'),
      '卢浮宫': $rawfile('卢浮宫.png'),
      '大都会艺术博物馆': $rawfile('大都会艺术博物馆.png'),
      '艾尔米塔什博物馆': $rawfile('艾尔米塔什博物馆.webp'),
      '东京国立博物馆': $rawfile('东京国立博物馆.jpg'),
      '故宫博物院': $rawfile('故宫.png'),
      '中国国家博物馆': $rawfile('中国国家博物馆.webp'),
      '上海博物馆': $rawfile('上海博物馆.jpg'),
      '梵蒂冈博物馆': $rawfile('梵蒂冈博物馆.jpg'),
      '普拉多博物馆': $rawfile('普拉多博物馆.webp'),
      '乌菲兹美术馆': $rawfile('乌菲兹美术馆.jpg'),
      '埃及博物馆': $rawfile('埃及博物馆.webp'),
      '古根海姆博物馆': $rawfile('古根海姆博物馆.jpg'),
      '泰特现代美术馆': $rawfile('泰特现代美术馆.webp'),
      '奥赛博物馆': $rawfile('奥赛博物馆.webp'),
      '芝加哥艺术博物馆': $rawfile('芝加哥艺术博物馆.jpg'),
      '柏林国家博物馆': $rawfile('柏林国家博物馆.webp'),
      '阿姆斯特丹国家博物馆': $rawfile('阿姆斯特丹国家博物馆.webp'),
      '首尔国立中央博物馆': $rawfile('首尔国立中央博物馆.webp'),
      '印度国家博物馆': $rawfile('印度国家博物馆.jpg'),
      '巴西国家博物馆': $rawfile('巴西国家博物馆.webp'),
      '墨西哥国家人类学博物馆': $rawfile('墨西哥国家人类学博物馆.webp'),
      '澳大利亚国家博物馆': $rawfile('澳大利亚国家博物馆.jpg'),
      '开普敦南非博物馆': $rawfile('开普敦南非博物馆.webp'),
      '陕西历史博物馆': $rawfile('陕西历史博物馆.webp'),
      '南京博物院': $rawfile('南京博物馆.jpg'), // 图片文件名是南京博物馆.jpg
      '台北故宫博物院': $rawfile('台北故宫博物院.jpg'),
      '维多利亚与阿尔伯特博物馆': $rawfile('维多利亚与阿尔伯特博物馆.webp'),
      '波士顿美术博物馆': $rawfile('波士顿美术博物馆.jpg')
    };
    return imageMap[imageName] || $rawfile('故宫.png');
  }

  getArtifactImage(imageName: string): Resource | string {
    // 使用本地图片资源，与images文件夹中的图片对应
    const imageMap: Record<string, Resource> = {
      '清明上河图': $rawfile('清明上河图.png'),
      '罗塞塔石碑': $rawfile('罗塞塔石碑.png'),
      '蒙娜丽莎': $rawfile('蒙娜丽莎.png'),
      '兵马俑': $rawfile('兵马俑.png'),
      '图坦卡蒙黄金面具': $rawfile('图坦卡蒙黄金面具.png'),
      '维伦多夫的维纳斯': $rawfile('维伦多夫的维纳斯.png'),
      '大卫像': $rawfile('大卫像.webp'),
      '星夜': $rawfile('星夜.webp'),
      '向日葵': $rawfile('向日葵.jpg'),
      '思想者': $rawfile('思想者.webp'),
      '睡莲': $rawfile('睡莲.webp'),
      '最后的晚餐': $rawfile('最后的晚餐.webp'),
      '自由引导人民': $rawfile('自由引导人民.png'),
      '富春山居图': $rawfile('富春山居图.webp'),
      '掷铁饼者': $rawfile('掷铁饼者.jpg'),
      '断臂的维纳斯': $rawfile('断臂的维纳斯.jpg'),
      '夜巡': $rawfile('夜巡.webp'),
      '记忆的永恒': $rawfile('记忆的永恒.webp'),
      '呐喊': $rawfile('呐喊.webp'),
      '格尔尼卡': $rawfile('格尔尼卡.webp')
    };
    return imageMap[imageName] || $rawfile('兵马俑.png');
  }

  // 最新资讯组件
  @Builder
  NewsSection() {
    Column() {
      Row() {
        Text('最新资讯')
          .fontSize(this.isLandscape ? 26 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 36 : 30)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor($r('app.color.primary_light'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/News' } as router.RouterOptions)
          })
      }
      .width('100%')
      .margin({ bottom: this.isLandscape ? 20 : 16 })
      .alignItems(VerticalAlign.Center)

      Column() {
        ForEach(this.newsItems, (news: NewsItem) => {
          this.NewsCard(news)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ 
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16, 
      top: this.isLandscape ? 24 : 20, 
      bottom: this.isLandscape ? 32 : 24 
    })
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 12, left: 16, right: 16 })
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(57, 73, 171, 0.08)',
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 18,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 4
    })
  }

  // 历史时间线组件
  @Builder
  TimelineSection() {
    Column() {
      Row() {
        Text('历史时间线')
          .fontSize(this.isLandscape ? 26 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 36 : 30)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor($r('app.color.primary_light'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/Timeline' } as router.RouterOptions)
          })
      }
      .width('100%')
      .margin({ bottom: this.isLandscape ? 20 : 16 })
      .alignItems(VerticalAlign.Center)

      Column() {
        ForEach(this.timelineItems, (item: TimelineItem) => {
          this.TimelineCard(item)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ 
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16, 
      top: this.isLandscape ? 24 : 20, 
      bottom: this.isLandscape ? 32 : 24 
    })
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 12, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  TimelineCard(item: TimelineItem) {
    Row() {
      Column() {
        Text(item.year)
          .fontSize(this.isLandscape ? 16 : 14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_light'))
          .lineHeight(this.isLandscape ? 22 : 18)
          .margin({ bottom: this.isLandscape ? 4 : 2 })
          .width('100%')

        Text(item.title)
          .fontSize(this.isLandscape ? 15 : 13)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 20 : 16)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 6 : 4 })
          .width('100%')

        Text(item.description)
          .fontSize(this.isLandscape ? 12 : 10)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(this.isLandscape ? 18 : 14)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 8 : 5 })
          .width('100%')

        Row() {
          if (item.type === 'museum') {
            Text('博物馆')
              .fontSize(this.isLandscape ? 9 : 8)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor($r('app.color.accent_color'))
              .padding({ left: this.isLandscape ? 8 : 6, right: this.isLandscape ? 8 : 6, top: this.isLandscape ? 3 : 2, bottom: this.isLandscape ? 3 : 2 })
              .borderRadius(8)
              .margin({ right: this.isLandscape ? 6 : 4 })
          } else {
            Text('藏品')
              .fontSize(this.isLandscape ? 9 : 8)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor($r('app.color.button_primary'))
              .padding({ left: this.isLandscape ? 8 : 6, right: this.isLandscape ? 8 : 6, top: this.isLandscape ? 3 : 2, bottom: this.isLandscape ? 3 : 2 })
              .borderRadius(8)
              .margin({ right: this.isLandscape ? 6 : 4 })
          }
        }
        .width('100%')
        .margin({ bottom: this.isLandscape ? 4 : 3 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
    }
    .width('100%')
    .padding(this.isLandscape ? 16 : 12)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(14)
    .border({
      width: 1,
      color: 'rgba(57, 73, 171, 0.08)',
      style: BorderStyle.Solid
    })
    .margin({ bottom: this.isLandscape ? 14 : 8 })
    .shadow({
      radius: 14,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 3
    })
    .onClick(() => {
      if (item.type === 'museum' && item.museumId) {
        router.pushUrl({
          url: 'pages/MuseumDetail',
          params: {
            id: item.museumId,
            name: item.title,
            description: item.description,
            image: '故宫'
          }
        } as router.RouterOptions)
      } else if (item.type === 'artifact' && item.artifactId) {
        router.pushUrl({
          url: 'pages/ArtifactDetail',
          params: {
            id: item.artifactId,
            name: item.title,
            description: item.description,
            image: item.title
          }
        } as router.RouterOptions)
      }
    })
  }

  @Builder
  NewsCard(news: NewsItem) {
    Row() {
      Image(this.getNewsImage(news.image))
        .width(this.isLandscape ? 100 : 60)
        .height(this.isLandscape ? 100 : 60)
        .objectFit(ImageFit.Cover)
        .borderRadius(10)
        .margin({ right: this.isLandscape ? 12 : 8 })
        .alt(news.title)
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column() {
        Text(news.title)
          .fontSize(this.isLandscape ? 15 : 12)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 20 : 16)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 6 : 3 })
          .width('100%')

        Text(news.description)
          .fontSize(this.isLandscape ? 12 : 10)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(this.isLandscape ? 18 : 14)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 8 : 5 })
          .width('100%')

        Column() {
          Row() {
            ForEach(news.tags, (tag: string) => {
              Text(tag)
                .fontSize(this.isLandscape ? 9 : 8)
                .fontColor($r('app.color.primary_light'))
                .backgroundColor($r('app.color.primary_light'))
                .opacity(0.2)
                .padding({ 
                  left: this.isLandscape ? 6 : 4, 
                  right: this.isLandscape ? 6 : 4, 
                  top: this.isLandscape ? 3 : 2, 
                  bottom: this.isLandscape ? 3 : 2 
                })
                .borderRadius(8)
                .margin({ right: this.isLandscape ? 4 : 3 })
            })
          }
          .width('100%')
          .margin({ bottom: this.isLandscape ? 4 : 3 })

          Row() {
            Blank()
            Text(`${news.date} · ${news.views}浏览`)
              .fontSize(this.isLandscape ? 10 : 8)
              .fontColor($r('app.color.text_tertiary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height(this.isLandscape ? undefined : 90)
    .padding(this.isLandscape ? 16 : 8)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(14)
    .border({
      width: 1,
      color: 'rgba(57, 73, 171, 0.08)',
      style: BorderStyle.Solid
    })
    .margin({ bottom: this.isLandscape ? 14 : 6 })
    .shadow({
      radius: 14,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 3
    })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/NewsDetail',
        params: {
          id: news.id,
          title: news.title,
          category: news.category,
          date: news.date,
          views: news.views,
          tags: news.tags,
          description: news.description,
          image: news.image
        }
      } as router.RouterOptions)
    })
  }

  getNewsImage(imageName: string): Resource | string {
    // 使用本地图片资源
    const imageMap: Record<string, Resource> = {
      '博物馆统计': $rawfile('大英博物馆.png'),
      '博物馆发展': $rawfile('大英博物馆.png'),
      '古埃及展览': $rawfile('古埃及文明.png'),
      '博物馆榜单': $rawfile('大英博物馆.png'),
      '古埃及大展': $rawfile('古埃及文明.png'),
      '梵蒂冈博物馆': $rawfile('卢浮宫.png'),
      '卢浮宫特展': $rawfile('卢浮宫特展.png'),
      '青铜兵器': $rawfile('青铜器复刻.png'),
      '数字馆藏': $rawfile('大英博物馆.png'),
      '故宫展览': $rawfile('故宫.png'),
      '木乃伊': $rawfile('古埃及文明.png'),
      '博物馆协会': $rawfile('大英博物馆.png')
    };
    return imageMap[imageName] || $rawfile('大英博物馆.png');
  }

  // 快捷入口组件
  @Builder
  QuickLinks() {
    Column() {
      Text('快捷入口')
        .fontSize(this.isLandscape ? 26 : 22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .lineHeight(this.isLandscape ? 36 : 30)
        .margin({ bottom: this.isLandscape ? 20 : 16 })
        .alignSelf(ItemAlign.Start)

      Grid() {
        GridItem() {
          this.QuickLinkCard('创建新行程', '选择博物馆和兴趣，生成个性化推荐', 'pages/SelectMuseumsPage')
        }
        GridItem() {
          this.QuickLinkCard('我的行程', '查看和管理您的专属参观行程', 'pages/MyItineraryPage')
        }
        GridItem() {
          this.QuickLinkCard('博物馆', '探索全球顶级博物馆，了解世界文化遗产', 'pages/MuseumList')
        }
        GridItem() {
          this.QuickLinkCard('藏品探索', '按分类浏览全球博物馆珍贵藏品', 'pages/ArtifactExplore')
        }
        GridItem() {
          this.QuickLinkCard('资讯中心', '获取最新展览预告和行业新闻', 'pages/News')
        }
        GridItem() {
          this.QuickLinkCard('历史时间线', '按时间顺序探索人类文明发展历程', 'pages/Timeline')
        }
        GridItem() {
          this.QuickLinkCard('知识问答', '测试你对博物馆和文物的了解', 'pages/Quiz')
        }
        GridItem() {
          this.QuickLinkCard('寻宝游戏', '根据线索找出正确的文物', 'pages/TreasureHuntPage')
        }
        GridItem() {
          this.QuickLinkCard('成就系统', '查看你的探索成就和收藏记录', 'pages/Achievements')
        }
        GridItem() {
          this.QuickLinkCard('小工具集', '日历、换算器、颜色拾取等实用工具', 'pages/ToolsPage')
        }
      }
      .columnsTemplate(this.isLandscape ? '1fr 1fr 1fr' : '1fr 1fr')
      .columnsGap(this.isLandscape ? 16 : 12)
      .rowsGap(this.isLandscape ? 16 : 12)
      .width('100%')
    }
    .width('100%')
    .padding({ 
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16, 
      top: this.isLandscape ? 24 : 20, 
      bottom: this.isLandscape ? 32 : 24 
    })
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 12, left: 16, right: 16 })
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(57, 73, 171, 0.08)',
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 18,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 4
    })
  }


  @Builder
  QuickLinkCard(title: string, description: string, url: string) {
    Column() {
      Text(title)
        .fontSize(this.isLandscape ? 16 : 14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .lineHeight(this.isLandscape ? 22 : 19)
        .margin({ bottom: this.isLandscape ? 8 : 5, top: this.isLandscape ? 16 : 10 })

      Text(description)
        .fontSize(this.isLandscape ? 13 : 11)
        .fontColor('#666666')
        .lineHeight(this.isLandscape ? 20 : 16)
        .margin({ bottom: this.isLandscape ? 12 : 8 })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)

      Button('查看')
        .type(ButtonType.Normal)
        .backgroundColor('#3949ab')
        .fontColor('#ffffff')
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .height(this.isLandscape ? 34 : 30)
        .fontSize(this.isLandscape ? 13 : 11)
        .borderRadius(17)
        .onClick(() => {
          router.pushUrl({ url: url } as router.RouterOptions)
        })
    }
    .width('100%')
    .height(this.isLandscape ? 160 : 140)
    .padding({ left: this.isLandscape ? 16 : 12, right: this.isLandscape ? 16 : 12, bottom: this.isLandscape ? 16 : 12, top: this.isLandscape ? 16 : 12 })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .border({
      width: 1,
      color: $r('app.color.border_color'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 16,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 4
    })
  }

  // 联系信息组件
  @Builder
  ContactSection() {
    Column() {
      Text('联系我们')
        .fontSize(this.isLandscape ? 20 : 18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#ffffff')
        .margin({ bottom: this.isLandscape ? 12 : 10 })
      
      Text('如有问题，可以发送邮箱至：')
        .fontSize(this.isLandscape ? 14 : 13)
        .fontColor('#ffffff')
        .opacity(0.9)
        .margin({ bottom: this.isLandscape ? 6 : 4 })
      
      Text('2945428215@qq.com')
        .fontSize(this.isLandscape ? 15 : 14)
        .fontColor('#ffffff')
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ 
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16,
      top: this.isLandscape ? 24 : 20,
      bottom: this.isLandscape ? 24 : 20
    })
    .backgroundColor('#3949ab')
    .margin({ 
      top: this.isLandscape ? 20 : 16,
      left: this.isLandscape ? 20 : 16, 
      right: this.isLandscape ? 20 : 16, 
      bottom: this.isLandscape ? 24 : 20 
    })
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(255, 255, 255, 0.2)',
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 20,
      color: 'rgba(57, 73, 171, 0.4)',
      offsetX: 0,
      offsetY: 6
    })
  }

}

// 数据模型
interface Museum {
  id: number;
  name: string;
  description: string;
  image: string;
  badge?: string;
}

interface NewsItem {
  id: number;
  title: string;
  category: string;
  date: string;
  views: number;
  tags: string[];
  description: string;
  image: string;
}

interface Artifact {
  id: number;
  name: string;
  era: string;
  region: string;
  material: string;
  theme: string;
  tags: string[];
  description: string;
  image: string;
  badge?: string;
}

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
