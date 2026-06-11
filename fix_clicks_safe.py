import re

path = r'c:\workspace\flutter_tarot\lib\widgets\spread_layouts.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add HitTestBehavior.opaque to _buildCardItem's GestureDetector
content = content.replace(
    "child: Column(\n      children: [\n        GestureDetector(",
    "child: GestureDetector(\n      behavior: HitTestBehavior.opaque,\n      onTap: onTap,\n      child: Column(\n        children: [\n          GestureDetector("
)
content = content.replace(
    "onTap: onTap,\n          child: ClipRRect(",
    "child: ClipRRect("
)

# 2. Add HitTestBehavior.opaque and wrap the texts in lists
# The pattern is:
# Expanded(
#   child: Column(
#     crossAxisAlignment: CrossAxisAlignment.start,

# We will replace it with:
# Expanded(
#   child: GestureDetector(
#     behavior: HitTestBehavior.opaque,
#     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_0'))),
#     child: Column(
#       crossAxisAlignment: CrossAxisAlignment.start,

target = """              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,"""

replacement = """              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_0'))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,"""

# BUT wait, the target has a closing `)` for Expanded that we need to offset by adding `),` for GestureDetector.
# Instead of replacing blindly, we will do it with a loop over lines.

lines = content.split('\n')
i = 0
while i < len(lines):
    if "Expanded(" in lines[i] and "child: Column(" in lines[i+1] and "crossAxisAlignment: CrossAxisAlignment.start," in lines[i+2]:
        # we found the start.
        # Replace line 1 with GestureDetector
        indent = len(lines[i+1]) - len(lines[i+1].lstrip())
        lines[i+1] = " " * indent + "child: GestureDetector(\n" + " " * (indent+2) + "behavior: HitTestBehavior.opaque,\n" + " " * (indent+2) + "onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),\n" + " " * (indent+2) + "child: Column("
        
        # Now find the matching closing of Column
        j = i + 2
        col_indent = indent + 2 # not really, Column is at `indent`, let's just find `],` then `),`
        while j < len(lines):
            if lines[j].strip() == "]," and lines[j+1].strip() == "),":
                # j+1 is Column's end.
                # we need to insert GestureDetector's end at j+2
                lines.insert(j+2, " " * indent + "),")
                break
            j += 1
    i += 1

content = '\n'.join(lines)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Safe fix applied!")
