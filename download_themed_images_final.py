#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从网上搜索并下载与主题相关的真实图片
使用多个免费图片API：Unsplash、Pexels、Pixabay
"""

import requests
import json
from pathlib import Path
import time
import random
from urllib.parse import quote

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 根据内容索引映射到主题关键词
CONTENT_THEMES = {
    # 内容图片 1-40 对应的主题
    1: "life lifestyle",  # 生活
    2: "life lifestyle",
    3: "emotion feeling",  # 情感
    4: "emotion feeling",
    5: "emotion feeling",
    6: "artificial intelligence technology",  # AI/科技
    7: "cybersecurity security",  # 安全
    8: "cybersecurity security",
    9: "electric car battery energy",  # 能源
    10: "electric car battery energy",
    11: "electric car battery energy",
    12: "recommendation algorithm",  # 推荐
    13: "natural language processing",  # NLP
    14: "natural language processing",
    15: "natural language processing",
    16: "programming coding",  # 编程
    17: "medical healthcare",  # 医疗
    18: "medical healthcare",
    19: "quantum computing",  # 量子
    20: "quantum computing",
    21: "quantum computing",
    22: "autonomous driving car",  # 自动驾驶
    23: "education learning",  # 教育
    24: "education learning",
    25: "finance business",  # 金融
    26: "finance business",
    27: "finance business",
    28: "environment climate",  # 环境
    29: "space exploration",  # 太空
    30: "space exploration",
    31: "robotics automation",  # 机器人
    32: "robotics automation",
    33: "robotics automation",
    34: "blockchain cryptocurrency",  # 区块链
    35: "virtual reality VR",  # VR
    36: "virtual reality VR",
    37: "biotechnology genetics",  # 生物技术
    38: "biotechnology genetics",
    39: "biotechnology genetics",
    40: "smart city urban",  # 智慧城市
}

# 头像主题（使用通用人物头像关键词）
AVATAR_KEYWORDS = [
    "portrait person",
    "professional headshot",
    "business person",
    "smiling person",
    "young professional",
    "casual portrait",
]

# 缩略图主题
THUMB_THEMES = {
    701: "technology innovation",
    702: "programming coding",
    703: "medical healthcare",
    704: "cybersecurity security",
    801: "life lifestyle",
    802: "emotion feeling",
    803: "energy battery",
    804: "quantum computing",
    805: "autonomous driving",
}

# 知识库Logo主题
KB_THEMES = {
    401: "knowledge education",
    402: "technology science",
    403: "research innovation",
}

# 功能图标主题（使用通用图标关键词）
ICON_KEYWORDS = [
    "icon symbol",
    "simple icon",
    "minimal icon",
    "flat icon",
]

def download_from_unsplash(keyword, width, height, save_path, max_retries=3):
    """从Unsplash下载图片（无需API key）"""
    for attempt in range(max_retries):
        try:
            # Unsplash Source API（无需API key）
            url = f"https://source.unsplash.com/{width}x{height}/?{quote(keyword)}"
            response = requests.get(url, timeout=10, allow_redirects=True)
            if response.status_code == 200 and len(response.content) > 1000:
                with open(save_path, 'wb') as f:
                    f.write(response.content)
                # 转换为PNG
                try:
                    from PIL import Image
                    img = Image.open(save_path)
                    png_path = save_path.with_suffix('.png')
                    img.convert('RGB').save(png_path, 'PNG')
                    if save_path.suffix != '.png':
                        save_path.unlink()  # 删除原文件
                    return True
                except:
                    # 如果转换失败，直接使用原文件
                    return True
        except Exception as e:
            if attempt < max_retries - 1:
                time.sleep(1)
            continue
    return False

def download_from_pexels(keyword, width, height, save_path, max_retries=3):
    """从Pexels下载图片（使用免费API）"""
    # Pexels API key（免费注册）
    API_KEY = "563492ad6f91700001000001c8a5b5e5e5e5e5e5e5e5e5e5e5e5e5e5"  # 示例key，需要替换
    for attempt in range(max_retries):
        try:
            url = f"https://api.pexels.com/v1/search?query={quote(keyword)}&per_page=1&orientation=landscape"
            headers = {"Authorization": API_KEY}
            response = requests.get(url, headers=headers, timeout=10)
            if response.status_code == 200:
                data = response.json()
                if data.get('photos') and len(data['photos']) > 0:
                    photo_url = data['photos'][0]['src']['large']
                    img_response = requests.get(photo_url, timeout=10)
                    if img_response.status_code == 200:
                        with open(save_path, 'wb') as f:
                            f.write(img_response.content)
                        # 转换为PNG
                        try:
                            from PIL import Image
                            img = Image.open(save_path)
                            img = img.resize((width, height), Image.Resampling.LANCZOS)
                            png_path = save_path.with_suffix('.png')
                            img.convert('RGB').save(png_path, 'PNG')
                            if save_path.suffix != '.png':
                                save_path.unlink()
                            return True
                        except:
                            return True
        except Exception as e:
            if attempt < max_retries - 1:
                time.sleep(1)
            continue
    return False

def download_from_pixabay(keyword, width, height, save_path, max_retries=3):
    """从Pixabay下载图片（使用免费API）"""
    # Pixabay API key（免费注册）
    API_KEY = "12345678-1234567890abcdef1234567890abcdef"  # 示例key，需要替换
    for attempt in range(max_retries):
        try:
            url = f"https://pixabay.com/api/?key={API_KEY}&q={quote(keyword)}&image_type=photo&per_page=3&safesearch=true"
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                data = response.json()
                if data.get('hits') and len(data['hits']) > 0:
                    # 随机选择一个图片
                    hit = random.choice(data['hits'])
                    img_url = hit['webformatURL']  # 或使用 'largeImageURL'
                    img_response = requests.get(img_url, timeout=10)
                    if img_response.status_code == 200:
                        with open(save_path, 'wb') as f:
                            f.write(img_response.content)
                        # 转换为PNG
                        try:
                            from PIL import Image
                            img = Image.open(save_path)
                            img = img.resize((width, height), Image.Resampling.LANCZOS)
                            png_path = save_path.with_suffix('.png')
                            img.convert('RGB').save(png_path, 'PNG')
                            if save_path.suffix != '.png':
                                save_path.unlink()
                            return True
                        except:
                            return True
        except Exception as e:
            if attempt < max_retries - 1:
                time.sleep(1)
            continue
    return False

def download_image_multi_source(keyword, width, height, save_path):
    """尝试多个来源下载图片"""
    # 方法1: Unsplash Source（最简单，无需API key）
    print(f"  尝试 Unsplash: {keyword}")
    if download_from_unsplash(keyword, width, height, save_path):
        return True
    
    # 方法2: Pexels（需要API key，但质量好）
    print(f"  尝试 Pexels: {keyword}")
    if download_from_pexels(keyword, width, height, save_path):
        return True
    
    # 方法3: Pixabay（需要API key）
    print(f"  尝试 Pixabay: {keyword}")
    if download_from_pixabay(keyword, width, height, save_path):
        return True
    
    return False

def download_all_themed_images():
    """下载所有主题相关的图片"""
    print("开始下载与主题相关的真实图片...")
    print("=" * 60)
    
    generated = 0
    failed = 0
    
    # 1. 下载内容图片 (1-40)
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        keyword = CONTENT_THEMES.get(i, "technology")
        save_path = MEDIA_DIR / f"content_{i}.png"
        print(f"  [{i}/40] {keyword}")
        if download_image_multi_source(keyword, 400, 300, save_path):
            generated += 1
            print(f"    ✓ 成功")
        else:
            failed += 1
            print(f"    ✗ 失败")
        time.sleep(0.5)  # 避免请求过快
    
    # 2. 下载头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
                  111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                  201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for idx, avatar_id in enumerate(avatar_ids):
        keyword = random.choice(AVATAR_KEYWORDS)
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.png"
        print(f"  [{idx+1}/{len(avatar_ids)}] {keyword}")
        if download_image_multi_source(keyword, 120, 120, save_path):
            generated += 1
            print(f"    ✓ 成功")
        else:
            failed += 1
            print(f"    ✗ 失败")
        time.sleep(0.5)
    
    # 3. 下载缩略图
    print("\n3. 下载缩略图...")
    for thumb_id, keyword in THUMB_THEMES.items():
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.png"
        print(f"  thumb_{thumb_id}: {keyword}")
        if download_image_multi_source(keyword, 240, 160, save_path):
            generated += 1
            print(f"    ✓ 成功")
        else:
            failed += 1
            print(f"    ✗ 失败")
        time.sleep(0.5)
    
    # 4. 下载知识库Logo
    print("\n4. 下载知识库Logo...")
    for kb_id, keyword in KB_THEMES.items():
        save_path = MEDIA_DIR / f"kb_{kb_id}.png"
        print(f"  kb_{kb_id}: {keyword}")
        if download_image_multi_source(keyword, 120, 120, save_path):
            generated += 1
            print(f"    ✓ 成功")
        else:
            failed += 1
            print(f"    ✗ 失败")
        time.sleep(0.5)
    
    # 5. 下载功能图标
    print("\n5. 下载功能图标...")
    for i in range(601, 611):
        keyword = random.choice(ICON_KEYWORDS)
        save_path = MEDIA_DIR / f"icon_{i}.png"
        print(f"  icon_{i}: {keyword}")
        if download_image_multi_source(keyword, 80, 80, save_path):
            generated += 1
            print(f"    ✓ 成功")
        else:
            failed += 1
            print(f"    ✗ 失败")
        time.sleep(0.5)
    
    # 6. 下载应用Logo
    print("\n6. 下载应用Logo...")
    save_path = MEDIA_DIR / "logo_999.png"
    if download_image_multi_source("logo brand", 64, 64, save_path):
        generated += 1
        print(f"    ✓ 成功")
    else:
        failed += 1
        print(f"    ✗ 失败")
    
    print("\n" + "=" * 60)
    print(f"下载完成! 成功: {generated}, 失败: {failed}")
    print(f"目录: {MEDIA_DIR.absolute()}")
    print("\n所有图片已下载为与主题相关的真实图片！")

if __name__ == "__main__":
    download_all_themed_images()


