import { router } from '@kit.ArkUI';

@Entry
@Component
struct News {
  @State selectedCategory: string = 'all';
  @State isLandscape: boolean = false;

  @State newsItems: NewsItem[] = [
    {
      id: 1,
      title: '2024年全国博物馆接待观众14.9亿人次创历史新高',
      category: 'industry',
      date: '2025-05-18',
      views: 3256,
      tags: ['行业新闻', '国家文物局', '统计数据'],
      description: '国家文物局发布数据显示，2024年全国博物馆举办陈列展览4.3万个、教育活动51.1万场，接待观众14.9亿人次，创历史新高。这一数据充分体现了我国博物馆事业的蓬勃发展，博物馆已成为人民群众精神文化生活的重要组成部分，在传承中华优秀传统文化、增强文化自信方面发挥了重要作用。',
      image: '博物馆统计'
    },
    {
      id: 2,
      title: '全国备案博物馆总数达7046家 免费开放率91.46%',
      category: 'industry',
      date: '2025-05-18',
      views: 2845,
      tags: ['行业新闻', '博物馆发展', '免费开放'],
      description: '截至2024年底，全国备案博物馆总数达7046家，较上一年增加213家，实现每20万人拥有一家博物馆，博物馆免费开放率达91.46%。这意味着全国有超过6400家博物馆免费向公众开放，让更多人能够享受到博物馆的文化服务，体现了文化事业的全面进步。',
      image: '博物馆发展'
    },
    {
      id: 3,
      title: '香港故宫文化博物馆举办"古埃及文明大展"',
      category: 'exhibition',
      date: '2025-10-28',
      views: 1892,
      tags: ['展览预告', '香港故宫', '古埃及'],
      description: '香港故宫文化博物馆与埃及最高文物委员会联合主办的"古埃及文明大展"将于2025年11月20日开幕，展出250件古埃及珍贵文物。这是香港故宫文化博物馆自开馆以来规模最大的国际展览之一，展品包括法老雕像、木乃伊、珠宝、壁画等，涵盖了古埃及文明从早期王朝到托勒密王朝的各个历史时期。',
      image: '古埃及展览'
    },
    {
      id: 4,
      title: '2024年度全国百大热门博物馆榜单发布',
      category: 'industry',
      date: '2025-01-13',
      views: 2156,
      tags: ['行业新闻', '博物馆榜单', '中博热搜榜'],
      description: '中国文物交流中心指导发布的"中博热搜榜"公布了2024年度全国热门博物馆百强榜单，同时发布了全国美术馆和纪念馆的年度热门百强榜单。榜单显示，故宫博物院、中国国家博物馆、上海博物馆等知名博物馆位居前列，这些博物馆在展览质量、公共服务、数字化建设等方面表现突出，深受观众喜爱。',
      image: '博物馆榜单'
    },
    {
      id: 5,
      title: '上海博物馆推出"金字塔之巅：古埃及文明大展"',
      category: 'exhibition',
      date: '2024-07-15',
      views: 3421,
      tags: ['展览预告', '上海博物馆', '古埃及'],
      description: '上海博物馆于2024年7月推出"金字塔之巅：古埃及文明大展"，并创新打造"一站式文旅体验新场景"，包括允许观众携带宠物猫参观的"博物馆奇喵夜"活动。展览展出了来自大英博物馆等世界知名博物馆的古埃及珍贵文物，通过沉浸式体验、多媒体展示等方式，让观众深入了解古埃及文明的历史和文化。',
      image: '古埃及大展'
    },
    {
      id: 6,
      title: '梵蒂冈博物馆2023年参观人数达680万人次',
      category: 'industry',
      date: '2024-12-20',
      views: 1678,
      tags: ['行业新闻', '梵蒂冈博物馆', '参观数据'],
      description: '2023年，梵蒂冈博物馆的参观人数达到680万人次，位居全球第二，仅次于卢浮宫，展现了世界顶级博物馆的吸引力。梵蒂冈博物馆收藏了大量珍贵的艺术品和文物，包括米开朗基罗的《创世纪》和《最后的审判》、拉斐尔的《雅典学院》等世界名作，这些珍贵的艺术品吸引了来自世界各地的游客。',
      image: '梵蒂冈博物馆'
    },
    {
      id: 7,
      title: '大英博物馆宣布2025年春季特展"古代丝绸之路的珍宝"',
      category: 'exhibition',
      date: '2025-12-10',
      views: 2890,
      tags: ['展览预告', '大英博物馆', '丝绸之路'],
      description: '大英博物馆将于2026年3月举办"古代丝绸之路的珍宝"特展，展出200余件来自中国、中亚、中东等地区的珍贵文物，展现古代丝绸之路的繁荣与文化交流。',
      image: '大英博物馆'
    },
    {
      id: 8,
      title: '卢浮宫推出全新数字导览系统，支持多语言AR体验',
      category: 'industry',
      date: '2025-12-15',
      views: 3124,
      tags: ['行业新闻', '卢浮宫', '数字技术'],
      description: '法国卢浮宫博物馆正式推出全新数字导览系统，支持中文、英文、法文等多种语言，并首次引入AR增强现实技术，为游客提供沉浸式的艺术体验。',
      image: '卢浮宫特展'
    },
    {
      id: 9,
      title: '中国国家博物馆举办"中华文明探源工程"成果展',
      category: 'exhibition',
      date: '2025-12-20',
      views: 2567,
      tags: ['展览预告', '中国国家博物馆', '考古发现'],
      description: '中国国家博物馆将于2026年1月举办"中华文明探源工程"重大成果展，集中展示近年来考古发现的重要成果，包括良渚、二里头、三星堆等遗址的最新发现。',
      image: '博物馆统计'
    }
  ];

  @State filteredNews: NewsItem[] = [];

  // 按日期排序，最新的在前
  sortNewsByDate(newsArray: NewsItem[]): NewsItem[] {
    return newsArray.sort((a, b) => {
      // 日期格式：'YYYY-MM-DD'，可以直接字符串比较
      return b.date.localeCompare(a.date);
    });
  }

  aboutToAppear() {
    // 初始化时对资讯进行排序
    this.newsItems = this.sortNewsByDate(this.newsItems);
    this.filteredNews = this.newsItems;
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          this.NavBar()

          Column() {
            Text('资讯中心')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })

            Text('全球文博领域的动态信息源，及时获取最新展览预告、行业新闻、考古发现和学术活动')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .margin({ bottom: 8 })

            Text('每周会更新最新一周的相关资讯')
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .textAlign(TextAlign.Center)
              .margin({ bottom: 30 })

            // 分类筛选
            this.CategoryFilter()

            // 资讯列表
            this.NewsList()
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
          // 通过区域尺寸判断横竖屏
          this.isLandscape = newValue.width > newValue.height;
        })
      }

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
          this.NavItem('资讯中心', '', true)
          this.NavItem('历史时间线', 'pages/Timeline', false)
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
  CategoryFilter() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
      this.CategoryButton('全部资讯', 'all')
      this.CategoryButton('展览预告', 'exhibition')
      this.CategoryButton('行业新闻', 'industry')
      this.CategoryButton('考古发现', 'archaeology')
      this.CategoryButton('学术活动', 'academic')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.divider_color'))
    .opacity(0.3)
    .borderRadius(12)
    .margin({ bottom: 25 })
  }

  @Builder
  CategoryButton(text: string, category: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedCategory === category ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedCategory === category ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedCategory = category;
        this.applyFilters();
      })
  }

  @Builder
  NewsList() {
    Column() {
      ForEach(this.filteredNews, (news: NewsItem) => {
        this.NewsCard(news)
      })
    }
    .width('100%')
  }

  @Builder
  NewsCard(news: NewsItem) {
    Row() {
      Image(this.getNewsImage(news.image))
        .width(this.isLandscape ? 100 : 90)
        .height(this.isLandscape ? 100 : 90)
        .objectFit(ImageFit.Cover)
        .borderRadius(10)
        .margin({ right: this.isLandscape ? 12 : 10 })
        .alt(news.title)
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column() {
        Text(news.title)
          .fontSize(this.isLandscape ? 15 : 14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 22 : 20)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 6 : 5 })
          .width('100%')

        Text(news.description)
          .fontSize(this.isLandscape ? 12 : 11)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(this.isLandscape ? 18 : 16)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 10 : 8 })
          .width('100%')

        Column() {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(news.tags, (tag: string) => {
              Text(tag)
                .fontSize(10)
                .fontColor($r('app.color.primary_light'))
                .backgroundColor($r('app.color.primary_lighter'))
                .padding({ left: 6, right: 6, top: 3, bottom: 3 })
                .borderRadius(10)
                .margin({ right: 4, bottom: 4 })
            })
          }
          .width('100%')
          .margin({ bottom: 6 })

          Row() {
            Blank()
            Text(`${news.date} · ${news.views}浏览`)
              .fontSize(10)
              .fontColor($r('app.color.text_tertiary'))
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        Button('阅读全文')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_inverse'))
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .height(this.isLandscape ? 32 : 30)
          .fontSize(this.isLandscape ? 12 : 11)
          .borderRadius(16)
          .margin({ top: this.isLandscape ? 8 : 6 })
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
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(this.isLandscape ? 12 : 10)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(14)
    .margin({ bottom: this.isLandscape ? 12 : 10 })
    .shadow({
      radius: 10,
      color: $r('app.color.shadow_color_light'),
      offsetX: 0,
      offsetY: 2
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
      '故宫特展': $rawfile('故宫.png'),
      '故宫展览': $rawfile('故宫.png'),
      '木乃伊': $rawfile('古埃及文明.png'),
      '博物馆协会': $rawfile('大英博物馆.png')
    };
    return imageMap[imageName] || $rawfile('大英博物馆.png');
  }

  applyFilters() {
    let filtered = this.newsItems.filter((news) => {
      // 分类筛选
      if (this.selectedCategory !== 'all' && news.category !== this.selectedCategory) {
        return false;
      }
      return true;
    });
    // 对筛选后的结果按日期排序，最新的在前
    this.filteredNews = this.sortNewsByDate(filtered);
  }
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

