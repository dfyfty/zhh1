#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
使用多个图片源下载图片，确保能成功下载
尝试多个免费图片服务，直到成功
"""

import requests
from pathlib import Path
import time
import random

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 多个图片源
IMAGE_SOURCES = [
    # 源1: Picsum Photos (随机图片)
    {
        "name": "Picsum Photos",
        "get_url": lambda w, h, seed: f"https://picsum.photos/{w}/{h}?random={seed}",
        "headers": {"User-Agent": "Mozilla/5.0"}
    },
    # 源2: Lorem Picsum (备用)
    {
        "name": "Lorem Picsum",
        "get_url": lambda w, h, seed: f"https://loremflickr.com/{w}/{h}/all?random={seed}",
        "headers": {"User-Agent": "Mozilla/5.0"}
    },
    # 源3: Placeholder.com (备用)
    {
        "name": "Placeholder",
        "get_url": lambda w, h, seed: f"https://placehold.co/{w}x{h}/random?text=Image",
        "headers": {"User-Agent": "Mozilla/5.0"}
    },
    # 源4: DummyImage (备用)
    {
        "name": "DummyImage",
        "get_url": lambda w, h, seed: f"https://dummyimage.com/{w}x{h}/4A90E2/ffffff&text=Image",
        "headers": {"User-Agent": "Mozilla/5.0"}
    },
]

def download_image_multi_source(width, height, seed, save_path, max_retries=3):
    """尝试多个图片源下载图片"""
    for attempt in range(max_retries):
        for source in IMAGE_SOURCES:
            try:
                url = source["get_url"](width, height, seed + attempt * 1000)
                headers = source["headers"]
                
                response = requests.get(url, headers=headers, timeout=15, stream=True, allow_redirects=True)
                response.raise_for_status()
                
                # 检查是否是有效的图片
                content_type = response.headers.get('content-type', '')
                if 'image' not in content_type.lower():
                    continue
                
                with open(save_path, 'wb') as f:
                    for chunk in response.iter_content(chunk_size=8192):
                        f.write(chunk)
                
                # 检查文件大小（至少1KB）
                if save_path.stat().st_size > 1024:
                    print(f"[OK] {save_path.name} (来源: {source['name']})")
                    return True
                else:
                    save_path.unlink()  # 删除太小的文件
                    continue
                    
            except Exception as e:
                continue
        
        # 如果所有源都失败，等待后重试
        if attempt < max_retries - 1:
            time.sleep(0.5)
    
    print(f"[FAIL] {save_path.name}")
    return False

def download_all_images():
    """下载所有图片"""
    print("开始从多个图片源下载图片...")
    print("=" * 60)
    
    downloaded = 0
    failed = 0
    
    # 下载内容图片
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        seed = 1000 + i * 17  # 使用质数确保不同
        save_path = MEDIA_DIR / f"content_{i}.jpg"
        if download_image_multi_source(400, 300, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.1)
    
    # 下载头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        seed = 2000 + avatar_id * 23
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
        if download_image_multi_source(120, 120, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.1)
    
    # 下载缩略图
    print("\n3. 下载缩略图...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    for thumb_id in thumb_ids:
        seed = 3000 + thumb_id * 29
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
        if download_image_multi_source(240, 160, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.1)
    
    # 下载知识库Logo
    print("\n4. 下载知识库Logo...")
    for i in range(401, 404):
        seed = 4000 + i * 31
        save_path = MEDIA_DIR / f"kb_{i}.jpg"
        if download_image_multi_source(120, 120, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.1)
    
    # 下载功能图标
    print("\n5. 下载功能图标...")
    for i in range(601, 611):
        seed = 5000 + i * 37
        save_path = MEDIA_DIR / f"icon_{i}.jpg"
        if download_image_multi_source(80, 80, seed, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.1)
    
    # 下载应用Logo
    print("\n6. 下载应用Logo...")
    save_path = MEDIA_DIR / "logo_999.jpg"
    if download_image_multi_source(64, 64, 9999, save_path):
        downloaded += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"下载完成!")
    print(f"成功: {downloaded} 张")
    print(f"失败: {failed} 张")
    print(f"保存目录: {MEDIA_DIR.absolute()}")
    
    if failed > 0:
        print(f"\n注意: 有 {failed} 张图片下载失败，可以重新运行脚本重试")

if __name__ == "__main__":
    try:
        import requests
    except ImportError:
        print("错误: 需要安装 requests 库")
        print("请运行: pip install requests")
        exit(1)
    
    download_all_images()


