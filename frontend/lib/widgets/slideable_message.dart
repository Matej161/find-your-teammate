import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SlideableMessage extends StatefulWidget {
  final String content;
  final String userId;
  final DateTime timestamp;
  final bool isMe;
  final Color backgroundColor;
  final Color textColor;
  final Color brandNavy;

  const SlideableMessage({
    super.key,
    required this.content,
    required this.userId,
    required this.timestamp,
    required this.isMe,
    required this.backgroundColor,
    required this.textColor,
    required this.brandNavy,
  });

  @override
  State<SlideableMessage> createState() => _SlideableMessageState();
}

class _SlideableMessageState extends State<SlideableMessage> {
  double _dragOffset = 0.0;

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isMe) {
      // For right-aligned messages, drag left (negative)
      if (details.delta.dx < 0) {
        setState(() {
          _dragOffset = (_dragOffset + details.delta.dx).clamp(-50.0, 0.0);
        });
      }
    } else {
      // For left-aligned messages, drag right (positive)
      if (details.delta.dx > 0) {
        setState(() {
          _dragOffset = (_dragOffset + details.delta.dx).clamp(0.0, 50.0);
        });
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final animatedOffset = _dragOffset;

    return Stack(
      children: [
        // Timestamp background
        if (animatedOffset.abs() > 5)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  _formatTime(widget.timestamp),
                  style: GoogleFonts.quicksand(
                    fontSize: 11,
                    color: widget.brandNavy.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        // Message bubble
        Transform.translate(
          offset: Offset(animatedOffset, 0),
          child: GestureDetector(
            onHorizontalDragUpdate: _onPanUpdate,
            onHorizontalDragEnd: _onPanEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(15).copyWith(
                  bottomRight: widget.isMe ? const Radius.circular(0) : const Radius.circular(15),
                  bottomLeft: !widget.isMe ? const Radius.circular(0) : const Radius.circular(15),
                ),
                border: widget.isMe ? null : Border.all(color: const Color(0xFFD0E0F0)),
              ),
              child: Column(
                crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Show sender name for all messages
                  Text(
                    widget.userId,
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: widget.isMe ? Colors.white.withOpacity(0.8) : widget.brandNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.content,
                    style: GoogleFonts.quicksand(
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
