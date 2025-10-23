const express = require('express');
const router = express.Router();
const { supabase, supabaseAdmin, STORAGE_BUCKETS } = require('../config/supabase');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');

// Configure multer for file uploads
const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024, // 10MB limit
    },
    fileFilter: (req, file, cb) => {
        // Allow only image files
        if (file.mimetype.startsWith('image/')) {
            cb(null, true);
        } else {
            cb(new Error('Only image files are allowed'), false);
        }
    }
});

// Middleware to verify authentication
const verifyAuth = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.replace('Bearer ', '');
        if (!token) {
            return res.status(401).json({
                success: false,
                error: 'Authentication required'
            });
        }

        const { data: { user }, error } = await supabase.auth.getUser(token);
        if (error || !user) {
            return res.status(401).json({
                success: false,
                error: 'Invalid token'
            });
        }

        req.user = user;
        next();
    } catch (error) {
        res.status(401).json({
            success: false,
            error: 'Authentication failed'
        });
    }
};

// GET /api/patients/profile - Get patient profile
router.get('/profile', verifyAuth, async (req, res) => {
    try {
        const { data: profile, error } = await supabase
            .from('profiles')
            .select(`
        *,
        patient_profiles(*)
      `)
            .eq('id', req.user.id)
            .single();

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch profile',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: profile
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch profile',
            message: error.message
        });
    }
});

// PUT /api/patients/profile - Update patient profile
router.put('/profile', verifyAuth, async (req, res) => {
    try {
        const { fullName, dateOfBirth, height, weight, bloodType, allergies, medicalHistory, emergencyContact } = req.body;

        // Update main profile
        const { error: profileError } = await supabase
            .from('profiles')
            .update({
                full_name: fullName,
                updated_at: new Date().toISOString()
            })
            .eq('id', req.user.id);

        if (profileError) {
            return res.status(500).json({
                success: false,
                error: 'Failed to update profile',
                message: profileError.message
            });
        }

        // Update or create patient profile
        const { error: patientError } = await supabase
            .from('patient_profiles')
            .upsert({
                id: req.user.id,
                date_of_birth: dateOfBirth,
                height: height,
                weight: weight,
                blood_type: bloodType,
                allergies: allergies,
                medical_history: medicalHistory,
                emergency_contact: emergencyContact,
                updated_at: new Date().toISOString()
            });

        if (patientError) {
            return res.status(500).json({
                success: false,
                error: 'Failed to update patient profile',
                message: patientError.message
            });
        }

        res.json({
            success: true,
            message: 'Profile updated successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to update profile',
            message: error.message
        });
    }
});

// GET /api/patients/assessments - Get patient wound assessments
router.get('/assessments', verifyAuth, async (req, res) => {
    try {
        const { page = 1, limit = 10 } = req.query;
        const offset = (page - 1) * limit;

        const { data: assessments, error } = await supabase
            .from('wound_assessments')
            .select(`
        *,
        devices(device_name, device_type)
      `)
            .eq('patient_id', req.user.id)
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch assessments',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: assessments
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch assessments',
            message: error.message
        });
    }
});

// POST /api/patients/assessments - Create new wound assessment
router.post('/assessments', verifyAuth, upload.array('images', 5), async (req, res) => {
    try {
        const { deviceId, lidarData, aiAnalysis, severityScore, treatmentRecommendation, requiresProfessional, locationOnBody, woundType, measurements } = req.body;

        // Upload images to Supabase Storage
        const imageUrls = [];
        if (req.files && req.files.length > 0) {
            for (const file of req.files) {
                const fileName = `${req.user.id}/${uuidv4()}-${file.originalname}`;
                const { data, error } = await supabaseAdmin.storage
                    .from(STORAGE_BUCKETS.PATIENT_IMAGES)
                    .upload(fileName, file.buffer, {
                        contentType: file.mimetype,
                        cacheControl: '3600'
                    });

                if (error) {
                    return res.status(500).json({
                        success: false,
                        error: 'Failed to upload image',
                        message: error.message
                    });
                }

                // Get public URL
                const { data: urlData } = supabaseAdmin.storage
                    .from(STORAGE_BUCKETS.PATIENT_IMAGES)
                    .getPublicUrl(fileName);

                imageUrls.push(urlData.publicUrl);
            }
        }

        // Create wound assessment
        const { data: assessment, error } = await supabase
            .from('wound_assessments')
            .insert({
                patient_id: req.user.id,
                device_id: deviceId,
                images: imageUrls,
                lidar_data: lidarData ? JSON.parse(lidarData) : null,
                ai_analysis: aiAnalysis ? JSON.parse(aiAnalysis) : null,
                severity_score: parseInt(severityScore),
                treatment_recommendation: treatmentRecommendation,
                requires_professional: requiresProfessional === 'true',
                location_on_body: locationOnBody,
                wound_type: woundType,
                measurements: measurements ? JSON.parse(measurements) : null
            })
            .select()
            .single();

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to create assessment',
                message: error.message
            });
        }

        res.status(201).json({
            success: true,
            data: assessment,
            message: 'Assessment created successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to create assessment',
            message: error.message
        });
    }
});

// GET /api/patients/medical-records - Get patient medical records
router.get('/medical-records', verifyAuth, async (req, res) => {
    try {
        const { page = 1, limit = 10, recordType } = req.query;
        const offset = (page - 1) * limit;

        let query = supabase
            .from('medical_records')
            .select(`
        *,
        profiles!medical_records_provider_id_fkey(full_name, user_type)
      `)
            .eq('patient_id', req.user.id)
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (recordType) {
            query = query.eq('record_type', recordType);
        }

        const { data: records, error } = await query;

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch medical records',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: records
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch medical records',
            message: error.message
        });
    }
});

// GET /api/patients/treatment-plans - Get patient treatment plans
router.get('/treatment-plans', verifyAuth, async (req, res) => {
    try {
        const { page = 1, limit = 10, status } = req.query;
        const offset = (page - 1) * limit;

        let query = supabase
            .from('treatment_plans')
            .select(`
        *,
        profiles!treatment_plans_provider_id_fkey(full_name, user_type),
        wound_assessments(id, severity_score, treatment_recommendation)
      `)
            .eq('patient_id', req.user.id)
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (status) {
            query = query.eq('status', status);
        }

        const { data: plans, error } = await query;

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch treatment plans',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: plans
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch treatment plans',
            message: error.message
        });
    }
});

module.exports = router;
