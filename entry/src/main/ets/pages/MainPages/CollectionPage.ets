import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface CollectionItem {
  id: string;
  title: string;
  author: string;
  summary: string;
  image: ResourceStr;
  collectTime: string;
  topic: string;
}

@Entry
@Component
struct CollectionPage {
  @State collections: CollectionItem[] = [
    {
      id: '1',
      title: '大模型会让哪些行业率先受益？',
      author: '答主 · 李然',
      summary: '效率、创造力、工具链改造三个角度的行业观察',
      image: $r('app.media.thumb_701'),
      collectTime: '2024-12-18',
      topic: '科技'
    },
    {
      id: '2',
      title: '如何快速掌握一门新的编程语言？',
      author: '答主 · 张伟',
      summary: '从语法基础到项目实战，分享高效学习路径和实践经验',
      image: $r('app.media.thumb_702'),
      collectTime: '2024-12-17',
      topic: '编程'
    },
    {
      id: '3',
      title: '深度学习在医疗诊断中的应用前景如何？',
      author: '答主 · 刘敏',
      summary: 'AI辅助诊断、影像识别、药物研发等领域的突破与挑战',
      image: $r('app.media.thumb_703'),
      collectTime: '2024-12-15',
      topic: '医疗'
    },
    {
      id: '4',
      title: '个人如何做好数字安全防护？',
      author: '答主 · 王璐',
      summary: '口令管理、双因子、设备加密与社工防御清单',
      image: $r('app.media.thumb_704'),
      collectTime: '2024-12-10',
      topic: '安全'
    }
  ];

  private removeCollection(id: string) {
    this.collections = this.collections.filter((item: CollectionItem) => item.id !== id);
    prompt.showToast({ message: '已取消收藏' });
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

        Text('我的收藏')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1);

        Text('编辑')
          .fontSize(14)
          .fontColor('#0f88eb')
          .padding({ right: 16 })
          .onClick(() => prompt.showToast({ message: '编辑模式' }));
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      // 收藏统计
      Row({ space: 8 }) {
        Text(`共 ${this.collections.length} 个收藏`)
          .fontSize(14)
          .fontColor('#666666');
        Blank();
        Text('按时间排序')
          .fontSize(13)
          .fontColor('#0f88eb')
          .onClick(() => prompt.showToast({ message: '排序方式切换' }));
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#f9f9f9');

      // 收藏列表
      if (this.collections.length === 0) {
        Column({ space: 16 }) {
          Text('📚')
            .fontSize(60);
          Text('暂无收藏')
            .fontSize(16)
            .fontColor('#999999');
          Text('浏览内容时点击收藏，这里会显示你的收藏')
            .fontSize(13)
            .fontColor('#bbbbbb');
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center);
      } else {
        List({ space: 12 }) {
          ForEach(this.collections, (item: CollectionItem) => {
            ListItem() {
              Row({ space: 12 }) {
                Image(item.image)
                  .width(100)
                  .height(70)
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover);

                Column({ space: 6 }) {
                  Text(item.title)
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis });

                  Text(item.author)
                    .fontSize(12)
                    .fontColor('#666666');

                  Row({ space: 8 }) {
                    Text(item.topic)
                      .fontSize(11)
                      .fontColor('#0f88eb')
                      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                      .backgroundColor('#eef5ff')
                      .borderRadius(4);
                    Text(item.collectTime)
                      .fontSize(11)
                      .fontColor('#999999');
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start);

                Text('×')
                  .fontSize(20)
                  .fontColor('#cccccc')
                  .onClick(() => this.removeCollection(item.id));
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#ffffff')
              .borderRadius(12)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/MainPages/DetailPage',
                  params: {
                    title: item.title,
                    author: item.author,
                    topic: item.topic,
                    summary: item.summary
                  }
                });
              });
            };
          });
        }
        .padding({ left: 16, right: 16, top: 12 })
        .layoutWeight(1);
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }
}

