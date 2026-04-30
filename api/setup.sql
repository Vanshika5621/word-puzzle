-- 1. OTPS table for custom email auth
CREATE TABLE IF NOT EXISTS otps (
    email TEXT PRIMARY KEY,
    code TEXT NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  username TEXT
);

-- 3. User Stats table
CREATE TABLE IF NOT EXISTS user_stats (
  user_id UUID REFERENCES users(id),
  total_puzzles_solved INTEGER DEFAULT 0,
  total_coins INTEGER DEFAULT 100,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  hints_used INTEGER DEFAULT 0,
  hints_available INTEGER DEFAULT 3,
  total_time_played INTEGER DEFAULT 0,
  last_played_date TIMESTAMP WITH TIME ZONE,
  puzzle_progress JSONB DEFAULT '{}',
  PRIMARY KEY (user_id)
);

-- 4. Puzzles table
CREATE TABLE IF NOT EXISTS puzzles (
  id TEXT PRIMARY KEY,
  title TEXT,
  difficulty TEXT,
  category TEXT,
  grid_size INTEGER,
  grid JSONB,
  clues JSONB,
  hints_allowed INTEGER DEFAULT 3,
  reward_coins INTEGER DEFAULT 50,
  daily_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Leaderboard table
CREATE TABLE IF NOT EXISTS leaderboard (
  user_id UUID REFERENCES users(id),
  puzzle_id TEXT,
  completion_time INTEGER,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (user_id, puzzle_id)
);

-- Row Level Security (RLS) - Disable for simplified backend access
ALTER TABLE otps DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_stats DISABLE ROW LEVEL SECURITY;
ALTER TABLE puzzles DISABLE ROW LEVEL SECURITY;
ALTER TABLE leaderboard DISABLE ROW LEVEL SECURITY;
