class TripModel {
  late final String tripId;
  final String passengerId;
  final String? driverId;
  final String from;
  final String to;
  final String status;
  final DateTime dateTime;
  final String price;
  final String passengerName;
  final String distance;

  TripModel({
    required this.tripId,
    required this.passengerId,
    this.driverId,
    required this.from,
    required this.to,
    required this.status,
    required this.dateTime,
    required this.price,
    required this.passengerName,
    required this.distance
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      tripId: json['tripId'],
      passengerId: json['passengerId'],
      driverId: json['driverId'],
      from: json['from'],
      to: json['to'],
      status: json['status'],
      dateTime: json['dateTime'],
      price: json['price'],
      passengerName: json['passengerName'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tripId': tripId,
    'passengerId': passengerId,
    'driverId': driverId,
    'from': from,
    'to': to,
    'status': status,
    'dateTime': dateTime,
    'price': price,
    'passengerName': passengerName,
    'distance': distance
  };
}
