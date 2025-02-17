import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

// Load the service account credentials from a JSON file
Future<ServiceAccountCredentials> loadCredentials() async {
  final credentialsJson = await rootBundle.loadString('assets/service-account.json');
  final credentialsMap = json.decode(credentialsJson);
  return ServiceAccountCredentials.fromJson(credentialsMap);
}




// Generate the OAuth 2.0 access token
Future<AccessCredentials> getAccessToken() async {
  final credentials = await loadCredentials();
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final httpClient = http.Client();
  return await obtainAccessCredentialsViaServiceAccount(credentials, scopes, httpClient);
}