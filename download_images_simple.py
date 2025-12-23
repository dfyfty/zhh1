#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
简化版图片下载脚本 - 使用Pixabay免费图片URL（无需API）
直接使用Pixabay的公开图片链接
"""

import os
import requests
from pathlib import Path
import time

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 使用Pixabay的免费图片URL（无需API key）
# 这些是Pixabay上公开的免费图片
PIXABAY_FREE_IMAGES = {
    # 内容图片 - 使用Pixabay的免费图片ID
    "content": [
        "https://pixabay.com/get/gc1234567890abcdef/",  # 占位符，需要替换为实际URL
    ],
    # 头像图片
    "avatar": [
        "https://pixabay.com/get/gc1234567890abcdef/",
    ]
}

def download_from_url(url, save_path):
    """从URL下载图片"""
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        response = requests.get(url, headers=headers, timeout=30, stream=True)
        response.raise_for_status()
        
        with open(save_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"✓ 下载成功: {save_path.name}")
        return True
    except Exception as e:
        print(f"✗ 下载失败 {save_path.name}: {e}")
        return False

def download_placeholder_images():
    """下载占位图片 - 使用免费的占位图片服务"""
    print("使用占位图片服务下载...")
    print("=" * 60)
    
    downloaded = 0
    
    # 使用placeholder.com或via.placeholder.com作为占位图片
    # 这些是免费的占位图片服务
    
    # 下载内容图片 (40张)
    print("\n1. 下载内容图片...")
    for i in range(1, 41):
        # 使用via.placeholder.com生成占位图片
        url = f"https://via.placeholder.com/400x300/4A90E2/FFFFFF?text=Content+{i}"
        save_path = MEDIA_DIR / f"content_{i}.png"
        if download_from_url(url, save_path):
            downloaded += 1
        time.sleep(0.1)  # 避免请求过快
    
    # 下载头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        url = f"https://via.placeholder.com/120x120/FF6B6B/FFFFFF?text=Avatar+{avatar_id}"
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.png"
        if download_from_url(url, save_path):
            downloaded += 1
        time.sleep(0.1)
    
    # 下载缩略图
    print("\n3. 下载缩略图...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    for thumb_id in thumb_ids:
        url = f"https://via.placeholder.com/240x160/50C878/FFFFFF?text=Thumb+{thumb_id}"
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.png"
        if download_from_url(url, save_path):
            downloaded += 1
        time.sleep(0.1)
    
    # 下载知识库Logo
    print("\n4. 下载知识库Logo...")
    for i in range(401, 404):
        url = f"https://via.placeholder.com/120x120/9B59B6/FFFFFF?text=KB+{i}"
        save_path = MEDIA_DIR / f"kb_{i}.png"
        if download_from_url(url, save_path):
            downloaded += 1
        time.sleep(0.1)
    
    # 下载功能图标
    print("\n5. 下载功能图标...")
    for i in range(601, 611):
        url = f"https://via.placeholder.com/80x80/F39C12/FFFFFF?text=Icon+{i}"
        save_path = MEDIA_DIR / f"icon_{i}.png"
        if download_from_url(url, save_path):
            downloaded += 1
        time.sleep(0.1)
    
    # 下载应用Logo
    print("\n6. 下载应用Logo...")
    url = "https://via.placeholder.com/64x64/3498DB/FFFFFF?text=Logo"
    save_path = MEDIA_DIR / "logo_999.png"
    if download_from_url(url, save_path):
        downloaded += 1
    
    print("\n" + "=" * 60)
    print(f"下载完成! 共下载 {downloaded} 张图片")
    print(f"保存目录: {MEDIA_DIR.absolute()}")
    print("\n注意: 这些是占位图片。如需真实图片，请:")
    print("1. 访问 https://pixabay.com/zh/")
    print("2. 搜索合适的图片")
    print("3. 下载并重命名为对应的文件名")
    print("4. 放到 media 目录中")

if __name__ == "__main__":
    try:
        import requests
    except ImportError:
        print("错误: 需要安装 requests 库")
        print("请运行: pip install requests")
        exit(1)
    
    download_placeholder_images()


