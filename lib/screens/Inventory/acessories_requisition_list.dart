import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/accessories_issuee_model.dart';
import '../../models/accessories_req_details.dart';
import '../../providers/riverpods/inventory_provider.dart';
import 'accessories_req_details.dart';

// Search provider for accessories issues screen
final accessoriesIssuesSearchProvider = StateProvider<String>((ref) => '');

class AccessoriesIssuesScreen extends ConsumerStatefulWidget {
  const AccessoriesIssuesScreen({super.key});

  @override
  ConsumerState<AccessoriesIssuesScreen> createState() =>
      _AccessoriesIssuesScreenState();
}

class _AccessoriesIssuesScreenState
    extends ConsumerState<AccessoriesIssuesScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(accessoriesIssuesSearchProvider.notifier).state =
        _searchController.text;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _searchFocusNode.requestFocus();
        });
      } else {
        _searchController.clear();
        ref.read(accessoriesIssuesSearchProvider.notifier).state = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final issuesAsync = ref.watch(accessoriesRequisitionProvider);
    final searchQuery = ref.watch(accessoriesIssuesSearchProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(searchQuery.isNotEmpty),
      body: issuesAsync.when(
        data: (issuesList) {
          if (issuesList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No accessories issues found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Filter the list based on search query
          final filteredList = _filterIssues(issuesList, searchQuery);

          if (filteredList.isEmpty && searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No results for "$searchQuery"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      ref.read(accessoriesIssuesSearchProvider.notifier).state = '';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Clear Search'),
                  ),
                ],
              ),
            );
          }

          // Show search results info
          final displayList =
          searchQuery.isEmpty ? issuesList : filteredList;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(accessoriesRequisitionProvider);
            },
            child: Column(
              children: [
                // Search results header
                if (searchQuery.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: Colors.grey.shade50,
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${filteredList.length} result${filteredList.length == 1 ? '' : 's'} found',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            ref.read(accessoriesIssuesSearchProvider.notifier).state = '';
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),

                // Issues list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayList.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final issue = displayList[index];
                      return _IssueCard(issue: issue);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Failed to load data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(accessoriesRequisitionProvider),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool hasSearchQuery) {
    if (_isSearching) {
      return AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _toggleSearch,
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search by code, requisition, remarks...',
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                _searchController.clear();
                ref.read(accessoriesIssuesSearchProvider.notifier).state = '';
              },
            )
                : null,
          ),
        ),
      );
    } else {
      return AppBar(
        title: const Text('Accessories Issues'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(accessoriesRequisitionProvider),
          ),
          if (hasSearchQuery)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                ref.read(accessoriesIssuesSearchProvider.notifier).state = '';
              },
              tooltip: 'Clear search',
            ),
        ],
      );
    }
  }

  // Filter function to search in issues list
  List<AccessoriesIssueeModel> _filterIssues(
      List<AccessoriesIssueeModel> issuesList,
      String query,
      ) {
    if (query.isEmpty) return issuesList;

    final lowerCaseQuery = query.toLowerCase();

    return issuesList.where((issue) {
      return _matchesSearch(issue, lowerCaseQuery);
    }).toList();
  }

  bool _matchesSearch(AccessoriesIssueeModel issue, String query) {
    // Search in multiple fields
    return (issue.issueCode?.toLowerCase().contains(query) ?? false) ||
        (issue.requisitionCode?.toLowerCase().contains(query) ?? false) ||
        (issue.remarks?.toLowerCase().contains(query) ?? false) ||
        (issue.slipNo?.toString().toLowerCase().contains(query) ?? false) ||
        (issue.date?.toLowerCase().contains(query) ?? false) ||
        (issue.createdDate?.toLowerCase().contains(query) ?? false);
  }
}

class _IssueCard extends StatelessWidget {
  final AccessoriesIssueeModel issue;

  const _IssueCard({required this.issue});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AccessoriesReqDetailsScreen(
              id: issue.issueId.toString(),
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Issue Code and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      issue.issueCode ?? 'No Code',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                      issue.isReturn == true ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      issue.isReturn == true ? 'Return' : 'Issue',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Main Details
              _buildDetailRow('Requisition', issue.requisitionCode),
              _buildDetailRow('Date', _formatDate(issue.date)),

              if (issue.hasSlipNo)
                _buildDetailRow('Slip No', issue.slipNo.toString()),

              if (issue.hasRemarks)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Remarks:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      issue.remarks!,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

              // Footer with creation info
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300], height: 1),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${issue.issueId ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (issue.createdDate != null)
                    Text(
                      'Created: ${_formatDate(issue.createdDate!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}