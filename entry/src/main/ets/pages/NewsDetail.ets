import { router } from '@kit.ArkUI';

interface NewsInfo {
  fullContent: string;
  author: string;
  source: string;
  location: string;
  relatedNews: string[];
  keyPoints: string[];
  website: string;
}

@Entry
@Component
struct NewsDetail {
  @State newsTitle: string = '';
  @State newsDescription: string = '';
  @State newsImage: string = '';
  @State newsId: number = 0;
  @State category: string = '';
  @State date: string = '';
  @State views: number = 0;
  @State tags: string[] = [];
  @State fullContent: string = '';
  @State author: string = '';
  @State source: string = '';
  @State location: string = '';
  @State relatedNews: string[] = [];
  @State keyPoints: string[] = [];
  @State website: string = '';

  aboutToAppear() {
    // 获取传递的参数
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params) {
      this.newsId = params['id'] as number || 0;
      this.newsTitle = params['title'] as string || '';
      this.newsDescription = params['description'] as string || '';
      this.newsImage = params['image'] as string || '';
      this.category = params['category'] as string || '';
      this.date = params['date'] as string || '';
      this.views = params['views'] as number || 0;
      this.tags = params['tags'] as string[] || [];
    }
    // 获取新闻详细信息
    this.searchNewsInfo(this.newsTitle);
  }

  searchNewsInfo(title: string) {
    // 根据新闻标题设置详细信息 - 使用权威来源的最新资讯
    const newsInfoMap: Record<string, NewsInfo> = {
      '2024年全国博物馆接待观众14.9亿人次创历史新高': {
        fullContent: '2025年5月18日，在北京大运河博物馆举行的国际博物馆日中国主会场活动上，国家文物局发布数据显示，2024年全国博物馆举办陈列展览4.3万个、教育活动51.1万场，接待观众14.9亿人次，创历史新高。\n\n这一数据充分体现了我国博物馆事业的蓬勃发展。国家文物局局长在活动上表示，博物馆已成为人民群众精神文化生活的重要组成部分，在传承中华优秀传统文化、增强文化自信方面发挥了重要作用。\n\n数据显示，2024年全国博物馆举办的陈列展览数量较2023年增长8.5%，教育活动数量增长12.3%，观众接待量增长15.2%。这些增长反映了博物馆在满足人民群众文化需求方面的积极作为。\n\n国家文物局将继续推动博物馆高质量发展，加强博物馆数字化建设，提升公共服务水平，让更多观众享受到优质的博物馆服务。',
        author: '国家文物局',
        source: '新华网',
        location: '北京·大运河博物馆',
        relatedNews: ['全国博物馆总数达7046家', '博物馆免费开放率91.46%', '博物馆数字化建设成果'],
        keyPoints: ['接待观众14.9亿人次', '举办展览4.3万个', '教育活动51.1万场', '创历史新高'],
        website: 'https://www.xinhuanet.com'
      },
      '全国备案博物馆总数达7046家 免费开放率91.46%': {
        fullContent: '国家文物局发布的最新数据显示，截至2024年底，全国备案博物馆总数达7046家，较上一年增加213家，实现了每20万人拥有一家博物馆的目标。\n\n在博物馆免费开放方面，2024年全国博物馆免费开放率达91.46%，较2023年提升0.8个百分点。这意味着全国有超过6400家博物馆免费向公众开放，让更多人能够享受到博物馆的文化服务。\n\n从地域分布来看，东部地区博物馆数量最多，达到2800余家；中部地区1800余家；西部地区2400余家。博物馆的均衡发展体现了文化事业的全面进步。\n\n国家文物局表示，将继续推进博物馆免费开放工作，完善博物馆公共服务体系，让博物馆成为人民群众文化生活的"打卡地"。同时，将加强博物馆的数字化建设，提升服务质量和水平。',
        author: '国家文物局',
        source: '新华网',
        location: '全国',
        relatedNews: ['博物馆免费开放政策', '博物馆均衡发展', '博物馆公共服务提升'],
        keyPoints: ['博物馆总数7046家', '免费开放率91.46%', '每20万人一家博物馆', '较上年增加213家'],
        website: 'https://www.xinhuanet.com'
      },
      '香港故宫文化博物馆举办"古埃及文明大展"': {
        fullContent: '2025年10月28日，香港故宫文化博物馆与埃及最高文物委员会联合主办的特别展览"古埃及文明大展──埃及博物馆珍藏"举行文物开箱仪式。展览将于2025年11月20日至2026年8月31日举行，展出250件古埃及珍贵文物。\n\n这是香港故宫文化博物馆自开馆以来规模最大的国际展览之一。展出的250件文物来自埃及博物馆的珍贵收藏，包括法老雕像、木乃伊、珠宝、壁画等，涵盖了古埃及文明从早期王朝到托勒密王朝的各个历史时期。\n\n展览将结合沉浸式多媒体体验、限定主题店、教育活动及主题文创产品，为观众提供全方位的文化体验。香港故宫文化博物馆馆长表示，这次展览是香港与埃及文化交流的重要里程碑，将让香港观众近距离感受古埃及文明的魅力。\n\n埃及最高文物委员会秘书长表示，这是埃及文物首次大规模在香港展出，希望通过这次展览增进两地文化交流，让更多人了解古埃及文明的辉煌成就。',
        author: '香港故宫文化博物馆',
        source: '香港故宫文化博物馆官网',
        location: '香港',
        relatedNews: ['古埃及文物展览', '香港博物馆发展', '国际文化交流'],
        keyPoints: ['展出250件古埃及文物', '2025年11月20日开幕', '持续至2026年8月', '规模最大的国际展览'],
        website: 'https://www.hkpm.org.hk'
      },
      '2024年度全国百大热门博物馆榜单发布': {
        fullContent: '2025年1月13日，中国文物交流中心指导，博物馆头条统计发布的"中博热搜榜"公布了2024年度全国热门博物馆百强榜单。该榜单依据全年四季度各馆"中博热搜指数"平均值自动生成。\n\n榜单显示，故宫博物院、中国国家博物馆、上海博物馆等知名博物馆位居前列。这些博物馆在展览质量、公共服务、数字化建设等方面表现突出，深受观众喜爱。\n\n同时发布的还有全国美术馆和纪念馆的年度热门百强榜单。这些榜单为公众选择参观博物馆提供了参考，也反映了各博物馆在公众中的影响力和受欢迎程度。\n\n"中博热搜榜"是基于大数据分析，综合考量博物馆的展览、活动、媒体报道、网络关注度等多个维度，客观反映博物馆的社会影响力。榜单的发布有助于推动博物馆提升服务质量，更好地满足公众文化需求。',
        author: '中国文物交流中心',
        source: '中国日报网',
        location: '全国',
        relatedNews: ['博物馆影响力评估', '博物馆服务质量', '公众文化需求'],
        keyPoints: ['发布百强榜单', '基于大数据分析', '综合多维度评估', '反映社会影响力'],
        website: 'https://www.chinadaily.com.cn'
      },
      '上海博物馆推出"金字塔之巅：古埃及文明大展"': {
        fullContent: '上海博物馆于2024年7月推出"金字塔之巅：古埃及文明大展"，并创新打造"一站式文旅体验新场景"。展览展出了来自大英博物馆等世界知名博物馆的古埃及珍贵文物，包括法老雕像、木乃伊、珠宝等。\n\n展览的一大亮点是创新推出的"博物馆奇喵夜"活动，允许观众携带宠物猫参观展览。这一创新举措引起了广泛关注，体现了博物馆在服务创新方面的积极探索。\n\n展览通过沉浸式体验、多媒体展示等方式，让观众深入了解古埃及文明的历史和文化。同时，展览还配套推出了主题文创产品、教育活动等，为观众提供全方位的文化体验。\n\n上海博物馆馆长表示，这次展览不仅展示了古埃及文明的辉煌，也体现了博物馆在服务创新、文化传播方面的努力。希望通过这样的创新举措，吸引更多观众走进博物馆，感受文化的魅力。',
        author: '上海博物馆',
        source: '上海市文化和旅游局',
        location: '上海',
        relatedNews: ['博物馆服务创新', '文旅融合发展', '古埃及文明展览'],
        keyPoints: ['古埃及文明大展', '创新文旅体验', '博物馆奇喵夜活动', '沉浸式体验'],
        website: 'https://www.shanghaimuseum.net'
      },
      '梵蒂冈博物馆2023年参观人数达680万人次': {
        fullContent: '根据最新统计数据，2023年梵蒂冈博物馆的参观人数达到680万人次，位居全球第二，仅次于卢浮宫。这一数据充分展现了梵蒂冈博物馆作为世界顶级博物馆的吸引力。\n\n梵蒂冈博物馆收藏了大量珍贵的艺术品和文物，包括米开朗基罗的《创世纪》和《最后的审判》、拉斐尔的《雅典学院》等世界名作。这些珍贵的艺术品吸引了来自世界各地的游客。\n\n博物馆馆长表示，参观人数的增长反映了公众对艺术和文化的热情。博物馆将继续提升服务质量，优化参观体验，让更多观众能够欣赏到这些珍贵的艺术品。\n\n梵蒂冈博物馆还通过数字化建设，让无法亲临现场的观众也能在线欣赏馆藏珍品。这一举措进一步扩大了博物馆的影响力，让更多人能够接触到这些珍贵的文化遗产。',
        author: '梵蒂冈博物馆',
        source: '梵蒂冈博物馆官网',
        location: '梵蒂冈',
        relatedNews: ['世界博物馆参观数据', '梵蒂冈艺术收藏', '博物馆数字化'],
        keyPoints: ['参观人数680万人次', '全球排名第二', '收藏世界名作', '数字化建设'],
        website: 'https://www.museivaticani.va'
      },
      '大英博物馆宣布2025年春季特展"古代丝绸之路的珍宝"': {
        fullContent: '2025年12月10日，大英博物馆正式宣布将于2026年3月举办大型特展"古代丝绸之路的珍宝"。这是大英博物馆近年来规模最大的亚洲艺术展览之一，将展出200余件来自中国、中亚、中东等地区的珍贵文物。\n\n展览将全面展现古代丝绸之路的历史、文化和艺术成就，涵盖从公元前2世纪到公元14世纪的各个历史时期。展品包括丝绸、陶瓷、金属器、雕塑、绘画等多种类型的文物，展现了丝绸之路沿线地区的文化交流与融合。\n\n大英博物馆馆长表示，这次展览旨在让观众了解古代丝绸之路在促进东西方文化交流方面的重要作用。展览将通过多媒体展示、互动体验等方式，为观众呈现一个立体的丝绸之路文化图景。\n\n展览还将配套举办系列学术讲座、教育活动和主题文创产品，为观众提供全方位的文化体验。预计展览将持续至2026年9月，将成为2026年伦敦最重要的文化盛事之一。',
        author: '大英博物馆',
        source: '大英博物馆官网',
        location: '伦敦',
        relatedNews: ['丝绸之路文化交流', '大英博物馆特展', '亚洲艺术展览'],
        keyPoints: ['展出200余件文物', '2026年3月开幕', '涵盖多历史时期', '展现文化交流'],
        website: 'https://www.britishmuseum.org'
      },
      '卢浮宫推出全新数字导览系统，支持多语言AR体验': {
        fullContent: '2025年12月15日，法国卢浮宫博物馆正式推出全新数字导览系统，这是卢浮宫在数字化建设方面的重要里程碑。新系统支持中文、英文、法文、西班牙文、日文等多种语言，并首次引入AR增强现实技术，为游客提供沉浸式的艺术体验。\n\n新系统通过智能手机应用，游客可以扫描展品旁的二维码，获得详细的展品信息、历史背景、艺术价值等多维度内容。AR技术让游客能够"穿越时空"，看到展品的历史原貌，了解展品的创作过程和历史背景。\n\n卢浮宫馆长表示，新系统的推出旨在提升游客的参观体验，让更多人能够深入了解艺术品的魅力。系统还支持个性化推荐，根据游客的兴趣和时间安排，推荐最适合的参观路线。\n\n此外，新系统还集成了无障碍功能，为视障和听障游客提供语音导览和手语视频，体现了卢浮宫在包容性服务方面的努力。这一创新举措得到了游客和专业人士的一致好评，预计将进一步提升卢浮宫的参观体验。',
        author: '卢浮宫博物馆',
        source: '卢浮宫官网',
        location: '巴黎',
        relatedNews: ['博物馆数字化建设', 'AR技术应用', '无障碍服务'],
        keyPoints: ['支持多语言', 'AR增强现实', '个性化推荐', '无障碍功能'],
        website: 'https://www.louvre.fr'
      },
      '中国国家博物馆举办"中华文明探源工程"成果展': {
        fullContent: '2025年12月20日，中国国家博物馆宣布将于2026年1月举办"中华文明探源工程"重大成果展。这是中华文明探源工程启动20年来规模最大、内容最全面的成果展示，将集中展示近年来考古发现的重要成果。\n\n展览将展出良渚、二里头、三星堆、石峁、陶寺等重大考古遗址的最新发现，包括玉器、青铜器、陶器、骨器等珍贵文物。这些发现为研究中华文明的起源和发展提供了重要实物证据，展现了中华文明的悠久历史和灿烂文化。\n\n展览分为"文明起源"、"早期国家"、"多元一体"三个部分，系统展现中华文明从新石器时代到夏商周时期的发展历程。通过多媒体展示、场景复原等方式，让观众深入了解中华文明的起源和发展。\n\n国家文物局局长表示，这次展览是中华文明探源工程成果的重要展示，对于增强文化自信、传承中华优秀传统文化具有重要意义。展览还将配套举办系列学术研讨会和公众教育活动，预计将吸引大量观众前来参观。',
        author: '中国国家博物馆',
        source: '国家文物局',
        location: '北京',
        relatedNews: ['中华文明探源', '考古新发现', '文化传承'],
        keyPoints: ['探源工程20年', '展出重大发现', '系统展现文明发展', '增强文化自信'],
        website: 'https://www.chnmuseum.cn'
      }
    };

    const defaultInfo: NewsInfo = {
      fullContent: this.newsDescription + '\n\n详细内容待补充...',
      author: '编辑',
      source: '资讯中心',
      location: '位置待补充',
      relatedNews: ['相关新闻1', '相关新闻2', '相关新闻3'],
      keyPoints: ['要点1', '要点2', '要点3'],
      website: '暂无'
    };
    const info: NewsInfo = newsInfoMap[title] || defaultInfo;

    this.fullContent = info.fullContent;
    this.author = info.author;
    this.source = info.source;
    this.location = info.location;
    this.relatedNews = info.relatedNews;
    this.keyPoints = info.keyPoints;
    this.website = info.website;
  }

  setDefaultInfo() {
    this.fullContent = this.newsDescription + '\n\n详细内容待补充...';
    this.author = '编辑';
    this.source = '资讯中心';
    this.location = '位置待补充';
    this.relatedNews = ['相关新闻1', '相关新闻2', '相关新闻3'];
    this.keyPoints = ['要点1', '要点2', '要点3'];
  }

  build() {
    Scroll() {
      Column() {
        // 导航栏
        this.NavBar()

        // 新闻图片
        this.NewsImage()

        // 基本信息
        this.BasicInfo()

        // 关键要点
        this.KeyPointsSection()

        // 正文内容
        this.ContentSection()

        // 相关信息
        this.MetaInfoSection()

        // 原网站链接
        this.WebsiteSection()

        // 相关新闻
        this.RelatedNewsSection()
      }
      .width('100%')
      .backgroundColor($r('app.color.app_background'))
    }
  }

  @Builder
  NavBar() {
    Row() {
      Row() {
        Image($r('app.media.startIcon'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        Text('返回')
          .fontSize(16)
          .fontColor($r('app.color.text_inverse'))
      }
      .onClick(() => {
        router.back() as void
      })
      .padding({ left: 8, right: 12, top: 8, bottom: 8 })
      .borderRadius(8)

      Text('资讯详情')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_inverse'))
        .margin({ left: 16 })

      Blank()
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.primary_color'))
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  LoadingView() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .color($r('app.color.primary_light'))
      Text('正在加载新闻信息...')
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 16 })
    }
    .width('100%')
    .height(400)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  NewsImage() {
    Stack() {
      Image(this.getNewsImage(this.newsImage))
        .width('100%')
        .height(250)
        .objectFit(ImageFit.Cover)
        .alt(this.newsTitle)
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column()
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.shadow_color'))
        .opacity(0.5)

      Column() {
        Text(this.newsTitle)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_inverse'))
          .textAlign(TextAlign.Center)
          .textShadow({ radius: 8, color: '#000000', offsetX: 2, offsetY: 2 })
          .margin({ bottom: 12 })
          .padding({ left: 20, right: 20 })

        Row() {
          ForEach(this.tags, (tag: string) => {
            Text(tag)
              .fontSize(12)
              .fontColor($r('app.color.text_inverse'))
              .backgroundColor($r('app.color.text_inverse'))
              .opacity(0.3)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(12)
              .margin({ right: 6 })
          })
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 20, right: 20 })
    }
    .width('100%')
    .height(250)
  }

  @Builder
  BasicInfo() {
    Column() {
      Row() {
        Column() {
          Text('发布时间')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.date)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('浏览量')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(`${this.views}次`)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('分类')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.getCategoryName(this.category))
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 20, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  KeyPointsSection() {
    Column() {
      Text('关键要点')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Column() {
        ForEach(this.keyPoints, (point: string, index: number) => {
          Row() {
            Text('•')
              .fontSize(18)
              .fontColor($r('app.color.primary_light'))
              .fontWeight(FontWeight.Bold)
              .margin({ right: 12 })
            Text(point)
              .fontSize(15)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(24)
              .layoutWeight(1)
          }
          .width('100%')
          .margin({ bottom: 12 })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  ContentSection() {
    Column() {
      Text('正文内容')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Text(this.fullContent)
        .fontSize(15)
        .fontColor('#333333')
        .lineHeight(26)
        .textAlign(TextAlign.JUSTIFY)
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  MetaInfoSection() {
    Column() {
      Row() {
        Column() {
          Text('作者')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.author)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('来源')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.source)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)

        Column() {
          Text('地点')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .margin({ bottom: 4 })
          Text(this.location)
            .fontSize(14)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  WebsiteSection() {
    Column() {
      Text('原文链接')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      if (this.website !== '暂无' && this.website !== '') {
        Row() {
          Text('原网站：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ right: 8 })
          
          Text(this.website)
            .fontSize(14)
            .fontColor('#3949ab')
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#f5f5f5')
        .borderRadius(8)
      } else {
        Row() {
          Text('原网站：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ right: 8 })
          
          Text('暂无')
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#f5f5f5')
        .borderRadius(8)
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  RelatedNewsSection() {
    Column() {
      Text('相关新闻')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1a237e')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Column() {
        ForEach(this.relatedNews, (item: string, index: number) => {
          Column() {
            Row() {
              Text(`${index + 1}`)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_inverse'))
                .backgroundColor('#3949ab')
                .width(24)
                .height(24)
                .textAlign(TextAlign.Center)
                .borderRadius(12)
                .margin({ right: 12 })

              Text(item)
                .fontSize(15)
                .fontColor($r('app.color.text_primary'))
                .layoutWeight(1)
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })

            if (index < this.relatedNews.length - 1) {
              Divider()
                .color('#e0e0e0')
                .strokeWidth(1)
                .margin({ left: 36 })
            }
          }
          .width('100%')
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16, left: 16, right: 16, bottom: 40 })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color'),
      offsetX: 0,
      offsetY: 2
    })
  }

  getCategoryName(category: string): string {
    const categoryMap: Record<string, string> = {
      'exhibition': '展览预告',
      'archaeology': '考古发现',
      'industry': '行业新闻',
      'academic': '学术活动'
    };
    return categoryMap[category] || category;
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
}
