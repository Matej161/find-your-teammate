import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navbar_widget.dart';
import '../models/squad.dart';
import '../SignalRContracts.dart';

class GameServerScreen extends StatefulWidget {
  final String gameName;
  const GameServerScreen({super.key, required this.gameName});

  @override
  State<GameServerScreen> createState() => _GameServerScreenState();
}

class _GameServerScreenState extends State<GameServerScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // 1. ADDED: ScrollController to handle auto-scrolling
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  
  final List<Map<String, String>> _messages = [
    {'user': 'Admin', 'text': 'Welcome to the global lobby!'},
  ];

  // 2. UPDATED: Send logic now triggers the scroll
  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'user': 'You', 
          'text': _chatController.text,
        });
        _chatController.clear();
      });

      SignalRContracts().sendMessage(widget.gameName, _chatController.text);

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

  final List<Squad> mockSquads = [
    Squad(id: '1', title: 'Global Elite Push', rank: 'Supreme', currentPlayers: 3, maxPlayers: 5, description: 'Need 2 more, must have mic!'),
    Squad(id: '2', title: 'Chill Ranked', rank: 'Gold', currentPlayers: 1, maxPlayers: 5, description: 'No toxicity please.'),
    Squad(id: '3', title: 'Faceit Level 10', rank: 'Level 10', currentPlayers: 4, maxPlayers: 5, description: 'Fast win.'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      
      // 3. FIXED: Button lifted with padding to prevent overlapping message bar
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70), 
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: brandBlue,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text("CREATE SQUAD", style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGlobalChat(),
                _buildSquadList(),
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
          child: _messages.isEmpty 
          ? Center(child: Text("Be the first to send a message!", style: GoogleFonts.quicksand(color: brandNavy)))
          : ListView.builder(
              controller: _scrollController, // Link the controller here
              // 4. FIXED: Bottom padding in list prevents last message from being hidden by button
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), 
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isMe = _messages[index]['user'] == 'You';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? brandBlue : Colors.white,
                      borderRadius: BorderRadius.circular(15).copyWith(
                        bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
                        bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(15),
                      ),
                      border: isMe ? null : Border.all(color: const Color(0xFFD0E0F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            _messages[index]['user']!,
                            style: GoogleFonts.quicksand(fontSize: 10, fontWeight: FontWeight.bold, color: brandNavy),
                          ),
                        Text(
                          _messages[index]['text']!,
                          style: GoogleFonts.quicksand(color: isMe ? Colors.white : brandNavy, fontWeight: FontWeight.w500),
                        ),
                      ],
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
                    style: GoogleFonts.quicksand(),
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
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Added padding for button here too
      itemCount: mockSquads.length,
      itemBuilder: (context, index) {
        final squad = mockSquads[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFFD0E0F0)),
          ),
          child: ListTile(
            title: Text(squad.title, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
            subtitle: Text("${squad.currentPlayers}/${squad.maxPlayers} Players • ${squad.rank}"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {},
          ),
        );
      },
    );
  }
}