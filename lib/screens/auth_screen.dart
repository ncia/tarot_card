import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../data/nickname_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class AuthScreen extends StatefulWidget {
  final bool isInline;
  const AuthScreen({super.key, this.isInline = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _isAdmin = false; // 관리자 가입 여부
  bool _obscurePassword = true; // 비밀번호 숨김 여부

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _generateRandomNickname() {
    final random = Random();
    final prefix = nicknamePrefixes[random.nextInt(nicknamePrefixes.length)];
    final suffix = nicknameSuffixes[random.nextInt(nicknameSuffixes.length)];
    _nicknameController.text = '$prefix $suffix';
  }

  Future<void> _signInWithGoogle() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('미리보기 환경(Windows)에서는 구글 로그인을 지원하지 않습니다. 안드로이드 기기나 웹을 이용해주세요.')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!docSnapshot.exists) {
          final random = Random();
          final prefix = nicknamePrefixes[random.nextInt(nicknamePrefixes.length)];
          final suffix = nicknameSuffixes[random.nextInt(nicknameSuffixes.length)];
          
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': user.email,
            'nickname': '$prefix $suffix',
            'role': 'user',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        if (mounted) {
          if (!widget.isInline) {
            Navigator.pop(context);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구글 로그인 오류: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('구글 로그인 중 알 수 없는 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    
    if (Firebase.apps.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('미리보기 환경(Windows)에서는 파이어베이스 로그인을 지원하지 않습니다.')),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      if (_isLogin) {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        if (userCredential.user != null && !userCredential.user!.emailVerified) {
          // 이메일 미인증 상태
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('이메일 인증이 필요합니다. 가입하신 이메일함을 확인해주세요.'),
                action: SnackBarAction(
                  label: '재발송',
                  onPressed: () async {
                    await userCredential.user!.sendEmailVerification();
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증 메일이 재발송되었습니다.')));
                  },
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
          await FirebaseAuth.instance.signOut(); // 인증 안되었으므로 강제 로그아웃
          return;
        }
      } else {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        final user = userCredential.user;
        if (user != null) {
          // Firestore에 유저 정보 및 권한(role) 저장
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': user.email,
            'nickname': _nicknameController.text.trim(),
            'role': _isAdmin ? 'admin' : 'user', // 관리자 여부에 따라 role 부여
            'createdAt': FieldValue.serverTimestamp(),
          });
          
          // 인증 메일 발송
          await user.sendEmailVerification();
          await FirebaseAuth.instance.signOut(); // 가입 직후 로그아웃 처리하여 인증 유도
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('회원가입이 완료되었습니다. 발송된 이메일을 확인하여 인증을 완료해주세요.'),
                duration: Duration(seconds: 5),
              ),
            );
            setState(() {
              _isLogin = true; // 로그인 화면으로 전환
              _passwordController.clear();
              _isAdmin = false; // 초기화
            });
            return;
          }
        }
      }
      if (mounted && !widget.isInline) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? '인증 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: GlassContainer(
              padding: const EdgeInsets.all(24),
              borderRadius: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLogin ? '로그인' : '회원가입',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 24),
                  if (!_isLogin) ...[
                    TextField(
                      controller: _nicknameController,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: '타로 세계의 닉네임',
                        labelStyle: const TextStyle(color: Colors.amberAccent),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.amberAccent),
                          onPressed: () => setState(() => _generateRandomNickname()),
                          tooltip: '닉네임 다시 뽑기',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(height: 16),
                  if (!_isLogin) ...[
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white54,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          title: const Text(
                            '관리자 계정으로 가입하기',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _isAdmin,
                          onChanged: (bool? value) {
                            setState(() {
                              _isAdmin = value ?? false;
                            });
                          },
                          activeColor: Colors.deepPurpleAccent,
                          checkColor: Colors.amberAccent,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.amberAccent)
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_isLogin ? '로그인하기' : '가입하기', style: const TextStyle(fontSize: 16)),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        if (!_isLogin && _nicknameController.text.isEmpty) {
                          _generateRandomNickname();
                        }
                      });
                    },
                    child: Text(
                      _isLogin ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인',
                      style: const TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 8),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google_logo.png', width: 24, height: 24),
                          const SizedBox(width: 8),
                          const Text('Google로 시작하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

    if (widget.isInline) {
      return formContent;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: formContent,
      ),
    );
  }
}
