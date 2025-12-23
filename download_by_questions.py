#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
根据问题标题搜索并下载对应的图片
"""

import requests
from pathlib import Path
import time
import hashlib
import sys

# 设置UTF-8编码
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

MEDIA_DIR = Path("entry/src/main/resources/base/media")
MEDIA_DIR.mkdir(parents=True, exist_ok=True)

# 根据代码中的问题标题映射到图片索引
QUESTIONS = {
    # content_1, content_2
    1: "脸与身材不符是种怎样的体验？",
    2: "脸与身材不符是种怎样的体验？",
    # content_3, content_4, content_5
    3: "为什么说男人至死都是少年？",
    4: "为什么说男人至死都是少年？",
    5: "为什么说男人至死都是少年？",
    # content_6
    6: "大模型会让哪些行业率先受益？",
    # content_7, content_8
    7: "个人如何做好数字安全防护？",
    8: "个人如何做好数字安全防护？",
    # content_9, content_10, content_11
    9: "新能源车电池未来五年的突破点是什么？",
    10: "新能源车电池未来五年的突破点是什么？",
    11: "新能源车电池未来五年的突破点是什么？",
    # content_12
    12: "如何用知识图谱做内容推荐？",
    # content_13, content_14, content_15
    13: "跨学科提问时，让模型理解你的语境的技巧？",
    14: "跨学科提问时，让模型理解你的语境的技巧？",
    15: "跨学科提问时，让模型理解你的语境的技巧？",
    # content_16
    16: "如何快速掌握一门新的编程语言？",
    # content_17, content_18
    17: "深度学习在医疗诊断中的应用前景如何？",
    18: "深度学习在医疗诊断中的应用前景如何？",
    # content_19, content_20, content_21
    19: "区块链技术在金融领域的实际应用案例",
    20: "区块链技术在金融领域的实际应用案例",
    21: "区块链技术在金融领域的实际应用案例",
    # content_22
    22: "5G网络对物联网发展的推动作用",
    # content_23, content_24
    23: "量子计算距离商业化还有多远？",
    24: "量子计算距离商业化还有多远？",
    # content_25, content_26, content_27
    25: "元宇宙概念下的虚拟现实技术发展",
    26: "元宇宙概念下的虚拟现实技术发展",
    27: "元宇宙概念下的虚拟现实技术发展",
    # content_28
    28: "自动驾驶技术的安全性与可靠性探讨",
    # content_29, content_30
    29: "边缘计算在工业4.0中的关键作用",
    30: "边缘计算在工业4.0中的关键作用",
    # content_31, content_32, content_33
    31: "Web3.0时代的去中心化应用生态",
    32: "Web3.0时代的去中心化应用生态",
    33: "Web3.0时代的去中心化应用生态",
    # content_34
    34: "人工智能在创意设计领域的突破",
    # content_35, content_36
    35: "云计算成本优化的最佳实践",
    36: "云计算成本优化的最佳实践",
    # content_37, content_38, content_39
    37: "数据隐私保护的技术方案与法律框架",
    38: "数据隐私保护的技术方案与法律框架",
    39: "数据隐私保护的技术方案与法律框架",
    # content_40
    40: "低代码平台如何改变软件开发模式？",
}

# 将中文问题转换为英文搜索关键词
def question_to_keywords(question):
    """将中文问题转换为英文搜索关键词"""
    keyword_map = {
        "脸与身材不符": "lifestyle appearance",
        "男人至死都是少年": "emotion feeling",
        "大模型": "artificial intelligence AI",
        "数字安全防护": "cybersecurity security",
        "新能源车电池": "electric car battery energy",
        "知识图谱": "knowledge graph algorithm",
        "模型理解语境": "natural language processing NLP",
        "编程语言": "programming coding computer",
        "医疗诊断": "medical healthcare diagnosis",
        "区块链技术": "blockchain cryptocurrency",
        "5G网络": "5G network IoT",
        "量子计算": "quantum computing",
        "虚拟现实": "virtual reality VR",
        "自动驾驶": "autonomous driving car",
        "边缘计算": "edge computing",
        "Web3.0": "Web3 blockchain",
        "创意设计": "creative design AI",
        "云计算成本": "cloud computing cost",
        "数据隐私": "data privacy protection",
        "低代码平台": "low code platform development",
    }
    
    for key, value in keyword_map.items():
        if key in question:
            return value
    
    # 默认关键词
    return "technology innovation"

def download_from_unsplash(keyword, width, height, save_path):
    """从Unsplash下载图片"""
    try:
        url = f"https://source.unsplash.com/{width}x{height}/?{keyword.replace(' ', ',')}"
        response = requests.get(url, timeout=15, allow_redirects=True, stream=True)
        if response.status_code == 200:
            content = response.content
            if len(content) > 5000:
                with open(save_path, 'wb') as f:
                    f.write(content)
                return True
    except:
        pass
    return False

def download_from_picsum(keyword, width, height, save_path):
    """从Picsum下载图片（使用关键词hash作为seed）"""
    try:
        seed = abs(hash(keyword)) % 10000
        url = f"https://picsum.photos/seed/{seed}/{width}/{height}"
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            with open(save_path, 'wb') as f:
                f.write(response.content)
            return True
    except:
        pass
    return False

def convert_to_png(save_path):
    """转换为PNG格式"""
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
        try:
            if save_path.suffix != '.png':
                png_path = save_path.with_suffix('.png')
                save_path.rename(png_path)
            return True
        except:
            return False

def download_image(keyword, width, height, save_path):
    """下载图片"""
    # 方法1: Unsplash
    if download_from_unsplash(keyword, width, height, save_path):
        if convert_to_png(save_path):
            return True
    
    # 方法2: Picsum
    if download_from_picsum(keyword, width, height, save_path):
        if convert_to_png(save_path):
            return True
    
    return False

def download_all():
    """下载所有图片"""
    print("根据问题标题下载对应图片...")
    print("=" * 60)
    
    generated = 0
    failed = 0
    
    # 下载内容图片
    print("\n下载内容图片 (content_1 到 content_40)...")
    for i in range(1, 41):
        question = QUESTIONS.get(i, "")
        keyword = question_to_keywords(question)
        save_path = MEDIA_DIR / f"content_{i}.png"
        print(f"  [{i}/40] {question[:30]}")
        print(f"        关键词: {keyword}")
        if download_image(keyword, 400, 300, save_path):
            generated += 1
            print(f"        OK")
        else:
            failed += 1
            print(f"        FAIL")
        time.sleep(0.5)  # 避免请求过快
    
    # 下载头像（使用通用关键词）
    print("\n下载头像图片...")
    avatar_ids = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 
                  111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                  201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
    for idx, avatar_id in enumerate(avatar_ids):
        keyword = f"portrait person {avatar_id}"
        save_path = MEDIA_DIR / f"avatar_{avatar_id}.png"
        print(f"  [{idx+1}/{len(avatar_ids)}] avatar_{avatar_id}")
        if download_image(keyword, 120, 120, save_path):
            generated += 1
            print(f"        OK")
        else:
            failed += 1
            print(f"        FAIL")
        time.sleep(0.3)
    
    # 下载缩略图（根据对应的问题）
    print("\n下载缩略图...")
    thumb_mapping = {
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
    for thumb_id, keyword in thumb_mapping.items():
        save_path = MEDIA_DIR / f"thumb_{thumb_id}.png"
        print(f"  thumb_{thumb_id}: {keyword}")
        if download_image(keyword, 240, 160, save_path):
            generated += 1
            print(f"        OK")
        else:
            failed += 1
            print(f"        FAIL")
        time.sleep(0.3)
    
    # 下载知识库Logo
    print("\n下载知识库Logo...")
    kb_keywords = {
        401: "knowledge education",
        402: "technology science",
        403: "research innovation",
    }
    for kb_id, keyword in kb_keywords.items():
        save_path = MEDIA_DIR / f"kb_{kb_id}.png"
        print(f"  kb_{kb_id}: {keyword}")
        if download_image(keyword, 120, 120, save_path):
            generated += 1
            print(f"        OK")
        else:
            failed += 1
            print(f"        FAIL")
        time.sleep(0.3)
    
    # 下载功能图标
    print("\n下载功能图标...")
    for i in range(601, 611):
        keyword = f"icon symbol {i}"
        save_path = MEDIA_DIR / f"icon_{i}.png"
        print(f"  icon_{i}")
        if download_image(keyword, 80, 80, save_path):
            generated += 1
            print(f"        OK")
        else:
            failed += 1
            print(f"        FAIL")
        time.sleep(0.3)
    
    # 下载应用Logo
    print("\n下载应用Logo...")
    save_path = MEDIA_DIR / "logo_999.png"
    if download_image("logo brand app", 64, 64, save_path):
        generated += 1
        print(f"        OK")
    else:
        failed += 1
        print(f"        FAIL")
    
    print("\n" + "=" * 60)
    print(f"下载完成! 成功: {generated}, 失败: {failed}")
    print(f"目录: {MEDIA_DIR.absolute()}")

if __name__ == "__main__":
    download_all()

