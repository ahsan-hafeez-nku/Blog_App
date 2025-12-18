import 'package:blog_app/core/font/app_font.dart';
import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.isNoInternet,
    required this.message,
    required this.onRetry,
  });

  final bool isNoInternet;
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isNoInternet
                    ? Colors.orange.shade50
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNoInternet
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline_rounded,
                size: 64,
                color: isNoInternet
                    ? Colors.orange.shade400
                    : Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 24),

            // Error Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.bold20(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              isNoInternet
                  ? 'Please check your connection and try again'
                  : 'Something went wrong. Please try again',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),

            const SizedBox(height: 12),

            // Retry Button
            TextButton.icon(
              onPressed: onRetry,

              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                // backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
