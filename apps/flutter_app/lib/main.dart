import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'platforms/web/web_homepage.dart';
import 'platforms/mobile/onboarding_screen.dart';
import 'platforms/desktop/desktop_onboarding.dart';
import 'utils/onboarding_utils.dart';

void main() {
  runApp(const StitchMeApp());
}

class StitchMeApp extends StatelessWidget {
  const StitchMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StitchMe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      home: const PlatformAwareHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlatformAwareHome extends StatefulWidget {
  const PlatformAwareHome({super.key});

  @override
  State<PlatformAwareHome> createState() => _PlatformAwareHomeState();
}

class _PlatformAwareHomeState extends State<PlatformAwareHome> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    if (kIsWeb) {
      // Web always shows homepage
      setState(() {
        _isLoading = false;
        _showOnboarding = false;
      });
      return;
    }

    try {
      final onboardingCompleted = await OnboardingUtils.isOnboardingCompleted();
      
      setState(() {
        _showOnboarding = !onboardingCompleted;
        _isLoading = false;
      });
      
      // Debug: Print onboarding status
      print('Onboarding completed: $onboardingCompleted');
      print('Show onboarding: $_showOnboarding');
    } catch (e) {
      // If there's an error, show onboarding as fallback
      setState(() {
        _showOnboarding = true;
        _isLoading = false;
      });
      print('Error checking onboarding: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if running on web
    if (kIsWeb) {
      return const WebHomepage(); // Show homepage only on web
    } else {
      // For mobile and desktop, check onboarding status
      if (_showOnboarding) {
        // Check if this is a desktop platform
        final platform = Theme.of(context).platform;
        print('Platform detected: $platform');
        
        if (platform == TargetPlatform.windows ||
            platform == TargetPlatform.macOS ||
            platform == TargetPlatform.linux) {
          print('Showing desktop onboarding');
          return const DesktopOnboardingWrapper();
        } else {
          print('Showing mobile onboarding');
          return const OnboardingScreen();
        }
      } else {
        print('Onboarding completed, showing login');
        return const LoginScreen();
      }
    }
  }
}

// Wrapper for desktop onboarding that shows login screen with popup
class DesktopOnboardingWrapper extends StatefulWidget {
  const DesktopOnboardingWrapper({super.key});

  @override
  State<DesktopOnboardingWrapper> createState() => _DesktopOnboardingWrapperState();
}

class _DesktopOnboardingWrapperState extends State<DesktopOnboardingWrapper> {
  @override
  void initState() {
    super.initState();
    // Show onboarding popup after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOnboardingDialog();
    });
  }

  void _showOnboardingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DesktopOnboarding(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // Logo and Title - Apple style
              Column(
                children: [
                  // App Icon with circular background
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
                  
                  // Title - Large, bold, black
                  const Text(
                    'StitchMe',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle - Medium gray, regular weight
                  const Text(
                    'Sign in to use AI-powered wound assessment, device control, and telemedicine features.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Email Field - Apple style
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Email or Phone Number',
                    hintStyle: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Password Field - Apple style
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF8E8E93),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forgot password feature coming soon')),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF007AFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sign In Button - Apple style
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F2F7),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sign Up Link - Apple style
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  
  // Step 1: Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  
  // Step 2: Demographics & Health
  String? _selectedGender;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _selectedBloodType;
  int _selectedBloodTypeIndex = 0;
  List<String> _selectedConditions = [];
  
  // Step 3: Contact Information
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedContactPreference;
  
  // Step 4: Security
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _medicalConditions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Autoimmune Disorder',
    'Blood Clotting Disorder',
    'Allergies',
    'None'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Content
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: _buildCurrentStep(),
              ),
              
              const SizedBox(height: 32),
              
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: _previousStep,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6B7280),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _canProceed() ? _nextStep : null,
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
                        _currentStep == _totalSteps - 1 ? 'Create Account' : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildDemographicsStep();
      case 2:
        return _buildContactStep();
      case 3:
        return _buildSecurityStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        const Text(
          'Let\'s start with your basic information for your medical profile.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // First Name
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _firstNameController,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'First Name',
              hintStyle: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Last Name
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _lastNameController,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'Last Name',
              hintStyle: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Date of Birth
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(
                    _selectedDate != null 
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Date of Birth',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate != null ? Colors.black : const Color(0xFF8E8E93),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF8E8E93),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemographicsStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.favorite,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title
        const Text(
          'Health Information',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        const Text(
          'Help us provide better medical care with your health details.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // Gender Selection
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('Male', Icons.male),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderOption('Female', Icons.female),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Height and Weight
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Height (cm)',
                    hintStyle: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Weight (kg)',
                    hintStyle: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Blood Type
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: _selectBloodType,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(
                    _selectedBloodType ?? 'Blood Type',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedBloodType != null ? Colors.black : const Color(0xFF8E8E93),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Theme.of(context).platform == TargetPlatform.iOS 
                        ? Icons.arrow_drop_down 
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF8E8E93),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.contact_phone,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        const Text(
          'How would you like us to reach you for appointments and updates?',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // Email
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'Email Address',
              hintStyle: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Phone
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'Phone Number',
              hintStyle: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Contact Preference
        const Text(
          'Preferred Contact Method:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildContactPreferenceOption('Email', Icons.email),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactPreferenceOption('Phone', Icons.phone),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.security,
            size: 40,
            color: Color(0xFF2563EB),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title
        const Text(
          'Account Security',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        const Text(
          'Create a secure password to protect your medical information.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 40),
        
        // Password
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF8E8E93),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Confirm Password
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              hintStyle: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF8E8E93),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Terms and Conditions
        Row(
          children: [
            Checkbox(
              value: _agreeToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreeToTerms = value ?? false;
                });
              },
              activeColor: const Color(0xFF2563EB),
            ),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPreferenceOption(String preference, IconData icon) {
    final isSelected = _selectedContactPreference == preference;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedContactPreference = preference;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              preference,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime tempDate = _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 25));
    
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS Cupertino Date Picker
      await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                // Header with Done button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF2F2F7), width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = tempDate;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Date picker
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempDate,
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      tempDate = newDate;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Android Material Date Picker
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tempDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF2563EB),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }
  }

  Future<void> _selectBloodType() async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS Cupertino Picker
      await showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            color: Colors.white,
            child: Column(
              children: [
                // Header with Done button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF2F2F7), width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedBloodType = _bloodTypes[_selectedBloodTypeIndex];
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Blood type picker
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      _selectedBloodTypeIndex = index;
                    },
                    children: _bloodTypes.map((String bloodType) {
                      return Center(
                        child: Text(
                          bloodType,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Android Material Bottom Sheet
      await showModalBottomSheet<String>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Blood Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Blood type list
                Expanded(
                  child: ListView.builder(
                    itemCount: _bloodTypes.length,
                    itemBuilder: (context, index) {
                      final bloodType = _bloodTypes[index];
                      final isSelected = _selectedBloodType == bloodType;
                      return ListTile(
                        title: Text(
                          bloodType,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? const Color(0xFF2563EB) : Colors.black,
                          ),
                        ),
                        trailing: isSelected 
                            ? const Icon(
                                Icons.check,
                                color: Color(0xFF2563EB),
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedBloodType = bloodType;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _firstNameController.text.isNotEmpty &&
               _lastNameController.text.isNotEmpty &&
               _selectedDate != null;
      case 1:
        return _selectedGender != null &&
               _heightController.text.isNotEmpty &&
               _weightController.text.isNotEmpty &&
               _selectedBloodType != null;
      case 2:
        return _emailController.text.isNotEmpty &&
               _phoneController.text.isNotEmpty &&
               _selectedContactPreference != null;
      case 3:
        return _passwordController.text.isNotEmpty &&
               _confirmPasswordController.text.isNotEmpty &&
               _passwordController.text == _confirmPasswordController.text &&
               _agreeToTerms;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Create account
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'StitchMe',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'reset_onboarding',
                child: Text('Reset Onboarding'),
              ),
              const PopupMenuItem(
                value: 'show_onboarding',
                child: Text('Show Onboarding'),
              ),
              const PopupMenuItem(
                value: 'force_onboarding',
                child: Text('Force Show Onboarding'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sign Out'),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else if (value == 'reset_onboarding') {
                await OnboardingUtils.resetOnboarding();
                if (context.mounted) {
                  // Check if this is a desktop platform
                  if (Theme.of(context).platform == TargetPlatform.windows ||
                      Theme.of(context).platform == TargetPlatform.macOS ||
                      Theme.of(context).platform == TargetPlatform.linux) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DesktopOnboardingWrapper()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                    );
                  }
                }
              } else if (value == 'show_onboarding') {
                if (context.mounted) {
                  // Show onboarding as a dialog for desktop
                  if (Theme.of(context).platform == TargetPlatform.windows ||
                      Theme.of(context).platform == TargetPlatform.macOS ||
                      Theme.of(context).platform == TargetPlatform.linux) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const DesktopOnboarding(),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                    );
                  }
                }
              } else if (value == 'force_onboarding') {
                if (context.mounted) {
                  // Force show onboarding by resetting and restarting
                  await OnboardingUtils.resetOnboarding();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PlatformAwareHome()),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Section - Apple style
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        size: 30,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to StitchMe',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'AI-Powered Wound Assessment System',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Quick Actions - Apple style
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.camera_alt,
                      title: 'Scan Wound',
                      subtitle: 'Take photos and analyze',
                      color: const Color(0xFF2563EB),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.video_call,
                      title: 'Video Call',
                      subtitle: 'Connect with healthcare provider',
                      color: const Color(0xFF2563EB),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.bluetooth,
                      title: 'Device Pairing',
                      subtitle: 'Connect StitchMe device',
                      color: const Color(0xFF2563EB),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.history,
                      title: 'History',
                      subtitle: 'View past assessments',
                      color: const Color(0xFF2563EB),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title feature coming soon')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}