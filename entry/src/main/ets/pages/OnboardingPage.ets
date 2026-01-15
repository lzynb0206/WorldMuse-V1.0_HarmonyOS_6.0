import { router } from '@kit.ArkUI';

/**
 * 新手引导页面
 */
@Entry
@Component
struct OnboardingPage {
  @StorageLink('hasSeenOnboarding') hasSeenOnboarding: boolean = false;
  @State currentIndex: number = 0;

  // 主题色
  private primaryColor: string = '#667eea';
  private textPrimary: string = '#1a1a1a';
  private textSecondary: string = '#666666';
  private textTertiary: string = '#999999';

  // 引导页数据
  private onboardingPages: OnboardingPageData[] = [
    {
      title: '欢迎来到云览天下',
      subtitle: '完全离线博物馆指南',
      description: '随时随地浏览全球博物馆，探索人类文明的瑰宝',
      image: '故宫.png',
      icon: '🏛️'
    },
    {
      title: '搜索与浏览',
      subtitle: '发现世界珍品',
      description: '浏览丰富的藏品库，搜索您感兴趣的文物和艺术品',
      image: '大英博物馆.png',
      icon: '🔍'
    },
    {
      title: '个性化行程规划',
      subtitle: '定制专属之旅',
      description: '选择博物馆和兴趣标签，生成专属的参观行程',
      image: '卢浮宫.png',
      icon: '📋'
    },
    {
      title: '互动游戏与测验',
      subtitle: '寓教于乐',
      description: '参与寻宝游戏和知识问答，在游戏中学习历史文化',
      image: '大都会艺术博物馆.png',
      icon: '🎮'
    },
    {
      title: '小工具集',
      subtitle: '实用便捷工具',
      description: '历史上的今天、度量衡换算等实用工具，让探索更有趣',
      image: '中国国家博物馆.webp',
      icon: '🛠️'
    }
  ];

  build() {
    Stack() {
      // 背景
      this.buildBackground()

      // 主内容
      Column() {
        // 跳过按钮
        this.buildSkipButton()

        // Swiper 内容
        this.buildSwiperContent()

        // 底部指示器和按钮
        this.buildBottomSection()
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private buildBackground() {
    Column()
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
  }

  @Builder
  private buildSkipButton() {
    Row() {
      Button('跳过')
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .fontColor(this.textSecondary)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .height(36)
        .padding({ left: 16, right: 16 })
        .borderRadius(18)
        .border({
          width: 1,
          color: '#E0E0E0',
          style: BorderStyle.Solid
        })
        .onClick(() => {
          this.completeOnboarding();
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .padding({ top: 50, right: 20 })
  }

  @Builder
  private buildSwiperContent() {
    Column() {
      Swiper() {
        ForEach(this.onboardingPages, (page: OnboardingPageData, index: number) => {
          this.buildOnboardingPage(page, index)
        }, (page: OnboardingPageData, index: number) => `page_${index}`)
      }
      .cachedCount(2)
      .index(this.currentIndex)
      .indicator(false)
      .duration(300)
      .itemSpace(0)
      .displayMode(SwiperDisplayMode.STRETCH)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .layoutWeight(1)

      // 自定义指示器
      this.buildIndicator()
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private buildOnboardingPage(page: OnboardingPageData, index: number) {
    Column() {
      // 图标
      Text(page.icon)
        .fontSize(100)
        .margin({ bottom: 32 })

      // 背景图片
      Image(this.getImageResource(page.image))
        .width(320)
        .height(220)
        .objectFit(ImageFit.Cover)
        .borderRadius(24)
        .margin({ bottom: 48 })
        .shadow({
          radius: 24,
          color: 'rgba(0, 0, 0, 0.08)',
          offsetX: 0,
          offsetY: 8
        })

      // 标题
      Text(page.title)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.textPrimary)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 16 })
        .width('90%')

      // 副标题
      Text(page.subtitle)
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.textSecondary)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 24 })
        .width('90%')

      // 描述
      Text(page.description)
        .fontSize(16)
        .fontColor(this.textTertiary)
        .textAlign(TextAlign.Center)
        .lineHeight(26)
        .width('85%')
        .maxLines(3)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({ left: 24, right: 24 })
  }

  @Builder
  private buildIndicator() {
    Row() {
      ForEach(this.onboardingPages, (page: OnboardingPageData, index: number) => {
        Column()
          .width(this.currentIndex === index ? 24 : 8)
          .height(8)
          .borderRadius(4)
          .backgroundColor(this.currentIndex === index ? this.primaryColor : '#E0E0E0')
          .margin({ right: index < this.onboardingPages.length - 1 ? 8 : 0 })
          .animation({
            duration: 200,
            curve: Curve.EaseInOut
          })
      }, (page: OnboardingPageData, index: number) => `indicator_${index}`)
    }
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 32 })
  }

  @Builder
  private buildBottomSection() {
    Column() {
      if (this.currentIndex === this.onboardingPages.length - 1) {
        // 最后一页显示"开始探索"按钮
        Button('开始探索')
          .type(ButtonType.Normal)
          .backgroundColor(this.primaryColor)
          .fontColor('#FFFFFF')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('85%')
          .height(56)
          .borderRadius(28)
          .shadow({
            radius: 16,
            color: 'rgba(102, 126, 234, 0.3)',
            offsetX: 0,
            offsetY: 6
          })
          .onClick(() => {
            this.completeOnboarding();
          })
      } else {
        // 其他页显示占位，保持布局一致
        Column()
          .width('85%')
          .height(56)
      }
    }
    .width('100%')
    .padding({ bottom: 60 })
  }

  private getImageResource(imageName: string): Resource | string {
    return $rawfile(imageName);
  }

  private completeOnboarding(): void {
    this.hasSeenOnboarding = true;
    router.replaceUrl({
      url: 'pages/Index'
    } as router.RouterOptions);
  }
}

/**
 * 引导页数据模型
 */
interface OnboardingPageData {
  title: string;
  subtitle: string;
  description: string;
  image: string;
  icon: string;
}

