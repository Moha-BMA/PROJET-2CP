import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chainage1/screens/MainScreen.dart';
import 'package:chainage1/app_state.dart';

class ProgressSpacePage extends ConsumerStatefulWidget {
  const ProgressSpacePage({Key? key}) : super(key: key);

  @override
  _ProgressSpacePageState createState() => _ProgressSpacePageState();
}

class _ProgressSpacePageState extends ConsumerState<ProgressSpacePage> {
  // Define the number of stages per Wilaya
  static const Map<String, int> wilayaStages = {
    'ولاية 1': 3,
    'ولاية 2': 2,
    'ولاية 3': 2,
    'ولاية 4': 2,
    'ولاية 5': 4,
    'ولاية 6': 3,
  };

  // Function to calculate progress for a Wilaya
  List<_WilayaProgress> _calculateWilayaProgress(WidgetRef ref) {
    return [
      _WilayaProgress(
        name: 'ولاية 1',
        completedStages: [
          ref.watch(w1Stage1StarsProvider),
          ref.watch(w1Stage2StarsProvider),
          ref.watch(w1Stage3StarsProvider),
        ].where((stars) => stars >= 1).length,
        totalStages: wilayaStages['ولاية 1']!,
      ),
      _WilayaProgress(
        name: 'ولاية 2',
        completedStages: [
          ref.watch(w2Stage1StarsProvider),
          ref.watch(w2Stage2StarsProvider),
        ].where((stars) => stars >= 1).length,
        totalStages: wilayaStages['ولاية 2']!,
      ),
      _WilayaProgress(
        name: 'ولاية 3',
        completedStages: [
          ref.watch(w3Stage1StarsProvider),
          ref.watch(w3Stage2StarsProvider),
        ].where((stars) => stars >= 1).length,
        totalStages: wilayaStages['ولاية 3']!,
      ),
      _WilayaProgress(
        name: 'ولاية 4',
        completedStages: [
          ref.watch(w4Stage1StarsProvider),
          ref.watch(w4Stage2StarsProvider),
        ].where((stars) => stars >= 1).length,
        totalStages: wilayaStages['ولاية 4']!,
      ),
      _WilayaProgress(
        name: 'ولاية 5',
        completedStages: [
          ref.watch(w5Stage1StarsProvider),
          ref.watch(w5Stage2StarsProvider),
          ref.watch(w5Stage3StarsProvider),
          ref.watch(w5Stage4StarsProvider),
        ].where((stars) => stars >= 1).length,
        totalStages: wilayaStages['ولاية 5']!,
      ),
      _WilayaProgress(
        name: 'ولاية 6',
        completedStages: [
          ref.watch(w6Stage1StarsProvider),
          ref.watch(w6Stage2StarsProvider),
          ref.watch(w6Stage3StarsProvider),
        ].where((stars) => stars >= 1).length,
        totalStages: wilayaStages['ولاية 6']!,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // Fetch name and age from providers
    final userName = ref.watch(userNameProvider);
    final userAge = ref.watch(userAgeProvider);

    // Manual positioning offsets
    final avatarLeft = w * 0.03;
    final avatarTop = h * 0.05;
    final avatarSize = w * 0.12;

    final nameLeft = w * 0.01;
    final nameTop = h * 0.3;
    final ageLeft = nameLeft;
    final ageTop = h * 0.4;

    final bH = h * 0.4;
    final bW = w * 0.42;
    final bTop = h * -0.1;
    final bLeft = w * 0.30;

    final positions = [
      Offset(w * 0.25, h * 0.25),
      Offset(w * 0.65, h * 0.25),
      Offset(w * 0.25, h * 0.45),
      Offset(w * 0.65, h * 0.45),
      Offset(w * 0.25, h * 0.65),
      Offset(w * 0.65, h * 0.65),
    ];

    final wilayas = _calculateWilayaProgress(ref);

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/assetsProgressspace/images/background.png', fit: BoxFit.cover),
          ),

          // Avatar
          Positioned(
            left: avatarLeft,
            top: avatarTop,
            child: Image.asset(
              'assets/assetsProgressspace/images/profile_icon.png',
              width: avatarSize,
              height: avatarSize,
            ),
          ),

          // Name box with edit on right
          Positioned(
            left: nameLeft,
            top: nameTop,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.005,
              ),
              decoration: BoxDecoration(
                color: Colors.white60.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName.isEmpty ? 'اسم المستخدم' : userName,
                    style: GoogleFonts.cairo(
                      fontSize: w * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: w * 0.01),
                  GestureDetector(
                    onTap: () => _editName(userName),
                    child: Image.asset(
                      'assets/assetsProgressspace/images/edit_button.png',
                      width: w * 0.03,
                      height: w * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Age box
          Positioned(
            left: ageLeft,
            top: ageTop,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.005,
              ),
              decoration: BoxDecoration(
                color: Colors.white60.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'العمر: $userAge',
                style: GoogleFonts.cairo(
                  fontSize: w * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Banner & Title
          Positioned(
            left: bLeft,
            top: bTop,
            width: bW,
            height: bH,
            child: Image.asset('assets/assetsProgressspace/images/banner.png', fit: BoxFit.cover),
          ),
          Positioned(
            top: h * -0.007,
            left: 0,
            right: 0,
            child: Text(
              'تقدم',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: h * 0.1,
                shadows: [Shadow(offset: Offset(5, 5), blurRadius: 3, color: Colors.black54)],
                color: Colors.green,
              ),
            ),
          ),

          // Boxes
          for (int i = 0; i < wilayas.length; i++)
            Positioned(
              left: positions[i].dx,
              top: positions[i].dy,
              width: w * 0.3,
              height: h * 0.15,
              child: _WilayaBox(
                title: wilayas[i].name,
                progress: wilayas[i].progress,
                onTap: () => _showDetails(context, wilayas[i]),
                barWidth: w * 0.15,
                barHeight: h * 0.025,
                backgroundAsset: 'assets/assetsProgressspace/images/wilaya.png',
              ),
            ),

          // Return
          Positioned(
            bottom: h * 0.009,
            left: w * 0.007,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Image.asset('assets/assetsProgressspace/images/return.png', width: w * 0.08, height: w * 0.08),
            ),
          ),
        ],
      ),
    );
  }

  void _editName(String currentName) async {
    final controller = TextEditingController(text: currentName);
    String? errorText;

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          scrollable: true,                            // <- make dialog scrollable
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          title: Text('تعديل الاسم', style: GoogleFonts.cairo()),
          content: SingleChildScrollView(               // <- allow content to scroll if needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(),
                  decoration: InputDecoration(
                    hintText: 'أدخل الاسم الجديد',
                    errorText: errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('إلغاء', style: GoogleFonts.cairo()),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  setState(() => errorText = 'الاسم لا يمكن أن يكون فارغاً');
                } else {
                  Navigator.of(dialogContext).pop(text);
                }
              },
              child: Text('حفظ', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );

    if (newName != null) {
      ref.read(userNameProvider.notifier).setName(newName);
    }
  }


  void _showDetails(BuildContext context, _WilayaProgress w) {
    final dialogWidth = MediaQuery.of(context).size.width * 0.6;
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: dialogWidth),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تقدم ${w.name}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'المراحل المكتملة: ${w.completedStages} / ${w.totalStages}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cairo(fontSize: 15),
                    ),
                    Text(
                      'التقدم: ${(w.progress * 100).toStringAsFixed(1)}%',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.cairo(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Image.asset('assets/assetsProgressspace/images/close_x.png', width: 28, height: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WilayaBox extends StatelessWidget {
  final String title;
  final double progress;
  final VoidCallback onTap;
  final double barWidth;
  final double barHeight;
  final String backgroundAsset;

  const _WilayaBox({
    Key? key,
    required this.title,
    required this.progress,
    required this.onTap,
    required this.barWidth,
    required this.barHeight,
    required this.backgroundAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(backgroundAsset), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.brown, width: 2),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: barWidth,
              height: barHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: barHeight,
                  backgroundColor: Colors.white.withOpacity(0.6),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: w * 0.03,
                shadows: [Shadow(blurRadius: 4, color: Colors.white70)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WilayaProgress {
  final String name;
  final int completedStages;
  final int totalStages;
  final double progress;

  _WilayaProgress({
    required this.name,
    required this.completedStages,
    required this.totalStages,
  }) : progress = totalStages > 0 ? completedStages / totalStages : 0.0;
}