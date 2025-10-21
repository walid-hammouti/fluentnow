import 'package:fluentnow/constants/strings.dart';

class Subscriptioncourses {
  final String title;
  final double price;
  final double discountedPrice;
  final DateTime startdate;
  final String status;

  Subscriptioncourses({
    required this.title,
    required this.price,
    required this.discountedPrice,
    required this.status,
    required this.startdate,
  });

  factory Subscriptioncourses.fromJson(Map<String, dynamic> json) {
    return Subscriptioncourses(
      title: json['title'],
      price: json['price'],
      discountedPrice: json['discounted_price'],
      status: json['status'],
      startdate: DateTime.parse(json['start_date']),
    );
  }
}
