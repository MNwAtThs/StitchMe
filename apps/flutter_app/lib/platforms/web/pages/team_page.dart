import 'package:flutter/material.dart';
import '../widgets/web_app_bar.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(currentPage: 'Team'),
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
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Meet Our Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Electrical and Computer Engineering students passionate about medical technology',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Team content
            Container(
              padding: const EdgeInsets.all(80),
              child: Column(
                children: [
                  // Team members grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40,
                    childAspectRatio: 1.2,
                    children: [
                      _buildTeamMember(
                        name: 'Sergio Deleon Jr.',
                        role: 'Project Lead & Software Engineer',
                        specialization: 'Full-Stack Development, AI Integration',
                        description: 'Leading the software architecture and cross-platform app development. Specializes in Flutter, Node.js, and AI/ML integration.',
                        color: const Color(0xFF2563EB),
                        initials: 'SD',
                      ),
                      _buildTeamMember(
                        name: 'Team Member 2',
                        role: 'Hardware Engineer',
                        specialization: 'Embedded Systems, Motor Control',
                        description: 'Responsible for device hardware design, motor control systems, and sensor integration.',
                        color: const Color(0xFF10B981),
                        initials: 'TM',
                      ),
                      _buildTeamMember(
                        name: 'Team Member 3',
                        role: 'AI/ML Engineer',
                        specialization: 'Computer Vision, Machine Learning',
                        description: 'Developing computer vision algorithms for wound detection and AI-powered treatment recommendations.',
                        color: const Color(0xFFF59E0B),
                        initials: 'TM',
                      ),
                      _buildTeamMember(
                        name: 'Team Member 4',
                        role: 'Systems Integration Engineer',
                        specialization: 'Hardware-Software Integration',
                        description: 'Ensuring seamless integration between software applications and physical device hardware.',
                        color: const Color(0xFFEF4444),
                        initials: 'TM',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Faculty advisor section
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Faculty Advisor',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Center(
                                child: Text(
                                  'Dr',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dr. [Faculty Advisor Name]',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Professor, Electrical and Computer Engineering',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Providing guidance on medical device design, regulatory compliance, and academic research methodology.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4B5563),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Project timeline
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Project Timeline',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimelineItem(
                                title: 'Fall 2024',
                                subtitle: 'Senior Design I',
                                description: 'Research, design, and software development phase',
                                color: const Color(0xFF2563EB),
                                isActive: true,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: _buildTimelineItem(
                                title: 'Spring 2025',
                                subtitle: 'Senior Design II',
                                description: 'Hardware integration, testing, and final presentation',
                                color: const Color(0xFF10B981),
                                isActive: false,
                              ),
                            ),
                          ],
                        ),
                      ],
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
  
  Widget _buildTeamMember({
    required String name,
    required String role,
    required String specialization,
    required String description,
    required Color color,
    required String initials,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            specialization,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.1) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : const Color(0xFFE5E7EB),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? color : const Color(0xFF6B7280),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'CURRENT' : 'UPCOMING',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isActive ? color : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
