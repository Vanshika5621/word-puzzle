// Supabase Configuration
// 📝 IMPORTANT: Yahan apne Supabase credentials dalne hain

class SupabaseConfig {
  // ⚠️ INSTRUCTIONS FOR DEVELOPER:
  // 1. Supabase account banayein: https://supabase.com
  // 2. New project create karein
  // 3. Project settings mein anon/public key mil jayegi
  // 4. URL bhi mil jayegi
  // 5. Niche ki values replace karein

  // 📝 YAHAN APNA SUPABASE URL DAALEIN
  static const String supabaseUrl = 'https://ptdegjcnqvnciwnzpdwh.supabase.co';
  
  // 📝 YAHAN APNA SUPABASE ANON KEY DAALEIN  
  static const String supabaseKey = 'sb_publishable_2twUmBte31UlSbBpY1-aJw_cD9t4mPF';

  // Tables names
  static const String usersTable = 'users';
  static const String puzzlesTable = 'puzzles';
  static const String userProgressTable = 'user_progress';
  static const String leaderboardTable = 'leaderboard';

  // Storage buckets
  static const String puzzleImagesBucket = 'puzzle-images';
  static const String userAvatarsBucket = 'avatars';
}

// Local Storage Keys
class StorageKeys {
  static const String userId = 'user_id';
  static const String userStats = 'user_stats';
  static const String currentPuzzle = 'current_puzzle';
  static const String puzzleProgress = 'puzzle_progress';
  static const String soundEnabled = 'sound_enabled';
  static const String vibrationEnabled = 'vibration_enabled';
  static const String theme = 'theme';
  static const String lastDailyClaim = 'last_daily_claim';
}
