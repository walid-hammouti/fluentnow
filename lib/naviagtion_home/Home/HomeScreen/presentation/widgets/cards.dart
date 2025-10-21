import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:flutter/material.dart';

class NewestCourseCard extends StatelessWidget {
  const NewestCourseCard({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            courseDeatailScreen,
            arguments: {
              'course': course,
              'isNew': true, // Your additional argument
            },
          );
        },
        child: Stack(
          children: [
            Container(
              width: 270,
              height: 230,
              decoration: BoxDecoration(
                color: Mycolors.cardPanel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Mycolors.textPrimary.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      course.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Mycolors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Course details with icons
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Mycolors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Mon/Wed/Fri',
                              style: TextStyle(
                                fontSize: 12,
                                color: Mycolors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Mycolors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.durationWeeks} weeks - ${course.hoursPerWeek}h/week',
                              style: TextStyle(
                                fontSize: 12,
                                color: Mycolors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Footer section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 14,
                                  color: Mycolors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${course.maxStudents} seats',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mycolors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Mycolors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${course.price} DZA',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Mycolors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // NEW Watermark Badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Mycolors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountCourseCard extends StatelessWidget {
  const DiscountCourseCard({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    // Calculate time difference if discountExpiry exists
    final timeDifference = course.discountExpiry!.difference(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            courseDeatailScreen,
            arguments: {'course': course, 'isNew': false},
          );
        },
        child: Stack(
          children: [
            Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: Mycolors.cardPanel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Mycolors.textPrimary.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course image with discount ribbon
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          course.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            '${course.discountPercent}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Mycolors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Course details with icons
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Mycolors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Mon/Wed/Fri',
                              style: TextStyle(
                                fontSize: 12,
                                color: Mycolors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Mycolors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.durationWeeks} weeks - ${course.hoursPerWeek} h/week',
                              style: TextStyle(
                                fontSize: 12,
                                color: Mycolors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Countdown timer - only show if discountExpiry exists
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 14,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              TweenAnimationBuilder<Duration>(
                                duration: timeDifference,
                                tween: Tween(
                                  begin: timeDifference,
                                  end: Duration.zero,
                                ),
                                onEnd: () {
                                  debugPrint('Timer ended');
                                },
                                builder: (
                                  BuildContext context,
                                  Duration value,
                                  Widget? child,
                                ) {
                                  final days = value.inDays;
                                  final hours = value.inHours % 24;
                                  return Text(
                                    '${days}d ${hours}h left',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Footer section with both prices in same line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 14,
                                  color: Mycolors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${course.maxStudents} seats',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mycolors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${course.price} DZA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Mycolors.textPrimary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${course.discountPrice} DZA',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
