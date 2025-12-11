import 'package:flutter/material.dart';

// Convert to StatefulWidget to allow for channel list expansion/collapse
class GameServerScreen extends StatefulWidget {
  // Required parameter to receive the game name
  final String gameName;

  const GameServerScreen({
    super.key,
    required this.gameName,
  });

  @override
  State<GameServerScreen> createState() => _GameServerScreenState();
}

class _GameServerScreenState extends State<GameServerScreen> {
  // State variable to track the currently selected channel, defaults to a text channel
  String _selectedChannelName = 'general-chat'; 
  String _selectedChannelType = 'TEXT';
  
  // Mock channel data
  final List<Map<String, dynamic>> textChannels = const [
    {'name': 'announcements', 'icon': Icons.tag, 'color': Colors.white},
    {'name': 'general-chat', 'icon': Icons.tag, 'color': Colors.white},
    {'name': 'match-discussion', 'icon': Icons.tag, 'color': Colors.white},
  ];

  final List<Map<String, dynamic>> voiceChannels = const [
    {'name': 'Lobby 1', 'icon': Icons.volume_up, 'users': 3, 'color': Colors.lightGreen},
    {'name': 'Squad Queue', 'icon': Icons.volume_up, 'users': 5, 'color': Colors.lightGreen},
    {'name': 'Idle Hangout', 'icon': Icons.volume_up, 'users': 0, 'color': Colors.white70},
  ];

  // Helper method to build a single channel ListTile
  Widget _buildChannelItem({
    required String name,
    required IconData icon,
    required Color color,
    int users = 0,
    required String type,
  }) {
    final bool isActiveVoice = type == 'VOICE' && users > 0;
    final bool isSelected = name == _selectedChannelName;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : color,
          size: 20,
        ),
        title: Text(
          '${type == 'TEXT' ? '#' : ''}$name',
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: isActiveVoice
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$users', style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
                  Icon(Icons.person, size: 18, color: isSelected ? Colors.white : Colors.white70),
                ],
              )
            : null,
        
        // Highlight the selected channel
        tileColor: isSelected 
            ? Colors.indigo.withOpacity(0.5) 
            : isActiveVoice 
                ? Colors.lightGreen.withOpacity(0.1) 
                : null,
                
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          setState(() {
            _selectedChannelName = name;
            _selectedChannelType = type;
          });
          // Close the drawer after selecting a channel on mobile
          if (Scaffold.of(context).isDrawerOpen) {
            Navigator.pop(context);
          }
          print('Attempting to join $name...');
        },
      ),
    );
  }

  // New method to build the active chat/voice view
  Widget _buildActiveChannelView() {
    // Mock chat messages for text channel display
    final messages = [
      {'user': 'GamerX', 'text': 'Who is ready for a ranked match tonight?', 'color': Colors.amber},
      {'user': 'AlphaBot', 'text': 'I am! Need one more player for our squad.', 'color': Colors.lightBlue},
      {'user': 'You', 'text': 'I can join! What roles are you missing?', 'color': Colors.redAccent},
      {'user': 'GamerX', 'text': 'We need a support or a jungler!', 'color': Colors.amber},
    ];

    if (_selectedChannelType == 'TEXT') {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937), // Card background
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chat Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '# $_selectedChannelName Chat',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.white10),
              
              // Mock Message List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 14, backgroundColor: msg['color'] as Color),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['user'] as String,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: msg['color'] as Color),
                                ),
                                Text(
                                  msg['text'] as String,
                                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Mock Input Field
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Message #$_selectedChannelName',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF374151),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.send, color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Mock Voice Channel View
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_none, size: 80, color: Colors.lightGreen),
            const SizedBox(height: 10),
            Text(
              'Voice Channel: $_selectedChannelName',
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Click to connect and chat!',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                print('Connecting to $_selectedChannelName voice...');
              },
              icon: const Icon(Icons.call, color: Colors.white),
              label: const Text('Connect'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      );
    }
  }
  
  // --- New method to build the entire channel sidebar content ---
  Widget _buildChannelSidebar() {
    return Container(
      color: const Color(0xFF1F2937), // Dark grey background for the sidebar
      // *** START: Added SafeArea and vertical padding for better spacing ***
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Added extra space at the top
            const SizedBox(height: 10), 

            // Server Header/Name inside the sidebar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0), // Reduced vertical padding here, relying on SizedBox
              child: Text(
                '${widget.gameName} Server',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.white10),

            // Channel List (Expanded to fill remaining sidebar height)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                children: [
                  // Text Channels Section
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text('TEXT CHANNELS', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                    iconColor: Colors.grey,
                    collapsedIconColor: Colors.grey,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                    children: textChannels.map((channel) {
                      return _buildChannelItem(
                        name: channel['name'] as String,
                        icon: channel['icon'] as IconData,
                        color: channel['color'] as Color,
                        type: 'TEXT',
                      );
                    }).toList(),
                  ),

                  // Voice Channels Section
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: const Text('VOICE CHANNELS', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                    iconColor: Colors.grey,
                    collapsedIconColor: Colors.grey,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                    children: voiceChannels.map((channel) {
                      return _buildChannelItem(
                        name: channel['name'] as String,
                        icon: channel['icon'] as IconData,
                        color: channel['color'] as Color,
                        users: channel['users'] as int,
                        type: 'VOICE',
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // *** END: Added SafeArea and vertical padding for better spacing ***
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameName} Server'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        
        // Back button in the AppBar (leading)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Selection',
        ),
        
        // Menu button to open the hidden channel sidebar (actions)
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(), // Opens the drawer
              tooltip: 'Show Channels',
            ),
          ),
        ],
      ),
      
      // --- 1. Channel Sidebar (Hidden on mobile, slides out) ---
      drawer: Drawer(
        child: _buildChannelSidebar(),
      ),
      
      // --- 2. Active Channel View (Takes up the whole screen body) ---
      body: Container(
        color: const Color(0xFF111827), // Deep dark background
        child: _buildActiveChannelView(),
      ),
    );
  }
}