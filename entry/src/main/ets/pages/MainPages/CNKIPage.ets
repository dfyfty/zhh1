import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface FeedItem {
  title: string;
  author: string;
  topic: string;
  time: string;
  tag?: string;
  summary?: string;
  images?: ResourceStr[]; // 图片资源数组
  authorAvatar?: ResourceStr; // 作者头像
}

interface MessageItem {
  from: string;
  title: string;
  time: string;
  unread: boolean;
  avatar?: ResourceStr; // 用户头像
}

interface KnowledgeBase {
  id: string;
  name: string;
  logo: ResourceStr;
  description: string;
  subscribers: number;
  contents: number;
  project?: string;
}

@Entry
@Component
export struct CNKIPage {
  @State currentTab: number = 0; // 0=首页 1=发现 2=私信
  @State query: string = '';
  @State filtered: FeedItem[] = [];
  @StorageLink('currentUser') currentUser: string = '';
  @State knowledgeBaseFlipStates: Map<string, boolean> = new Map(); // 知识库翻转状态

  // 模拟"知乎乎"内容数据
  private feedList: FeedItem[] = [
    { 
      title: '脸与身材不符是种怎样的体验？', 
      author: '答主 · 不倒斗的胡八一', 
      topic: '热榜 · 生活', 
      time: '2024', 
      tag: '生活', 
      summary: '又到了这只兔兔出现的时候...',
      images: [
        $r('app.media.content_1'),
        $r('app.media.content_2')
      ],
      authorAvatar: $r('app.media.avatar_101')
    },
    { 
      title: '为什么说男人至死都是少年？', 
      author: '答主 · 向前', 
      topic: '热榜 · 情感', 
      time: '2024', 
      tag: '情感', 
      summary: '丈母娘家小区暖气管爆了,一大早在修...',
      images: [
        $r('app.media.content_3'),
        $r('app.media.content_4'),
        $r('app.media.content_5')
      ],
      authorAvatar: $r('app.media.avatar_102')
    },
    { 
      title: '大模型会让哪些行业率先受益？', 
      author: '答主 · 李然', 
      topic: '热榜 · 科技', 
      time: '2024', 
      tag: 'AI', 
      summary: '效率、创造力、工具链改造三个角度的行业观察',
      images: [
        $r('app.media.content_6')
      ],
      authorAvatar: $r('app.media.avatar_103')
    },
    { 
      title: '个人如何做好数字安全防护？', 
      author: '答主 · 王璐', 
      topic: '热榜 · 安全', 
      time: '2023', 
      tag: '安全', 
      summary: '口令管理、双因子、设备加密与社工防御清单',
      images: [
        $r('app.media.content_7'),
        $r('app.media.content_8')
      ],
      authorAvatar: $r('app.media.avatar_104')
    },
    { 
      title: '新能源车电池未来五年的突破点是什么？', 
      author: '答主 · 陈曦', 
      topic: '热榜 · 能源', 
      time: '2025', 
      tag: '能源', 
      summary: '固态电池、快充安全、回收与梯次利用',
      images: [
        $r('app.media.content_9'),
        $r('app.media.content_10'),
        $r('app.media.content_11')
      ],
      authorAvatar: $r('app.media.avatar_105')
    },
    { 
      title: '如何用知识图谱做内容推荐？', 
      author: '答主 · 赵云', 
      topic: '专题 · 推荐', 
      time: '2022', 
      tag: '推荐', 
      summary: '实体关系补全、标签扩展与可解释推荐示例',
      images: [
        $r('app.media.content_12')
      ],
      authorAvatar: $r('app.media.avatar_106')
    },
    { 
      title: '跨学科提问时，让模型理解你的语境的技巧？', 
      author: '答主 · 钱七', 
      topic: '专题 · NLP', 
      time: '2021', 
      tag: 'NLP', 
      summary: '查询重写、上下文约束与少样本提示',
      images: [
        $r('app.media.content_13'),
        $r('app.media.content_14'),
        $r('app.media.content_15')
      ],
      authorAvatar: $r('app.media.avatar_107')
    },
    { 
      title: '如何快速掌握一门新的编程语言？', 
      author: '答主 · 张伟', 
      topic: '热榜 · 编程', 
      time: '2024', 
      tag: '编程', 
      summary: '从语法基础到项目实战，分享高效学习路径和实践经验',
      images: [
        $r('app.media.content_16')
      ],
      authorAvatar: $r('app.media.avatar_108')
    },
    { 
      title: '深度学习在医疗诊断中的应用前景如何？', 
      author: '答主 · 刘敏', 
      topic: '热榜 · 医疗', 
      time: '2024', 
      tag: '医疗', 
      summary: 'AI辅助诊断、影像识别、药物研发等领域的突破与挑战',
      images: [
        $r('app.media.content_17'),
        $r('app.media.content_18')
      ],
      authorAvatar: $r('app.media.avatar_109')
    },
    { 
      title: '区块链技术在金融领域的实际应用案例', 
      author: '答主 · 周强', 
      topic: '专题 · 区块链', 
      time: '2024', 
      tag: '区块链', 
      summary: '数字货币、智能合约、供应链金融等场景的落地实践',
      images: [
        $r('app.media.content_19'),
        $r('app.media.content_20'),
        $r('app.media.content_21')
      ],
      authorAvatar: $r('app.media.avatar_110')
    },
    { 
      title: '5G网络对物联网发展的推动作用', 
      author: '答主 · 吴磊', 
      topic: '热榜 · 通信', 
      time: '2024', 
      tag: '5G', 
      summary: '低延迟、高带宽特性如何赋能智能家居、工业互联网等场景',
      images: [
        $r('app.media.content_22')
      ],
      authorAvatar: $r('app.media.avatar_111')
    },
    { 
      title: '量子计算距离商业化还有多远？', 
      author: '答主 · 郑华', 
      topic: '热榜 · 量子', 
      time: '2024', 
      tag: '量子', 
      summary: '技术突破、应用场景、投资前景的全面分析',
      images: [
        $r('app.media.content_23'),
        $r('app.media.content_24')
      ],
      authorAvatar: $r('app.media.avatar_112')
    },
    { 
      title: '元宇宙概念下的虚拟现实技术发展', 
      author: '答主 · 孙丽', 
      topic: '专题 · VR', 
      time: '2024', 
      tag: 'VR', 
      summary: 'VR/AR设备、内容生态、用户体验的现状与未来',
      images: [
        $r('app.media.content_25'),
        $r('app.media.content_26'),
        $r('app.media.content_27')
      ],
      authorAvatar: $r('app.media.avatar_113')
    },
    { 
      title: '自动驾驶技术的安全性与可靠性探讨', 
      author: '答主 · 马超', 
      topic: '热榜 · 汽车', 
      time: '2024', 
      tag: '自动驾驶', 
      summary: '传感器融合、决策算法、事故责任等关键问题的深度解析',
      images: [
        $r('app.media.content_28')
      ],
      authorAvatar: $r('app.media.avatar_114')
    },
    { 
      title: '边缘计算在工业4.0中的关键作用', 
      author: '答主 · 赵敏', 
      topic: '专题 · 工业', 
      time: '2024', 
      tag: '工业', 
      summary: '实时数据处理、设备协同、智能制造的应用实践',
      images: [
        $r('app.media.content_29'),
        $r('app.media.content_30')
      ],
      authorAvatar: $r('app.media.avatar_115')
    },
    { 
      title: 'Web3.0时代的去中心化应用生态', 
      author: '答主 · 黄飞', 
      topic: '热榜 · Web3', 
      time: '2024', 
      tag: 'Web3', 
      summary: 'DeFi、NFT、DAO等去中心化应用的创新与挑战',
      images: [
        $r('app.media.content_31'),
        $r('app.media.content_32'),
        $r('app.media.content_33')
      ],
      authorAvatar: $r('app.media.avatar_116')
    },
    { 
      title: '人工智能在创意设计领域的突破', 
      author: '答主 · 林静', 
      topic: '专题 · 设计', 
      time: '2024', 
      tag: '设计', 
      summary: 'AI绘画、智能排版、创意生成的工具与实践案例',
      images: [
        $r('app.media.content_34')
      ],
      authorAvatar: $r('app.media.avatar_117')
    },
    { 
      title: '云计算成本优化的最佳实践', 
      author: '答主 · 陈明', 
      topic: '热榜 · 云服务', 
      time: '2024', 
      tag: '云计算', 
      summary: '资源调度、弹性伸缩、成本监控的策略与方法',
      images: [
        $r('app.media.content_35'),
        $r('app.media.content_36')
      ],
      authorAvatar: $r('app.media.avatar_118')
    },
    { 
      title: '数据隐私保护的技术方案与法律框架', 
      author: '答主 · 王芳', 
      topic: '专题 · 隐私', 
      time: '2024', 
      tag: '隐私', 
      summary: '差分隐私、同态加密、GDPR合规的技术与法律视角',
      images: [
        $r('app.media.content_37'),
        $r('app.media.content_38'),
        $r('app.media.content_39')
      ],
      authorAvatar: $r('app.media.avatar_119')
    },
    { 
      title: '低代码平台如何改变软件开发模式？', 
      author: '答主 · 李军', 
      topic: '热榜 · 开发', 
      time: '2024', 
      tag: '低代码', 
      summary: '快速开发、降低门槛、提升效率的新开发范式',
      images: [
        $r('app.media.content_40')
      ],
      authorAvatar: $r('app.media.avatar_120')
    }
  ];
  private readonly hotTags: string[] = ['AI', '安全', '能源', '推荐', 'NLP', '编程', '医疗', '区块链', '5G', '量子'];

  // 推荐知识库数据
  private knowledgeBases: KnowledgeBase[] = [
    {
      id: '1',
      name: '云工开物',
      logo: $r('app.media.kb_401'),
      description: '项目:云工开物——阿里云高校支持计划，提供丰富的技术资源和学习内容',
      subscribers: 182,
      contents: 13,
      project: '云工开物——阿里云高校支...'
    },
    {
      id: '2',
      name: 'AI技术前沿',
      logo: $r('app.media.kb_402'),
      description: '聚焦人工智能最新技术动态，分享深度学习、大模型等前沿知识',
      subscribers: 256,
      contents: 28,
      project: 'AI技术前沿研究'
    },
    {
      id: '3',
      name: '开发者社区',
      logo: $r('app.media.kb_403'),
      description: '汇聚开发者经验分享，涵盖前端、后端、移动开发等多个领域',
      subscribers: 189,
      contents: 35,
      project: '开发者技术交流'
    }
  ];

  // 模拟私信数据
  private messageList: MessageItem[] = [
    { 
      from: '系统通知', 
      title: '欢迎加入知乎乎社区，一起发现优质问答～', 
      time: '今天', 
      unread: true,
      avatar: $r('app.media.avatar_201')
    },
    { 
      from: '知乎乎小助手', 
      title: '你可以在这里收藏问题、关注话题', 
      time: '昨天', 
      unread: false,
      avatar: $r('app.media.avatar_202')
    },
    { 
      from: '产品更新', 
      title: '新版本支持私信提醒与消息订阅', 
      time: '3 天前', 
      unread: false,
      avatar: $r('app.media.avatar_203')
    }
  ];

  aboutToAppear() {
    this.filtered = this.feedList;
    if (!this.currentUser) {
      this.currentUser = AppStorage.Get<string>('currentUser') ?? '';
    }
    // 初始化知识库翻转状态
    this.knowledgeBases.forEach((kb: KnowledgeBase) => {
      this.knowledgeBaseFlipStates.set(kb.id, false);
    });
  }

  // 切换知识库卡片翻转状态
  private toggleKnowledgeBaseFlip(id: string) {
    const currentState = this.knowledgeBaseFlipStates.get(id) ?? false;
    this.knowledgeBaseFlipStates.set(id, !currentState);
  }

  private search() {
    const keyword = this.query.trim().toLowerCase();
    if (!keyword) {
      this.filtered = this.feedList;
      return;
    }
    this.filtered = this.feedList.filter((item: FeedItem) => {
      const content = `${item.title} ${item.author} ${item.topic} ${item.time} ${item.tag ?? ''} ${item.summary ?? ''}`.toLowerCase();
      return content.includes(keyword);
    });
  }

  private quickTag(tag: string) {
    this.query = tag;
    this.search();
  }

  private enterMine() {
      router.replaceUrl({ url: 'pages/MainPages/MinePage' });
  }

  private ensureLogin() {
    if (!this.currentUser) {
      prompt.showToast({ message: '请先登录' });
      router.replaceUrl({ url: 'pages/MainPages/ZhiHuHuLoginPage' });
    }
  }

  build() {
    Column() {
      // 顶部欢迎+搜索
      Column({ space: 8 }) {
        Row() {
          Row({ space: 8 }) {
            Image($r('app.media.logo_999'))
              .width(32)
              .height(32)
              .borderRadius(16)
              .border({ width: 2, color: '#ffffff' });
            Text('知乎乎')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ffffff');
          }
          .alignItems(VerticalAlign.Center)
          .padding({ left: 12, top: 10, bottom: 10 });
          
          Row({ space: 8 }) {
            if (this.currentUser) {
              Image($r('app.media.avatar_998'))
                .width(32)
                .height(32)
                .borderRadius(16)
                .border({ width: 2, color: '#ffffff' });
            }
            Text(this.currentUser ? `Hi，${this.currentUser}` : '未登录')
              .fontSize(14)
              .fontColor('#e9f3ff')
              .padding({ right: 12 })
              .onClick(() => {
                // 无论当前是否登录，点击右上角都进入统一的登录页面
                router.replaceUrl({ url: 'pages/MainPages/ZhiHuHuLoginPage' });
              });
          }
          .alignItems(VerticalAlign.Center);
        }
        .backgroundColor('#0f88eb')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .width('100%');

        Row({ space: 10 }) {
          TextInput({ placeholder: '搜索知乎乎内容/问题', text: this.query })
            .width('70%')
            .height(42)
            .border({ width: 1, color: '#eeeeee' })
            .borderRadius(6)
            .padding({ left: 10 })
            .onChange((value: string) => {
              this.query = value;
            });

          Button('搜索')
            .width('25%')
            .height(42)
            .backgroundColor('#0f88eb')
            .fontColor('#ffffff')
            .borderRadius(6)
            .onClick(() => {
              this.search();
            });
        }
        .alignItems(VerticalAlign.Center)
        .padding({ top: 12, left: 12, right: 12 });

        Row({ space: 8 }) {
          ForEach(this.hotTags, (tag: string) => {
            Button(tag)
              .type(ButtonType.Normal)
              .backgroundColor('#f0f7ff')
              .fontColor('#2b6fe8')
              .onClick(() => this.quickTag(tag));
          });
        }
        .padding({ left: 12, right: 12, bottom: 6 });
      }

      // 内容区
      if (this.currentTab === 0) {
        // 首页：搜索结果/推荐列表
        List({ space: 10 }) {
          ForEach(this.filtered, (item: FeedItem) => {
            ListItem() {
              Column({ space: 8 }) {
                // 作者信息行（带头像）
                Row({ space: 8 }) {
                  if (item.authorAvatar) {
                    Image(item.authorAvatar)
                      .width(36)
                      .height(36)
                      .borderRadius(18)
                      .objectFit(ImageFit.Cover);
                  }
                  Column({ space: 2 }) {
                    Text(item.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#333333');
                    Text(`${item.author} | ${item.topic} | ${item.time}`)
                      .fontSize(12)
                      .fontColor('#999999');
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start);
                }
                .width('100%');

                if (item.summary) {
                  Text(item.summary)
                    .fontSize(13)
                    .fontColor('#777777')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .width('100%');
                }

                // 图片展示区域
                if (item.images && item.images.length > 0) {
                  if (item.images.length === 1) {
                    // 单张图片：大图
                    Image(item.images[0])
                      .width('100%')
                      .height(200)
                      .objectFit(ImageFit.Cover)
                      .borderRadius(8)
                      .margin({ top: 4, bottom: 4 });
                  } else if (item.images.length === 2) {
                    // 两张图片：并排显示
                    Row({ space: 8 }) {
                      ForEach(item.images, (img: ResourceStr) => {
                        Image(img)
                          .width('48%')
                          .aspectRatio(1)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(8);
                      });
                    }
                    .width('100%')
                    .margin({ top: 4, bottom: 4 });
                  } else {
                    // 三张或更多图片：横向排列
                    Row({ space: 6 }) {
                      ForEach(item.images.slice(0, 3), (img: ResourceStr) => {
                        Image(img)
                          .width('31%')
                          .height(100)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(6);
                      });
                    }
                    .width('100%')
                    .margin({ top: 4, bottom: 4 });
                  }
                }

                Row({ space: 8 }) {
                  if (item.tag) {
                    Text(item.tag)
                      .fontSize(12)
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .backgroundColor('#eef5ff')
                      .fontColor('#2b6fe8')
                      .borderRadius(12);
                  }
                  Blank();
                  Button('查看详情')
                    .height(32)
                    .backgroundColor('#eeeeee')
                    .fontColor('#333333')
                    .borderRadius(6)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/MainPages/DetailPage',
                        params: {
                          title: item.title,
                          author: item.author,
                          topic: item.topic,
                          time: item.time,
                          summary: item.summary ?? '',
                          images: item.images ?? [],
                          authorAvatar: item.authorAvatar ?? ''
                        }
                      });
                    });
                }
                .width('100%');
              }
              .padding(12)
              .backgroundColor('#ffffff')
              .border({ width: 0.5, color: '#eeeeee' })
              .borderRadius(8)
              .margin({ bottom: 8 });
            };
          });
        }
        .padding({ left: 12, right: 12, top: 10 })
        .layoutWeight(1);
      } else if (this.currentTab === 1) {
        // 发现：重新设计的发现页面
        Scroll() {
          Column({ space: 20 }) {
            // 顶部大标题
            Column({ space: 16 }) {
              Text('用提问发现世界')
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .textAlign(TextAlign.Center)
                .width('100%')
                .padding({ top: 20, bottom: 8 });

              // 推荐问题区域
              Column({ space: 10 }) {
                Button('房价下跌对普通人意味着什么?')
                  .type(ButtonType.Normal)
                  .width('90%')
                  .height(44)
                  .backgroundColor('#f5f5f5')
                  .fontColor('#666666')
                  .fontSize(14)
                  .borderRadius(22)
                  .onClick(() => {
                    this.currentTab = 0;
                    this.query = '房价';
                    this.search();
                    prompt.showToast({ message: '已为你筛选：房价 下跌 普通人' });
                  });

                Button('如何部署DeepSeek联网?')
                  .type(ButtonType.Normal)
                  .width('90%')
                  .height(44)
                  .backgroundColor('#f5f5f5')
                  .fontColor('#666666')
                  .fontSize(14)
                  .borderRadius(22)
                  .onClick(() => {
                    this.currentTab = 0;
                    this.query = 'DeepSeek';
                    this.search();
                    prompt.showToast({ message: '已为你筛选：DeepSeek 联网 部署' });
                  });

                Button('索尼在历史上有哪些经典产品?')
                  .type(ButtonType.Normal)
                  .width('90%')
                  .height(44)
                  .backgroundColor('#f5f5f5')
                  .fontColor('#666666')
                  .fontSize(14)
                  .borderRadius(22)
                  .onClick(() => {
                    this.currentTab = 0;
                    this.query = '索尼';
                    this.search();
                    prompt.showToast({ message: '已为你筛选：索尼 经典 产品' });
                  });
              }
              .width('100%')
              .alignItems(HorizontalAlign.Center)
              .padding({ top: 8, bottom: 16 });
            }
            .width('100%')
            .padding({ bottom: 8 });

            // 推荐知识库模块
            Column({ space: 12 }) {
              // 标题栏
              Row() {
                Text('推荐知识库')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333');
                Blank();
                Row({ space: 4 }) {
                  Text('知识广场')
                    .fontSize(14)
                    .fontColor('#0f88eb');
                  Text('>')
                    .fontSize(16)
                    .fontColor('#0f88eb');
                }
                .onClick(() => {
                  prompt.showToast({ message: '进入知识广场' });
                });
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8 });

              // 知识库卡片列表（可横向滚动）
              Scroll() {
                Row({ space: 12 }) {
                  ForEach(this.knowledgeBases, (kb: KnowledgeBase) => {
                    // 可翻转的知识库卡片
                    Stack({ alignContent: Alignment.Center }) {
                      // 正面
                      Column({ space: 8 }) {
                        Row({ space: 10 }) {
                          Image(kb.logo)
                            .width(60)
                            .height(60)
                            .borderRadius(8)
                            .objectFit(ImageFit.Cover);
                          Column({ space: 4 }) {
                            Text(kb.name)
                              .fontSize(16)
                              .fontWeight(FontWeight.Bold)
                              .fontColor('#333333');
                            if (kb.project) {
                              Text(kb.project)
                                .fontSize(12)
                                .fontColor('#666666')
                                .maxLines(1)
                                .textOverflow({ overflow: TextOverflow.Ellipsis });
                            }
                          }
                          .layoutWeight(1)
                          .alignItems(HorizontalAlign.Start);
                        }
                        .width('100%');

                        Text(`${kb.name}·${kb.subscribers}人订阅·${kb.contents}个内容`)
                          .fontSize(12)
                          .fontColor('#999999')
                          .width('100%');
                      }
                      .width(280)
                      .height(120)
                      .padding(12)
                      .backgroundColor('#ffffff')
                      .borderRadius(12)
                      .shadow({ radius: 8, color: '#e5ebf5', offsetX: 0, offsetY: 2 })
                      .rotate({ x: 0, y: 1, z: 0, angle: this.knowledgeBaseFlipStates.get(kb.id) ? 180 : 0 })
                      .opacity(this.knowledgeBaseFlipStates.get(kb.id) ? 0 : 1)
                      .animation({ duration: 400, curve: Curve.EaseInOut });

                      // 背面（详细信息）
                      Column({ space: 8 }) {
                        Text(kb.name)
                          .fontSize(18)
                          .fontWeight(FontWeight.Bold)
                          .fontColor('#333333')
                          .margin({ bottom: 4 });
                        Text(kb.description)
                          .fontSize(13)
                          .fontColor('#666666')
                          .maxLines(4)
                          .textOverflow({ overflow: TextOverflow.Ellipsis });
                        Row({ space: 12 }) {
                          Column() {
                            Text(`${kb.subscribers}`)
                              .fontSize(16)
                              .fontWeight(FontWeight.Bold)
                              .fontColor('#0f88eb');
                            Text('订阅')
                              .fontSize(11)
                              .fontColor('#999999');
                          }
                          .alignItems(HorizontalAlign.Center);
                          Column() {
                            Text(`${kb.contents}`)
                              .fontSize(16)
                              .fontWeight(FontWeight.Bold)
                              .fontColor('#0f88eb');
                            Text('内容')
                              .fontSize(11)
                              .fontColor('#999999');
                          }
                          .alignItems(HorizontalAlign.Center);
                        }
                        .margin({ top: 8 })
                        .width('100%')
                        .justifyContent(FlexAlign.SpaceAround);
                      }
                      .width(280)
                      .height(120)
                      .padding(12)
                      .backgroundColor('#f0f7ff')
                      .borderRadius(12)
                      .shadow({ radius: 8, color: '#e5ebf5', offsetX: 0, offsetY: 2 })
                      .rotate({ x: 0, y: 1, z: 0, angle: this.knowledgeBaseFlipStates.get(kb.id) ? 0 : -180 })
                      .opacity(this.knowledgeBaseFlipStates.get(kb.id) ? 1 : 0)
                      .animation({ duration: 400, curve: Curve.EaseInOut });
                    }
                    .width(280)
                    .height(120)
                    .onClick(() => {
                      this.toggleKnowledgeBaseFlip(kb.id);
                    });
                  });
                }
                .padding({ left: 16, right: 16 });
              }
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Auto)
              .width('100%')
              .height(140);
            }
            .width('100%')
            .padding({ bottom: 8 })
            .backgroundColor('#f9f9f9');

            // 底部输入栏
            // 底部输入栏
            Row({ space: 10 }) {
              // 智能思考按钮
              Button('智能思考')
                .type(ButtonType.Normal)
                .height(44)
                .backgroundColor('#f0f7ff')
                .fontColor('#0f88eb')
                .fontSize(14)
                .borderRadius(22)
                .padding({ left: 16, right: 16 })
                .onClick(() => {
                  prompt.showToast({ message: '智能思考功能' });
                });

              // 知按钮
              Button('知')
                .type(ButtonType.Normal)
                .width(44)
                .height(44)
                .backgroundColor('#f0f7ff')
                .fontColor('#0f88eb')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .borderRadius(22)
                .onClick(() => {
                  prompt.showToast({ message: '知识功能' });
                });

              // 输入框
              Row({ space: 8 }) {
                Text('🎤')
                  .fontSize(20)
                  .margin({ left: 14 });
                Text('输入你的问题,使用@提问答主/知识')
                  .fontSize(14)
                  .fontColor('#999999')
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis });
                Text('📎')
                  .fontSize(20)
                  .margin({ right: 14 });
              }
              .layoutWeight(1)
              .height(44)
              .backgroundColor('#ffffff')
              .border({ width: 1, color: '#e0e0e0', radius: 22 })
              .borderRadius(22)
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                prompt.showToast({ message: '点击输入问题' });
              });
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 20, bottom: 20 })
            .backgroundColor('#ffffff');
          }
          .width('100%');
        }
        .layoutWeight(1);
      } else if (this.currentTab === 2) {
        // 私信：登录后查看系统消息 / 私信列表
        if (!this.currentUser) {
          Column({ space: 16 }) {
            Text('私信')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#0f88eb');
            Text('请先登录后查看私信与通知')
              .fontSize(14)
              .fontColor('#666666');

            Button('返回首页')
              .width(160)
              .height(40)
              .backgroundColor('#0f88eb')
              .fontColor('#ffffff')
              .borderRadius(8)
              .onClick(() => {
                this.currentTab = 0;
              });
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center);
        } else {
          Column({ space: 10 }) {
            Text('私信与通知')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#0f88eb');

            List({ space: 8 }) {
              ForEach(this.messageList, (msg: MessageItem, index: number) => {
                ListItem() {
                  Row({ space: 12 }) {
                    // 用户头像
                    if (msg.avatar) {
                      Image(msg.avatar)
                        .width(50)
                        .height(50)
                        .borderRadius(25)
                        .objectFit(ImageFit.Cover)
                        .border({ width: 2, color: '#f0f0f0' });
                    } else {
                      // 默认头像占位
                      Column()
                        .width(50)
                        .height(50)
                        .borderRadius(25)
                        .backgroundColor('#e0e0e0')
                        .justifyContent(FlexAlign.Center)
                        .alignItems(HorizontalAlign.Center);
                    }
                    
                    Column({ space: 4 }) {
                      Row({ space: 8 }) {
                        Text(msg.from)
                          .fontSize(15)
                          .fontWeight(FontWeight.Medium)
                          .fontColor('#333333');
                        if (msg.unread) {
                          Text('未读')
                            .fontSize(10)
                            .fontColor('#ffffff')
                            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                            .backgroundColor('#ff4d4f')
                            .borderRadius(10);
                        }
                      }
                      .width('100%');
                      Text(msg.title)
                        .fontSize(14)
                        .fontWeight(msg.unread ? FontWeight.Bold : FontWeight.Normal)
                        .fontColor('#333333')
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis });
                      Text(msg.time)
                        .fontSize(12)
                        .fontColor('#999999');
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start);
                  }
                  .padding(12)
                  .backgroundColor('#ffffff')
                  .borderRadius(10)
                  .onClick(() => {
                    // 打开对话详情页，并标记为已读
                    this.messageList[index].unread = false;
                    router.pushUrl({
                      url: 'pages/MainPages/MessageDetailPage',
                      params: {
                        from: msg.from,
                        title: msg.title,
                        time: msg.time
                      }
                    });
                  });
                };
              });
            }
          }
          .padding({ left: 16, right: 16, top: 16, bottom: 12 })
          .layoutWeight(1);
        }
      } else {
        // “我的”占位页：带返回按钮，底部仍有统一导航栏
        Column({ space: 16 }) {
          Text('正在跳转到“我的”')
            .fontSize(16)
            .fontColor('#666666');

          Button('返回首页')
            .width(160)
            .height(40)
            .backgroundColor('#0f88eb')
            .fontColor('#ffffff')
            .borderRadius(8)
            .onClick(() => {
              // 仅切回首页 tab，不做路由跳转
              this.currentTab = 0;
            });
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center);
      }

      // 底部导航栏（含中间发布按钮）
      Row() {
        Column() {
          Text('首页')
            .fontSize(14)
            .fontColor(this.currentTab === 0 ? '#0f88eb' : '#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 0;
        });

        Column() {
          Text('发现')
            .fontSize(14)
            .fontColor(this.currentTab === 1 ? '#0f88eb' : '#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 1;
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
          this.ensureLogin();
          if (this.currentUser) {
            router.pushUrl({ url: 'pages/MainPages/PublishPage' });
          }
        });

        Column() {
          Text('私信')
            .fontSize(14)
            .fontColor(this.currentTab === 2 ? '#0f88eb' : '#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          this.currentTab = 2;
          if (!this.currentUser) {
            this.ensureLogin();
          }
        });

        Column() {
          Text('我的')
            .fontSize(14)
            .fontColor('#666666');
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
        .onClick(() => {
          this.ensureLogin();
          this.enterMine();
        });
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


