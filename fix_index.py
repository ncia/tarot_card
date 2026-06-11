import re

path = r'c:\workspace\flutter_tarot\lib\widgets\spread_layouts.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# _OneCardLayout does not have an index variable.
# Let's find _OneCardLayout's build method and replace `$index` with `0` inside it.
# We can just look for the class `_OneCardLayout` and replace `$index` inside it.
parts = content.split('class _ThreeCardLayout')
if len(parts) == 2:
    one_card_part = parts[0]
    three_card_part = 'class _ThreeCardLayout' + parts[1]
    
    one_card_part = one_card_part.replace('_$index', '_0')
    
    content = one_card_part + three_card_part
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Fixed _OneCardLayout index!")
else:
    print("Failed to split")
