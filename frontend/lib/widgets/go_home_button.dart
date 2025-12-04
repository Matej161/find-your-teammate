import 'package:flutter/material.dart';

class GoHomeButton extends StatelessWidget {
  // This allows you to change the destination if you reuse it on other screens,
  // but it defaults to '/home' so you don't have to type it every time.
  final String destinationRoute;

  const GoHomeButton({
    super.key,
    this.destinationRoute = '/home',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back, // You can change this to Icons.close (X) if you prefer
        color: Colors.white,
      ),
      onPressed: () {
        // Navigate to the target route (defaults to home)
        Navigator.of(context).pushReplacementNamed(destinationRoute);
      },
    );
  }
}