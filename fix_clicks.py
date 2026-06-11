import re

path = r'c:\workspace\flutter_tarot\lib\widgets\spread_layouts.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add HitTestBehavior.opaque to _buildCardItem's GestureDetector
content = content.replace(
    '  return GestureDetector(\n    onTap: () {',
    '  return GestureDetector(\n    behavior: HitTestBehavior.opaque,\n    onTap: () {'
)

# 2. Add GestureDetector to the Expanded Column for list views
# Pattern to match Expanded child Column
# We have 6 spreads. Let's just do it dynamically.

def replace_expanded(m):
    # m.group(1) is the indentation
    indent = m.group(1)
    
    # We don't have index easily, let's just use a string format to find the exact hero tag.
    # Actually, we can just replace `child: Column(` with the GestureDetector if we know the index.
    pass

# Let's do exact replacements.
one_card_old = """              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),"""

one_card_new = """              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_0'))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                      ),"""

list_view_old = """                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),"""

list_view_new = """                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                          ),"""

content = content.replace(one_card_old, one_card_new)
content = content.replace(list_view_old, list_view_new)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Replaced!")
