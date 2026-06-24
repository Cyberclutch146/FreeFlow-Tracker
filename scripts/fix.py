import glob
for f in ['setup_constants.py', 'setup_models.py', 'setup_db_and_repos.py', 'setup_ui.py']:
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    content = content.replace(' + "\\\\n"', '')
    with open(f, 'w', encoding='utf-8') as file:
        file.write(content)
