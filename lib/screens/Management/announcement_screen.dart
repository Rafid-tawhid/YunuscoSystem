// screens/news_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/announcement_model.dart';
import 'package:yunusco_group/screens/Management/widgets/comment_screen.dart';
import 'package:yunusco_group/screens/Management/widgets/create_post_screen.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../providers/riverpods/management_provider.dart';

class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Company News Feed'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: postsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feed, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Be the first to share something!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return posts.isEmpty?CircularProgressIndicator():
          ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: posts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}

class PostCard extends ConsumerWidget {
  final AnnouncementModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseService = ref.watch(firebaseServiceProvider);
    final currentUserId = firebaseService.currentUser?.uid;
    final isLiked = currentUserId != null && post.likes.contains(currentUserId);
    final likeNotifier = ref.watch(likePostProvider(post.id).notifier);
    final deleteNotifier = ref.watch(deletePostProvider(post.id).notifier);

    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and timestamp
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    post.userName[0].toUpperCase(),
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(post.designation??''),
                      Text(
                        _formatTimeAgo(post.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentUserId == post.userId)
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Delete Post'),
                        onTap: () => deleteNotifier.deletePost(),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 12),
            // Post content
            Text(
              post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Like and comment buttons
            Row(
              children: [
                // Like button
                InkWell(
                  onTap: () => likeNotifier.toggleLike(),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text('${post.likesCount}'),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                // Comment button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(postId: post.id),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.comment, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${post.commentsCount}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${date.day}/${date.month}/${date.year}';
  }
}