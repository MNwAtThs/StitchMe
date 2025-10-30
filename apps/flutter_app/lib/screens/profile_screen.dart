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
      // Get basic profile
      final profileResponse = await _supabaseService.client
          .from('profiles')
          .select('*')
          .eq('id', _supabaseService.currentUser!.id)
          .single();
      
      // Get patient-specific profile if exists
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

      // Show loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Read image bytes
      final bytes = await image.readAsBytes();
      
      // Upload to Supabase Storage
      final fileName = '${_supabaseService.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final avatarUrl = await _supabaseService.uploadFile(
        bucket: 'avatars',
        path: fileName,
        fileBytes: bytes,
        contentType: 'image/jpeg',
      );

      // Update profile
      await _supabaseService.updateProfile(avatarUrl: avatarUrl);

      // Reload profile
      await _loadProfile();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile picture updated!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
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
          child: Column(
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryBlue,
                      AppTheme.accentBlue,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacingXxl),
                    
                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 58,
                            backgroundColor: Colors.white,
                            backgroundImage: avatarUrl != null
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl == null
                                ? Text(
                                    _getInitials(fullName),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        
                        // Edit button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadAvatar,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Name
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingS),
                    
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                      ),
                      child: Text(
                        _formatUserType(userType),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                  ],
                ),
              ),
              
              // Profile Information
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Information Section
                    const Text(
                      'Contact Information',
                      style: AppTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                      iconColor: AppTheme.primaryBlue,
                    ),
                    
                    if (phone.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacingM),
                      _buildInfoCard(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: phone,
                        iconColor: AppTheme.successGreen,
                      ),
                    ],
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                    
                    // Personal Information Section
                    const Text(
                      'Personal Information',
                      style: AppTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    if (dateOfBirth != null) ...[
                      _buildInfoCard(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: _formatDate(dateOfBirth),
                        iconColor: AppTheme.purpleAccent,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                    ],
                    
                    if (bloodType != null && bloodType.isNotEmpty) ...[
                      _buildInfoCard(
                        icon: Icons.bloodtype_outlined,
                        label: 'Blood Type',
                        value: bloodType,
                        iconColor: AppTheme.errorRed,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                    ],
                    
                    _buildInfoCard(
                      icon: Icons.badge_outlined,
                      label: 'User ID',
                      value: user?.id.substring(0, 8) ?? 'N/A',
                      iconColor: AppTheme.textSecondary,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                    
                    // Actions Section
                    const Text(
                      'Account Actions',
                      style: AppTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Edit Profile Button
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: () => _showEditProfileDialog(),
                      iconColor: AppTheme.primaryBlue,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Change Password Button
                    _buildActionButton(
                      icon: Icons.lock_outlined,
                      label: 'Change Password',
                      onTap: () => _showChangePasswordDialog(),
                      iconColor: AppTheme.accentBlue,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Sign Out Button
                    _buildActionButton(
                      icon: Icons.logout,
                      label: 'Sign Out',
                      onTap: () => _showSignOutDialog(),
                      iconColor: AppTheme.warningAmber,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Delete Account Button
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete Account',
                      onTap: () => _showDeleteAccountDialog(),
                      iconColor: AppTheme.errorRed,
                      isDangerous: true,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    bool isDangerous = false,
  }) {
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
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.bodyLarge.copyWith(
                    color: isDangerous ? AppTheme.errorRed : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
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
      return dateString;
    }
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _profile?['full_name'] ?? '');
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
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
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
                await _supabaseService.client
                    .from('profiles')
                    .update({
                      'full_name': nameController.text.trim(),
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
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureCurrent = !obscureCurrent;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
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
                    labelText: 'Confirm New Password',
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
                      content: const Text('New passwords do not match'),
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
                  // Navigate to login screen
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
                border: OutlineInputBorder(),
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
                // Delete user profile and data
                await _supabaseService.client
                    .from('profiles')
                    .delete()
                    .eq('id', _supabaseService.currentUser!.id);

                // Sign out
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
}

