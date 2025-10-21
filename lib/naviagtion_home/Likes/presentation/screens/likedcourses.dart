import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/businesse_logic/cubit/courselist_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:fluentnow/naviagtion_home/Likes/businesse_logic/cubit/likedcourses_cubit.dart';
import 'package:fluentnow/naviagtion_home/Likes/presentation/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedcoursesScreen extends StatefulWidget {
  const LikedcoursesScreen({super.key});

  @override
  State<LikedcoursesScreen> createState() => _LikedcoursesScreenState();
}

class _LikedcoursesScreenState extends State<LikedcoursesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LikedcoursesCubit>().fetchLikedCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.background,
      appBar: AppBar(
        title: Text(
          'Liked Courses',
          style: TextStyle(
            color: Mycolors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Mycolors.background,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<LikedcoursesCubit>().fetchLikedCourses(),
        child: BlocBuilder<LikedcoursesCubit, LikedcoursesState>(
          builder: (context, state) {
            if (state is LikedcoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LikedcoursesError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is LikedcoursesLoaded) {
              return _buildCourseList(state.likedcourses);
            }
            return const Center(child: Text('No courses available'));
          },
        ),
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses) {
    if (courses.isEmpty) {
      return SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // This ensures it's always scrollable

        child: Center(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 200),
                Icon(Icons.thumb_up_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No liked courses',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final hasDiscount =
            course.discountPercent != 0.0 && course.discountExpiry != null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child:
              hasDiscount
                  ? DiscountCourseCard(
                    course: _convertToDiscountedCourse(course),
                  )
                  : CourseCard(course: _convertToDiscountedCourse(course)),
        );
      },
    );
  }

  // Helper methods to convert between different course types
  Course _convertToDiscountedCourse(Course course) {
    return Course(
      id: course.id,
      title: course.title,
      imageUrl: course.imageUrl,
      durationWeeks: course.durationWeeks,
      hoursPerWeek: course.hoursPerWeek,
      maxStudents: course.maxStudents,
      price: course.price,
      discountPercent: course.discountPercent!,
      discountPrice: course.discountPrice!,
      discountExpiry: course.discountExpiry!,
    );
  }
}
