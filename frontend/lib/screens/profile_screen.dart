import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/navbar_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color brandBlue = Color(0xFF1E88E5);
  static const Color brandNavy = Color(0xFF102060);
  static const Color iceBackground = Color(0xFFE8F1F9);

  void _showEditUsernameDialog(BuildContext context, User? user) {
    final TextEditingController usernameController = TextEditingController(
      text: user?.displayName ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F8FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Edit Username',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: brandNavy,
            ),
          ),
          content: TextField(
            controller: usernameController,
            style: GoogleFonts.quicksand(color: brandNavy),
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: GoogleFonts.quicksand(),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                usernameController.dispose();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.quicksand(color: brandNavy),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text.isEmpty) return;
                
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: dialogContext,
                  builder: (BuildContext confirmContext) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Confirm Change',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: brandNavy,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to change your username to "${usernameController.text}"?',
                        style: GoogleFonts.quicksand(color: brandNavy),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(confirmContext).pop(false),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.quicksand(color: brandNavy),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(confirmContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Yes, Change',
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

                if (confirmed != true) return;

                try {
                  // TODO: Backend will handle this
                  await user?.updateDisplayName(usernameController.text);
                  await user?.reload();
                  
                  if (mounted) {
                    setState(() {});
                    Navigator.of(dialogContext).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Username updated successfully!',
                          style: GoogleFonts.quicksand(),
                        ),
                        backgroundColor: brandBlue,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to update username',
                          style: GoogleFonts.quicksand(),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
                usernameController.dispose();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: iceBackground,
      appBar: NavbarWidget(
        title: 'MY PROFILE',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: brandBlue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            // Profile Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: brandBlue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Name',
                              style: GoogleFonts.quicksand(
                                fontSize: 12,
                                color: const Color(0xFF666666),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: brandBlue, size: 20),
                          onPressed: () => _showEditUsernameDialog(context, user),
                          tooltip: 'Edit username',
                        ),
                      ],
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
                        user?.displayName ?? 'Not set',
                        style: GoogleFonts.quicksand(
                          color: brandNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Section
                    Row(
                      children: [
                        Icon(Icons.email_outlined, color: brandBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Email',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                        user?.email ?? 'No email',
                        style: GoogleFonts.quicksand(
                          color: brandNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
