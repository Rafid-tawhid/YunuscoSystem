// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import '../models/announcement_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<DocumentReference> createPost(String content) async {
    final user = DashboardHelpers.currentUser;
    if (user == null) throw Exception('User not logged in');

    final post = AnnouncementModel(
      id: '',
      userId: (user.userId??0).toString(),
      userName: user.userName ?? user.userRoleName!.split('@')[0],
      designation:user.designation??'None',
      content: content,
      timestamp: DateTime.now(),
      likes: [],
      likesCount: 0,
      commentsCount: 0,
      isActive: true,
    );

    final docRef = _firestore.collection('posts').doc();
    post.id = docRef.id; // Update the post with the generated ID

    await docRef.set(post.toMap());
    return docRef;
  }

  Stream<List<AnnouncementModel>> getPosts() {
    return _firestore
        .collection('posts')
        .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => AnnouncementModel.fromFirestore(doc)).toList());
  }

  Future<void> toggleLike(String postId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final postRef = _firestore.collection('posts').doc(postId);

    return _firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      if (!postDoc.exists) throw Exception('Post not found');

      final post = AnnouncementModel.fromFirestore(postDoc);
      final likes = List<String>.from(post.likes);
      final isLiked = likes.contains(user.uid);

      if (isLiked) {
        likes.remove(user.uid);
      } else {
        likes.add(user.uid);
      }

      transaction.update(postRef, {
        'likes': likes,
        'likesCount': likes.length,
      });
    });
  }

  Future<DocumentReference> addComment(String postId, String content) async {
    final user = DashboardHelpers.currentUser;
    if (user == null) throw Exception('User not logged in');

    final comment = Comment(
      id: '',
      userId: (user.userId??0).toString(),
      userName: user.userName ?? user.userRoleName!.split('@')[0],
      content: content,
      timestamp: DateTime.now(),
    );

    final docRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();

    comment.id = docRef.id; // Update the comment with the generated ID

    await docRef.set(comment.toMap());

    await _firestore.collection('posts').doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });

    return docRef;
  }

  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList());
  }

  Future<void> deletePost(String postId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final postDoc = await _firestore.collection('posts').doc(postId).get();
    final post = AnnouncementModel.fromFirestore(postDoc);

    if (post.userId != user.uid) {
      throw Exception('Only post owner can delete the post');
    }

    await _firestore.collection('posts').doc(postId).update({
      'isActive': false,
    });
  }
}