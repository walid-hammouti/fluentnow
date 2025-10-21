class News {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final bool isUrgent;
  final DateTime publishedAt;
  final String? externalLink;
  final bool isPublished;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.isUrgent = false,
    required this.publishedAt,
    this.externalLink,
    this.isPublished = true,
  });

  // Factory constructor for creating a new News instance from a map (e.g., from JSON)
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String,
      isUrgent: json['is_urgent'] as bool? ?? false,
      publishedAt: DateTime.parse(json['published_at'] as String),
      externalLink: json['external_link'] as String?,
      isPublished: json['is_published'] as bool? ?? true,
    );
  }
}

/// Represents a school event with attendance tracking and registration details

class SchoolEvent {
  final String id;
  final String title; //*
  final String description; //*
  final String imageUrl; //*
  final DateTime eventDate; //*
  final String startTime; // Stored as "HH:MM" (24-hour format)
  final String? endTime; // Stored as "HH:MM" (24-hour format)
  final String location; //*
  final int? maxAttendees; //*
  final bool isFree; //*
  final double? price; //*
  final bool registrationRequired; //*
  final DateTime? registrationDeadline; //*
  final List<String> audience; //*
  final bool isCancelled; //*
  final String? cancellationReason; //*
  final bool isPublished;

  const SchoolEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.eventDate,
    required this.startTime,
    this.endTime,
    required this.location,
    this.maxAttendees,
    this.isFree = true,
    this.price,
    this.registrationRequired = false,
    this.registrationDeadline,
    this.audience = const [],
    this.isCancelled = false,
    this.cancellationReason,
    this.isPublished = true,
  });

  factory SchoolEvent.fromJson(Map<String, dynamic> json) {
    return SchoolEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      eventDate: DateTime.parse(json['event_date'] as String),
      startTime: json['start_time'] as String, // Direct string assignment
      endTime: json['end_time'] as String?, // Direct string assignment
      location: json['location'] as String,
      maxAttendees: json['max_attendees'] as int?,
      isFree: json['is_free'] as bool? ?? true,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      registrationRequired: json['registration_required'] as bool? ?? false,
      registrationDeadline:
          json['registration_deadline'] != null
              ? DateTime.parse(json['registration_deadline'] as String)
              : null,
      audience: List<String>.from(json['audience'] as List? ?? []),
      isCancelled: json['is_cancelled'] as bool? ?? false,
      cancellationReason: json['cancellation_reason'] as String?,
      isPublished: json['is_published'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventDate == other.eventDate &&
          startTime == other.startTime;

  @override
  int get hashCode => id.hashCode ^ eventDate.hashCode ^ startTime.hashCode;

  @override
  String toString() {
    return 'SchoolEvent($id, "$title", ${eventDate.year}-${eventDate.month}-${eventDate.day} $startTime)';
  }

  // Format time for display (e.g., "14:30" → "2:30 PM")
  String get formattedStartTime {
    final parts = startTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour =
        hour > 12
            ? hour - 12
            : hour == 0
            ? 12
            : hour;
    return '$displayHour:$minute $period';
  }

  // Get full time range if endTime exists
  String? get formattedTimeRange {
    if (endTime == null) return null;
    final endParts = endTime!.split(':');
    final endHour = int.parse(endParts[0]);
    final endMinute = endParts[1];
    final endPeriod = endHour >= 12 ? 'PM' : 'AM';
    final endDisplayHour =
        endHour > 12
            ? endHour - 12
            : endHour == 0
            ? 12
            : endHour;
    return '$formattedStartTime - $endDisplayHour:$endMinute $endPeriod';
  }

  // Check if registration is still open
  bool get isRegistrationOpen {
    if (!registrationRequired) return false;
    if (registrationDeadline == null) return true;
    return DateTime.now().isBefore(registrationDeadline!);
  }
}

class Eventcard {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Eventcard({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  // Factory constructor for creating a new Eventcard instance from a map (e.g., from JSON)
  factory Eventcard.fromJson(Map<String, dynamic> json) {
    return Eventcard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
