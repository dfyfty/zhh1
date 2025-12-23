import router from '@ohos.router';
import prompt from '@ohos.promptAction';

interface Account {
  username: string;
  password: string;
}

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPwd: string = '';

  aboutToAppear() {
    if (!AppStorage.Get<Account[]>('users')) {
      AppStorage.SetOrCreate('users', []);
    }
  }

  private validate(): boolean {
    if (!this.username.trim()) {
      prompt.showToast({ message: '请输入账号' });
      return false;
    }
    if (this.username.trim().length < 3) {
      prompt.showToast({ message: '账号需至少3个字符' });
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
    if (this.password !== this.confirmPwd) {
      prompt.showToast({ message: '两次密码不一致' });
      return false;
    }
    return true;
  }

  private register() {
    if (!this.validate()) {
      return;
    }
    const users = AppStorage.Get<Account[]>('users') ?? [];
    if (users.find((u: Account) => u.username === this.username.trim())) {
      prompt.showToast({ message: '账号已存在，请更换' });
      return;
    }
    const newUsers: Account[] = [...users, { username: this.username.trim(), password: this.password }];
    AppStorage.SetOrCreate('users', newUsers);
    prompt.showToast({ message: '注册成功，请返回登录' });
    router.back();
  }

  build() {
    Column() {
      Column({ space: 20 }) {
        // 标题
        Text('知乎乎 · 注册')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0c0c0c');

        // 账号输入
        Column({ space: 6 }) {
          Text('用户名')
            .fontSize(14)
            .fontColor('#555555');
          TextInput({ placeholder: '请设置账号' })
            .width('100%')
            .height(40)
            .border({ width: 0 })
            .padding({ left: 4, right: 4 })
            .onChange((value: string) => {
              this.username = value;
            });
          Divider().color('#dcdcdc').height(1);
        }

        // 密码输入
        Column({ space: 6 }) {
          Text('密码')
            .fontSize(14)
            .fontColor('#555555');
          TextInput({ placeholder: '请设置密码' })
            .width('100%')
            .height(40)
            .border({ width: 0 })
            .padding({ left: 4, right: 4 })
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            });
          Divider().color('#dcdcdc').height(1);
        }

        // 确认密码
        Column({ space: 6 }) {
          Text('确认密码')
            .fontSize(14)
            .fontColor('#555555');
          TextInput({ placeholder: '请确认密码' })
            .width('100%')
            .height(40)
            .border({ width: 0 })
            .padding({ left: 4, right: 4 })
            .type(InputType.Password)
            .onChange((value: string) => {
              this.confirmPwd = value;
            });
          Divider().color('#dcdcdc').height(1);
        }

        // 注册按钮
        Button('注册')
          .width('100%')
          .height(44)
          .backgroundColor('#0f88eb')
          .fontColor('#ffffff')
          .borderRadius(8)
          .shadow({ radius: 8, color: '#d9d9d9', offsetX: 0, offsetY: 2 })
          .onClick(() => {
            this.register();
          });

        // 返回登录页
        Row() {
          Text('已注册？')
            .fontSize(13)
            .fontColor('#666666');
          Text('直接登录')
            .fontSize(13)
            .fontColor('#0f88eb')
            .onClick(() => {
              router.back();
            });
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        // 注册说明
        Column({ space: 4 }) {
          Text('提示')
            .fontSize(13)
            .fontColor('#666666');
          Text('• 用户名至少 3 个字符，支持中英文与数字')
            .fontSize(12)
            .fontColor('#888888');
          Text('• 密码至少 6 位，建议包含数字与字母')
            .fontSize(12)
            .fontColor('#888888');
          Text('• 注册成功后可使用新账号在登录页登录知乎乎')
            .fontSize(12)
            .fontColor('#888888');
        }
      }
      .width('82%')
      .padding({ top: 28, bottom: 32, left: 24, right: 24 })
      .backgroundColor('#ffffff')
      .borderRadius(12)
      .shadow({ radius: 12, color: '#cfcfcf', offsetX: 0, offsetY: 4 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#e6d6f5');
  }
}


