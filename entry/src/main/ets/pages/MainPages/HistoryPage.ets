import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface HistoryItem {
  id: string;
  title: string;
  author: string;
  summary: string;
  image: ResourceStr;
  viewTime: string;
  topic: string;
}

@Entry
@Component
struct HistoryPage {
  @State histories: HistoryItem[] = [
    {
      id: '1',
      title: '脸与身材不符是种怎样的体验？',
      author: '答主 · 不倒斗的胡八一',
      summary: '又到了这只兔兔出现的时候...',
      image: $r('app.media.thumb_801'),
      viewTime: '10分钟前',
      topic: '生活'
    },
    {
      id: '2',
      title: '为什么说男人至死都是少年？',
      author: '答主 · 向前',
      summary: '丈母娘家小区暖气管爆了,一大早在修...',
      image: $r('app.media.thumb_802'),
      viewTime: '30分钟前',
      topic: '情感'
    },
    {
      id: '3',
      title: '新能源车电池未来五年的突破点是什么？',
      author: '答主 · 陈曦',
      summary: '固态电池、快充安全、回收与梯次利用',
      image: $r('app.media.thumb_803'),
      viewTime: '2小时前',
      topic: '能源'
    },
    {
      id: '4',
      title: '量子计算距离商业化还有多远？',
      author: '答主 · 郑华',
      summary: '技术突破、应用场景、投资前景的全面分析',
      image: $r('app.media.thumb_804'),
      viewTime: '昨天',
      topic: '量子'
    },
    {
      id: '5',
      title: '自动驾驶技术的安全性与可靠性探讨',
      author: '答主 · 马超',
      summary: '传感器融合、决策算法、事故责任等关键问题的深度解析',
      image: $r('app.media.thumb_805'),
      viewTime: '昨天',
      topic: '汽车'
    }
  ];

  private clearHistory() {
    this.histories = [];
    prompt.showToast({ message: '已清空浏览历史' });
  }

  private removeItem(id: string) {
    this.histories = this.histories.filter((item: HistoryItem) => item.id !== id);
    prompt.showToast({ message: '已删除' });
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

        Text('浏览历史')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1);

        Text('清空')
          .fontSize(14)
          .fontColor('#ff4d4f')
          .padding({ right: 16 })
          .onClick(() => this.clearHistory());
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      // 历史记录列表
      if (this.histories.length === 0) {
        Column({ space: 16 }) {
          Text('📖')
            .fontSize(60);
          Text('暂无浏览记录')
            .fontSize(16)
            .fontColor('#999999');
          Text('你浏览过的内容会显示在这里')
            .fontSize(13)
            .fontColor('#bbbbbb');
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center);
      } else {
        List({ space: 12 }) {
          ForEach(this.histories, (item: HistoryItem) => {
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
                    Text(item.viewTime)
                      .fontSize(11)
                      .fontColor('#999999');
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start);

                Text('×')
                  .fontSize(20)
                  .fontColor('#cccccc')
                  .onClick(() => this.removeItem(item.id));
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

