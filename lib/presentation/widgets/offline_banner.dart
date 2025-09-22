// lib/presentation/widgets/offline_banner.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});
  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((status) {
      setState(() {
        _isOffline = status == ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: const Text('You are offline — showing cached posts',
          style: TextStyle(color: Colors.white)),
    );
  }
}
