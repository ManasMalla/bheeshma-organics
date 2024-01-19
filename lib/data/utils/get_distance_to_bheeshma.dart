import 'dart:convert';

import 'package:http/http.dart';

class DistanceUtil {
  Future<int> getDistanceToBheeshmaOrganics(String pincode) async {
    final request = await post(
        Uri.parse(
            'https://india-pincode-with-latitude-and-longitude.p.rapidapi.com/api/v1/pincode/distance'),
        body: {
          'pincode1': pincode,
          'pincode2': '523001',
        },
        headers: {
          "content-type": "application/x-www-form-urlencoded",
          "X-RapidAPI-Key":
              "71d6258d4cmsh6b89f0d4894d120p16d4f6jsncdafdf4b64b3",
          "X-RapidAPI-Host":
              "india-pincode-with-latitude-and-longitude.p.rapidapi.com",
        });
    if (request.statusCode == 200) {
      final response = json.decode(request.body);
      return (response['distance'].toInt()) * 1600;
    } else {
      return 523000;
    }
  }
}
