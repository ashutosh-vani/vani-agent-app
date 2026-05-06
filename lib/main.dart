import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/config/theme.dart';
import 'package:vani_app/screens/splash_screen.dart';
import 'package:vani_app/screens/auth/login_screen.dart';
import 'package:vani_app/screens/auth/google_callback_screen.dart';
import 'package:vani_app/screens/main_shell.dart';
import 'package:vani_app/screens/phone_numbers/available_phone_numbers_screen.dart';
import 'package:vani_app/screens/whatsapp/whatsapp_inbox_screen.dart';
import 'package:vani_app/screens/integrations/integrations_screen.dart';
import 'package:vani_app/screens/integrations/meta_ads_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaniAgent',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(),
        '/available-phone-numbers': (context) => const AvailablePhoneNumbersScreen(),
        '/whatsapp-inbox': (context) => const WhatsAppInboxScreen(),
        '/integrations': (context) => const IntegrationsScreen(),
        '/meta-ads': (context) => const MetaAdsScreen(),
        '/auth/google/callback': (context) {
          final uri = Uri.base;
          final code = uri.queryParameters['code'];
          final state = uri.queryParameters['state'];
          final error = uri.queryParameters['error'];
          
          return GoogleCallbackScreen(
            code: code,
            state: state,
            error: error,
          );
        },
      },
    );
  }
}
