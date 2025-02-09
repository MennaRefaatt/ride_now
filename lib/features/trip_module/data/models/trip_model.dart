import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
class TripModel {
  late final String tripId;
  final String from;
  final String to;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime dateTime;
  final String price;
  final String estimatedTime;
  final String distance;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final DriverData driverData;
  final PassengerData passengerData;
  final bool moreThan4Passengers;
  final String comment;

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
    required this.paymentMethod,
    required this.paymentStatus,
    required this.estimatedTime,
    required this.moreThan4Passengers,
    required this.comment,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: json['tripId'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      from: json['from'],
      to: json['to'],
      moreThan4Passengers: json['moreThan4Passengers'],
      comment: json['comment'],
      status: json['status'],
      estimatedTime: json['estimatedTime'],
      fromLatLng: json['fromLatLng'] is Map<String, dynamic>
          ? LatLng(
              json['fromLatLng']['latitude']?.toDouble() ?? 0.0,
              json['fromLatLng']['longitude']?.toDouble() ?? 0.0,
            )
          : json['fromLatLng'] as LatLng,
      toLatLng: json['toLatLng'] is Map<String, dynamic>
          ? LatLng(
              json['toLatLng']['latitude']?.toDouble() ?? 0.0,
              json['toLatLng']['longitude']?.toDouble() ?? 0.0,
            )
          : json['toLatLng'] as LatLng,
      dateTime: (json['dateTime'] is Timestamp)
          ? (json['dateTime'] as Timestamp).toDate()
          : DateFormat('dd/MM/yyyy HH:mm').parse(json['dateTime'] ?? ''),
      price: (json['price'] is String)
          ? double.tryParse(json['price'])?.toString() ?? '0.0'
          : json['price'].toString(),
      distance: (json['distance'] is String)
          ? double.tryParse(json['distance'])?.toString() ?? '0.0'
          : json['distance'].toString(),
      driverData: json['driverData'] is Map<String, dynamic>
          ? DriverData.fromJson(json['driverData'])
          : DriverData.fromJson({}),
      passengerData: json['passengerData'] is Map<String, dynamic>
          ? PassengerData.fromJson(json['passengerData'])
          : PassengerData.fromJson({}),
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate = dateFormat.format(dateTime);
    return {
      'tripId': tripId,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'from': from,
      'to': to,
      'moreThan4Passengers': moreThan4Passengers,
      'comment': comment,
      'estimatedTime': estimatedTime,
      "fromLatLng": {
        "latitude": fromLatLng.latitude,
        "longitude": fromLatLng.longitude
      },
      "toLatLng": {
        "latitude": toLatLng.latitude,
        "longitude": toLatLng.longitude
      },
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
  final String driverToken;
  DriverData({
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.driverImage,
    required this.carColor,
    required this.carModel,
    required this.carNumber,
    required this.driverLocation,
    required this.driverToken,
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
      driverToken: json['driverToken'],
      driverLocation: LatLng(json['driverLocation']['latitude'] ?? 0.0,
          json['driverLocation']['longitude'] ?? 0.0),
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
        'driverToken': driverToken,
        'driverLocation': {
          'latitude': driverLocation.latitude,
          'longitude': driverLocation.longitude,
        },
      };
}

class PassengerData {
  final String passengerId;
  final String passengerName;
  final String passengerPhone;
  final String passengerToken;
  PassengerData({
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerToken,
  });

  factory PassengerData.fromJson(Map<String, dynamic> json) {
    return PassengerData(
      passengerId: json['passengerId'],
      passengerName: json['passengerName'],
      passengerPhone: json['passengerPhone'],
      passengerToken: json['passengerToken'],
    );
  }

  Map<String, dynamic> toJson() => {
        'passengerId': passengerId,
        'passengerName': passengerName,
        'passengerPhone': passengerPhone,
        'passengerToken': passengerToken,
      };
}
