import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  late final String tripId;
  final String from;
  final String to;
  final String status;
  final Timestamp dateTime;
  final String price;
  final String distance;
  final DriverData driverData;
  final PassengerData passengerData;
  TripModel({
    required this.tripId,
    required this.from,
    required this.to,
    required this.status,
    required this.dateTime,
    required this.price,
    required this.distance,
    required this.driverData,
    required this.passengerData,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: json['tripId'],
      from: json['from'],
      to: json['to'],
      status: json['status'],
      dateTime: json['dateTime'],
      price: json['price'],
      distance: json['distance'],
      driverData: DriverData.fromJson(json['driverData']),
      passengerData: PassengerData.fromJson(json['passengerData']),
    );
  }

  Map<String, dynamic> toJson() => {
    'tripId': tripId,
    'from': from,
    'to': to,
    'status': status,
    'dateTime': dateTime,
    'price': price,
    'distance': distance,
    'driverData': driverData.toJson(),
    'passengerData': passengerData.toJson(),
  };

  DateTime getDateTime() {
    return dateTime.toDate();
  }
}

class DriverData {
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String driverImage;
  final String driverLocation;

  DriverData({
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.driverImage,
    required this.driverLocation,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      driverImage: json['driverImage'],
      driverLocation: json['driverLocation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'driverId': driverId,
    'driverName': driverName,
    'driverPhone': driverPhone,
    'driverImage': driverImage,
    'driverLocation': driverLocation,
  };
}

class PassengerData {
  final String passengerId;
  final String passengerName;
  final String passengerPhone;

  PassengerData({
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
  });

  factory PassengerData.fromJson(Map<String, dynamic> json) {
    return PassengerData(
      passengerId: json['passengerId'],
      passengerName: json['passengerName'],
      passengerPhone: json['passengerPhone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'passengerId': passengerId,
    'passengerName': passengerName,
    'passengerPhone': passengerPhone,
  };
}
