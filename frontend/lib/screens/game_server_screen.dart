import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Message.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navbar_widget.dart';
import '../models/squad.dart';
import '../SignalRContracts.dart';
import '../widgets/slideable_message.dart';
import 'lobby_screen.dart';

class GameServerScreen extends StatefulWidget {
  final String gameName;
  final String guid;
  const GameServerScreen({super.key, required this.gameName, required this.guid});

  @override
  State<GameServerScreen> createState() => _GameServerScreenState();
}

class _GameServerScreenState extends State<GameServerScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // 1. ADDED: ScrollController to handle auto-scrolling
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  
  final SignalRContracts _signalRContracts = SignalRContracts();
  final Map<String, String> gamesId = {
    "League of Legends": "00000000-0000-0000-0000-000000000001",
    "Fortnite": "00000000-0000-0000-0000-000000000002",
    "Minecraft": "00000000-0000-0000-0000-000000000003",
    "Rocket League": "00000000-0000-0000-0000-000000000004",
    "Valorant": "00000000-0000-0000-0000-000000000005",
    "Counter-Strike 2": "00000000-0000-0000-0000-000000000006",
    "Overwatch 2": "00000000-0000-0000-0000-000000000007",
    "Apex Legends": "00000000-0000-0000-0000-000000000008",
  };
  List<Message> messages = List.empty();
  // Store squads per channel - each game has its own list
  final Map<String, List<Squad>> _squadsByChannel = {};
  String channelId = "";

  // Get squads for current channel
  List<Squad> get squads => _squadsByChannel[channelId] ?? [];


  // 2. UPDATED: Send logic now triggers the scroll
  void _sendMessage() async {
    if (_chatController.text.isNotEmpty) {
      print(widget.guid);
      await _signalRContracts.sendMessage(channelId, _chatController.text, widget.guid);
      loadMessages();

      // Auto-scroll to bottom after the message is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void loadMessages() async {
    try {
      // 1. Zavoláš funkci s await
      final history = await _signalRContracts.getChatHistory(channelId);

      // 2. Aktualizuješ stav aplikace, aby se zprávy vykreslily
      setState(() {
        messages = history;
      });
    } catch (e) {
      print("Chyba při přiřazování zpráv: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes to show/hide button
    });
    init();
  }

  void init() async {
    channelId = gamesId[widget.gameName] ?? "";
    await _signalRContracts.connect();
    loadMessages();
    // Initialize empty squad list for this channel if it doesn't exist
    if (!_squadsByChannel.containsKey(channelId)) {
      _squadsByChannel[channelId] = [];
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Clean up controller
    _chatController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF1E88E5);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F9),
      appBar: NavbarWidget(title: widget.gameName.toUpperCase()),
      
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              //border: Border(bottom: BorderSide(color: Color(0xFFD0E0F0), width: 1.0)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: brandBlue,
              indicatorColor: brandBlue,
              labelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'GLOBAL CHAT', icon: Icon(Icons.public, size: 20)),
                Tab(text: 'ACTIVE SQUADS', icon: Icon(Icons.groups, size: 20)),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGlobalChat(),
                    _buildSquadList(),
                  ],
                ),
                // CREATE SQUAD button only on Active Squads tab
                if (_tabController.index == 1)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () => _showCreateSquadDialog(context),
                      backgroundColor: brandBlue,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: Text("CREATE SQUAD", style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalChat() {
    const Color brandNavy = Color(0xFF102060);
    const Color brandBlue = Color(0xFF1E88E5);

    return Column(
      children: [
        Expanded(
          child: messages.isEmpty 
          ? Center(child: Text("Be the first to send a message!", style: GoogleFonts.quicksand(color: brandNavy)))
          : ListView.builder(
              controller: _scrollController, // Link the controller here
              // 4. FIXED: Bottom padding in list prevents last message from being hidden by button
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 150), 
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.userId == widget.guid;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: SlideableMessage(
                      content: message.content,
                      userId: isMe ? "You" : (message.username ?? "Unknown"),
                      timestamp: message.timeSent,
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
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                // 5. FIXED: Icon added back
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: brandBlue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSquadList() {
    const Color brandNavy = Color(0xFF102060);
    
    if (squads.isEmpty) {
      return Center(
        child: Text(
          "No active squads yet.\nBe the first to create one!",
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(color: brandNavy, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Added padding for button at bottom right
      itemCount: squads.length,
      itemBuilder: (context, index) {
        final squad = squads[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              squad.title, 
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, 
                color: brandNavy,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "${squad.currentPlayers}/${squad.maxPlayers} Players • ${squad.rank}", 
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1E88E5)),
            onTap: () {
              _showSquadDetailsDialog(context, squad);
            },
          ),
        );
      },
    );
  }

  void _showCreateSquadDialog(BuildContext context) {
    const Color brandBlue = Color(0xFF1E88E5);
    const Color brandNavy = Color(0xFF102060);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _CreateSquadDialog(
          onSquadCreated: (Squad squad) {
            setState(() {
              if (!_squadsByChannel.containsKey(channelId)) {
                _squadsByChannel[channelId] = [];
              }
              _squadsByChannel[channelId]!.add(squad);
            });
            // Navigate to lobby screen after creating
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LobbyScreen(
                  squad: squad,
                  gameName: widget.gameName,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSquadDetailsDialog(BuildContext context, Squad squad) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _SquadDetailsDialog(
          squad: squad,
          gameName: widget.gameName,
        );
      },
    );
  }
}

// Separate StatefulWidget for the dialog to properly manage controllers
class _CreateSquadDialog extends StatefulWidget {
  final Function(Squad) onSquadCreated;

  const _CreateSquadDialog({required this.onSquadCreated});

  @override
  State<_CreateSquadDialog> createState() => _CreateSquadDialogState();
}

class _CreateSquadDialogState extends State<_CreateSquadDialog> {
  late TextEditingController titleController;
  late TextEditingController rankController;
  late TextEditingController maxPlayersController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    rankController = TextEditingController();
    maxPlayersController = TextEditingController(text: '5');
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    rankController.dispose();
    maxPlayersController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _createSquad() {
    if (titleController.text.isEmpty || 
        rankController.text.isEmpty ||
        maxPlayersController.text.isEmpty) {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: GoogleFonts.quicksand(),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    
    final maxPlayers = int.tryParse(maxPlayersController.text);
    if (maxPlayers == null || maxPlayers < 2 || maxPlayers > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a number between 2 and 10 players',
            style: GoogleFonts.quicksand(),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    
    // Create new squad locally
    final newSquad = Squad(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      rank: rankController.text,
      currentPlayers: 1, // Creator is the first player
      maxPlayers: maxPlayers,
      description: descriptionController.text,
    );
    
    widget.onSquadCreated(newSquad);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF5F8FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Create Squad',
        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: const Color(0xFF102060)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: GoogleFonts.quicksand(color: const Color(0xFF102060)),
              decoration: InputDecoration(
                labelText: 'Squad Title',
                labelStyle: GoogleFonts.quicksand(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rankController,
              style: GoogleFonts.quicksand(color: const Color(0xFF102060)),
              decoration: InputDecoration(
                labelText: 'Rank/Level',
                labelStyle: GoogleFonts.quicksand(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxPlayersController,
              style: GoogleFonts.quicksand(color: const Color(0xFF102060)),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Max Players (2-10)',
                labelStyle: GoogleFonts.quicksand(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              style: GoogleFonts.quicksand(color: const Color(0xFF102060)),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.quicksand(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.quicksand(color: const Color(0xFF102060)),
          ),
        ),
        ElevatedButton(
          onPressed: _createSquad,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Create',
            style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Squad Details Dialog
class _SquadDetailsDialog extends StatelessWidget {
  final Squad squad;
  final String gameName;

  const _SquadDetailsDialog({
    required this.squad,
    required this.gameName,
  });

  void _joinSquad(BuildContext context) {
    Navigator.of(context).pop(); // Close details dialog
    // Navigate to lobby screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LobbyScreen(
          squad: squad,
          gameName: gameName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF1E88E5);
    const Color brandNavy = Color(0xFF102060);
    final bool isFull = squad.currentPlayers >= squad.maxPlayers;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        squad.title,
        style: GoogleFonts.quicksand(
          fontWeight: FontWeight.bold,
          color: brandNavy,
          fontSize: 22,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank and Players Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rank/Level',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: const Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          squad.rank,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: brandNavy,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFFD0E0F0),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Players',
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              color: const Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${squad.currentPlayers}/${squad.maxPlayers}',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: isFull ? Colors.redAccent : brandNavy,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              'Description',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                color: brandNavy,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                squad.description.isEmpty ? 'No description provided.' : squad.description,
                style: GoogleFonts.quicksand(
                  color: squad.description.isEmpty ? const Color(0xFF999999) : brandNavy,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: GoogleFonts.quicksand(color: brandNavy),
          ),
        ),
        ElevatedButton(
          onPressed: isFull ? null : () => _joinSquad(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: brandBlue,
            disabledBackgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isFull ? 'Full' : 'Join Squad',
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}