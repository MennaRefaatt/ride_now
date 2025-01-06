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
      driverData: json['driverData'] is Map<String, dynamic>
          ? DriverData.fromJson(json['driverData'])
          : DriverData.fromJson({}), // Or handle accordingly
      passengerData: json['passengerData'] is Map<String, dynamic>
          ? PassengerData.fromJson(json['passengerData'])
          : PassengerData.fromJson({}), // Or handle accordingly
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
  final String carColor;
  final String carModel;
  final String carNumber;
  final DriverLocation driverLocation;
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
      driverLocation: DriverLocation.fromJson(json['driverLocation']),
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
class DriverLocation {
  final double latitude;
  final double longitude;

  DriverLocation({
    required this.latitude,
    required this.longitude,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
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
