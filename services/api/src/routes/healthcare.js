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
    }
});

// Middleware to verify authentication and healthcare provider role
const verifyHealthcareProvider = async (req, res, next) => {
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

        // Check if user is a healthcare provider
        const { data: profile, error: profileError } = await supabase
            .from('profiles')
            .select('user_type')
            .eq('id', user.id)
            .single();

        if (profileError || profile.user_type !== 'healthcare_provider') {
            return res.status(403).json({
                success: false,
                error: 'Healthcare provider access required'
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

// GET /api/healthcare/profile - Get healthcare provider profile
router.get('/profile', verifyHealthcareProvider, async (req, res) => {
    try {
        const { data: profile, error } = await supabase
            .from('profiles')
            .select(`
        *,
        healthcare_provider_profiles(*)
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

// PUT /api/healthcare/profile - Update healthcare provider profile
router.put('/profile', verifyHealthcareProvider, async (req, res) => {
    try {
        const { fullName, licenseNumber, specialization, hospitalAffiliation, department } = req.body;

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

        // Update or create healthcare provider profile
        const { error: providerError } = await supabase
            .from('healthcare_provider_profiles')
            .upsert({
                id: req.user.id,
                license_number: licenseNumber,
                specialization: specialization,
                hospital_affiliation: hospitalAffiliation,
                department: department,
                updated_at: new Date().toISOString()
            });

        if (providerError) {
            return res.status(500).json({
                success: false,
                error: 'Failed to update provider profile',
                message: providerError.message
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

// GET /api/healthcare/patients - Get list of patients
router.get('/patients', verifyHealthcareProvider, async (req, res) => {
    try {
        const { page = 1, limit = 10, search } = req.query;
        const offset = (page - 1) * limit;

        let query = supabase
            .from('profiles')
            .select(`
        id,
        full_name,
        email,
        created_at,
        patient_profiles(*)
      `)
            .eq('user_type', 'patient')
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (search) {
            query = query.or(`full_name.ilike.%${search}%,email.ilike.%${search}%`);
        }

        const { data: patients, error } = await query;

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch patients',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: patients
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch patients',
            message: error.message
        });
    }
});

// GET /api/healthcare/patients/:patientId/assessments - Get patient assessments
router.get('/patients/:patientId/assessments', verifyHealthcareProvider, async (req, res) => {
    try {
        const { patientId } = req.params;
        const { page = 1, limit = 10 } = req.query;
        const offset = (page - 1) * limit;

        const { data: assessments, error } = await supabase
            .from('wound_assessments')
            .select(`
        *,
        devices(device_name, device_type),
        profiles!wound_assessments_patient_id_fkey(full_name, email)
      `)
            .eq('patient_id', patientId)
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch patient assessments',
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
            error: 'Failed to fetch patient assessments',
            message: error.message
        });
    }
});

// POST /api/healthcare/medical-records - Create medical record
router.post('/medical-records', verifyHealthcareProvider, upload.array('attachments', 5), async (req, res) => {
    try {
        const { patientId, recordType, title, description, data } = req.body;

        // Upload attachments to Supabase Storage
        const attachmentUrls = [];
        if (req.files && req.files.length > 0) {
            for (const file of req.files) {
                const fileName = `medical-records/${patientId}/${uuidv4()}-${file.originalname}`;
                const { data: uploadData, error } = await supabaseAdmin.storage
                    .from(STORAGE_BUCKETS.MEDICAL_FILES)
                    .upload(fileName, file.buffer, {
                        contentType: file.mimetype,
                        cacheControl: '3600'
                    });

                if (error) {
                    return res.status(500).json({
                        success: false,
                        error: 'Failed to upload attachment',
                        message: error.message
                    });
                }

                // Get public URL
                const { data: urlData } = supabaseAdmin.storage
                    .from(STORAGE_BUCKETS.MEDICAL_FILES)
                    .getPublicUrl(fileName);

                attachmentUrls.push(urlData.publicUrl);
            }
        }

        // Create medical record
        const { data: record, error } = await supabase
            .from('medical_records')
            .insert({
                patient_id: patientId,
                provider_id: req.user.id,
                record_type: recordType,
                title: title,
                description: description,
                data: data ? JSON.parse(data) : null,
                attachments: attachmentUrls
            })
            .select(`
        *,
        profiles!medical_records_patient_id_fkey(full_name, email)
      `)
            .single();

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to create medical record',
                message: error.message
            });
        }

        res.status(201).json({
            success: true,
            data: record,
            message: 'Medical record created successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to create medical record',
            message: error.message
        });
    }
});

// POST /api/healthcare/treatment-plans - Create treatment plan
router.post('/treatment-plans', verifyHealthcareProvider, async (req, res) => {
    try {
        const { patientId, assessmentId, planName, description, steps, medications, followUpDate } = req.body;

        const { data: plan, error } = await supabase
            .from('treatment_plans')
            .insert({
                patient_id: patientId,
                provider_id: req.user.id,
                assessment_id: assessmentId,
                plan_name: planName,
                description: description,
                steps: steps ? JSON.parse(steps) : null,
                medications: medications ? JSON.parse(medications) : null,
                follow_up_date: followUpDate
            })
            .select(`
        *,
        profiles!treatment_plans_patient_id_fkey(full_name, email),
        wound_assessments(id, severity_score, treatment_recommendation)
      `)
            .single();

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to create treatment plan',
                message: error.message
            });
        }

        res.status(201).json({
            success: true,
            data: plan,
            message: 'Treatment plan created successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to create treatment plan',
            message: error.message
        });
    }
});

// GET /api/healthcare/video-sessions - Get video sessions
router.get('/video-sessions', verifyHealthcareProvider, async (req, res) => {
    try {
        const { page = 1, limit = 10, status } = req.query;
        const offset = (page - 1) * limit;

        let query = supabase
            .from('video_sessions')
            .select(`
        *,
        profiles!video_sessions_patient_id_fkey(full_name, email),
        wound_assessments(id, severity_score, treatment_recommendation)
      `)
            .eq('provider_id', req.user.id)
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (status) {
            query = query.eq('session_status', status);
        }

        const { data: sessions, error } = await query;

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch video sessions',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: sessions
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to fetch video sessions',
            message: error.message
        });
    }
});

// POST /api/healthcare/video-sessions - Create video session
router.post('/video-sessions', verifyHealthcareProvider, async (req, res) => {
    try {
        const { patientId, assessmentId, sessionNotes } = req.body;

        const { data: session, error } = await supabase
            .from('video_sessions')
            .insert({
                patient_id: patientId,
                provider_id: req.user.id,
                assessment_id: assessmentId,
                session_notes: sessionNotes
            })
            .select(`
        *,
        profiles!video_sessions_patient_id_fkey(full_name, email)
      `)
            .single();

        if (error) {
            return res.status(500).json({
                success: false,
                error: 'Failed to create video session',
                message: error.message
            });
        }

        res.status(201).json({
            success: true,
            data: session,
            message: 'Video session created successfully'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Failed to create video session',
            message: error.message
        });
    }
});

module.exports = router;
