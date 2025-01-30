import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_url.dart';

class PlantIdentificationService {
  static Future<Map<String, dynamic>> getPlantasMatchApi(
    String? organs,
    String? imagepath,
  ) async {
    String url = PlantasApiUrl.getplantasMatchData;
    try {
      log('Creating multipart request to URL: $url');

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll({'accept': 'application/json', 'token': '123'});

      request.fields['organs'] = organs ?? 'auto';
      log('Adding fields: organs = $organs');

      request.files
          .add(await http.MultipartFile.fromPath('images', imagepath!));
      log('Adding file: $imagepath');

      var response = await request.send();

      log('Request sent, waiting for response...');
      var responseBody = await response.stream.bytesToString();
      log('Response body: $response');

      Map<String, dynamic> result = jsonDecode(responseBody);

      switch (response.statusCode) {
        case HttpStatus.ok:
          return result;
        case HttpStatus.unauthorized:
          log('Unauthorized request.');
          return {'message': 'Unauthorized'};
        case HttpStatus.notFound:
          log('Resource not found.');
          return {'message': 'Something went wrong', 'success': 'false'};
        case HttpStatus.internalServerError:
          log('Internal server error.');
          return {'message': 'Server Error', 'success': 'false'};
        default:
          log('Unexpected error: ${response.statusCode}');
          return {
            'message': 'Unexpected error: ${response.statusCode}',
            'success': 'false'
          };
      }
    } on SocketException {
      log('No internet connection.');
      return {'message': 'Not connected to the internet', 'success': 'false'};
    } on TimeoutException {
      log('Request timed out.');
      return {'message': 'Request timeout', 'success': 'false'};
    } on FormatException {
      log('Bad response format.');
      return {'message': 'Bad response format', 'success': 'false'};
    } catch (e) {
      log('Unexpected error: $e');
      return {'message': 'Unexpected error', 'success': 'false'};
    }
  }

  static Future<Map<String, dynamic>> plantasDetaildata({
    String? preferedReferential,
    String? bestMatch,
  }) async {
    // Construct the URL with query parameters
    String url =
        "${PlantasApiUrl.plantasDetailData}?project_name=$preferedReferential&lang=en&truncated=true";

    // Create the request body
    Map<String, dynamic> requestBody = {
      'specie_name': bestMatch,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      Map<String, dynamic> result = jsonDecode(response.body);

      log('url--------------: $url');
      log('status code-------: ${response.statusCode}');

      switch (response.statusCode) {
        case HttpStatus.ok:
          return result;
        case HttpStatus.unauthorized:
          return {'message': 'Unauthorized'};
        case HttpStatus.notFound:
          return {'message': 'Something went wrong', 'success': 'false'};
        case HttpStatus.internalServerError:
          return {'message': 'Server Error', 'success': 'false'};
        default:
          return {
            'message': 'Unexpected error: ${response.statusCode}',
            'success': 'false'
          };
      }
    } on SocketException {
      return {'message': 'Not connected to the internet', 'success': 'false'};
    } on TimeoutException {
      return {'message': 'Request timeout', 'success': 'false'};
    } on FormatException {
      return {'message': 'Bad response format', 'success': 'false'};
    } catch (e) {
      log('Unexpected error: $e');
      return {'message': 'Unexpected error', 'success': 'false'};
    }
  }
}
