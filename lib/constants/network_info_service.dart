import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:plantas_ai_plant_identifier/constants/api_url.dart';

class NetworkInfoService {
  static Future<bool> isNetworkAvailable() async {
    if (kIsWeb) {
      debugPrint("Running on the web, assuming network is available.");
      return true;
    } else {
      debugPrint("Checking network availability...");
      try {
        final List<InternetAddress> res = await InternetAddress.lookup(PlantasApiUrl.checkUrl);
        debugPrint('Lookup result: ${res.length} addresses found.');
        if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
          return true;
        } else {
          debugPrint('No valid addresses found.');
          return false;
        }
      } on SocketException catch (e) {
        debugPrint('SocketException: $e');
        return false;
      } catch (e) {
        debugPrint('Unexpected error: $e');
        return false;
      }
    }
  }
}
