import { router } from '@kit.ArkUI';
import { EventService } from '../services/EventService';
import { HistoricalEvent } from '../models/EventModel';
import { DYNASTIES, UNITS, getConversionRate, Unit } from '../common/constants/UnitConverter';

@Entry
@Component
struct ToolsPage {
  @State currentTabIndex: number = 0;

  // 日历工具状态
  @State currentDate: Date = new Date();
  @State todayEvents: HistoricalEvent[] = [];
  @State isLoading: boolean = true;

  // 度量衡换算器状态
  @State selectedDynasty: string = 'han';
  @State selectedUnit: string = 'chi';
  @State inputValue: string = '1';
  @State result: string = '';

  private tabNames: string[] = ['小日历', '度量衡'];
  private eventService: EventService = EventService.getInstance();

  aboutToAppear(): void {
    if (this.currentTabIndex === 0) {
      this.loadTodayEvents();
    } else if (this.currentTabIndex === 1) {
      this.calculate();
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('小工具集')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.card_background'))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      Divider()
        .color($r('app.color.divider_color'))
        .strokeWidth(0.5)

      // Tab切换
      Row() {
        ForEach(this.tabNames, (name: string, index: number) => {
          Button(name)
            .type(ButtonType.Normal)
            .backgroundColor(this.currentTabIndex === index ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
            .fontColor(this.currentTabIndex === index ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
            .fontSize(14)
            .fontWeight(this.currentTabIndex === index ? FontWeight.Medium : FontWeight.Normal)
            .height(40)
            .layoutWeight(1)
            .borderRadius(8)
            .margin({ right: index < this.tabNames.length - 1 ? 8 : 0 })
            .onClick(() => {
              this.currentTabIndex = index;
              if (index === 0 && this.todayEvents.length === 0) {
                this.loadTodayEvents();
              } else if (index === 1 && this.result === '') {
                this.calculate();
              }
            })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor($r('app.color.card_background'))

      // 内容区域
      this.buildContent()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_background'))
  }

  @Builder
  private buildContent() {
    if (this.currentTabIndex === 0) {
      this.buildCalendarTool()
    } else {
      this.buildUnitConverter()
    }
  }

  // ========== 日历工具 ==========
  @Builder
  private buildCalendarTool() {
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

  // ========== 度量衡换算器 ==========
  @Builder
  private buildUnitConverter() {
    Column() {
      // 标题
      Text('古今度量衡换算器')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 20, bottom: 24 })

      // 朝代选择
      this.buildDynastySelector()

      // 输入区域
      this.buildInputArea()

      // 结果显示
      this.buildResultDisplay()
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.app_background'))
  }

  @Builder
  private buildDynastySelector() {
    Column() {
      Text('选择朝代')
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      Button(this.getDynastyName())
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.filter_button_background'))
        .fontColor($r('app.color.text_primary'))
        .fontSize(16)
        .width('100%')
        .height(50)
        .onClick(() => {
          this.showDynastyPicker();
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: 16 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  private buildInputArea() {
    Column() {
      Text('输入数值')
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      Row() {
        TextInput({ placeholder: '请输入数值', text: this.inputValue })
          .layoutWeight(1)
          .height(50)
          .fontSize(18)
          .onChange((value: string) => {
            this.inputValue = value;
            this.calculate();
          })

        Button(this.getUnitName())
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.filter_button_background'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .width(120)
          .height(50)
          .margin({ left: 12 })
          .onClick(() => {
            this.showUnitPicker();
          })
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .margin({ bottom: 16 })
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  private buildResultDisplay() {
    Column() {
      Text('换算结果')
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 16 })

      Text(this.result)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.button_primary'))
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 24, bottom: 24 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  // ========== 日历工具方法 ==========
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

  // ========== 度量衡换算器方法 ==========
  private getDynastyName(): string {
    for (let i = 0; i < DYNASTIES.length; i++) {
      if (DYNASTIES[i].id === this.selectedDynasty) {
        return DYNASTIES[i].name;
      }
    }
    return '汉代';
  }

  private getUnitName(): string {
    for (let i = 0; i < UNITS.length; i++) {
      if (UNITS[i].id === this.selectedUnit) {
        return UNITS[i].name;
      }
    }
    return '尺';
  }

  private getSelectedDynastyIndex(): number {
    for (let i = 0; i < DYNASTIES.length; i++) {
      if (DYNASTIES[i].id === this.selectedDynasty) {
        return i;
      }
    }
    return 0;
  }

  private getSelectedUnitIndex(): number {
    for (let i = 0; i < UNITS.length; i++) {
      if (UNITS[i].id === this.selectedUnit) {
        return i;
      }
    }
    return 0;
  }

  private showDynastyPicker(): void {
    const currentIndex = this.getSelectedDynastyIndex();
    const nextIndex = (currentIndex + 1) % DYNASTIES.length;
    this.selectedDynasty = DYNASTIES[nextIndex].id;
    this.calculate();
  }

  private showUnitPicker(): void {
    const currentIndex = this.getSelectedUnitIndex();
    const nextIndex = (currentIndex + 1) % UNITS.length;
    this.selectedUnit = UNITS[nextIndex].id;
    this.calculate();
  }

  private calculate(): void {
    const value = parseFloat(this.inputValue);
    if (isNaN(value) || value <= 0) {
      this.result = '请输入有效数值';
      return;
    }

    const conversion = getConversionRate(this.selectedDynasty);
    if (!conversion) {
      this.result = '换算失败';
      return;
    }

    let unit: Unit | null = null;
    for (let i = 0; i < UNITS.length; i++) {
      if (UNITS[i].id === this.selectedUnit) {
        unit = UNITS[i];
        break;
      }
    }
    
    if (!unit) {
      this.result = '单位错误';
      return;
    }

    let convertedValue = 0;
    let unitName = '';

    if (unit.type === 'length') {
      if (this.selectedUnit === 'chi') {
        convertedValue = value * conversion.chi;
        unitName = '厘米';
      } else if (this.selectedUnit === 'zhang') {
        convertedValue = value * conversion.zhang;
        unitName = '厘米';
      } else if (this.selectedUnit === 'cun') {
        convertedValue = value * conversion.cun;
        unitName = '厘米';
      }
    } else {
      if (this.selectedUnit === 'jin') {
        convertedValue = value * conversion.jin;
        unitName = '克';
      } else if (this.selectedUnit === 'liang') {
        convertedValue = value * conversion.liang;
        unitName = '克';
      } else if (this.selectedUnit === 'qian') {
        convertedValue = value * conversion.qian;
        unitName = '克';
      }
    }

    // 格式化显示
    if (convertedValue >= 1000 && unit.type === 'length') {
      this.result = `${(convertedValue / 100).toFixed(2)} 米`;
    } else if (convertedValue >= 1000 && unit.type === 'weight') {
      this.result = `${(convertedValue / 1000).toFixed(2)} 千克`;
    } else {
      this.result = `${convertedValue.toFixed(2)} ${unitName}`;
    }
  }

}