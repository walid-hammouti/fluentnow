import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/businesse_logic/cubit/courselist_cubit.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/data/repository/courseslist_repo.dart';
import 'package:fluentnow/naviagtion_home/Courses%20List/presentation/widgets/cards.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesListScreen extends StatefulWidget {
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourselistCubit>().fetchAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.background,
        appBar: AppBar(
          title: Text(
            'All Courses',
            style: TextStyle(
              color: Mycolors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Mycolors.background,
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<CourselistCubit>().fetchAllCourses(),
          child: BlocBuilder<CourselistCubit, CourselistState>(
            builder: (context, state) {
              if (state is CourselistLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CourselistError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is CourselistLoaded) {
                return _buildCourseList(state.courselist);
              }
              return const Center(child: Text('No courses available'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        // Check if the course has discount information
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
