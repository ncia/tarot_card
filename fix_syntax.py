import re

path = r'c:\workspace\flutter_tarot\lib\widgets\spread_layouts.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# We need to find the exact structure where we added GestureDetector but forgot to close it.
# It looks like:
'''
                      isRev ? "역방향 (Reversed)" : "정방향 (Upright)",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
'''
# It should be:
'''
                      isRev ? "역방향 (Reversed)" : "정방향 (Upright)",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
'''

# Let's just do a regex replace to fix it.
# The pattern is: `isRev \? "역방향 \(Reversed\)" : "정방향 \(Upright\)",\s*style: const TextStyle\(color: Colors\.white70, fontSize: 14\),\s*\),\s*],\s*\),\s*\),`
# Wait, let's just search for `],\s*\),\s*\),\s*],` and replace with `],\s*\),\s*\),\s*\),\s*],`
# Actually, the best way is to revert the file to an older version, or run flutter format and see if it formats.
# Let's fix it by adding the missing parenthesis.

# Let's look at the original file before my fix_clicks.py:
# Expanded child was Column. Column ended with ], then ), then Expanded ended with ), then Row ended with children: [ ..., Expanded ], so ], then ).
# So after Column ends with ],\n), there is Expanded ending with ).
# Now it's Expanded > GestureDetector > Column.
# Column ends with ],\n). Then GestureDetector ends with ), Then Expanded ends with ).
# So we need ],\n),\n),\n) instead of ],\n),\n)

content = content.replace('''                    ),
                  ],
                ),
              ),
            ],''', '''                    ),
                  ],
                ),
              ),
            ),
            ],''')

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Syntax fixed!")
