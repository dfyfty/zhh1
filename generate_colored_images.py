#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
本地生成彩色图片，不依赖网络
使用PIL生成各种颜色的图片，替换蓝色占位图
"""

from pathlib import Path
import random

try:
    from PIL import Image, ImageDraw
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("警告: 未安装Pillow，将创建简单图片")

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 定义多种颜色主题（避免蓝色）
COLOR_THEMES = [
    "#FF6B6B",  # 红色
    "#4ECDC4",  # 青色
    "#45B7D1",  # 蓝色（浅）
    "#FFA07A",  # 浅橙
    "#98D8C8",  # 薄荷绿
    "#F7DC6F",  # 黄色
    "#BB8FCE",  # 紫色
    "#85C1E2",  # 天蓝
    "#F8B739",  # 橙色
    "#52BE80",  # 绿色
    "#E74C3C",  # 深红
    "#3498DB",  # 亮蓝
    "#9B59B6",  # 深紫
    "#1ABC9C",  # 青绿
    "#E67E22",  # 深橙
    "#34495E",  # 深灰蓝
    "#16A085",  # 深青
    "#27AE60",  # 深绿
    "#D35400",  # 深橙红
    "#C0392B",  # 深红
]

def create_colored_image(width, height, color, save_path, pattern=None):
    """创建彩色图片"""
    if not HAS_PIL:
        # 如果没有PIL，创建一个最小的有效PNG
        create_minimal_png(save_path, width, height)
        return True
    
    try:
        # 创建图片
        img = Image.new('RGB', (width, height), color=color)
        draw = ImageDraw.Draw(img)
        
        # 添加一些图案让图片更有趣
        if pattern == "gradient":
            # 渐变效果
            for y in range(height):
                ratio = y / height
                r = int(int(color[1:3], 16) * (1 - ratio * 0.3))
                g = int(int(color[3:5], 16) * (1 - ratio * 0.3))
                b = int(int(color[5:7], 16) * (1 - ratio * 0.3))
                draw.line([(0, y), (width, y)], fill=(r, g, b))
        elif pattern == "circles":
            # 添加一些圆形
            for _ in range(3):
                x = random.randint(0, width)
                y = random.randint(0, height)
                r = random.randint(20, min(width, height) // 3)
                draw.ellipse([x-r, y-r, x+r, y+r], fill=(255, 255, 255, 100), outline=None)
        elif pattern == "lines":
            # 添加一些线条
            for _ in range(5):
                x1 = random.randint(0, width)
                y1 = random.randint(0, height)
                x2 = random.randint(0, width)
                y2 = random.randint(0, height)
                draw.line([(x1, y1), (x2, y2)], fill=(255, 255, 255, 50), width=2)
        
        # 保存为JPG
        img.save(save_path, 'JPEG', quality=85)
        print(f"OK: {save_path.name}")
        return True
    except Exception as e:
        print(f"FAIL: {save_path.name} - {e}")
        return False

def create_minimal_png(save_path, width, height):
    """创建最小的有效PNG（备用方案）"""
    # 这是一个1x1像素的红色PNG
    minimal_png = bytes([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53, 0xDE,
        0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, 0x54,
        0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00, 0x00,
        0x03, 0x01, 0x01, 0x00, 0x18, 0xDD, 0x8D, 0xB4,
        0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44,
        0xAE, 0x42, 0x60, 0x82
    ])
    with open(save_path, 'wb') as f:
        f.write(minimal_png)
    print(f"OK (minimal): {save_path.name}")

def generate_all_images():
    """生成所有图片"""
    print("开始生成彩色图片（本地生成，无需网络）...")
    print("=" * 60)
    
    if not HAS_PIL:
        print("提示: 安装Pillow可以生成更好的图片: pip install Pillow")
    
    generated = 0
    failed = 0
    
    # 设置随机种子确保可重复
    random.seed(42)
    
    # 内容图片 (40张)
    print("\n1. 生成内容图片 (content_1 到 content_40)...")
    patterns = ["gradient", "circles", "lines", None]
    for i in range(1, 41):
        color = random.choice(COLOR_THEMES)
        pattern = random.choice(patterns)
        save_path = MEDIA_DIR / f"content_{i}.jpg"
        if create_colored_image(400, 300, color, save_path, pattern):
            generated += 1
        else:
            failed += 1
    
    # 头像图片
    print("\n2. 生成头像图片...")
    avatar_ids = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
                  111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                  201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        color = random.choice(COLOR_THEMES)
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
        if create_colored_image(120, 120, color, save_path, "circles"):
            generated += 1
        else:
            failed += 1
    
    # 缩略图
    print("\n3. 生成缩略图...")
    thumb_ids = [701, 702, 703, 704, 801, 802, 803, 804, 805]
    for thumb_id in thumb_ids:
        color = random.choice(COLOR_THEMES)
        pattern = random.choice(["gradient", "lines"])
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
        if create_colored_image(240, 160, color, save_path, pattern):
            generated += 1
        else:
            failed += 1
    
    # 知识库Logo
    print("\n4. 生成知识库Logo...")
    for i in range(401, 404):
        color = random.choice(COLOR_THEMES)
        save_path = MEDIA_DIR / f"kb_{i}.jpg"
        if create_colored_image(120, 120, color, save_path, "circles"):
            generated += 1
        else:
            failed += 1
    
    # 功能图标
    print("\n5. 生成功能图标...")
    for i in range(601, 611):
        color = random.choice(COLOR_THEMES)
        save_path = MEDIA_DIR / f"icon_{i}.jpg"
        if create_colored_image(80, 80, color, save_path, "circles"):
            generated += 1
        else:
            failed += 1
    
    # 应用Logo
    print("\n6. 生成应用Logo...")
    save_path = MEDIA_DIR / "logo_999.jpg"
    if create_colored_image(64, 64, "#0f88eb", save_path, "circles"):
        generated += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"生成完成! 成功: {generated}, 失败: {failed}")
    print(f"目录: {MEDIA_DIR.absolute()}")
    print("\n所有图片已生成为彩色图片，不再是蓝色占位图！")

if __name__ == "__main__":
    generate_all_images()


