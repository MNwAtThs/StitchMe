import 'package:flutter/material.dart';
import '../widgets/web_app_bar.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(currentPage: 'Features'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'System Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Comprehensive AI-powered wound care capabilities across all platforms',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Features content
            Container(
              padding: const EdgeInsets.all(80),
              child: Column(
                children: [
                  // AI & Computer Vision Features
                  _buildFeatureSection(
                    title: 'AI & Computer Vision',
                    subtitle: 'Advanced machine learning for accurate wound assessment',
                    features: [
                      _buildFeatureItem(
                        icon: Icons.visibility,
                        title: 'Automated Wound Detection',
                        description: 'Computer vision algorithms automatically identify and classify wound types with 90%+ accuracy',
                        color: const Color(0xFF2563EB),
                      ),
                      _buildFeatureItem(
                        icon: Icons.analytics,
                        title: 'Severity Assessment',
                        description: 'AI-powered analysis determines wound severity levels and healing progress over time',
                        color: const Color(0xFF7C3AED),
                      ),
                      _buildFeatureItem(
                        icon: Icons.psychology,
                        title: 'Treatment Recommendations',
                        description: 'Machine learning models suggest optimal treatment protocols based on wound characteristics',
                        color: const Color(0xFFDC2626),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Hardware Integration Features
                  _buildFeatureSection(
                    title: 'Hardware Integration',
                    subtitle: 'Cutting-edge sensors and precision control systems',
                    features: [
                      _buildFeatureItem(
                        icon: Icons.threed_rotation,
                        title: 'LiDAR 3D Scanning',
                        description: 'iPhone LiDAR technology creates precise 3D wound maps for accurate measurement and monitoring',
                        color: const Color(0xFF10B981),
                      ),
                      _buildFeatureItem(
                        icon: Icons.precision_manufacturing,
                        title: 'Automated Dispensing',
                        description: 'Precision motor control system applies skin glue, cleaning solutions, and sanitizers',
                        color: const Color(0xFFF59E0B),
                      ),
                      _buildFeatureItem(
                        icon: Icons.health_and_safety,
                        title: 'Vital Signs Monitoring',
                        description: 'Non-invasive sensors monitor patient vitals during treatment for comprehensive care',
                        color: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Cross-Platform Features
                  _buildFeatureSection(
                    title: 'Cross-Platform Applications',
                    subtitle: 'Seamless experience across all devices and platforms',
                    features: [
                      _buildFeatureItem(
                        icon: Icons.phone_android,
                        title: 'Mobile Apps (iOS/Android)',
                        description: 'Native mobile apps with camera integration, LiDAR scanning, and device pairing capabilities',
                        color: const Color(0xFF06B6D4),
                      ),
                      _buildFeatureItem(
                        icon: Icons.desktop_windows,
                        title: 'Desktop Applications',
                        description: 'Professional desktop apps for healthcare providers with advanced device management',
                        color: const Color(0xFF8B5CF6),
                      ),
                      _buildFeatureItem(
                        icon: Icons.web,
                        title: 'Web Dashboard',
                        description: 'Browser-based management interface for hospitals and healthcare facilities',
                        color: const Color(0xFF059669),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Communication Features
                  _buildFeatureSection(
                    title: 'Communication & Connectivity',
                    subtitle: 'Advanced telemedicine and device integration capabilities',
                    features: [
                      _buildFeatureItem(
                        icon: Icons.video_call,
                        title: 'Video Telemedicine',
                        description: 'High-quality WebRTC video calling connects patients with healthcare professionals',
                        color: const Color(0xFFDC2626),
                      ),
                      _buildFeatureItem(
                        icon: Icons.bluetooth,
                        title: 'Device Pairing',
                        description: 'Seamless Bluetooth and WiFi connectivity between mobile apps and treatment device',
                        color: const Color(0xFF2563EB),
                      ),
                      _buildFeatureItem(
                        icon: Icons.sync,
                        title: 'Real-time Sync',
                        description: 'Instant data synchronization across all connected devices and platforms',
                        color: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Security & Compliance
                  _buildFeatureSection(
                    title: 'Security & Compliance',
                    subtitle: 'Medical-grade security and regulatory compliance',
                    features: [
                      _buildFeatureItem(
                        icon: Icons.security,
                        title: 'HIPAA Compliance',
                        description: 'End-to-end encryption and secure data handling meeting healthcare privacy standards',
                        color: const Color(0xFF7C3AED),
                      ),
                      _buildFeatureItem(
                        icon: Icons.verified_user,
                        title: 'Role-Based Access',
                        description: 'Secure authentication with patient and healthcare provider permission levels',
                        color: const Color(0xFFEF4444),
                      ),
                      _buildFeatureItem(
                        icon: Icons.history,
                        title: 'Audit Logging',
                        description: 'Complete audit trail of all medical data access and treatment activities',
                        color: const Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureSection({
    required String title,
    required String subtitle,
    required List<Widget> features,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: feature,
        )),
      ],
    );
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
