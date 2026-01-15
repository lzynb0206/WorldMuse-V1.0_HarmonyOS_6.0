import { router } from '@kit.ArkUI';
import { INTEREST_TAGS } from '../common/constants/InterestTags';
import { InterestTag } from '../models/ArtifactModel';

@Entry
@Component
struct InterestSelectPage {
  @State selectedTags: string[] = [];
  @State isLandscape: boolean = false;

  aboutToAppear(): void {
    // 检查是否已有保存的兴趣标签
    const savedTags = AppStorage.get<string[]>('userInterests');
    if (savedTags && savedTags.length > 0) {
      this.selectedTags = savedTags;
    }
  }

  build() {
    Column() {
      // 导航栏固定在顶部
      this.buildHeader()

      // 可滚动内容区域
      Scroll() {
        Column() {
          // 提示文字
          Text('选择您感兴趣的内容，我们将为您推荐相关藏品')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .margin({ top: 16, bottom: 24, left: 16, right: 16 })

          // 兴趣标签选择区域
          this.buildInterestTags()

          // 底部按钮
          this.buildActionButtons()
        }
        .width('100%')
        .padding({ bottom: 40 })
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
  private buildHeader() {
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
        
        Text('个性化推荐')
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
    .margin({ left: 16, right: 16, top: 16 })
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

  private isTagSelected(tagName: string): boolean {
    return this.selectedTags.includes(tagName);
  }

  @Builder
  private buildActionButtons() {
    Column() {
      if (this.selectedTags.length === 0) {
        Text('请至少选择一个兴趣标签')
          .fontSize(12)
          .fontColor($r('app.color.text_tertiary'))
          .margin({ bottom: 12 })
      }

      Row() {
        Button('重新选择')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.filter_button_background'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .height(48)
          .layoutWeight(1)
          .borderRadius(24)
          .margin({ right: 12 })
          .enabled(this.selectedTags.length > 0)
          .onClick(() => {
            this.selectedTags = [];
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
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .padding({ top: 24, bottom: 20, left: 0, right: 0 })
    .margin({ top: 16 })
  }

  private toggleTag(tagName: string): void {
    const index = this.selectedTags.indexOf(tagName);
    if (index > -1) {
      this.selectedTags.splice(index, 1);
    } else {
      this.selectedTags.push(tagName);
    }
    // 触发状态更新
    this.selectedTags = [...this.selectedTags];
  }

  private generateRecommendations(): void {
    // 保存用户选择的兴趣标签
    AppStorage.setOrCreate('userInterests', this.selectedTags);
    
    // 跳转到推荐页面
    router.pushUrl({
      url: 'pages/RecommendPage',
      params: {
        selectedTags: this.selectedTags
      }
    } as router.RouterOptions);
  }
}

