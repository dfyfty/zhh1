#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量替换所有文件中的网络图片URL为本地资源引用
"""

import re
import os
from pathlib import Path

# 要处理的文件目录
PAGES_DIR = Path("entry/src/main/ets/pages")

def replace_all_urls_in_file(file_path):
    """替换文件中的所有图片URL"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changes = 0
        
        # 替换所有 picsum.photos URL
        # 匹配模式: 'https://picsum.photos/数字/数字?random=数字'
        pattern = r"'https://picsum\.photos/\d+/\d+\?random=(\d+)'"
        
        def replace_match(match):
            random_id = int(match.group(1))
            nonlocal changes
            changes += 1
            
            # 根据random ID确定资源类型
            if 1 <= random_id <= 40:
                return f"$r('app.media.content_{random_id}')"
            elif 101 <= random_id <= 120:
                return f"$r('app.media.avatar_{random_id}')"
            elif random_id in [201, 202, 203]:
                return f"$r('app.media.avatar_{random_id}')"
            elif random_id in [301, 302, 303]:
                return f"$r('app.media.avatar_{random_id}')"
            elif random_id == 501:
                return f"$r('app.media.avatar_{random_id}')"
            elif 601 <= random_id <= 610:
                return f"$r('app.media.icon_{random_id}')"
            elif 701 <= random_id <= 704:
                return f"$r('app.media.thumb_{random_id}')"
            elif 801 <= random_id <= 805:
                return f"$r('app.media.thumb_{random_id}')"
            elif 901 <= random_id <= 904:
                return f"$r('app.media.avatar_{random_id}')"
            elif random_id in [998, 999]:
                if random_id == 999:
                    # 检查是否是logo (32x32)
                    return f"$r('app.media.logo_{random_id}')"
                else:
                    return f"$r('app.media.avatar_{random_id}')"
            elif random_id == 1001:
                return f"$r('app.media.avatar_{random_id}')"
            elif 401 <= random_id <= 403:
                return f"$r('app.media.kb_{random_id}')"
            else:
                # 默认作为avatar处理
                return f"$r('app.media.avatar_{random_id}')"
        
        content = re.sub(pattern, replace_match, content)
        
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
        changes = replace_all_urls_in_file(file_path)
        if changes > 0:
            files_processed += 1
            total_changes += changes
    
    print("\n" + "=" * 60)
    print(f"处理完成!")
    print(f"处理文件数: {files_processed}")
    print(f"总替换数: {total_changes}")

if __name__ == "__main__":
    process_all_files()


