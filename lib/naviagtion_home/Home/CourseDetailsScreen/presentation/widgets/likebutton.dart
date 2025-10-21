import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitcorusesdetails/coursedetails_cubit.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/businesse_logic/cubitlikedcourses/likedcourses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseLikeButton extends StatefulWidget {
  final String courseId;
  const CourseLikeButton({super.key, required this.courseId});

  @override
  State<CourseLikeButton> createState() => _CourseLikeButtonState();
}

class _CourseLikeButtonState extends State<CourseLikeButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursedetailsCubit, CourseDetailsState>(
      builder: (context, detailsState) {
        // Get initial like status from details
        final initialIsLiked =
            detailsState is CourseDetailsLoaded ? detailsState.isliked : false;
        final courseId =
            detailsState is CourseDetailsLoaded ? widget.courseId : null;

        return BlocConsumer<CourseLikeCubit, CourseLikeState>(
          listener: (context, likeState) {
            // Handle errors
            if (likeState is LikeError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(likeState.message)));
            }
          },
          builder: (context, likeState) {
            // Determine current state
            final isProcessing = likeState is LikeLoading;
            final isLiked =
                likeState is LikeSuccess
                    ? true
                    : likeState is UnlikeSuccess
                    ? false
                    : initialIsLiked;

            return IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
              ),
              onPressed:
                  isProcessing || courseId == null
                      ? null
                      : () => context.read<CourseLikeCubit>().toggleLike(
                        courseId,
                        isLiked,
                      ),
            );
          },
        );
      },
    );
  }
}
