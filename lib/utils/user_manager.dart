// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/shared/localstorage/index.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';

class UserManager {
  static const String _userKey = "current_user";
  static const String _memberNoKey = "member_no";
  static const String _mtumishiKey = "mtumishi";

  // Save current user
  static Future<void> saveCurrentUser(BaseUser user) async {
    String userJson = jsonEncode(user.toJson());
    await LocalStorage.setStringItem(_userKey, userJson);

    // Also save in the old format for backward compatibility
    await LocalStorage.setStringItem(_memberNoKey, userJson);
  }

  // Get current user
  static Future<BaseUser?> getCurrentUser() async {
    String userJson = await LocalStorage.getStringItem(_userKey);

    // Try to get from old storage format if not found
    if (userJson.isEmpty) {
      userJson = await LocalStorage.getStringItem(_memberNoKey);
    }

    if (userJson.isNotEmpty) {
      try {
        Map<String, dynamic> userData = jsonDecode(userJson);
        return _createUserFromJson(userData);
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing user data: $e");
        }
        return null;
      }
    }

    return null;
  }

  // Create user from JSON data
  static BaseUser? _createUserFromJson(Map<String, dynamic> json) {
    String? userType = json['user_type'];

    switch (userType) {
      case 'ADMIN':
        return AdminUser.fromJson(json);
      case 'MZEE':
        return MzeeUser.fromJson(json);
      case 'KATIBU':
        return KatibuUser.fromJson(json);
      case 'MSHARIKA':
        return MsharikaUser.fromJson(json);
      default:
        // Try to infer user type from available fields
        if (json.containsKey('level') && json.containsKey('email')) {
          return AdminUser.fromJson({...json, 'user_type': 'ADMIN'});
        } else if (json.containsKey('eneo')) {
          return MzeeUser.fromJson({...json, 'user_type': 'MZEE'});
        } else if (json.containsKey('jina_la_msharika')) {
          return MsharikaUser.fromJson({...json, 'user_type': 'MSHARIKA'});
        } else if (json.containsKey('jina') && json.containsKey('jumuiya')) {
          return KatibuUser.fromJson({...json, 'user_type': 'KATIBU'});
        }
        return null;
    }
  }

  // Get user display name
  static String getUserDisplayName(BaseUser? user) {
    if (user == null) return 'Unknown User';

    if (user is AdminUser) {
      return user.fullName;
    } else if (user is MzeeUser) {
      return user.jina;
    } else if (user is KatibuUser) {
      return user.jina;
    } else if (user is MsharikaUser) {
      return user.jinaLaMsharika;
    }

    return 'User';
  }

  // Get user phone number
  static String getUserPhoneNumber(BaseUser? user) {
    if (user == null) return '';

    if (user is AdminUser) {
      return user.phonenumber;
    } else if (user is MzeeUser) {
      return user.nambaYaSimu;
    } else if (user is KatibuUser) {
      return user.nambaYaSimu;
    } else if (user is MsharikaUser) {
      return user.nambaYaSimu;
    }

    return '';
  }

  // Check if user has admin privileges
  static bool isAdmin(BaseUser? user) {
    return user is AdminUser;
  }

  // Check if user is Mzee
  static bool isMzee(BaseUser? user) {
    return user is MzeeUser;
  }

  // Check if user is Katibu
  static bool isKatibu(BaseUser? user) {
    return user is KatibuUser;
  }

  // Check if user is Msharika
  static bool isMsharika(BaseUser? user) {
    return user is MsharikaUser;
  }

  // Save mtumishi data
  static Future<void> saveMtumishiData(Map<String, dynamic> mtumishiData) async {
    String mtumishiJson = jsonEncode(mtumishiData);
    await LocalStorage.setStringItem(_mtumishiKey, mtumishiJson);
  }

  // Get mtumishi data
  static Future<Map<String, dynamic>?> getMtumishiData() async {
    String mtumishiJson = await LocalStorage.getStringItem(_mtumishiKey);
    if (mtumishiJson.isNotEmpty) {
      try {
        return jsonDecode(mtumishiJson);
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing mtumishi data: $e");
        }
        return null;
      }
    }
    return null;
  }

  // Clear all user data (logout)
  static Future<void> clearUserData() async {
    await LocalStorage.removeItem(_userKey);
    await LocalStorage.removeItem(_memberNoKey);
    await LocalStorage.removeItem(_mtumishiKey);
  }

  // Fetch all users by role from API
  static Future<List<BaseUser>> getAllUsersByRole(String role) async {
    try {
      String apiUrl = "${ApiUrl.BASEURL}get_users_by_role.php";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "user_type": role.toUpperCase(),
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404 && jsonResponse is List) {
          List<BaseUser> users = [];
          for (var userData in jsonResponse) {
            BaseUser? user = _createUserFromJson(userData);
            if (user != null) {
              users.add(user);
            }
          }
          return users;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching users by role: $e");
      }
    }
    return [];
  }

  // Fetch all admins
  static Future<List<AdminUser>> getAllAdmins() async {
    List<BaseUser> users = await getAllUsersByRole('ADMIN');
    return users.whereType<AdminUser>().toList();
  }

  // Fetch all Mzee users
  static Future<List<MzeeUser>> getAllMzee() async {
    List<BaseUser> users = await getAllUsersByRole('MZEE');
    return users.whereType<MzeeUser>().toList();
  }

  // Fetch all Katibu users
  static Future<List<KatibuUser>> getAllKatibu() async {
    List<BaseUser> users = await getAllUsersByRole('KATIBU');
    return users.whereType<KatibuUser>().toList();
  }

  // Fetch all Msharika users
  static Future<List<MsharikaUser>> getAllMsharika() async {
    List<BaseUser> users = await getAllUsersByRole('MSHARIKA');
    return users.whereType<MsharikaUser>().toList();
  }

  // Fetch all users (all roles combined)
  static Future<List<BaseUser>> getAllUsers() async {
    try {
      String apiUrl = "${ApiUrl.BASEURL}get_all_users.php";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404 && jsonResponse is List) {
          List<BaseUser> users = [];
          for (var userData in jsonResponse) {
            BaseUser? user = _createUserFromJson(userData);
            if (user != null) {
              users.add(user);
            }
          }
          return users;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching all users: $e");
      }
    }
    return [];
  }

  // Get users by jumuiya (community)
  static Future<List<BaseUser>> getUsersByJumuiya(String jumuiyaId) async {
    try {
      String apiUrl = "${ApiUrl.BASEURL}get_users_by_jumuiya.php";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "jumuiya_id": jumuiyaId,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404 && jsonResponse is List) {
          List<BaseUser> users = [];
          for (var userData in jsonResponse) {
            BaseUser? user = _createUserFromJson(userData);
            if (user != null) {
              users.add(user);
            }
          }
          return users;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching users by jumuiya: $e");
      }
    }
    return [];
  }

  // Search users by name
  static Future<List<BaseUser>> searchUsersByName(String searchTerm) async {
    try {
      String apiUrl = "${ApiUrl.BASEURL}search_users.php";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "search_term": searchTerm,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404 && jsonResponse is List) {
          List<BaseUser> users = [];
          for (var userData in jsonResponse) {
            BaseUser? user = _createUserFromJson(userData);
            if (user != null) {
              users.add(user);
            }
          }
          return users;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error searching users: $e");
      }
    }
    return [];
  }

  // Get user statistics
  static Future<Map<String, int>> getUserStatistics() async {
    try {
      String apiUrl = "${ApiUrl.BASEURL}get_user_statistics.php";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404) {
          return {
            'total_users': jsonResponse['total_users'] ?? 0,
            'admins': jsonResponse['admins'] ?? 0,
            'mzee': jsonResponse['mzee'] ?? 0,
            'katibu': jsonResponse['katibu'] ?? 0,
            'msharika': jsonResponse['msharika'] ?? 0,
          };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user statistics: $e");
      }
    }
    return {
      'total_users': 0,
      'admins': 0,
      'mzee': 0,
      'katibu': 0,
      'msharika': 0,
    };
  }
}
