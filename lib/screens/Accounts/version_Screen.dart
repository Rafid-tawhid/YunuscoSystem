// widgets/version_alert_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/providers/riverpods/notification_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/app_version.dart';

class VersionsScreen extends ConsumerWidget {
  const VersionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync = ref.watch(versionCheckProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Available Versions'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: versionsAsync.when(
        data: (versions) {
          // Sort by build number descending (newest first)
          versions.sort((a, b) {
            int aBuild = int.tryParse(a.buildNumber ?? '0') ?? 0;
            int bBuild = int.tryParse(b.buildNumber ?? '0') ?? 0;
            return bBuild.compareTo(aBuild);
          });

          return ListView.builder(
            itemCount: versions.length,
            itemBuilder: (context, index) {
              final version = versions[index];
              return VersionItem(version: version);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              const Text('Failed to load versions'),
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class VersionItem extends StatelessWidget {
  final AppVersion version;

  const VersionItem({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildCard(context),

        // Show NEW badge if mandatory
        if (version.isMandatory == true)
          Positioned(
            right: 20,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Text(
                "NEW",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  //
  Widget _buildCard(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.android),
        title: Text(
          'Version ${version.version}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build: ${version.buildNumber}'),
            if (version.releaseDate != null)
              Text('Released: ${version.releaseDate}'),
            if (version.description != null)
              Text(version.description!),
          ],
        ),
        trailing: version.link != null
            ? IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _downloadVersion(version.link!),
        )
            : null,
        onTap: version.link != null
            ? () => _downloadVersion(version.link!)
            : null,
      ),
    );
  }

  void _downloadVersion(String link) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
