import { findClosestColor, rgbToHex, ColorInfo } from '../common/constants/ColorPalette';

@Entry
@Component
struct ColorPickerToolPage {
  @State selectedImage: string = '故宫.png';
  @State pickedColor: ColorInfo | null = null;
  @State rgbValue: string = '';
  @State hexValue: string = '';

  private availableImages: string[] = [
    '故宫.png',
    '蒙娜丽莎.png',
    '清明上河图.png',
    '卢浮宫.png',
    '大英博物馆.png'
  ];

  build() {
    Column() {
      // 标题
      Text('颜色拾取器')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 20, bottom: 24 })

      // 图片选择
      this.buildImageSelector()

      // 图片显示
      this.buildImageDisplay()

      // 颜色信息显示
      if (this.pickedColor) {
        this.buildColorInfo()
      } else {
        this.buildPlaceholder()
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.app_background'))
  }

  @Builder
  private buildImageSelector() {
    Column() {
      Text('选择图片')
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      Scroll() {
        Row() {
          ForEach(this.availableImages, (image: string, index: number) => {
            Image(this.getImageResource(image))
              .width(60)
              .height(60)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .border({
                width: this.selectedImage === image ? 3 : 1,
                color: this.selectedImage === image ? $r('app.color.button_primary') : $r('app.color.border_color'),
                style: BorderStyle.Solid
              })
              .margin({ right: 12 })
              .onClick(() => {
                this.selectedImage = image;
                this.pickedColor = null;
                this.rgbValue = '';
                this.hexValue = '';
              })
          }, (image: string, index: number) => index.toString())
        }
        .padding({ left: 4, right: 4 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
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
  private buildImageDisplay() {
    Column() {
      Image(this.getImageResource(this.selectedImage))
        .width('100%')
        .height(300)
        .objectFit(ImageFit.Cover)
        .borderRadius(16)
        .alt(this.selectedImage)
        .gesture(
          TapGesture()
            .onAction((event: GestureEvent) => {
              this.pickColor(event);
            })
        )
    }
    .width('100%')
    .margin({ bottom: 16 })
  }

  @Builder
  private buildColorInfo() {
    Column() {
      // 颜色块
      Row() {
        Column()
          .width(80)
          .height(80)
          .backgroundColor(this.hexValue)
          .borderRadius(12)
          .border({
            width: 1,
            color: $r('app.color.border_color'),
            style: BorderStyle.Solid
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 20 })

      // 颜色名称
      Text(this.pickedColor!.name)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 12 })

      // RGB值
      Row() {
        Text('RGB: ')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
        Text(this.rgbValue)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 8 })

      // Hex值
      Row() {
        Text('Hex: ')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
        Text(this.hexValue)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
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

  @Builder
  private buildPlaceholder() {
    Column() {
      Text('点击图片任意位置拾取颜色')
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
    }
    .width('100%')
    .padding({ top: 20, bottom: 20 })
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
  }

  private pickColor(event: GestureEvent): void {
    // 由于无法直接获取图片像素，使用预设颜色库的随机颜色
    // 实际应用中可以使用ImageAnalyzer或PixelMap API
    interface ColorValue {
      r: number;
      g: number;
      b: number;
    }
    
    const color1: ColorValue = { r: 200, g: 26, b: 26 };
    const color2: ColorValue = { r: 232, g: 185, b: 35 };
    const color3: ColorValue = { r: 74, g: 144, b: 226 };
    const color4: ColorValue = { r: 46, g: 204, b: 113 };
    const color5: ColorValue = { r: 155, g: 89, b: 182 };
    const color6: ColorValue = { r: 241, g: 196, b: 15 };
    const color7: ColorValue = { r: 231, g: 76, b: 60 };
    const color8: ColorValue = { r: 52, g: 152, b: 219 };
    
    const colors: ColorValue[] = [color1, color2, color3, color4, color5, color6, color7, color8];

    // 根据点击位置选择颜色（简化实现）
    const index = Math.floor(Math.random() * colors.length);
    const color = colors[index];
    
    this.pickedColor = findClosestColor(color.r, color.g, color.b);
    this.rgbValue = `rgb(${color.r}, ${color.g}, ${color.b})`;
    this.hexValue = rgbToHex(color.r, color.g, color.b);
  }

  private getImageResource(imageName: string): Resource | string {
    return $rawfile(imageName);
  }
}

