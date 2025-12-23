import router from '@ohos.router';
import prompt from '@ohos.promptAction';

@Entry
@Component
struct ZhiHuHuRegisterPage {
  @State username: string = '';
  @State phone: string = '';
  @State password: string = '';
  @State confirmPwd: string = '';

  private validateAndRegister() {
    if (!this.username) {
      prompt.showToast({ message: '请输入用户名' });
      return;
    }
    if (!this.phone || this.phone.length !== 11) {
      prompt.showToast({ message: '请输入正确的手机号' });
      return;
    }
    if (this.password.length < 6 || this.password.length > 16) {
      prompt.showToast({ message: '密码长度需为6-16位' });
      return;
    }
    if (this.password !== this.confirmPwd) {
      prompt.showToast({ message: '两次密码输入不一致' });
      return;
    }

    prompt.showToast({ message: '注册成功，请登录' });
    setTimeout(() => {
      router.pushUrl({ url: 'pages/MainPages/ZhiHuHuLoginPage' });
    }, 1500);
  }

  build() {
    Column({ space: 15 }) {
      // 返回 + 标题
      Row({ space: 10 }) {
        Button('< 返回')
          .fontSize(14)
          .fontColor('#007AFF')
          .backgroundColor('#ffffff')
          .onClick(() => {
            router.back();
          });
        Text('账号注册')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333');
      }
      .margin({ top: 40, bottom: 20 });

      // 用户名
      TextInput({ placeholder: '请设置用户名' })
        .width('100%')
        .height(45)
        .border({ width: 1, color: '#eeeeee' })
        .borderRadius(8)
        .padding({ left: 15 })
        .onChange((value: string) => {
          this.username = value;
        });

      // 手机号，只允许数字（通过 inputFilter 过滤非数字字符）
      TextInput({ placeholder: '请输入手机号' })
        .width('100%')
        .height(45)
        .border({ width: 1, color: '#eeeeee' })
        .borderRadius(8)
        .padding({ left: 15 })
        .inputFilter('^[0-9]*$', (value: string) => {
          // 输入不符合规则时的回调，这里简单忽略或做提示
          // 可根据需要使用 prompt.showToast 提示
        })
        .onChange((value: string) => {
          this.phone = value;
        });

      // 密码
      TextInput({ placeholder: '请设置密码（6-16位）' })
        .width('100%')
        .height(45)
        .border({ width: 1, color: '#eeeeee' })
        .borderRadius(8)
        .padding({ left: 15 })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        });

      // 确认密码
      TextInput({ placeholder: '请确认密码' })
        .width('100%')
        .height(45)
        .border({ width: 1, color: '#eeeeee' })
        .borderRadius(8)
        .padding({ left: 15 })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.confirmPwd = value;
        });

      Button('完成注册')
        .width('100%')
        .height(45)
        .backgroundColor('#007AFF')
        .fontColor('#ffffff')
        .borderRadius(8)
        .margin({ top: 10 })
        .onClick(() => {
          this.validateAndRegister();
        });
    }
    .padding({ left: 20, right: 20, bottom: 20 })
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff');
  }
}


