import re

path = r'c:\workspace\flutter_tarot\lib\widgets\spread_layouts.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# The bug is that we added a GestureDetector inside Expanded, but forgot to close it.
# The `Expanded`'s child is `GestureDetector`, which has `child: Column(`.
# `Column` ends with `],\n)` 
# Then we expect `GestureDetector` to end with `),`
# Then `Expanded` to end with `)` or `),` depending on whether it's the last element.
# The structure we injected in `update_diary_list2.py` (no wait, it was `fix_clicks.py`) was:
'''
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push...
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            ...
                          ),
                          const SizedBox(height: 8),
                          Text(
                            TarotLocalizations.getName(context, card.id),
                            ...
                          ),
                          Text(
                            isRev ? "역방향 (Reversed)" : "정방향 (Upright)",
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ), # <--- We need THIS
                  ), # <--- We need THIS
'''

# The current broken structure is:
'''
                      isRev ? "역방향 (Reversed)" : "정방향 (Upright)",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
'''
# Notice the missing `),`.
# So we need to find `isRev \? "역방향 \(Reversed\)" : "정방향 \(Upright\)",\s*style: const TextStyle\(color: Colors\.white70, fontSize: 14\),\s*\),\s*],\s*\),\s*\),`
# Let's match the exact text block and replace it regardless of exact indentation.

pattern = re.compile(r'(isRev \? "역방향 \(Reversed\)" : "정방향 \(Upright\)",\s*style: const TextStyle\(color: Colors\.white70, fontSize: 14\),\s*\),\s*],\s*\),\s*)(\),\s*)(?!,\s*\])', re.MULTILINE)
# Wait, let's just do a simple replacement for all indentation levels.

lines = content.split('\n')
for i in range(len(lines)):
    if 'isRev ? "역방향 (Reversed)" : "정방향 (Upright)",' in lines[i]:
        # we found the line. It's followed by:
        # style: const TextStyle...
        # ),
        # ],
        # ),
        # ),
        # Let's count down to the `],`
        j = i
        while j < len(lines) and ']' not in lines[j]:
            j += 1
        
        if j < len(lines):
            # j is the line with `],`
            # j+1 should be `),`
            # j+2 should be `),`
            
            # Let's check the indentation of `],`
            indent = len(lines[j]) - len(lines[j].lstrip())
            # we need to insert an extra `),` at indent - 2
            
            # check if there's already 3 closing parens
            if '), // added' not in lines[j+2] and '), // added' not in lines[j+1]:
                # We'll just insert a line after j+1
                insert_str = " " * (indent - 2) + "),"
                lines.insert(j + 2, insert_str + ' // added')

content = '\n'.join(lines)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print("All syntaxes fixed!")
