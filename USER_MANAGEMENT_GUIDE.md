# User Management System - Usage Guide

This document explains how to use the enhanced UserManager to get all user details based on their roles (Admin, Katibu, Mzee, or Msharika).

## 🔧 **Setup**

### 1. API Endpoints Required
Make sure your backend has these API endpoints:

```php
// Get users by role
POST /api/get_users_by_role.php
Body: { "user_type": "ADMIN|MZEE|KATIBU|MSHARIKA" }

// Get all users
POST /api/get_all_users.php

// Get users by jumuiya
POST /api/get_users_by_jumuiya.php
Body: { "jumuiya_id": "123" }

// Search users
POST /api/search_users.php
Body: { "search_term": "John" }

// Get user statistics
POST /api/get_user_statistics.php
```

### 2. Import Required Packages
```dart
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/models/user_models.dart';
```

## 📋 **Basic Usage**

### Get Current User
```dart
BaseUser? currentUser = await UserManager.getCurrentUser();
if (currentUser != null) {
  print("Current user: ${UserManager.getUserDisplayName(currentUser)}");
  print("User type: ${currentUser.userType}");
}
```

### Get All Users by Role

#### Get All Admins
```dart
List<AdminUser> admins = await UserManager.getAllAdmins();
for (AdminUser admin in admins) {
  print("Admin: ${admin.fullName} - ${admin.email}");
}
```

#### Get All Mzee
```dart
List<MzeeUser> mazee = await UserManager.getAllMzee();
for (MzeeUser mzee in mazee) {
  print("Mzee: ${mzee.jina} - ${mzee.eneo}");
}
```

#### Get All Katibu
```dart
List<KatibuUser> makatibu = await UserManager.getAllKatibu();
for (KatibuUser katibu in makatibu) {
  print("Katibu: ${katibu.jina} - ${katibu.jumuiya}");
}
```

#### Get All Msharika
```dart
List<MsharikaUser> washarika = await UserManager.getAllMsharika();
for (MsharikaUser msharika in washarika) {
  print("Msharika: ${msharika.jinaLaMsharika} - ${msharika.jinaLaJumuiya}");
}
```

### Get All Users (All Roles)
```dart
List<BaseUser> allUsers = await UserManager.getAllUsers();
print("Total users: ${allUsers.length}");

// Filter by user type
List<BaseUser> admins = allUsers.where((user) => user.userType == 'ADMIN').toList();
List<BaseUser> mazee = allUsers.where((user) => user.userType == 'MZEE').toList();
```

## 🔍 **Advanced Usage**

### Search Users by Name
```dart
List<BaseUser> searchResults = await UserManager.searchUsersByName("John");
for (BaseUser user in searchResults) {
  print("Found: ${UserManager.getUserDisplayName(user)} (${user.userType})");
}
```

### Get Users by Jumuiya
```dart
List<BaseUser> jumuiyaUsers = await UserManager.getUsersByJumuiya("123");
print("Users in this jumuiya: ${jumuiyaUsers.length}");
```

### Get User Statistics
```dart
Map<String, int> stats = await UserManager.getUserStatistics();
print("Total users: ${stats['total_users']}");
print("Admins: ${stats['admins']}");
print("Mzee: ${stats['mzee']}");
print("Katibu: ${stats['katibu']}");
print("Msharika: ${stats['msharika']}");
```

## 🎯 **Role-Based Access Control**

### Check User Permissions
```dart
BaseUser? currentUser = await UserManager.getCurrentUser();

if (UserManager.isAdmin(currentUser)) {
  // Admin can see all users
  List<BaseUser> allUsers = await UserManager.getAllUsers();
  // Show admin panel
} else if (UserManager.isMzee(currentUser)) {
  // Mzee can see users in their eneo
  // Show limited access
} else if (UserManager.isKatibu(currentUser)) {
  // Katibu can see users in their jumuiya
  String jumuiyaId = (currentUser as KatibuUser).jumuiyaId;
  List<BaseUser> jumuiyaUsers = await UserManager.getUsersByJumuiya(jumuiyaId);
} else if (UserManager.isMsharika(currentUser)) {
  // Msharika can only see their own data
  // Show limited access
}
```

## 📱 **UI Implementation Example**

### Simple User List Widget
```dart
class UserListWidget extends StatefulWidget {
  final String userType; // 'ADMIN', 'MZEE', 'KATIBU', 'MSHARIKA', or 'ALL'
  
  const UserListWidget({Key? key, required this.userType}) : super(key: key);
  
  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BaseUser>>(
      future: _getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users found');
        }
        
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            BaseUser user = snapshot.data![index];
            return ListTile(
              title: Text(UserManager.getUserDisplayName(user)),
              subtitle: Text('${user.userType} - ${UserManager.getUserPhoneNumber(user)}'),
              trailing: Icon(_getUserIcon(user.userType)),
            );
          },
        );
      },
    );
  }
  
  Future<List<BaseUser>> _getUsers() {
    switch (widget.userType) {
      case 'ADMIN':
        return UserManager.getAllAdmins().then((list) => list.cast<BaseUser>());
      case 'MZEE':
        return UserManager.getAllMzee().then((list) => list.cast<BaseUser>());
      case 'KATIBU':
        return UserManager.getAllKatibu().then((list) => list.cast<BaseUser>());
      case 'MSHARIKA':
        return UserManager.getAllMsharika().then((list) => list.cast<BaseUser>());
      default:
        return UserManager.getAllUsers();
    }
  }
  
  IconData _getUserIcon(String userType) {
    switch (userType) {
      case 'ADMIN':
        return Icons.admin_panel_settings;
      case 'MZEE':
        return Icons.elderly;
      case 'KATIBU':
        return Icons.edit_note;
      case 'MSHARIKA':
        return Icons.person;
      default:
        return Icons.person;
    }
  }
}
```

## 🔧 **Complete User Management Screen**

A complete user management screen has been created at:
`lib/admin/user_management_screen.dart`

To use it in your app:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const UserManagementScreen()),
);
```

## 🚨 **Error Handling**

Always wrap UserManager calls in try-catch blocks:

```dart
try {
  List<BaseUser> users = await UserManager.getAllUsers();
  // Handle success
} catch (e) {
  print("Error fetching users: $e");
  // Handle error - show snackbar, retry button, etc.
}
```

## 📋 **Backend API Response Format**

Your API should return JSON in this format:

### Single User Response
```json
{
  "id": 1,
  "full_name": "John Doe",
  "email": "john@example.com",
  "phonenumber": "+255123456789",
  "member_no": "KKKT001",
  "kanisa_id": "1",
  "kanisa_name": "KKKT Miyuji",
  "user_type": "ADMIN"
}
```

### Multiple Users Response
```json
[
  {
    "id": 1,
    "full_name": "John Doe",
    "user_type": "ADMIN",
    ...
  },
  {
    "id": 2,
    "jina": "Mary Smith",
    "user_type": "MZEE",
    ...
  }
]
```

### Statistics Response
```json
{
  "total_users": 150,
  "admins": 5,
  "mzee": 20,
  "katibu": 25,
  "msharika": 100
}
```

This user management system provides comprehensive functionality for handling different user roles in your church management app.
