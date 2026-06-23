import glob

for f in glob.glob('lib/**/*.dart', recursive=True):
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Fix Colors
    content = content.replace('AppColors.backgroundBase', 'AppColors.backgroundPrimary')
    content = content.replace('AppColors.accentGreen', 'AppColors.accentTeal')
    
    # Fix strings
    content = content.replace("'${isIncome ? '+' : '-'}${CurrencyFormatter.format(t.amount)}'", '"${isIncome ? \'+\' : \'-\'}${CurrencyFormatter.format(t.amount)}"')
    
    with open(f, 'w', encoding='utf-8') as file:
        file.write(content)
