#!/usr/bin/env python3

# Python script to create a telegraph page of kernel changelogs

import os
from telegraph import Telegraph

telegraph = Telegraph()
Tag='5.4.1'
Title='Rad Kernel Chaneglogs for v/x ' + Tag

os.system('cd /home/theradcolor/whyred/kernel && git log 5.4^..5.4.1 --oneline >> /home/theradcolor/lazyscripts/kernel/radcl.txt')

# Read text func() from a file
def read(file):
    try:
        file = open(file, 'r')
        data = file.read()
        file.close()

    except FileNotFoundError:
        data = None

    return data


telegraph.create_account(short_name='rad', author_name='Shashank', author_url='https://github.com/theradcolor')

content = read("radcl.txt")
content = "<br/><br/>".join(content.split("\n"))

response = telegraph.create_page(
    Title,
    html_content='<b>Sources • <a href="https://github.com/theradcolor/android_kernel_xiaomi_whyred">Kernel GitHub Sources Link</a></b><br><p>{}</p>'.format(content),
    author_name='Shashank',
    author_url='https://github.com/theradcolor'
)

print('https://telegra.ph/{}'.format(response['path']))
os.system('rm -rf /home/theradcolor/lazyscripts/kernel/radcl.txt')
