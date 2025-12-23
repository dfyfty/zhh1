# Pixabay图片下载指南

## 方法1：使用Python脚本自动下载（推荐）

### 步骤1：安装依赖
```bash
pip install requests
```

### 步骤2：运行下载脚本
```bash
python download_images_simple.py
```

这个脚本会：
- 自动下载所有需要的占位图片
- 保存到 `entry/src/main/resources/base/media/` 目录
- 使用正确的文件名

### 步骤3：替换为真实图片（可选）
如果需要使用Pixabay的真实图片：

1. 访问 https://pixabay.com/zh/
2. 搜索合适的图片（如：technology, nature, portrait等）
3. 下载图片
4. 重命名为对应的文件名（如：content_1.jpg, avatar_101.jpg等）
5. 替换media目录中的占位图片

## 方法2：手动下载Pixabay图片

### 需要的图片列表

#### 内容图片（40张）
- 文件名：`content_1.jpg` 到 `content_40.jpg`
- 推荐尺寸：400x300 或更大
- 搜索关键词：technology, nature, business, people, city, abstract, food, travel

#### 头像图片（约30张）
- 文件名：
  - `avatar_101.jpg` 到 `avatar_120.jpg` (20张)
  - `avatar_201.jpg`, `avatar_202.jpg`, `avatar_203.jpg` (3张)
  - `avatar_301.jpg`, `avatar_302.jpg`, `avatar_303.jpg` (3张)
  - `avatar_501.jpg` (1张)
  - `avatar_901.jpg` 到 `avatar_904.jpg` (4张)
  - `avatar_998.jpg`, `avatar_999.jpg`, `avatar_1001.jpg` (3张)
- 推荐尺寸：120x120 或更大
- 搜索关键词：portrait, person, face, profile, woman, man

#### 缩略图（9张）
- 文件名：
  - `thumb_701.jpg` 到 `thumb_704.jpg` (4张)
  - `thumb_801.jpg` 到 `thumb_805.jpg` (5张)
- 推荐尺寸：240x160 或更大
- 搜索关键词：technology, nature, business, people

#### 知识库Logo（3张）
- 文件名：`kb_401.jpg`, `kb_402.jpg`, `kb_403.jpg`
- 推荐尺寸：120x120 或更大
- 搜索关键词：technology, education, knowledge

#### 功能图标（10张）
- 文件名：`icon_601.jpg` 到 `icon_610.jpg`
- 推荐尺寸：80x80 或更大
- 搜索关键词：icon, symbol, sign, logo

#### 应用Logo（1张）
- 文件名：`logo_999.jpg`
- 推荐尺寸：64x64 或更大
- 搜索关键词：logo, brand, symbol

### 下载步骤

1. **访问Pixabay**
   - 打开 https://pixabay.com/zh/
   - 注册账号（可选，但推荐）

2. **搜索图片**
   - 在搜索框输入关键词
   - 选择"免费图片"（Free Images）
   - 选择合适的图片

3. **下载图片**
   - 点击图片进入详情页
   - 选择合适尺寸下载
   - 保存到本地

4. **重命名和放置**
   - 将下载的图片重命名为对应的文件名
   - 放到 `entry/src/main/resources/base/media/` 目录

## 方法3：使用Pixabay API（高级）

如果需要批量下载，可以使用Pixabay API：

1. **注册API Key**
   - 访问 https://pixabay.com/api/docs/
   - 注册账号并获取API key

2. **修改download_images.py**
   - 替换 `PIXABAY_API_KEY` 为你的API key
   - 运行脚本

3. **运行脚本**
   ```bash
   python download_images.py
   ```

## 注意事项

1. **文件命名规范**
   - 只能包含字母、数字和下划线：`[a-zA-Z0-9_]`
   - 不能包含中文字符或特殊字符

2. **图片格式**
   - 支持 JPG、PNG 格式
   - HarmonyOS推荐使用PNG格式

3. **图片尺寸**
   - 建议使用合适的尺寸，不要过大
   - 头像：120x120 或 180x180
   - 内容图片：400x300 或 640x480
   - 缩略图：240x160

4. **版权**
   - Pixabay的图片都是免费使用的
   - 无需署名，可用于商业用途

## 快速开始

最简单的方式是运行占位图片脚本：

```bash
python download_images_simple.py
```

这会立即下载所有占位图片，让项目可以编译运行。之后可以逐步替换为Pixabay的真实图片。


