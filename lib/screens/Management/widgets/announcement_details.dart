import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/announcement_model.dart';
import '../../../models/announcement_comment_model.dart';
import '../../../providers/riverpods/management_provider.dart';

class AnnouncementDetails extends ConsumerStatefulWidget {
  final AnnouncementModel model;
  const AnnouncementDetails({super.key, required this.model});

  @override
  ConsumerState<AnnouncementDetails> createState() => _AnnouncementDetailsState();
}

class _AnnouncementDetailsState extends ConsumerState<AnnouncementDetails> {
  final TextEditingController _commentController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Small delay to ensure widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComments();
      _isInitialized = true;
    });
  }

  Future<void> _loadComments() async {
    // Set loading state
    ref.read(isLoadingCommentsProvider.notifier).state = true;

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getData(
          'api/Support/GetAnnouncementDetails/${widget.model.announcementId}'
      );

      debugPrint('API Response: $response');

      if (response != null &&
          response['data'] != null &&
          response['data']['Comments'] != null) {

        final List<AnnouncementCommentModel> loadedComments = [];

        for (var item in response['data']['Comments']) {
          loadedComments.add(AnnouncementCommentModel(
            commentId: item['CommentId'],
            userId: item['UserId'] ?? '',
            userName: item['UserName'] ?? '',
            commentText: item['CommentText'] ?? '',
            parentCommentId: item['ParentCommentId'],
            createdAt: item['CreatedAt'] ?? '',
          ));
        }

        debugPrint('Loaded ${loadedComments.length} comments');

        // Update comments list
        ref.read(commentsListProvider.notifier).state = loadedComments;
      } else {
        debugPrint('No comments found in response');
        ref.read(commentsListProvider.notifier).state = [];
      }
    } catch (e) {
      print('Error loading comments: $e');
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load comments: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      ref.read(isLoadingCommentsProvider.notifier).state = false;
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final userId = DashboardHelpers.currentUser!.iDnum;
    final userName = DashboardHelpers.currentUser!.userName;

    if (userId == null || userName == null) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Set posting state
    ref.read(isPostingCommentProvider.notifier).state = true;

    try {
      final apiService = ref.read(apiServiceProvider);
      final comment = {
        "announcementId": widget.model.announcementId!,
        "userId": userId,
        "userName": userName,
        "commentText": _commentController.text.trim(),
        "parentCommentId": widget.model.announcementId,
      };

      await apiService.postData(
        'api/Support/AddComment',
        comment,
      );

      // Clear text field
      _commentController.clear();

      // Refresh comments
      await _loadComments();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment posted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post comment: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      ref.read(isPostingCommentProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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

  Widget _buildCommentTile(AnnouncementCommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getAvatarColor(comment.userName ?? 'A'),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(comment.userName ?? 'A'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.userName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.commentText ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        // Handle like
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.reply_outlined,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        // Handle reply
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'A';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    final index = name.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
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

  @override
  Widget build(BuildContext context) {
    // Watch the providers
    final comments = ref.watch(commentsListProvider);
    final isLoading = ref.watch(isLoadingCommentsProvider);
    final isPosting = ref.watch(isPostingCommentProvider);

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
                            count: 124,
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

                    // Loading State
                    if (isLoading && _isInitialized)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )

                    // Comments List
                    else if (comments.isNotEmpty)
                      ...comments.map((comment) => _buildCommentTile(comment))

                    // Empty State
                    else
                      _buildEmptyComments(),
                  ],
                ),
              ),
            ),
          ),

          // Comment Input Section
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
                      suffixIcon: isPosting
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
                if (_commentController.text.isEmpty && !isPosting)
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
}