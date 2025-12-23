#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从Pixabay下载与内容主题相关的图片
根据内容标题和主题搜索合适的图片
"""

import requests
import json
from pathlib import Path
import time

# Pixabay API配置
PIXABAY_API_KEY = "9656065-a4094594c34c9d8b680cc1a64"  # 示例API key，建议替换
PIXABAY_API_URL = "https://pixabay.com/api/"

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 内容主题与搜索关键词映射
CONTENT_THEMES = {
    # 内容图片 (1-40)
    1: {"keywords": ["rabbit", "cute", "animal"], "title": "脸与身材不符"},
    2: {"keywords": ["rabbit", "cute", "animal"], "title": "脸与身材不符"},
    3: {"keywords": ["man", "youth", "boy"], "title": "男人至死都是少年"},
    4: {"keywords": ["man", "youth", "boy"], "title": "男人至死都是少年"},
    5: {"keywords": ["man", "youth", "boy"], "title": "男人至死都是少年"},
    6: {"keywords": ["ai", "technology", "robot"], "title": "大模型行业"},
    7: {"keywords": ["security", "lock", "protection"], "title": "数字安全"},
    8: {"keywords": ["security", "lock", "protection"], "title": "数字安全"},
    9: {"keywords": ["battery", "energy", "electric"], "title": "新能源电池"},
    10: {"keywords": ["battery", "energy", "electric"], "title": "新能源电池"},
    11: {"keywords": ["battery", "energy", "electric"], "title": "新能源电池"},
    12: {"keywords": ["knowledge", "graph", "network"], "title": "知识图谱"},
    13: {"keywords": ["ai", "brain", "thinking"], "title": "跨学科提问"},
    14: {"keywords": ["ai", "brain", "thinking"], "title": "跨学科提问"},
    15: {"keywords": ["ai", "brain", "thinking"], "title": "跨学科提问"},
    16: {"keywords": ["programming", "code", "computer"], "title": "编程语言"},
    17: {"keywords": ["medical", "doctor", "healthcare"], "title": "医疗诊断"},
    18: {"keywords": ["medical", "doctor", "healthcare"], "title": "医疗诊断"},
    19: {"keywords": ["blockchain", "crypto", "finance"], "title": "区块链金融"},
    20: {"keywords": ["blockchain", "crypto", "finance"], "title": "区块链金融"},
    21: {"keywords": ["blockchain", "crypto", "finance"], "title": "区块链金融"},
    22: {"keywords": ["5g", "network", "iot"], "title": "5G物联网"},
    23: {"keywords": ["quantum", "computer", "science"], "title": "量子计算"},
    24: {"keywords": ["quantum", "computer", "science"], "title": "量子计算"},
    25: {"keywords": ["vr", "virtual", "reality"], "title": "虚拟现实"},
    26: {"keywords": ["vr", "virtual", "reality"], "title": "虚拟现实"},
    27: {"keywords": ["vr", "virtual", "reality"], "title": "虚拟现实"},
    28: {"keywords": ["autonomous", "car", "vehicle"], "title": "自动驾驶"},
    29: {"keywords": ["industry", "factory", "automation"], "title": "工业4.0"},
    30: {"keywords": ["industry", "factory", "automation"], "title": "工业4.0"},
    31: {"keywords": ["web3", "decentralized", "crypto"], "title": "Web3.0"},
    32: {"keywords": ["web3", "decentralized", "crypto"], "title": "Web3.0"},
    33: {"keywords": ["web3", "decentralized", "crypto"], "title": "Web3.0"},
    34: {"keywords": ["design", "creative", "art"], "title": "创意设计"},
    35: {"keywords": ["cloud", "server", "computing"], "title": "云计算"},
    36: {"keywords": ["cloud", "server", "computing"], "title": "云计算"},
    37: {"keywords": ["privacy", "security", "data"], "title": "数据隐私"},
    38: {"keywords": ["privacy", "security", "data"], "title": "数据隐私"},
    39: {"keywords": ["privacy", "security", "data"], "title": "数据隐私"},
    40: {"keywords": ["code", "development", "software"], "title": "低代码平台"},
}

# 头像图片主题
AVATAR_THEMES = {
    # 使用多样化的人物头像关键词
    101: ["portrait", "woman", "face"],
    102: ["portrait", "man", "face"],
    103: ["portrait", "person", "professional"],
    104: ["portrait", "woman", "business"],
    105: ["portrait", "man", "business"],
    106: ["portrait", "person", "smile"],
    107: ["portrait", "woman", "smile"],
    108: ["portrait", "man", "smile"],
    109: ["portrait", "person", "young"],
    110: ["portrait", "woman", "young"],
    111: ["portrait", "man", "young"],
    112: ["portrait", "person", "adult"],
    113: ["portrait", "woman", "adult"],
    114: ["portrait", "man", "adult"],
    115: ["portrait", "person", "mature"],
    116: ["portrait", "woman", "mature"],
    117: ["portrait", "man", "mature"],
    118: ["portrait", "person", "casual"],
    119: ["portrait", "woman", "casual"],
    120: ["portrait", "man", "casual"],
    201: ["avatar", "system", "notification"],
    202: ["avatar", "assistant", "help"],
    203: ["avatar", "update", "product"],
    301: ["portrait", "user", "comment"],
    302: ["portrait", "user", "comment"],
    303: ["portrait", "user", "comment"],
    501: ["portrait", "profile", "user"],
    901: ["portrait", "person", "follow"],
    902: ["portrait", "person", "follow"],
    903: ["portrait", "person", "follow"],
    904: ["portrait", "person", "follow"],
    998: ["avatar", "user", "default"],
    999: ["logo", "brand", "icon"],
    1001: ["portrait", "profile", "user"],
}

def search_pixabay_images(keyword, count=1, size="medium"):
    """从Pixabay搜索图片"""
    try:
        params = {
            "key": PIXABAY_API_KEY,
            "q": keyword,
            "image_type": "photo",
            "orientation": "horizontal",
            "safesearch": "true",
            "per_page": min(count, 200)
        }
        
        response = requests.get(PIXABAY_API_URL, params=params, timeout=30)
        response.raise_for_status()
        
        data = response.json()
        if "hits" in data and len(data["hits"]) > 0:
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

def download_image(url, save_path):
    """下载图片并保存"""
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

def download_all_themed_images():
    """下载所有主题相关的图片"""
    print("开始下载主题相关图片...")
    print("=" * 60)
    
    downloaded = 0
    failed = 0
    
    # 下载内容图片
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        theme = CONTENT_THEMES.get(i, {"keywords": ["nature", "abstract"]})
        keywords = theme["keywords"]
        keyword = " ".join(keywords[:2])  # 使用前两个关键词
        
        images = search_pixabay_images(keyword, count=1, size="medium")
        if images:
            save_path = MEDIA_DIR / f"content_{i}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
        
        time.sleep(0.2)  # 避免请求过快
    
    # 下载头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        keywords = AVATAR_THEMES.get(avatar_id, ["portrait", "person"])
        keyword = " ".join(keywords[:2])
        
        images = search_pixabay_images(keyword, count=1, size="small")
        if images:
            save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
        
        time.sleep(0.2)
    
    # 下载缩略图（使用与内容相关的主题）
    print("\n3. 下载缩略图...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    thumb_themes = ["technology", "nature", "business", "people", "science", "innovation", "digital", "modern", "creative"]
    for idx, thumb_id in enumerate(thumb_ids):
        keyword = thumb_themes[idx % len(thumb_themes)]
        images = search_pixabay_images(keyword, count=1, size="small")
        if images:
            save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载知识库Logo
    print("\n4. 下载知识库Logo...")
    kb_keywords = ["technology", "education", "knowledge"]
    for i in range(401, 404):
        keyword = kb_keywords[i - 401]
        images = search_pixabay_images(keyword, count=1, size="small")
        if images:
            save_path = MEDIA_DIR / f"kb_{i}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载功能图标（使用图标相关关键词）
    print("\n5. 下载功能图标...")
    icon_keywords = ["book", "course", "wallet", "service", "vip", "gift", "activity", "feedback", "settings", "help"]
    for i in range(601, 611):
        keyword = icon_keywords[i - 601]
        images = search_pixabay_images(keyword, count=1, size="small")
        if images:
            save_path = MEDIA_DIR / f"icon_{i}.jpg"
            if download_image(images[0], save_path):
                downloaded += 1
            else:
                failed += 1
        else:
            failed += 1
        time.sleep(0.2)
    
    # 下载应用Logo
    print("\n6. 下载应用Logo...")
    images = search_pixabay_images("logo brand symbol", count=1, size="small")
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
    print("\n注意: 如果某些图片下载失败，可以手动从Pixabay下载并替换")

if __name__ == "__main__":
    try:
        import requests
    except ImportError:
        print("错误: 需要安装 requests 库")
        print("请运行: pip install requests")
        exit(1)
    
    download_all_themed_images()


