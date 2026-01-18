import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/riverpods/employee_provider.dart';
import '../../../utils/colors.dart';

class EmpSingleEvaluationList extends ConsumerStatefulWidget {
  final String idCard;
  const EmpSingleEvaluationList({super.key, required this.idCard});

  @override
  ConsumerState<EmpSingleEvaluationList> createState() => _EmpSingleEvaluationListState();
}

class _EmpSingleEvaluationListState extends ConsumerState<EmpSingleEvaluationList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employerSingleEvaluationList.notifier).getSingleValue(widget.idCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final evaluationsState = ref.watch(employerSingleEvaluationList);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Performance Evaluations',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: evaluationsState.when(
        data: (evaluations) {
          if (evaluations.isEmpty) {
            return _buildEmptyState();
          }
          return _buildEvaluationsList(evaluations);
        },
        loading: () => _buildLoadingState(),
        error: (e, _) => _buildErrorState(e.toString()),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Evaluations Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This employee has no performance evaluations yet.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading Evaluations...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Evaluations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(employerSingleEvaluationList.notifier).getSingleValue(widget.idCard);
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationsList(List<dynamic> evaluations) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(employerSingleEvaluationList.notifier).getSingleValue(widget.idCard);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: evaluations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final eval = evaluations[index];
          return _buildEvaluationCard(eval, index);
        },
      ),
    );
  }

  Widget _buildEvaluationCard(dynamic eval, int index) {
    final averageScore = _calculateAverageScore(eval);
    final overallRating = _getOverallRating(averageScore);
    final ratingColor = _getRatingColor(overallRating);

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with evaluation number and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Evaluation #${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ratingColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ratingColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    overallRating,
                    style: TextStyle(
                      color: ratingColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(eval.ratingDate),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Overall score
            _buildScoreSection(averageScore),
            const SizedBox(height: 16),

            // Rating categories in grid
            _buildRatingGrid(eval),
            const SizedBox(height: 16),

            // Comments and Goals
            if (eval.comments != null && eval.comments!.isNotEmpty)
              _buildCommentSection('Comments', eval.comments!),
            if (eval.goals != null && eval.goals!.isNotEmpty)
              _buildCommentSection('Goals for Next Period', eval.goals!),

            // Reviewed by
            if (eval.reviewedBy != null && eval.reviewedBy!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Reviewed by: ${eval.reviewedBy!}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(double averageScore) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('Overall Score', '${averageScore.toStringAsFixed(1)}/5.0'),
          Container(width: 1, height: 30, color: Colors.blue[200]),
          _buildScoreItem('Percentage', '${(averageScore * 20).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingGrid(dynamic eval) {
    final ratings = [
      {'label': 'Quality of Work', 'value': eval.qualityOfWork, 'icon': Icons.work_outline},
      {'label': 'Productivity', 'value': eval.productivity, 'icon': Icons.trending_up_outlined},
      {'label': 'Technical Skills', 'value': eval.technicalSkills, 'icon': Icons.computer_outlined},
      {'label': 'Communication', 'value': eval.communication, 'icon': Icons.chat_outlined},
      {'label': 'Teamwork', 'value': eval.teamwork, 'icon': Icons.group_outlined},
      {'label': 'Problem Solving', 'value': eval.problemSolving, 'icon': Icons.lightbulb_outline},
      {'label': 'Initiative', 'value': eval.initiative, 'icon': Icons.rocket_launch_outlined},
      {'label': 'Attendance', 'value': eval.attendance, 'icon': Icons.calendar_today_outlined},
      {'label': 'Adaptability', 'value': eval.adaptability, 'icon': Icons.autorenew_outlined},
      {'label': 'Leadership', 'value': eval.leadership, 'icon': Icons.leaderboard_outlined},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final rating = ratings[index];
        return _buildRatingItem(
          rating['label'] as String,
          rating['value'] as double,
          rating['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildRatingItem(String label, double value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: myColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: myColors.primaryColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getScoreColor(value),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      size: 14,
                      color: _getScoreColor(value),
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

  Widget _buildCommentSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageScore(dynamic eval) {
    final scores = [
      eval.qualityOfWork,
      eval.productivity,
      eval.technicalSkills,
      eval.communication,
      eval.teamwork,
      eval.problemSolving,
      eval.initiative,
      eval.attendance,
      eval.adaptability,
      eval.leadership,
    ];
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  String _getOverallRating(double score) {
    if (score >= 4.5) return 'Excellent';
    if (score >= 4.0) return 'Very Good';
    if (score >= 3.5) return 'Good';
    if (score >= 3.0) return 'Satisfactory';
    if (score >= 2.5) return 'Needs Improvement';
    return 'Unsatisfactory';
  }

  Color _getRatingColor(String rating) {
    switch (rating) {
      case 'Excellent':
        return Colors.green;
      case 'Very Good':
        return Colors.lightGreen;
      case 'Good':
        return Colors.blue;
      case 'Satisfactory':
        return Colors.orange;
      case 'Needs Improvement':
        return Colors.orangeAccent;
      case 'Unsatisfactory':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 4.0) return Colors.green;
    if (score >= 3.0) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}