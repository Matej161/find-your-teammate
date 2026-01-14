import 'package:flutter/material.dart';
import 'package:frontend/SignalRContracts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navbar_widget.dart';

class ProfileScreen extends StatefulWidget {
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
      await _signalR.connect();
      final name = await _signalR.getUsername(widget.userId);
      
      if (mounted) {
        setState(() {
          _displayName = name ?? "User not found";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _displayName = "Connection error";
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
        _initAndLoad(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iceBackground,
      appBar: NavbarWidget(
        title: 'MY PROFILE', 
        showBackButton: true, 
        userId: widget.userId,
      ),
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
                        Text(
                          'Username', 
                          style: GoogleFonts.quicksand(
                            fontSize: 12, 
                            color: Colors.grey, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
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
                        ? const Center(
                            child: SizedBox(
                              height: 20, 
                              width: 20, 
                              child: CircularProgressIndicator(strokeWidth: 2)
                            )
                          ) 
                        : Text(
                            _displayName, 
                            style: GoogleFonts.quicksand(
                              color: brandNavy, 
                              fontSize: 16, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
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
  static const Color brandBlue = Color(0xFF1E88E5);
  static const Color brandNavy = Color(0xFF102060);

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Change Username',
        style: GoogleFonts.quicksand(
          fontWeight: FontWeight.bold,
          color: brandNavy,
        ),
      ),
      content: TextField(
        controller: _controller,
        style: GoogleFonts.quicksand(color: brandNavy),
        decoration: InputDecoration(
          labelText: 'New username',
          labelStyle: GoogleFonts.quicksand(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF5F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: brandBlue, width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: GoogleFonts.quicksand(
              color: Colors.grey, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_controller.text.isEmpty) return;
            bool success = await widget.signalR.changeUsername(
              widget.userId, 
              _controller.text
            );
            if (mounted) Navigator.pop(context, success);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: brandBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            'Save',
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