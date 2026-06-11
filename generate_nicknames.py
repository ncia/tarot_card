import random
import os

# 40 * 25 = 1000
adj_prefix = ["신비로운", "운명적인", "영원한", "푸른", "붉은", "은빛", "황금빛", "고독한", "지혜로운", "신성한", 
              "잊혀진", "빛나는", "어두운", "찬란한", "아름다운", "우울한", "비밀스러운", "조용한", "거친", "따뜻한", 
              "차가운", "슬픈", "기쁜", "무한한", "아득한", "신비한", "몽환적인", "눈부신", "깊은", "오래된", 
              "새로운", "환상적인", "낭만적인", "신묘한", "기묘한", "성스러운", "위대한", "신비주의", "순수한", "타락한"]

noun_prefix = ["달빛의", "별빛의", "새벽의", "밤하늘의", "바람의", "바다의", "불꽃의", "안개의", "구름의", "태양의", 
               "대지의", "숲속의", "폭풍의", "번개의", "이슬의", "황혼의", "우주의", "시간의", "공간의", "기억의", 
               "꿈의", "환상의", "진실의", "운명의", "영원의"]

# 40 * 25 = 1000
adj_suffix = ["떠도는", "길잃은", "깨달은", "숨겨진", "잠든", "깨어난", "지켜보는", "노래하는", "춤추는", "방랑하는", 
              "속삭이는", "타오르는", "스러지는", "피어나는", "우는", "웃는", "꿈꾸는", "헤매는", "다가오는", "멀어지는", 
              "나아가는", "멈춰선", "기도하는", "예언하는", "축복받은", "저주받은", "구원받은", "선택받은", "버림받은", "태어난", 
              "죽어가는", "부활하는", "기억하는", "망각한", "사랑하는", "미워하는", "용서하는", "투쟁하는", "갈망하는", "체념한"]

noun_suffix = ["시인", "여행자", "마법사", "방랑자", "기사", "정령", "요정", "예언자", "관찰자", "수호자", 
               "인도자", "구도자", "탐험가", "전사", "사냥꾼", "학자", "광대", "제사장", "여사제", "황제", 
               "현자", "마녀", "연금술사", "그림자", "악마"]

prefixes = []
for a in adj_prefix:
    for n in noun_prefix:
        prefixes.append(f"{a} {n}")

suffixes = []
for a in adj_suffix:
    for n in noun_suffix:
        suffixes.append(f"{a} {n}")

# Shuffle them to make it random order in the file
random.seed(42)
random.shuffle(prefixes)
random.shuffle(suffixes)

dart_content = f"""// AUTO GENERATED FILE
// Contains 1000 prefixes and 1000 suffixes for Tarot Nicknames

const List<String> nicknamePrefixes = [
    {', '.join([f'"{p}"' for p in prefixes])}
];

const List<String> nicknameSuffixes = [
    {', '.join([f'"{s}"' for s in suffixes])}
];
"""

# ensure dir exists
os.makedirs("lib/data", exist_ok=True)
with open("lib/data/nickname_data.dart", "w", encoding="utf-8") as f:
    f.write(dart_content)

print(f"Generated {len(prefixes)} prefixes and {len(suffixes)} suffixes.")
