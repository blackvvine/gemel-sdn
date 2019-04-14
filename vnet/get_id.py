#!/usr/bin/env python3

from bs4 import BeautifulSoup as BS
from sys import argv
import re


def print_help():
    print("Usage: ./get_id.sh [topology XML file] [MAC address]")
    exit(0)

if len(argv) < 3:
    print_help()

with open(argv[1]) as f:
    doc = f.read()

soup = BS(doc, 'html.parser')

inf = [t for t in soup.find_all('mac') if t.get_text() == argv[2]][0]

p = re.compile(r"\d+")
mid = [t for t in inf.parent.find_all('id') if p.match(t.get_text())][0].get_text()

switch = inf.parent.parent.find('attachment-points').find('tp-id').get_text()

m = re.match(r"(.+:.+):.+", switch)

if m:
    switch = m.group(1)

print("openflow:%s" % mid)
print(switch)


