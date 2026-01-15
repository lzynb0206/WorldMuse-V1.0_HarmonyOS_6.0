import { router } from '@kit.ArkUI';

@Entry
@Component
struct ArtifactExplore {
  @State selectedEra: string = 'all';
  @State selectedRegion: string = 'all';
  @State selectedMaterial: string = 'all';
  @State selectedTheme: string = 'all';
  @State searchText: string = '';
  @State isLandscape: boolean = false;

  @State artifacts: Artifact[] = [
    {
      id: 1,
      name: '清明上河图',
      era: 'ancient',
      region: 'asia',
      material: 'paper',
      theme: 'court',
      tags: ['宋代', '中国', '绢本', '绘画'],
      description: '北宋画家张择端所作，描绘了北宋都城汴京的城市面貌和当时社会各阶层人民的生活状况。全长528.7厘米，高24.8厘米，是中国古代风俗画的巅峰之作，展现了12世纪中国城市的繁华景象。',
      image: '清明上河图'
    },
    {
      id: 2,
      name: '罗塞塔石碑',
      era: 'ancient',
      region: 'africa',
      material: 'stone',
      theme: 'religion',
      tags: ['托勒密王朝', '埃及', '玄武岩', '铭文'],
      description: '制作于公元前196年，刻有古埃及国王托勒密五世登基的诏书，是解密古埃及象形文字的关键。石碑上刻有三种文字：古埃及象形文字、古埃及草书和古希腊文，为解读古埃及文字提供了重要线索。',
      image: '罗塞塔石碑'
    },
    {
      id: 3,
      name: '蒙娜丽莎',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'renaissance',
      tags: ['文艺复兴', '意大利', '油画', '肖像'],
      description: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的油画，以其神秘的微笑而闻名于世。创作于1503-1519年，现藏于法国卢浮宫，是世界上最著名的绘画作品之一，每年吸引数百万游客前来观赏。',
      image: '蒙娜丽莎'
    },
    {
      id: 4,
      name: '兵马俑',
      era: 'ancient',
      region: 'asia',
      material: 'terracotta',
      theme: 'war',
      tags: ['秦代', '中国', '陶器', '雕塑'],
      description: '秦始皇陵的陪葬坑中的陶俑，规模宏大，造型逼真，是中国古代雕塑艺术的杰作。每个兵马俑的面部表情、发型、服饰都各不相同，展现了秦代高超的雕塑技艺，被誉为"世界第八大奇迹"。',
      image: '兵马俑'
    },
    {
      id: 5,
      name: '图坦卡蒙黄金面具',
      era: 'ancient',
      region: 'africa',
      material: 'gold',
      theme: 'religion',
      tags: ['古埃及', '埃及', '黄金', '葬礼用品'],
      description: '古埃及法老图坦卡蒙的葬礼面具，由纯金制成，镶嵌有宝石和彩色玻璃，是古埃及艺术的代表作。制作于公元前1323年，重达11公斤，展现了古埃及精湛的金属加工工艺和宗教信仰。',
      image: '图坦卡蒙黄金面具'
    },
    {
      id: 6,
      name: '维伦多夫的维纳斯',
      era: 'prehistoric',
      region: 'europe',
      material: 'stone',
      theme: 'daily',
      tags: ['旧石器时代', '奥地利', '石灰石', '雕塑'],
      description: '旧石器时代的小型女性雕像，发现于奥地利，是已知最早的人类艺术表现之一。制作于约2.5万年前，高11厘米，可能用于生殖崇拜或宗教仪式，是人类艺术史上的重要里程碑。',
      image: '维伦多夫的维纳斯'
    },
    {
      id: 7,
      name: '大卫像',
      era: 'renaissance',
      region: 'europe',
      material: 'stone',
      theme: 'renaissance',
      tags: ['文艺复兴', '意大利', '大理石', '雕塑'],
      description: '意大利文艺复兴时期雕塑家米开朗基罗创作的大理石雕塑，高5.17米，创作于1501-1504年。描绘了《圣经》中大卫王准备与巨人歌利亚战斗的场景，是文艺复兴雕塑艺术的巅峰之作。',
      image: '大卫像'
    },
    {
      id: 8,
      name: '星夜',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'daily',
      tags: ['后印象派', '荷兰', '油画', '风景'],
      description: '荷兰后印象派画家文森特·梵高创作的油画，描绘了夜晚的星空和村庄。创作于1889年，现藏于纽约现代艺术博物馆，以其独特的笔触和色彩运用而闻名，是梵高最具代表性的作品之一。',
      image: '星夜'
    },
    {
      id: 9,
      name: '向日葵',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'daily',
      tags: ['后印象派', '荷兰', '油画', '静物'],
      description: '荷兰后印象派画家文森特·梵高创作的系列油画作品，以向日葵为主题。创作于1888-1889年，梵高共创作了11幅向日葵作品，展现了其对生命力和自然美的追求，是印象派艺术的经典之作。',
      image: '向日葵'
    },
    {
      id: 10,
      name: '思想者',
      era: 'renaissance',
      region: 'europe',
      material: 'bronze',
      theme: 'daily',
      tags: ['现代艺术', '法国', '青铜', '雕塑'],
      description: '法国雕塑家奥古斯特·罗丹创作的青铜雕塑，创作于1880年。原本是为《地狱之门》设计的，后来成为独立的作品，展现了人类思考的深刻内涵，是现代雕塑艺术的代表作。',
      image: '思想者'
    },
    {
      id: 11,
      name: '睡莲',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'daily',
      tags: ['印象派', '法国', '油画', '风景'],
      description: '法国印象派画家克劳德·莫奈创作的系列油画作品，以睡莲为主题。创作于1899-1926年，共创作了250多幅，展现了莫奈对光影变化的敏锐观察，是印象派艺术的巅峰之作。',
      image: '睡莲'
    },
    {
      id: 12,
      name: '最后的晚餐',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'religion',
      tags: ['文艺复兴', '意大利', '壁画', '宗教画'],
      description: '意大利文艺复兴时期画家列奥纳多·达·芬奇创作的壁画，描绘了耶稣与十二门徒共进最后一餐的场景。创作于1495-1498年，现位于意大利米兰圣玛利亚感恩教堂，是文艺复兴艺术的杰作。',
      image: '最后的晚餐'
    },
    {
      id: 13,
      name: '自由引导人民',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'war',
      tags: ['浪漫主义', '法国', '油画', '历史画'],
      description: '法国浪漫主义画家欧仁·德拉克洛瓦创作的油画，描绘了1830年法国七月革命的场景。创作于1830年，现藏于法国卢浮宫，以其强烈的动感和情感表达而闻名，是浪漫主义艺术的代表作。',
      image: '自由引导人民'
    },
    {
      id: 14,
      name: '富春山居图',
      era: 'ancient',
      region: 'asia',
      material: 'paper',
      theme: 'daily',
      tags: ['元代', '中国', '纸本', '山水画'],
      description: '元代画家黄公望创作的山水画长卷，描绘了富春江两岸的山水景色。全长636.9厘米，高33厘米，是中国古代山水画的巅峰之作，被誉为"画中之兰亭"，现分藏于浙江省博物馆和台北故宫博物院。',
      image: '富春山居图'
    },
    {
      id: 15,
      name: '掷铁饼者',
      era: 'ancient',
      region: 'europe',
      material: 'stone',
      theme: 'daily',
      tags: ['古希腊', '希腊', '大理石', '雕塑'],
      description: '古希腊雕塑家米隆创作的大理石雕塑，创作于约公元前450年。描绘了运动员投掷铁饼的瞬间，展现了古希腊对人体美的追求，是古典雕塑艺术的代表作，现藏于意大利罗马国家博物馆。',
      image: '掷铁饼者'
    },
    {
      id: 16,
      name: '断臂的维纳斯',
      era: 'ancient',
      region: 'europe',
      material: 'stone',
      theme: 'daily',
      tags: ['古希腊', '希腊', '大理石', '雕塑'],
      description: '古希腊雕塑作品，创作于约公元前130-100年。高2.04米，现藏于法国卢浮宫，以其完美的比例和优雅的姿态而闻名，是古希腊雕塑艺术的巅峰之作，被誉为"美的象征"。',
      image: '断臂的维纳斯'
    },
    {
      id: 17,
      name: '夜巡',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'war',
      tags: ['巴洛克', '荷兰', '油画', '群像'],
      description: '荷兰巴洛克画家伦勃朗创作的油画，描绘了阿姆斯特丹民兵连队的群像。创作于1642年，现藏于荷兰阿姆斯特丹国家博物馆，以其独特的光影效果和构图而闻名，是伦勃朗最具代表性的作品之一。',
      image: '夜巡'
    },
    {
      id: 18,
      name: '记忆的永恒',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'daily',
      tags: ['超现实主义', '西班牙', '油画', '超现实'],
      description: '西班牙超现实主义画家萨尔瓦多·达利创作的油画，描绘了融化的时钟和荒凉的风景。创作于1931年，现藏于纽约现代艺术博物馆，以其超现实的想象力和精湛的技法而闻名，是超现实主义艺术的代表作。',
      image: '记忆的永恒'
    },
    {
      id: 19,
      name: '呐喊',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'daily',
      tags: ['表现主义', '挪威', '油画', '情感表达'],
      description: '挪威表现主义画家爱德华·蒙克创作的油画，描绘了一个在桥上呐喊的人物。创作于1893年，现藏于挪威国家美术馆，以其强烈的情感表达和独特的色彩运用而闻名，是表现主义艺术的代表作。',
      image: '呐喊'
    },
    {
      id: 20,
      name: '格尔尼卡',
      era: 'renaissance',
      region: 'europe',
      material: 'oil',
      theme: 'war',
      tags: ['立体主义', '西班牙', '油画', '反战'],
      description: '西班牙立体主义画家巴勃罗·毕加索创作的油画，描绘了西班牙内战期间格尔尼卡镇被轰炸的场景。创作于1937年，现藏于西班牙马德里索菲亚王后国家艺术中心博物馆，以其强烈的反战主题和独特的艺术风格而闻名。',
      image: '格尔尼卡'
    }
  ];

  @State filteredArtifacts: Artifact[] = [];

  aboutToAppear() {
    this.filteredArtifacts = this.artifacts;
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          this.NavBar()

        Column() {
          Text('藏品探索')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 8 })

          Text('打破物理博物馆界限，探索来自世界各地博物馆的珍贵藏品')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .margin({ bottom: 20 })

          // 搜索框
          this.SearchSection()

          // 筛选器
          this.FilterBar()

          // 主题推荐
          this.ThemeRecommendations()

          // 藏品列表
          this.ArtifactsList()
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
          this.NavItem('藏品探索', '', true)
          this.NavItem('资讯中心', 'pages/News', false)
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
  SearchSection() {
    Row() {
      TextInput({ placeholder: '搜索藏品名称...', text: this.searchText })
        .layoutWeight(1)
        .height(46)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius({ topLeft: 12, bottomLeft: 12 })
        .fontSize(14)
        .padding({ left: 16 })
        .onChange((value: string) => {
          this.searchText = value;
          this.applyFilters();
        })
        .onSubmit(() => {
          this.applyFilters();
        })

      Button('搜索')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.button_primary'))
        .fontColor($r('app.color.text_inverse'))
        .fontWeight(FontWeight.Medium)
        .height(46)
        .fontSize(14)
        .borderRadius({ topRight: 12, bottomRight: 12 })
        .onClick(() => {
          this.applyFilters();
        })
    }
    .width('100%')
    .margin({ bottom: 20 })
  }

  @Builder
  FilterBar() {
    Column() {
      Text('高级筛选器')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 20 })

      // 时代筛选
      Column() {
        Text('时代')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 12 })

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
          this.EraButton('全部', 'all')
          this.EraButton('史前时期', 'prehistoric')
          this.EraButton('古代文明', 'ancient')
          this.EraButton('中世纪', 'medieval')
          this.EraButton('文艺复兴', 'renaissance')
        }
        .width('100%')
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 地域筛选
      Column() {
        Text('地域')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 12 })

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
          this.RegionButton('全部', 'all')
          this.RegionButton('亚洲', 'asia')
          this.RegionButton('欧洲', 'europe')
          this.RegionButton('非洲', 'africa')
          this.RegionButton('美洲', 'america')
        }
        .width('100%')
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 材质筛选
      Column() {
        Text('材质')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 12 })

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
          this.MaterialButton('全部', 'all')
          this.MaterialButton('石头', 'stone')
          this.MaterialButton('油画', 'oil')
          this.MaterialButton('陶器', 'terracotta')
          this.MaterialButton('黄金', 'gold')
          this.MaterialButton('纸质', 'paper')
          this.MaterialButton('青铜', 'bronze')
        }
        .width('100%')
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 主题筛选
      Column() {
        Text('主题')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 12 })

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
          this.ThemeButton('全部', 'all')
          this.ThemeButton('宫廷', 'court')
          this.ThemeButton('宗教', 'religion')
          this.ThemeButton('文艺复兴', 'renaissance')
          this.ThemeButton('战争', 'war')
          this.ThemeButton('日常生活', 'daily')
        }
        .width('100%')
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.background_secondary'))
    .borderRadius(12)
    .margin({ bottom: 25 })
  }

  @Builder
  EraButton(text: string, value: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedEra === value ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedEra === value ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedEra = value;
        this.applyFilters();
      })
  }

  @Builder
  RegionButton(text: string, value: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedRegion === value ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedRegion === value ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedRegion = value;
        this.applyFilters();
      })
  }

  @Builder
  MaterialButton(text: string, value: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedMaterial === value ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedMaterial === value ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedMaterial = value;
        this.applyFilters();
      })
  }

  @Builder
  ThemeButton(text: string, value: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedTheme === value ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedTheme === value ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedTheme = value;
        this.applyFilters();
      })
  }

  @Builder
  ThemeRecommendations() {
    Column() {
      Text('主题推荐')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 15 })

      Row() {
        this.ThemeCard('丝绸之路', '丝绸之路')
        this.ThemeCard('文艺复兴', '文艺复兴')
        this.ThemeCard('古埃及文明', '古埃及文明')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .margin({ bottom: 25 })
  }

  @Builder
  ThemeCard(title: string, image: string) {
    Stack() {
      Column()
        .width('100%')
        .height(160)
        .backgroundColor('#3949ab')
        .borderRadius(12)

      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#ffffff')
        .textShadow({ radius: 4, color: '#000000', offsetX: 1, offsetY: 1 })
    }
    .width('30%')
    .height(160)
    .borderRadius(12)
    .onClick(() => {
      // 根据主题筛选藏品
      if (title === '文艺复兴') {
        this.selectedTheme = 'renaissance';
      } else if (title === '古埃及文明') {
        this.selectedTheme = 'religion';
      } else {
        // 丝绸之路可以筛选包含相关标签的藏品
        this.selectedTheme = 'all';
        // 可以添加额外的筛选逻辑
      }
      this.applyFilters();
    })
  }

  @Builder
  ArtifactsList() {
    Column() {
      Row() {
        Text(`找到 ${this.filteredArtifacts.length} 件藏品`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))

        Blank()

        Button('清除筛选')
          .type(ButtonType.Normal)
          .backgroundColor('transparent')
          .fontColor($r('app.color.primary_light'))
          .fontSize(14)
          .onClick(() => {
            this.selectedEra = 'all';
            this.selectedRegion = 'all';
            this.selectedMaterial = 'all';
            this.selectedTheme = 'all';
            this.applyFilters();
          })
      }
      .width('100%')
      .margin({ bottom: 20 })

      Column() {
        ForEach(this.filteredArtifacts, (artifact: Artifact) => {
          this.ArtifactCard(artifact)
        })
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  ArtifactCard(artifact: Artifact) {
    Row() {
      Image(this.getArtifactImage(artifact.image))
        .width(this.isLandscape ? 130 : 110)
        .height(this.isLandscape ? 130 : 110)
        .objectFit(ImageFit.Cover)
        .borderRadius(14)
        .alt(artifact.name)
        .margin({ right: this.isLandscape ? 16 : 12 })
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column() {
        Text(artifact.name)
          .fontSize(this.isLandscape ? 17 : 16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(this.isLandscape ? 24 : 22)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 8 : 6 })
          .width('100%')

        Row() {
          ForEach(artifact.tags, (tag: string) => {
            Text(tag)
              .fontSize(this.isLandscape ? 11 : 10)
              .fontColor($r('app.color.primary_light'))
              .backgroundColor($r('app.color.primary_lighter'))
              .padding({ 
                left: this.isLandscape ? 8 : 6, 
                right: this.isLandscape ? 8 : 6, 
                top: this.isLandscape ? 4 : 3, 
                bottom: this.isLandscape ? 4 : 3 
              })
              .borderRadius(12)
              .margin({ right: this.isLandscape ? 6 : 4 })
          })
        }
        .width('100%')
        .margin({ bottom: this.isLandscape ? 10 : 8 })

        Text(artifact.description)
          .fontSize(this.isLandscape ? 13 : 12)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(this.isLandscape ? 20 : 18)
          .maxLines(this.isLandscape ? 3 : 2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: this.isLandscape ? 14 : 10 })
          .width('100%')

        Button('查看详情')
          .type(ButtonType.Normal)
          .backgroundColor('#3949ab')
          .fontColor('#ffffff')
          .fontWeight(FontWeight.Medium)
          .fontSize(this.isLandscape ? 14 : 13)
          .height(this.isLandscape ? 36 : 34)
          .width('100%')
          .borderRadius(18)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ArtifactDetail',
              params: {
                id: artifact.id,
                name: artifact.name,
                description: artifact.description,
                image: artifact.image,
                era: artifact.era,
                region: artifact.region,
                material: artifact.material,
                theme: artifact.theme,
                tags: artifact.tags
              }
            } as router.RouterOptions)
          })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(this.isLandscape ? 18 : 14)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: this.isLandscape ? 16 : 12 })
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color_light'),
      offsetX: 0,
      offsetY: 2
    })
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

  applyFilters() {
    // 先创建一个新数组，确保状态更新触发UI刷新
    const filtered: Artifact[] = [];
    for (let i = 0; i < this.artifacts.length; i++) {
      const artifact = this.artifacts[i];
      // 时代筛选
      if (this.selectedEra !== 'all' && artifact.era !== this.selectedEra) {
        continue;
      }
      // 地区筛选
      if (this.selectedRegion !== 'all' && artifact.region !== this.selectedRegion) {
        continue;
      }
      // 材质筛选
      if (this.selectedMaterial !== 'all' && artifact.material !== this.selectedMaterial) {
        continue;
      }
      // 主题筛选
      if (this.selectedTheme !== 'all' && artifact.theme !== this.selectedTheme) {
        continue;
      }
      // 搜索筛选
      if (this.searchText && this.searchText.trim() !== '') {
        const searchLower = this.searchText.toLowerCase().trim();
        const nameMatch = artifact.name.toLowerCase().includes(searchLower);
        const descMatch = artifact.description.toLowerCase().includes(searchLower);
        const tagMatch = artifact.tags.some(tag => tag.toLowerCase().includes(searchLower));
        if (!nameMatch && !descMatch && !tagMatch) {
          continue;
        }
      }
      filtered.push(artifact);
    }
    // 使用新数组赋值，确保触发状态更新
    this.filteredArtifacts = filtered;
  }
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
}

