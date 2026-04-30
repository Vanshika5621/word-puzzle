# 🧩 Crossword Puzzle App

A fully functional crossword puzzle mobile app built with Flutter, similar to "Crossword Puzzle Free" by Easybrain, with Supabase backend integration.

## ✨ Features

### Core Gameplay
- **Dynamic Grid System** - 5x5, 10x10, 13x13, 15x15 grid sizes
- **Auto-fill grid** with black and white cells
- **Numbered cells** for clues
- **Letter input** in cells with tap selection
- **Highlight selected word** (horizontal/vertical)

### Clues System
- **"Across" and "Down"** clues list
- **Click clue** → highlight word on grid
- **Clue counter** (1 Across, 2 Down, etc.)
- **Progress tracking** for each clue

### Input System
- **On-screen keyboard** (A-Z)
- **Backspace/Delete** button
- **Auto-move** to next cell
- **Tap to select** cell

### Game Features
- **Timer** (count up)
- **Hint system** (reveal letter/word)
- **Check answers** (wrong letters highlight red)
- **Auto-complete detection**
- **Save progress** locally

### Difficulty Levels
- **Easy** (5x5 grid)
- **Medium** (10x10 grid)
- **Hard** (13x13 grid)
- **Expert** (15x15 grid)
- **Daily puzzles**

### User Features
- **Coin system** - Earn coins by completing puzzles
- **Streak system** - Track consecutive days played
- **Statistics** - Time played, puzzles solved, hints used
- **Shop** - Buy hints with coins
- **Share score** - Share achievements on social media

### Backend (Supabase)
- **User authentication** (when Supabase is configured)
- **Cloud save** - Sync progress across devices
- **Daily puzzles** - Fetch from server
- **Leaderboard** - Compare scores with others

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Provider** for state management
- **SharedPreferences** for local storage
- **Supabase** for backend
- **Confetti** for animations

## 📱 Platforms

✅ Android  
✅ iOS  
✅ Web (limited)  

## 🚀 Setup Instructions

### Step 1: Install Flutter

Agar Flutter installed nahi hai to:

```bash
# macOS pe Flutter install karo
brew install flutter

# Ya official website se download karo:
# https://flutter.dev/docs/get-started/install
```

### Step 2: Project Setup

```bash
# 1. Is folder me jaao
cd /Users/vanshikasoni/word_puzzle

# 2. Dependencies install karo
flutter pub get

# 3. App run karo
flutter run
```

### Step 3: Supabase Setup (IMPORTANT)

**⚠️ YAHAN AAPKO APNE CREDENTIALS DALNE HAIN:**

1. **Supabase account banao**: https://supabase.com
2. **New project create karo**
3. **Project settings mein jao**
4. **"API" section mein yeh values copy karo:**
   - `URL` 
   - `anon/public key`

5. **`lib/utils/supabase_config.dart` file mein yeh values replace karo:**

```dart
// YAHAN APNA SUPABASE URL DAALEIN
static const String supabaseUrl = 'https://your-project.supabase.co';

// YAHAN APNA SUPABASE ANON KEY DAALEIN  
static const String supabaseKey = 'your-anon-key-here';
```

### Step 4: Supabase Database Tables Create Karo

Supabase SQL editor mein yeh queries run karo:

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  username TEXT
);

-- User Stats table
CREATE TABLE user_stats (
  user_id UUID REFERENCES users(id),
  total_puzzles_solved INTEGER DEFAULT 0,
  total_coins INTEGER DEFAULT 100,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  hints_used INTEGER DEFAULT 0,
  hints_available INTEGER DEFAULT 3,
  total_time_played INTEGER DEFAULT 0,
  last_played_date TIMESTAMP,
  puzzle_progress JSONB DEFAULT '{}',
  PRIMARY KEY (user_id)
);

-- Puzzles table
CREATE TABLE puzzles (
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
  created_at TIMESTAMP DEFAULT NOW()
);

-- Leaderboard table
CREATE TABLE leaderboard (
  user_id UUID REFERENCES users(id),
  puzzle_id TEXT,
  completion_time INTEGER,
  completed_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, puzzle_id)
);
```

### Step 5: Android/iOS Build

```bash
# Android APK build karo
flutter build apk --release

# Android App Bundle (Play Store ke liye)
flutter build appbundle --release

# iOS build (Mac + Xcode required)
flutter build ios --release
```

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── cell_model.dart       # Grid cell data
│   ├── clue_model.dart       # Clue data
│   ├── puzzle_model.dart     # Complete puzzle data
│   └── user_stats_model.dart # User statistics
├── screens/
│   ├── home_screen.dart      # Main menu
│   ├── game_screen.dart      # Crossword game
│   ├── category_screen.dart  # Puzzle categories
│   └── win_screen.dart       # Win celebration
├── widgets/
│   ├── crossword_grid.dart   # Grid widget
│   ├── clues_panel.dart      # Clues list
│   └── keyboard_widget.dart  # On-screen keyboard
├── providers/
│   └── game_provider.dart    # State management
└── utils/
    ├── constants.dart        # App constants, colors
    ├── puzzle_generator.dart # Sample puzzles
    └── supabase_config.dart  # Supabase settings
```

## 🎨 Color Scheme

- **Background**: #1A1A2E (Dark Navy)
- **Grid White**: White cells
- **Grid Black**: #0D0D1A
- **Selected Cell**: #FFD700 (Yellow)
- **Selected Word**: #B8E6FF (Light Blue)
- **Wrong Letter**: #FF4444 (Red)
- **Correct Letter**: #44FF44 (Green)
- **Accent**: #6C63FF (Purple)
- **Gold**: #FFD700

## 🎮 How to Play

1. **Cell select karo** - Grid pe tap karke cell select karo
2. **Word direction change** - Same cell pe dobara tap karke Across/Down toggle karo
3. **Letter enter karo** - Keyboard se letter enter karo
4. **Clue dekho** - Neeche Across/Down clues panel mein clues dekho
5. **Hint use karo** - Hint button pe tap karke letter ya word reveal karo
6. **Check karo** - Wrong answers red highlight honge
7. **Win!** - Saare words solve karke puzzle complete karo

## 📝 Commands Reference

| Command | Kaam |
|---------|------|
| `flutter pub get` | Dependencies install karo |
| `flutter run` | App run karo |
| `flutter build apk` | Android APK build karo |
| `flutter build appbundle` | Play Store ke liye build karo |
| `flutter clean` | Cache clean karo |
| `flutter doctor` | Setup check karo |

## 🔧 Troubleshooting

### Error: "No pubspec.yaml file found"
```bash
cd /Users/vanshikasoni/word_puzzle
flutter pub get
```

### Error: "Supabase not initialized"
- `supabase_config.dart` mein credentials add karo
- Ya Supabase setup temporarily comment kar sakte ho

### App chal nahi raha
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Screenshots

(Screenshots yahan add karein)

## 🤝 Support

Koi problem aaye to:
1. `flutter doctor` run karke check karo
2. Dependencies update karo: `flutter pub upgrade`
3. Clean build karo: `flutter clean`

## 📄 License

This project is for educational purposes.

---

**Made with ❤️ using Flutter**
