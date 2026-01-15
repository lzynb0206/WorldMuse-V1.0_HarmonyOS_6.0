import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { RecommendService } from '../services/RecommendService';
import { ArtifactService } from '../services/ArtifactService';
import { RecommendResult } from '../models/ArtifactModel';
import { ItineraryMuseum } from '../models/MuseumModel';

@Entry
@Component
struct RecommendListPage {
  @State museumIds: number[] = [];
  @State selectedTags: string[] = [];
  @State recommendations: RecommendResult[] = [];
  @State selectedArtifactIds: Set<number> = new Set();
  @State isLoading: boolean = true;

  private recommendService: RecommendService = RecommendService.getInstance();
  private artifactService: ArtifactService = ArtifactService.getInstance();

  aboutToAppear(): void {
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params['museumIds']) {
      this.museumIds = params['museumIds'] as number[];
    }
    if (params['selectedTags']) {
      this.selectedTags = params['selectedTags'] as string[];
    }
    this.loadRecommendations();
  }

  build() {
    Column() {
      // 导航栏
      this.buildNavBar()

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.button_primary'))
          Text('正在生成推荐...')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            // 推荐说明
            this.buildRecommendInfo()

            // 推荐列表
            this.buildRecommendList()

            // 底部操作栏
            this.buildBottomActions()
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
        
        Text('推荐藏品')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .margin({ left: 8 })

        Button() {
          Text('我的行程')
            .fontSize(14)
            .fontColor($r('app.color.button_primary'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .height(40)
        .onClick(() => {
          router.pushUrl({ url: 'pages/MyItineraryPage' } as router.RouterOptions);
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
  private buildRecommendInfo() {
    Column() {
      Text(`为您推荐 ${this.recommendations.length} 件藏品`)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 8 })

      Text('根据您选择的博物馆和兴趣标签，我们为您精选了以下藏品')
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(18)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 12 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  private buildRecommendList() {
    List() {
      ForEach(this.recommendations, (recommendation: RecommendResult) => {
        ListItem() {
          this.buildRecommendItem(recommendation)
        }
      })
    }
    .width('100%')
    .divider({ strokeWidth: 0.5, color: $r('app.color.divider_color'), startMargin: 16, endMargin: 16 })
    .padding({ top: 8 })
  }

  @Builder
  private buildRecommendItem(recommendation: RecommendResult) {
    this.buildRecommendItemContent(recommendation)
  }

  @Builder
  private buildBottomActions() {
    Column() {
      Row() {
        Text(`已选择 ${this.selectedArtifactIds.size} 件藏品`)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Button('加入行程')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.button_primary'))
        .fontColor($r('app.color.text_inverse'))
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .height(50)
        .borderRadius(25)
        .enabled(this.selectedArtifactIds.size > 0)
        .onClick(() => {
          this.addToItinerary();
        })
    }
    .width('100%')
    .padding({ bottom: 20 })
  }

  private loadRecommendations(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.recommendations = this.recommendService.getRecommendations(
        this.museumIds,
        this.selectedTags,
        3,
        8
      );
      this.isLoading = false;
    }, 300);
  }

  private toggleSelect(artifactId: number): void {
    if (this.selectedArtifactIds.has(artifactId)) {
      this.selectedArtifactIds.delete(artifactId);
    } else {
      this.selectedArtifactIds.add(artifactId);
    }
    this.selectedArtifactIds = new Set(this.selectedArtifactIds);
  }

  @Builder
  private buildRecommendItemContent(recommendation: RecommendResult) {
    Row() {
      Stack() {
        Image(this.getArtifactImage(recommendation.artifact.image))
          .width(100)
          .height(100)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)
          .alt(recommendation.artifact.title)

        if (this.isArtifactSelected(recommendation.artifact.id)) {
          Column() {
            Image($r('app.media.startIcon'))
              .width(24)
              .height(24)
              .fillColor('#FFFFFF')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgba(57, 73, 171, 0.7)')
          .borderRadius(12)
        }
      }
      .width(100)
      .height(100)

      Column() {
        Text(recommendation.artifact.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 4 })
          .width('100%')

        Row() {
          Text(recommendation.artifact.museumName)
            .fontSize(13)
            .fontColor($r('app.color.button_primary'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .margin({ bottom: 6 })

        Text(recommendation.artifact.desc)
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(16)
          .margin({ bottom: 8 })
          .width('100%')

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(recommendation.artifact.tags, (tag: string) => {
            Text(tag)
              .fontSize(11)
              .fontColor($r('app.color.text_tertiary'))
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor($r('app.color.filter_button_background'))
              .borderRadius(8)
              .margin({ right: 6, bottom: 4 })
          })
        }
        .width('100%')

        Row() {
          Text(`预计参观时间：${recommendation.artifact.duration}分钟`)
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 12 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .margin({ left: 16, right: 16, top: 8, bottom: 8 })
    .border({
      width: this.isArtifactSelected(recommendation.artifact.id) ? 2 : 0,
      color: $r('app.color.button_primary'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.toggleSelect(recommendation.artifact.id);
    })
  }

  private isArtifactSelected(artifactId: number): boolean {
    return this.selectedArtifactIds.has(artifactId);
  }

  private addToItinerary(): void {
    if (this.selectedArtifactIds.size === 0) {
      promptAction.showToast({
        message: '请至少选择一件藏品',
        duration: 2000
      });
      return;
    }

    // 获取当前行程
    const currentItinerary = AppStorage.get<ItineraryMuseum[]>('myItinerary') || [];
    const itineraryMap = new Map<number, ItineraryMuseum>();

    // 将现有行程转换为Map
    for (let i = 0; i < currentItinerary.length; i++) {
      const item: ItineraryMuseum = currentItinerary[i];
      itineraryMap.set(item.museumId, item);
    }

    // 按博物馆分组添加新藏品
    const selectedArtifacts = this.artifactService.getArtifactsByIds(Array.from(this.selectedArtifactIds));
    for (let i = 0; i < selectedArtifacts.length; i++) {
      const artifact = selectedArtifacts[i];
      if (!itineraryMap.has(artifact.museumId)) {
        itineraryMap.set(artifact.museumId, {
          museumId: artifact.museumId,
          museumName: artifact.museumName,
          artifactIds: []
        });
      }
      const museumItinerary = itineraryMap.get(artifact.museumId);
      if (museumItinerary && !museumItinerary.artifactIds.includes(artifact.id)) {
        museumItinerary.artifactIds.push(artifact.id);
      }
    }

    // 保存行程
    const updatedItinerary = Array.from(itineraryMap.values());
    AppStorage.setOrCreate('myItinerary', updatedItinerary);

    promptAction.showToast({
      message: `已添加 ${this.selectedArtifactIds.size} 件藏品到行程`,
      duration: 2000
    });

    // 跳转到我的行程页面
    setTimeout(() => {
      router.pushUrl({ url: 'pages/MyItineraryPage' } as router.RouterOptions);
    }, 500);
  }

  private getArtifactImage(imageName: string): Resource | string {
    return $rawfile(imageName);
  }
}

