import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingXxl,
            vertical: AppTheme.spacingXl,
          ),
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
              
              const SizedBox(height: AppTheme.spacingXxxl),
              
              // Next button - Using theme
              SizedBox(
                height: AppTheme.buttonHeightM,
                child: ElevatedButton(
                  onPressed: _nextPage,
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
        // App icon - Using theme
        AppTheme.iconContainer(
          icon: Icons.medical_services,
          iconColor: AppTheme.accentBlue,
          size: 80,
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title - Using theme
        Text(
          'Welcome to StitchMe',
          style: AppTheme.getTitleLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle - Using theme
        Text(
          'Revolutionary AI-powered wound assessment and treatment system for healthcare professionals.',
          style: AppTheme.getBodyLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // Key benefits - Apple style
        Column(
          children: [
            _buildBenefitItem(
              context,
              Icons.speed,
              'Instant Analysis',
              'Get immediate wound assessment',
            ),
            const SizedBox(height: AppTheme.spacingXl),
            _buildBenefitItem(
              context,
              Icons.precision_manufacturing,
              'Precise Measurements',
              '3D LiDAR scanning for accuracy',
            ),
            const SizedBox(height: AppTheme.spacingXl),
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
          color: AppTheme.accentBlue,
          size: AppTheme.iconL,
        ),
        const SizedBox(width: AppTheme.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTheme.getBodyMedium(context),
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
        // Illustration - Using theme
        AppTheme.iconContainer(
          icon: Icons.psychology,
          iconColor: AppTheme.accentBlue,
          size: 80,
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title - Using theme
        Text(
          'AI-Powered Analysis',
          style: AppTheme.getTitleLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle - Using theme
        Text(
          'Our advanced computer vision technology analyzes wound images to provide instant, accurate assessments and treatment recommendations.',
          style: AppTheme.getBodyLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // Features list - Apple style
        Column(
          children: [
            _buildFeatureItem(
              context,
              'Wound Classification',
              'Automatically categorizes wound types and severity',
            ),
            const SizedBox(height: AppTheme.spacingXl),
            _buildFeatureItem(
              context,
              'Treatment Recommendations',
              'AI suggests optimal treatment protocols',
            ),
            const SizedBox(height: AppTheme.spacingXl),
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
          margin: const EdgeInsets.only(top: AppTheme.spacingS),
          decoration: const BoxDecoration(
            color: AppTheme.accentBlue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppTheme.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTheme.getBodyMedium(context),
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
        // Advanced features illustration - Using theme
        AppTheme.iconContainer(
          icon: Icons.medical_services,
          iconColor: AppTheme.accentBlue,
          size: 80,
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title - Using theme
        Text(
          'Advanced Features',
          style: AppTheme.getTitleLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle - Using theme
        Text(
          '3D LiDAR scanning for precise measurements and telemedicine integration for professional consultations.',
          style: AppTheme.getBodyLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Features - Using theme
        Column(
          children: [
            _buildAdvancedFeature(
              context,
              Icons.threed_rotation,
              '3D LiDAR Scanning',
              'Precise wound measurements and 3D visualization',
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildAdvancedFeature(
              context,
              Icons.video_call,
              'Telemedicine Integration',
              'Live consultations with healthcare providers',
            ),
            const SizedBox(height: AppTheme.spacingL),
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
          color: AppTheme.accentBlue,
          size: AppTheme.iconL,
        ),
        const SizedBox(width: AppTheme.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTheme.getBodyMedium(context),
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
        // Device illustration - Using theme
        AppTheme.iconContainer(
          icon: Icons.bluetooth,
          iconColor: AppTheme.accentBlue,
          size: 80,
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title - Using theme
        Text(
          'Device Pairing',
          style: AppTheme.getTitleLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle - Using theme
        Text(
          'Connect your mobile app with the StitchMe treatment device for automated wound care and real-time monitoring.',
          style: AppTheme.getBodyLarge(context),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Setup steps - Using theme
        Column(
          children: [
            _buildSetupStep(
              context,
              '1',
              'Enable Bluetooth',
              'Turn on Bluetooth on your device',
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildSetupStep(
              context,
              '2',
              'Find & Connect',
              'Scan and pair with StitchMe device',
            ),
            const SizedBox(height: AppTheme.spacingL),
            _buildSetupStep(
              context,
              '3',
              'Ready to Use',
              'Start automated treatment',
            ),
          ],
        ),
        
        const SizedBox(height: AppTheme.spacingXxl),
        
        // Note - Using theme
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: AppTheme.surfaceContainer(),
          child: const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.accentBlue,
                size: AppTheme.iconS,
              ),
              SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  'Device pairing is optional.',
                  style: AppTheme.bodySmall,
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
            color: AppTheme.accentBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: AppTheme.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTheme.getBodyMedium(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
