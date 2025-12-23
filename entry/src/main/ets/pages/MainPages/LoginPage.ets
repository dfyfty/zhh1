import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface Account {
  username: string;
  password: string;
}

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  private readonly defaultUser: Account = { username: 'xiezhi', password: '123456' };

  private safeNav(url: string) {
    try {
      // 优先 pushUrl，失败再 fallback replaceUrl，最大化跳转成功率
      router.pushUrl({ url });
    } catch (e) {
      try {
        router.replaceUrl({ url });
      } catch (err) {
        prompt.showToast({ message: '跳转失败，请确认 module.json5 已登记页面' });
      }
    }
  }

  aboutToAppear() {
    this.ensureStorage();
  }

  onPageShow() {
    this.ensureStorage();
  }

  private ensureStorage() {
    const existed = AppStorage.Get<Account[]>('users');
    if (!existed || existed.length === 0) {
      AppStorage.SetOrCreate('users', [this.defaultUser]);
    }
    if (!AppStorage.Has('currentUser')) {
      AppStorage.SetOrCreate('currentUser', '');
    }
  }

  private validate(): boolean {
    if (!this.username.trim()) {
      prompt.showToast({ message: '请输入账号' });
      return false;
    }
    if (!this.password) {
      prompt.showToast({ message: '请输入密码' });
      return false;
    }
    if (this.password.length < 6) {
      prompt.showToast({ message: '密码至少6位' });
      return false;
    }
    return true;
  }

  private doLogin() {
    if (!this.validate()) {
      return;
    }

    const users = AppStorage.Get<Account[]>('users') ?? [];
    const matched = users.find((u: Account) => u.username === this.username.trim() && u.password === this.password);
    if (!matched) {
      prompt.showToast({ message: '账号或密码错误' });
      return;
    }

    AppStorage.SetOrCreate('currentUser', matched.username);
    prompt.showToast({ message: '登录成功' });
    this.safeNav('pages/MainPages/CNKIPage');
  }

  build() {
    Column() {
      // 顶部 Logo / 文案
      Column({ space: 6 }) {
        Text('知乎乎')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0f88eb');
        Text('登录后与社区一起发现优质问答')
          .fontSize(14)
          .fontColor('#4d4d4d');
      }
      .margin({ bottom: 12 })

      // 表单卡片
      Column({ space: 22 }) {
        // 用户名
        Column({ space: 6 }) {
          Text('用户名')
            .fontSize(14)
            .fontColor('#555555');
          TextInput({ placeholder: '请输入用户名' })
            .width('100%')
            .height(44)
            .border({ width: 1, color: '#e5e8ee' })
            .borderRadius(10)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.username = value;
            });
        }

        // 密码
        Column({ space: 6 }) {
          Text('密码')
            .fontSize(14)
            .fontColor('#555555');
          TextInput({ placeholder: '请输入密码' })
            .width('100%')
            .height(44)
            .border({ width: 1, color: '#e5e8ee' })
            .borderRadius(10)
            .padding({ left: 12, right: 12 })
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            });
        }

        // 登录按钮
        Button('登录')
          .width('100%')
          .height(46)
          .fontColor('#ffffff')
          .borderRadius(12)
          .shadow({ radius: 10, color: '#d9e7fb', offsetX: 0, offsetY: 3 })
          .backgroundColor('#0f88eb')
          .onClick(() => {
            this.doLogin();
          });

        // 轻提示/注册链接
        Row() {
          Text('未注册？')
            .fontSize(13)
            .fontColor('#666666');
          Text('去注册')
            .fontSize(13)
            .fontColor('#0f88eb')
            .onClick(() => {
              router.pushUrl({ url: 'pages/RegisterPage/RegisterPage' });
            });
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        // 一键体验（默认账号）
        Button('一键体验（默认账号）')
          .width('100%')
          .height(44)
          .backgroundColor('#f2f6ff')
          .fontColor('#0f88eb')
          .borderRadius(10)
          .onClick(() => {
            this.ensureStorage();
            AppStorage.SetOrCreate('currentUser', this.defaultUser.username);
            prompt.showToast({ message: '已使用默认账号登录' });
            this.safeNav('pages/MainPages/CNKIPage');
          });

        // 登录说明
        Column({ space: 4 }) {
          Text('提示')
            .fontSize(13)
            .fontColor('#666666');
          Text('• 默认体验账号：xiezhi / 123456')
            .fontSize(12)
            .fontColor('#888888');
          Text('• 登录后可访问首页/发现/我的，查看收藏与历史')
            .fontSize(12)
            .fontColor('#888888');
        }
      }
      .width('86%')
      .padding({ top: 28, bottom: 32, left: 24, right: 24 })
      .backgroundColor('#ffffff')
      .borderRadius(16)
      .shadow({ radius: 18, color: '#dfe6f3', offsetX: 0, offsetY: 8 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f2f6fb');
  }
}


