import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface FollowParams {
  type?: string; // 'following' 或 'followers'
}

interface UserItem {
  id: string;
  name: string;
  avatar: ResourceStr;
  bio: string;
  isFollowing: boolean;
  followersCount: number;
  answersCount: number;
}

@Entry
@Component
struct FollowPage {
  @State type: string = 'following';
  @State followingList: UserItem[] = [
    {
      id: '1',
      name: '李然',
      avatar: $r('app.media.avatar_901'),
      bio: '科技领域创作者，关注AI与产业融合',
      isFollowing: true,
      followersCount: 12580,
      answersCount: 156
    },
    {
      id: '2',
      name: '张伟',
      avatar: $r('app.media.avatar_902'),
      bio: '全栈工程师，乐于分享编程经验',
      isFollowing: true,
      followersCount: 8920,
      answersCount: 89
    }
  ];
  @State followersList: UserItem[] = [
    {
      id: '3',
      name: '王小明',
      avatar: $r('app.media.avatar_903'),
      bio: '学生党，喜欢学习新技术',
      isFollowing: false,
      followersCount: 120,
      answersCount: 5
    },
    {
      id: '4',
      name: '刘芳',
      avatar: $r('app.media.avatar_904'),
      bio: '产品经理，关注用户体验',
      isFollowing: true,
      followersCount: 560,
      answersCount: 23
    }
  ];

  aboutToAppear() {
    const params = router.getParams() as FollowParams;
    if (params && params.type) {
      this.type = params.type;
    }
  }

  private toggleFollow(list: UserItem[], index: number) {
    list[index].isFollowing = !list[index].isFollowing;
    const status = list[index].isFollowing ? '已关注' : '已取消关注';
    prompt.showToast({ message: status });
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

        Text(this.type === 'following' ? '我的关注' : '我的粉丝')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1);
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      // Tab切换
      Row() {
        Column() {
          Text('关注')
            .fontSize(16)
            .fontWeight(this.type === 'following' ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.type === 'following' ? '#0f88eb' : '#666666');
          if (this.type === 'following') {
            Divider()
              .color('#0f88eb')
              .strokeWidth(2)
              .width(40)
              .margin({ top: 8 });
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 12, bottom: 12 })
        .onClick(() => {
          this.type = 'following';
        });

        Column() {
          Text('粉丝')
            .fontSize(16)
            .fontWeight(this.type === 'followers' ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.type === 'followers' ? '#0f88eb' : '#666666');
          if (this.type === 'followers') {
            Divider()
              .color('#0f88eb')
              .strokeWidth(2)
              .width(40)
              .margin({ top: 8 });
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 12, bottom: 12 })
        .onClick(() => {
          this.type = 'followers';
        });
      }
      .width('100%')
      .backgroundColor('#ffffff')
      .border({ width: { bottom: 0.5 }, color: '#e8e8e8' });

      // 用户列表
      if (this.type === 'following') {
        if (this.followingList.length === 0) {
          Column({ space: 16 }) {
            Text('👥')
              .fontSize(60);
            Text('暂无关注')
              .fontSize(16)
              .fontColor('#999999');
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center);
        } else {
          List({ space: 12 }) {
            ForEach(this.followingList, (user: UserItem, index: number) => {
              ListItem() {
                Row({ space: 12 }) {
                  Image(user.avatar)
                    .width(50)
                    .height(50)
                    .borderRadius(25)
                    .objectFit(ImageFit.Cover);

                  Column({ space: 4 }) {
                    Text(user.name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#333333');
                    Text(user.bio)
                      .fontSize(13)
                      .fontColor('#666666')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis });
                    Row({ space: 12 }) {
                      Text(`${user.followersCount} 粉丝`)
                        .fontSize(12)
                        .fontColor('#999999');
                      Text(`${user.answersCount} 回答`)
                        .fontSize(12)
                        .fontColor('#999999');
                    }
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start);

                  Button(user.isFollowing ? '已关注' : '+ 关注')
                    .height(32)
                    .backgroundColor(user.isFollowing ? '#f5f5f5' : '#0f88eb')
                    .fontColor(user.isFollowing ? '#666666' : '#ffffff')
                    .fontSize(13)
                    .borderRadius(16)
                    .onClick(() => this.toggleFollow(this.followingList, index));
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#ffffff')
                .borderRadius(12)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/MainPages/ProfilePage',
                    params: { userId: user.id, userName: user.name }
                  });
                });
              };
            });
          }
          .padding({ left: 16, right: 16, top: 12 })
          .layoutWeight(1);
        }
      } else {
        if (this.followersList.length === 0) {
          Column({ space: 16 }) {
            Text('👥')
              .fontSize(60);
            Text('暂无粉丝')
              .fontSize(16)
              .fontColor('#999999');
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center);
        } else {
          List({ space: 12 }) {
            ForEach(this.followersList, (user: UserItem, index: number) => {
              ListItem() {
                Row({ space: 12 }) {
                  Image(user.avatar)
                    .width(50)
                    .height(50)
                    .borderRadius(25)
                    .objectFit(ImageFit.Cover);

                  Column({ space: 4 }) {
                    Text(user.name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#333333');
                    Text(user.bio)
                      .fontSize(13)
                      .fontColor('#666666')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis });
                    Row({ space: 12 }) {
                      Text(`${user.followersCount} 粉丝`)
                        .fontSize(12)
                        .fontColor('#999999');
                      Text(`${user.answersCount} 回答`)
                        .fontSize(12)
                        .fontColor('#999999');
                    }
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start);

                  Button(user.isFollowing ? '已关注' : '+ 关注')
                    .height(32)
                    .backgroundColor(user.isFollowing ? '#f5f5f5' : '#0f88eb')
                    .fontColor(user.isFollowing ? '#666666' : '#ffffff')
                    .fontSize(13)
                    .borderRadius(16)
                    .onClick(() => this.toggleFollow(this.followersList, index));
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#ffffff')
                .borderRadius(12)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/MainPages/ProfilePage',
                    params: { userId: user.id, userName: user.name }
                  });
                });
              };
            });
          }
          .padding({ left: 16, right: 16, top: 12 })
          .layoutWeight(1);
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }
}

