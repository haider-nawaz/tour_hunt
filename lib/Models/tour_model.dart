import 'package:cloud_firestore/cloud_firestore.dart';

class TourModel {
  String? arrangedByEmail;
  String? category;
  String? companyName;
  String? departureTime;
  String? arrival;
  String? description;
  String? departureFrom;
  String? duration;
  String? location;
  String? price;
  String? status;
  String? id;

  TourModel({
    required this.arrangedByEmail,
    required this.category,
    required this.companyName,
    required this.departureTime,
    required this.arrival,
    required this.description,
    required this.departureFrom,
    required this.duration,
    required this.location,
    required this.price,
    required this.status,
    this.id,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      arrangedByEmail: json['arrangedByEmail'],
      category: json['category'],
      companyName: json['companyname'],
      departureTime: json['departureTime'],
      arrival: json['arrival'],
      description: json['description'],
      departureFrom: json['departureFrom'],
      duration: json['duration'],
      location: json['location'],
      price: json['price'],
      status: json['status'],
      id: '',
    );
  }

  Map<String, dynamic> toJson() => {
        'arrangeby': arrangedByEmail,
        'category': category,
        'companyname': companyName,
        'departure': departureTime,
        'arrival': arrival,
        'description': description,
        'departureFrom': departureFrom,
        'duration': duration,
        'location': location,
        'price': price,
        'status': status,
      };

  //from map
  TourModel.fromMap(DocumentSnapshot map) {
    arrangedByEmail = map['arrangedByEmail'];
    category = map['category'];
    companyName = map['companyname'];
    departureTime = map['departureTime'];
    description = map['description'];
    departureFrom = map['departureFrom'];
    duration = map['duration'];
    location = map['location'];
    price = map['price'];
    status = map['status'];
    id = map.id;
  }
}
