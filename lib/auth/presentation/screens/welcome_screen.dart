import 'package:fluentnow/cache/cachehelper.dart';
import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController();

  int currentPage = 1;

  Future<void> completeOnboarding() async {
    await CacheData.setData(key: 'WelcomeScreen_complete', value: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.background,
      body: Column(
        children: [
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Opacity(
                    opacity: currentPage < 2 ? 0.0 : 1.0,
                    child: backbutton(),
                  ),
                ),
              ),
              skipButton(),
            ],
          ),
          SizedBox(height: 20),
          appTitle(),
          SizedBox(height: 28),
          pageView(),
          smoothPageIndicator(),
          SizedBox(height: 32),
          getstartedButton(),
        ],
      ),
    );
  }

  Widget skipButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Mycolors.textPrimary, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () {
              completeOnboarding();
              Navigator.pushReplacementNamed(context, signupScreen);
            },

            style: ElevatedButton.styleFrom(
              overlayColor: Colors.transparent,

              backgroundColor: Colors.transparent, // Makes gradient visible
              shadowColor: Colors.transparent, // Removes default shadow
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Mycolors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget backbutton() {
    return IconButton(
      onPressed: () {
        if (currentPage > 1) {
          setState(() {
            controller.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            currentPage--;
          });
        }
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  Widget getstartedButton() {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Rounded corners
        gradient: LinearGradient(
          colors: [
            Color(0xFF2196F3), // Primary blue (Material blue 500)
            Color(0xFF00BCD4), // Teal accent (Material cyan 500)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (currentPage < 3) {
            setState(() {
              controller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          } else {
            completeOnboarding();
            Navigator.pushReplacementNamed(
              context,
              signupScreen,
            ); // Navigate to login screen
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Makes gradient visible
          shadowColor: Colors.transparent, // Removes default shadow
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          currentPage < 3 ? 'NEXT' : 'GET STARTED',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget smoothPageIndicator() {
    return SmoothPageIndicator(
      effect: WormEffect(
        dotHeight: 16,
        dotWidth: 16,
        type: WormType.underground,
        activeDotColor: Mycolors.primary, // Using your primary color (#A0D2EB)
      ),
      count: 3,
      controller: controller,
    );
  }

  Widget pageView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: IgnorePointer(
        ignoring: true,
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentPage = index + 1; // Update currentPage based on index
            });
          },
          children: [screen1(), screen2(), screen3()],
        ),
      ),
    );
  }

  Widget screen3() {
    return Column(
      children: [
        Text(
          'Taught by skilled, native-level educators.',
          style: TextStyle(
            color: Mycolors.textSecondary,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 24), // Add more spacing before the image
        Image.asset('assets/images/teacher.png', height: 300, width: 300),
      ],
    );
  }

  Widget screen2() {
    return Column(
      children: [
        Text(
          'Team classes or solo sessions\nboth available!',
          style: TextStyle(
            color: Mycolors.textSecondary,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 24), // Add more spacing before the image
        Image.asset('assets/images/class.png'),
      ],
    );
  }

  Widget screen1() {
    return Column(
      children: [
        Text(
          'We offer courses in English, French,\nSpanish, and more!',
          style: TextStyle(
            color: Mycolors.textSecondary,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 24), // Add more spacing before the image
        Image.asset('assets/images/study.png', height: 300, width: 300),
      ],
    );
  }

  Widget appTitle() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Welcome to ',
            style: TextStyle(
              color: Mycolors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'FluentNow',
            style: TextStyle(
              color: Mycolors.primary, // Using your primary color (#A0D2EB)
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
