import re

path = r'c:\workspace\flutter_tarot\lib\screens\diary_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

helper_method = """  Widget _buildDiaryThumbnails(TarotDiary diary) {
    if (diary.cardIds.length <= 1) {
      final cardId = diary.cardIds.isNotEmpty ? diary.cardIds.first : diary.cardId;
      final card = tarotDeck.firstWhere((c) => c.id == cardId, orElse: () => tarotDeck.first);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(card.imagePath, width: 60, height: 90, fit: BoxFit.cover),
      );
    }

    final displayCount = diary.cardIds.length > 4 ? 4 : diary.cardIds.length;
    return SizedBox(
      width: 60.0 + (displayCount - 1) * 15.0,
      height: 90,
      child: Stack(
        children: List.generate(displayCount, (index) {
          final cardId = diary.cardIds[index];
          final card = tarotDeck.firstWhere((c) => c.id == cardId, orElse: () => tarotDeck.first);
          return Positioned(
            left: index * 15.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 0))
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(card.imagePath, width: 60, height: 90, fit: BoxFit.cover),
              ),
            ),
          );
        }),
      ),
    );
  }
"""

if "_buildDiaryThumbnails" not in content:
    # Insert helper method before the last brace
    last_brace_index = content.rfind('}')
    content = content[:last_brace_index] + helper_method + content[last_brace_index:]

# Replace ClipRRect image rendering inside builders
target1 = r"""\s*ClipRRect\(\s*borderRadius: BorderRadius\.circular\(8\),\s*child: Image\.asset\(card\.imagePath, width: 60, height: 90, fit: BoxFit\.cover\),\s*\),"""
target2 = r"""\s*ClipRRect\(\s*borderRadius: BorderRadius\.circular\(8\),\s*child: Image\.asset\('assets/images/cards/\$\{diary.cardId\}\.jpg', width: 60, height: 95, fit: BoxFit\.cover\),\s*\),"""

content = re.sub(target1, "\n                          _buildDiaryThumbnails(diary),", content)
content = re.sub(target2, "\n                          _buildDiaryThumbnails(diary),", content)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated!")
