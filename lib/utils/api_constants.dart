// Backend API URL - यह change करना है जब deploy हो
const String BACKEND_URL = 'https://word-puzzle-backend.vercel.app';

// Auth endpoints
const String SEND_OTP_ENDPOINT = '$BACKEND_URL/auth/send-otp';
const String VERIFY_OTP_ENDPOINT = '$BACKEND_URL/auth/verify-otp';
