import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'community_detail.dart';
import 'communitypost.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('아직 게시글이 없습니다.'));
          return ListView.separated(
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 24),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.7,
              height: 24,
            ),
            itemBuilder: (context, index) {
              final post = docs[index].data() as Map<String, dynamic>;
              final postId = docs[index].id;
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommunityDetailPage(postId: postId, post: post),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Text(
                        post['category'] ?? '',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        post['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CommunityPost()),
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, size: 32),
        tooltip: '글쓰기',
      ),
    );
  }
}
