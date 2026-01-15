import { router } from '@kit.ArkUI';

@Entry
@Component
struct MuseumList {
  @State selectedRegion: string = 'all';
  @State searchText: string = '';

  @State museums: Museum[] = [
    {
      id: 1,
      name: '故宫博物院',
      description: '北京故宫博物院，世界上现存规模最大、保存最为完整的木质结构古建筑群。始建于明永乐十八年（1420年），是明清两朝的皇家宫殿，现为世界文化遗产。',
      image: '故宫',
      badge: '热门',
      location: '中国·北京',
      region: 'asia'
    },
    {
      id: 2,
      name: '大英博物馆',
      description: '世界上规模最大、最著名的博物馆之一，收藏了世界各地的文物和珍品。成立于1753年，拥有超过800万件藏品，涵盖人类文明各个时期。',
      image: '大英博物馆',
      badge: '推荐',
      location: '英国·伦敦',
      region: 'europe'
    },
    {
      id: 3,
      name: '卢浮宫',
      description: '位于法国巴黎的世界著名艺术博物馆，以收藏古典绘画和雕刻而闻名。前身为法国王宫，现收藏有《蒙娜丽莎》、《维纳斯》等世界名作。',
      image: '卢浮宫',
      badge: '新上线',
      location: '法国·巴黎',
      region: 'europe'
    },
    {
      id: 4,
      name: '大都会艺术博物馆',
      description: '美国最大的艺术博物馆，收藏了来自世界各地的200多万件艺术品。成立于1870年，涵盖从古代到现代的艺术作品，是纽约最重要的文化地标之一。',
      image: '大都会艺术博物馆',
      badge: '推荐',
      location: '美国·纽约',
      region: 'america'
    },
    {
      id: 5,
      name: '艾尔米塔什博物馆',
      description: '位于俄罗斯圣彼得堡，世界四大博物馆之一，以收藏印象派和后印象派作品闻名。前身为沙皇冬宫，现拥有超过300万件藏品，是俄罗斯最重要的艺术博物馆。',
      image: '艾尔米塔什博物馆',
      badge: '热门',
      location: '俄罗斯·圣彼得堡',
      region: 'europe'
    },
    {
      id: 6,
      name: '东京国立博物馆',
      description: '日本历史最悠久的博物馆，收藏了大量日本和亚洲的艺术品及文物。成立于1872年，是日本最大的博物馆，收藏有11万件文物，其中87件为国宝。',
      image: '东京国立博物馆',
      badge: '新上线',
      location: '日本·东京',
      region: 'asia'
    },
    {
      id: 7,
      name: '中国国家博物馆',
      description: '中国最大的综合性历史博物馆，位于北京天安门广场东侧。收藏有140万件文物，涵盖从远古到现代的中国历史，是了解中华文明的重要窗口。',
      image: '中国国家博物馆',
      badge: '推荐',
      location: '中国·北京',
      region: 'asia'
    },
    {
      id: 8,
      name: '上海博物馆',
      description: '中国重要的古代艺术博物馆，以收藏中国古代青铜器、陶瓷、书画、玉器而闻名。馆藏文物超过100万件，其中珍贵文物14万件，是研究中国古代艺术的重要机构。',
      image: '上海博物馆',
      badge: '热门',
      location: '中国·上海',
      region: 'asia'
    },
    {
      id: 9,
      name: '梵蒂冈博物馆',
      description: '位于梵蒂冈城内的艺术博物馆群，收藏有大量文艺复兴时期的艺术品和古代文物。以西斯廷教堂的米开朗基罗壁画而闻名于世，是世界上最著名的博物馆之一。',
      image: '梵蒂冈博物馆',
      badge: '推荐',
      location: '梵蒂冈',
      region: 'europe'
    },
    {
      id: 10,
      name: '普拉多博物馆',
      description: '西班牙最重要的艺术博物馆，位于马德里。收藏有大量西班牙黄金时代的绘画作品，包括戈雅、委拉斯开兹等大师的杰作，是研究西班牙艺术的重要场所。',
      image: '普拉多博物馆',
      badge: '新上线',
      location: '西班牙·马德里',
      region: 'europe'
    },
    {
      id: 11,
      name: '乌菲兹美术馆',
      description: '意大利佛罗伦萨最著名的艺术博物馆，收藏有大量文艺复兴时期的绘画作品。以收藏波提切利、达·芬奇、拉斐尔等大师的作品而闻名，是文艺复兴艺术的宝库。',
      image: '乌菲兹美术馆',
      badge: '推荐',
      location: '意大利·佛罗伦萨',
      region: 'europe'
    },
    {
      id: 12,
      name: '埃及博物馆',
      description: '位于开罗的埃及国家博物馆，收藏有大量古埃及文物，包括图坦卡蒙的黄金面具和木乃伊。是世界上收藏古埃及文物最丰富的博物馆，是研究古埃及文明的重要机构。',
      image: '埃及博物馆',
      badge: '热门',
      location: '埃及·开罗',
      region: 'africa'
    },
    {
      id: 13,
      name: '古根海姆博物馆',
      description: '位于纽约的现代艺术博物馆，以收藏20世纪和21世纪的艺术作品而闻名。建筑本身由弗兰克·劳埃德·赖特设计，是建筑艺术的杰作，收藏有大量现代艺术大师的作品。',
      image: '古根海姆博物馆',
      badge: '推荐',
      location: '美国·纽约',
      region: 'america'
    },
    {
      id: 14,
      name: '泰特现代美术馆',
      description: '英国最重要的现代艺术博物馆，位于伦敦泰晤士河畔。前身为发电站，现收藏有大量20世纪和21世纪的艺术作品，是了解现代艺术发展的重要场所。',
      image: '泰特现代美术馆',
      badge: '新上线',
      location: '英国·伦敦',
      region: 'europe'
    },
    {
      id: 15,
      name: '奥赛博物馆',
      description: '位于巴黎的19世纪艺术博物馆，前身为奥赛火车站。收藏有大量印象派和后印象派作品，包括莫奈、梵高、雷诺阿等大师的杰作，是研究19世纪艺术的重要机构。',
      image: '奥赛博物馆',
      badge: '推荐',
      location: '法国·巴黎',
      region: 'europe'
    },
    {
      id: 16,
      name: '芝加哥艺术博物馆',
      description: '美国重要的艺术博物馆，收藏有大量印象派、后印象派和现代艺术作品。以收藏《美国哥特式》等名作而闻名，是研究美国艺术的重要场所。',
      image: '芝加哥艺术博物馆',
      badge: '热门',
      location: '美国·芝加哥',
      region: 'america'
    },
    {
      id: 17,
      name: '柏林国家博物馆',
      description: '德国最重要的博物馆群，包括多个分馆，收藏有大量欧洲艺术和文物。以收藏古埃及、古希腊、古罗马文物而闻名，是研究欧洲文明的重要机构。',
      image: '柏林国家博物馆',
      badge: '推荐',
      location: '德国·柏林',
      region: 'europe'
    },
    {
      id: 18,
      name: '阿姆斯特丹国家博物馆',
      description: '荷兰最重要的艺术博物馆，收藏有大量荷兰黄金时代的绘画作品。以收藏伦勃朗的《夜巡》等名作而闻名，是研究荷兰艺术的重要场所。',
      image: '阿姆斯特丹国家博物馆',
      badge: '新上线',
      location: '荷兰·阿姆斯特丹',
      region: 'europe'
    },
    {
      id: 19,
      name: '首尔国立中央博物馆',
      description: '韩国最大的博物馆，收藏有大量韩国和亚洲的文物。以收藏高丽青瓷、朝鲜王朝文物而闻名，是研究韩国历史和文化的重要机构。',
      image: '首尔国立中央博物馆',
      badge: '推荐',
      location: '韩国·首尔',
      region: 'asia'
    },
    {
      id: 20,
      name: '印度国家博物馆',
      description: '印度最重要的博物馆，收藏有大量印度古代文物和艺术品。以收藏印度教、佛教、耆那教艺术品而闻名，是研究印度文明的重要机构。',
      image: '印度国家博物馆',
      badge: '热门',
      location: '印度·新德里',
      region: 'asia'
    },
    {
      id: 21,
      name: '巴西国家博物馆',
      description: '巴西最重要的自然历史和人类学博物馆，收藏有大量南美洲的文物和标本。以收藏古生物化石、印第安文物而闻名，是研究南美洲文明的重要机构。',
      image: '巴西国家博物馆',
      badge: '推荐',
      location: '巴西·里约热内卢',
      region: 'america'
    },
    {
      id: 22,
      name: '墨西哥国家人类学博物馆',
      description: '墨西哥最重要的博物馆，收藏有大量中美洲古代文明的文物。以收藏玛雅、阿兹特克文物而闻名，是研究中美洲文明的重要机构。',
      image: '墨西哥国家人类学博物馆',
      badge: '新上线',
      location: '墨西哥·墨西哥城',
      region: 'america'
    },
    {
      id: 23,
      name: '澳大利亚国家博物馆',
      description: '澳大利亚最重要的博物馆，收藏有大量澳大利亚原住民文物和自然历史标本。以收藏原住民艺术品、澳大利亚历史文物而闻名，是研究澳大利亚文化的重要机构。',
      image: '澳大利亚国家博物馆',
      badge: '推荐',
      location: '澳大利亚·堪培拉',
      region: 'asia'
    },
    {
      id: 24,
      name: '开普敦南非博物馆',
      description: '南非重要的自然历史博物馆，收藏有大量非洲的文物和标本。以收藏古人类化石、非洲艺术品而闻名，是研究非洲文明的重要机构。',
      image: '开普敦南非博物馆',
      badge: '热门',
      location: '南非·开普敦',
      region: 'africa'
    },
    {
      id: 25,
      name: '陕西历史博物馆',
      description: '中国重要的历史博物馆，位于古都西安。收藏有大量周、秦、汉、唐等朝代的文物，以收藏兵马俑、唐代文物而闻名，是研究中国古代历史的重要机构。',
      image: '陕西历史博物馆',
      badge: '推荐',
      location: '中国·西安',
      region: 'asia'
    },
    {
      id: 26,
      name: '南京博物院',
      description: '中国重要的综合性博物馆，位于南京。收藏有大量中国古代文物，以收藏明清文物、书画、陶瓷而闻名，是研究中国历史文化的重要机构。',
      image: '南京博物院',
      badge: '热门',
      location: '中国·南京',
      region: 'asia'
    },
    {
      id: 27,
      name: '台北故宫博物院',
      description: '位于台北的综合性博物馆，收藏有大量中国古代文物和艺术品。以收藏《清明上河图》、《富春山居图》等名作而闻名，是研究中华文明的重要机构。',
      image: '台北故宫博物院',
      badge: '推荐',
      location: '中国·台北',
      region: 'asia'
    },
    {
      id: 28,
      name: '维多利亚与阿尔伯特博物馆',
      description: '英国重要的装饰艺术和设计博物馆，位于伦敦。收藏有大量装饰艺术品、服装、珠宝等，是研究装饰艺术和设计历史的重要机构。',
      image: '维多利亚与阿尔伯特博物馆',
      badge: '新上线',
      location: '英国·伦敦',
      region: 'europe'
    },
    {
      id: 29,
      name: '奥赛博物馆',
      description: '位于巴黎的19世纪艺术博物馆，前身为奥赛火车站。收藏有大量印象派和后印象派作品，包括莫奈、梵高、雷诺阿等大师的杰作，是研究19世纪艺术的重要机构。',
      image: '奥赛博物馆',
      badge: '推荐',
      location: '法国·巴黎',
      region: 'europe'
    },
    {
      id: 30,
      name: '波士顿美术博物馆',
      description: '美国重要的艺术博物馆，位于波士顿。收藏有大量古代和现代艺术作品，以收藏亚洲艺术、印象派作品而闻名，是研究世界艺术的重要机构。',
      image: '波士顿美术博物馆',
      badge: '热门',
      location: '美国·波士顿',
      region: 'america'
    }
  ];

  @State filteredMuseums: Museum[] = [];

  aboutToAppear() {
    this.filteredMuseums = this.museums;
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 导航栏
          this.NavBar()

          Column() {
            Text('博物馆')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })

            Text('探索全球顶级博物馆，了解世界文化遗产')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .margin({ bottom: 8 })

            Text(`共${this.filteredMuseums.length}个博物馆`)
              .fontSize(14)
              .fontColor($r('app.color.primary_light'))
              .fontWeight(FontWeight.Medium)
              .textAlign(TextAlign.Center)
              .margin({ bottom: 20 })

            // 搜索框
            this.SearchSection()

            // 地区筛选
            this.RegionFilter()

            // 博物馆列表
            this.MuseumsList()
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 20, bottom: 20 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ top: 20, left: 16, right: 16, bottom: 20 })
        }
        .width('100%')
        .backgroundColor($r('app.color.app_background'))
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
          this.NavItem('博物馆', '', true)
          this.NavItem('藏品探索', 'pages/ArtifactExplore', false)
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
      TextInput({ placeholder: '搜索博物馆名称...', text: this.searchText })
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
  RegionFilter() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
      this.RegionButton('全部', 'all')
      this.RegionButton('亚洲', 'asia')
      this.RegionButton('欧洲', 'europe')
      this.RegionButton('美洲', 'america')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.divider_color'))
    .opacity(0.3)
    .borderRadius(12)
    .margin({ bottom: 25 })
  }

  @Builder
  RegionButton(text: string, region: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedRegion === region ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedRegion === region ? $r('app.color.text_inverse') : $r('app.color.primary_light'))
      .fontSize(14)
      .fontWeight(this.selectedRegion === region ? FontWeight.Medium : FontWeight.Normal)
      .height(40)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedRegion = region;
        this.applyFilters();
      })
  }

  @Builder
  MuseumsList() {
    Column() {
      ForEach(this.filteredMuseums, (museum: Museum) => {
        this.MuseumCard(museum)
      })
    }
    .width('100%')
  }

  @Builder
  MuseumCard(museum: Museum) {
    Row() {
      Image(this.getMuseumImage(museum.image))
        .width(120)
        .height(120)
        .objectFit(ImageFit.Cover)
        .borderRadius(14)
        .margin({ right: 16 })
        .alt(museum.name)
        .syncLoad(true)
        .onError(() => {
          // 图片加载失败时的处理
        })

      Column() {
        Row() {
          Text(museum.name)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)

          if (museum.badge) {
            Text(museum.badge)
              .fontSize(11)
              .fontColor($r('app.color.text_inverse'))
              .fontWeight(FontWeight.Medium)
              .backgroundColor($r('app.color.accent_color'))
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(12)
          }
        }
        .width('100%')
        .margin({ bottom: 8 })

        Text(museum.location)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 8 })

        Text(museum.description)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(20)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 12 })
          .width('100%')

        Button('查看详情')
          .type(ButtonType.Normal)
          .backgroundColor('#3949ab')
          .fontColor('#ffffff')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .height(36)
          .fontSize(14)
          .borderRadius(18)
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
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(18)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: 16 })
    .shadow({
      radius: 12,
      color: $r('app.color.shadow_color_light'),
      offsetX: 0,
      offsetY: 2
    })
  }

  applyFilters() {
    this.filteredMuseums = this.museums.filter((museum) => {
      // 地区筛选
      if (this.selectedRegion !== 'all' && museum.region !== this.selectedRegion) {
        return false;
      }
      // 搜索筛选
      if (this.searchText && this.searchText.trim() !== '') {
        const searchLower = this.searchText.toLowerCase().trim();
        const nameMatch = museum.name.toLowerCase().includes(searchLower);
        const descMatch = museum.description.toLowerCase().includes(searchLower);
        if (!nameMatch && !descMatch) {
          return false;
        }
      }
      return true;
    });
  }

  getMuseumImage(imageName: string): Resource | string {
    // 使用本地图片资源，与images文件夹中的图片对应
    const imageMap: Record<string, Resource> = {
      '故宫': $rawfile('故宫.png'),
      '大英博物馆': $rawfile('大英博物馆.png'),
      '卢浮宫': $rawfile('卢浮宫.png'),
      '大都会艺术博物馆': $rawfile('大都会艺术博物馆.png'),
      '艾尔米塔什': $rawfile('艾尔米塔什博物馆.webp'),
      '艾尔米塔什博物馆': $rawfile('艾尔米塔什博物馆.webp'),
      '东京国立': $rawfile('东京国立博物馆.jpg'),
      '东京国立博物馆': $rawfile('东京国立博物馆.jpg'),
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

}

interface Museum {
  id: number;
  name: string;
  description: string;
  image: string;
  badge?: string;
  location?: string;
  region?: string;
}
