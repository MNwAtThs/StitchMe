import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Dummy data for demonstration
  final List<Map<String, dynamic>> _assessments = [
    {
      'id': '1',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'severity': 'Low',
      'severityScore': 3,
      'woundType': 'Laceration',
      'location': 'Left Forearm',
      'status': 'Healing Well',
      'requiresProfessional': false,
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'severity': 'Moderate',
      'severityScore': 6,
      'woundType': 'Abrasion',
      'location': 'Right Knee',
      'status': 'Under Treatment',
      'requiresProfessional': true,
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'severity': 'Low',
      'severityScore': 2,
      'woundType': 'Minor Cut',
      'location': 'Left Hand',
      'status': 'Healed',
      'requiresProfessional': false,
    },
    {
      'id': '4',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'severity': 'High',
      'severityScore': 8,
      'woundType': 'Deep Wound',
      'location': 'Right Leg',
      'status': 'Requires Follow-up',
      'requiresProfessional': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assessment History',
                    style: AppTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '${_assessments.length} total assessments',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Assessment List
            Expanded(
              child: _assessments.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL,
                        vertical: AppTheme.spacingM,
                      ),
                      itemCount: _assessments.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: AppTheme.spacingM,
                      ),
                      itemBuilder: (context, index) {
                        final assessment = _assessments[index];
                        return _buildAssessmentCard(assessment);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(Map<String, dynamic> assessment) {
    final severityColor = _getSeverityColor(assessment['severityScore']);
    final date = assessment['date'] as DateTime;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAssessmentDetails(assessment),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: AppTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(
              color: AppTheme.borderDefault.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Severity Indicator
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Center(
                      child: Text(
                        '${assessment['severityScore']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: severityColor,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: AppTheme.spacingL),
                  
                  // Wound Type and Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assessment['woundType'],
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(date),
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Severity Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                    ),
                    child: Text(
                      assessment['severity'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: severityColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Details Row
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: AppTheme.spacingXs),
                  Text(
                    assessment['location'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingL),
                  Icon(
                    Icons.healing_outlined,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: AppTheme.spacingXs),
                  Expanded(
                    child: Text(
                      assessment['status'],
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (assessment['requiresProfessional']) ...[
                const SizedBox(height: AppTheme.spacingM),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.warningAmber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppTheme.warningAmber,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: Text(
                          'Professional care recommended',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.warningAmber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            ),
            child: const Icon(
              Icons.history,
              size: 50,
              color: AppTheme.successGreen,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'No Assessments Yet',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Your wound assessments will appear here',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(int score) {
    if (score <= 3) {
      return AppTheme.successGreen;
    } else if (score <= 6) {
      return AppTheme.warningAmber;
    } else {
      return AppTheme.errorRed;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  void _showAssessmentDetails(Map<String, dynamic> assessment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.backgroundPrimary,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXl),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: AppTheme.spacingM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingXxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assessment Details',
                      style: AppTheme.titleMedium,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                    
                    _buildDetailRow(
                      'Wound Type',
                      assessment['woundType'],
                      Icons.medical_services_outlined,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    _buildDetailRow(
                      'Location',
                      assessment['location'],
                      Icons.location_on_outlined,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    _buildDetailRow(
                      'Severity',
                      '${assessment['severity']} (${assessment['severityScore']}/10)',
                      Icons.speed_outlined,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    _buildDetailRow(
                      'Status',
                      assessment['status'],
                      Icons.healing_outlined,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    _buildDetailRow(
                      'Date',
                      _formatDate(assessment['date']),
                      Icons.calendar_today_outlined,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXxl),
                    
                    SizedBox(
                      width: double.infinity,
                      height: AppTheme.buttonHeightM,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                      ),
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryBlue,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


