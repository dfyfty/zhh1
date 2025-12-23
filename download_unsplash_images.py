#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
使用Unsplash Source API下载主题相关图片（无需API key）
根据内容主题生成合适的图片
"""

import requests
from pathlib import Path
import time

# 图片保存目录
MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# Unsplash Source API - 无需API key
UNSPLASH_SOURCE = "https://source.unsplash.com"

# 内容主题与图片ID映射（使用Unsplash的随机图片功能）
CONTENT_THEMES = {
    # 内容图片 (1-40) - 使用不同的主题关键词
    1: "400x300/?rabbit,cute,animal",
    2: "400x300/?rabbit,cute,animal",
    3: "400x300/?man,youth,portrait",
    4: "400x300/?man,youth,portrait",
    5: "400x300/?man,youth,portrait",
    6: "400x300/?ai,technology,robot",
    7: "400x300/?security,lock,protection",
    8: "400x300/?security,lock,protection",
    9: "400x300/?battery,energy,electric",
    10: "400x300/?battery,energy,electric",
    11: "400x300/?battery,energy,electric",
    12: "400x300/?network,graph,data",
    13: "400x300/?ai,brain,thinking",
    14: "400x300/?ai,brain,thinking",
    15: "400x300/?ai,brain,thinking",
    16: "400x300/?programming,code,computer",
    17: "400x300/?medical,doctor,healthcare",
    18: "400x300/?medical,doctor,healthcare",
    19: "400x300/?blockchain,crypto,finance",
    20: "400x300/?blockchain,crypto,finance",
    21: "400x300/?blockchain,crypto,finance",
    22: "400x300/?5g,network,iot",
    23: "400x300/?quantum,computer,science",
    24: "400x300/?quantum,computer,science",
    25: "400x300/?vr,virtual,reality",
    26: "400x300/?vr,virtual,reality",
    27: "400x300/?vr,virtual,reality",
    28: "400x300/?autonomous,car,vehicle",
    29: "400x300/?industry,factory,automation",
    30: "400x300/?industry,factory,automation",
    31: "400x300/?web3,decentralized,crypto",
    32: "400x300/?web3,decentralized,crypto",
    33: "400x300/?web3,decentralized,crypto",
    34: "400x300/?design,creative,art",
    35: "400x300/?cloud,server,computing",
    36: "400x300/?cloud,server,computing",
    37: "400x300/?privacy,security,data",
    38: "400x300/?privacy,security,data",
    39: "400x300/?privacy,security,data",
    40: "400x300/?code,development,software",
}

# 头像图片 - 使用人物肖像
AVATAR_THEMES = {
    101: "120x120/?portrait,woman,face",
    102: "120x120/?portrait,man,face",
    103: "120x120/?portrait,person,professional",
    104: "120x120/?portrait,woman,business",
    105: "120x120/?portrait,man,business",
    106: "120x120/?portrait,person,smile",
    107: "120x120/?portrait,woman,smile",
    108: "120x120/?portrait,man,smile",
    109: "120x120/?portrait,person,young",
    110: "120x120/?portrait,woman,young",
    111: "120x120/?portrait,man,young",
    112: "120x120/?portrait,person,adult",
    113: "120x120/?portrait,woman,adult",
    114: "120x120/?portrait,man,adult",
    115: "120x120/?portrait,person,mature",
    116: "120x120/?portrait,woman,mature",
    117: "120x120/?portrait,man,mature",
    118: "120x120/?portrait,person,casual",
    119: "120x120/?portrait,woman,casual",
    120: "120x120/?portrait,man,casual",
    201: "120x120/?avatar,system,notification",
    202: "120x120/?avatar,assistant,help",
    203: "120x120/?avatar,update,product",
    301: "120x120/?portrait,user,comment",
    302: "120x120/?portrait,user,comment",
    303: "120x120/?portrait,user,comment",
    501: "120x120/?portrait,profile,user",
    901: "120x120/?portrait,person,follow",
    902: "120x120/?portrait,person,follow",
    903: "120x120/?portrait,person,follow",
    904: "120x120/?portrait,person,follow",
    998: "120x120/?avatar,user,default",
    999: "64x64/?logo,brand,symbol",
    1001: "120x120/?portrait,profile,user",
}

def download_from_unsplash(size_query, save_path):
    """从Unsplash Source下载图片"""
    try:
        url = f"{UNSPLASH_SOURCE}/{size_query}"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        
        # Unsplash Source会重定向到实际图片URL
        response = requests.get(url, headers=headers, timeout=30, allow_redirects=True, stream=True)
        response.raise_for_status()
        
        with open(save_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"✓ 下载成功: {save_path.name}")
        return True
    except Exception as e:
        print(f"✗ 下载失败 {save_path.name}: {e}")
        return False

def download_all_images():
    """下载所有图片"""
    print("开始从Unsplash下载主题相关图片...")
    print("=" * 60)
    
    downloaded = 0
    failed = 0
    
    # 下载内容图片
    print("\n1. 下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        query = CONTENT_THEMES.get(i, "400x300/?nature,abstract")
        save_path = MEDIA_DIR / f"content_{i}.jpg"
        if download_from_unsplash(query, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.3)  # 避免请求过快
    
    # 下载头像图片
    print("\n2. 下载头像图片...")
    avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for avatar_id in avatar_ids:
        query = AVATAR_THEMES.get(avatar_id, "120x120/?portrait,person")
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.jpg"
        if download_from_unsplash(query, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.3)
    
    # 下载缩略图
    print("\n3. 下载缩略图...")
    thumb_ids = list(range(701, 705)) + list(range(801, 806))
    thumb_themes = ["240x160/?technology", "240x160/?nature", "240x160/?business", 
                    "240x160/?people", "240x160/?science", "240x160/?innovation", 
                    "240x160/?digital", "240x160/?modern", "240x160/?creative"]
    for idx, thumb_id in enumerate(thumb_ids):
        query = thumb_themes[idx % len(thumb_themes)]
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.jpg"
        if download_from_unsplash(query, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.3)
    
    # 下载知识库Logo
    print("\n4. 下载知识库Logo...")
    kb_themes = ["120x120/?technology", "120x120/?education", "120x120/?knowledge"]
    for i in range(401, 404):
        query = kb_themes[i - 401]
        save_path = MEDIA_DIR / f"kb_{i}.jpg"
        if download_from_unsplash(query, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.3)
    
    # 下载功能图标
    print("\n5. 下载功能图标...")
    icon_themes = ["80x80/?book", "80x80/?course", "80x80/?wallet", "80x80/?service",
                   "80x80/?vip", "80x80/?gift", "80x80/?activity", "80x80/?feedback",
                   "80x80/?settings", "80x80/?help"]
    for i in range(601, 611):
        query = icon_themes[i - 601]
        save_path = MEDIA_DIR / f"icon_{i}.jpg"
        if download_from_unsplash(query, save_path):
            downloaded += 1
        else:
            failed += 1
        time.sleep(0.3)
    
    # 下载应用Logo
    print("\n6. 下载应用Logo...")
    save_path = MEDIA_DIR / "logo_999.jpg"
    if download_from_unsplash("64x64/?logo,brand,symbol", save_path):
        downloaded += 1
    else:
        failed += 1
    
    print("\n" + "=" * 60)
    print(f"下载完成!")
    print(f"成功: {downloaded} 张")
    print(f"失败: {failed} 张")
    print(f"保存目录: {MEDIA_DIR.absolute()}")

if __name__ == "__main__":
    try:
        import requests
    except ImportError:
        print("错误: 需要安装 requests 库")
        print("请运行: pip install requests")
        exit(1)
    
    download_all_images()


