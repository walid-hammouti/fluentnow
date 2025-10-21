import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitcorusesdetails/coursedetails_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitcourseregistration/course_registration_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/repository/coursedetails_repo.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/data/webservices/coursedetails_webserivces.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/presentation/widgets/coursedetailsskeliton.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/presentation/widgets/likebutton.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/presentation/widgets/registriationdialog.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({
    super.key,
    required this.course,
    required this.isNew,
  });
  final Course course;
  final bool isNew;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CoursedetailsCubit>(
      context,
    ).getCourseDetailsScreen(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> scheduleJsonb = {
      "Monday": "08:00–10:00",
      "Wednesday": "10:00–12:00",
      "friday": "14:00–16:00",
    };

    bool showFullText = false;
    final course = widget.course;
    final isDiscounted =
        (course.discountPrice ?? 0) > 0.0 &&
        (course.discountExpiry?.isAfter(DateTime.now()) ?? false) &&
        (course.discountPercent ?? 0) > 0;

    return Scaffold(
      backgroundColor: Mycolors.background,
      appBar: AppBar(
        backgroundColor: Mycolors.background,

        title: Text(
          "Course Details",
          style: TextStyle(
            color: Mycolors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [CourseLikeButton(courseId: course.id)],
      ),
      body: BlocConsumer<CoursedetailsCubit, CourseDetailsState>(
        listener: (context, state) {
          if (state is CourseDetailsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is CourseDetailsLoading || state is CourseDetailsInitial) {
            return CourseDetailsSkeleton();
          }
          if (state is CourseDetailsLoaded) {
            final details = state.details;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Hero Image with gradient overlay
                    isDiscounted
                        ? Container(
                          height: 220,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(course.imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // Positioned discount badge in top-right corner
                              Positioned(
                                top: 12,
                                right: 12,
                                child:
                                    course.discountPercent! > 0
                                        ? Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors
                                                    .red, // Or any color you prefer
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '${course.discountPercent}% OFF',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                        : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        )
                        : Container(
                          height: 220,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(course.imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              if (widget.isNew)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Mycolors
                                              .primary, // Adjust color as needed
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "NEW",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Mycolors.cardPanel,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // Course Title and Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Mycolors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                isDiscounted
                                    ? SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Align(
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              '${course.price} DZA',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Mycolors.textPrimary,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${course.discountPrice} DZA',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Mycolors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '${course.price} DZA',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Mycolors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),

                            SizedBox(height: 12),

                            // Duration and Weekly Hours
                            Row(
                              children: [
                                _buildInfoChip(
                                  icon: Icons.calendar_today,
                                  text: "${course.durationWeeks} weeks",
                                  color: Mycolors.accent,
                                ),
                                SizedBox(width: 8),
                                _buildInfoChip(
                                  icon: Icons.access_time,
                                  text: "${course.durationWeeks} h/week",
                                  color: Mycolors.secondary,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            buildScheduleContainer(scheduleJsonb),

                            SizedBox(height: 20),

                            // Course Descrption
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Mycolors.cardPanel,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "About this course",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final textSpan = TextSpan(
                                        text: details.descrption,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Mycolors.textSecondary,
                                          height: 1.5,
                                        ),
                                      );

                                      // Use Directionality to get the current text direction
                                      final textDirection = Directionality.of(
                                        context,
                                      );

                                      final textPainter = TextPainter(
                                        text: textSpan,
                                        maxLines: 2,
                                        textDirection:
                                            textDirection, // Now using nullable TextDirection
                                      )..layout(maxWidth: constraints.maxWidth);

                                      final isTextLong =
                                          textPainter.didExceedMaxLines;

                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                details.descrption,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Mycolors.textSecondary,
                                                  height: 1.5,
                                                ),
                                                maxLines:
                                                    showFullText ? null : 2,
                                                overflow:
                                                    showFullText
                                                        ? TextOverflow.visible
                                                        : TextOverflow.ellipsis,
                                              ),
                                              if (isTextLong)
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      showFullText =
                                                          !showFullText;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 4,
                                                    ),
                                                    child: Text(
                                                      showFullText
                                                          ? "Read Less"
                                                          : "Read More",
                                                      style: TextStyle(
                                                        color: Mycolors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Course Details Grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: [
                                _buildDetailCard(
                                  icon: Icons.school,
                                  title: "Level",
                                  value: details.level,
                                  color: Mycolors.accent,
                                ),
                                _buildDetailCard(
                                  icon: Icons.language,
                                  title: "Language",
                                  value: details.language,
                                  color: Mycolors.secondary,
                                ),
                                _buildDetailCard(
                                  icon: Icons.person,
                                  title: "Instructor",
                                  value: "Hammouti Walid",
                                  color: Mycolors.primary,
                                ),
                                _buildDetailCard(
                                  icon: Icons.chair_alt_outlined,
                                  title: "Seats number",
                                  value: course.maxStudents.toString(),
                                  color: Colors.green,
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Date Cards
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat(
                                    'MMM d, y',
                                  ).format(details.startDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Mycolors.primary,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "to",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'MMM d, y',
                                  ).format(details.endDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Mycolors.secondary,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 30),

                            // Enroll Button
                            state.isregistred
                                ? Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors
                                            .grey[300], // Gray background for locked state
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: null, // Disable tap
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.lock,
                                              size: 20,
                                              color: Colors.grey[600],
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Already regestred",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                : Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Mycolors.primary,
                                        Mycolors.secondary,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Mycolors.primary.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: () async {
                                        {
                                          final registrationSuccess =
                                              await showDialog<bool>(
                                                context: context,
                                                builder:
                                                    (context) => BlocProvider(
                                                      create:
                                                          (
                                                            context,
                                                          ) => CourseRegistrationCubit(
                                                            CoursedetailsRepo(
                                                              CoursedetailsWebserivces(),
                                                            ),
                                                          ),
                                                      child:
                                                          RegistrationNotesDialog(
                                                            courseName:
                                                                course.title,
                                                            courseId: course.id,
                                                          ),
                                                    ),
                                              ) ??
                                              false;

                                          if (registrationSuccess) {
                                            // Refresh the course details
                                            BlocProvider.of<CoursedetailsCubit>(
                                              context,
                                            ).getCourseDetailsScreen(
                                              widget.course.id,
                                            );
                                          }
                                        }
                                        ;
                                      },
                                      child: Center(
                                        child: Text(
                                          "Regeter Now",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Mycolors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScheduleContainer(Map<String, dynamic> scheduleJsonb) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            scheduleJsonb.entries.map((entry) {
              final String day = entry.key;
              final String hour = entry.value.toString();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      '$day: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Mycolors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      hour,
                      style: TextStyle(
                        color: Mycolors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 60), // Ensures minimum height
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align items vertically centered
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Mycolors.textSecondary),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Mycolors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis, // Add ... if text overflows
                  maxLines: 1, // Restrict to a single line
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
