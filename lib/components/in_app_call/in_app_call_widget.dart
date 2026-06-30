import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppCallWidget extends StatelessWidget {
  const InAppCallWidget({
    super.key,
    required this.phoneNumber,
    this.channelName = '',
    this.callerName = '',
    this.receiverName = '',
    this.token = '',
  });

  final String phoneNumber;
  final String channelName;
  final String callerName;
  final String receiverName;
  final String token;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
      if (context.mounted) Navigator.of(context).pop();
    });
    return const SizedBox.shrink();
  }
}
