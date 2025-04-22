import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 250));

    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        currentUser != null ? '/dashboard' : '/login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 40, 50, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 36 , 0, 20),
            child: SvgPicture.asset("assets/logo.svg", height: 80),
          ),
          Padding(
             padding: const EdgeInsets.fromLTRB(16, 20 , 16, 20),
            child: Container(
              height: 300,
              width: 400,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SvgPicture.asset("assets/splash_image.svg", height: 250, width: 200, fit: BoxFit.cover,),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
           padding: const EdgeInsets.fromLTRB(16, 20 , 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/splash_name.png", height: 210),
                const SizedBox(height: 80),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(254, 211, 106, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
              final authService = Provider.of<AuthService>(
                context,
                listen: false,
              );
              final currentUser = authService.currentUser;
              Navigator.pushReplacementNamed(
                context,
                currentUser != null ? '/dashboard' : '/login',
              );
            },
                        child: Text(
                                  "Let's Start",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                      ),
                    ),
              ],
            ),
          ),
          
          
        ],
      ),
    );
  }
}
