import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:fluentnow/naviagtion_home/Home/HomeScreen/data/model/homecourses.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          courseDeatailScreen,
          arguments: {'course': course, 'isNew': false},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: Mycolors.cardPanel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Mycolors.textPrimary.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Course image - now on the left
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                    child: Image.network(
                      course.imageUrl,
                      width: 170,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Mycolors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),

                          // Course details with icons
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            text: 'Mon/Wed/Fri',
                          ),
                          const SizedBox(height: 6),

                          _buildDetailRow(
                            icon: Icons.access_time,
                            text:
                                '${course.durationWeeks} weeks - ${course.hoursPerWeek}h/week',
                          ),
                          const Spacer(),

                          // Footer section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailRow(
                                icon: Icons.people_outline,
                                text: '${course.maxStudents} seats',
                                mainAxisSize: MainAxisSize.min,
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
                  ),
                ],
              ),
            ),

            // NEW Watermark Badge
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      children: [
        Icon(icon, size: 14, color: Mycolors.textSecondary.withOpacity(0.7)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Mycolors.textSecondary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class DiscountCourseCard extends StatelessWidget {
  const DiscountCourseCard({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    final remaining = course.discountExpiry!.difference(DateTime.now());
    final duration =
        remaining > Duration.zero ? remaining : Duration(seconds: 1);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          courseDeatailScreen,
          arguments: {'course': course, 'isNew': false},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Mycolors.cardPanel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Mycolors.textPrimary.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Course image with discount ribbon
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                        child: Image.network(
                          course.imageUrl,
                          width: 170,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${course.discountPercent}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Mycolors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),

                          // Course details with icons
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            text: 'Mon/Wed/Fri',
                          ),
                          const SizedBox(height: 6),

                          _buildDetailRow(
                            icon: Icons.access_time,
                            text:
                                '${course.durationWeeks} weeks - ${course.hoursPerWeek} h/week',
                          ),
                          const SizedBox(height: 12),

                          // Countdown timer
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 15,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(width: 6),

                                TweenAnimationBuilder<Duration>(
                                  duration: duration,
                                  tween: Tween(
                                    begin: duration,
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
                                        fontSize: 13,
                                        color: Colors.red[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),

                          // Footer section with both prices
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailRow(
                                icon: Icons.people_outline,
                                text: '${course.maxStudents} seats',
                                mainAxisSize: MainAxisSize.min,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${course.price} DZA',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Mycolors.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisSize: mainAxisSize,
      children: [
        Icon(icon, size: 14, color: Mycolors.textSecondary.withOpacity(0.7)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Mycolors.textSecondary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
