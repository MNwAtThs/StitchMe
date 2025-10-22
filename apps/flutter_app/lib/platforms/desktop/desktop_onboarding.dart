import 'package:flutter/material.dart';
import '../../utils/onboarding_utils.dart';

class DesktopOnboarding extends StatefulWidget {
  const DesktopOnboarding({super.key});

  @override
  State<DesktopOnboarding> createState() => _DesktopOnboardingState();
}

class _DesktopOnboardingState extends State<DesktopOnboarding> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await OnboardingUtils.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.75; // 75% of screen width
    final dialogHeight = screenSize.height * 0.8; // 80% of screen height
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth.clamp(500.0, 1000.0), // Min 500px, Max 1000px
        height: dialogHeight.clamp(450.0, 800.0), // Min 450px, Max 800px
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Content area
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: const [
                  DesktopWelcomeStep(),
                  DesktopAIAnalysisStep(),
                  DesktopLiDARStep(),
                  DesktopTelemedicineStep(),
                ],
              ),
            ),
            
            // Footer with navigation
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  
                  const SizedBox(height: 12),
                  
                  // Navigation buttons and dots on same line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Back button
                      if (_currentStep > 0)
                        ElevatedButton(
                          onPressed: _previousStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.grey[700],
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 80), // Placeholder for alignment
                      
                      // Center - Step indicators
                      Row(
                        children: [
                          ...List.generate(_totalSteps, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index <= _currentStep
                                    ? const Color(0xFF10B981)
                                    : Colors.grey[300],
                              ),
                            );
                          }),
                        ],
                      ),
                      
                      // Right side - Next/Skip button
                      ElevatedButton(
                        onPressed: _currentStep == _totalSteps - 1 ? _skipOnboarding : _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(_currentStep == _totalSteps - 1 ? 'Get Started' : 'Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}

// Desktop Welcome Step
class DesktopWelcomeStep extends StatelessWidget {
  const DesktopWelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App icon
        Container(
          width: (dialogWidth * 0.15).clamp(60.0, 100.0),
          height: (dialogWidth * 0.15).clamp(60.0, 100.0),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.medical_services,
            size: 50,
            color: Color(0xFF10B981),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        const Text(
          'Welcome to StitchMe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Description
        Text(
          'AI-powered wound assessment and treatment system for healthcare professionals',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Key features - centered in the middle of the screen
        Center(
          child: Column(
            children: [
              _buildFeatureItem(
                context,
                Icons.speed,
                'Instant Analysis',
                'AI-powered wound assessment',
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                context,
                Icons.precision_manufacturing,
                '3D Scanning',
                'LiDAR precision measurements',
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                context,
                Icons.video_call,
                'Telemedicine',
                'Connect with patients',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF10B981),
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
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Desktop AI Analysis Step
class DesktopAIAnalysisStep extends StatelessWidget {
  const DesktopAIAnalysisStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.1),
                const Color(0xFF10B981).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.psychology,
            size: 50,
            color: Color(0xFF10B981),
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'AI-Powered Analysis',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Advanced computer vision technology analyzes wound images for instant, accurate assessments and treatment recommendations.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Features list - centered in the middle of the screen
        Center(
          child: Column(
            children: [
              _buildFeatureRow(
                context,
                'Wound Classification',
                'Automatically categorizes wound types and severity levels',
              ),
              const SizedBox(height: 8),
              _buildFeatureRow(
                context,
                'Treatment Recommendations',
                'AI suggests optimal treatment protocols based on analysis',
              ),
              const SizedBox(height: 8),
              _buildFeatureRow(
                context,
                'Progress Tracking',
                'Monitor healing progress with detailed analytics',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(
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
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Desktop LiDAR Step
class DesktopLiDARStep extends StatelessWidget {
  const DesktopLiDARStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.1),
                const Color(0xFF10B981).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.threed_rotation,
            size: 50,
            color: Color(0xFF10B981),
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          '3D LiDAR Scanning',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Utilize iPhone LiDAR technology to create precise 3D models of wounds for accurate measurements and detailed analysis.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Benefits - centered in the middle of the screen
        Center(
          child: Column(
            children: [
              _buildLiDARBenefit(
                context,
                'Precise Measurements',
                'Get exact wound dimensions in millimeters',
              ),
              const SizedBox(height: 8),
              _buildLiDARBenefit(
                context,
                '3D Visualization',
                'View wounds from all angles for better assessment',
              ),
              const SizedBox(height: 8),
              _buildLiDARBenefit(
                context,
                'Progress Monitoring',
                'Track healing with 3D comparisons over time',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiDARBenefit(
    BuildContext context,
    String title,
    String description,
  ) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF10B981),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF10B981),
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Desktop Telemedicine Step
class DesktopTelemedicineStep extends StatelessWidget {
  const DesktopTelemedicineStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF59E0B).withValues(alpha: 0.1),
                const Color(0xFFF59E0B).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.video_call,
            size: 50,
            color: Color(0xFFF59E0B),
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'Telemedicine Integration',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Connect directly with patients and healthcare professionals for real-time consultations and expert medical advice.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Features - centered in the middle of the screen
        Center(
          child: Column(
            children: [
              _buildTelemedicineFeature(
                context,
                Icons.video_call,
                'Live Video Consultations',
                'Real-time video calls with patients and colleagues',
              ),
              const SizedBox(height: 8),
              _buildTelemedicineFeature(
                context,
                Icons.share,
                'Share Analysis Results',
                'Send wound data and AI recommendations securely',
              ),
              const SizedBox(height: 8),
              _buildTelemedicineFeature(
                context,
                Icons.schedule,
                'Schedule Appointments',
                'Manage patient appointments and follow-ups',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTelemedicineFeature(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFFF59E0B),
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
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Desktop Device Pairing Step
class DesktopDevicePairingStep extends StatelessWidget {
  const DesktopDevicePairingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.bluetooth,
              size: 50,
              color: Color(0xFF8B5CF6),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Device Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Manage and control StitchMe treatment devices, monitor patient progress, and coordinate care across multiple devices.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Setup steps
          Column(
            children: [
              _buildSetupStep(
                context,
                '1',
                'Device Discovery',
                'Find and connect to StitchMe devices',
              ),
              const SizedBox(height: 8),
              _buildSetupStep(
                context,
                '2',
                'Patient Assignment',
                'Assign devices to specific patients',
              ),
              const SizedBox(height: 8),
              _buildSetupStep(
                context,
                '3',
                'Treatment Monitoring',
                'Monitor automated treatment progress',
              ),
              const SizedBox(height: 8),
              _buildSetupStep(
                context,
                '4',
                'Data Management',
                'Access and analyze treatment data',
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Note
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Device management is available for healthcare professionals with proper credentials.',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF8B5CF6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
