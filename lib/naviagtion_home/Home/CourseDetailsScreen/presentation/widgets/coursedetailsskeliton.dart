import 'package:fluentnow/constants/app_theme.dart';
import 'package:flutter/material.dart';

class CourseDetailsSkeleton extends StatelessWidget {
  const CourseDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.background,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Hero Image Skeleton
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),

              // Main Content Skeleton
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
                      // Title Skeleton
                      Container(
                        width: double.infinity,
                        height: 28,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 10),
                      ),

                      // Price Skeleton
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 100,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                      ),

                      SizedBox(height: 12),

                      // Chips Skeleton
                      Row(
                        children: [
                          _buildSkeletonChip(),
                          SizedBox(width: 8),
                          _buildSkeletonChip(),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Description Skeleton
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 20,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.only(bottom: 8),
                          ),
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.only(bottom: 4),
                          ),
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.only(bottom: 4),
                          ),
                          Container(
                            width: 200,
                            height: 16,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Grid Skeleton
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(
                          4,
                          (index) => _buildSkeletonDetailCard(),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Dates Skeleton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 20,
                            color: Colors.grey[300],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "to",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 20,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      // Button Skeleton
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 16, height: 16, color: Colors.grey[300]),
          const SizedBox(width: 5),
          Container(width: 60, height: 12, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildSkeletonDetailCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 10,
                color: Colors.grey[300],
                margin: const EdgeInsets.only(bottom: 4),
              ),
              Container(width: 60, height: 12, color: Colors.grey[300]),
            ],
          ),
        ],
      ),
    );
  }
}
