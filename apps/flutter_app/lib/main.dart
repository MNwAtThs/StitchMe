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
import 'screens/wound_scanning_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/history_screen.dart';
import 'screens/device_pairing_screen.dart';

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
      themeMode: ThemeMode.light, // Light mode only
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
                  Text(
                    'StitchMe',
                    style: AppTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Subtitle
                  Text(
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
            Text(
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
                                  : AppTheme.getBorderDefault(context),
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
        Text(
          'Personal Information',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        Text(
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
        Text(
          'Contact Information',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        Text(
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
        Text(
          'Account Security',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        Text(
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
        Text(
          'Date of Birth',
          style: AppTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // Subtitle
        Text(
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppTheme.backgroundPrimary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
          ),
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
                      child: const Text('Cancel', style: TextStyle(color: AppTheme.primaryBlue)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Done', style: TextStyle(color: AppTheme.primaryBlue)),
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
                  backgroundColor: AppTheme.backgroundPrimary,
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
            colorScheme: const ColorScheme.light(
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
        Text(
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navigationItems = [
    {
      'label': 'Scan',
      'icon': Icons.camera_alt_outlined,
      'selectedIcon': Icons.camera_alt,
    },
    {
      'label': 'Device',
      'icon': Icons.devices_outlined,
      'selectedIcon': Icons.devices,
    },
    {
      'label': 'History',
      'icon': Icons.history_outlined,
      'selectedIcon': Icons.history,
    },
    {
      'label': 'Profile',
      'icon': Icons.person_outline,
      'selectedIcon': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isMobile = platform == TargetPlatform.iOS || 
                     platform == TargetPlatform.android ||
                     MediaQuery.of(context).size.width < 600;
    final isIOS = platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    
    // Use custom navigation for iOS/macOS to get rounded corners
    if (isIOS && isMobile) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundPrimary,
        body: _buildCurrentScreen(),
        bottomNavigationBar: _buildCustomIOSBottomNav(),
        extendBody: true, // Extend body behind bottom navigation
      );
    }
    
    // Material (Android/Desktop) or Desktop with sidebar
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Row(
        children: [
          // Desktop sidebar
          if (!isMobile) _buildDesktopSidebar(),
          
          // Main content
          Expanded(
            child: _buildCurrentScreen(),
          ),
        ],
      ),
      // Mobile bottom navigation (Material)
      bottomNavigationBar: isMobile && !isIOS ? _buildMobileBottomNav() : null,
      extendBody: isMobile && !isIOS ? true : false, // Extend body behind bottom navigation for mobile
    );
  }

  Widget _buildScreenByIndex(int index) {
    switch (index) {
      case 0:
        return _buildScanScreen();
      case 1:
        return _buildDeviceScreen();
      case 2:
        return _buildHistoryScreen();
      case 3:
        return _buildProfileScreen();
      default:
        return _buildScanScreen();
    }
  }

  Widget _buildDesktopSidebar() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSecondary,
        border: Border(
          right: BorderSide(
            color: AppTheme.borderDefault,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo/Title
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXxl),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                const Text(
                  'StitchMe',
                  style: AppTheme.titleSmall,
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                final isSelected = _selectedIndex == index;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingXs,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingL,
                          vertical: AppTheme.spacingM,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryBlue.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? item['selectedIcon'] : item['icon'],
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.textSecondary,
                              size: 24,
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const Divider(height: 1),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorRed),
              title: const Text('Sign Out', style: TextStyle(color: AppTheme.errorRed)),
              onTap: () async {
                await SupabaseService().signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderDefault.withOpacity(0.8),
            width: 1.0,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0), // Even more rounded top corners
          topRight: Radius.circular(28.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 80,
          indicatorColor: AppTheme.primaryBlue.withOpacity(0.1),
          destinations: _navigationItems.map((item) {
            final isSelected = _selectedIndex == _navigationItems.indexOf(item);
            return NavigationDestination(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Icon(
                  item['icon'],
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.primaryBlue.withOpacity(0.6),
                ),
              ),
              selectedIcon: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Icon(
                  item['selectedIcon'],
                  color: AppTheme.primaryBlue,
                ),
              ),
              label: item['label'],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCustomIOSBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderDefault.withOpacity(0.8),
            width: 1.0,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0), // Even more rounded top corners
          topRight: Radius.circular(28.0),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Icon(
                          isSelected ? item['selectedIcon'] : item['icon'],
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.primaryBlue.withOpacity(0.6),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.primaryBlue.withOpacity(0.6),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildScanScreen();
      case 1:
        return _buildDeviceScreen();
      case 2:
        return _buildHistoryScreen();
      case 3:
        return _buildProfileScreen();
      default:
        return _buildScanScreen();
    }
  }

  Widget _buildScanScreen() {
    // Show the wound scanning screen directly as the default view
    return const WoundScanningScreen();
  }

  Widget _buildDeviceScreen() {
    return const DevicePairingScreen();
  }

  Widget _buildHistoryScreen() {
    return const HistoryScreen();
  }

  Widget _buildProfileScreen() {
    return const ProfileScreen();
  }
}
