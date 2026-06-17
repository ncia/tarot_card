import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'glass_container.dart';

class ProfileEditDialog extends StatefulWidget {
  final User user;
  final String currentNickname;
  final String currentProfileImage;

  const ProfileEditDialog({
    super.key,
    required this.user,
    required this.currentNickname,
    required this.currentProfileImage,
  });

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _nicknameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  late String _selectedImage;
  bool _isLoading = false;
  bool _isSocialLoginUser = false;
  bool _isEmailEditing = false;
  
  final List<String> _availableAvatars = [
    'assets/images/witch_morgan.jpg',
    'assets/images/witch_luna.jpg',
    'assets/images/witch_aria.jpg',
    'assets/images/witch_serena.jpg',
    'assets/images/witch_evelyn.jpg',
    'assets/images/witch_karen.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.currentNickname);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
    
    // 기본 이미지가 목록에 없으면 morgan으로
    _selectedImage = _availableAvatars.contains(widget.currentProfileImage) 
        ? widget.currentProfileImage 
        : 'assets/images/witch_morgan.jpg';
        
    // 구글/애플 가입 여부 확인 (소셜 가입자는 이메일 변경 불가)
    _isSocialLoginUser = widget.user.providerData.any(
      (userInfo) => userInfo.providerId == 'google.com' || userInfo.providerId == 'apple.com'
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final newNickname = _nicknameController.text.trim();
      final newEmail = _emailController.text.trim();

      // 1. 닉네임 중복 검사 및 정보 업데이트
      if (newNickname.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('닉네임을 입력해주세요.')));
        setState(() => _isLoading = false);
        return;
      }

      if (newNickname != widget.currentNickname) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('nickname', isEqualTo: newNickname)
            .get();
            
        if (querySnapshot.docs.isNotEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('이미 사용 중인 닉네임입니다. 다른 닉네임을 입력해주세요.')),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
        'nickname': newNickname,
        'profileImage': _selectedImage,
      });

      // 2. 이메일 변경 처리 (소셜 로그인이 아니며, 기존 이메일과 다르고, 비어있지 않을 때)
      if (!_isSocialLoginUser && newEmail != widget.user.email && newEmail.isNotEmpty) {
        // 비밀번호 확인
        final password = _passwordController.text;
        if (password.isEmpty) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이메일 변경을 위해 현재 비밀번호를 입력해주세요.')));
          setState(() => _isLoading = false);
          return;
        }

        // 재인증
        final AuthCredential credential = EmailAuthProvider.credential(
          email: widget.user.email!,
          password: password,
        );
        await widget.user.reauthenticateWithCredential(credential);

        // 파이어베이스 Auth 이메일 변경 인증 메일 발송
        await widget.user.verifyBeforeUpdateEmail(newEmail);
        
        // Firestore의 email도 업데이트 (하지만 실제 Auth 이메일은 링크 클릭 시 변경됨)
        // 안내 메시지 표시
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('인증 메일이 발송되었습니다. 새 이메일함에서 인증을 완료해주세요.'), duration: Duration(seconds: 5)),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('프로필이 저장되었습니다.')));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String msg = '오류가 발생했습니다.';
        if (e.code == 'wrong-password') { msg = '비밀번호가 틀렸습니다.'; }
        else if (e.code == 'invalid-email') { msg = '유효하지 않은 이메일 형식입니다.'; }
        else if (e.code == 'email-already-in-use') { msg = '이미 사용 중인 이메일입니다.'; }
        else if (e.code == 'requires-recent-login') { msg = '보안을 위해 다시 로그인 후 시도해주세요.'; }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장 중 알 수 없는 오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 20,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('프로필 수정', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // 사진 선택
              const Text('프로필 사진', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableAvatars.length,
                  itemBuilder: (context, index) {
                    final avatar = _availableAvatars[index];
                    final isSelected = avatar == _selectedImage;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedImage = avatar),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? Colors.amberAccent : Colors.transparent, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(avatar),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 닉네임 입력
              TextField(
                controller: _nicknameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '닉네임',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                ),
              ),
              const SizedBox(height: 16),

              // 이메일 입력
              TextField(
                controller: _emailController,
                enabled: !_isSocialLoginUser,
                style: TextStyle(color: _isSocialLoginUser ? Colors.white54 : Colors.white),
                decoration: InputDecoration(
                  labelText: '이메일 주소',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  helperText: _isSocialLoginUser ? '구글/애플 연동 계정은 이메일을 변경할 수 없습니다.' : '이메일 변경 시 확인 메일이 발송됩니다.',
                  helperStyle: TextStyle(color: _isSocialLoginUser ? Colors.redAccent : Colors.amberAccent, fontSize: 11),
                ),
                onChanged: (val) {
                  if (!_isEmailEditing && val != widget.user.email) {
                    setState(() => _isEmailEditing = true);
                  } else if (_isEmailEditing && val == widget.user.email) {
                    setState(() => _isEmailEditing = false);
                  }
                },
              ),
              
              if (_isEmailEditing && !_isSocialLoginUser) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: '현재 비밀번호 (이메일 변경 확인용)',
                    labelStyle: TextStyle(color: Colors.redAccent),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),

              // 하단 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('취소', style: TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
