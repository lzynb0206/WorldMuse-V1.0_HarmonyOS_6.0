import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { GameService } from '../services/GameService';
import { TreasureQuestion } from '../models/GameModel';
import { Artifact } from '../models/ArtifactModel';

/**
 * 游戏状态
 */
enum GameState {
  START, // 开始页面
  PLAYING, // 游戏中
  RESULT // 结果页面
}

@Entry
@Component
struct TreasureHuntPage {
  @State highScore: number = 0;
  @State totalCoins: number = 0;
  @State unlockedBadges: string = '[]';

  @State gameState: GameState = GameState.START;
  @State questions: TreasureQuestion[] = [];
  @State currentQuestionIndex: number = 0;
  @State selectedAnswer: number = -1;
  @State isAnswered: boolean = false;
  @State score: number = 0;
  @State correctCount: number = 0;
  @State comboCount: number = 0;
  @State maxCombo: number = 0;
  @State coinsEarned: number = 0;
  @State isLandscape: boolean = false;

  private gameService: GameService = GameService.getInstance();

  aboutToAppear(): void {
    // 加载保存的数据
    this.highScore = AppStorage.get<number>('treasureHighScore') || 0;
    this.totalCoins = AppStorage.get<number>('treasureCoins') || 0;
    this.unlockedBadges = AppStorage.get<string>('treasureBadges') || '[]';
  }

  build() {
    Stack() {
      if (this.gameState === GameState.START) {
        this.buildStartPage()
      } else if (this.gameState === GameState.PLAYING) {
        this.buildGamePage()
      } else if (this.gameState === GameState.RESULT) {
        this.buildResultPage()
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
  private buildStartPage() {
    Column() {
      // 标题
      Column() {
        Text('🏛️')
          .fontSize(80)
          .margin({ bottom: 16 })

        Text('博物馆寻宝')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ bottom: 8 })

        Text('根据线索找出正确的文物')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
      }
      .width('100%')
      .padding({ top: 60, bottom: 40 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 游戏说明
      Column() {
        Row() {
          Text('📝')
            .fontSize(24)
            .margin({ right: 12 })
          Column() {
            Text('游戏规则')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })
            Text('根据文字线索，从4个选项中选择正确的文物')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 20 })

        Row() {
          Text('💰')
            .fontSize(24)
            .margin({ right: 12 })
          Column() {
            Text('奖励机制')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })
            Text('答对得金币，连续正确有连击加分')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 20 })

        Row() {
          Text('🏆')
            .fontSize(24)
            .margin({ right: 12 })
          Column() {
            Text('最高分')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })
            Text(`${this.highScore} 分`)
              .fontSize(20)
              .fontColor($r('app.color.button_primary'))
              .fontWeight(FontWeight.Bold)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(24)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(20)
      .margin({ left: 16, right: 16, bottom: 40 })
      .shadow({
        radius: 12,
        color: 'rgba(0, 0, 0, 0.08)',
        offsetX: 0,
        offsetY: 4
      })

      // 开始按钮
      Button('开始寻宝')
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.button_primary'))
        .fontColor($r('app.color.text_inverse'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('80%')
        .height(56)
        .borderRadius(28)
        .margin({ bottom: 40 })
        .onClick(() => {
          this.startGame();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  private buildGamePage() {
    if (this.questions.length > 0 && this.currentQuestionIndex < this.questions.length) {

      Column() {
        // 顶部信息栏
        Row() {
          Text(`第 ${this.currentQuestionIndex + 1} / ${this.questions.length} 题`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .layoutWeight(1)

          Row() {
            Text('💰')
              .fontSize(18)
              .margin({ right: 4 })
            Text(`${this.totalCoins}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.button_primary'))
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .backgroundColor($r('app.color.card_background'))

        // 进度条
        Progress({ value: this.getProgress(), total: 100, type: ProgressType.Linear })
          .width('100%')
          .height(4)
          .color($r('app.color.button_primary'))
          .backgroundColor($r('app.color.divider_color'))

        Scroll() {
          Column() {
            // 连击提示
            if (this.comboCount > 1) {
              Row() {
                Text(`🔥 ${this.comboCount} 连击！`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF6B35')
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding(12)
              .backgroundColor('#FFF3E0')
              .borderRadius(12)
              .margin({ top: 16, bottom: 8 })
            }

            // 线索卡片
            Column() {
              Text('💡 线索')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ bottom: 12 })

              Text(this.getCurrentQuestion().clue)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .lineHeight(28)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .padding(24)
            .backgroundColor($r('app.color.card_background'))
            .borderRadius(20)
            .margin({ top: 20, left: 16, right: 16, bottom: 20 })
            .shadow({
              radius: 12,
              color: 'rgba(0, 0, 0, 0.08)',
              offsetX: 0,
              offsetY: 4
            })

            // 选项网格
            Grid() {
              ForEach(this.getCurrentQuestion().options, (artifactId: number, index: number) => {
                GridItem() {
                  this.buildOptionCard(artifactId, index)
                }
              })
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 20 })
          }
          .width('100%')
        }
        .layoutWeight(1)

        // 底部按钮
        if (this.isAnswered) {
          Column() {
            // 解析说明
            if (this.isAnswerCorrect()) {
              Text('✅ 回答正确！')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#4CAF50')
                .margin({ bottom: 8 })
            } else {
              Text('❌ 回答错误')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#F44336')
                .margin({ bottom: 8 })
            }

            Text(this.getCurrentQuestion().explain)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)
              .margin({ bottom: 16 })
              .padding({ left: 16, right: 16 })

            Button(this.currentQuestionIndex === this.questions.length - 1 ? '查看结果' : '下一题')
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.button_primary'))
              .fontColor($r('app.color.text_inverse'))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('90%')
              .height(48)
              .borderRadius(24)
              .onClick(() => {
                this.nextQuestion();
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.card_background'))
        }
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  private buildOptionCard(artifactId: number, index: number) {

    Column() {
      Image(this.getArtifactImage(this.getArtifactImageName(artifactId)))
        .width('100%')
        .height(120)
        .objectFit(ImageFit.Cover)
        .borderRadius(12)
        .alt(this.getArtifactTitle(artifactId))

      Text(this.getArtifactTitle(artifactId))
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(16)
    .border({
      width: this.isOptionSelected(artifactId) ? 3 : (this.isAnswered && this.isOptionCorrect(artifactId) ? 3 : 1),
      color: this.isOptionSelected(artifactId)
        ? (this.isOptionCorrect(artifactId) ? '#4CAF50' : '#F44336')
        : (this.isAnswered && this.isOptionCorrect(artifactId) ? '#4CAF50' : $r('app.color.border_color')),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 8,
      color: this.isOptionSelected(artifactId) ? 'rgba(57, 73, 171, 0.2)' : 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 2
    })
    .opacity(this.isAnswered && !this.isOptionCorrect(artifactId) && !this.isOptionSelected(artifactId) ? 0.5 : 1)
    .onClick(() => {
      if (!this.isAnswered) {
        this.selectAnswer(artifactId);
      }
    })
  }

  @Builder
  private buildResultPage() {
    Scroll() {
      Column() {
        // 结果标题
        Column() {
          Text('🎉')
            .fontSize(80)
            .margin({ bottom: 16 })

          Text('寻宝完成！')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 8 })

          Text(`得分：${this.score} 分`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.button_primary'))
        }
        .width('100%')
        .padding({ top: 40, bottom: 30 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        // 统计信息
        Row() {
          Column() {
            Text(`${this.correctCount}`)
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
            Text('答对题数')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)

          Divider()
            .vertical(true)
            .color($r('app.color.divider_color'))
            .strokeWidth(1)
            .height(50)

          Column() {
            Text(`${this.maxCombo}`)
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF6B35')
            Text('最大连击')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)

          Divider()
            .vertical(true)
            .color($r('app.color.divider_color'))
            .strokeWidth(1)
            .height(50)

          Column() {
            Text(`+${this.coinsEarned}`)
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFD700')
            Text('获得金币')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .padding(20)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(20)
        .margin({ left: 16, right: 16, bottom: 20 })
        .shadow({
          radius: 12,
          color: 'rgba(0, 0, 0, 0.08)',
          offsetX: 0,
          offsetY: 4
        })

        // 最高分提示
        if (this.score > this.highScore) {
          Row() {
            Text('🏆 新纪录！')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFD700')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding(16)
          .backgroundColor('#FFF9C4')
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 20 })
        }

        // 操作按钮
        Column() {
          Button('再来一局')
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.button_primary'))
            .fontColor($r('app.color.text_inverse'))
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .height(50)
            .borderRadius(25)
            .margin({ bottom: 12 })
            .onClick(() => {
              this.startGame();
            })

            Button('返回首页')
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.filter_button_background'))
            .fontColor($r('app.color.text_primary'))
            .fontSize(16)
            .width('100%')
            .height(46)
            .borderRadius(23)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Index' } as router.RouterOptions);
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 40 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }

  private startGame(): void {
    this.questions = this.gameService.getTreasureQuestions(10);
    this.currentQuestionIndex = 0;
    this.selectedAnswer = -1;
    this.isAnswered = false;
    this.score = 0;
    this.correctCount = 0;
    this.comboCount = 0;
    this.maxCombo = 0;
    this.coinsEarned = 0;
    this.gameState = GameState.PLAYING;
  }

  private selectAnswer(artifactId: number): void {
    this.selectedAnswer = artifactId;
    this.isAnswered = true;

    const question = this.questions[this.currentQuestionIndex];
    const isCorrect = artifactId === question.answer;

    if (isCorrect) {
      this.correctCount++;
      this.comboCount++;
      if (this.comboCount > this.maxCombo) {
        this.maxCombo = this.comboCount;
      }
    } else {
      this.comboCount = 0;
    }
  }

  private nextQuestion(): void {
    if (this.currentQuestionIndex < this.questions.length - 1) {
      this.currentQuestionIndex++;
      this.selectedAnswer = -1;
      this.isAnswered = false;
    } else {
      this.finishGame();
    }
  }

  private getCurrentQuestion(): TreasureQuestion {
    if (this.questions.length > 0 && this.currentQuestionIndex < this.questions.length) {
      return this.questions[this.currentQuestionIndex];
    }
    return this.questions[0];
  }

  private getProgress(): number {
    if (this.questions.length === 0) {
      return 0;
    }
    return ((this.currentQuestionIndex + 1) / this.questions.length) * 100;
  }

  private isAnswerCorrect(): boolean {
    return this.selectedAnswer === this.getCurrentQuestion().answer;
  }

  private isOptionSelected(artifactId: number): boolean {
    return this.selectedAnswer === artifactId;
  }

  private isOptionCorrect(artifactId: number): boolean {
    return artifactId === this.getCurrentQuestion().answer;
  }

  private getArtifactTitle(artifactId: number): string {
    const artifact = this.gameService.getArtifactById(artifactId);
    return artifact?.title || '未知';
  }

  private getArtifactImageName(artifactId: number): string {
    const artifact = this.gameService.getArtifactById(artifactId);
    return artifact?.image || '';
  }

  private finishGame(): void {
    // 计算得分和金币
    this.score = this.gameService.calculateScore(
      this.correctCount,
      this.questions.length,
      this.maxCombo
    );
    this.coinsEarned = this.gameService.calculateCoins(
      this.correctCount,
      this.maxCombo
    );

    // 更新最高分
    if (this.score > this.highScore) {
      this.highScore = this.score;
      AppStorage.setOrCreate('treasureHighScore', this.highScore);
    }

    // 更新金币
    this.totalCoins = this.totalCoins + this.coinsEarned;
    AppStorage.setOrCreate('treasureCoins', this.totalCoins);

    // 检查徽章
    const badges = this.gameService.checkBadges(this.score, 'treasure');
    if (badges.length > 0) {
      const currentBadges = JSON.parse(this.unlockedBadges || '[]') as string[];
      badges.forEach(badge => {
        if (!currentBadges.includes(badge)) {
          currentBadges.push(badge);
        }
      });
      this.unlockedBadges = JSON.stringify(currentBadges);
      AppStorage.setOrCreate('treasureBadges', this.unlockedBadges);
    }

    this.gameState = GameState.RESULT;
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

