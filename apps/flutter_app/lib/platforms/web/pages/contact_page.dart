import 'package:flutter/material.dart';
import '../widgets/web_app_bar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(currentPage: 'Contact'),
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
                  colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Get in touch with our team for collaboration, questions, or project inquiries',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Contact content
            Container(
              padding: const EdgeInsets.all(80),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Contact info
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get In Touch',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'We\'re always excited to discuss our project, share our progress, and explore potential collaborations in medical technology and AI.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Contact methods
                        _buildContactMethod(
                          icon: Icons.school,
                          title: 'University',
                          subtitle: 'University of Texas at San Antonio',
                          details: 'Electrical and Computer Engineering Department',
                          color: const Color(0xFF2563EB),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        _buildContactMethod(
                          icon: Icons.email,
                          title: 'Project Email',
                          subtitle: 'stitchme.team@utsa.edu',
                          details: 'For project inquiries and collaboration',
                          color: const Color(0xFF10B981),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        _buildContactMethod(
                          icon: Icons.code,
                          title: 'GitHub Repository',
                          subtitle: 'github.com/stitchme-utsa',
                          details: 'View our open-source code and documentation',
                          color: const Color(0xFF6B7280),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        _buildContactMethod(
                          icon: Icons.location_on,
                          title: 'Location',
                          subtitle: 'San Antonio, Texas',
                          details: 'UTSA Main Campus - Engineering Building',
                          color: const Color(0xFFEF4444),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Social/Professional links
                        const Text(
                          'Connect With Our Team',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            _buildSocialButton(
                              icon: Icons.work,
                              label: 'LinkedIn',
                              color: const Color(0xFF0A66C2),
                            ),
                            const SizedBox(width: 12),
                            _buildSocialButton(
                              icon: Icons.code,
                              label: 'GitHub',
                              color: const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 12),
                            _buildSocialButton(
                              icon: Icons.article,
                              label: 'Research',
                              color: const Color(0xFF2563EB),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 80),
                  
                  // Right side - Contact form
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Send us a message',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Contact form
                          _buildFormField(
                            label: 'Name',
                            hint: 'Your full name',
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildFormField(
                            label: 'Email',
                            hint: 'your.email@example.com',
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildFormField(
                            label: 'Organization',
                            hint: 'University, Company, or Institution',
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildFormField(
                            label: 'Subject',
                            hint: 'What would you like to discuss?',
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildFormField(
                            label: 'Message',
                            hint: 'Tell us about your inquiry or collaboration idea...',
                            maxLines: 5,
                          ),
                          
                          const SizedBox(height: 30),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implement form submission
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Thank you for your message! We\'ll get back to you soon.'),
                                    backgroundColor: Color(0xFF10B981),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Send Message',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFBAE6FD)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF0284C7),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: const Text(
                                    'This is an academic project. Response times may vary during semester breaks.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required String details,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
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
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
