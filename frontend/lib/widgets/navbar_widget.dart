import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
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
      leading: showBackButton ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: brandNavy, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ) : null,
      shape: const Border(
        bottom: BorderSide(color: borderColor, width: 1.0),
      ),
      title: Text(
        title,
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