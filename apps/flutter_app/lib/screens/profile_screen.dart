import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabaseService = SupabaseService();
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _patientProfile;
  bool _isLoading = true;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileResponse = await _supabaseService.client
          .from('profiles')
          .select('*')
          .eq('id', _supabaseService.currentUser!.id)
          .single();
      
      final patientProfileResponse = await _supabaseService.client
          .from('patient_profiles')
          .select('*')
          .eq('id', _supabaseService.currentUser!.id)
          .maybeSingle();

      setState(() {
        _profile = profileResponse;
        _patientProfile = patientProfileResponse;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) return;

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final bytes = await image.readAsBytes();
      final fileName = '${_supabaseService.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final avatarUrl = await _supabaseService.uploadFile(
        bucket: 'avatars',
        path: fileName,
        fileBytes: bytes,
        contentType: 'image/jpeg',
      );

      await _supabaseService.updateProfile(avatarUrl: avatarUrl);
      await _loadProfile();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile picture updated!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile picture: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundPrimary,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = _supabaseService.currentUser;
    final fullName = _profile?['full_name'] ?? 'User';
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    final email = _profile?['email'] ?? user?.email ?? '';
    final phone = _profile?['phone'] ?? '';
    final avatarUrl = _profile?['avatar_url'];
    final userType = _profile?['user_type'] ?? 'patient';
    final dateOfBirth = _patientProfile?['date_of_birth'];
    final bloodType = _patientProfile?['blood_type'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Settings',
                  style: AppTheme.titleLarge,
                ),
                
                const SizedBox(height: AppTheme.spacingXxl),
                
                // Profile Section with Picture and Name
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppTheme.backgroundSecondary,
                            backgroundImage: avatarUrl != null
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl == null
                                ? Text(
                                    _getInitials(fullName),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  )
                                : null,
                          ),
                          
                          // Edit button
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAndUploadAvatar,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.backgroundPrimary,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacingL),
                      
                      Text(
                        fullName,
                        style: AppTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppTheme.spacingS),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingL,
                          vertical: AppTheme.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppTheme.successGreen,
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Text(
                              'Joined ${_formatJoinDate(_profile?['created_at'])}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingXxxl),
                
                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildInfoItem(
                  icon: Icons.badge_outlined,
                  label: 'Role',
                  value: _formatUserType(userType),
                  iconColor: AppTheme.purpleAccent,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildInfoItem(
                  icon: Icons.person_outline,
                  label: 'First Name',
                  value: firstName.isNotEmpty ? firstName : 'Not set',
                  iconColor: AppTheme.primaryBlue,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildInfoItem(
                  icon: Icons.person_outline,
                  label: 'Last Name',
                  value: lastName.isNotEmpty ? lastName : 'Not set',
                  iconColor: AppTheme.primaryBlue,
                ),
                
                const SizedBox(height: AppTheme.spacingXxxl),
                
                // Medical Information Section
                _buildSectionTitle('Medical Information'),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildInfoItem(
                  icon: Icons.cake_outlined,
                  label: 'Date of Birth',
                  value: _formatDate(dateOfBirth),
                  iconColor: AppTheme.warningAmber,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildInfoItem(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood Type',
                  value: bloodType ?? 'Not set',
                  iconColor: AppTheme.errorRed,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildInfoItem(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  value: _patientProfile?['weight'] != null 
                      ? '${_patientProfile!['weight']} kg' 
                      : 'Not set',
                  iconColor: AppTheme.purpleAccent,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildInfoItem(
                  icon: Icons.height_outlined,
                  label: 'Height',
                  value: _patientProfile?['height'] != null 
                      ? '${_patientProfile!['height']} cm' 
                      : 'Not set',
                  iconColor: AppTheme.accentBlue,
                ),
                
                const SizedBox(height: AppTheme.spacingXxxl),
                
                // Contact Information Section
                _buildSectionTitle('Contact Information'),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildInfoItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: email,
                  iconColor: AppTheme.accentBlue,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildInfoItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: phone.isNotEmpty ? phone : 'Not set',
                  iconColor: AppTheme.successGreen,
                ),
                
                const SizedBox(height: AppTheme.spacingXxxl),
                
                // Account Actions Section
                _buildSectionTitle('Account Actions'),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildActionItem(
                  icon: Icons.edit_outlined,
                  label: 'Edit Profile',
                  onTap: () => _showEditProfileDialog(),
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildActionItem(
                  icon: Icons.lock_outlined,
                  label: 'Change Password',
                  onTap: () => _showChangePasswordDialog(),
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildActionItem(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  onTap: () => _showSignOutDialog(),
                  color: AppTheme.warningAmber,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildActionItem(
                  icon: Icons.delete_outline,
                  label: 'Delete Account',
                  onTap: () => _showDeleteAccountDialog(),
                  color: AppTheme.errorRed,
                  isDangerous: true,
                ),
                
                const SizedBox(height: AppTheme.spacingXxxl),
                
                // Legal & Info Section
                _buildSectionTitle('Legal & Information'),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildActionItem(
                  icon: Icons.description_outlined,
                  label: 'Terms & Conditions',
                  onTap: () => _showTermsDialog(),
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                _buildActionItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () => _showPrivacyDialog(),
                ),
                
                const SizedBox(height: AppTheme.spacingXxxl),
                
                // App Info Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundSecondary,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: AppTheme.spacingS),
                                Text(
                                  'Version 1.0.0',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacingL),
                      
                      // Made with love
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Made with',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.favorite,
                            size: 16,
                            color: AppTheme.errorRed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'at UTSA',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacingS),
                      
                      Text(
                        '© 2024 StitchMe. All rights reserved.',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingXxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.titleSmall.copyWith(
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    bool isDangerous = false,
  }) {
    final itemColor = color ?? AppTheme.textPrimary;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: isDangerous
                ? AppTheme.errorRed.withOpacity(0.05)
                : AppTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: isDangerous
                ? Border.all(
                    color: AppTheme.errorRed.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: itemColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.bodyLarge.copyWith(
                    color: itemColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String _formatUserType(String userType) {
    switch (userType) {
      case 'patient':
        return 'Patient';
      case 'healthcare_provider':
      case 'healthcareProvider':
        return 'Healthcare Provider';
      default:
        return userType.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not set';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Not set';
    }
  }

  String _formatJoinDate(String? dateString) {
    if (dateString == null) return 'recently';
    try {
      final date = DateTime.parse(dateString);
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${monthNames[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'recently';
    }
  }

  void _showEditProfileDialog() {
    final fullName = _profile?['full_name'] ?? '';
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);
    final phoneController = TextEditingController(text: _profile?['phone'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final newFullName = '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim();
                
                await _supabaseService.client
                    .from('profiles')
                    .update({
                      'full_name': newFullName,
                      'phone': phoneController.text.trim(),
                      'updated_at': DateTime.now().toIso8601String(),
                    })
                    .eq('id', _supabaseService.currentUser!.id);

                await _loadProfile();

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated successfully!'),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update profile: $e'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        obscureNew = !obscureNew;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                  ),
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
                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Passwords do not match'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                  return;
                }

                try {
                  await _supabaseService.client.auth.updateUser(
                    UserAttributes(password: newPasswordController.text),
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Password changed successfully!'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to change password: $e'),
                        backgroundColor: AppTheme.errorRed,
                      ),
                    );
                  }
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _supabaseService.signOut();
                
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to sign out: $e'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningAmber,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            const Text(
              'Type "DELETE" to confirm:',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: 'DELETE',
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
              if (confirmController.text.trim().toUpperCase() != 'DELETE') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please type DELETE to confirm'),
                    backgroundColor: AppTheme.errorRed,
                  ),
                );
                return;
              }

              try {
                await _supabaseService.client
                    .from('profiles')
                    .delete()
                    .eq('id', _supabaseService.currentUser!.id);

                await _supabaseService.signOut();

                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete account: $e'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms & Conditions for StitchMe\n\n'
            'By using this application, you agree to our terms and conditions.\n\n'
            '1. Medical Disclaimer: This app provides information and suggestions but does not replace professional medical advice.\n\n'
            '2. Data Usage: We collect and process your medical data securely to provide wound assessment services.\n\n'
            '3. User Responsibilities: You are responsible for the accuracy of information provided.\n\n'
            '4. Service Availability: We strive to maintain service availability but cannot guarantee uninterrupted access.\n\n'
            'For complete terms, please visit our website.',
            style: AppTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy for StitchMe\n\n'
            'We take your privacy seriously and are committed to protecting your personal and medical information.\n\n'
            '1. Information Collection: We collect personal information, medical data, and device usage data to provide our services.\n\n'
            '2. Data Security: Your data is encrypted and stored securely using industry-standard practices.\n\n'
            '3. Data Sharing: We do not sell your data. Information is shared only with healthcare providers you authorize.\n\n'
            '4. Your Rights: You have the right to access, modify, or delete your data at any time.\n\n'
            'For our complete privacy policy, please visit our website.',
            style: AppTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
