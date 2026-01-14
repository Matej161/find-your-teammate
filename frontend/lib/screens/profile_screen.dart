import 'package:flutter/material.dart';
import 'package:frontend/SignalRContracts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navbar_widget.dart';

class ProfileScreen extends StatefulWidget {
  // Předpokládám, že při přihlášení si ukládáš userId někam globálně 
  // nebo ho máš k dispozici. Pokud ne, pro test tam teď dej natvrdo ID usera z DB.
  final String userId; 

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color brandBlue = Color(0xFF1E88E5);
  static const Color brandNavy = Color(0xFF102060);
  static const Color iceBackground = Color(0xFFE8F1F9);

  String _displayName = "";
  bool _isLoading = true;
  
  // Používáme tvou SignalR třídu
  final SignalRContracts _signalR = SignalRContracts();

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  @override
  void dispose() {
    _signalR.dispose();
    super.dispose();
  }

  Future<void> _initAndLoad() async {
    try {
      // 1. Připojení
      await _signalR.connect();
      
      // 2. Načtení jména z tvého backendu přes userId
      final name = await _signalR.getUsername(widget.userId);
      
      if (mounted) {
        setState(() {
          _displayName = name ?? "Uživatel nenalezen";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _displayName = "Chyba spojení";
          _isLoading = false;
        });
      }
    }
  }

  void _showEditUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditUsernameDialog(
        userId: widget.userId, 
        currentName: _displayName,
        signalR: _signalR
      ),
    ).then((updated) {
      if (updated == true) {
        setState(() => _isLoading = true);
        _initAndLoad(); // Znovu načte data po změně
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iceBackground,
      appBar: NavbarWidget(title: 'MŮJ PROFIL', showBackButton: true, userId: widget.userId,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 60,
              backgroundColor: brandBlue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Uživatelské jméno', 
                          style: GoogleFonts.quicksand(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.edit, color: brandBlue, size: 20),
                          onPressed: () => _showEditUsernameDialog(context),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F8FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _isLoading 
                        ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))) 
                        : Text(_displayName, style: GoogleFonts.quicksand(color: brandNavy, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DIALOG BEZ FIREBASE ---
class EditUsernameDialog extends StatefulWidget {
  final String userId;
  final String currentName;
  final SignalRContracts signalR;

  const EditUsernameDialog({
    super.key, 
    required this.userId, 
    required this.currentName,
    required this.signalR
  });

  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Změnit jméno'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Nové jméno'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Zrušit')),
        ElevatedButton(
          onPressed: () async {
            if (_controller.text.isEmpty) return;
            // Voláme tvůj SignalR
            bool success = await widget.signalR.changeUsername(widget.userId, _controller.text);
            if (mounted) Navigator.pop(context, success);
          }, 
          child: const Text('Uložit')
        ),
      ],
    );
  }
}