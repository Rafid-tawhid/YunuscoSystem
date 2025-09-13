import 'package:flutter/material.dart';

class PaginationBox extends StatelessWidget {
  final int totalItems;
  final int currentPage;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const PaginationBox({
    Key? key,
    required this.totalItems,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total pages
    final totalPages = (totalItems / itemsPerPage).ceil();

    // If there's only 1 page, don't show pagination
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          if (currentPage > 1)
            _buildPageButton(
              icon: Icons.chevron_left,
              onPressed: () => onPageChanged(currentPage - 1),
            ),

          // Page numbers
          ..._generatePageNumbers(totalPages).map((page) {
            return _buildPageNumber(
              page: page,
              isCurrent: page == currentPage,
              onPressed: () => onPageChanged(page),
            );
          }),

          // Next button
          if (currentPage < totalPages)
            _buildPageButton(
              icon: Icons.chevron_right,
              onPressed: () => onPageChanged(currentPage + 1),
            ),
        ],
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildPageNumber({
    required int page,
    required bool isCurrent,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isCurrent ? Colors.blue : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: isCurrent ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: Text(
              page.toString(),
              style: TextStyle(
                color: isCurrent ? Colors.white : Colors.blue,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<int> _generatePageNumbers(int totalPages) {
    final List<int> pages = [];
    const int maxVisiblePages = 7; // Maximum pages to show

    if (totalPages <= maxVisiblePages) {
      // Show all pages
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      // Show limited pages with ellipsis
      if (currentPage <= 4) {
        // Show first 5 pages and last page
        for (int i = 1; i <= 5; i++) {
          pages.add(i);
        }
        pages.add(-1); // Ellipsis
        pages.add(totalPages);
      } else if (currentPage >= totalPages - 3) {
        // Show first page and last 5 pages
        pages.add(1);
        pages.add(-1); // Ellipsis
        for (int i = totalPages - 4; i <= totalPages; i++) {
          pages.add(i);
        }
      } else {
        // Show first page, current page with neighbors, and last page
        pages.add(1);
        pages.add(-1); // Ellipsis
        for (int i = currentPage - 1; i <= currentPage + 1; i++) {
          pages.add(i);
        }
        pages.add(-1); // Ellipsis
        pages.add(totalPages);
      }
    }

    return pages;
  }
}