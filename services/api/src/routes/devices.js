const express = require('express');
const router = express.Router();

// GET /api/devices - Get all devices (placeholder)
router.get('/', (req, res) => {
    res.json({
        success: true,
        data: [],
        message: 'Devices endpoint - placeholder implementation'
    });
});

module.exports = router;
