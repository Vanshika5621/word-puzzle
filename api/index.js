const express = require('express');
const nodemailer = require('nodemailer');
const { createClient } = require('@supabase/supabase-js');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// Initialize Supabase Client
const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Email Transporter setup
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

// Helper: Generate 6-digit OTP
const generateOTP = () => {
    return Math.floor(100000 + Math.random() * 900000).toString();
};

// Route: Send OTP
app.post('/auth/send-otp', async (req, res) => {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: 'Email is required' });

    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes expiry

    try {
        // 1. Save OTP to Supabase
        await supabase
            .from('otps')
            .upsert({ email, code: otp, expires_at: expiresAt.toISOString() }, { onConflict: 'email' });

        // 2. Send Email (Non-blocking if possible, but for reliability we wait)
        const mailOptions = {
            from: `"Word Puzzle" <${process.env.EMAIL_USER}>`,
            to: email,
            subject: 'Your Login OTP',
            text: `Your 6-digit OTP is: ${otp}. It will expire in 10 minutes.`
        };

        await transporter.sendMail(mailOptions);
        res.json({ success: true, message: 'OTP sent successfully' });
    } catch (error) {
        console.error('Error sending OTP:', error);
        
        let errorMessage = 'Failed to send OTP';
        if (error.message && error.message.includes('relation "otps" does not exist')) {
            errorMessage = 'Database Table Missing: Please run the SQL code in Supabase Editor.';
        } else if (error.message && error.message.includes('Username and Password not accepted')) {
            errorMessage = 'Gmail Error: Your App Password in .env is incorrect.';
        } else if (error.message) {
            errorMessage = error.message;
        }
        
        res.status(500).json({ success: false, error: errorMessage });
    }
});

// Route: Verify OTP
app.post('/auth/verify-otp', async (req, res) => {
    const { email, otp } = req.body;
    if (!email || !otp) return res.status(400).json({ error: 'Email and OTP are required' });

    try {
        // 1. Get OTP from database
        const { data, error } = await supabase
            .from('otps')
            .select('*')
            .eq('email', email)
            .single();

        if (error || !data) {
            return res.status(400).json({ error: 'OTP not found or expired' });
        }

        // 2. Check if expired
        if (new Date(data.expires_at) < new Date()) {
            return res.status(400).json({ error: 'OTP expired' });
        }

        // 3. Verify code
        if (data.code !== otp) {
            return res.status(400).json({ error: 'Invalid OTP' });
        }

        // 4. Success - Clear OTP and return success
        await supabase.from('otps').delete().eq('email', email);

        // Optionally: Create/Get user from 'users' table
        let { data: user, error: userError } = await supabase
            .from('users')
            .select('*')
            .eq('email', email)
            .single();

        if (!user) {
            const { data: newUser, error: createError } = await supabase
                .from('users')
                .insert({ email })
                .select()
                .single();
            user = newUser;
        }

        res.json({ success: true, user });
    } catch (error) {
        console.error('Error verifying OTP:', error);
        res.status(500).json({ success: false, error: 'Verification failed' });
    }
});

app.get('/', (req, res) => {
    res.send('Backend is running 🚀');
});

// 🚀 Export for Vercel
module.exports = app;
