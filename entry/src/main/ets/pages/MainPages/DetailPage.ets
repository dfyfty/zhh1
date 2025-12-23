import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface DetailParams {
  title?: string;
  author?: string;
  topic?: string;
  time?: string;
  summary?: string;
  images?: ResourceStr[];
  authorAvatar?: ResourceStr;
}

interface CommentItem {
  id: string;
  user: string;
  avatar: ResourceStr;
  content: string;
  time: string;
  likes: number;
  isLiked: boolean;
}

@Entry
@Component
struct DetailPage {
  private params: DetailParams = {};
  @State isLiked: boolean = false;
  @State likeCount: number = 128;
  @State isCollected: boolean = false;
  @State collectCount: number = 56;
  @State commentCount: number = 32;
  @State showCommentInput: boolean = false;
  @State commentText: string = '';
  @State comments: CommentItem[] = [
    {
      id: '1',
      user: '热心网友',
      avatar: $r('app.media.avatar_301'),
      content: '这个回答太棒了，学到了很多！',
      time: '2小时前',
      likes: 42,
      isLiked: false
    },
    {
      id: '2',
      user: '知乎乎用户',
      avatar: $r('app.media.avatar_302'),
      content: '说得非常有道理，赞同！',
      time: '5小时前',
      likes: 18,
      isLiked: false
    },
    {
      id: '3',
      user: '匿名用户',
      avatar: $r('app.media.avatar_303'),
      content: '请问还有更多相关内容推荐吗？',
      time: '1天前',
      likes: 7,
      isLiked: false
    }
  ];

  aboutToAppear() {
    const p = router.getParams() as DetailParams;
    if (p) {
      this.params = p;
    }
  }

  private toggleLike() {
    this.isLiked = !this.isLiked;
    this.likeCount += this.isLiked ? 1 : -1;
    prompt.showToast({ message: this.isLiked ? '已点赞' : '取消点赞' });
  }

  private toggleCollect() {
    this.isCollected = !this.isCollected;
    this.collectCount += this.isCollected ? 1 : -1;
    prompt.showToast({ message: this.isCollected ? '已收藏' : '取消收藏' });
  }

  private shareContent() {
    prompt.showToast({ message: '分享功能：复制链接成功' });
  }

  private submitComment() {
    if (this.commentText.trim().length === 0) {
      prompt.showToast({ message: '评论内容不能为空' });
      return;
    }
    const newComment: CommentItem = {
      id: `${Date.now()}`,
      user: '我',
      avatar: $r('app.media.avatar_999'),
      content: this.commentText,
      time: '刚刚',
      likes: 0,
      isLiked: false
    };
    this.comments = [newComment, ...this.comments];
    this.commentCount += 1;
    this.commentText = '';
    this.showCommentInput = false;
    prompt.showToast({ message: '评论成功' });
  }

  private toggleCommentLike(index: number) {
    const comment = this.comments[index];
    comment.isLiked = !comment.isLiked;
    comment.likes += comment.isLiked ? 1 : -1;
    this.comments[index] = comment;
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

        Text('详情')
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

      // 内容区可滚动
      Scroll() {
        Column({ space: 16 }) {
          // 标题
          Text(this.params.title ?? '详情')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .width('100%')
            .textAlign(TextAlign.Start);

          // 作者信息行
          Row({ space: 10 }) {
            if (this.params.authorAvatar) {
              Image(this.params.authorAvatar)
                .width(44)
                .height(44)
                .borderRadius(22)
                .objectFit(ImageFit.Cover);
            }
            Column({ space: 4 }) {
              Text(this.params.author ?? '')
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333');
              Text(`${this.params.topic ?? ''} · ${this.params.time ?? ''}`)
                .fontSize(12)
                .fontColor('#999999');
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start);

            Button('+ 关注')
              .height(32)
              .backgroundColor('#0f88eb')
              .fontColor('#ffffff')
              .fontSize(13)
              .borderRadius(16)
              .padding({ left: 12, right: 12 })
              .onClick(() => prompt.showToast({ message: '已关注' }));
          }
          .width('100%');

          Divider().color('#e8e8e8').strokeWidth(1);

          // 正文摘要
          if (this.params.summary) {
            Text(this.params.summary as string)
              .fontSize(16)
              .fontColor('#555555')
              .lineHeight(26)
              .width('100%')
              .textAlign(TextAlign.Start);
          }

          // 详细内容
          Column({ space: 12 }) {
            Text('详细回答：')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%');

            Text('这是一个非常有趣的问题。让我来详细解答一下。在当今社会，这个话题越来越受到大家的关注。')
              .fontSize(15)
              .fontColor('#666666')
              .lineHeight(26)
              .width('100%');

            Text('首先，我们需要理解这个问题的本质。从历史发展的角度来看，这个现象并不是近年才出现的，而是有着深厚的社会背景和文化根源。')
              .fontSize(15)
              .fontColor('#666666')
              .lineHeight(26)
              .width('100%');

            Text('从多个角度来看，这个问题涉及到心理学、社会学等多个领域。每个人的理解和感受都可能不同，这也是这个话题能够引起广泛讨论的原因之一。')
              .fontSize(15)
              .fontColor('#666666')
              .lineHeight(26)
              .width('100%');

            Text('最后，我想说的是，对于这类问题，我们应该保持开放的心态，尊重不同的观点，理性地进行讨论和交流。')
              .fontSize(15)
              .fontColor('#666666')
              .lineHeight(26)
              .width('100%');
          }
          .width('100%');

          // 图片展示区域
          if (this.params.images && this.params.images.length > 0) {
            Column({ space: 12 }) {
              Text('相关图片：')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .width('100%');

              if (this.params.images.length === 1) {
                Image(this.params.images[0])
                  .width('100%')
                  .height(280)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(12);
              } else if (this.params.images.length === 2) {
                Row({ space: 10 }) {
                        ForEach(this.params.images, (img: ResourceStr) => {
                    Image(img)
                      .width('48%')
                      .aspectRatio(1)
                      .objectFit(ImageFit.Cover)
                      .borderRadius(12);
                  });
                }
                .width('100%');
              } else {
                if (this.params.images) {
                  Column({ space: 10 }) {
                    Row({ space: 10 }) {
                      ForEach(this.params.images.slice(0, 2), (img: ResourceStr) => {
                        Image(img)
                          .width('48%')
                          .aspectRatio(1)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(12);
                      });
                    }
                    .width('100%');
                    if (this.params.images && this.params.images.length >= 3) {
                      Row({ space: 10 }) {
                        ForEach(this.params.images.slice(2, Math.min(5, this.params.images.length)), (img: ResourceStr) => {
                          Image(img)
                            .width(this.params.images!.length === 3 ? '100%' : '31%')
                            .height(this.params.images!.length === 3 ? 180 : 120)
                            .objectFit(ImageFit.Cover)
                            .borderRadius(12);
                        });
                      }
                      .width('100%');
                    }
                  }
                  .width('100%');
                }
              }
            }
            .width('100%');
          }

          // 互动区域（点赞、收藏、分享统计）
          Row() {
            Row({ space: 6 }) {
              Text(this.isLiked ? '❤️' : '🤍')
                .fontSize(18);
              Text(`${this.likeCount}`)
                .fontSize(14)
                .fontColor('#666666');
            }
            .padding({ left: 16, right: 16 })
            .onClick(() => this.toggleLike());

            Row({ space: 6 }) {
              Text(this.isCollected ? '⭐' : '☆')
                .fontSize(18);
              Text(`${this.collectCount}`)
                .fontSize(14)
                .fontColor('#666666');
            }
            .padding({ left: 16, right: 16 })
            .onClick(() => this.toggleCollect());

            Row({ space: 6 }) {
              Text('💬')
                .fontSize(18);
              Text(`${this.commentCount}`)
                .fontSize(14)
                .fontColor('#666666');
            }
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.showCommentInput = !this.showCommentInput;
            });

            Blank();

            Row({ space: 6 }) {
              Text('↗')
                .fontSize(18);
              Text('分享')
                .fontSize(14)
                .fontColor('#666666');
            }
            .padding({ left: 16, right: 16 })
            .onClick(() => this.shareContent());
          }
          .width('100%')
          .height(48)
          .backgroundColor('#f9f9f9')
          .borderRadius(12);

          // 评论输入区（可收起）
          if (this.showCommentInput) {
            Column({ space: 10 }) {
              TextInput({ placeholder: '写下你的评论...', text: this.commentText })
                .width('100%')
                .height(80)
                .backgroundColor('#ffffff')
                .border({ width: 1, color: '#e0e0e0' })
                .borderRadius(8)
                .padding(10)
                .onChange((value: string) => {
                  this.commentText = value;
                });

              Row({ space: 12 }) {
                Blank();
                Button('取消')
                  .height(36)
                  .backgroundColor('#f5f5f5')
                  .fontColor('#666666')
                  .borderRadius(18)
                  .onClick(() => {
                    this.showCommentInput = false;
                    this.commentText = '';
                  });
                Button('发布')
                  .height(36)
                  .backgroundColor('#0f88eb')
                  .fontColor('#ffffff')
                  .borderRadius(18)
                  .onClick(() => this.submitComment());
              }
              .width('100%');
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#f5f5f5')
            .borderRadius(12);
          }

          // 评论列表
          Column({ space: 12 }) {
            Row() {
              Text('全部评论')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333');
              Blank();
              Text(`${this.commentCount}条`)
                .fontSize(14)
                .fontColor('#999999');
            }
            .width('100%');

            ForEach(this.comments, (comment: CommentItem, index: number) => {
              Row({ space: 10 }) {
                Image(comment.avatar)
                  .width(36)
                  .height(36)
                  .borderRadius(18)
                  .objectFit(ImageFit.Cover);

                Column({ space: 4 }) {
                  Row() {
                    Text(comment.user)
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#333333');
                    Blank();
                    Text(comment.time)
                      .fontSize(12)
                      .fontColor('#999999');
                  }
                  .width('100%');

                  Text(comment.content)
                    .fontSize(14)
                    .fontColor('#555555')
                    .lineHeight(22)
                    .width('100%');

                  Row({ space: 4 }) {
                    Text(comment.isLiked ? '❤️' : '🤍')
                      .fontSize(14);
                    Text(`${comment.likes}`)
                      .fontSize(12)
                      .fontColor('#999999');
                  }
                  .onClick(() => this.toggleCommentLike(index));
                }
                .layoutWeight(1);
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#ffffff')
              .borderRadius(10);
            });
          }
          .width('100%');

          // 延伸阅读
          Column({ space: 12 }) {
            Text('延伸阅读：')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .width('100%');

            Text('1. 相关话题讨论')
              .fontSize(15)
              .fontColor('#0f88eb')
              .width('100%')
              .onClick(() => prompt.showToast({ message: '跳转到相关话题' }));

            Text('2. 类似问题推荐')
              .fontSize(15)
              .fontColor('#0f88eb')
              .width('100%')
              .onClick(() => prompt.showToast({ message: '跳转到类似问题' }));

            Text('3. 答主其他回答')
              .fontSize(15)
              .fontColor('#0f88eb')
              .width('100%')
              .onClick(() => prompt.showToast({ message: '查看答主其他回答' }));
          }
          .width('100%')
          .padding({ top: 8 });
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 100 });
      }
      .layoutWeight(1);

      // 底部操作栏
      Row({ space: 12 }) {
        Row({ space: 8 }) {
          Text('💬')
            .fontSize(20);
          Text('写评论...')
            .fontSize(14)
            .fontColor('#999999');
        }
        .layoutWeight(1)
        .height(40)
        .backgroundColor('#f5f5f5')
        .borderRadius(20)
        .padding({ left: 16 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.showCommentInput = true;
        });

        Column() {
          Text(this.isLiked ? '❤️' : '🤍')
            .fontSize(22);
          Text(`${this.likeCount}`)
            .fontSize(10)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .onClick(() => this.toggleLike());

        Column() {
          Text(this.isCollected ? '⭐' : '☆')
            .fontSize(22);
          Text(`${this.collectCount}`)
            .fontSize(10)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .onClick(() => this.toggleCollect());

        Column() {
          Text('↗')
            .fontSize(22);
          Text('分享')
            .fontSize(10)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .onClick(() => this.shareContent());
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#ffffff')
      .border({ width: { top: 0.5 }, color: '#e8e8e8' });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f7f8fa');
  }
}
