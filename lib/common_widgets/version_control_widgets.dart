import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_version.dart';
import '../providers/riverpods/notification_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateWidget extends ConsumerWidget {
  const UpdateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final hasNewBuild = ref.watch(newBuildProvider);

    return hasNewBuild.when(
      data: (show) {
        if (!show) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => _openDownload(ref),
          child: Container(
            color: Colors.orange,
            padding: const EdgeInsets.all(12),
            child: const Row(
              children: [
                Icon(Icons.download, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Tap to download new version',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _openDownload(WidgetRef ref) async {
    final versions = await ref.read(versionCheckProvider.future);
    final checker = VersionChecker();
    final highestBuild = checker.getHighestBuild(versions);


    // Open Google Drive link (replace with your link)
    await launchUrl(Uri.parse(versions.last.link??'')).then((v) async {
      // Save as seen
      if (highestBuild != null) {
        await checker.saveBuild(highestBuild);
        ref.invalidate(newBuildProvider);
      }
    });
  }
}


class VersionChecker {
  static const String _lastBuildKey = 'last_build';

  // Get highest build number from list
  String? getHighestBuild(List<AppVersion> versions) {
    if (versions.isEmpty) return null;

    int highest = 0;
    String? highestBuild;

    for (var version in versions) {
      int build = int.tryParse(version.buildNumber ?? '0') ?? 0;
      if (build > highest) {
        highest = build;
        highestBuild = version.buildNumber;
      }
    }

    return highestBuild;
  }

  // Save build number
  Future<void> saveBuild(String buildNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastBuildKey, buildNumber);
  }

  // Check if new build available
  Future<bool> hasNewBuild(List<AppVersion> versions) async {
    final highest = getHighestBuild(versions);
    if (highest == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_lastBuildKey);

    if (saved == null) {
      await saveBuild(highest);
      return false;
    }

    return int.parse(highest) > int.parse(saved);
  }
}


const platform = MethodChannel('app.version.channel');
