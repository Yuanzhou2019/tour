import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sightour/core/theme/app_theme.dart';

/// Placeholder home page for Stage 0 scaffold.
///
/// The real Prepare / Map / Discover / Tools / You tabs land in Stage 1+.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sightour'),
      ),
      body: Center(
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snap) {
            final String version = snap.data?.version ?? '0.0.0';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sightour scaffold ready',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'v$version',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.slate500,
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
