#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量替换代码中的网络图片URL为本地资源引用
"""

import re
import os
from pathlib import Path

# 要处理的文件目录
PAGES_DIR = Path("entry/src/main/ets/pages")

def replace_urls_in_file(file_path):
    """替换文件中的图片URL"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changes = 0
        
        # 替换内容图片 (random=1 到 random=40)
        for i in range(1, 41):
            # 匹配各种尺寸的内容图片
            patterns = [
                (rf"'https://picsum\.photos/\d+/\d+\?random={i}'", f"$r('app.media.content_{i}')"),
                (rf'"https://picsum\.photos/\d+/\d+\?random={i}"', f'$r("app.media.content_{i}")'),
            ]
            for pattern, replacement in patterns:
                matches = re.findall(pattern, content)
                if matches:
                    content = re.sub(pattern, replacement, content)
                    changes += len(matches)
        
        # 替换头像图片
        avatar_ids = list(range(101, 121)) + [201, 202, 203, 301, 302, 303, 501, 901, 902, 903, 904, 998, 999, 1001]
        for avatar_id in avatar_ids:
            patterns = [
                (rf"'https://picsum\.photos/\d+/\d+\?random={avatar_id}'", f"$r('app.media.avatar_{avatar_id}')"),
                (rf'"https://picsum\.photos/\d+/\d+\?random={avatar_id}"', f'$r("app.media.avatar_{avatar_id}")'),
            ]
            for pattern, replacement in patterns:
                matches = re.findall(pattern, content)
                if matches:
                    content = re.sub(pattern, replacement, content)
                    changes += len(matches)
        
        # 替换缩略图
        thumb_ids = list(range(701, 705)) + list(range(801, 806))
        for thumb_id in thumb_ids:
            patterns = [
                (rf"'https://picsum\.photos/\d+/\d+\?random={thumb_id}'", f"$r('app.media.thumb_{thumb_id}')"),
                (rf'"https://picsum\.photos/\d+/\d+\?random={thumb_id}"', f'$r("app.media.thumb_{thumb_id}")'),
            ]
            for pattern, replacement in patterns:
                matches = re.findall(pattern, content)
                if matches:
                    content = re.sub(pattern, replacement, content)
                    changes += len(matches)
        
        # 替换知识库Logo
        for i in range(401, 404):
            patterns = [
                (rf"'https://picsum\.photos/\d+/\d+\?random={i}'", f"$r('app.media.kb_{i}')"),
                (rf'"https://picsum\.photos/\d+/\d+\?random={i}"', f'$r("app.media.kb_{i}")'),
            ]
            for pattern, replacement in patterns:
                matches = re.findall(pattern, content)
                if matches:
                    content = re.sub(pattern, replacement, content)
                    changes += len(matches)
        
        # 替换功能图标
        for i in range(601, 611):
            patterns = [
                (rf"'https://picsum\.photos/\d+/\d+\?random={i}'", f"$r('app.media.icon_{i}')"),
                (rf'"https://picsum\.photos/\d+/\d+\?random={i}"', f'$r("app.media.icon_{i}")'),
            ]
            for pattern, replacement in patterns:
                matches = re.findall(pattern, content)
                if matches:
                    content = re.sub(pattern, replacement, content)
                    changes += len(matches)
        
        # 替换应用Logo (random=999)
        patterns = [
            (r"'https://picsum\.photos/\d+/\d+\?random=999'", "$r('app.media.logo_999')"),
            (r'"https://picsum\.photos/\d+/\d+\?random=999"', '$r("app.media.logo_999")'),
        ]
        for pattern, replacement in patterns:
            matches = re.findall(pattern, content)
            if matches:
                content = re.sub(pattern, replacement, content)
                changes += len(matches)
        
        # 如果内容有变化，保存文件
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"[OK] {file_path.name}: 替换了 {changes} 处")
            return changes
        else:
            return 0
            
    except Exception as e:
        print(f"[ERROR] 处理失败 {file_path.name}: {e}")
        return 0

def process_all_files():
    """处理所有.ets文件"""
    print("开始替换图片URL...")
    print("=" * 60)
    
    total_changes = 0
    files_processed = 0
    
    # 遍历所有.ets文件
    for file_path in PAGES_DIR.rglob("*.ets"):
        changes = replace_urls_in_file(file_path)
        if changes > 0:
            files_processed += 1
            total_changes += changes
    
    print("\n" + "=" * 60)
    print(f"处理完成!")
    print(f"处理文件数: {files_processed}")
    print(f"总替换数: {total_changes}")

if __name__ == "__main__":
    process_all_files()

