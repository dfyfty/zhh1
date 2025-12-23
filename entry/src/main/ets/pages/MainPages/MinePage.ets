import router from '@ohos.router';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct MinePage {
  @StorageLink('currentUser') currentUser: string = '';

  private logout() {
    AppStorage.SetOrCreate('currentUser', '');
    prompt.showToast({ message: '已退出登录' });
    router.pushUrl({ url: 'pages/MainPages/ZhiHuHuLoginPage' });
  }

  build() {
    Column() {
      // 上半部分内容可滚动
      Scroll() {
        Column({ space: 20 }) {
          // 顶部设置入口
          Row() {
            Blank();
            Text('设置')
              .fontSize(16)
              .fontColor('#333333')
              .padding({ right: 16, top: 12 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/MainPages/SettingsPage' });
              });
          }
          .width('100%');

          // 顶部个人信息卡片
          Column({ space: 16 }) {
            Row({ space: 16 }) {
              // 头像
              Image($r('app.media.avatar_501'))
                .width(60)
                .height(60)
                .borderRadius(30)
                .objectFit(ImageFit.Cover)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/MainPages/ProfilePage',
                    params: { userName: this.currentUser || '卜微' }
                  });
                });

              Column({ space: 6 }) {
                Text(this.currentUser || '卜微')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333');
                Text('点击查看个人主页')
                  .fontSize(13)
                  .fontColor('#777777')
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/MainPages/ProfilePage',
                      params: { userName: this.currentUser || '卜微' }
                    });
                  });
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start);

              Button('创作中心')
                .height(32)
                .backgroundColor('#f0f6ff')
                .fontColor('#0f88eb')
                .fontSize(13)
                .borderRadius(16)
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  router.pushUrl({ url: 'pages/MainPages/PublishPage' });
                });
            }
            .width('100%');

            // 关注/收藏等统计
            Row() {
              Column() {
                Text('2')
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333');
                Text('关注')
                  .fontSize(12)
                  .fontColor('#999999');
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/MainPages/FollowPage',
                  params: { type: 'following' }
                });
              });

              Column() {
                Text('0')
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333');
                Text('被关注')
                  .fontSize(12)
                  .fontColor('#999999');
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/MainPages/FollowPage',
                  params: { type: 'followers' }
                });
              });

              Column() {
                Text('2')
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333');
                Text('收藏')
                  .fontSize(12)
                  .fontColor('#999999');
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                router.pushUrl({ url: 'pages/MainPages/CollectionPage' });
              });

              Column() {
                Text('3')
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333');
                Text('最近浏览')
                  .fontSize(12)
                  .fontColor('#999999');
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                router.pushUrl({ url: 'pages/MainPages/HistoryPage' });
              });
            }
            .width('100%')
            .padding({ top: 4, bottom: 4 });
          }
          .padding({ top: 32, left: 20, right: 20, bottom: 20 })
          .backgroundColor('#ffffff')
          .borderRadius(20)
          .shadow({ radius: 12, color: '#e5efff', offsetX: 0, offsetY: 6 });

          // 会员卡片
          Column({ space: 12 }) {
            Text('盐选会员年卡 限时 5 折')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#a86a2a');
            Text('低至 ¥0.29 / 天，解锁更多优质内容')
              .fontSize(13)
              .fontColor('#8c6b3d');

            Row({ space: 12 }) {
              Button('盐选榜单')
                .type(ButtonType.Normal)
                .backgroundColor('#fff7ec')
                .fontColor('#a86a2a')
                .borderRadius(18)
                .padding({ left: 16, right: 16 })
                .onClick(() => prompt.showToast({ message: '盐选榜单' }));
              Button('阅读记录')
                .type(ButtonType.Normal)
                .backgroundColor('#fff7ec')
                .fontColor('#a86a2a')
                .borderRadius(18)
                .padding({ left: 16, right: 16 })
                .onClick(() => {
                  router.pushUrl({ url: 'pages/MainPages/HistoryPage' });
                });
              Button('会员中心')
                .type(ButtonType.Normal)
                .backgroundColor('#fff7ec')
                .fontColor('#a86a2a')
                .borderRadius(18)
                .padding({ left: 16, right: 16 })
                .onClick(() => prompt.showToast({ message: '会员中心' }));
            }
            .width('100%');
          }
          .padding(16)
          .backgroundColor('#ffe6bf')
          .borderRadius(18)
          .margin({ left: 16, right: 16 });

          // 功能入口九宫格
          Column({ space: 20 }) {
            Row({ space: 24 }) {
              Column({ space: 6 }) {
                Image($r('app.media.icon_601'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('书架')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({ url: 'pages/MainPages/CollectionPage' });
              });

              Column({ space: 6 }) {
                Image($r('app.media.icon_602'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('我的课程')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '我的课程' }));

              Column({ space: 6 }) {
                Image($r('app.media.icon_603'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('钱包')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '钱包功能' }));

              Column({ space: 6 }) {
                Image($r('app.media.icon_604'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('付费咨询')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '付费咨询' }));

              Column({ space: 6 }) {
                Image($r('app.media.icon_605'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('福利社')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '福利社' }));
            }
            .padding({ left: 20, right: 20 });

            Row({ space: 24 }) {
              Column({ space: 6 }) {
                Image($r('app.media.icon_606'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('已购')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '已购内容' }));

              Column({ space: 6 }) {
                Image($r('app.media.icon_607'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('帮助与客服')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => {
                router.pushUrl({ url: 'pages/MainPages/HelpPage' });
              });

              Column({ space: 6 }) {
                Image($r('app.media.icon_608'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('AI 实验室')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: 'AI 实验室' }));

              Column({ space: 6 }) {
                Image($r('app.media.icon_609'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('圈子')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '圈子功能' }));

              Column({ space: 6 }) {
                Image($r('app.media.icon_610'))
                  .width(40)
                  .height(40)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover);
                Text('打卡挑战')
                  .fontSize(12)
                  .fontColor('#444444');
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .onClick(() => prompt.showToast({ message: '打卡挑战' }));
            }
            .padding({ left: 20, right: 20, bottom: 4 });
          }
          .backgroundColor('#ffffff')
          .borderRadius(20)
          .margin({ left: 12, right: 12 });

          // 推荐问题区域
          Column({ space: 12 }) {
            Row() {
              Text('推荐问题')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333');
              Blank();
              Text('更多问题 >')
                .fontSize(13)
                .fontColor('#0f88eb')
                .onClick(() => {
                  router.replaceUrl({ url: 'pages/MainPages/CNKIPage' });
                });
            }
            .width('100%');

            Column({ space: 10 }) {
              Text('43 公斤，166cm 算瘦还是微胖？')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333');
              Text('2486 回答 · 2492 关注')
                .fontSize(12)
                .fontColor('#999999');
            }
            .padding(12)
            .backgroundColor('#ffffff')
            .borderRadius(12)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/MainPages/DetailPage',
                params: {
                  title: '43 公斤，166cm 算瘦还是微胖？',
                  author: '热门问题',
                  topic: '生活',
                  summary: '这是一个关于身材标准的讨论...'
                }
              });
            });
          }
          .padding({ left: 16, right: 16, bottom: 16 });

          // 登录/退出与返回首页
          Column({ space: 12 }) {
            if (this.currentUser) {
              Button('退出登录')
                .width('100%')
                .height(48)
                .backgroundColor('#0f88eb')
                .fontColor('#ffffff')
                .borderRadius(24)
                .onClick(() => {
                  this.logout();
                });
            } else {
              Button('去登录')
                .width('100%')
                .height(48)
                .backgroundColor('#0f88eb')
                .fontColor('#ffffff')
                .borderRadius(24)
                .onClick(() => {
                  router.pushUrl({ url: 'pages/MainPages/ZhiHuHuLoginPage' });
                });
            }

            Button('返回首页')
              .width('100%')
              .height(44)
              .backgroundColor('#f0f6ff')
              .fontColor('#0f88eb')
              .borderRadius(22)
              .onClick(() => {
                router.replaceUrl({ url: 'pages/MainPages/CNKIPage' });
              });
          }
          .padding({ left: 16, right: 16, bottom: 16 });
        }
        .width('100%');
      }
      .layoutWeight(1);

      // 底部导航栏：与首页风格保持一致
      Row() {
        Column() {
          Text('首页')
            .fontSize(14)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          router.replaceUrl({ url: 'pages/MainPages/CNKIPage' });
        });

        Column() {
          Text('发现')
            .fontSize(14)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          router.replaceUrl({ url: 'pages/MainPages/CNKIPage' });
        });

        // 中间发布按钮
        Column() {
          Text('+')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ffffff');
        }
        .width(50)
        .height(50)
        .borderRadius(25)
        .backgroundColor('#0f88eb')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          router.pushUrl({ url: 'pages/MainPages/PublishPage' });
        });

        Column() {
          Text('私信')
            .fontSize(14)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          router.replaceUrl({ url: 'pages/MainPages/CNKIPage' });
        });

        Column() {
          Text('我的')
            .fontSize(14)
            .fontColor('#0f88eb');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1);
      }
      .height(60)
      .backgroundColor('#ffffff')
      .border({ width: 0.5, color: '#eeeeee', radius: 0 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f9f9f9');
  }
}
