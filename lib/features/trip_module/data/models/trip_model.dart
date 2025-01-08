import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TripModel {
  late final String tripId;
  final String from;
  final String to;
  final String status;
  final DateTime dateTime;
  final String price;
  final String distance;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final DriverData driverData;
  final PassengerData passengerData;
  TripModel({
    required this.tripId,
    required this.from,
    required this.to,
    required this.status,
    required this.dateTime,
    required this.price,
    required this.fromLatLng,
    required this.toLatLng,
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
      fromLatLng: LatLng(json['fromLat'], json['fromLng']),
      toLatLng: LatLng(json['toLat'], json['toLng']),
      dateTime: (json['dateTime'] is Timestamp)
          ? (json['dateTime'] as Timestamp).toDate()
          : DateFormat('dd/MM/yyyy HH:mm')
              .parse(json['dateTime'] ?? ''), // Handle custom format
      price: json['price'],
      distance: json['distance'],
      driverData: json['driverData'] is Map<String, dynamic>
          ? DriverData.fromJson(json['driverData'])
          : DriverData.fromJson({}), // Or handle accordingly
      passengerData: json['passengerData'] is Map<String, dynamic>
          ? PassengerData.fromJson(json['passengerData'])
          : PassengerData.fromJson({}), // Or handle accordingly
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate = dateFormat.format(dateTime);
    return {
      'tripId': tripId,
      'from': from,
      'to': to,
      "fromLatLng": fromLatLng.toJson(),
      "toLatLng": toLatLng.toJson(),
      'status': status,
      'dateTime': formattedDate,
      'price': price,
      'distance': distance,
      'driverData': driverData.toJson(),
      'passengerData': passengerData.toJson(),
    };
  }

  String getFormattedDateTime() {
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormatter.format(dateTime);
  }
}

class DriverData {
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String driverImage;
  final String carColor;
  final String carModel;
  final String carNumber;
  final LatLng driverLocation;
  DriverData({
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.driverImage,
    required this.carColor,
    required this.carModel,
    required this.carNumber,
    required this.driverLocation,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      driverImage: json['driverImage'],
      carColor: json['carColor'],
      carModel: json['carModel'],
      carNumber: json['carNumber'],
      driverLocation: LatLng(json['driverLocation']['latitude'],
          json['driverLocation']['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'driverName': driverName,
        'driverPhone': driverPhone,
        'driverImage': driverImage,
        'carColor': carColor,
        'carModel': carModel,
        'carNumber': carNumber,
        'driverLocation': driverLocation.toJson(),
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
