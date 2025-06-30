"""
将指定文件夹下所有 log 文件中提取的网址，整理为 Clash 规则（DOMAIN-SUFFIX 优先，IP/特殊域名用 DOMAIN），去重、排序，并输出为 YAML 文件。
"""

import os
import yaml
import ipaddress
from tqdm import tqdm


import re


def extract_domains_from_logs(log_dir):
    """遍历 log_dir 下所有 .log 文件，提取包含 'match Match using' 的域名或IP，去重"""
    domains = set()
    log_files = [fname for fname in os.listdir(log_dir) if fname.endswith(".log")]
    print(f"共找到 {len(log_files)} 个 log 文件")
    # 匹配 [TCP] ... --> 域名:端口 match Match using
    pattern = re.compile(
        r"\[TCP\] [^ ]+\(([^,]+), uid=\d+\) --> ([^:]+):\d+ match Match using"
    )
    for fname in tqdm(log_files, desc="处理日志文件"):
        fpath = os.path.join(log_dir, fname)
        with open(fpath, "r", encoding="utf-8") as f:
            for line in f:
                if "match Match using" in line:
                    m = pattern.search(line)
                    if m:
                        domains.add(m.group(2))
    return domains


def classify_domains(domains):
    """将域名分为 DOMAIN-SUFFIX 和 DOMAIN 两类，并各自排序"""
    domain_suffix = []
    domain = []
    for d in domains:
        try:
            ipaddress.ip_address(d)
            domain.append(d)
        except ValueError:
            if d and all(c not in d for c in "/:"):
                if "." in d:
                    domain_suffix.append(d)
                else:
                    domain.append(d)
            else:
                domain.append(d)
    domain_suffix = sorted(set(domain_suffix), key=lambda x: x.lower())
    domain = sorted(set(domain), key=lambda x: x.lower())
    return domain_suffix, domain


def build_clash_rules(domain_suffix, domain):
    """生成 Clash 规则列表，DOMAIN-SUFFIX 在前，DOMAIN 在后"""
    rules = [f"DOMAIN-SUFFIX,{d},DIRECT" for d in domain_suffix]
    rules += [f"DOMAIN,{d},DIRECT" for d in domain]
    return rules


def main():
    log_dir = "/home/ranfr/.local/share/io.github.clash-verge-rev.clash-verge-rev/logs/service"  # 可根据需要修改
    out_path = "clash_urls.yaml"
    domains = extract_domains_from_logs(log_dir)
    domain_suffix, domain = classify_domains(domains)
    rules = build_clash_rules(domain_suffix, domain)
    clash_yaml = {"payload": rules}
    with open(out_path, "w", encoding="utf-8") as f:
        yaml.dump(clash_yaml, f, allow_unicode=True, default_flow_style=False)
    print(f"已生成 {out_path}，共 {len(domains)} 个唯一网址")


if __name__ == "__main__":
    main()
