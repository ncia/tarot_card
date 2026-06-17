import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'auth_screen.dart'; // AuthScreen 임포트 추가
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/profile_edit_dialog.dart';
import 'main_screen.dart';
import 'theme_selection_screen.dart';

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
              
              if (!isLoggedIn) {
                return const AuthScreen(isInline: true);
              }
              
              return _buildMenuList(context, isFirebaseInitialized: true, isLoggedIn: isLoggedIn, user: user);
            }
          )
        : _buildMenuList(context, isFirebaseInitialized: false, isLoggedIn: false, user: null),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, {required bool isFirebaseInitialized, required bool isLoggedIn, User? user}) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      children: [

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
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo.shade900,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/witch_morgan.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
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
                ],
              ),
            ),
          )
        else if (isLoggedIn)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
            builder: (context, docSnapshot) {
              String displayName = user.email ?? '이름 없음';
              String profileImage = 'assets/images/witch_morgan.jpg';
              if (docSnapshot.hasData && docSnapshot.data!.exists) {
                final data = docSnapshot.data!.data() as Map<String, dynamic>;
                displayName = data['nickname'] ?? displayName;
                profileImage = data['profileImage'] ?? profileImage;
              }
              
              return GlassContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 20,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.shade900,
                        image: DecorationImage(
                          image: AssetImage(profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? '',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          _EmailVerificationBadge(user: user),
                        ],
                      ),
                    ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ProfileEditDialog(
                              user: user,
                              currentNickname: displayName,
                              currentProfileImage: profileImage,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        else
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
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade800,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/witch_morgan.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '로그인해주세요',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),
                        Text(
                          '터치하여 회원가입 및 로그인',
                          style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 30),
        // Menu Items
        _buildSectionTitle('나의 기록'),
        _buildMenuItem(Icons.history_edu, '타로 일기 보관함', '저장된 일기를 확인하세요.', onTap: () {
          mainScreenKey.currentState?.switchTab(2);
        }),
        _buildMenuItem(Icons.star_border, '즐겨찾는 카드', '내가 가장 좋아하는 카드 목록'),
        
        const SizedBox(height: 20),
        _buildSectionTitle('앱 설정'),
        if (isLoggedIn && user != null) _PushSettingsTile(userId: user.uid),
        _buildMenuItem(Icons.language, '언어 설정', '한국어'),
        _buildMenuItem(Icons.dark_mode_outlined, '테마 설정', '배경 이미지 변경', onTap: () {
          Navigator.pushNamed(context, '/theme_selection');
        }),
        
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

class _PushSettingsTile extends StatefulWidget {
  final String userId;
  const _PushSettingsTile({required this.userId});

  @override
  State<_PushSettingsTile> createState() => _PushSettingsTileState();
}

class _PushSettingsTileState extends State<_PushSettingsTile> {
  bool _pushEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPushSetting();
  }

  Future<void> _loadPushSetting() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        setState(() {
          _pushEnabled = doc.data()?['pushEnabled'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('푸시 설정 로드 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePush(bool value) async {
    setState(() {
      _pushEnabled = value;
      _isLoading = true;
    });

    try {
      if (value) {
        // 권한 요청 (iOS 등의 경우 여기서 창이 뜹니다)
        await FirebaseMessaging.instance.requestPermission();
      }
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'pushEnabled': value,
      });
    } catch (e) {
      debugPrint('푸시 설정 업데이트 오류: $e');
      setState(() => _pushEnabled = !value); // 롤백
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Icon(Icons.notifications_active_outlined, color: Colors.amberAccent),
            ),
            title: const Text(
              '푸시 알림 수신',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '새로운 운세 및 이벤트 알림',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),
            trailing: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amberAccent),
                  )
                : Switch(
                    value: _pushEnabled,
                    onChanged: _togglePush,
                    activeColor: Colors.amberAccent,
                  ),
          ),
        ),
      ),
    );
  }
}

class _EmailVerificationBadge extends StatefulWidget {
  final User user;
  const _EmailVerificationBadge({required this.user});

  @override
  State<_EmailVerificationBadge> createState() => _EmailVerificationBadgeState();
}

class _EmailVerificationBadgeState extends State<_EmailVerificationBadge> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    return GestureDetector(
      onTap: isVerified || _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                await FirebaseAuth.instance.currentUser?.reload();
                if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이메일 인증이 확인되었습니다! ✨')),
                    );
                  }
                } else {
                  final langCode = Localizations.localeOf(context).languageCode;
                  await FirebaseAuth.instance.setLanguageCode(langCode);
                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.deepPurple.shade900,
                        title: const Text('인증 메일 발송', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          '인증 메일이 발송되었습니다.\n이메일함을 확인하여 링크를 클릭한 뒤, 이 버튼을 다시 한 번 눌러주세요!',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('확인', style: TextStyle(color: Colors.amberAccent)),
                          ),
                        ],
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('너무 많은 요청이거나 오류가 발생했습니다.')),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isVerified ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isVerified ? Colors.green : Colors.redAccent),
        ),
        child: _isLoading 
            ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
                isVerified ? '이메일 인증 완료됨' : '이메일 미인증 (터치하여 인증하기)',
                style: TextStyle(
                  color: isVerified ? Colors.greenAccent : Colors.redAccent, 
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

