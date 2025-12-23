#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
从网上搜索并下载与主题相关的真实图片
使用多个免费图片源，想尽一切办法下载
"""

import requests
import json
from pathlib import Path
import time
import random
from urllib.parse import quote
import sys

# 设置UTF-8编码
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 根据内容索引映射到主题关键词（英文关键词用于搜索）
CONTENT_THEMES = {
    1: "lifestyle daily life",  # 生活
    2: "lifestyle daily life",
    3: "emotion feeling relationship",  # 情感
    4: "emotion feeling relationship",
    5: "emotion feeling relationship",
    6: "artificial intelligence AI technology",  # AI/科技
    7: "cybersecurity security protection",  # 安全
    8: "cybersecurity security protection",
    9: "electric car battery energy",  # 能源
    10: "electric car battery energy",
    11: "electric car battery energy",
    12: "recommendation algorithm",  # 推荐
    13: "natural language processing NLP",  # NLP
    14: "natural language processing NLP",
    15: "natural language processing NLP",
    16: "programming coding computer",  # 编程
    17: "medical healthcare doctor",  # 医疗
    18: "medical healthcare doctor",
    19: "quantum computing physics",  # 量子
    20: "quantum computing physics",
    21: "quantum computing physics",
    22: "autonomous driving car",  # 自动驾驶
    23: "education learning school",  # 教育
    24: "education learning school",
    25: "finance business money",  # 金融
    26: "finance business money",
    27: "finance business money",
    28: "environment climate nature",  # 环境
    29: "space exploration astronomy",  # 太空
    30: "space exploration astronomy",
    31: "robotics automation robot",  # 机器人
    32: "robotics automation robot",
    33: "robotics automation robot",
    34: "blockchain cryptocurrency",  # 区块链
    35: "virtual reality VR",  # VR
    36: "virtual reality VR",
    37: "biotechnology genetics science",  # 生物技术
    38: "biotechnology genetics science",
    39: "biotechnology genetics science",
    40: "smart city urban technology",  # 智慧城市
}

AVATAR_KEYWORDS = [
    "portrait person",
    "professional headshot",
    "business person",
    "smiling person",
]

THUMB_THEMES = {
    701: "technology innovation",
    702: "programming coding",
    703: "medical healthcare",
    704: "cybersecurity security",
    801: "lifestyle daily",
    802: "emotion feeling",
    803: "energy battery",
    804: "quantum computing",
    805: "autonomous driving",
}

KB_THEMES = {
    401: "knowledge education",
    402: "technology science",
    403: "research innovation",
}

def download_from_unsplash_source(keyword, width, height, save_path):
    """方法1: Unsplash Source API（无需API key，最简单）"""
    try:
        url = f"https://source.unsplash.com/{width}x{height}/?{quote(keyword)}"
        response = requests.get(url, timeout=15, allow_redirects=True, stream=True)
        if response.status_code == 200:
            content = response.content
            if len(content) > 5000:  # 确保不是错误页面
                with open(save_path, 'wb') as f:
                    f.write(content)
                return True
    except:
        pass
    return False

def download_from_lorem_picsum(keyword, width, height, save_path):
    """方法2: Lorem Picsum（随机图片，但稳定）"""
    try:
        # 使用关键词的hash作为seed，确保同一关键词得到相同图片
        seed = hash(keyword) % 1000
        url = f"https://picsum.photos/seed/{seed}/{width}/{height}"
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            with open(save_path, 'wb') as f:
                f.write(response.content)
            return True
    except:
        pass
    return False

def download_from_placeholder(keyword, width, height, save_path):
    """方法3: Placeholder.com（备用方案）"""
    try:
        # 使用关键词生成颜色
        color_hash = hash(keyword) % 0xFFFFFF
        url = f"https://via.placeholder.com/{width}x{height}/{color_hash:06x}/ffffff?text={quote(keyword[:20])}"
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            with open(save_path, 'wb') as f:
                f.write(response.content)
            return True
    except:
        pass
    return False

def download_from_dummyimage(keyword, width, height, save_path):
    """方法4: DummyImage（备用方案）"""
    try:
        color_hash = hash(keyword) % 0xFFFFFF
        url = f"https://dummyimage.com/{width}x{height}/{color_hash:06x}/ffffff.png&text={quote(keyword[:15])}"
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            with open(save_path, 'wb') as f:
                f.write(response.content)
            return True
    except:
        pass
    return False

def convert_to_png(save_path):
    """将图片转换为PNG格式"""
    try:
        from PIL import Image
        img = Image.open(save_path)
        png_path = save_path.with_suffix('.png')
        if img.mode == 'RGBA':
            img.save(png_path, 'PNG')
        else:
            img.convert('RGB').save(png_path, 'PNG')
        if save_path.suffix != '.png' and save_path.exists():
            save_path.unlink()
        return True
    except:
        # 如果转换失败，尝试重命名
        try:
            if save_path.suffix != '.png':
                png_path = save_path.with_suffix('.png')
                save_path.rename(png_path)
            return True
        except:
            return False

def download_image(keyword, width, height, save_path):
    """尝试多个方法下载图片"""
    methods = [
        ("Unsplash Source", download_from_unsplash_source),
        ("Lorem Picsum", download_from_lorem_picsum),
        ("Placeholder", download_from_placeholder),
        ("DummyImage", download_from_dummyimage),
    ]
    
    for method_name, method_func in methods:
        try:
            if method_func(keyword, width, height, save_path):
                # 转换为PNG
                if convert_to_png(save_path):
                    return True
        except Exception as e:
            continue
    
    return False

def download_all_images():
    """下载所有图片"""
    print("开始下载与主题相关的图片...")
    print("=" * 60)
    
    generated = 0
    failed = 0
    
    # 1. 内容图片
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        keyword = CONTENT_THEMES.get(i, "technology")
        save_path = MEDIA_DIR / f"content_{i}.png"
        print(f"  [{i}/40] {keyword[:30]}")
        if download_image(keyword, 400, 300, save_path):
            generated += 1
            print(f"    OK")
        else:
            failed += 1
            print(f"    FAIL")
        time.sleep(0.3)
    
    # 2. 头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
                  111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                  201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for idx, avatar_id in enumerate(avatar_ids):
        keyword = random.choice(AVATAR_KEYWORDS) + f" {avatar_id}"
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.png"
        print(f"  [{idx+1}/{len(avatar_ids)}] avatar_{avatar_id}")
        if download_image(keyword, 120, 120, save_path):
            generated += 1
            print(f"    OK")
        else:
            failed += 1
            print(f"    FAIL")
        time.sleep(0.3)
    
    # 3. 缩略图
    print("\n3. 下载缩略图...")
    for thumb_id, keyword in THUMB_THEMES.items():
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.png"
        print(f"  thumb_{thumb_id}: {keyword}")
        if download_image(keyword, 240, 160, save_path):
            generated += 1
            print(f"    OK")
        else:
            failed += 1
            print(f"    FAIL")
        time.sleep(0.3)
    
    # 4. 知识库Logo
    print("\n4. 下载知识库Logo...")
    for kb_id, keyword in KB_THEMES.items():
        save_path = MEDIA_DIR / f"kb_{kb_id}.png"
        print(f"  kb_{kb_id}: {keyword}")
        if download_image(keyword, 120, 120, save_path):
            generated += 1
            print(f"    OK")
        else:
            failed += 1
            print(f"    FAIL")
        time.sleep(0.3)
    
    # 5. 功能图标
    print("\n5. 下载功能图标...")
    icon_keywords = ["icon symbol", "simple icon", "minimal icon"]
    for i in range(601, 611):
        keyword = random.choice(icon_keywords) + f" {i}"
        save_path = MEDIA_DIR / f"icon_{i}.png"
        print(f"  icon_{i}")
        if download_image(keyword, 80, 80, save_path):
            generated += 1
            print(f"    OK")
        else:
            failed += 1
            print(f"    FAIL")
        time.sleep(0.3)
    
    # 6. 应用Logo
    print("\n6. 下载应用Logo...")
    save_path = MEDIA_DIR / "logo_999.png"
    if download_image("logo brand app", 64, 64, save_path):
        generated += 1
        print(f"    OK")
    else:
        failed += 1
        print(f"    FAIL")
    
    print("\n" + "=" * 60)
    print(f"下载完成! 成功: {generated}, 失败: {failed}")
    print(f"目录: {MEDIA_DIR.absolute()}")

if __name__ == "__main__":
    download_all_images()


