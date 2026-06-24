import glob
for f in glob.glob('lib/**/*.dart', recursive=True):
    with open(f, 'r', encoding='utf-8') as file:
        c = file.read()
    c = c.replace("'\\${isIncome ? '+' : '-'}${CurrencyFormatter.format(t.amount)}'", 'isIncome ? "+${CurrencyFormatter.format(t.amount)}" : "-${CurrencyFormatter.format(t.amount)}"')
    
    with open(f, 'w', encoding='utf-8') as file:
        file.write(c)

with open('test/widget_test.dart', 'r', encoding='utf-8') as file:
    c = file.read()
c = c.replace('MyApp()', 'const MaterialApp()')
with open('test/widget_test.dart', 'w', encoding='utf-8') as file:
    file.write(c)

f = 'lib/repositories/transaction_repository.dart'
with open(f, 'r', encoding='utf-8') as file:
    c = file.read()
c = c.replace('return t.amount + ', 'return (t.amount) + ')
# wait, FutureOr<double> is because `fold` is missing initialValue!
c = c.replace('.fold(0, (sum, t)', '.fold(0.0, (sum, t)')
with open(f, 'w', encoding='utf-8') as file:
    file.write(c)
