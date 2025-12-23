#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
本地生成占位图片脚本
使用PIL/Pillow库生成占位图片，无需网络连接
"""

import os
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
    HAS_PIL = True
except ImportError:
    HAS_PIL = False
    print("警告: 未安装PIL/Pillow库，将使用简单方法生成图片")

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

def create_placeholder_with_pil(width, height, text, bg_color, text_color, save_path):
    """使用PIL创建占位图片"""
    try:
        # 创建图片
        img = Image.new('RGB', (width, height), color=bg_color)
        draw = ImageDraw.Draw(img)
        
        # 尝试使用默认字体
        try:
            font = ImageFont.truetype("arial.ttf", 20)
        except:
            try:
                font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", 20)
            except:
                font = ImageFont.load_default()
        
        # 计算文本位置（居中）
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        position = ((width - text_width) // 2, (height - text_height) // 2)
        
        # 绘制文本
        draw.text(position, text, fill=text_color, font=font)
        
        # 保存图片
        img.save(save_path, 'PNG')
        print(f"成功创建: {save_path.name}")
        return True
    except Exception as e:
        print(f"创建失败 {save_path.name}: {e}")
        return False

def create_simple_placeholder(width, height, save_path):
    """创建简单的纯色占位图片（不使用PIL）"""
    try:
        # 使用简单的PNG格式创建纯色图片
        # PNG文件头 + 简单的IHDR块
        png_data = bytearray([
            0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,  # PNG签名
        ])
        
        # 由于不使用PIL，我们创建一个最小的有效图片文件
        # 这里使用一个1x1像素的PNG
        # 实际应用中建议安装Pillow: pip install Pillow
        
        # 如果PIL不可用，创建一个空文件作为占位符
        with open(save_path, 'wb') as f:
            # 写入一个最小的有效PNG（1x1红色像素）
            minimal_png = bytes([
                0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,  # PNG签名
                0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,  # IHDR块
                0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,  # 1x1
                0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53, 0xDE,
                0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, 0x54,  # IDAT块
                0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00, 0x00,
                0x03, 0x01, 0x01, 0x00, 0x18, 0xDD, 0x8D, 0xB4,
                0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44,  # IEND块
                0xAE, 0x42, 0x60, 0x82
            ])
            f.write(minimal_png)
        
        print(f"创建占位文件: {save_path.name} (需要安装Pillow生成真实图片)")
        return True
    except Exception as e:
        print(f"创建失败 {save_path.name}: {e}")
        return False

def generate_all_images():
    """生成所有需要的图片"""
    print("开始生成占位图片...")
    print("=" * 60)
    
    if not HAS_PIL:
        print("\n注意: 未安装Pillow库")
        print("建议运行: pip install Pillow")
        print("将创建最小占位文件...\n")
    
    generated = 0
    
    # 颜色配置
    colors = {
        "content": ("#4A90E2", "#FFFFFF"),  # 蓝色背景，白色文字
        "avatar": ("#FF6B6B", "#FFFFFF"),   # 红色背景，白色文字
        "thumb": ("#50C878", "#FFFFFF"),   # 绿色背景，白色文字
        "kb": ("#9B59B6", "#FFFFFF"),      # 紫色背景，白色文字
        "icon": ("#F39C12", "#FFFFFF"),     # 橙色背景，白色文字
        "logo": ("#3498DB", "#FFFFFF")      # 蓝色背景，白色文字
    }
    
    # 生成内容图片 (40张)
    print("\n1. 生成内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        save_path = MEDIA_DIR / f"content_{i}.png"
        if HAS_PIL:
            if create_placeholder_with_pil(400, 300, f"Content {i}", colors["content"][0], colors["content"][1], save_path):
                generated += 1
        else:
            if create_simple_placeholder(400, 300, save_path):
                generated += 1
    
    # 生成头像图片
    print("\n2. 生成头像图片...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.png"
        if HAS_PIL:
            if create_placeholder_with_pil(120, 120, f"Avatar {avatar_id}", colors["avatar"][0], colors["avatar"][1], save_path):
                generated += 1
        else:
            if create_simple_placeholder(120, 120, save_path):
                generated += 1
    
    # 生成缩略图
    print("\n3. 生成缩略图...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    for thumb_id in thumb_ids:
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.png"
        if HAS_PIL:
            if create_placeholder_with_pil(240, 160, f"Thumb {thumb_id}", colors["thumb"][0], colors["thumb"][1], save_path):
                generated += 1
        else:
            if create_simple_placeholder(240, 160, save_path):
                generated += 1
    
    # 生成知识库Logo
    print("\n4. 生成知识库Logo...")
    for i in range(401, 404):
        save_path = MEDIA_DIR / f"kb_{i}.png"
        if HAS_PIL:
            if create_placeholder_with_pil(120, 120, f"KB {i}", colors["kb"][0], colors["kb"][1], save_path):
                generated += 1
        else:
            if create_simple_placeholder(120, 120, save_path):
                generated += 1
    
    # 生成功能图标
    print("\n5. 生成功能图标...")
    for i in range(601, 611):
        save_path = MEDIA_DIR / f"icon_{i}.png"
        if HAS_PIL:
            if create_placeholder_with_pil(80, 80, f"Icon {i}", colors["icon"][0], colors["icon"][1], save_path):
                generated += 1
        else:
            if create_simple_placeholder(80, 80, save_path):
                generated += 1
    
    # 生成应用Logo
    print("\n6. 生成应用Logo...")
    save_path = MEDIA_DIR / "logo_999.png"
    if HAS_PIL:
        if create_placeholder_with_pil(64, 64, "Logo", colors["logo"][0], colors["logo"][1], save_path):
            generated += 1
    else:
        if create_simple_placeholder(64, 64, save_path):
            generated += 1
    
    print("\n" + "=" * 60)
    print(f"生成完成! 共生成 {generated} 张图片")
    print(f"保存目录: {MEDIA_DIR.absolute()}")
    
    if not HAS_PIL:
        print("\n提示: 安装Pillow库可以生成带文字的占位图片:")
        print("pip install Pillow")

if __name__ == "__main__":
    generate_all_images()


