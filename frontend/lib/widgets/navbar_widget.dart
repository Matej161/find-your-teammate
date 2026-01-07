import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const NavbarWidget({
    super.key, 
    required this.title, 
    this.showBackButton = true // Default to true so we can go back
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  // Track the current toast to remove it if a new one appears
  OverlayEntry? _currentToast;

  // --- CUSTOM TOP NOTIFICATION HELPER ---
  void _showTopToast(String message, Color bgColor, IconData icon) {
    // 1. Remove existing toast if visible
    _currentToast?.remove();

    // 2. Create the OverlayEntry
    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Safe area + 10px margin
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30), // Rounded "Pill" shape
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 28), // Big Icon
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Bigger Font
                      fontWeight: FontWeight.bold, // Bold Font
                      fontFamily: 'Roboto', // Default nicely readable font
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 3. Insert into the screen
    Overlay.of(context).insert(_currentToast!);

    // 4. Auto-remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentToast != null) {
        _currentToast?.remove();
        _currentToast = null;
      }
    });
  }

  @override
  void dispose() {
    _currentToast?.remove(); // Cleanup toast when widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandNavy = Color(0xFF102060);
    const Color iceBackground = Color(0xFFE8F1F9);
    const Color borderColor = Color(0xFFD0E0F0);

    return AppBar(
      backgroundColor: iceBackground,
      elevation: 0,
      toolbarHeight: 50,
      centerTitle: false,
      automaticallyImplyLeading: false, 
      // 1. ADDED BACK ARROW (Replaced search)
      leading: widget.showBackButton ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: brandNavy, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ) : null,
      shape: const Border(
        bottom: BorderSide(color: borderColor, width: 1.0),
      ),
      title: Text(
        widget.title,
        style: GoogleFonts.quicksand(
          color: brandNavy,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        // 2. USER MENU (Replaced Exit Button)
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: brandNavy, size: 28),
          color: Colors.white,
          onSelected: (value) {
            if (value == 'logout') {
              // --- LOGOUT NOTIFICATION ---
              _showTopToast('You logged out!', Colors.redAccent, Icons.logout);
              
              // Navigate to Home
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (value == 'profile') {
              print("Navigate to profile page in the future");
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'profile',
              child: Text('My Profile', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout', style: GoogleFonts.quicksand(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}