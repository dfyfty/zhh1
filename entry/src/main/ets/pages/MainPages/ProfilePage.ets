import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface ProfileParams {
  userId?: string;
  userName?: string;
}

interface AnswerItem {
  id: string;
  title: string;
  content: string;
  likes: number;
  comments: number;
  time: string;
}

interface UserInfo {
  avatar: ResourceStr;
  name: string;
  bio: string;
  location: string;
  profession: string;
  followingCount: number;
  followersCount: number;
  likesCount: number;
  answersCount: number;
  articlesCount: number;
  ideasCount: number;
}

@Entry
@Component
struct ProfilePage {
  @State params: ProfileParams = {};
  @State isFollowing: boolean = false;
  @State currentTab: number = 0; // 0=回答 1=文章 2=想法

  @State userInfo: UserInfo = {
    avatar: $r('app.media.avatar_1001'),
    name: '用户',
    bio: '这个人很懒，什么都没写',
    location: '北京',
    profession: '互联网从业者',
    followingCount: 128,
    followersCount: 3560,
    likesCount: 12800,
    answersCount: 56,
    articlesCount: 12,
    ideasCount: 89
  };

  private answers: AnswerItem[] = [
    {
      id: '1',
      title: '如何看待2024年的科技发展趋势？',
      content: '从AI大模型到量子计算，2024年将是科技爆发的一年...',
      likes: 1280,
      comments: 89,
      time: '3天前'
    },
    {
      id: '2',
      title: '程序员如何保持学习的热情？',
      content: '持续学习是每个程序员的必修课，我的方法是...',
      likes: 860,
      comments: 56,
      time: '1周前'
    },
    {
      id: '3',
      title: '远程办公的利与弊有哪些？',
      content: '经过几年的远程办公实践，我总结了以下几点...',
      likes: 520,
      comments: 34,
      time: '2周前'
    }
  ];

  aboutToAppear() {
    const p = router.getParams() as ProfileParams;
    if (p) {
      this.params = p;
      if (p.userName) {
        this.userInfo.name = p.userName;
      }
    }
  }

  private toggleFollow() {
    this.isFollowing = !this.isFollowing;
    if (this.isFollowing) {
      this.userInfo.followersCount += 1;
    } else {
      this.userInfo.followersCount -= 1;
    }
    prompt.showToast({ message: this.isFollowing ? '已关注' : '已取消关注' });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor('#333333')
          .padding({ left: 16, right: 16 })
          .onClick(() => router.back());

        Text('个人主页')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1);

        Text('⋮')
          .fontSize(24)
          .fontColor('#333333')
          .padding({ left: 16, right: 16 })
          .onClick(() => prompt.showToast({ message: '更多选项' }));
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      Scroll() {
        Column({ space: 16 }) {
          // 用户信息卡片
          Column({ space: 16 }) {
            Row({ space: 16 }) {
              Image(this.userInfo.avatar)
                .width(70)
                .height(70)
                .borderRadius(35)
                .objectFit(ImageFit.Cover);

              Column({ space: 6 }) {
                Text(this.userInfo.name)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333');
                Text(this.userInfo.bio)
                  .fontSize(13)
                  .fontColor('#666666')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis });
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start);

              Button(this.isFollowing ? '已关注' : '+ 关注')
                .height(36)
                .backgroundColor(this.isFollowing ? '#f5f5f5' : '#0f88eb')
                .fontColor(this.isFollowing ? '#666666' : '#ffffff')
                .fontSize(14)
                .borderRadius(18)
                .onClick(() => this.toggleFollow());
            }
            .width('100%');

            // 位置和职业
            Row({ space: 16 }) {
              Row({ space: 4 }) {
                Text('📍')
                  .fontSize(14);
                Text(this.userInfo.location)
                  .fontSize(13)
                  .fontColor('#666666');
              }
              Row({ space: 4 }) {
                Text('💼')
                  .fontSize(14);
                Text(this.userInfo.profession)
                  .fontSize(13)
                  .fontColor('#666666');
              }
            }
            .width('100%');

            // 统计数据
            Row() {
              Column() {
                Text(`${this.userInfo.followingCount}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
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
                Text(`${this.userInfo.followersCount}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333');
                Text('粉丝')
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
                Text(`${this.userInfo.likesCount}`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333');
                Text('获赞')
                  .fontSize(12)
                  .fontColor('#999999');
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center);
            }
            .width('100%')
            .padding({ top: 12 });
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#ffffff');

          // Tab切换
          Row() {
            Column() {
              Text(`回答 ${this.userInfo.answersCount}`)
                .fontSize(15)
                .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.currentTab === 0 ? '#0f88eb' : '#666666');
              if (this.currentTab === 0) {
                Divider()
                  .color('#0f88eb')
                  .strokeWidth(2)
                  .width(50)
                  .margin({ top: 8 });
              }
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              this.currentTab = 0;
            });

            Column() {
              Text(`文章 ${this.userInfo.articlesCount}`)
                .fontSize(15)
                .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.currentTab === 1 ? '#0f88eb' : '#666666');
              if (this.currentTab === 1) {
                Divider()
                  .color('#0f88eb')
                  .strokeWidth(2)
                  .width(50)
                  .margin({ top: 8 });
              }
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              this.currentTab = 1;
            });

            Column() {
              Text(`想法 ${this.userInfo.ideasCount}`)
                .fontSize(15)
                .fontWeight(this.currentTab === 2 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.currentTab === 2 ? '#0f88eb' : '#666666');
              if (this.currentTab === 2) {
                Divider()
                  .color('#0f88eb')
                  .strokeWidth(2)
                  .width(50)
                  .margin({ top: 8 });
              }
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
            .padding({ top: 12, bottom: 12 })
            .onClick(() => {
              this.currentTab = 2;
            });
          }
          .width('100%')
          .backgroundColor('#ffffff');

          // 内容列表
          if (this.currentTab === 0) {
            Column({ space: 12 }) {
              ForEach(this.answers, (answer: AnswerItem) => {
                Column({ space: 8 }) {
                  Text(answer.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .width('100%');

                  Text(answer.content)
                    .fontSize(14)
                    .fontColor('#666666')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .width('100%');

                  Row({ space: 16 }) {
                    Row({ space: 4 }) {
                      Text('👍')
                        .fontSize(14);
                      Text(`${answer.likes}`)
                        .fontSize(13)
                        .fontColor('#999999');
                    }
                    Row({ space: 4 }) {
                      Text('💬')
                        .fontSize(14);
                      Text(`${answer.comments}`)
                        .fontSize(13)
                        .fontColor('#999999');
                    }
                    Blank();
                    Text(answer.time)
                      .fontSize(12)
                      .fontColor('#999999');
                  }
                  .width('100%');
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#ffffff')
                .borderRadius(12)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/MainPages/DetailPage',
                    params: {
                      title: answer.title,
                      author: this.userInfo.name,
                      summary: answer.content
                    }
                  });
                });
              });
            }
            .padding({ left: 16, right: 16, bottom: 20 });
          } else if (this.currentTab === 1) {
            Column({ space: 16 }) {
              Text('📝')
                .fontSize(50);
              Text('暂无文章')
                .fontSize(15)
                .fontColor('#999999');
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center);
          } else {
            Column({ space: 16 }) {
              Text('💡')
                .fontSize(50);
              Text('暂无想法')
                .fontSize(15)
                .fontColor('#999999');
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center);
          }
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

