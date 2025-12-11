import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// THE REUSABLE WIDGET 
// ---------------------------------------------------------------------------
class GameSelectionWidget extends StatelessWidget {
  final String name;      
  final IconData icon;    
  final Color color;      
  final VoidCallback onTap; 

  const GameSelectionWidget({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Retaining the dark grey background and rounded corners
        color: const Color(0xFF1F2937), 
        borderRadius: BorderRadius.circular(20),
        // *** FIX: REMOVED Border and BoxShadow (the glow effect) ***
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          // Retained splash and highlight for user feedback on tap
          splashColor: color.withOpacity(0.4), 
          highlightColor: color.withOpacity(0.15), 
          child: Padding(
            padding: const EdgeInsets.all(12.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Display
                Container(
                  padding: const EdgeInsets.all(16), 
                  decoration: BoxDecoration(
                    // Retained background color for the icon container
                    color: color.withOpacity(0.15), 
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,  
                    size: 40, 
                    color: color,
                  ),
                ),
                const SizedBox(height: 12), 
                
                // Game Name Display
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700, 
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54, 
                        blurRadius: 2,
                      )
                    ]
                  ),
                  maxLines: 2, 
                  overflow: TextOverflow.visible, 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}