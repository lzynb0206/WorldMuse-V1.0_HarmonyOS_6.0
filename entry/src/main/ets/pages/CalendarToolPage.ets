import { router } from '@kit.ArkUI';
import { EventService } from '../services/EventService';
import { HistoricalEvent } from '../models/EventModel';

@Entry
@Component
struct CalendarToolPage {
  @State currentDate: Date = new Date();
  @State todayEvents: HistoricalEvent[] = [];
  @State isLoading: boolean = true;

  private eventService: EventService = EventService.getInstance();

  aboutToAppear(): void {
    this.loadTodayEvents();
  }

  build() {
    Column() {
      // 标题
      Text('历史上的今天')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 20, bottom: 16 })

      // 日期显示
      this.buildDateDisplay()

      // 事件列表
      if (this.isLoading) {
        LoadingProgress()
          .width(40)
          .height(40)
          .color($r('app.color.button_primary'))
          .margin({ top: 40 })
      } else {
        this.buildEventsList()
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.app_background'))
  }

  @Builder
  private buildDateDisplay() {
    Column() {
      Text(this.getDateString())
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.button_primary'))
        .margin({ bottom: 8 })

      Text(this.getWeekdayString())
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
    }
    .width('100%')
    .padding({ top: 20, bottom: 20 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: 20 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  private buildEventsList() {
    if (this.todayEvents.length === 0) {
      Column() {
        Image($r('app.media.startIcon'))
          .width(60)
          .height(60)
          .opacity(0.3)
          .margin({ bottom: 12 })

        Text('暂无特别事件')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else {
      Scroll() {
        Column() {
          ForEach(this.todayEvents, (event: HistoricalEvent) => {
            this.buildEventCard(event)
          })
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
      .layoutWeight(1)
    }
  }

  @Builder
  private buildEventCard(event: HistoricalEvent) {
    Column() {
      Text(event.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 8 })
        .width('100%')

      Text(event.desc)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
        .width('100%')
        .margin({ bottom: 12 })

      Button('查看相关藏品')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.button_primary'))
        .fontColor($r('app.color.text_inverse'))
        .fontSize(14)
        .height(36)
        .borderRadius(18)
        .width('100%')
        .onClick(() => {
          this.navigateToArtifact(event.artifactId);
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: 12 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  private loadTodayEvents(): void {
    this.isLoading = true;
    setTimeout(() => {
      this.todayEvents = this.eventService.getTodayEvents();
      this.isLoading = false;
    }, 300);
  }

  private getDateString(): string {
    const month = this.currentDate.getMonth() + 1;
    const day = this.currentDate.getDate();
    return `${month}月${day}日`;
  }

  private getWeekdayString(): string {
    const weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    return weekdays[this.currentDate.getDay()];
  }

  private navigateToArtifact(artifactId: number): void {
    router.pushUrl({
      url: 'pages/ArtifactDetail',
      params: {
        artifactId: artifactId
      }
    } as router.RouterOptions);
  }
}

