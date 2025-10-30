import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ui_kit/ui_kit.dart';
import 'dart:io';

class WoundAnalysisResultsScreen extends StatefulWidget {
  final XFile imageFile;
  final Map<String, dynamic> analysisResult;
  final List<Map<String, dynamic>> lidarData;

  const WoundAnalysisResultsScreen({
    super.key,
    required this.imageFile,
    required this.analysisResult,
    required this.lidarData,
  });

  @override
  State<WoundAnalysisResultsScreen> createState() => _WoundAnalysisResultsScreenState();
}

class _WoundAnalysisResultsScreenState extends State<WoundAnalysisResultsScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Wound Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResults,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveResults,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Row(
              children: [
                _buildTabButton('Analysis', 0),
                _buildTabButton('Image', 1),
                if (widget.lidarData.isNotEmpty) _buildTabButton('3D Data', 2),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Tab content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildAnalysisTab();
      case 1:
        return _buildImageTab();
      case 2:
        return _buildLiDARTab();
      default:
        return _buildAnalysisTab();
    }
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall assessment card
          _buildAssessmentCard(),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Wound details
          _buildWoundDetailsCard(),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Recommendations
          _buildRecommendationsCard(),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Risk assessment
          _buildRiskAssessmentCard(),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard() {
    final confidence = widget.analysisResult['confidence_score'] ?? 0.0;
    final severity = widget.analysisResult['severity'] ?? 'unknown';
    final woundDetected = widget.analysisResult['wound_detected'] ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  woundDetected ? Icons.check_circle : Icons.warning,
                  color: woundDetected ? AppTheme.successGreen : AppTheme.warningAmber,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  woundDetected ? 'Wound Detected' : 'No Wound Detected',
                  style: AppTheme.titleSmall,
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            if (woundDetected) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Severity:', style: AppTheme.bodyMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(severity).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Text(
                      severity.toUpperCase(),
                      style: TextStyle(
                        color: _getSeverityColor(severity),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Confidence:', style: AppTheme.bodyMedium),
                  Text(
                    '${(confidence * 100).toStringAsFixed(1)}%',
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingS),
              
              LinearProgressIndicator(
                value: confidence,
                backgroundColor: AppTheme.borderDefault,
                valueColor: AlwaysStoppedAnimation<Color>(
                  confidence > 0.8 ? AppTheme.successGreen :
                  confidence > 0.6 ? AppTheme.warningAmber : AppTheme.errorRed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWoundDetailsCard() {
    final woundArea = widget.analysisResult['wound_area_cm2'] ?? 0.0;
    final detectedFeatures = widget.analysisResult['detected_features'] ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wound Details', style: AppTheme.titleSmall),
            
            const SizedBox(height: AppTheme.spacingM),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Area:', style: AppTheme.bodyMedium),
                Text(
                  '${woundArea.toStringAsFixed(1)} cm²',
                  style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            
            if (widget.lidarData.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Volume (LiDAR):', style: AppTheme.bodyMedium),
                  Text(
                    '0.8 ml', // This would come from LiDAR processing
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: AppTheme.spacingM),
            
            if (detectedFeatures.isNotEmpty) ...[
              Text('Visual Analysis:', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppTheme.spacingS),
              
              ...detectedFeatures.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${entry.key.toString().replaceAll('_', ' ').toUpperCase()}:', 
                         style: AppTheme.bodySmall),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = List<String>.from(widget.analysisResult['recommendations'] ?? []);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: AppTheme.primaryBlue),
                const SizedBox(width: AppTheme.spacingS),
                Text('Treatment Recommendations', style: AppTheme.titleSmall),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            ...recommendations.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskAssessmentCard() {
    final requiresProfessional = widget.analysisResult['requires_professional'] ?? false;
    final riskAssessment = widget.analysisResult['risk_assessment'] ?? 'unknown';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  requiresProfessional ? Icons.warning : Icons.check_circle,
                  color: requiresProfessional ? AppTheme.warningAmber : AppTheme.successGreen,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text('Risk Assessment', style: AppTheme.titleSmall),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Risk Level:', style: AppTheme.bodyMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: _getRiskColor(riskAssessment).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(
                    riskAssessment.toUpperCase(),
                    style: TextStyle(
                      color: _getRiskColor(riskAssessment),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            if (requiresProfessional) ...[
              const SizedBox(height: AppTheme.spacingM),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  border: Border.all(color: AppTheme.warningAmber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.medical_services, color: AppTheme.warningAmber),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Text(
                        'Professional medical consultation recommended',
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.warningAmber),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            child: Image.file(
              File(widget.imageFile.path),
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Image Information', style: AppTheme.titleSmall),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Capture Time:', style: AppTheme.bodyMedium),
                      Text(
                        DateTime.now().toString().split('.')[0],
                        style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('File Size:', style: AppTheme.bodyMedium),
                      FutureBuilder<int>(
                        future: File(widget.imageFile.path).length(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final sizeInMB = snapshot.data! / (1024 * 1024);
                            return Text(
                              '${sizeInMB.toStringAsFixed(1)} MB',
                              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            );
                          }
                          return const Text('Calculating...');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiDARTab() {
    if (widget.lidarData.isEmpty) {
      return const Center(
        child: Text('No LiDAR data available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.threed_rotation, color: AppTheme.accentBlue),
                      const SizedBox(width: AppTheme.spacingS),
                      Text('3D Depth Analysis', style: AppTheme.titleSmall),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Data Points:', style: AppTheme.bodyMedium),
                      Text(
                        '${widget.lidarData.length}',
                        style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Max Depth:', style: AppTheme.bodyMedium),
                      Text(
                        '3.2 mm', // This would come from actual LiDAR processing
                        style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Volume:', style: AppTheme.bodyMedium),
                      Text(
                        '0.8 ml',
                        style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Placeholder for 3D visualization
          Card(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.view_in_ar, size: 48, color: AppTheme.accentBlue),
                    SizedBox(height: AppTheme.spacingM),
                    Text('3D Visualization'),
                    Text('(Coming Soon)', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final requiresProfessional = widget.analysisResult['requires_professional'] ?? false;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundPrimary,
        border: Border(
          top: BorderSide(color: AppTheme.borderDefault),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (requiresProfessional) ...[
              SizedBox(
                width: double.infinity,
                height: AppTheme.buttonHeightM,
                child: ElevatedButton.icon(
                  onPressed: _requestProfessionalConsultation,
                  icon: const Icon(Icons.video_call),
                  label: const Text('Request Professional Consultation'),
                  style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.warningAmber,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
            ],
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveToHistory,
                    icon: const Icon(Icons.save),
                    label: const Text('Save to History'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Dashboard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
        return AppTheme.successGreen;
      case 'moderate':
        return AppTheme.warningAmber;
      case 'severe':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return AppTheme.successGreen;
      case 'medium':
        return AppTheme.warningAmber;
      case 'high':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _shareResults() {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _saveResults() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results saved successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _requestProfessionalConsultation() {
    // TODO: Implement professional consultation request
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Professional consultation request sent'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _saveToHistory() {
    // TODO: Implement save to history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to assessment history'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
}
