import 'package:code_structure/core/providers/all_users_provider.dart';
import 'package:code_structure/core/providers/user_provider.dart';
import 'package:code_structure/firebase_options.dart';
import 'package:code_structure/ui/auth/sign_up/login_screen.dart';
import 'package:code_structure/ui/root_screen/root_screen.dart';
import 'package:code_structure/ui/screens/discover/discover_screen.dart';
import 'package:code_structure/ui/screens/favorites/favorites_screen.dart';
import 'package:code_structure/ui/screens/filter/filter_screen.dart';
import 'package:code_structure/ui/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:code_structure/core/services/online_status_service.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => DiscoverScreen());
//       default:
//         return MaterialPageRoute(builder: (_) => DiscoverScreen());
//     }
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final OnlineStatusService _onlineStatusService = OnlineStatusService();

  @override
  void initState() {
    super.initState();
    _onlineStatusService.initialize();
  }

  @override
  void dispose() {
    _onlineStatusService.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(394, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AllUsersProvider(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffFAF8F6),
          ),
          // initialRoute: '/',
          // onGenerateRoute: RouteGenerator.generateRoute,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
