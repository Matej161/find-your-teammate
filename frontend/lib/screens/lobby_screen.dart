import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/squad.dart';
import '../widgets/slideable_message.dart';
import '../widgets/navbar_widget.dart';

class LobbyMessage {
  final String userId;
  final String content;
  final DateTime timestamp;

  LobbyMessage({
    required this.userId,
    required this.content,
    required this.timestamp,
  });
}

class LobbyScreen extends StatefulWidget {
  final Squad squad;
  final String gameName;

  const LobbyScreen({
    super.key,
    required this.squad,
    required this.gameName,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  static const Color brandBlue = Color(0xFF1E88E5);
  static const Color brandNavy = Color(0xFF102060);
  static const Color iceBackground = Color(0xFFE8F1F9);
  
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<LobbyMessage> _lobbyMessages = [];
  final String _currentUserId = "You"; // TODO: Get from auth
  bool _isLobbyInfoExpanded = false;

  Future<bool> _onWillPop() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Leave Lobby?',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: brandNavy,
            ),
          ),
          content: Text(
            'Leaving will remove you from the lobby. Are you sure you want to proceed?',
            style: GoogleFonts.quicksand(color: brandNavy),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.quicksand(color: brandNavy),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Leave',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLeave == true) {
      // Navigate back to game server screen
      Navigator.of(context).pop();
      return false; // Prevent default back action
    }
    return false; // Prevent default back action
  }

  void _sendLobbyMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _lobbyMessages.add(LobbyMessage(
          userId: _currentUserId,
          content: _chatController.text,
          timestamp: DateTime.now(),
        ));
      });
      _chatController.clear();
      
      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: iceBackground,
        appBar: NavbarWidget(
          title: widget.squad.title.toUpperCase(),
          showBackButton: true,
          onBackPressed: () async {
            await _onWillPop();
          },
          userId: "",
        ),
        body: Column(
          children: [
            // Expandable Lobby Info Section
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              color: Colors.white,
              child: Column(
                children: [
                  // Always visible header
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isLobbyInfoExpanded = !_isLobbyInfoExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: brandBlue, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Lobby Info',
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: brandNavy,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F8FA),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.squad.rank,
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          color: brandNavy,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: brandBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${widget.squad.currentPlayers}/${widget.squad.maxPlayers} Players',
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          color: brandBlue,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.squad.description.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.squad.description.length > 60
                                        ? '${widget.squad.description.substring(0, 60)}...'
                                        : widget.squad.description,
                                    style: GoogleFonts.quicksand(
                                      color: const Color(0xFF666666),
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            _isLobbyInfoExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: brandBlue,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expandable content
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Color(0xFFD0E0F0)),
                          const SizedBox(height: 12),
                          // Players List
                          Text(
                            'Players',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: brandNavy,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Current player
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: brandBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person, color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'You (Host)',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Empty slots
                              ...List.generate(
                                widget.squad.maxPlayers - widget.squad.currentPlayers,
                                (index) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F8FA),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFD0E0F0)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.person_outline, color: Colors.grey[600], size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Empty',
                                        style: GoogleFonts.quicksand(
                                          color: const Color(0xFF999999),
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: _isLobbyInfoExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
            // Chat Section
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _lobbyMessages.isEmpty
                        ? Center(
                            child: Text(
                              "No messages yet.\nStart the conversation!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(color: brandNavy),
                            ),
                          )
                        : ListView.builder(
                            controller: _chatScrollController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            itemCount: _lobbyMessages.length,
                            itemBuilder: (context, index) {
                              final message = _lobbyMessages[index];
                              final isMe = message.userId == _currentUserId;
                              return Align(
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: SlideableMessage(
                                    content: message.content,
                                    userId: isMe ? "You" : message.userId,
                                    timestamp: message.timestamp,
                                    isMe: isMe,
                                    backgroundColor: isMe ? brandBlue : Colors.white,
                                    textColor: isMe ? Colors.white : brandNavy,
                                    brandNavy: brandNavy,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  // Chat input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xFFD0E0F0))),
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              style: GoogleFonts.quicksand(color: brandNavy),
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendLobbyMessage(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_rounded, color: brandBlue),
                            onPressed: _sendLobbyMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
