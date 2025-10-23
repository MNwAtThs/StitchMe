const express = require('express');
const router = express.Router();
const { supabase, supabaseAdmin } = require('../config/supabase');

// POST /api/auth/login
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                success: false,
                error: 'Email and password are required'
            });
        }

        // Authenticate with Supabase
        const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password
        });

        if (error) {
            return res.status(401).json({
                success: false,
                error: 'Invalid credentials',
                message: error.message
            });
        }

        // Get user profile
        const { data: profile, error: profileError } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', data.user.id)
            .single();

        if (profileError) {
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch user profile',
                message: profileError.message
            });
        }

        res.json({
            success: true,
            data: {
                user: {
                    id: data.user.id,
                    email: data.user.email,
                    fullName: profile.full_name,
                    userType: profile.user_type,
                    avatarUrl: profile.avatar_url
                },
                session: data.session
            },
            message: 'Login successful'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Login failed',
            message: error.message
        });
    }
});

// POST /api/auth/register
router.post('/register', async (req, res) => {
    try {
        const { email, password, fullName, userType } = req.body;

        if (!email || !password || !fullName || !userType) {
            return res.status(400).json({
                success: false,
                error: 'Email, password, full name, and user type are required'
            });
        }

        // Register user with Supabase
        const { data, error } = await supabase.auth.signUp({
            email,
            password,
            options: {
                data: {
                    full_name: fullName,
                    user_type: userType
                }
            }
        });

        if (error) {
            return res.status(400).json({
                success: false,
                error: 'Registration failed',
                message: error.message
            });
        }

        // The profile will be automatically created by the trigger
        res.status(201).json({
            success: true,
            data: {
                user: {
                    id: data.user.id,
                    email: data.user.email,
                    fullName: fullName,
                    userType: userType
                }
            },
            message: 'Registration successful. Please check your email to confirm your account.'
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: 'Registration failed',
            message: error.message
        });
    }
});

// POST /api/auth/logout
router.post('/logout', async (req, res) => {
    try {
        const { session } = req.body;

        if (session?.access_token) {
            const { error } = await supabase.auth.signOut();
            if (error) {
                return res.status(400).json({
                    success: false,
                    error: 'Logout failed',
                    message: error.message
                });
            }
        }

        res.json({
            success: true,
            message: 'Logout successful'
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: 'Logout failed',
            message: error.message
        });
    }
});

// POST /api/auth/refresh
router.post('/refresh', async (req, res) => {
    try {
        const { refresh_token } = req.body;

        if (!refresh_token) {
            return res.status(400).json({
                success: false,
                error: 'Refresh token is required'
            });
        }

        const { data, error } = await supabase.auth.refreshSession({
            refresh_token
        });

        if (error) {
            return res.status(401).json({
                success: false,
                error: 'Token refresh failed',
                message: error.message
            });
        }

        res.json({
            success: true,
            data: {
                session: data.session
            },
            message: 'Token refreshed'
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: 'Token refresh failed',
            message: error.message
        });
    }
});

module.exports = router;
