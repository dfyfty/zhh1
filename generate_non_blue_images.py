#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成非蓝色彩色图片（PNG格式）
完全排除蓝色，使用暖色调和中性色调
"""

from pathlib import Path
import random

try:
    from PIL import Image, ImageDraw, ImageFont
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("警告: 未安装Pillow，请先安装: pip install Pillow")

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 定义非蓝色颜色主题（完全排除蓝色）
NON_BLUE_COLORS = [
    "#FF6B6B",  # 珊瑚红
    "#FF8C42",  # 橙红
    "#FFA07A",  # 浅橙
    "#F7DC6F",  # 黄色
    "#F8B739",  # 橙色
    "#52BE80",  # 绿色
    "#27AE60",  # 深绿
    "#1ABC9C",  # 青绿（偏绿）
    "#16A085",  # 深青绿
    "#E74C3C",  # 深红
    "#C0392B",  # 深红
    "#D35400",  # 深橙红
    "#E67E22",  # 深橙
    "#9B59B6",  # 紫色
    "#8E44AD",  # 深紫
    "#BB8FCE",  # 浅紫
    "#EC7063",  # 粉红
    "#F1948A",  # 浅粉
    "#F5B041",  # 金黄
    "#F39C12",  # 金色
    "#58D68D",  # 薄荷绿
    "#48C9B0",  # 青绿
    "#45B39D",  # 深青绿
    "#5DADE2",  # 这个是天蓝，需要排除
    "#85C1E2",  # 这个也是天蓝，需要排除
    "#A569BD",  # 紫红
    "#DC7633",  # 棕橙
    "#F4D03F",  # 亮黄
    "#82E0AA",  # 浅绿
    "#F8C471",  # 浅橙黄
]

# 完全排除蓝色，只使用暖色调和中性色调
WARM_COLORS = [
    "#FF6B6B",  # 珊瑚红
    "#FF8C42",  # 橙红
    "#FFA07A",  # 浅橙
    "#F7DC6F",  # 黄色
    "#F8B739",  # 橙色
    "#E74C3C",  # 深红
    "#C0392B",  # 深红
    "#D35400",  # 深橙红
    "#E67E22",  # 深橙
    "#EC7063",  # 粉红
    "#F1948A",  # 浅粉
    "#F5B041",  # 金黄
    "#F39C12",  # 金色
    "#DC7633",  # 棕橙
    "#F4D03F",  # 亮黄
    "#F8C471",  # 浅橙黄
]

GREEN_COLORS = [
    "#52BE80",  # 绿色
    "#27AE60",  # 深绿
    "#1ABC9C",  # 青绿
    "#16A085",  # 深青绿
    "#58D68D",  # 薄荷绿
    "#48C9B0",  # 青绿
    "#45B39D",  # 深青绿
    "#82E0AA",  # 浅绿
]

PURPLE_COLORS = [
    "#9B59B6",  # 紫色
    "#8E44AD",  # 深紫
    "#BB8FCE",  # 浅紫
    "#A569BD",  # 紫红
]

# 合并所有非蓝色颜色
ALL_NON_BLUE = WARM_COLORS + GREEN_COLORS + PURPLE_COLORS

def create_non_blue_image(width, height, color, save_path, pattern=None, text=None):
    """创建非蓝色彩色图片"""
    if not HAS_PIL:
        print(f"跳过 {save_path.name} (需要Pillow)")
        return False
    
    try:
        # 创建图片
        img = Image.new('RGB', (width, height), color=color)
        draw = ImageDraw.Draw(img)
        
        # 添加图案让图片更有趣
        if pattern == "gradient":
            # 渐变效果
            for y in range(height):
                ratio = y / height
                r = int(int(color[1:3], 16) * (1 - ratio * 0.2))
                g = int(int(color[3:5], 16) * (1 - ratio * 0.2))
                b = int(int(color[5:7], 16) * (1 - ratio * 0.2))
                r = max(0, min(255, r))
                g = max(0, min(255, g))
                b = max(0, min(255, b))
                draw.line([(0, y), (width, y)], fill=(r, g, b))
        elif pattern == "circles":
            # 添加一些圆形
            max_r = min(width, height) // 4
            if max_r > 5:  # 确保有足够的空间
                for _ in range(3):
                    x = random.randint(0, width)
                    y = random.randint(0, height)
                    r = random.randint(5, max_r)
                    # 使用半透明白色
                    overlay = Image.new('RGBA', (width, height), (0, 0, 0, 0))
                    overlay_draw = ImageDraw.Draw(overlay)
                    overlay_draw.ellipse([x-r, y-r, x+r, y+r], fill=(255, 255, 255, 80))
                    img = Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB')
                    draw = ImageDraw.Draw(img)
        elif pattern == "lines":
            # 添加一些线条
            for _ in range(5):
                x1 = random.randint(0, width)
                y1 = random.randint(0, height)
                x2 = random.randint(0, width)
                y2 = random.randint(0, height)
                draw.line([(x1, y1), (x2, y2)], fill=(255, 255, 255, 100), width=2)
        elif pattern == "dots":
            # 添加点状图案
            for _ in range(20):
                x = random.randint(0, width)
                y = random.randint(0, height)
                r = random.randint(3, 8)
                draw.ellipse([x-r, y-r, x+r, y+r], fill=(255, 255, 255, 150))
        
        # 如果需要添加文字
        if text:
            try:
                # 尝试使用系统字体
                font_size = min(width, height) // 8
                try:
                    font = ImageFont.truetype("arial.ttf", font_size)
                except:
                    try:
                        font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", font_size)
                    except:
                        font = ImageFont.load_default()
                
                # 计算文字位置（居中）
                bbox = draw.textbbox((0, 0), text, font=font)
                text_width = bbox[2] - bbox[0]
                text_height = bbox[3] - bbox[1]
                x = (width - text_width) // 2
                y = (height - text_height) // 2
                
                # 绘制文字（白色）
                draw.text((x, y), text, fill=(255, 255, 255), font=font)
            except:
                pass  # 如果字体加载失败，跳过文字
        
        # 保存为PNG
        img.save(save_path, 'PNG')
        print(f"OK: {save_path.name}")
        return True
    except Exception as e:
        print(f"FAIL: {save_path.name} - {e}")
        return False

def generate_all_images():
    """生成所有非蓝色图片"""
    print("开始生成非蓝色彩色图片（PNG格式）...")
    print("=" * 60)
    
    if not HAS_PIL:
        print("错误: 需要安装Pillow库")
        print("请运行: pip install Pillow")
        return
    
    generated = 0
    failed = 0
    
    # 设置随机种子确保可重复
    random.seed(123)  # 使用不同的种子确保颜色不同
    
    # 内容图片 (40张) - 使用暖色调
    print("\n1. 生成内容图片 (content_1 到 content_40)...")
    patterns = ["gradient", "circles", "lines", "dots", None]
    for i in range(1, 41):
        color = random.choice(WARM_COLORS + GREEN_COLORS)
        pattern = random.choice(patterns)
        save_path = MEDIA_DIR / f"content_{i}.png"
        if create_non_blue_image(400, 300, color, save_path, pattern):
            generated += 1
        else:
            failed += 1
    
    # 头像图片 - 使用各种颜色
    print("\n2. 生成头像图片...")
    avatar_ids = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
                  111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                  201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        color = random.choice(ALL_NON_BLUE)
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.png"
        if create_non_blue_image(120, 120, color, save_path, "circles"):
            generated += 1
        else:
            failed += 1
    
    # 缩略图 - 使用暖色调
    print("\n3. 生成缩略图...")
    thumb_ids = [701, 702, 703, 704, 801, 802, 803, 804, 805]
    for thumb_id in thumb_ids:
        color = random.choice(WARM_COLORS + GREEN_COLORS)
        pattern = random.choice(["gradient", "lines", "dots"])
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.png"
        if create_non_blue_image(240, 160, color, save_path, pattern):
            generated += 1
        else:
            failed += 1
    
    # 知识库Logo - 使用紫色和绿色
    print("\n4. 生成知识库Logo...")
    for i in range(401, 404):
        color = random.choice(PURPLE_COLORS + GREEN_COLORS)
        save_path = MEDIA_DIR / f"kb_{i}.png"
        if create_non_blue_image(120, 120, color, save_path, "circles"):
            generated += 1
        else:
            failed += 1
    
    # 功能图标 - 使用各种暖色
    print("\n5. 生成功能图标...")
    for i in range(601, 611):
        color = random.choice(WARM_COLORS)
        save_path = MEDIA_DIR / f"icon_{i}.png"
        if create_non_blue_image(80, 80, color, save_path, "circles"):
            generated += 1
        else:
            failed += 1
    
    # 应用Logo - 使用橙色（品牌色）
    print("\n6. 生成应用Logo...")
    save_path = MEDIA_DIR / "logo_999.png"
    if create_non_blue_image(64, 64, "#FF8C42", save_path, "circles"):
        generated += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"生成完成! 成功: {generated}, 失败: {failed}")
    print(f"目录: {MEDIA_DIR.absolute()}")
    print("\n所有图片已生成为非蓝色彩色图片（PNG格式）！")
    print("使用颜色：暖色调（红、橙、黄）+ 绿色 + 紫色")

if __name__ == "__main__":
    generate_all_images()

