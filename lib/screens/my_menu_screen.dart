import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'auth_screen.dart'; // AuthScreen 임포트 추가

class MyMenuScreen extends StatelessWidget {
  const MyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase가 초기화되지 않은 환경(예: 윈도우 미설정) 처리
    final isFirebaseInitialized = Firebase.apps.isNotEmpty;
    
    return GradientBackground(
      child: SafeArea(
        child: isFirebaseInitialized 
        ? StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final isLoggedIn = user != null;
              return _buildMenuList(context, isFirebaseInitialized: true, isLoggedIn: isLoggedIn, user: user);
            }
          )
        : _buildMenuList(context, isFirebaseInitialized: false, isLoggedIn: false, user: null),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, {required bool isFirebaseInitialized, required bool isLoggedIn, User? user}) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      children: [
        Text(
          AppLocalizations.of(context)?.navMyMenu ?? '내 정보',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 30),
        // User Profile Section
        if (!isFirebaseInitialized)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: GlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.indigo.shade900,
                    backgroundImage: const AssetImage('assets/images/fortune_teller.jpg'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '파이어베이스 미연결',
                          style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Windows 설정 필요 (미리보기)',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '터치하여 로그인 화면 UI 보기',
                          style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.login, color: Colors.amberAccent),
                ],
              ),
            ),
          )
        else
          InkWell(
            onTap: isLoggedIn ? null : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: GlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: isLoggedIn ? Colors.indigo.shade900 : Colors.grey.shade800,
                    backgroundImage: const AssetImage('assets/images/fortune_teller.jpg'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isLoggedIn)
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
                            builder: (context, docSnapshot) {
                              String displayName = '이름 없음';
                              if (docSnapshot.hasData && docSnapshot.data!.exists) {
                                final data = docSnapshot.data!.data() as Map<String, dynamic>;
                                displayName = data['nickname'] ?? user.email ?? '이름 없음';
                              }
                              return Text(
                                displayName,
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          )
                        else
                          const Text(
                            '로그인해주세요',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        if (isLoggedIn)
                          Text(
                            user!.email ?? '',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8),
                        if (isLoggedIn)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: user!.emailVerified ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: user.emailVerified ? Colors.green : Colors.redAccent),
                            ),
                            child: Text(
                              user.emailVerified ? '이메일 인증됨' : '이메일 미인증',
                              style: TextStyle(color: user.emailVerified ? Colors.greenAccent : Colors.redAccent, fontSize: 12),
                            ),
                          )
                        else
                          const Text(
                            '터치하여 회원가입 및 로그인',
                            style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  if (isLoggedIn) 
                    const Icon(Icons.edit, color: Colors.white54)
                  else 
                    const Icon(Icons.login, color: Colors.amberAccent),
                ],
              ),
            ),
          ),
        const SizedBox(height: 30),
        // Menu Items
        _buildSectionTitle('나의 기록'),
        _buildMenuItem(Icons.history_edu, '과거 점괘 보관함', '저장된 점괘를 확인하세요.'),
        _buildMenuItem(Icons.star_border, '즐겨찾는 카드', '내가 가장 좋아하는 카드 목록'),
        
        const SizedBox(height: 20),
        _buildSectionTitle('앱 설정'),
        _buildMenuItem(Icons.volume_up_outlined, '사운드 및 알림', 'BGM, 효과음 설정'),
        _buildMenuItem(Icons.language, '언어 설정', '한국어'),
        _buildMenuItem(Icons.dark_mode_outlined, '테마 설정', '다크/라이트 모드'),
        
        const SizedBox(height: 20),
        _buildSectionTitle('고객 지원'),
        _buildMenuItem(Icons.help_outline, '자주 묻는 질문 (FAQ)', null),
        _buildMenuItem(Icons.info_outline, '앱 정보', '버전 1.0.0'),
        
        if (isLoggedIn) ...[
          const SizedBox(height: 20),
          _buildSectionTitle('계정 관리'),
          _buildMenuItem(Icons.logout, '로그아웃', '현재 기기에서 로그아웃합니다.', onTap: () async {
            await FirebaseAuth.instance.signOut();
          }),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String? subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 16,
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.amberAccent),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  )
                : null,
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }
}
