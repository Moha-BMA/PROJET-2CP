#  Qobtan's Adventure - Exploring the Wonders of Algeria

<p align="center">
  <img src="assets/assetsMainPage/logo.png" alt="Qobtan's Adventure Logo" width="200"/>
</p>

An educational mobile game built with Flutter that takes children on an exciting journey to discover Algeria's rich cultural heritage, historical landmarks, and beautiful wilayas (provinces). The app features an adorable fennec fox mascot named "Qobtan" (Captain) who guides players through their adventure.

## 📱 About the App

**Qobtan's Adventure** is designed to teach children about Algeria in a fun and interactive way. The game adapts its content based on the player's age, providing appropriate challenges for:
- **Kids (Under 7 years)**: Simpler puzzles and flip card games
- **Teens (8+ years)**: More challenging quizzes, puzzles, and educational content

## ✨ Features

### 🎮 Games & Activities
- **🧩 Jigsaw Puzzles**: Assemble beautiful images of Algerian landmarks
- **🃏 Flip Card Memory Game**: Match pairs of images featuring Algerian culture
- **❓ Quiz Questions**: Test knowledge about Algeria's wilayas, history, and geography
- **📸 Photo Quizzes**: Identify landmarks and cultural elements from images

### 🗺️ Explore 6 Wilayas
Each wilaya (province) contains multiple stages with different games:
1. **Wilaya 1** - 3 stages
2. **Wilaya 2** - 2 stages
3. **Wilaya 3** - 2 stages
4. **Wilaya 4** - 2 stages
5. **Wilaya 5** - 4 stages
6. **Wilaya 6** - 3 stages

### 📦 Mystery Boxes
- 16 unique mystery box challenges
- Unlock with coins earned from gameplay
- Contains educational videos about Algeria
- Separate content for kids and teens

### 🏆 Progress & Rewards
- **⭐ Star System**: Earn 1-3 stars per stage based on performance
- **🪙 Coins**: Earn coins to unlock mystery boxes
- **🏅 Trophies**: Collect trophies for completing all stages in each wilaya
- **📊 Progress Tracking**: View your progress for each wilaya

### 👤 Player Profile
- Personalized experience with player name
- Age-appropriate content selection
- Save and track progress

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7+
- **State Management**: Flutter Riverpod
- **Local Storage**: SharedPreferences
- **Animations**: Rive animations
- **Video Player**: video_player package
- **Fonts**: Google Fonts

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  rive: ^0.13.20
  flutter_riverpod: ^2.4.5
  shared_preferences: ^2.2.2
  video_player: ^2.7.0
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Moha-BMA/PROJET-2CP.git
   cd PROJET-2CP
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── app_state.dart            # Riverpod state providers
├── screens/                  # Main app screens
│   ├── FirstScreen.dart      # Splash screen
│   ├── SecondScreen.dart     # Welcome screen
│   ├── ThirdScreen.dart      # Name & age input
│   ├── MainScreen.dart       # Main menu
│   ├── Introvideo.dart       # Intro video player
│   └── jinglescreen.dart     # Jingle animation
├── Games/                    # Game modules
│   ├── above8/               # Games for 8+ years
│   └── under7/               # Games for under 7
├── MBGames/                  # Mystery box games
├── Mystery Boxes/            # Mystery box screens
├── Wilayas_stages/           # Wilaya stage screens
├── card+gameplay/            # Card collection screens
├── ProgressSpace/            # Progress tracking
├── TrophySpace/              # Trophy collection
└── Settings/                 # Settings screen

assets/
├── assetsfirst5screens/      # Onboarding assets
├── assetsMainPage/           # Main menu assets
├── assetswilayas/            # Wilaya images
├── assetsgames/              # Game assets
├── assetsgamesunderabove/    # Age-specific game assets
├── assetsMBflipcard/         # Mystery box flip cards
├── assetsQuiz/               # Quiz assets
├── assetsTrophyspace/        # Trophy images
├── assetsProgressspace/      # Progress screen assets
└── videos/                   # Educational videos
```

## 🎯 Game Flow

1. **Welcome Screen** → Enter name and age
2. **Intro Video** → Watch the adventure introduction
3. **Main Menu** → Choose from:
   - 🎴 **Play** - Explore wilayas and complete stages
   - 📦 **Mystery Boxes** - Unlock educational content
   - 🏆 **Trophies** - View earned trophies
   - 📊 **Progress** - Track your journey
   - ⚙️ **Settings** - Adjust preferences

## 🌍 Language

The app is primarily in **Arabic (العربية)**, designed to teach Algerian children about their homeland in their native language.

## 👥 Target Audience

- **Primary**: Children aged 3-18 years
- **Focus**: Algerian youth learning about their country's heritage

## 📄 License

This project is part of a 2CP (2ème année Cycle Préparatoire) academic project.

## 🤝 Contributors

- **Team PROJET-2CP**

---

<p align="center">
  <b>🇩🇿 Discover Algeria with Qobtan! 🦊</b>
</p>
