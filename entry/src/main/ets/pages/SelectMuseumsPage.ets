import { router } from '@kit.ArkUI';
import { MuseumService } from '../services/MuseumService';
import { Museum } from '../models/MuseumModel';

@Entry
@Component
struct SelectMuseumsPage {
  @State selectedMuseumIds: Set<number> = new Set();
  @State isLandscape: boolean = false;

  private museumService: MuseumService = MuseumService.getInstance();
  private museums: Museum[] = [];

  aboutToAppear(): void {
    this.museums = this.museumService.getAllMuseums();
  }

  build() {
    Column() {
      // 导航栏
      this.buildNavBar()

      Scroll() {
        Column() {
          // 说明文字
          Text('选择您想参观的博物馆（至少选择一个）')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .margin({ top: 16, bottom: 20, left: 16, right: 16 })

          // 博物馆列表
          this.buildMuseumList()

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
          router.pushUrl({ url: 'pages/Index' } as router.RouterOptions);
        })
        
        Text('创建新行程')
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
  private buildMuseumList() {
    Grid() {
      ForEach(this.museums, (museum: Museum) => {
        GridItem() {
          this.buildMuseumCard(museum)
        }
      })
    }
    .columnsTemplate(this.isLandscape ? '1fr 1fr 1fr' : '1fr 1fr')
    .columnsGap(12)
    .rowsGap(12)
    .width('100%')
    .padding({ left: 16, right: 16 })
  }

  @Builder
  private buildMuseumCard(museum: Museum) {
    Column() {
      Stack() {
        Image(this.getMuseumImage(museum.image))
          .width('100%')
          .height(140)
          .objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: 12, topRight: 12 })
          .alt(museum.name)

        if (this.isMuseumSelected(museum.id)) {
          Column() {
            Image($r('app.media.startIcon'))
              .width(32)
              .height(32)
              .fillColor('#FFFFFF')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgba(57, 73, 171, 0.7)')
        }
      }
      .width('100%')
      .height(140)
      .clip(true)

      Column() {
        Text(museum.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 12, bottom: 4 })
          .width('100%')

        Text(museum.location)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 8 })
          .width('100%')

        if (museum.description) {
          Text(museum.description)
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(16)
            .width('100%')
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12, bottom: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .border({
      width: this.isMuseumSelected(museum.id) ? 3 : 1,
      color: this.isMuseumSelected(museum.id) ? $r('app.color.button_primary') : $r('app.color.border_color'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 8,
      color: this.isMuseumSelected(museum.id) ? 'rgba(57, 73, 171, 0.2)' : 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.toggleMuseum(museum.id);
    })
  }

  @Builder
  private buildActionButtons() {
    Column() {
      Row() {
        Text(`已选择 ${this.selectedMuseumIds.size} 个博物馆`)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Button('下一步：选择兴趣标签')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.button_primary'))
        .fontColor($r('app.color.text_inverse'))
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .height(50)
        .borderRadius(25)
        .enabled(this.selectedMuseumIds.size > 0)
        .onClick(() => {
          this.nextStep();
        })
    }
    .width('100%')
    .padding({ bottom: 20 })
  }

  private isMuseumSelected(museumId: number): boolean {
    return this.selectedMuseumIds.has(museumId);
  }

  private toggleMuseum(museumId: number): void {
    if (this.selectedMuseumIds.has(museumId)) {
      this.selectedMuseumIds.delete(museumId);
    } else {
      this.selectedMuseumIds.add(museumId);
    }
    this.selectedMuseumIds = new Set(this.selectedMuseumIds);
  }

  private nextStep(): void {
    if (this.selectedMuseumIds.size === 0) {
      return;
    }

    const museumIds = Array.from(this.selectedMuseumIds);
    router.pushUrl({
      url: 'pages/SelectInterestsPage',
      params: {
        museumIds: museumIds
      }
    } as router.RouterOptions);
  }

  private getMuseumImage(imageName: string): Resource | string {
    return $rawfile(imageName);
  }
}
