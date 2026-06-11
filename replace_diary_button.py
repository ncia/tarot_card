import re

path = r'c:\workspace\flutter_tarot\lib\screens\reading_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# We need to find the ElevatedButton for "일기에 저장하기" and change its arguments.
old_diary_button = """                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiaryEditScreen(
                              card: _shuffledDeck[_selectedCardIndices[0]],
                              resultText: !_shuffledReversed[_selectedCardIndices[0]] ? _shuffledDeck[_selectedCardIndices[0]].uprightDesc : _shuffledDeck[_selectedCardIndices[0]].reversedDesc,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('일기에 저장하기', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),"""

new_diary_button = """                    ElevatedButton(
                      onPressed: () {
                        List<TarotCardData> cards = [];
                        List<bool> reversals = [];
                        List<String> labels = [];
                        List<String> meanings = [];
                        
                        // Spread-specific labels
                        List<String> spreadLabels = [];
                        if (widget.spreadType.name == 'oneCard') {
                          spreadLabels = ['오늘의 점괘'];
                        } else if (widget.spreadType.name == 'threeCard') {
                          spreadLabels = ['1. 과거', '2. 현재', '3. 미래'];
                        } else if (widget.spreadType.name == 'fourCard') {
                          spreadLabels = ['1. 현재 상황 및 문제', '2. 문제의 원인', '3. 해결을 위한 조언', '4. 예상되는 결과'];
                        } else if (widget.spreadType.name == 'fiveCard') {
                          spreadLabels = ['1. 현재', '2. 과거', '3. 미래', '4. 원인', '5. 잠재력'];
                        } else if (widget.spreadType.name == 'celticCross') {
                          spreadLabels = ['1. 현재 상황', '2. 방해물', '3. 무의식', '4. 과거', '5. 의식적 목표', '6. 가까운 미래', '7. 태도', '8. 외부 환경', '9. 희망과 두려움', '10. 최종 결과'];
                        } else if (widget.spreadType.name == 'hexagram') {
                          spreadLabels = ['1. 과거', '2. 현재', '3. 미래', '4. 조언', '5. 주변 환경', '6. 결과'];
                        } else {
                          spreadLabels = List.generate(widget.spreadType.cardCount, (i) => '포지션 ${i + 1}');
                        }
                        
                        for (int i = 0; i < widget.spreadType.cardCount; i++) {
                          final idx = _selectedCardIndices[i];
                          cards.add(_shuffledDeck[idx]);
                          reversals.add(_shuffledReversed[idx]);
                          labels.add(spreadLabels.length > i ? spreadLabels[i] : '포지션 ${i + 1}');
                          meanings.add(!_shuffledReversed[idx] ? _shuffledDeck[idx].uprightDesc : _shuffledDeck[idx].reversedDesc);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiaryEditScreen(
                              cards: cards,
                              cardReversals: reversals,
                              positionLabels: labels,
                              cardMeanings: meanings,
                              spreadType: widget.spreadType.name,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('일기에 저장하기', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),"""

if old_diary_button in content:
    content = content.replace(old_diary_button, new_diary_button)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Replaced!")
else:
    print("Not found! Let's just do regex replacement.")
    # More robust regex
    import re
    pattern = r'ElevatedButton\(\s*onPressed: \(\) \{\s*Navigator\.push\(\s*context,\s*MaterialPageRoute\(\s*builder: \(context\) => DiaryEditScreen\([^)]+\),\s*\),\s*\);\s*\},[\s\S]*?child: const Text\(\'일기에 저장하기\', style: TextStyle\(fontWeight: FontWeight\.bold\)\),\s*\),'
    
    match = re.search(pattern, content)
    if match:
        content = content.replace(match.group(0), new_diary_button)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Replaced with regex!")
    else:
        print("Still not found!")
