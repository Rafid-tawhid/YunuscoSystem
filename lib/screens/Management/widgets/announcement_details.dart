import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/announcement_model.dart';
import '../../../providers/riverpods/management_provider.dart';
import 'comments_tile.dart';

class AnnouncementDetails extends ConsumerStatefulWidget {
  final AnnouncementModel model;
  const AnnouncementDetails({super.key, required this.model});

  @override
  ConsumerState<AnnouncementDetails> createState() => _AnnouncementDetailsState();
}

class _AnnouncementDetailsState extends ConsumerState<AnnouncementDetails> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load comments when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentsProvider.notifier).loadComments(widget.model.announcementId!);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    // Optional: Clear comments when leaving screen
    ref.read(commentsProvider.notifier).clearComments();
    super.dispose();
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final userId = DashboardHelpers.currentUser!.iDnum;
    final userName = DashboardHelpers.currentUser!.userName;

    if (userId == null || userName == null) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Post comment using Riverpod
    await ref.read(postCommentProvider(
      PostCommentParams(
        announcementId: widget.model.announcementId!,
        userId: userId,
        userName: userName,
        commentText: _commentController.text.trim(),
      ),
    ).future);

    // Clear text field
    _commentController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment posted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider);
    final postCommentAsync = ref.watch(postCommentProvider(
      PostCommentParams(
        announcementId: widget.model.announcementId!,
        userId: DashboardHelpers.currentUser!.iDnum ?? '',
        userName: DashboardHelpers.currentUser!.userName ?? '',
        commentText: _commentController.text.trim(),
      ),
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Announcement Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Announcement Details Card
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Chip
                    if (widget.model.category != null && widget.model.category!.isNotEmpty)
                      Chip(
                        label: Text(
                          widget.model.category!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      widget.model.title ?? 'No Title',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Meta Information
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.model.createdBy ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(widget.model.publishDate),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        widget.model.description ?? 'No description available',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            icon: Icons.comment_outlined,
                            count: widget.model.commentCount ?? comments.length,
                            label: 'Comments',
                          ),
                          _buildStatItem(
                            icon: Icons.favorite_outline,
                            count: widget.model.reactionCount ?? 0,
                            label: 'Reactions',
                          ),
                          _buildStatItem(
                            icon: Icons.visibility_outlined,
                            count: 124, // Example view count
                            label: 'Views',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Comments Section Header
                    Row(
                      children: [
                        Text(
                          'Comments',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            comments.length.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Comments List
                    if (comments.isEmpty)
                      _buildEmptyComments()
                    else
                      ...comments.map((comment) => CommentTile(
                        comment: comment,
                        onLike: () {
                          // Handle like
                        },
                        onReply: () {
                          // Handle reply - you could focus the text field and set it to reply mode
                        },
                      )),
                  ],
                ),
              ),
            ),
          ),

          // Comment Input Section with loading state
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      suffixIcon: postCommentAsync.isLoading
                          ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                          : _commentController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _postComment,
                        color: Theme.of(context).primaryColor,
                      )
                          : null,
                    ),
                    onSubmitted: (_) => _postComment(),
                    textInputAction: TextInputAction.send,
                    maxLines: null,
                  ),
                ),
                if (_commentController.text.isEmpty && !postCommentAsync.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: _postComment,
                      icon: Icon(
                        Icons.send,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required num count,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyComments() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.comment_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}