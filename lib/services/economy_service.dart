import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class EconomyService extends ChangeNotifier {
  static final EconomyService _instance = EconomyService._internal();
  factory EconomyService() => _instance;
  
  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  EconomyService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _initListener(user);
    });
  }

  int _coins = 0;
  int _magicDust = 0;
  int _worldTreeExp = 0;
  int _crystalBallExp = 0;

  int get coins => _coins;
  int get magicDust => _magicDust;
  int get worldTreeExp => _worldTreeExp;
  int get crystalBallExp => _crystalBallExp;

  void _initListener(User? user) {
    _firestoreSubscription?.cancel();
    if (user != null) {
      _firestoreSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          final data = doc.data()!;
          _coins = data['coins'] ?? 0;
          _magicDust = data['magicDust'] ?? 0;
          _worldTreeExp = data['worldTreeExp'] ?? 0;
          _crystalBallExp = data['crystalBallExp'] ?? 0;
          notifyListeners();
        } else {
          _coins = 0;
          _magicDust = 0;
          _worldTreeExp = 0;
          _crystalBallExp = 0;
          notifyListeners();
        }
      });
    } else {
      _coins = 0;
      _magicDust = 0;
      _worldTreeExp = 0;
      _crystalBallExp = 0;
      notifyListeners();
    }
  }

  // Initialize new user with 3 coins if they don't have the document or fields yet
  Future<void> initializeNewUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          'coins': 3,
          'magicDust': 0,
          'worldTreeExp': 0,
          'crystalBallExp': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'user',
        }, SetOptions(merge: true));
      } else {
        // If doc exists but no coins field, give them 3
        final data = doc.data()!;
        if (!data.containsKey('coins')) {
          await docRef.update({'coins': 3});
        }
      }
    }
  }

  Future<bool> deductCoin(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    if (_coins >= amount) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'coins': FieldValue.increment(-amount),
      });
      return true;
    }
    return false;
  }

  Future<void> addMagicDust(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'magicDust': FieldValue.increment(amount),
      });
    }
  }

  Future<void> addWorldTreeExp(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'worldTreeExp': FieldValue.increment(amount),
        'lastWateredAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> upgradeCrystalBall(int cost) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    if (_magicDust >= cost) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'magicDust': FieldValue.increment(-cost),
        'crystalBallExp': FieldValue.increment(1),
      });
      return true;
    }
    return false;
  }
}
