import 'dart:io';

import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/naviagtion_home/Home/CourseDetailsScreen/presentation/widgets/coursedetailsskeliton.dart';
import 'package:fluentnow/naviagtion_home/News/businesse_logic/cubiteventdetails.dart/event_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    BlocProvider.of<EventDetailsCubit>(
      context,
    ).fetchEventDetails(widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showFullText = false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.background,
        appBar: AppBar(
          backgroundColor: Mycolors.background,

          title: Text(
            "Event Details",
            style: TextStyle(
              color: Mycolors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<EventDetailsCubit, EventDetailsState>(
          listener: (context, state) {
            if (state is EventDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is EventDetailsloading || state is EventDetailsInitial) {
              return CourseDetailsSkeleton();
            }
            if (state is EventDetailsLoaded) {
              final event = state.event;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(event.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
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
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  event.isFree
                                      ? Align(
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
                                            'Free',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Mycolors.primary,
                                            ),
                                          ),
                                        ),
                                      )
                                      : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Align(
                                          child: Row(
                                            children: [
                                              Spacer(),

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
                                                  '${event.price} DZA',
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
                                      ),
                                  SizedBox(height: 12),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    icon: Icons.access_time,
                                    text: DateFormat(
                                      'EE, d MMMM yyyy',
                                    ).format(event.eventDate),

                                    color: Mycolors.secondary,
                                  ),
                                  SizedBox(width: 16),

                                  _buildInfoChip(
                                    icon: Icons.school,
                                    text:
                                        "Max attendens :${event.maxAttendees}",
                                    color: Mycolors.accent,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _buildMapChip(
                                  context: context,
                                  icon: Icons.location_on,
                                  text: event.location,
                                  color: Mycolors.secondary,
                                ),
                              ),
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
                                          text: event.description,
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
                                        )..layout(
                                          maxWidth: constraints.maxWidth,
                                        );

                                        final isTextLong =
                                            textPainter.didExceedMaxLines;

                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event.description,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Mycolors.textSecondary,
                                                    height: 1.5,
                                                  ),
                                                  maxLines:
                                                      showFullText ? null : 2,
                                                  overflow:
                                                      showFullText
                                                          ? TextOverflow.visible
                                                          : TextOverflow
                                                              .ellipsis,
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
                                                          color:
                                                              Mycolors.primary,
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
                              _buildDetailCardlist(
                                color: Mycolors.primary,
                                icon: Icons.person,
                                values: event.audience,
                                title: 'Audience',
                              ),
                              SizedBox(height: 20),

                              buildEventStatus(
                                startTime: event.startTime,
                                endTime: event.endTime,
                                registrationRequired:
                                    event.registrationRequired,
                                registrationDeadline:
                                    event.registrationDeadline,
                                isCancelled: event.isCancelled,
                                cancellationReason: event.cancellationReason,
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
            throw Exception('NO DEATAILS');
          },
        ),
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
      constraints: BoxConstraints(
        minHeight: 60,
        maxWidth: 150,
      ), // Ensures minimum height
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

Widget _buildDetailCardlist({
  required IconData icon,
  required String title,
  required List<String> values,
  required Color color,
}) {
  return Container(
    constraints: BoxConstraints(minHeight: 60, maxWidth: 150),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    padding: EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: Mycolors.textSecondary),
              ),
              SizedBox(height: 4),
              // 👇 this part ensures multi-line display
              Text(
                values.join('\n'), // JOIN with line break
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Mycolors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildEventStatus({
  required String startTime,
  required String? endTime,
  required bool registrationRequired,
  required DateTime? registrationDeadline,
  required bool isCancelled,
  required String? cancellationReason,
}) {
  // Case 1: Event is cancelled
  if (isCancelled &&
      cancellationReason != null &&
      cancellationReason.isNotEmpty) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Event cancelled: $cancellationReason",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Case 2: Registration required
  if (registrationRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (registrationDeadline != null)
          Text(
            "Registration Deadline: ",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        Text(
          DateFormat('MMM d, y').format(registrationDeadline!.toLocal()),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Mycolors.primary,
          ),
        ),
        SizedBox(width: 12),
        Text(
          "Event time: ",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        Text(
          endTime != null
              ? "${_formatTime(startTime)} – ${_formatTime(endTime!)}"
              : _formatTime(startTime),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Mycolors.secondary,
          ),
        ),

        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Mycolors.primary, Mycolors.secondary],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Mycolors.primary.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () async {},
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
        const SizedBox(height: 4),
      ],
    );
  }

  // Case 3: Registration not required
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Event time: ",
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
      Text(
        endTime != null
            ? "${_formatTime(startTime)} – ${_formatTime(endTime!)}"
            : _formatTime(startTime),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Mycolors.secondary,
        ),
      ),
      const SizedBox(height: 10),

      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.info_outline, color: Colors.green),
            SizedBox(width: 8),
            Text(
              "No registration required.",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

String _formatTime(String timeStr) {
  final parts = timeStr.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  final dt = DateTime(0, 1, 1, hour, minute);
  return DateFormat.jm().format(dt); // e.g., 1:00 PM
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

Widget _buildMapChip({
  required IconData icon,
  required String text,
  required Color color,
  required BuildContext context, // Pass context as parameter
}) {
  return GestureDetector(
    onTap: () => _launchMap(text, context),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 5),
        Text(
          text,
          overflow: TextOverflow.ellipsis,

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

Future<void> _launchMap(String location, BuildContext context) async {
  // First try to launch as a URL (for web links)
  try {
    final uri = Uri.tryParse(location);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch $location');
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
  } catch (e) {
    debugPrint('URL launch failed: $e');
  }

  // If not a URL, try to launch in maps app
  final query = Uri.encodeComponent(location);
  final mapUri = Uri.parse(
    Platform.isAndroid ? 'geo:0,0?q=$query' : 'http://maps.apple.com/?q=$query',
  );

  try {
    if (!await canLaunchUrl(mapUri)) {
      throw Exception('Could not launch maps');
    }
    await launchUrl(mapUri);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open location: $location')),
      );
    }
    debugPrint('Map launch failed: $e');
  }
}
