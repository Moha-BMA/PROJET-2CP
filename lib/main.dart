import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Settings UI',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF8F2ED),
      ),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = false;
  bool notificationsEnabled = true;
  bool vibrationEnabled = true;
  String language = "ENGLISH";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F2ED),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Main panel with wooden border
              Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F2ED),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: const Color(0xFFC79F74),
                    width: 15,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sound toggle
                    _buildToggleRow(
                      "Sound", 
                      soundEnabled, 
                      (value) => setState(() => soundEnabled = value),
                      showIcon: false,
                    ),
                    const SizedBox(height: 24),
                    
                    // Notifications toggle
                    _buildToggleRow(
                      "Notifications", 
                      notificationsEnabled, 
                      (value) => setState(() => notificationsEnabled = value),
                      showIcon: true,
                    ),
                    const SizedBox(height: 24),
                    
                    // Vibration toggle
                    _buildToggleRow(
                      "Vibration", 
                      vibrationEnabled, 
                      (value) => setState(() => vibrationEnabled = value),
                      showIcon: false,
                    ),
                    const SizedBox(height: 32),
                    
                    // Language selector
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2C5A9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Language",
                            style: TextStyle(
                              color: Color(0xFF835008),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6ADF34),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "ENGLISH",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Support button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: const Border(
                          left: BorderSide(
                            color: Color(0xFFB6702A),
                            width: 4,
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD3923E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "SUPPORT",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Settings header with curved background
              Positioned(
                top: 0,
                child: Container(
                  width: 280,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2C5A9),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFC79F74),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "SETTINGS",
                      style: TextStyle(
                        color: Color(0xFF835008),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Close button
              Positioned(
                top: 15,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    // Handle close action
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2C5A9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFC79F74),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: Color(0xFF835008),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged, {bool showIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (showIcon)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.notifications,
                  color: const Color(0xFF835008),
                  size: 24,
                ),
              ),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF835008),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        _buildCustomSwitch(value, onChanged),
      ],
    );
  }

  Widget _buildCustomSwitch(bool value, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 64,
        height: 32,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF26DF67) : const Color(0xFFE2C896),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 36 : 4,
              top: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: value ? const Color(0xFF15E35D) : const Color(0xFFCEA022),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}