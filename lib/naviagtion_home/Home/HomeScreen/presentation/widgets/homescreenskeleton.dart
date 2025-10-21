import 'package:fluentnow/constants/app_theme.dart';
import 'package:flutter/material.dart';

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Skeleton
            _buildHeaderSkeleton(),
            const SizedBox(height: 16),

            // Promo Banner Skeleton
            _buildPromoBannerSkeleton(),
            const SizedBox(height: 24),

            // Newest Courses Section Skeleton
            _buildSectionTitleSkeleton(),
            _buildHorizontalListSkeleton(itemHeight: 250),
            const SizedBox(height: 24),

            // Discounted Courses Section Skeleton
            _buildSectionTitleSkeleton(),
            _buildHorizontalListSkeleton(itemHeight: 270),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar
          const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
          const SizedBox(width: 16),
          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 12,
                  color: Colors.grey.withOpacity(0.6),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 16,
                  color: Colors.grey.withOpacity(0.6),
                ),
              ],
            ),
          ),
          // Icons
          Row(
            children: List.generate(
              2,
              (index) => Container(
                margin: const EdgeInsets.only(left: 16),
                width: 24,
                height: 24,
                color: Colors.grey.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBannerSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSectionTitleSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Container(
        width: 150,
        height: 20,
        color: Colors.grey.withOpacity(0.6),
      ),
    );
  }

  Widget _buildHorizontalListSkeleton({required double itemHeight}) {
    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, top: 16),
        itemCount: 3, // Show 3 skeleton items
        itemBuilder: (context, index) {
          return Container(
            width: 270,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey.withOpacity(0.6),
                ),
                const SizedBox(height: 8),
                // Details
                ...List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      width: 100 + index * 20.0,
                      height: 12,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ),
                const Spacer(),
                // Footer
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey.withOpacity(0.6),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
