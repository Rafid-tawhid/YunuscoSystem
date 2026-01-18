import 'package:flutter/material.dart';

class DashboardMenuItem {
  final String name;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;
  final VoidCallback onTap;

  DashboardMenuItem({
    required this.name,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
    required this.onTap,
  });
}

class ReusableDashboardCard extends StatelessWidget {
  final DashboardMenuItem menu;

  const ReusableDashboardCard({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: menu.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: menu.onTap,
          splashColor: menu.iconColor.withOpacity(0.2),
          highlightColor: menu.iconColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: menu.icon==Icons.workspace_premium?Colors.white: menu.iconColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    menu.icon,
                    size: 32,
                    color: menu.iconColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  menu.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
