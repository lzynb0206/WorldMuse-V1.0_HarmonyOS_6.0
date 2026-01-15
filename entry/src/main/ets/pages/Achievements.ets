import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

interface Achievement {
  id: string;
  title: string;
  description: string;
  icon: string;
  condition: string;
  progress: number;
  maxProgress: number;
  unlocked: boolean;
  category: 'explore' | 'collect' | 'learn' | 'special';
}

@Entry
@Component
struct Achievements {
  @State achievements: Achievement[] = [
    {
      id: 'explore_5',
      title: '初出茅庐',
      description: '探索5个博物馆',
      icon: '🏛️',
      condition: 'explore_museums',
      progress: 0,
      maxProgress: 5,
      unlocked: false,
      category: 'explore'
    },
    {
      id: 'explore_10',
      title: '博物馆爱好者',
      description: '探索10个博物馆',
      icon: '🎨',
      condition: 'explore_museums',
      progress: 0,
      maxProgress: 10,
      unlocked: false,
      category: 'explore'
    },
    {
      id: 'artifact_10',
      title: '文物鉴赏家',
      description: '查看10件藏品',
      icon: '🏺',
      condition: 'view_artifacts',
      progress: 0,
      maxProgress: 10,
      unlocked: false,
      category: 'explore'
    },
    {
      id: 'artifact_20',
      title: '文物专家',
      description: '查看20件藏品',
      icon: '👑',
      condition: 'view_artifacts',
      progress: 0,
      maxProgress: 20,
      unlocked: false,
      category: 'explore'
    },
    {
      id: 'collect_5',
      title: '收藏新手',
      description: '收藏5个内容',
      icon: '⭐',
      condition: 'collect_items',
      progress: 0,
      maxProgress: 5,
      unlocked: false,
      category: 'collect'
    },
    {
      id: 'collect_20',
      title: '收藏达人',
      description: '收藏20个内容',
      icon: '💎',
      condition: 'collect_items',
      progress: 0,
      maxProgress: 20,
      unlocked: false,
      category: 'collect'
    },
    {
      id: 'quiz_80',
      title: '知识达人',
      description: '问答正确率达到80%',
      icon: '📚',
      condition: 'quiz_score',
      progress: 0,
      maxProgress: 80,
      unlocked: false,
      category: 'learn'
    },
    {
      id: 'quiz_100',
      title: '满分学霸',
      description: '问答获得满分',
      icon: '🎓',
      condition: 'quiz_perfect',
      progress: 0,
      maxProgress: 1,
      unlocked: false,
      category: 'learn'
    },
    {
      id: 'timeline_all',
      title: '历史通',
      description: '浏览完整时间线',
      icon: '📜',
      condition: 'view_timeline',
      progress: 0,
      maxProgress: 1,
      unlocked: false,
      category: 'special'
    },
    {
      id: 'daily_7',
      title: '坚持探索',
      description: '连续7天使用应用',
      icon: '🔥',
      condition: 'daily_login',
      progress: 0,
      maxProgress: 7,
      unlocked: false,
      category: 'special'
    }
  ];

  @State selectedCategory: string = 'all';
  @State preferencesStore: preferences.Preferences | null = null;

  aboutToAppear() {
    this.loadAchievements();
  }

  async loadAchievements() {
    try {
      const context = getContext(this) as Context;
      this.preferencesStore = await preferences.getPreferences(context, 'user_data');
      if (!this.preferencesStore) return;

      // 加载用户数据
      const exploredMuseums = await this.preferencesStore.get('exploredMuseums', 0);
      const viewedArtifacts = await this.preferencesStore.get('viewedArtifacts', 0);
      const collectedItems = await this.preferencesStore.get('collectedItems', 0);
      const quizBestScore = await this.preferencesStore.get('quizBestScore', 0);
      const viewedTimeline = await this.preferencesStore.get('viewedTimeline', false);
      const dailyLogin = await this.preferencesStore.get('dailyLogin', 0);

      // 更新成就进度
      this.achievements.forEach(achievement => {
        switch (achievement.condition) {
          case 'explore_museums':
            achievement.progress = exploredMuseums as number;
            break;
          case 'view_artifacts':
            achievement.progress = viewedArtifacts as number;
            break;
          case 'collect_items':
            achievement.progress = collectedItems as number;
            break;
          case 'quiz_score':
            achievement.progress = quizBestScore as number;
            break;
          case 'quiz_perfect':
            achievement.progress = (quizBestScore as number) >= 100 ? 1 : 0;
            break;
          case 'view_timeline':
            achievement.progress = (viewedTimeline as boolean) ? 1 : 0;
            break;
          case 'daily_login':
            achievement.progress = dailyLogin as number;
            break;
        }
        achievement.unlocked = achievement.progress >= achievement.maxProgress;
      });

      this.achievements = [...this.achievements];
    } catch (error) {
      console.error('加载成就失败:', error);
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 导航栏
          this.NavBar()

          Column() {
            Text('成就系统')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .margin({ bottom: 8 })

            Text('完成成就，解锁徽章，记录您的探索历程')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .margin({ bottom: 30 })

            // 统计信息
            this.Statistics()

            // 分类筛选
            this.CategoryFilter()

            // 成就列表
            this.AchievementsList()
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 20, bottom: 20 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ top: 20, left: 16, right: 16, bottom: 20 })
        }
        .width('100%')
        .backgroundColor($r('app.color.app_background'))
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  NavBar() {
    Column() {
      // 顶部标题栏
      Row() {
        Image($r('app.media.startIcon'))
          .width(24)
          .height(24)
          .margin({ right: 8 })
        Text('云览天下')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      // 可滑动的导航菜单
      Scroll() {
        Row() {
          this.NavItem('首页', 'pages/Index', false)
          this.NavItem('创建新行程', 'pages/SelectMuseumsPage', false)
          this.NavItem('我的行程', 'pages/MyItineraryPage', false)
          this.NavItem('博物馆', 'pages/MuseumList', false)
          this.NavItem('藏品探索', 'pages/ArtifactExplore', false)
          this.NavItem('资讯中心', 'pages/News', false)
          this.NavItem('历史时间线', 'pages/Timeline', false)
          this.NavItem('知识问答', 'pages/Quiz', false)
          this.NavItem('寻宝游戏', 'pages/TreasureHuntPage', false)
          this.NavItem('成就系统', '', true)
          this.NavItem('小工具集', 'pages/ToolsPage', false)
        }
        .height(48)
        .padding({ left: 16, right: 16 })
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Auto)
      .width('100%')
      .height(48)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder
  NavItem(text: string, url: string, active: boolean) {
    Text(text)
      .fontSize(14)
      .fontColor(active ? $r('app.color.primary_light') : $r('app.color.text_secondary'))
      .fontWeight(active ? FontWeight.Medium : FontWeight.Normal)
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .margin({ right: 8 })
      .onClick(() => {
        if (url) {
          router.pushUrl({ url: url } as router.RouterOptions)
        }
      })
  }

  @Builder
  Statistics() {
    Row() {
      Column() {
        Text(`${this.achievements.filter(a => a.unlocked).length}`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_light'))
        Text('已解锁')
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
      }
      .layoutWeight(1)

      Column() {
        Text(`${this.achievements.length}`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_light'))
        Text('总成就')
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
      }
      .layoutWeight(1)

      Column() {
        Text(`${Math.round(this.achievements.filter(a => a.unlocked).length / this.achievements.length * 100)}%`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_light'))
        Text('完成度')
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
      }
      .layoutWeight(1)
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.divider_color'))
    .opacity(0.3)
    .borderRadius(12)
    .margin({ bottom: 20 })
  }

  @Builder
  CategoryFilter() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
      this.CategoryButton('全部', 'all')
      this.CategoryButton('探索', 'explore')
      this.CategoryButton('收藏', 'collect')
      this.CategoryButton('学习', 'learn')
      this.CategoryButton('特殊', 'special')
    }
    .width('100%')
    .padding(20)
    .backgroundColor($r('app.color.divider_color'))
    .opacity(0.3)
    .borderRadius(12)
    .margin({ bottom: 20 })
  }

  @Builder
  CategoryButton(text: string, category: string) {
    Button(text)
      .type(ButtonType.Normal)
      .backgroundColor(this.selectedCategory === category ? $r('app.color.button_primary') : $r('app.color.filter_button_background'))
      .fontColor(this.selectedCategory === category ? $r('app.color.text_inverse') : $r('app.color.text_primary'))
      .fontSize(14)
      .height(36)
      .padding({ left: 20, right: 20 })
      .borderRadius(25)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.selectedCategory = category;
      })
  }

  @Builder
  AchievementsList() {
    Column() {
      ForEach(this.getFilteredAchievements(), (achievement: Achievement) => {
        this.AchievementCard(achievement)
      })
    }
    .width('100%')
  }

  getFilteredAchievements(): Achievement[] {
    if (this.selectedCategory === 'all') {
      return this.achievements;
    }
    return this.achievements.filter(a => a.category === this.selectedCategory);
  }

  @Builder
  AchievementCard(achievement: Achievement) {
    Row() {
      // 图标
      Column() {
        Text(achievement.icon)
          .fontSize(40)
        if (achievement.unlocked) {
          Text('✓')
            .fontSize(16)
            .fontColor($r('app.color.primary_light'))
            .fontWeight(FontWeight.Bold)
            .margin({ top: -10 })
        }
      }
      .width(60)
      .height(60)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(achievement.unlocked ? $r('app.color.primary_light') : $r('app.color.divider_color'))
      .opacity(achievement.unlocked ? 0.2 : 0.3)
      .borderRadius(30)
      .margin({ right: 16 })
      .opacity(achievement.unlocked ? 1 : 0.6)

      // 内容
      Column() {
        Row() {
          Text(achievement.title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(achievement.unlocked ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
            .layoutWeight(1)

          if (achievement.unlocked) {
            Text('已解锁')
              .fontSize(12)
              .fontColor($r('app.color.primary_light'))
              .backgroundColor($r('app.color.primary_lighter'))
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(10)
          }
        }
        .width('100%')
        .margin({ bottom: 6 })

        Text(achievement.description)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .margin({ bottom: 8 })
          .width('100%')

        // 进度条
        Row() {
          Progress({ value: achievement.progress, total: achievement.maxProgress })
            .width('100%')
            .height(6)
            .color(achievement.unlocked ? '#3949ab' : '#cccccc')
            .layoutWeight(1)

          Text(`${achievement.progress}/${achievement.maxProgress}`)
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
            .margin({ left: 8 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(12)
    .margin({ bottom: 12 })
    .border({
      width: achievement.unlocked ? 2 : 1,
      color: achievement.unlocked ? $r('app.color.primary_light') : $r('app.color.border_color'),
      style: BorderStyle.Solid
    })
    .shadow({
      radius: 8,
      color: $r('app.color.shadow_color_light'),
      offsetX: 0,
      offsetY: 2
    })
  }
}

