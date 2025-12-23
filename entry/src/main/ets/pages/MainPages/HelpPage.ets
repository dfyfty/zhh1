import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface FAQItem {
  id: string;
  question: string;
  answer: string;
  isExpanded: boolean;
}

@Entry
@Component
struct HelpPage {
  @State faqList: FAQItem[] = [
    {
      id: '1',
      question: '如何发布问题？',
      answer: '点击首页右上角的"+"按钮，即可进入发布问题页面。填写问题标题、描述和选择话题后，点击发布即可。',
      isExpanded: false
    },
    {
      id: '2',
      question: '如何修改个人资料？',
      answer: '进入"我的"页面，点击头像区域或"编辑资料"按钮，即可修改昵称、头像、简介等个人信息。',
      isExpanded: false
    },
    {
      id: '3',
      question: '如何关注其他用户？',
      answer: '在任意用户的主页、回答下方或推荐列表中，点击"关注"按钮即可关注该用户。关注后可在首页看到其动态。',
      isExpanded: false
    },
    {
      id: '4',
      question: '如何收藏内容？',
      answer: '在任意问题或回答详情页，点击底部的收藏按钮（星星图标），即可将内容加入收藏。在"我的收藏"中可查看所有收藏内容。',
      isExpanded: false
    },
    {
      id: '5',
      question: '账号被封禁怎么办？',
      answer: '如果您的账号被封禁，请联系客服申诉。请提供您的账号信息和相关说明，我们会在3个工作日内处理。',
      isExpanded: false
    },
    {
      id: '6',
      question: '如何删除已发布的内容？',
      answer: '进入您发布的问题或回答详情页，点击右上角的"..."按钮，选择"删除"即可。注意：删除后无法恢复。',
      isExpanded: false
    },
    {
      id: '7',
      question: '如何举报违规内容？',
      answer: '在任意内容的详情页，点击右上角的"..."按钮，选择"举报"，填写举报原因后提交。我们会尽快审核处理。',
      isExpanded: false
    }
  ];

  private toggleExpand(index: number) {
    this.faqList[index].isExpanded = !this.faqList[index].isExpanded;
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

        Text('帮助与客服')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .layoutWeight(1);
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center);

      Scroll() {
        Column({ space: 16 }) {
          // 客服入口
          Column({ space: 12 }) {
            Text('联系客服')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%');

            Row({ space: 12 }) {
              Column({ space: 8 }) {
                Text('💬')
                  .fontSize(32);
                Text('在线客服')
                  .fontSize(13)
                  .fontColor('#333333');
              }
              .layoutWeight(1)
              .height(90)
              .backgroundColor('#f0f7ff')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => prompt.showToast({ message: '正在连接在线客服...' }));

              Column({ space: 8 }) {
                Text('📧')
                  .fontSize(32);
                Text('邮件反馈')
                  .fontSize(13)
                  .fontColor('#333333');
              }
              .layoutWeight(1)
              .height(90)
              .backgroundColor('#f0f7ff')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => prompt.showToast({ message: '邮箱：support@zhihuhu.com' }));

              Column({ space: 8 }) {
                Text('📞')
                  .fontSize(32);
                Text('电话客服')
                  .fontSize(13)
                  .fontColor('#333333');
              }
              .layoutWeight(1)
              .height(90)
              .backgroundColor('#f0f7ff')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => prompt.showToast({ message: '客服热线：400-123-4567' }));
            }
            .width('100%');
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#ffffff')
          .borderRadius(12);

          // 常见问题
          Column({ space: 12 }) {
            Text('常见问题')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%');

            ForEach(this.faqList, (faq: FAQItem, index: number) => {
              Column({ space: 8 }) {
                Row() {
                  Text(faq.question)
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .layoutWeight(1);

                  Text(faq.isExpanded ? '∧' : '∨')
                    .fontSize(16)
                    .fontColor('#999999');
                }
                .width('100%')
                .onClick(() => this.toggleExpand(index));

                if (faq.isExpanded) {
                  Text(faq.answer)
                    .fontSize(14)
                    .fontColor('#666666')
                    .lineHeight(22)
                    .width('100%')
                    .padding({ top: 8 });
                }
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#f9f9f9')
              .borderRadius(8);
            });
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#ffffff')
          .borderRadius(12);

          // 问题反馈
          Column({ space: 12 }) {
            Text('问题反馈')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%');

            Text('如果您在使用过程中遇到问题，或有任何建议，欢迎向我们反馈。')
              .fontSize(14)
              .fontColor('#666666')
              .lineHeight(22)
              .width('100%');

            Button('提交反馈')
              .width('100%')
              .height(44)
              .backgroundColor('#0f88eb')
              .fontColor('#ffffff')
              .fontSize(15)
              .borderRadius(22)
              .onClick(() => prompt.showToast({ message: '反馈提交页面' }));
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#ffffff')
          .borderRadius(12);

          // 服务条款
          Column({ space: 12 }) {
            Text('相关协议')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%');

            Row() {
              Text('用户协议')
                .fontSize(15)
                .fontColor('#333333')
                .layoutWeight(1);
              Text('>')
                .fontSize(16)
                .fontColor('#cccccc');
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .onClick(() => prompt.showToast({ message: '用户协议' }));

            Divider().color('#f0f0f0').strokeWidth(1);

            Row() {
              Text('隐私政策')
                .fontSize(15)
                .fontColor('#333333')
                .layoutWeight(1);
              Text('>')
                .fontSize(16)
                .fontColor('#cccccc');
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .onClick(() => prompt.showToast({ message: '隐私政策' }));

            Divider().color('#f0f0f0').strokeWidth(1);

            Row() {
              Text('社区规范')
                .fontSize(15)
                .fontColor('#333333')
                .layoutWeight(1);
              Text('>')
                .fontSize(16)
                .fontColor('#cccccc');
            }
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .onClick(() => prompt.showToast({ message: '社区规范' }));
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#ffffff')
          .borderRadius(12);

          // 版本信息
          Column({ space: 4 }) {
            Text('知乎乎 v1.0.0')
              .fontSize(13)
              .fontColor('#999999');
            Text('© 2024 知乎乎团队')
              .fontSize(12)
              .fontColor('#bbbbbb');
          }
          .width('100%')
          .padding({ top: 20, bottom: 40 })
          .alignItems(HorizontalAlign.Center);
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16 });
      }
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }
}

