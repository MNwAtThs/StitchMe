const express = require('express');
const router = express.Router();

// GET /api/users - Get all users (placeholder)
router.get('/', (req, res) => {
    res.json({
        success: true,
        data: [],
        message: 'Users endpoint - placeholder implementation'
    });
});

module.exports = router;
