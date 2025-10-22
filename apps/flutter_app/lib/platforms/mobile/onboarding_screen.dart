import 'package:flutter/material.dart';
import '../../main.dart';
import '../../utils/onboarding_utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }


  Future<void> _completeOnboarding() async {
    await OnboardingUtils.completeOnboarding();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page content - pushed up to top
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: const [
                    WelcomePage(),
                    AIAnalysisPage(),
                    AdvancedFeaturesPage(),
                    DevicePairingPage(),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Blue Next button - Apple style
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Welcome Page
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App icon - Apple style
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.medical_services,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title - Apple style
        const Text(
          'Welcome to StitchMe',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle - Apple style
        const Text(
          'Revolutionary AI-powered wound assessment and treatment system for healthcare professionals.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // Key benefits - Apple style
        Column(
          children: [
            _buildBenefitItem(
              context,
              Icons.speed,
              'Instant Analysis',
              'Get immediate wound assessment',
            ),
            const SizedBox(height: 20),
            _buildBenefitItem(
              context,
              Icons.precision_manufacturing,
              'Precise Measurements',
              '3D LiDAR scanning for accuracy',
            ),
            const SizedBox(height: 20),
            _buildBenefitItem(
              context,
              Icons.health_and_safety,
              'Professional Care',
              'Connect with healthcare providers',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2563EB),
          size: 28,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// AI Analysis Page
class AIAnalysisPage extends StatelessWidget {
  const AIAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustration - Apple style
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.psychology,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title - Apple style
        const Text(
          'AI-Powered Analysis',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle - Apple style
        const Text(
          'Our advanced computer vision technology analyzes wound images to provide instant, accurate assessments and treatment recommendations.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // Features list - Apple style
        Column(
          children: [
            _buildFeatureItem(
              context,
              'Wound Classification',
              'Automatically categorizes wound types and severity',
            ),
            const SizedBox(height: 20),
            _buildFeatureItem(
              context,
              'Treatment Recommendations',
              'AI suggests optimal treatment protocols',
            ),
            const SizedBox(height: 20),
            _buildFeatureItem(
              context,
              'Progress Tracking',
              'Monitor healing progress over time',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Advanced Features Page (combines LiDAR and Telemedicine)
class AdvancedFeaturesPage extends StatelessWidget {
  const AdvancedFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Advanced features illustration - Apple style
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.medical_services,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title - Apple style
        const Text(
          'Advanced Features',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle - Apple style
        const Text(
          '3D LiDAR scanning for precise measurements and telemedicine integration for professional consultations.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Features - Apple style (compact)
        Column(
          children: [
            _buildAdvancedFeature(
              context,
              Icons.threed_rotation,
              '3D LiDAR Scanning',
              'Precise wound measurements and 3D visualization',
            ),
            const SizedBox(height: 16),
            _buildAdvancedFeature(
              context,
              Icons.video_call,
              'Telemedicine Integration',
              'Live consultations with healthcare providers',
            ),
            const SizedBox(height: 16),
            _buildAdvancedFeature(
              context,
              Icons.trending_up,
              'Progress Tracking',
              'Monitor healing with detailed analytics',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedFeature(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2563EB),
          size: 28,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Device Pairing Page
class DevicePairingPage extends StatelessWidget {
  const DevicePairingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Device illustration - Apple style
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.bluetooth,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title - Apple style
        const Text(
          'Device Pairing',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle - Apple style
        const Text(
          'Connect your mobile app with the StitchMe treatment device for automated wound care and real-time monitoring.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Setup steps - Apple style (simplified)
        Column(
          children: [
            _buildSetupStep(
              context,
              '1',
              'Enable Bluetooth',
              'Turn on Bluetooth on your device',
            ),
            const SizedBox(height: 16),
            _buildSetupStep(
              context,
              '2',
              'Find & Connect',
              'Scan and pair with StitchMe device',
            ),
            const SizedBox(height: 16),
            _buildSetupStep(
              context,
              '3',
              'Ready to Use',
              'Start automated treatment',
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Note - Apple style (compact)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFF2563EB),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Device pairing is optional.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetupStep(
    BuildContext context,
    String stepNumber,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
