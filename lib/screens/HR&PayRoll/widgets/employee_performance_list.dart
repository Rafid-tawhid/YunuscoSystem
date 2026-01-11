// screens/performance_ratings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/models/emp_performance_rating_model.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../../providers/riverpods/employee_provider.dart';
import 'emp_single_performance_list.dart';

class PerformanceRatingsScreen extends ConsumerStatefulWidget {
  const PerformanceRatingsScreen({super.key});

  @override
  ConsumerState<PerformanceRatingsScreen> createState() => _PerformanceRatingsScreenState();
}

class _PerformanceRatingsScreenState extends ConsumerState<PerformanceRatingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(performanceRatingProvider.notifier).fetchPerformanceRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final performanceRatingsAsync = ref.watch(performanceRatingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Employee Performance Ratings'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(performanceRatingProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: performanceRatingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorWidget(error.toString()),
        data: (ratings) => _buildRatingsList(ratings),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              'Failed to load performance ratings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(performanceRatingProvider.notifier).refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColors.primaryColor,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsList(List<EmpPerformanceRatingModel> ratings) {
    if (ratings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No performance ratings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(performanceRatingProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          final rating = ratings[index];
          return _buildRatingCard(rating);
        },
      ),
    );
  }

  Widget _buildRatingCard(EmpPerformanceRatingModel rating) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EmpSingleEvaluationList(idCard: rating.idCardNo??'',)));
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Info Row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: myColors.primaryColor.withOpacity(0.1),
                    child: Text(
                      _getInitials(rating.fullName ?? 'N/A'),
                      style: TextStyle(
                        color: myColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rating.fullName ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (rating.designationName != null)
                          Text(
                            rating.designationName!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRatingColor(rating.averageRatingPercentage ?? 0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${(rating.averageRatingPercentage ?? 0).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Department and Reviews
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (rating.departmentName != null)
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.departmentName!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                  Row(
                    children: [
                      Icon(
                        Icons.rate_review,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${rating.totalReviews ?? 0} reviews',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Employee ID
              Text(
                'ID: ${rating.idCardNo ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 8),

              // Rating Progress Bar
              LinearProgressIndicator(
                value: (rating.averageRatingPercentage ?? 0) / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getRatingColor(rating.averageRatingPercentage ?? 0),
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(num percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return 'N/A';
  }
}