import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { ItineraryMuseum } from '../models/MuseumModel';
import { Artifact } from '../models/ArtifactModel';
import { ArtifactService } from '../services/ArtifactService';

@Entry
@Component
struct MyItineraryPage {
  @StorageLink('myItinerary') itineraryMuseums: ItineraryMuseum[] = [];
  @State isLandscape: boolean = false;

  private artifactService: ArtifactService = ArtifactService.getInstance();

  build() {
    Column() {
      // 导航栏
      this.buildNavBar()

      if (this.itineraryMuseums.length === 0) {
        this.buildEmptyView()
      } else {
        Scroll() {
          Column() {
            // 按博物馆分组显示
            ForEach(this.itineraryMuseums, (museumItinerary: ItineraryMuseum) => {
              this.buildMuseumSection(museumItinerary)
            })

            // 总时间统计
            this.buildTotalTimeInfo()
          }
          .width('100%')
          .padding({ bottom: 100 })
        }
        .width('100%')
        .layoutWeight(1)
      }
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
        
        Text('我的行程')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .margin({ left: 8 })

        Button() {
          Text('创建新行程')
            .fontSize(14)
            .fontColor($r('app.color.button_primary'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .height(40)
        .onClick(() => {
          router.pushUrl({ url: 'pages/SelectMuseumsPage' } as router.RouterOptions);
        })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(0.5)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  private buildEmptyView() {
    Column() {
      Image($r('app.media.startIcon'))
        .width(80)
        .height(80)
        .opacity(0.3)
        .margin({ bottom: 16 })

      Text('行程为空')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 8 })

      Text('快去创建您的专属行程吧！')
        .fontSize(14)
        .fontColor($r('app.color.text_tertiary'))
        .margin({ bottom: 24 })

      Button('创建新行程')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.button_primary'))
        .fontColor($r('app.color.text_inverse'))
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width(200)
        .height(44)
        .borderRadius(22)
        .onClick(() => {
          router.pushUrl({ url: 'pages/SelectMuseumsPage' } as router.RouterOptions);
        })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private buildMuseumSection(museumItinerary: ItineraryMuseum) {
    Column() {
      // 博物馆标题
      Row() {
        Text(museumItinerary.museumName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        Text(`${museumItinerary.artifactIds.length} 件藏品`)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      // 藏品列表
      this.buildMuseumArtifactsList(museumItinerary)

      // 本馆时间统计
      this.buildMuseumTimeInfo(museumItinerary)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16, bottom: 8 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  private buildArtifactItem(artifact: Artifact, museumId: number) {
    Row() {
      Image(this.getArtifactImage(artifact.image))
        .width(80)
        .height(80)
        .objectFit(ImageFit.Cover)
        .borderRadius(12)
        .alt(artifact.title)

      Column() {
        Text(artifact.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 4 })
          .width('100%')

        Text(artifact.desc)
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(16)
          .margin({ bottom: 6 })
          .width('100%')

        Row() {
          Text(`${artifact.duration} 分钟`)
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 12 })

      Button() {
        Image($r('app.media.startIcon'))
          .width(20)
          .height(20)
          .fillColor($r('app.color.text_secondary'))
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width(40)
      .height(40)
      .onClick(() => {
        this.removeArtifact(museumId, artifact.id);
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .draggable(true)
  }

  @Builder
  private buildMuseumArtifactsList(museumItinerary: ItineraryMuseum) {
    List() {
      ForEach(this.getMuseumArtifacts(museumItinerary), (artifact: Artifact) => {
        ListItem() {
          this.buildArtifactItem(artifact, museumItinerary.museumId)
        }
      }, (artifact: Artifact) => artifact.id.toString())
    }
    .width('100%')
    .height(this.getMuseumArtifacts(museumItinerary).length * 100)
    .divider({ strokeWidth: 0.5, color: $r('app.color.divider_color'), startMargin: 16, endMargin: 16 })
    .onItemMove((from: number, to: number) => {
      return this.moveArtifact(museumItinerary.museumId, from, to);
    })
  }

  @Builder
  private buildMuseumTimeInfo(museumItinerary: ItineraryMuseum) {
    Row() {
      Text(`本馆预计游览时间：`)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))

      Text(`${this.getMuseumDuration(museumItinerary)} 分钟`)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FF6B35')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 16 })
    .backgroundColor($r('app.color.filter_button_background'))
  }

  private getMuseumArtifacts(museumItinerary: ItineraryMuseum): Artifact[] {
    return this.artifactService.getArtifactsByIds(museumItinerary.artifactIds);
  }

  private getMuseumDuration(museumItinerary: ItineraryMuseum): number {
    const artifacts = this.getMuseumArtifacts(museumItinerary);
    return this.calculateMuseumDuration(artifacts);
  }

  @Builder
  private buildTotalTimeInfo() {
    Column() {
      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(1)
        .margin({ top: 16, bottom: 16 })

      Row() {
        Text('总预计时间：')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        Text(`${this.calculateTotalDuration()} 分钟`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF6B35')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 8 })

      Text(`（分 ${this.itineraryMuseums.length} 个博物馆）`)
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 8, bottom: 16 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  private calculateMuseumDuration(artifacts: Artifact[]): number {
    let total = 0;
    for (let i = 0; i < artifacts.length; i++) {
      total += artifacts[i].duration;
    }
    // 添加5-10分钟步行缓冲
    const buffer = artifacts.length > 0 ? Math.min(10, Math.max(5, artifacts.length * 2)) : 0;
    return total + buffer;
  }

  private calculateTotalDuration(): number {
    let total = 0;
    for (let i = 0; i < this.itineraryMuseums.length; i++) {
      const museumItinerary = this.itineraryMuseums[i];
      const artifacts = this.artifactService.getArtifactsByIds(museumItinerary.artifactIds);
      total += this.calculateMuseumDuration(artifacts);
    }
    return total;
  }

  private moveArtifact(museumId: number, from: number, to: number): boolean {
    const museumIndex = this.itineraryMuseums.findIndex(item => item.museumId === museumId);
    if (museumIndex === -1) {
      return false;
    }

    const museumItinerary = this.itineraryMuseums[museumIndex];
    const artifactIds: number[] = [];
    for (let i = 0; i < museumItinerary.artifactIds.length; i++) {
      artifactIds.push(museumItinerary.artifactIds[i]);
    }
    
    const movedItem = artifactIds[from];
    artifactIds.splice(from, 1);
    artifactIds.splice(to, 0, movedItem);

    const updatedItinerary: ItineraryMuseum = {
      museumId: museumItinerary.museumId,
      museumName: museumItinerary.museumName,
      artifactIds: artifactIds
    };
    
    const updatedMuseums: ItineraryMuseum[] = [];
    for (let i = 0; i < this.itineraryMuseums.length; i++) {
      if (i === museumIndex) {
        updatedMuseums.push(updatedItinerary);
      } else {
        updatedMuseums.push(this.itineraryMuseums[i]);
      }
    }
    this.itineraryMuseums = updatedMuseums;
    
    this.saveItinerary();
    return true;
  }

  private removeArtifact(museumId: number, artifactId: number): void {
    promptAction.showDialog({
      title: '确认删除',
      message: '确定要从行程中移除这件藏品吗？',
      buttons: [
        { text: '取消', color: $r('app.color.text_secondary') },
        { text: '删除', color: $r('app.color.button_primary') }
      ]
    }).then((value: promptAction.ShowDialogSuccessResponse) => {
      if (value.index === 1) {
        const museumIndex = this.itineraryMuseums.findIndex(item => item.museumId === museumId);
        if (museumIndex === -1) {
          return;
        }

        const museumItinerary = this.itineraryMuseums[museumIndex];
        const artifactIndex = museumItinerary.artifactIds.indexOf(artifactId);
        if (artifactIndex > -1) {
          const updatedArtifactIds: number[] = [];
          for (let i = 0; i < museumItinerary.artifactIds.length; i++) {
            if (i !== artifactIndex) {
              updatedArtifactIds.push(museumItinerary.artifactIds[i]);
            }
          }
          
          // 如果该博物馆没有藏品了，移除整个博物馆
          if (updatedArtifactIds.length === 0) {
            const updatedMuseums: ItineraryMuseum[] = [];
            for (let i = 0; i < this.itineraryMuseums.length; i++) {
              if (i !== museumIndex) {
                updatedMuseums.push(this.itineraryMuseums[i]);
              }
            }
            this.itineraryMuseums = updatedMuseums;
          } else {
            const updatedItinerary: ItineraryMuseum = {
              museumId: museumItinerary.museumId,
              museumName: museumItinerary.museumName,
              artifactIds: updatedArtifactIds
            };
            const updatedMuseums: ItineraryMuseum[] = [];
            for (let i = 0; i < this.itineraryMuseums.length; i++) {
              if (i === museumIndex) {
                updatedMuseums.push(updatedItinerary);
              } else {
                updatedMuseums.push(this.itineraryMuseums[i]);
              }
            }
            this.itineraryMuseums = updatedMuseums;
          }
          
          this.saveItinerary();
        }
      }
    }).catch(() => {
      // 用户取消
    });
  }

  private saveItinerary(): void {
    AppStorage.setOrCreate('myItinerary', this.itineraryMuseums);
  }

  private getArtifactImage(imageName: string): Resource | string {
    return $rawfile(imageName);
  }
}
