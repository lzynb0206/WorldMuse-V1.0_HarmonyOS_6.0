import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { RecommendService } from '../services/RecommendService';
import { ArtifactService } from '../services/ArtifactService';
import { Artifact, RecommendResult } from '../models/ArtifactModel';
import { ItineraryItem } from '../models/ArtifactModel';

@Entry
@Component
struct RecommendPage {
  @State selectedTags: string[] = [];
  @State recommendations: RecommendResult[] = [];
  @State selectedArtifactIds: Set<number> = new Set();
  @State isLandscape: boolean = false;
  @State isLoading: boolean = true;

  private artifactService: ArtifactService = ArtifactService.getInstance();
  private recommendService: RecommendService = RecommendService.getInstance();

  async aboutToAppear(): Promise<void> {
    // 获取路由参数
    const params = (router.getParams() as Record<string, Object>) || {};
    if (params['selectedTags']) {
      this.selectedTags = params['selectedTags'] as string[];
    } else {
      // 如果没有参数，从AppStorage获取
      const savedTags = AppStorage.get<string[]>('userInterests');
      this.selectedTags = savedTags || [];
    }

    // 加载推荐数据
    await this.loadRecommendations();
  }

  private async loadRecommendations(): Promise<void> {
    this.isLoading = true;
    
    // 模拟异步加载
    setTimeout(() => {
      // 获取所有博物馆ID（临时方案，实际应该从路由参数获取）
      const allMuseumIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8];
      this.recommendations = this.recommendService.getRecommendations(allMuseumIds, this.selectedTags, 3, 8);
      this.isLoading = false;
    }, 300);
  }

  build() {
    Stack() {
      if (this.isLoading) {
        this.buildLoadingView()
      } else {
        this.buildContent()
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
  private buildLoadingView() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color($r('app.color.button_primary'))
      
      Text('正在生成推荐...')
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private buildContent() {
    Column() {
      // 导航栏
      this.buildNavBar()

      Scroll() {
        Column() {
          // 推荐说明
          this.buildRecommendHeader()

          // 推荐列表
          this.buildRecommendList()
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Auto)

      // 底部操作栏
      this.buildBottomBar()
    }
    .width('100%')
    .height('100%')
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
        
        Text('个性化推荐')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .margin({ left: 8 })

        Button('我的行程')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.button_primary'))
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .height(32)
          .padding({ left: 12, right: 12 })
          .borderRadius(16)
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
  private buildRecommendHeader() {
    Column() {
      Row() {
        Text('为您推荐')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        Text(`共${this.recommendations.length}件藏品`)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.selectedTags.length > 0) {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          ForEach(this.selectedTags, (tag: string) => {
            Text(tag)
              .fontSize(12)
              .fontColor($r('app.color.button_primary'))
              .backgroundColor($r('app.color.button_primary'))
              .opacity(0.15)
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
              .borderRadius(12)
              .margin({ right: 8, bottom: 8 })
          })
        }
        .width('100%')
      }

      Row() {
        Button('重新推荐')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .fontColor($r('app.color.button_primary'))
          .fontSize(14)
          .height(32)
          .padding({ left: 12, right: 12 })
          .borderRadius(16)
          .border({
            width: 1,
            color: $r('app.color.button_primary'),
            style: BorderStyle.Solid
          })
          .onClick(() => {
            router.pushUrl({ url: 'pages/InterestSelectPage' } as router.RouterOptions);
          })
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 20, bottom: 16 })
    .backgroundColor($r('app.color.card_background'))
    .margin({ top: 16, left: 16, right: 16 })
    .borderRadius(16)
  }

  @Builder
  private buildRecommendList() {
    Column() {
      ForEach(this.recommendations, (item: RecommendResult, index: number) => {
        this.buildRecommendItem(item.artifact, index)
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12 })
  }

  @Builder
  private buildRecommendItem(artifact: Artifact, index: number) {
    Row() {
      // 左侧图片
      Stack() {
        Image(this.getArtifactImage(artifact.image))
          .width(100)
          .height(100)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)
          .alt(artifact.title)

        if (this.isArtifactSelected(artifact.id)) {
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
            .margin(8)
            .backgroundColor('rgba(57, 73, 171, 0.8)')
            .borderRadius(12)
        }
      }
      .width(100)
      .height(100)
      .margin({ right: 12 })

      // 右侧内容
      Column() {
        Text(artifact.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ bottom: 4 })
          .width('100%')

        Text(artifact.museumName)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 6 })
          .width('100%')

        Text(artifact.desc)
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(18)
          .margin({ bottom: 8 })
          .width('100%')

        // 标签
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          ForEach(artifact.tags.slice(0, 3), (tag: string) => {
            Text(tag)
              .fontSize(10)
              .fontColor($r('app.color.text_tertiary'))
              .backgroundColor($r('app.color.divider_color'))
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(8)
              .margin({ right: 6, bottom: 6 })
          })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: 12 })
    .border({
      width: this.isArtifactSelected(artifact.id) ? 2 : 1,
      color: this.isArtifactSelected(artifact.id) ? $r('app.color.button_primary') : $r('app.color.border_color'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.toggleSelect(artifact.id);
    })
  }

  private isArtifactSelected(artifactId: number): boolean {
    return this.selectedArtifactIds.has(artifactId);
  }

  @Builder
  private buildBottomBar() {
    Column() {
      Row() {
        Text(`已选择 ${this.selectedArtifactIds.size} 件藏品`)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)

        Button('加入行程')
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.button_primary'))
          .fontColor($r('app.color.text_inverse'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .height(44)
          .padding({ left: 24, right: 24 })
          .borderRadius(22)
          .enabled(this.selectedArtifactIds.size > 0)
          .onClick(() => {
            this.addToItinerary();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .backgroundColor($r('app.color.card_background'))
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: -2
    })
  }

  private toggleSelect(artifactId: number): void {
    if (this.selectedArtifactIds.has(artifactId)) {
      this.selectedArtifactIds.delete(artifactId);
    } else {
      this.selectedArtifactIds.add(artifactId);
    }
    // 触发状态更新
    this.selectedArtifactIds = new Set(this.selectedArtifactIds);
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
    const currentItinerary = AppStorage.get<ItineraryItem[]>('myItinerary') || [];
    const artifactService = ArtifactService.getInstance();
    let maxOrder = currentItinerary.length > 0 
      ? Math.max(...currentItinerary.map(item => item.order)) 
      : -1;

    // 添加选中的藏品到行程
    const newItems: ItineraryItem[] = [];
    this.selectedArtifactIds.forEach(artifactId => {
      // 检查是否已存在
      const exists = currentItinerary.some(item => item.artifactId === artifactId);
      if (!exists) {
        const artifact = artifactService.getArtifactById(artifactId);
        if (artifact) {
          maxOrder++;
          newItems.push({
            artifactId: artifact.id,
            artifact: artifact,
            order: maxOrder
          });
        }
      }
    });

    if (newItems.length > 0) {
      const updatedItinerary = [...currentItinerary, ...newItems];
      AppStorage.setOrCreate('myItinerary', updatedItinerary);
      
      promptAction.showToast({
        message: `已添加 ${newItems.length} 件藏品到行程`,
        duration: 2000
      });

      // 清空选择
      this.selectedArtifactIds = new Set();
    } else {
      promptAction.showToast({
        message: '所选藏品已在行程中',
        duration: 2000
      });
    }
  }

  private getArtifactImage(imageName: string): Resource | string {
    const imageMap: Record<string, Resource> = {
      '清明上河图.png': $rawfile('清明上河图.png'),
      '罗塞塔石碑.png': $rawfile('罗塞塔石碑.png'),
      '蒙娜丽莎.png': $rawfile('蒙娜丽莎.png'),
      '兵马俑.png': $rawfile('兵马俑.png'),
      '图坦卡蒙黄金面具.png': $rawfile('图坦卡蒙黄金面具.png'),
      '维伦多夫的维纳斯.png': $rawfile('维伦多夫的维纳斯.png'),
      '大卫像.webp': $rawfile('大卫像.webp'),
      '星夜.webp': $rawfile('星夜.webp'),
      '富春山居图.webp': $rawfile('富春山居图.webp'),
      '唐三彩复刻.png': $rawfile('唐三彩复刻.png'),
      '青铜器复刻.png': $rawfile('青铜器复刻.png'),
      '睡莲.webp': $rawfile('睡莲.webp'),
      '自由引导人民.png': $rawfile('自由引导人民.png'),
      '断臂的维纳斯.jpg': $rawfile('断臂的维纳斯.jpg'),
      '千里江山图文创.png': $rawfile('千里江山图文创.png')
    };
    return imageMap[imageName] || $rawfile('兵马俑.png');
  }
}

