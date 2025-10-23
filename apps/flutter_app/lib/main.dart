import 'dart:async'; // Add this import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ui_kit/ui_kit.dart';
import 'platforms/web/web_homepage.dart';
import 'platforms/mobile/onboarding_screen.dart';
import 'platforms/desktop/desktop_onboarding.dart';
import 'utils/onboarding_utils.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables from .env file
    await dotenv.load(fileName: ".env");
    
    // Get Supabase credentials from .env file
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Supabase credentials not found in .env file');
    }
    
    // Initialize Supabase
    print('Initializing Supabase with URL: $supabaseUrl');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('Supabase initialized successfully');
    
    // Initialize SupabaseService
    await SupabaseService().initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('SupabaseService initialized successfully');
  } catch (e) {
    print('CRITICAL ERROR initializing app: $e');
    print('Stack trace: ${StackTrace.current}');
    rethrow; // Don't continue if initialization fails
  }
  
  runApp(const StitchMeApp());
}

class StitchMeApp extends StatelessWidget {
  const StitchMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StitchMe',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXxl, vertical: AppTheme.spacingHuge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // Logo and Title
              Column(
                children: [
                  // App Icon
                  AppTheme.iconContainer(
                    icon: Icons.medical_services,
                    iconColor: AppTheme.accentBlue,
                    size: 80,
                  ),
                  const SizedBox(height: AppTheme.spacingXxxl),
                  
                  // Title
                  const Text(
                    'StitchMe',
                    style: AppTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Subtitle
                  const Text(
                    'Sign in to use AI-powered wound assessment, device control, and telemedicine features.',
                    style: AppTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingHuge),
              
              // Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: AppTheme.buttonHeightM,
                child: ElevatedButton(
                  onPressed: _validateAndSignIn,
                  child: const Text('Sign In'),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Sign Up Link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text('Don\'t have an account? Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _forgotPassword() async {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                Navigator.pop(context);
                _showErrorSnackBar('Please enter your email');
                return;
              }
              
              try {
                await SupabaseService().client.auth.resetPasswordForEmail(
                  emailController.text.trim(),
                );
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Password reset email sent! Check your inbox.'),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                }
              } catch (error) {
                Navigator.pop(context);
                _showErrorSnackBar('Failed to send reset email: ${error.toString()}');
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  void _validateAndSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    try {
      final response = await SupabaseService().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      } else {
        _showErrorSnackBar('Invalid email or password');
      }
    } catch (error) {
      _showErrorSnackBar('Sign in failed: ${error.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
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
  final int _totalSteps = 5;
  
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // State
  DateTime? _dateOfBirth;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isVerifyingEmail = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers to trigger validation updates
    _firstNameController.addListener(_onNameChanged);
    _lastNameController.addListener(_onNameChanged);
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
    _confirmPasswordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onNameChanged);
    _lastNameController.removeListener(_onNameChanged);
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _confirmPasswordController.removeListener(_onTextChanged);
    _debounceTimer?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  void _onNameChanged() {
    _debounceTimer?.cancel(); // Cancel the previous timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        // This will trigger a rebuild and re-evaluate _canProceed()
      });
    });
  }

  void _onTextChanged() {
    setState(() {
      // This will trigger a rebuild and re-evaluate _canProceed()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                children: [
                  // Step indicator
                  Expanded(
                    child: Row(
                      children: List.generate(_totalSteps, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                              right: index < _totalSteps - 1 ? AppTheme.spacingS : 0,
                            ),
                            decoration: BoxDecoration(
                              color: index <= _currentStep 
                                  ? AppTheme.primaryBlue 
                                  : AppTheme.borderDefault,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingL),
                  // Step counter
                  Text(
                    '${_currentStep + 1} of $_totalSteps',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXxl),
                child: Column(
                  children: [
                    // Step content
                    Expanded(
                      child: _buildCurrentStep(),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                    
                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          SizedBox(
                            width: 120,
                            height: AppTheme.buttonHeightM,
                            child: OutlinedButton(
                              onPressed: _previousStep,
                              child: const Text('Back'),
                            ),
                          )
                        else
                          const SizedBox(width: 120),
                        
                        SizedBox(
                          width: 120,
                          height: AppTheme.buttonHeightM,
                          child: ElevatedButton(
                            onPressed: _canProceed() ? _nextStep : null,
                            child: Text(_currentStep == _totalSteps - 1 ? 'Create Account' : 'Next'),
                          ),
                        ),
                      ],
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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildDateOfBirthStep();
      case 2:
        return _buildContactInfoStep();
      case 3:
        return _buildVerifyEmailStep();
      case 4:
        return _buildSecurityStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: AppTheme.iconContainer(
            icon: Icons.person,
            iconColor: AppTheme.accentBlue,
            size: 80,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title
        const Text(
          'Personal Information',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        const Text(
          'Let\'s start with your basic information.',
          style: AppTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // First Name
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            hintText: 'First Name',
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Last Name
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            hintText: 'Last Name',
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: AppTheme.iconContainer(
            icon: Icons.email,
            iconColor: AppTheme.accentBlue,
            size: 80,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title
        const Text(
          'Contact Information',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        const Text(
          'How can we reach you?',
          style: AppTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // Email
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email Address',
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: AppTheme.iconContainer(
            icon: Icons.security,
            iconColor: AppTheme.accentBlue,
            size: 80,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title
        const Text(
          'Account Security',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        const Text(
          'Create a secure password.',
          style: AppTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // Password
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Confirm Password
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingL),
        
        // Terms checkbox
        Row(
          children: [
            Checkbox(
              value: _agreeToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreeToTerms = value ?? false;
                });
              },
              activeColor: AppTheme.primaryBlue,
            ),
            Expanded(
              child: Text(
                'I agree to the Terms of Service and Privacy Policy',
                style: AppTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateOfBirthStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: AppTheme.iconContainer(
            icon: Icons.cake_outlined,
            iconColor: AppTheme.accentBlue,
            size: 80,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title
        const Text(
          'Date of Birth',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        const Text(
          'We need your date of birth for medical records.',
          style: AppTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // Date picker button
        GestureDetector(
          onTap: _showPlatformDatePicker,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateOfBirth == null
                      ? 'Select Date of Birth'
                      : '${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}',
                  style: TextStyle(
                    color: _dateOfBirth == null
                        ? AppTheme.textSecondary.withOpacity(0.6)
                        : AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPlatformDatePicker() async {
    // Use iOS/macOS native date picker wheel
    if (Theme.of(context).platform == TargetPlatform.iOS || 
        Theme.of(context).platform == TargetPlatform.macOS) {
      await _showCupertinoDatePicker();
    } 
    // Use Android native date picker
    else {
      await _showMaterialDatePicker();
    }
  }

  Future<void> _showCupertinoDatePicker() async {
    DateTime tempDate = _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25));
    
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          color: AppTheme.backgroundPrimary,
          child: Column(
            children: [
              // Header with Done button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.borderDefault,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() {
                          _dateOfBirth = tempDate;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Date Picker Wheel
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
  }

  Future<void> _showMaterialDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundPrimary,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _dateOfBirth = date;
      });
    }
  }

  Widget _buildVerifyEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: AppTheme.iconContainer(
            icon: Icons.verified_user,
            iconColor: AppTheme.accentBlue,
            size: 80,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXxxl),
        
        // Title
        const Text(
          'Verify Your Email',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        Text(
          'We sent a 6-digit code to\n${_emailController.text}',
          style: AppTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingHuge),
        
        // OTP Input
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          decoration: const InputDecoration(
            hintText: '000000',
            counterText: '',
          ),
          onChanged: (value) {
            setState(() {}); // Trigger rebuild for validation
          },
        ),
        
        const SizedBox(height: AppTheme.spacingL),
        
        // Resend code button
        Center(
          child: TextButton(
            onPressed: _isVerifyingEmail ? null : _resendOTP,
            child: Text(
              _isVerifyingEmail ? 'Sending...' : 'Resend Code',
              style: const TextStyle(
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Navigation methods
  bool _canProceed() {
    bool canProceed = false;
    switch (_currentStep) {
      case 0:
        // Step 1: Name - Allow proceeding if at least one name field has at least 4 characters
        canProceed = _firstNameController.text.trim().length >= 4 ||
               _lastNameController.text.trim().length >= 4;
        break;
      case 1:
        // Step 2: Date of Birth - Must be selected
        canProceed = _dateOfBirth != null;
        break;
      case 2:
        // Step 3: Email - Must be filled and send OTP
        canProceed = _emailController.text.trim().isNotEmpty;
        break;
      case 3:
        // Step 4: Verify Email - Must enter 6-digit code
        canProceed = _otpController.text.length == 6;
        break;
      case 4:
        // Step 5: Password - Must match and agree to terms
        canProceed = _passwordController.text.isNotEmpty &&
               _confirmPasswordController.text.isNotEmpty &&
               _passwordController.text == _confirmPasswordController.text &&
               _agreeToTerms;
        break;
      default:
        canProceed = false;
    }
    return canProceed;
  }

  void _nextStep() async {
    // If on email step, send OTP before proceeding
    if (_currentStep == 2) {
      await _sendOTP();
    }
    // If on verify email step, verify OTP before proceeding
    else if (_currentStep == 3) {
      final verified = await _verifyOTP();
      if (!verified) return; // Don't proceed if verification failed
    }
    
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _createAccount();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _sendOTP() async {
    setState(() {
      _isVerifyingEmail = true;
    });
    
    try {
      await SupabaseService().client.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo: null, // We're using OTP code, not magic link
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Verification code sent! Check your email.'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (error) {
      _showErrorSnackBar('Failed to send code: ${error.toString()}');
    } finally {
      setState(() {
        _isVerifyingEmail = false;
      });
    }
  }

  Future<void> _resendOTP() async {
    await _sendOTP();
  }

  Future<bool> _verifyOTP() async {
    try {
      final response = await SupabaseService().client.auth.verifyOTP(
        email: _emailController.text.trim(),
        token: _otpController.text.trim(),
        type: OtpType.email,
      );
      
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Email verified successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        return true;
      } else {
        _showErrorSnackBar('Invalid verification code');
        return false;
      }
    } catch (error) {
      _showErrorSnackBar('Verification failed: ${error.toString()}');
      return false;
    }
  }

  void _createAccount() async {
    try {
      // Test basic network connectivity first
      print('Testing network connectivity...');
      try {
        final testSocket = await Socket.connect('wtjxiboqqfxwpemjbnlq.supabase.co', 443, timeout: Duration(seconds: 10));
        testSocket.destroy();
        print('Network test: SUCCESS - Can connect to Supabase');
      } catch (e) {
        print('Network test: FAILED - Cannot connect to Supabase: $e');
        _showErrorSnackBar('Network connection failed. Please check your internet connection and try again.');
        return;
      }
      
      // Create full name from available fields
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final fullName = firstName.isNotEmpty && lastName.isNotEmpty 
          ? '$firstName $lastName'
          : firstName.isNotEmpty 
              ? firstName 
              : lastName;
      
      print('Completing signup for: ${_emailController.text.trim()}');
      
      // User is already authenticated via OTP, just need to set password and update profile
      try {
        // Update password for the authenticated user
        await SupabaseService().client.auth.updateUser(
          UserAttributes(password: _passwordController.text),
        );
        
        // Update profile with full name and user type
        await SupabaseService().client.from('profiles').upsert({
          'id': SupabaseService().client.auth.currentUser!.id,
          'email': _emailController.text.trim(),
          'full_name': fullName,
          'user_type': 'patient',
        });
        
        // Save patient profile information (DOB only for now)
        try {
          await SupabaseService().updatePatientProfile(
            dateOfBirth: _dateOfBirth,
          );
        } catch (profileError) {
          print('Warning: Could not save patient profile: $profileError');
          // Don't fail the signup if profile save fails
        }
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      } catch (error) {
        _showErrorSnackBar('Failed to complete account setup: ${error.toString()}');
      }
    } catch (error) {
      _showErrorSnackBar('Account creation failed: ${error.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundPrimary,
        elevation: 0,
        title: const Text(
          'StitchMe',
          style: AppTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SupabaseService().signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to StitchMe!',
          style: AppTheme.titleLarge,
        ),
      ),
    );
  }
}
