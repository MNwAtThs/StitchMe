import 'package:flutter/material.dart';
import '../widgets/web_app_bar.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(currentPage: 'Progress'),
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
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Project Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Follow our journey building the StitchMe AI-powered wound assessment system',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Progress content
            Container(
              padding: const EdgeInsets.all(80),
              child: Column(
                children: [
                  // Overall progress
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
                          'Overall Project Status',
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
                              child: _buildProgressCard(
                                title: 'Phase 1: Foundation',
                                progress: 1.0,
                                status: 'Complete',
                                color: const Color(0xFF10B981),
                                description: 'Project setup, architecture design, and basic UI implementation',
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildProgressCard(
                                title: 'Phase 2: Core Features',
                                progress: 0.3,
                                status: 'In Progress',
                                color: const Color(0xFF2563EB),
                                description: 'Camera integration, AI models, and device communication',
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildProgressCard(
                                title: 'Phase 3: Integration',
                                progress: 0.0,
                                status: 'Planned',
                                color: const Color(0xFF6B7280),
                                description: 'Hardware integration, testing, and optimization',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Development blog/timeline
                  const Text(
                    'Development Blog',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Blog entries
                  _buildBlogEntry(
                    date: 'October 2024',
                    title: 'Project Kickoff & Architecture Design',
                    content: 'Started our senior design capstone project with initial research into AI-powered medical devices. Completed comprehensive tech stack analysis and chose Flutter + Node.js + Python architecture. Set up monorepo structure with cross-platform applications, backend services, and shared packages.',
                    tags: ['Architecture', 'Planning', 'Tech Stack'],
                    color: const Color(0xFF2563EB),
                  ),
                  
                  _buildBlogEntry(
                    date: 'October 2024',
                    title: 'Flutter Cross-Platform Development',
                    content: 'Implemented basic Flutter application with platform-specific features. Created web homepage, mobile login screens, and desktop dashboard layouts. Successfully demonstrated single codebase running on iOS, Android, Web, Windows, macOS, and Linux platforms.',
                    tags: ['Flutter', 'Cross-Platform', 'UI/UX'],
                    color: const Color(0xFF10B981),
                  ),
                  
                  _buildBlogEntry(
                    date: 'November 2024',
                    title: 'AI Model Development Begins',
                    content: 'Started development of computer vision models for wound detection and classification. Researching PyTorch implementations and gathering training datasets. Initial experiments with OpenCV for image preprocessing and feature extraction.',
                    tags: ['AI/ML', 'Computer Vision', 'PyTorch'],
                    color: const Color(0xFFF59E0B),
                    isUpcoming: true,
                  ),
                  
                  _buildBlogEntry(
                    date: 'November 2024',
                    title: 'LiDAR Integration Research',
                    content: 'Investigating iOS ARKit integration for LiDAR-based 3D wound scanning. Exploring platform channels in Flutter for native iOS functionality. Planning custom native modules for advanced LiDAR features.',
                    tags: ['LiDAR', 'iOS', 'ARKit'],
                    color: const Color(0xFF7C3AED),
                    isUpcoming: true,
                  ),
                  
                  _buildBlogEntry(
                    date: 'December 2024',
                    title: 'Hardware Prototype Development',
                    content: 'Beginning hardware prototype development with Raspberry Pi and motor control systems. Designing mechanical components for precision treatment application. Testing sensor integration for vital signs monitoring.',
                    tags: ['Hardware', 'Raspberry Pi', 'Sensors'],
                    color: const Color(0xFFEF4444),
                    isUpcoming: true,
                  ),
                  
                  _buildBlogEntry(
                    date: 'Spring 2025',
                    title: 'System Integration & Testing',
                    content: 'Final integration of all software and hardware components. Comprehensive testing of AI models, device communication, and safety systems. Preparing for final presentation and demonstration.',
                    tags: ['Integration', 'Testing', 'Final Demo'],
                    color: const Color(0xFF6B7280),
                    isUpcoming: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressCard({
    required String title,
    required double progress,
    required String status,
    required Color color,
    required String description,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBlogEntry({
    required String date,
    required String title,
    required String content,
    required List<String> tags,
    required Color color,
    bool isUpcoming = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUpcoming ? const Color(0xFFE5E7EB) : color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isUpcoming ? const Color(0xFF6B7280) : color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isUpcoming) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'UPCOMING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isUpcoming ? const Color(0xFF6B7280) : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: isUpcoming ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUpcoming 
                    ? const Color(0xFFF3F4F6) 
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUpcoming 
                      ? const Color(0xFFD1D5DB) 
                      : color.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isUpcoming ? const Color(0xFF6B7280) : color,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
