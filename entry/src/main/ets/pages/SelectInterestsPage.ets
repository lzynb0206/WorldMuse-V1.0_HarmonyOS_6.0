import { router } from '@kit.ArkUI';
import { INTEREST_TAGS, InterestTag } from '../common/constants/InterestTags';

@Entry
@Component
struct SelectInterestsPage {
  @State selectedMuseumIds: number[] = [];
  @State selectedTags: string[] = [];
  @State isLandscape: boolean = false;

  aboutToAppear(): void {
    // 获取路由参数
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params['museumIds']) {
      this.selectedMuseumIds = params['museumIds'] as number[];
    }
  }

  build() {
    Column() {
      // 导航栏
      this.buildNavBar()

      Scroll() {
        Column() {
          // 说明文字
          Text('选择您感兴趣的内容类型（可多选）')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .margin({ top: 16, bottom: 20, left: 16, right: 16 })

          // 兴趣标签选择区域
          this.buildInterestTags()

          // 底部按钮
          this.buildActionButtons()
        }
        .width('100%')
        .padding({ bottom: 100 })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_background'))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.isLandscape = newValue.width > newValue.height;
    })
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
          router.back();
        })
        
        Text('选择兴趣标签')
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
  private buildInterestTags() {
    Column() {
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(INTEREST_TAGS, (tag: InterestTag) => {
          this.buildTagItem(tag)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 20, bottom: 20 })
    .backgroundColor($r('app.color.card_background'))
    .margin({ left: 16, right: 16 })
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  private buildTagItem(tag: InterestTag) {
    Button(tag.name)
      .type(ButtonType.Normal)
      .backgroundColor(this.isTagSelected(tag.name) ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.isTagSelected(tag.name) ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .fontWeight(this.isTagSelected(tag.name) ? FontWeight.Medium : FontWeight.Normal)
      .height(40)
      .padding({ left: 20, right: 20 })
      .borderRadius(20)
      .margin({ right: 12, bottom: 12 })
      .border({
        width: this.isTagSelected(tag.name) ? 0 : 1,
        color: $r('app.color.border_color'),
        style: BorderStyle.Solid
      })
      .onClick(() => {
        this.toggleTag(tag.name);
      })
  }

  @Builder
  private buildActionButtons() {
    Column() {
      Row() {
        Button('上一步')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.filter_button_background'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .height(48)
          .layoutWeight(1)
          .borderRadius(24)
          .margin({ right: 12 })
          .onClick(() => {
            router.back();
          })

        Button('生成推荐')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_inverse'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .height(48)
          .layoutWeight(1)
          .borderRadius(24)
          .enabled(this.selectedTags.length > 0)
          .onClick(() => {
            this.generateRecommendations();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 24, bottom: 20 })
    }
    .width('100%')
  }

  private isTagSelected(tagName: string): boolean {
    return this.selectedTags.includes(tagName);
  }

  private toggleTag(tagName: string): void {
    const index = this.selectedTags.indexOf(tagName);
    if (index > -1) {
      this.selectedTags.splice(index, 1);
    } else {
      this.selectedTags.push(tagName);
    }
    this.selectedTags = [...this.selectedTags];
  }

  private generateRecommendations(): void {
    if (this.selectedTags.length === 0) {
      return;
    }

    router.pushUrl({
      url: 'pages/RecommendListPage',
      params: {
        museumIds: this.selectedMuseumIds,
        selectedTags: this.selectedTags
      }
    } as router.RouterOptions);
  }
}

