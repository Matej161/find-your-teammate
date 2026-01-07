import 'package:flutter/material.dart';

class GameSelectionWidget extends StatelessWidget {
  final String name;
  final String bannerUrl;
  final VoidCallback onTap;

  const GameSelectionWidget({
    super.key,
    required this.name,
    required this.bannerUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. THE BANNER (Full visibility)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bannerUrl,
                  fit: BoxFit.cover,
                  // Added a grey icon for broken images so it's not just blank
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
          ),

          // 2. THE TEXT (Just the game title now)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: Text(
              name,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF102060), // Match the brand Navy
              ),
            ),
          ),
        ],
      ),
    );
  }
}