import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/businesse_logic/cubit/home_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/user.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/presentation/widgets/cards.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/presentation/widgets/homescreenskeleton.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).fetchHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: HomeScreenSkeleton());
          } else if (state is HomeError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            });
            return const Center(child: Text('An error occurred.'));
          } else if (state is HomeLoaded) {
            return Scaffold(
              backgroundColor: Mycolors.background,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row with Avatar, Greeting, and Icons
                    _buildHeader(context, state.user),
                    const SizedBox(height: 16),
                    // Promotional Banner
                    _buildPromoBanner(),
                    const SizedBox(height: 8),
                    // Newest Courses Section
                    _buildSectionTitle('Newest Courses'),
                    _buildNewestCoursesList(
                      context,
                      state.newestCourses,
                    ), // Limited-Time Offers Section
                    _buildSectionTitle('Limited-Time Offers'),
                    _buildDiscountedCoursesList(
                      context,
                      state.discountedCourses,
                    ),
                  ],
                ),
              ),
            );
          }
          // Fallback widget for unexpected states
          return const Center(child: Text('Unexpected state.'));
        },
      ),
    );
  }
}

// Helper widget for the header section
Widget _buildHeader(BuildContext context, User user) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Mycolors.primary,
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: const Text(
        'Welcome Back',
        style: TextStyle(fontSize: 12, color: Mycolors.textSecondary),
      ),
      subtitle: Text(
        user.username,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Mycolors.textPrimary,
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.search, color: Mycolors.primary),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.notifications_none_sharp,
                color: Mycolors.primary,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper widget for the promo banner
Widget _buildPromoBanner() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Master Languages,',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Mycolors.background,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Shape Your World',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Mycolors.background,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Learn to communicate confidently and\nconnect with the world around you.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: Mycolors.background.withOpacity(0.9),
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper widget for section titles
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 16),
    child: Text(
      title,
      style: TextStyle(
        fontFamily: "Lexend",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Mycolors.textPrimary,
      ),
    ),
  );
}

// Helper widget for horizontal course lists
// For newest courses
Widget _buildNewestCoursesList(BuildContext context, List<Course> courses) {
  return SizedBox(
    height: 260,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return NewestCourseCard(course: course);
      },
    ),
  );
}

// For discounted courses
Widget _buildDiscountedCoursesList(BuildContext context, List<Course> courses) {
  return SizedBox(
    height: 300, // Slightly taller to accommodate discount info
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return DiscountCourseCard(course: course);
      },
    ),
  );
}
