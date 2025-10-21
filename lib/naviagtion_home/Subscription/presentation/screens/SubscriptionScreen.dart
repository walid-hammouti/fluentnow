import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Subscription/businesse_logic/cubit/subscription_cubit.dart';
import 'package:fluentnow/naviagtion_home/Subscription/data/model/subscriptioncourses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    BlocProvider.of<SubscriptionCubit>(context).fetchSubscibedCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.background,
      appBar: AppBar(
        title: Text(
          'My Subscription',
          style: TextStyle(
            color: Mycolors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Mycolors.background,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: Mycolors.primary,
        onRefresh:
            () async =>
                BlocProvider.of<SubscriptionCubit>(
                  context,
                ).fetchSubscibedCourses(),
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionInitial || state is SubscriptionLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Mycolors.primary),
              );
            } else if (state is SubscriptionErrore) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () =>
                              BlocProvider.of<SubscriptionCubit>(
                                context,
                              ).fetchSubscibedCourses(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is SubscriptionLoaded) {
              return _buildCourseList(state.subcourses);
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  Widget _buildCourseList(List<Subscriptioncourses> courses) {
    if (courses.isEmpty) {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No Courses Yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Explore our courses and start learning!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(course);
      },
    );
  }

  Widget _buildCourseCard(Subscriptioncourses course) {
    // Define status colors

    // Get color based on status (default to grey if status not found)
    final statusColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Mycolors.primary.withOpacity(0.9),
            Mycolors.secondary.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'start date : ${_formatDate(course.startdate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (course.discountedPrice > 0 &&
                        course.discountedPrice < course.price)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${((course.price - course.discountedPrice) / course.price * 100).toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      course.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildPriceSection(course),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(Subscriptioncourses course) {
    if (course.discountedPrice > 0 && course.discountedPrice < course.price) {
      return Row(
        children: [
          Text(
            '\$${course.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${course.discountedPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Text(
        '\$${course.price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
