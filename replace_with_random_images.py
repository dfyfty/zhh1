#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
使用Picsum Photos生成随机图片替换占位图
虽然不是主题相关，但至少不是蓝色占位图
"""

import requests
from pathlib import Path
import time

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

def download_from_picsum(width, height, seed, save_path):
    """从Picsum Photos下载图片"""
    try:
        url = f"https://picsum.photos/{width}/{height}?random={seed}"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        
        response = requests.get(url, headers=headers, timeout=30, stream=True)
        response.raise_for_status()
        
        with open(save_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"[OK] 下载成功: {save_path.name}")
        return True
    except Exception as e:
        print(f"[ERROR] 下载失败 {save_path.name}: {e}")
        return False

def download_all_images():
    """下载所有图片"""
    print("开始从Picsum Photos下载随机图片...")
    print("=" * 60)
    
    downloaded = 0
    failed = 0
    
    # 下载内容图片 (使用不同的随机种子)
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        # 使用较大的随机种子确保每张图片都不同
        seed = 1000 + i * 10
        save_path = MEDIA_DIR / f"content_{i}.jpg"
        if download_from_picsum(400, 300, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        seed = 2000 + avatar_id * 10
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
        if download_from_picsum(120, 120, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载缩略图
    print("\n3. 下载缩略图...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    for idx, thumb_id in enumerate(thumb_ids):
        seed = 3000 + thumb_id * 10
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
        if download_from_picsum(240, 160, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载知识库Logo
    print("\n4. 下载知识库Logo...")
    for i in range(401, 404):
        seed = 4000 + i * 10
        save_path = MEDIA_DIR / f"kb_{i}.jpg"
        if download_from_picsum(120, 120, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载功能图标
    print("\n5. 下载功能图标...")
    for i in range(601, 611):
        seed = 5000 + i * 10
        save_path = MEDIA_DIR / f"icon_{i}.jpg"
        if download_from_picsum(80, 80, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载应用Logo
    print("\n6. 下载应用Logo...")
    save_path = MEDIA_DIR / "logo_999.jpg"
    if download_from_picsum(64, 64, 9999, save_path):
        downloaded += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"下载完成!")
    print(f"成功: {downloaded} 张")
    print(f"失败: {failed} 张")
    print(f"保存目录: {MEDIA_DIR.absolute()}")
    print("\n注意: 这些是随机图片，如需主题相关图片，请参考 MANUAL_DOWNLOAD_GUIDE.md")

if __name__ == "__main__":
    try:
        import requests
    except ImportError:
        print("错误: 需要安装 requests 库")
        print("请运行: pip install requests")
        exit(1)
    
    download_all_images()


