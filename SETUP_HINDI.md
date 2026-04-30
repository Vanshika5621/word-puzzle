# 📱 Crossword Puzzle App - Setup Guide (Hindi)

## 🚀 Quick Start

### Step 1: Flutter Install Karo

```bash
# Mac pe:
brew install flutter

# Ya download karo: https://flutter.dev/docs/get-started/install
```

### Step 2: Dependencies Install Karo

```bash
cd /Users/vanshikasoni/word_puzzle
flutter pub get
```

### Step 3: App Run Karo

```bash
flutter run
```

## ⚠️ IMPORTANT - Supabase Setup

**Aapko yeh 3 cheezein karni hain:**

### 1. Supabase Account Banayo
- https://supabase.com pe jao
- Sign up karo
- New project create karo

### 2. Credentials Copy Karo
- Project settings → API
- **URL** copy karo
- **anon key** copy karo

### 3. File Mein Paste Karo

**File:** `lib/utils/supabase_config.dart`

```dart
// YAHAN APNA SUPABASE URL DAALEIN
static const String supabaseUrl = 'https://your-project.supabase.co';

// YAHAN APNA SUPABASE ANON KEY DAALEIN  
static const String supabaseKey = 'your-anon-key-here';
```

## 🗄️ Database Tables Banayo

Supabase → SQL Editor mein yeh run karo:

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_stats (
  user_id UUID REFERENCES users(id),
  total_puzzles_solved INTEGER DEFAULT 0,
  total_coins INTEGER DEFAULT 100,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  PRIMARY KEY (user_id)
);
```

## 📱 Android/iOS Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## ❓ Common Commands

| Command | Matlab |
|---------|--------|
| `flutter pub get` | Packages download karo |
| `flutter run` | App chalao |
| `flutter doctor` | Check karo sab sahi hai |
| `flutter clean` | Cache saaf karo |
| `flutter build apk` | APK banao |

## 🆘 Problem Aaye Toh

### App chal nahi rahi?
```bash
flutter clean
flutter pub get
flutter run
```

### Dependencies error?
```bash
flutter pub upgrade
```

### Android Studio mein open karo:
```bash
cd /Users/vanshikasoni/word_puzzle
idea .
```

## 📧 Support

Koi bhi problem ho toh `flutter doctor` run karke output check karo.

---

**App Ready! 🎉**
