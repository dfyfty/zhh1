import router from '@ohos.router';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct PublishPage {
  @State questionTitle: string = '';
  @State questionContent: string = '';
  @State selectedTopic: string = '';
  @State isAnonymous: boolean = false;

  private topics: string[] = ['科技', '生活', '情感', '编程', '医疗', '金融', '教育', '游戏', '影视', '其他'];

  private publishQuestion() {
    if (this.questionTitle.trim().length === 0) {
      prompt.showToast({ message: '请输入问题标题' });
      return;
    }
    if (this.questionTitle.trim().length < 5) {
      prompt.showToast({ message: '标题至少5个字' });
      return;
    }

    prompt.showToast({ message: '发布成功！' });
    router.back();
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('取消')
          .fontSize(16)
          .fontColor('#666666')
          .padding({ left: 16, right: 16 })
          .onClick(() => router.back());

        Blank();

        Text('发布问题')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333');

        Blank();

        Button('发布')
          .height(36)
          .backgroundColor('#0f88eb')
          .fontColor('#ffffff')
          .fontSize(14)
          .borderRadius(18)
          .padding({ left: 16, right: 16 })
          .margin({ right: 16 })
          .onClick(() => this.publishQuestion());
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      Scroll() {
        Column({ space: 20 }) {
          // 问题标题
          Column({ space: 8 }) {
            Text('问题标题')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333');

            TextInput({ placeholder: '写下你的问题（5-50字）', text: this.questionTitle })
              .width('100%')
              .height(50)
              .backgroundColor('#f9f9f9')
              .border({ width: 1, color: '#e8e8e8' })
              .borderRadius(8)
              .padding({ left: 12, right: 12 })
              .maxLength(50)
              .onChange((value: string) => {
                this.questionTitle = value;
              });

            Text(`${this.questionTitle.length}/50`)
              .fontSize(12)
              .fontColor('#999999')
              .alignSelf(ItemAlign.End);
          }
          .width('100%')
          .padding({ left: 16, right: 16 });

          // 问题描述
          Column({ space: 8 }) {
            Text('问题描述（选填）')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333');

            TextArea({ placeholder: '补充问题的背景和细节，有助于获得更好的回答...', text: this.questionContent })
              .width('100%')
              .height(150)
              .backgroundColor('#f9f9f9')
              .border({ width: 1, color: '#e8e8e8' })
              .borderRadius(8)
              .padding(12)
              .maxLength(500)
              .onChange((value: string) => {
                this.questionContent = value;
              });

            Text(`${this.questionContent.length}/500`)
              .fontSize(12)
              .fontColor('#999999')
              .alignSelf(ItemAlign.End);
          }
          .width('100%')
          .padding({ left: 16, right: 16 });

          // 选择话题
          Column({ space: 12 }) {
            Text('选择话题')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333');

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.topics, (topic: string) => {
                Button(topic)
                  .type(ButtonType.Normal)
                  .height(36)
                  .backgroundColor(this.selectedTopic === topic ? '#0f88eb' : '#f5f5f5')
                  .fontColor(this.selectedTopic === topic ? '#ffffff' : '#666666')
                  .fontSize(14)
                  .borderRadius(18)
                  .margin({ right: 10, bottom: 10 })
                  .onClick(() => {
                    this.selectedTopic = topic;
                  });
              });
            }
            .width('100%');
          }
          .width('100%')
          .padding({ left: 16, right: 16 });

          // 匿名选项
          Row() {
            Text('匿名提问')
              .fontSize(15)
              .fontColor('#333333');

            Blank();

            Toggle({ type: ToggleType.Switch, isOn: this.isAnonymous })
              .selectedColor('#0f88eb')
              .onChange((isOn: boolean) => {
                this.isAnonymous = isOn;
                prompt.showToast({ message: isOn ? '已开启匿名' : '已关闭匿名' });
              });
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .backgroundColor('#ffffff')
          .borderRadius(12)
          .margin({ left: 16, right: 16 });

          // 提示信息
          Column({ space: 8 }) {
            Text('发布须知')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333');

            Text('1. 请确保问题表述清晰、具体')
              .fontSize(13)
              .fontColor('#666666');

            Text('2. 避免发布敏感、违规内容')
              .fontSize(13)
              .fontColor('#666666');

            Text('3. 选择合适的话题有助于获得更多曝光')
              .fontSize(13)
              .fontColor('#666666');
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#f9f9f9')
          .borderRadius(12)
          .margin({ left: 16, right: 16, top: 8 })
          .alignItems(HorizontalAlign.Start);

          // 添加图片（可选）
          Column({ space: 12 }) {
            Text('添加图片（选填）')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333');

            Row({ space: 12 }) {
              Column() {
                Text('+')
                  .fontSize(32)
                  .fontColor('#cccccc');
                Text('添加图片')
                  .fontSize(12)
                  .fontColor('#999999');
              }
              .width(80)
              .height(80)
              .backgroundColor('#f9f9f9')
              .borderRadius(8)
              .border({ width: 1, color: '#e0e0e0', style: BorderStyle.Dashed })
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                prompt.showToast({ message: '图片选择功能' });
              });
            }
            .width('100%');
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 40 });
        }
        .width('100%')
        .padding({ top: 20 });
      }
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff');
  }
}

