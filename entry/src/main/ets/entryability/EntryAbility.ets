import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    
    // 初始化AppStorage
    if (!AppStorage.has('myItinerary')) {
      AppStorage.setOrCreate('myItinerary', []);
    }
    if (!AppStorage.has('userInterests')) {
      AppStorage.setOrCreate('userInterests', []);
    }
    if (!AppStorage.has('treasureHighScore')) {
      AppStorage.setOrCreate('treasureHighScore', 0);
    }
    if (!AppStorage.has('treasureCoins')) {
      AppStorage.setOrCreate('treasureCoins', 0);
    }
    if (!AppStorage.has('treasureBadges')) {
      AppStorage.setOrCreate('treasureBadges', '[]');
    }
    if (!AppStorage.has('hasSeenOnboarding')) {
      AppStorage.setOrCreate('hasSeenOnboarding', false);
    }
    
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    // 注意：ohos.permission.INTERNET 是 normal 权限，系统会自动授予，无需手动检查
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}