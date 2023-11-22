import 'package:auto_route/auto_route.dart';
import 'package:fitness_app/app/routes/app_router.dart';
import 'package:fitness_ui/fitness_ui.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  Future<void> navigate() async {
    await Future<void>.delayed(2.seconds);
    if (!mounted) return;
    await context.replaceRoute(const BottomNavigationBarRoute());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(size: 40),
      ),
    );
  }
}
