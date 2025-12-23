import router from '@ohos.router';
import { CNKIPage } from './CNKIPage';

@Entry
@Component
struct ZhiHuHuHomePage {
  build() {
    // 容器组件作为根节点，内部渲染 CNKIPage 覆盖整个页面
    Column() {
      CNKIPage();
    }
    .width('100%')
    .height('100%');
  }
}


