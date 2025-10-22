import 'package:flutter/material.dart';
import '../widgets/web_app_bar.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(currentPage: 'Research'),
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
                  colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Research & Development',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Advancing wound care through artificial intelligence and automated treatment systems',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Content sections
            Container(
              padding: const EdgeInsets.all(80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Problem Statement
                  _buildSection(
                    title: 'Problem Statement',
                    content: 'Traditional wound care relies heavily on manual assessment and treatment, which can be subjective, time-consuming, and inconsistent. Healthcare providers often lack immediate access to specialized wound care expertise, particularly in remote or underserved areas. Our research addresses these challenges through an AI-powered automated wound assessment and treatment system.',
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Research Objectives
                  _buildSection(
                    title: 'Research Objectives',
                    content: '',
                    customContent: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildObjective('Develop computer vision algorithms for accurate wound classification and severity assessment'),
                        _buildObjective('Integrate LiDAR technology for precise 3D wound measurement and mapping'),
                        _buildObjective('Create automated treatment dispensing system with safety protocols'),
                        _buildObjective('Implement telemedicine capabilities for remote healthcare provider consultation'),
                        _buildObjective('Design cross-platform applications for seamless device control and monitoring'),
                        _buildObjective('Ensure HIPAA compliance and medical-grade security standards'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Technical Approach
                  _buildSection(
                    title: 'Technical Approach',
                    content: '',
                    customContent: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildTechCard(
                            title: 'Computer Vision & AI',
                            items: [
                              'PyTorch deep learning models',
                              'OpenCV image processing',
                              'Wound classification algorithms',
                              'Severity assessment metrics',
                              'Real-time inference optimization',
                            ],
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: _buildTechCard(
                            title: 'Hardware Integration',
                            items: [
                              'LiDAR 3D scanning (iOS ARKit)',
                              'Precision motor control systems',
                              'Multi-sensor vital monitoring',
                              'Automated dispensing mechanisms',
                              'Safety and emergency protocols',
                            ],
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: _buildTechCard(
                            title: 'Software Architecture',
                            items: [
                              'Flutter cross-platform apps',
                              'Node.js API microservices',
                              'WebRTC telemedicine integration',
                              'Supabase cloud infrastructure',
                              'Real-time data synchronization',
                            ],
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Expected Outcomes
                  _buildSection(
                    title: 'Expected Outcomes',
                    content: 'Our research aims to demonstrate significant improvements in wound care efficiency, accuracy, and accessibility. We expect to achieve 90%+ accuracy in wound classification, reduce assessment time by 60%, and enable remote wound care in underserved areas. The system will serve as a proof-of-concept for AI-powered medical devices and contribute to the growing field of automated healthcare.',
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Academic Context
                  _buildSection(
                    title: 'Academic Context',
                    content: '',
                    customContent: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.school, color: Color(0xFF2563EB), size: 24),
                              const SizedBox(width: 12),
                              const Text(
                                'University of Texas at San Antonio',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildAcademicDetail('Program', 'Electrical and Computer Engineering'),
                          _buildAcademicDetail('Course', 'Senior Design Capstone (ECE 4953/4963)'),
                          _buildAcademicDetail('Duration', 'Fall 2024 - Spring 2025'),
                          _buildAcademicDetail('Team Size', '4-5 Engineering Students'),
                          _buildAcademicDetail('Advisor', 'Dr. [Faculty Advisor Name]'),
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
  
  Widget _buildSection({
    required String title,
    required String content,
    Widget? customContent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 20),
        if (content.isNotEmpty)
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        if (customContent != null) customContent,
      ],
    );
  }
  
  Widget _buildObjective(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTechCard({
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildAcademicDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
