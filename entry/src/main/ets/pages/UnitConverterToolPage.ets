import { DYNASTIES, UNITS, getConversionRate, Dynasty, Unit, ConversionRate } from '../common/constants/UnitConverter';

@Entry
@Component
struct UnitConverterToolPage {
  @State selectedDynasty: string = 'han';
  @State selectedUnit: string = 'chi';
  @State inputValue: string = '1';
  @State result: string = '';

  aboutToAppear(): void {
    this.calculate();
  }

  build() {
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
    // 简化实现：循环切换朝代
    const currentIndex = this.getSelectedDynastyIndex();
    const nextIndex = (currentIndex + 1) % DYNASTIES.length;
    this.selectedDynasty = DYNASTIES[nextIndex].id;
    this.calculate();
  }

  private showUnitPicker(): void {
    // 简化实现：循环切换单位
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

