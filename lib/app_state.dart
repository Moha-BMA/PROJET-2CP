import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences Provider - place it at the top
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart with ref.read()');
});

// User Age Provider - Added for saving age
final userAgeProvider = StateNotifierProvider<UserAgeNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserAgeNotifier(prefs);
});

class UserAgeNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  UserAgeNotifier(this._prefs) : super(_prefs.getInt('userAge') ?? 3);

  void setAge(int age) {
    state = age;
    _prefs.setInt('userAge', age);
  }
}

// User Name Provider - Added for saving name
final userNameProvider = StateNotifierProvider<UserNameNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserNameNotifier(prefs);
});

class UserNameNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;

  UserNameNotifier(this._prefs) : super(_prefs.getString('userName') ?? '');

  void setName(String name) {
    state = name;
    _prefs.setString('userName', name);
  }
}

// ---------------- Wilaya 1 Stage Stars Providers ----------------

// Wilaya 1 Stage 1 Stars
final w1Stage1StarsProvider = StateNotifierProvider<W1Stage1StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W1Stage1StarsNotifier(prefs);
});

class W1Stage1StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W1Stage1StarsNotifier(this._prefs) : super(_prefs.getInt('W1_stage1_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W1_stage1_stars', stars);
  }
}

// Wilaya 1 Stage 2 Stars
final w1Stage2StarsProvider = StateNotifierProvider<W1Stage2StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W1Stage2StarsNotifier(prefs);
});

class W1Stage2StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W1Stage2StarsNotifier(this._prefs) : super(_prefs.getInt('W1_stage2_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W1_stage2_stars', stars);
  }
}

// Wilaya 1 Stage 3 Stars
final w1Stage3StarsProvider = StateNotifierProvider<W1Stage3StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W1Stage3StarsNotifier(prefs);
});

class W1Stage3StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W1Stage3StarsNotifier(this._prefs) : super(_prefs.getInt('W1_stage3_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W1_stage3_stars', stars);
  }
}

// ---------------- Wilaya 2 Stage Stars Providers ----------------

// Wilaya 2 Stage 1 Stars
final w2Stage1StarsProvider = StateNotifierProvider<W2Stage1StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W2Stage1StarsNotifier(prefs);
});

class W2Stage1StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W2Stage1StarsNotifier(this._prefs) : super(_prefs.getInt('W2_stage1_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W2_stage1_stars', stars);
  }
}

// Wilaya 2 Stage 2 Stars
final w2Stage2StarsProvider = StateNotifierProvider<W2Stage2StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W2Stage2StarsNotifier(prefs);
});

class W2Stage2StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W2Stage2StarsNotifier(this._prefs) : super(_prefs.getInt('W2_stage2_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W2_stage2_stars', stars);
  }
}

// ---------------- Wilaya 3 Stage Stars Providers ----------------

// Wilaya 3 Stage 1 Stars
final w3Stage1StarsProvider = StateNotifierProvider<W3Stage1StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W3Stage1StarsNotifier(prefs);
});

class W3Stage1StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W3Stage1StarsNotifier(this._prefs) : super(_prefs.getInt('W3_stage1_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W3_stage1_stars', stars);
  }
}

// Wilaya 3 Stage 2 Stars
final w3Stage2StarsProvider = StateNotifierProvider<W3Stage2StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W3Stage2StarsNotifier(prefs);
});

class W3Stage2StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W3Stage2StarsNotifier(this._prefs) : super(_prefs.getInt('W3_stage2_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W3_stage2_stars', stars);
  }
}

// ---------------- Wilaya 4 Stage Stars Providers ----------------

// Wilaya 4 Stage 1 Stars
final w4Stage1StarsProvider = StateNotifierProvider<W4Stage1StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W4Stage1StarsNotifier(prefs);
});

class W4Stage1StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W4Stage1StarsNotifier(this._prefs) : super(_prefs.getInt('W4_stage1_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W4_stage1_stars', stars);
  }
}

// Wilaya 4 Stage 2 Stars
final w4Stage2StarsProvider = StateNotifierProvider<W4Stage2StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W4Stage2StarsNotifier(prefs);
});

class W4Stage2StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W4Stage2StarsNotifier(this._prefs) : super(_prefs.getInt('W4_stage2_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W4_stage2_stars', stars);
  }
}

// ---------------- Wilaya 5 Stage Stars Providers ----------------

// Wilaya 5 Stage 1 Stars
final w5Stage1StarsProvider = StateNotifierProvider<W5Stage1StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W5Stage1StarsNotifier(prefs);
});

class W5Stage1StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W5Stage1StarsNotifier(this._prefs) : super(_prefs.getInt('W5_stage1_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W5_stage1_stars', stars);
  }
}

// Wilaya 5 Stage 2 Stars
final w5Stage2StarsProvider = StateNotifierProvider<W5Stage2StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W5Stage2StarsNotifier(prefs);
});

class W5Stage2StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W5Stage2StarsNotifier(this._prefs) : super(_prefs.getInt('W5_stage2_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W5_stage2_stars', stars);
  }
}

// Wilaya 5 Stage 3 Stars
final w5Stage3StarsProvider = StateNotifierProvider<W5Stage3StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W5Stage3StarsNotifier(prefs);
});

class W5Stage3StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W5Stage3StarsNotifier(this._prefs) : super(_prefs.getInt('W5_stage3_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W5_stage3_stars', stars);
  }
}

// Wilaya 5 Stage 4 Stars
final w5Stage4StarsProvider = StateNotifierProvider<W5Stage4StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W5Stage4StarsNotifier(prefs);
});

class W5Stage4StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W5Stage4StarsNotifier(this._prefs) : super(_prefs.getInt('W5_stage4_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W5_stage4_stars', stars);
  }
}

// ---------------- Wilaya 6 Stage Stars Providers ----------------

// Wilaya 6 Stage 1 Stars
final w6Stage1StarsProvider = StateNotifierProvider<W6Stage1StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W6Stage1StarsNotifier(prefs);
});

class W6Stage1StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W6Stage1StarsNotifier(this._prefs) : super(_prefs.getInt('W6_stage1_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W6_stage1_stars', stars);
  }
}

// Wilaya 6 Stage 2 Stars
final w6Stage2StarsProvider = StateNotifierProvider<W6Stage2StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W6Stage2StarsNotifier(prefs);
});

class W6Stage2StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W6Stage2StarsNotifier(this._prefs) : super(_prefs.getInt('W6_stage2_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W6_stage2_stars', stars);
  }
}

// Wilaya 6 Stage 3 Stars
final w6Stage3StarsProvider = StateNotifierProvider<W6Stage3StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return W6Stage3StarsNotifier(prefs);
});

class W6Stage3StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  W6Stage3StarsNotifier(this._prefs) : super(_prefs.getInt('W6_stage3_stars') ?? 0);

  void setStars(int stars) {
    state = stars;
    _prefs.setInt('W6_stage3_stars', stars);
  }
}

// ---------------- User Category Provider ----------------

final userCategoryProvider = StateNotifierProvider<UserCategoryNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserCategoryNotifier(prefs);
});

class UserCategoryNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  UserCategoryNotifier(this._prefs) : super(_prefs.getBool('userCategory') ?? true);

  void setCategory(bool isChild) {
    state = isChild;
    _prefs.setBool('userCategory', isChild);
  }
}

// ---------------- Coins Provider ----------------

final coinsProvider = StateNotifierProvider<CoinsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CoinsNotifier(prefs);
});

class CoinsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  CoinsNotifier(this._prefs) : super(_prefs.getInt('userCoins') ?? 0);

  void setCoins(int amount) {
    state = amount;
    _prefs.setInt('userCoins', amount);
  }

  void addCoins(int amount) {
    state = state + amount;
    _prefs.setInt('userCoins', state);
  }

  void spendCoins(int amount) {
    if (state >= amount) {
      state = state - amount;
      _prefs.setInt('userCoins', state);
    }
  }
}

// ---------------- Stars Provider ----------------

final starsProvider = StateNotifierProvider<StarsNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StarsNotifier(prefs);
});

class StarsNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  StarsNotifier(this._prefs) : super(_prefs.getInt('userStars') ?? 0);


  void addStars(int amount) {
    state = state + amount;
    _prefs.setInt('userStars', state);
  }
}

final starsProvider2 = Provider<int>((ref) {
  // Sum stars from all wilaya stage providers
  final w1Stage1Stars = ref.watch(w1Stage1StarsProvider);
  final w1Stage2Stars = ref.watch(w1Stage2StarsProvider);
  final w1Stage3Stars = ref.watch(w1Stage3StarsProvider);
  final w2Stage1Stars = ref.watch(w2Stage1StarsProvider);
  final w2Stage2Stars = ref.watch(w2Stage2StarsProvider);
  final w3Stage1Stars = ref.watch(w3Stage1StarsProvider);
  final w3Stage2Stars = ref.watch(w3Stage2StarsProvider);
  final w4Stage1Stars = ref.watch(w4Stage1StarsProvider);
  final w4Stage2Stars = ref.watch(w4Stage2StarsProvider);
  final w5Stage1Stars = ref.watch(w5Stage1StarsProvider);
  final w5Stage2Stars = ref.watch(w5Stage2StarsProvider);
  final w5Stage3Stars = ref.watch(w5Stage3StarsProvider);
  final w5Stage4Stars = ref.watch(w5Stage4StarsProvider);
  final w6Stage1Stars = ref.watch(w6Stage1StarsProvider);
  final w6Stage2Stars = ref.watch(w6Stage2StarsProvider);
  final w6Stage3Stars = ref.watch(w6Stage3StarsProvider);

  return w1Stage1Stars +
      w1Stage2Stars +
      w1Stage3Stars +
      w2Stage1Stars +
      w2Stage2Stars +
      w3Stage1Stars +
      w3Stage2Stars +
      w4Stage1Stars +
      w4Stage2Stars +
      w5Stage1Stars +
      w5Stage2Stars +
      w5Stage3Stars +
      w5Stage4Stars +
      w6Stage1Stars +
      w6Stage2Stars +
      w6Stage3Stars;
});

// ---------------- Video Provider ----------------
// Intro Video Viewed Provider
final hasViewedIntroVideoProvider = StateNotifierProvider<HasViewedIntroVideoNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HasViewedIntroVideoNotifier(prefs);
});

class HasViewedIntroVideoNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  HasViewedIntroVideoNotifier(this._prefs) : super(_prefs.getBool('hasViewedIntroVideo') ?? false);

  void setViewed(bool viewed) {
    state = viewed;
    _prefs.setBool('hasViewedIntroVideo', viewed);
  }
}