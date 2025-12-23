import router from '@ohos.router';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct SettingsPage {
  private exitAccount() {
    // 清理登录态并返回登录页面
    AppStorage.SetOrCreate('currentUser', '');
    prompt.showToast({ message: '已退出登录' });
    router.replaceUrl({ url: 'pages/MainPages/ZhiHuHuLoginPage' });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#333333')
          .padding({ left: 12, right: 8, top: 8, bottom: 8 })
          .onClick(() => {
            router.back();
          });

        Text('设置')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333');
      }
      .width('100%')
      .height(52)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      // 内容区可滚动
      Scroll() {
        Column({ space: 8 }) {
          // 关于与帮助
          Row() {
            Text('关于与帮助')
              .fontSize(16)
              .fontColor('#222222');
            Blank();
            Text('>')
              .fontSize(16)
              .fontColor('#cccccc');
          }
          .width('100%')
          .height(48)
          .padding({ left: 20, right: 20 })
          .backgroundColor('#ffffff')
          .onClick(() => {
            prompt.showToast({ message: '关于与帮助' });
          });

          // 去评价
          Row() {
            Text('去评价')
              .fontSize(16)
              .fontColor('#222222');
            Blank();
            Text('>')
              .fontSize(16)
              .fontColor('#cccccc');
          }
          .width('100%')
          .height(48)
          .padding({ left: 20, right: 20 })
          .backgroundColor('#ffffff')
          .onClick(() => {
            prompt.showToast({ message: '去应用市场评价' });
          });

          // 开源许可
          Row() {
            Text('开源许可')
              .fontSize(16)
              .fontColor('#222222');
            Blank();
            Text('>')
              .fontSize(16)
              .fontColor('#cccccc');
          }
          .width('100%')
          .height(48)
          .padding({ left: 20, right: 20 })
          .backgroundColor('#ffffff')
          .onClick(() => {
            prompt.showToast({ message: '开源许可' });
          });

          // 其他应用
          Row() {
            Text('其他应用')
              .fontSize(16)
              .fontColor('#222222');
            Blank();
            Text('>')
              .fontSize(16)
              .fontColor('#cccccc');
          }
          .width('100%')
          .height(48)
          .padding({ left: 20, right: 20 })
          .backgroundColor('#ffffff')
          .onClick(() => {
            prompt.showToast({ message: '其他应用' });
          });

          // 用户体验调研
          Row() {
            Text('用户体验调研')
              .fontSize(16)
              .fontColor('#222222');
            Blank();
            Text('>')
              .fontSize(16)
              .fontColor('#cccccc');
          }
          .width('100%')
          .height(48)
          .padding({ left: 20, right: 20 })
          .backgroundColor('#ffffff')
          .onClick(() => {
            prompt.showToast({ message: '用户体验调研' });
          });

          // 检查更新
          Column() {
            Row() {
              Text('检查更新')
                .fontSize(16)
                .fontColor('#222222');
              Blank();
            }
            .width('100%')
            .height(48)
            .padding({ left: 20, right: 20, bottom: 4 });

            Text('当前版本 1.0.0 (示例)')
              .fontSize(13)
              .fontColor('#999999')
              .padding({ left: 20, right: 20, bottom: 12 });
          }
          .backgroundColor('#ffffff');

          // 预装信息
          Column() {
            Text('预装信息')
              .fontSize(16)
              .fontColor('#222222')
              .padding({ left: 20, right: 20, top: 14, bottom: 4 });
            Text('oppo_preinstall')
              .fontSize(13)
              .fontColor('#999999')
              .padding({ left: 20, right: 20, bottom: 14 });
          }
          .backgroundColor('#ffffff');

          // 关于知乎乎
          Row() {
            Text('关于知乎乎')
              .fontSize(16)
              .fontColor('#222222');
          }
          .width('100%')
          .height(48)
          .padding({ left: 20, right: 20 })
          .backgroundColor('#ffffff')
          .onClick(() => {
            prompt.showToast({ message: '关于知乎乎' });
          });

          // 退出账号
          Button('退出账号')
            .width('100%')
            .height(48)
            .backgroundColor('#ffffff')
            .fontColor('#ff4d4f')
            .fontSize(16)
            .borderRadius(0)
            .margin({ top: 24 })
            .onClick(() => {
              this.exitAccount();
            });

          // 底部版权信息
          Column({ space: 4 }) {
            Text('© 2011 – 2025 zhihu.com')
              .fontSize(12)
              .fontColor('#aaaaaa');
            Text('All rights reserved.')
              .fontSize(12)
              .fontColor('#aaaaaa');
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 24, bottom: 24 });
        }
        .width('100%');
      }
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }
}