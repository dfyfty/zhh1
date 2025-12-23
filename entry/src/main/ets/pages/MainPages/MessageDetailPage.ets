import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface MessageDetailParams {
  from?: string;
  title?: string;
  time?: string;
}

interface DialogItem {
  fromSelf: boolean;
  text: string;
  time: string;
}

@Entry
@Component
struct MessageDetailPage {
  private params: MessageDetailParams = {};

  // 简单模拟一段对话内容
  private dialog: DialogItem[] = [
    { fromSelf: false, text: '欢迎加入知乎乎社区，一起发现优质问答～', time: '今天 10:00' },
    { fromSelf: true, text: '好的，了解啦～', time: '今天 10:01' },
    { fromSelf: false, text: '在首页可以浏览推荐问题，在“我的”里管理收藏与历史记录。', time: '今天 10:02' }
  ];

  aboutToAppear() {
    const p = router.getParams() as MessageDetailParams;
    if (p) {
      this.params = p;
    }
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

        Column({ space: 2 }) {
          Text(this.params.from ?? '系统通知')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333');
          Text(this.params.title ?? '')
            .fontSize(12)
            .fontColor('#999999')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      // 对话内容
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.dialog, (item: DialogItem, index: number) => {
            Column({ space: 4 }) {
              Row() {
                if (item.fromSelf) {
                  Blank();
                  Text(item.text)
                    .fontSize(14)
                    .fontColor('#ffffff')
                    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                    .backgroundColor('#0f88eb')
                    .borderRadius(18);
                } else {
                  Text(item.text)
                    .fontSize(14)
                    .fontColor('#333333')
                    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                    .backgroundColor('#f5f5f5')
                    .borderRadius(18);
                  Blank();
                }
              }
              .width('100%')
              .padding({ left: 16, right: 16 });

              Row() {
                if (item.fromSelf) {
                  Blank();
                  Text(item.time)
                    .fontSize(11)
                    .fontColor('#bbbbbb');
                } else {
                  Text(item.time)
                    .fontSize(11)
                    .fontColor('#bbbbbb');
                  Blank();
                }
              }
              .width('100%')
              .padding({ left: 24, right: 24 });
            }
            .width('100%');
          });
        }
        .width('100%')
        .padding({ top: 12, bottom: 80 });
      }
      .layoutWeight(1);

      // 底部输入栏
      Row({ space: 8 }) {
        TextInput({ placeholder: '回复对方...' })
          .layoutWeight(1)
          .height(40)
          .border({ width: 1, color: '#e0e0e0' })
          .borderRadius(20)
          .padding({ left: 12 });
        Button('发送')
          .height(40)
          .backgroundColor('#0f88eb')
          .fontColor('#ffffff')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            prompt.showToast({ message: '示例对话，暂不支持真实发送' });
          });
      }
      .width('100%')
      .padding({ left: 12, right: 12, bottom: 16 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }
}


