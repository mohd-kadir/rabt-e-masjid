import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rabt_e_masjid/providers/app_data_provider.dart';
import 'package:rabt_e_masjid/screens/dashboard_screen.dart';
import 'package:rabt_e_masjid/screens/home_screen.dart';
import 'package:rabt_e_masjid/screens/para_list_screen.dart';
import 'package:rabt_e_masjid/screens/quran_screen.dart';
import 'package:rabt_e_masjid/screens/splash_screen.dart';
import 'package:rabt_e_masjid/screens/surah_list_screen.dart';
import 'package:rabt_e_masjid/screens/qibla_screen.dart';
import 'theme/app_theme.dart';
import 'models/quran_progress_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await QuranProgressState.load();
  runApp(const RabtEMasjidApp());
}

class RabtEMasjidApp extends StatelessWidget {
  const RabtEMasjidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppDataProvider(),
      child: MaterialApp(
        title: 'Rabt-e-Masjid',
        theme: AppTheme.lightTheme,
        //useMaterial3: true,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/quran': (context) => const QuranScreen(),
          '/surah-list': (context) => const SurahListScreen(),
          '/para-list': (context) => const ParaListScreen(),
          '/qibla': (context) => const QiblaScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}