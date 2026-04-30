const nodemailer = require('nodemailer');
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

async function debug() {
    console.log('--- Backend Debug Start ---');
    
    // 1. Check Supabase
    console.log('Checking Supabase connection...');
    const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
    const { data, error } = await supabase.from('otps').select('*').limit(1);
    
    if (error) {
        console.error('❌ Supabase Error:', error.message);
        if (error.message.includes('relation "otps" does not exist')) {
            console.log('👉 Solution: Aapne SQL code run nahi kiya hai. Supabase mein tables banani padengi.');
        }
    } else {
        console.log('✅ Supabase Connection: OK');
    }

    // 2. Check Email
    console.log('Checking Email transporter...');
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    try {
        await transporter.verify();
        console.log('✅ Email Transporter: OK');
    } catch (err) {
        console.error('❌ Email Error:', err.message);
        console.log('👉 Solution: Gmail App Password sahi nahi hai ya 2-Step Verification off hai.');
    }

    console.log('--- Debug End ---');
}

debug();
