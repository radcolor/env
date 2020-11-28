#!/usr/bin/env python3

# Python script to create a telegraph page of kernel changelogs

import os
from telegraph import Telegraph

TAG0=os.environ['TAG_LATEST']
TAG1=os.environ['TAG_SECOND_LATEST']
Title='Rad Kernel Changelogs for v/x ' + TAG0

os.system('git log {}^...{} --oneline >> radcl'.format(TAG1, TAG0))

# Read text func() from a file
def read(file):
    try:
        file = open(file, 'r')
        data = file.read()
        file.close()

    except FileNotFoundError:
        data = None

    return data


telegraph = Telegraph()

telegraph.create_account(short_name='rad', author_name='Shashank', author_url='https://github.com/theradcolor')

content = read("radcl")
content = "<br/><br/>".join(content.split("\n"))

response = telegraph.create_page(
    Title,
    html_content='<b>Sources • <a href="https://github.com/theradcolor/android_kernel_xiaomi_whyred">Kernel GitHub Sources Link</a></b><br><p>{}</p>'.format(content),
    author_name='Shashank',
    author_url='https://github.com/theradcolor'
)

print('https://telegra.ph/{}'.format(response['path']))
