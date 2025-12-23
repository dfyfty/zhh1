import router from '@ohos.router';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct ZhiHuHuLoginPage {
  @State username: string = '';
  @State password: string = '';

  private doLogin() {
    // 简单示例：不做严格校验，账号留空时使用默认昵称
    const name = this.username.trim() || '知乎乎用户';
    AppStorage.SetOrCreate('currentUser', name);
    prompt.showToast({ message: `欢迎回来，${name}` });
    // 登录后直接进入带底部导航的首页
    router.replaceUrl({ url: 'pages/MainPages/CNKIPage' });
  }

  build() {
    Column({ space: 24 }) {
      // 顶部标题
      Column({ space: 8 }) {
        Text('知乎乎登录')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0f88eb');
        Text('请输入账号和密码，进入知乎乎问答首页')
          .fontSize(14)
          .fontColor('#666666');
      }
      .width('100%')
      .padding({ top: 60, left: 24, right: 24 });

      // 账号输入
      Column({ space: 6 }) {
        Text('账号')
          .fontSize(14)
          .fontColor('#333333');
        TextInput({ placeholder: '请输入账号', text: this.username })
          .width('100%')
          .height(44)
          .border({ width: 1, color: '#dddddd' })
          .borderRadius(8)
          .padding({ left: 12 })
          .onChange((v: string) => {
            this.username = v;
          });
      }
      .padding({ left: 24, right: 24 });

      // 密码输入
      Column({ space: 6 }) {
        Text('密码')
          .fontSize(14)
          .fontColor('#333333');
        TextInput({ placeholder: '请输入密码' })
          .width('100%')
          .height(44)
          .border({ width: 1, color: '#dddddd' })
          .borderRadius(8)
          .padding({ left: 12 })
          .type(InputType.Password)
          .onChange((v: string) => {
            this.password = v;
          });
      }
      .padding({ left: 24, right: 24 });

      // 登录按钮
      Button('登录')
        .width('100%')
        .height(46)
        .backgroundColor('#0f88eb')
        .fontColor('#ffffff')
        .borderRadius(24)
        .margin({ left: 24, right: 24, top: 10 })
        .onClick(() => {
          this.doLogin();
        });

      // 去注册 / 游客体验
      Row({ space: 16 }) {
        Text('没有账号？去注册')
          .fontSize(13)
          .fontColor('#0f88eb')
          .onClick(() => {
            router.pushUrl({ url: 'pages/MainPages/ZhiHuHuRegisterPage' });
          });
        Text('先体验一下')
          .fontSize(13)
          .fontColor('#666666')
          .onClick(() => {
            router.pushUrl({ url: 'pages/MainPages/ZhiHuHuHomePage' });
          });
      }
      .margin({ left: 24, right: 24, top: 8 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff');
  }
}


