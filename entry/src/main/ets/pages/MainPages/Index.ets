import router from '@ohos.router';
import prompt from '@ohos.promptAction';

function safeNav(url: string) {
  try {
    router.replaceUrl({ url });
  } catch (e) {
    prompt.showToast({ message: '跳转失败，请确认 module.json5 已登记页面' });
  }
}

@Entry
@Component
struct Index {
  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 顶部卡片 + 主按钮
        Column({ space: 12 }) {
          Text('知乎乎')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0f88eb');

          Text('发现并分享高质量问答 · 登录后解锁完整体验')
            .fontSize(14)
            .fontColor('#4d4d4d')
            .textAlign(TextAlign.Center);

          // 主按钮：进入登录
          Button('进入知乎乎')
            .width(220)
            .height(46)
            .backgroundColor('#0f88eb')
            .fontColor('#ffffff')
            .borderRadius(10)
            .shadow({ radius: 10, color: '#d7e8fb', offsetX: 0, offsetY: 3 })
            .onClick(() => {
              safeNav('pages/MainPages/ZhiHuHuLoginPage');
            });

          // 次按钮：一键体验
          Button('一键体验（跳过登录）')
            .width(220)
            .height(44)
            .backgroundColor('#eef5ff')
            .fontColor('#0f88eb')
            .borderRadius(10)
            .onClick(() => {
              // 先进入知乎乎主页面，再通过主页面上的按钮进入带底部导航栏的页面
              safeNav('pages/MainPages/ZhiHuHuHomePage');
            });
        }
        .padding({ top: 32, bottom: 32, left: 24, right: 24 })
        .backgroundColor('#ffffff')
        .borderRadius(16)
        .shadow({ radius: 18, color: '#dfe6f3', offsetX: 0, offsetY: 8 })
        .alignItems(HorizontalAlign.Center)

        // 特色介绍
        Column({ space: 10 }) {
          Text('为你推荐')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#0f88eb');

          Column({ space: 8 }) {
            Text('· 热榜：实时热门问答，快速了解大家在讨论什么。')
              .fontSize(14)
              .fontColor('#333333');
            Text('· 发现：多领域精选，帮你拓展视野。')
              .fontSize(14)
              .fontColor('#333333');
            Text('· 我的：登录后可收藏、查看历史，便捷回访。')
              .fontSize(14)
              .fontColor('#333333');
          }
          .padding(12)
          .backgroundColor('#ffffff')
          .borderRadius(12)
          .shadow({ radius: 10, color: '#e5ebf5', offsetX: 0, offsetY: 4 })
        }
        .padding({ left: 16, right: 16 })

        // 快捷入口卡片
        Column({ space: 12 }) {
          Text('快速开始')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#0f88eb');

          Row({ space: 12 }) {
            Column({ space: 6 }) {
              Text('热榜')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#0f88eb');
              Text('当前热门问题，随时浏览')
                .fontSize(13)
                .fontColor('#555555');
              Button('去看看')
                .width(120)
                .height(36)
                .backgroundColor('#eef5ff')
                .fontColor('#0f88eb')
                .borderRadius(10)
                .onClick(() => {
                  safeNav('pages/MainPages/ZhiHuHuHomePage');
                });
            }
            .padding(12)
            .backgroundColor('#ffffff')
            .borderRadius(12)
            .shadow({ radius: 10, color: '#e5ebf5', offsetX: 0, offsetY: 4 })

            Column({ space: 6 }) {
              Text('我的')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#0f88eb');
              Text('登录后查看收藏与历史')
                .fontSize(13)
                .fontColor('#555555');
              Button('去登录')
                .width(120)
                .height(36)
                .backgroundColor('#0f88eb')
                .fontColor('#ffffff')
                .borderRadius(10)
                .onClick(() => {
                  safeNav('pages/MainPages/ZhiHuHuLoginPage');
                });
            }
            .padding(12)
            .backgroundColor('#ffffff')
            .borderRadius(12)
            .shadow({ radius: 10, color: '#e5ebf5', offsetX: 0, offsetY: 4 })
          }
          .alignItems(VerticalAlign.Center)
        }
        .padding({ left: 16, right: 16, bottom: 24 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f2f6fb');
  }
}