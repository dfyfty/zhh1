#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
简单可靠的图片下载脚本
使用Picsum Photos，这是最稳定的免费图片服务
"""

import requests
from pathlib import Path
import time

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

def download_image(url, save_path, max_retries=3):
    """下载图片"""
    for attempt in range(max_retries):
        try:
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
            response = requests.get(url, headers=headers, timeout=20, stream=True, allow_redirects=True)
            response.raise_for_status()
            
            with open(save_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
            
            # 检查文件大小
            if save_path.stat().st_size > 500:  # 至少500字节
                print(f"OK: {save_path.name}")
                return True
            else:
                save_path.unlink()
                if attempt < max_retries - 1:
                    time.sleep(1)
                    continue
                    
        except Exception as e:
            if attempt < max_retries - 1:
                time.sleep(1)
                continue
            print(f"FAIL: {save_path.name} - {str(e)[:50]}")
    
    return False

def download_all():
    """下载所有图片"""
    print("开始下载图片...")
    print("=" * 60)
    
    downloaded = 0
    failed = 0
    
    # 内容图片 (40张)
    print("\n1. 下载内容图片...")
    for i in range(1, 41):
        # 使用不同的ID确保每张图片都不同
        seed = 10000 + i * 100
        url = f"https://picsum.photos/400/300?random={seed}"
        save_path = MEDIA_DIR / f"content_{i}.jpg"
        if download_image(url, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.15)  # 避免请求过快
    
    # 头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
                  111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                  201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        seed = 20000 + avatar_id * 50
        url = f"https://picsum.photos/120/120?random={seed}"
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
        if download_image(url, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.15)
    
    # 缩略图
    print("\n3. 下载缩略图...")
    thumb_ids = [701, 702, 703, 704, 801, 802, 803, 804, 805]
    for thumb_id in thumb_ids:
        seed = 30000 + thumb_id * 50
        url = f"https://picsum.photos/240/160?random={seed}"
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
        if download_image(url, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.15)
    
    # 知识库Logo
    print("\n4. 下载知识库Logo...")
    for i in range(401, 404):
        seed = 40000 + i * 50
        url = f"https://picsum.photos/120/120?random={seed}"
        save_path = MEDIA_DIR / f"kb_{i}.jpg"
        if download_image(url, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.15)
    
    # 功能图标
    print("\n5. 下载功能图标...")
    for i in range(601, 611):
        seed = 50000 + i * 50
        url = f"https://picsum.photos/80/80?random={seed}"
        save_path = MEDIA_DIR / f"icon_{i}.jpg"
        if download_image(url, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.15)
    
    # 应用Logo
    print("\n6. 下载应用Logo...")
    url = f"https://picsum.photos/64/64?random=99999"
    save_path = MEDIA_DIR / "logo_999.jpg"
    if download_image(url, save_path):
        downloaded += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"完成! 成功: {downloaded}, 失败: {failed}")
    print(f"目录: {MEDIA_DIR.absolute()}")
    
    if failed > 0:
        print(f"\n提示: 有 {failed} 张失败，可以重新运行脚本重试")

if __name__ == "__main__":
    try:
        import requests
    except ImportError:
        print("需要安装: pip install requests")
        exit(1)
    
    download_all()


