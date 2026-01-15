import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct SettingsPage {
  @StorageLink('hasSeenOnboarding') hasSeenOnboarding: boolean = false;

  build() {
    Column() {
      // 导航栏
      this.buildNavBar()

      Scroll() {
        Column() {
          // 设置项列表
          this.buildSettingsList()
        }
        .width('100%')
        .padding({ top: 20, bottom: 40 })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_background'))
  }

  @Builder
  private buildNavBar() {
    Column() {
      Row() {
        Button() {
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
            .fillColor($r('app.color.text_primary'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(40)
        .height(40)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Index' } as router.RouterOptions);
        })
        
        Text('设置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .margin({ left: 8 })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(0.5)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  private buildSettingsList() {
    Column() {
      // 新手引导
      this.buildSettingItem(
        '📖',
        '重新查看引导',
        '查看应用功能介绍和使用指南',
        () => {
          this.showOnboarding();
        }
      )

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(0.5)
        .margin({ left: 16, right: 16 })

      // 关于应用
      this.buildSettingItem(
        'ℹ️',
        '关于应用',
        '云览天下 v1.0.0',
        () => {
          this.showAbout();
        }
      )

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(0.5)
        .margin({ left: 16, right: 16 })

      // 数据说明
      this.buildSettingItem(
        '💾',
        '数据说明',
        '所有数据均为离线存储，无需网络连接',
        () => {
          this.showDataInfo();
        }
      )
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }

  @Builder
  private buildSettingItem(icon: string, title: string, subtitle: string, onClick: () => void) {
    Row() {
      Text(icon)
        .fontSize(24)
        .margin({ right: 16 })

      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .alignSelf(ItemAlign.Start)

        Text(subtitle)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .alignSelf(ItemAlign.Start)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.startIcon'))
        .width(20)
        .height(20)
        .fillColor($r('app.color.text_tertiary'))
    }
    .width('100%')
    .height(72)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .margin({ bottom: 12 })
    .onClick(() => {
      onClick();
    })
  }

  private showOnboarding(): void {
    this.hasSeenOnboarding = false;
    router.pushUrl({
      url: 'pages/OnboardingPage'
    } as router.RouterOptions);
  }

  private showAbout(): void {
    promptAction.showDialog({
      title: '关于云览天下',
      message: '版本：v1.0.0\n\n完全离线的博物馆探索应用，随时随地浏览全球博物馆，探索人类文明的瑰宝。\n\n【主要功能】\n\n🏛️ 博物馆浏览\n浏览全球顶级博物馆的详细介绍，包括历史背景、建筑特色、馆藏亮点等信息。\n\n🗺️ 个性化行程规划\n选择感兴趣的博物馆和兴趣标签，系统将为您生成专属的参观行程推荐。\n\n📦 藏品探索\n按分类浏览全球博物馆珍贵藏品，包括艺术品、文物、历史文献等，深入了解每件藏品的历史背景和文化价值。\n\n📰 资讯中心\n获取最新展览预告、博物馆新闻和行业资讯，第一时间了解文博动态。\n\n⏳ 历史时间线\n按时间顺序探索人类文明发展历程，了解各个历史时期的重要事件和文化成就。\n\n📚 知识问答\n通过丰富的题库测试您对博物馆和文物的了解，在答题中学习历史文化知识。\n\n🎮 寻宝游戏\n根据线索找出正确的文物，寓教于乐，让探索更有趣。\n\n🏆 成就系统\n记录您的探索成就和收藏记录，见证您的博物馆之旅。\n\n🛠️ 小工具集\n提供历史上的今天、度量衡换算等实用工具，让学习和探索更加便捷。\n\n【使用说明】\n\n1. 首次打开应用时，会显示功能介绍页面，帮助您快速了解各项功能。\n\n2. 在首页可以浏览今日推荐博物馆、藏品和最新资讯。\n\n3. 点击导航栏中的功能入口，可以快速跳转到对应功能页面。\n\n4. 所有数据均为离线存储，无需网络连接即可使用全部功能。\n\n5. 在设置页面可以重新查看引导、查看版本信息和数据说明。',
      buttons: [
        {
          text: '确定',
          color: $r('app.color.button_primary')
        }
      ]
    });
  }

  private showDataInfo(): void {
    promptAction.showDialog({
      title: '数据说明',
      message: '本应用所有数据均为离线存储：\n\n• 博物馆和藏品信息\n• 历史事件数据\n• 知识问答题库\n• 用户行程和收藏\n\n无需网络连接即可使用所有功能',
      buttons: [
        {
          text: '确定',
          color: $r('app.color.button_primary')
        }
      ]
    });
  }
}

