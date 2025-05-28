import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // 추가

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '설정',
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.indigo),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('환경설정 아이콘 클릭')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.indigo),
            title: const Text('언어 변경 (EN/KR)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.indigo),
            title: const Text('알림 설정'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, color: Colors.indigo),
            title: const Text('북마크 관리'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.indigo),
            title: const Text('이용약관/개인정보'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.indigo),
            title: const Text('문의/피드백'),
            onTap: () {},
          ),
          // 🔻 로그아웃: 구글 & 파이어베이스 모두 로그아웃 처리!
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.indigo),
            title: const Text('로그아웃'),
            onTap: () async {
              // Google 로그아웃 (에러 무시 가능)
              try {
                await GoogleSignIn().signOut();
              } catch (_) {}
              // Firebase 로그아웃
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃되었습니다')),
                );
              }
            },
          ),
          const Divider(height: 30),
          Center(
            child: Text(
              '앱버전 v1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
