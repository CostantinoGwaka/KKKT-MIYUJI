// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';

class UserService {
  static Future<LoginResponse> login(
      String memberNo, String password, String token) async {
    try {
      String myApi = "${ApiUrl.BASEURL}login.php/";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: {
          "member_no": memberNo.startsWith('0')
              ? '255${memberNo.substring(1)}'
              : memberNo,
          "password": password,
          "token": token,
        },
      );

      // log(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Handle the new API response format
        if (jsonResponse is Map<String, dynamic>) {
          return LoginResponse.fromJson(jsonResponse);
        }

        // Handle old API response format (array)
        if (jsonResponse != null &&
            jsonResponse != 404 &&
            jsonResponse != 500) {
          if (jsonResponse is List && jsonResponse.isNotEmpty) {
            // For backward compatibility with old API format
            final userData = jsonResponse[0];
            return LoginResponse(
              status: 200,
              message: "Login successful",
              data: _createUserFromOldFormat(userData),
            );
          }
        } else if (jsonResponse == 404) {
          return LoginResponse(
            status: 404,
            message: "Taarifa zako hazijapatikana",
          );
        } else if (jsonResponse == 500) {
          return LoginResponse(
            status: 500,
            message: "Server Error Please Try Again Later",
          );
        }
      } else if (response.statusCode != 200) {
        return LoginResponse(
          status: 404,
          message: "Taarifa zako hazijapatikana",
        );
      } else {
        return LoginResponse(
          status: response.statusCode,
          message: "Taarifa zako hazijapatikana",
        );
      }

      return LoginResponse(
        status: response.statusCode,
        message: "Taarifa zako hazijapatikana",
      );
    } catch (e) {
      return LoginResponse(
        status: 0,
        message: "Network error: ${e.toString()}",
      );
    }
  }

  // Helper method to create user from old API format
  static BaseUser? _createUserFromOldFormat(Map<String, dynamic> userData) {
    // Try to determine user type from available fields

    // if (userData.containsKey('level') && userData.containsKey('email')) {
    //   // Admin user
    //   return BaseUser(
    //     id: userData['id'] ?? 0,
    //     phonenumber: userData['namba_ya_simu'] ?? '',
    //     email: userData['email'] ?? '',
    //     password: userData['password'] ?? '',
    //     level: userData['level'] ?? '1',
    //     status: userData['status'] ?? 0,
    //     fullName: userData['fname'] ?? userData['jina'] ?? '',
    //     memberNo: userData['member_no'] ?? '',
    //     kanisaId: userData['kanisa_id'] ?? '1',
    //     kanisaName: userData['kanisa_name'] ?? 'KKKT MIYUJI',
    //   );
    // } else if (userData.containsKey('eneo')) {
    //   // Mzee user
    //   return BaseUser(
    //     id: userData['id'] ?? 0,
    //     jina: userData['jina'] ?? userData['fname'] ?? '',
    //     nambaYaSimu: userData['namba_ya_simu'] ?? '',
    //     password: userData['password'] ?? '',
    //     eneo: userData['eneo'] ?? '',
    //     jumuiya: userData['jumuiya'] ?? '',
    //     jumuiyaId: userData['jumuiya_id'] ?? '',
    //     mwaka: userData['mwaka'] ?? '',
    //     status: userData['status'] ?? 'active',
    //     tarehe: userData['tarehe'] ?? '',
    //     memberNo: userData['member_no'] ?? '',
    //     kanisaId: userData['kanisa_id'] ?? '1',
    //     kanisaName: userData['kanisa_name'] ?? 'KKKT MIYUJI',
    //   );
    // } else if (userData.containsKey('jina_la_msharika')) {
    //   // Msharika user
    //   return MsharikaRecord.fromJson(userData);
    // } else if (userData.containsKey('jina') &&
    //     userData.containsKey('jumuiya')) {
    //   // Katibu user
    //   return BaseUser(
    //     id: userData['id'] ?? 0,
    //     jina: userData['jina'] ?? userData['fname'] ?? '',
    //     nambaYaSimu: userData['namba_ya_simu'] ?? '',
    //     password: userData['password'] ?? '',
    //     jumuiya: userData['jumuiya'] ?? '',
    //     jumuiyaId: userData['jumuiya_id'] ?? '',
    //     mwaka: userData['mwaka'] ?? '',
    //     status: userData['status'] ?? 'active',
    //     tarehe: userData['tarehe'] ?? '',
    //     memberNo: userData['member_no'] ?? '',
    //     kanisaId: userData['kanisa_id'] ?? '1',
    //     kanisaName: userData['kanisa_name'] ?? 'KKKT MIYUJI',
    //   );
    // }

    return BaseUser.fromJson(userData);
  }

  static Future<bool> checkMtumishi(String memberNo) async {
    try {
      String mtumishApi = "${ApiUrl.BASEURL}check_mtumish.php/";
      final response = await http.post(
        Uri.parse(mtumishApi),
        headers: {'Accept': 'application/json'},
        body: {
          "member_no": memberNo,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null &&
            jsonResponse != 404 &&
            jsonResponse != 500) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
