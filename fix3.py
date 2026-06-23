f = 'setup_core.py'
with open(f, 'r', encoding='utf-8') as file:
    content = file.read()
content = content.replace(' + "\\\\n"', '')
with open(f, 'w', encoding='utf-8') as file:
    file.write(content)
