import 'package:flutter/material.dart';
import '../web_homepage.dart';
import '../pages/research_page.dart';
import '../pages/features_page.dart';
import '../pages/team_page.dart';
import '../pages/progress_page.dart';
import '../pages/contact_page.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  
  const WebAppBar({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo - clickable to go home
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WebHomepage()),
                (route) => false,
              );
            },
            child: Row(
              children: [
                const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  'StitchMe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation buttons
          Row(
            children: [
              _buildNavButton(
                context,
                'Research',
                currentPage == 'Research',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ResearchPage()),
                ),
              ),
              const SizedBox(width: 20),
              _buildNavButton(
                context,
                'Features',
                currentPage == 'Features',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FeaturesPage()),
                ),
              ),
              const SizedBox(width: 20),
              _buildNavButton(
                context,
                'Team',
                currentPage == 'Team',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TeamPage()),
                ),
              ),
              const SizedBox(width: 20),
              _buildNavButton(
                context,
                'Progress',
                currentPage == 'Progress',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProgressPage()),
                ),
              ),
              const SizedBox(width: 20),
              _buildNavButton(
                context,
                'Contact',
                currentPage == 'Contact',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactPage()),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2563EB),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavButton(
    BuildContext context,
    String title,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: isActive ? null : onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          decoration: isActive ? TextDecoration.underline : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

// Simple login screen placeholder
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(
        child: Text('Login Screen - This would be your existing login'),
      ),
    );
  }
}
