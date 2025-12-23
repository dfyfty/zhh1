#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
自动从Pixabay下载图片并保存到指定目录
使用Pixabay的免费图片API
"""

import os
import requests
import json
from pathlib import Path

# Pixabay API配置（使用免费API，无需注册）
# 注意：实际使用时建议注册获取API key以获得更好的服务
PIXABAY_API_KEY = "9656065-a4094594c34c9d8b680cc1a64"  # 示例API key，建议替换
PIXABAY_API_URL = "https://pixabay.com/api/"

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 图片需求列表
IMAGE_REQUIREMENTS = {
    # 内容图片 (40张) - 各种主题
    "content": {
        "count": 40,
        "keywords": ["technology", "nature", "business", "people", "city", "abstract", "food", "travel"],
        "size": "medium"  # 640x960
    },
    # 头像图片 (约30张) - 人物头像
    "avatar": {
        "count": 30,
        "keywords": ["portrait", "person", "face", "profile", "woman", "man"],
        "size": "small"  # 180x180
    },
    # 缩略图 (9张) - 各种主题
    "thumb": {
        "count": 9,
        "keywords": ["technology", "nature", "business", "people"],
        "size": "small"  # 180x180
    },
    # 知识库Logo (3张) - 科技/教育主题
    "kb": {
        "count": 3,
        "keywords": ["technology", "education", "knowledge"],
        "size": "small"  # 180x180
    },
    # 功能图标 (10张) - 图标/符号
    "icon": {
        "count": 10,
        "keywords": ["icon", "symbol", "sign", "logo"],
        "size": "small"  # 180x180
    },
    # 应用Logo (1张)
    "logo": {
        "count": 1,
        "keywords": ["logo", "brand", "symbol"],
        "size": "small"  # 180x180
    }
}

def download_image(url, save_path):
    """下载图片并保存"""
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        
        with open(save_path, 'wb') as f:
            f.write(response.content)
        
        print(f"✓ 下载成功: {save_path.name}")
        return True
    except Exception as e:
        print(f"✗ 下载失败 {save_path.name}: {e}")
        return False

def search_pixabay_images(keyword, count=1, size="medium"):
    """从Pixabay搜索图片"""
    try:
        params = {
            "key": PIXABAY_API_KEY,
            "q": keyword,
            "image_type": "photo",
            "orientation": "horizontal",
            "safesearch": "true",
            "per_page": min(count, 200)  # Pixabay最多返回200张
        }
        
        response = requests.get(PIXABAY_API_URL, params=params, timeout=30)
        response.raise_for_status()
        
        data = response.json()
        if "hits" in data and len(data["hits"]) > 0:
            # 根据size选择图片URL
            images = []
            for hit in data["hits"][:count]:
                if size == "small":
                    url = hit.get("previewURL") or hit.get("webformatURL")
                elif size == "medium":
                    url = hit.get("webformatURL") or hit.get("largeImageURL")
                else:
                    url = hit.get("largeImageURL") or hit.get("webformatURL")
                
                if url:
                    images.append(url)
            
            return images
        else:
            print(f"  警告: 未找到关键词 '{keyword}' 的图片")
            return []
    except Exception as e:
        print(f"  错误: 搜索Pixabay失败 ({keyword}): {e}")
        return []

def download_all_images():
    """下载所有需要的图片"""
    print("开始下载图片...")
    print("=" * 60)
    
    downloaded = 0
    failed = 0
    
    # 下载内容图片
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    keywords = IMAGE_REQUIREMENTS["content"]["keywords"]
    for i in range(1, 41):
        keyword = keywords[i % len(keywords)]
        images = search_pixabay_images(keyword, count=1, size=IMAGE_REQUIREMENTS["content"]["size"])
        if images:
            save_path = MEDIA_DIR / f"content_{i}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
    
    # 下载头像图片
    print("\n2. 下载头像图片 (avatar_101 到 avatar_120, avatar_201-203, avatar_301-303, avatar_501, avatar_901-904, avatar_998-999, avatar_1001)...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    keywords = IMAGE_REQUIREMENTS["avatar"]["keywords"]
    for idx, avatar_id in enumerate(avatar_ids):
        keyword = keywords[idx % len(keywords)]
        images = search_pixabay_images(keyword, count=1, size=IMAGE_REQUIREMENTS["avatar"]["size"])
        if images:
            save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
    
    # 下载缩略图
    print("\n3. 下载缩略图 (thumb_701-704, thumb_801-805)...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    keywords = IMAGE_REQUIREMENTS["thumb"]["keywords"]
    for idx, thumb_id in enumerate(thumb_ids):
        keyword = keywords[idx % len(keywords)]
        images = search_pixabay_images(keyword, count=1, size=IMAGE_REQUIREMENTS["thumb"]["size"])
        if images:
            save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
    
    # 下载知识库Logo
    print("\n4. 下载知识库Logo (kb_401-403)...")
    keywords = IMAGE_REQUIREMENTS["kb"]["keywords"]
    for i in range(401, 404):
        keyword = keywords[(i - 401) % len(keywords)]
        images = search_pixabay_images(keyword, count=1, size=IMAGE_REQUIREMENTS["kb"]["size"])
        if images:
            save_path = MEDIA_DIR / f"kb_{i}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
    
    # 下载功能图标
    print("\n5. 下载功能图标 (icon_601-610)...")
    keywords = IMAGE_REQUIREMENTS["icon"]["keywords"]
    for i in range(601, 611):
        keyword = keywords[(i - 601) % len(keywords)]
        images = search_pixabay_images(keyword, count=1, size=IMAGE_REQUIREMENTS["icon"]["size"])
        if images:
            save_path = MEDIA_DIR / f"icon_{i}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
    
    # 下载应用Logo
    print("\n6. 下载应用Logo (logo_999)...")
    keywords = IMAGE_REQUIREMENTS["logo"]["keywords"]
    images = search_pixabay_images(keywords[0], count=1, size=IMAGE_REQUIREMENTS["logo"]["size"])
    if images:
        save_path = MEDIA_DIR / "logo_999.jpg"
        if download_image(images[0], save_path):
            downloaded += 1
        else:
            failed += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"下载完成!")
    print(f"成功: {downloaded} 张")
    print(f"失败: {failed} 张")
    print(f"保存目录: {MEDIA_DIR.absolute()}")

if __name__ == "__main__":
    # 检查requests库
    try:
        import requests
    except ImportError:
        print("错误: 需要安装 requests 库")
        print("请运行: pip install requests")
        exit(1)
    
    download_all_images()


