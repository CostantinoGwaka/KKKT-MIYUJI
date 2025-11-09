// Example usage of the new user system

// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/user_manager.dart';

class UserProfileExample extends StatefulWidget {
  @override
  _UserProfileExampleState createState() => _UserProfileExampleState();
}

class _UserProfileExampleState extends State<UserProfileExample> {
  BaseUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: currentUser == null
            ? Center(child: Text('No user logged in'))
            : _buildUserProfile(),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Type: ${currentUser!.userType}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Name: ${UserManager.getUserDisplayName(currentUser)}'),
        Text('Phone: ${UserManager.getUserPhoneNumber(currentUser)}'),
        Text('Member No: ${currentUser!.memberNo}'),
        Text('Church: ${currentUser!.kanisaName}'),
        SizedBox(height: 16),

        // User type specific information
        if (UserManager.isAdmin(currentUser))
          _buildAdminInfo(currentUser as BaseUser)
        else if (UserManager.isMzee(currentUser))
          _buildMzeeInfo(currentUser as BaseUser)
        else if (UserManager.isKatibu(currentUser))
          _buildKatibuInfo(currentUser as BaseUser)
        else if (UserManager.isMsharika(currentUser))
          _buildMsharikaInfo(currentUser as BaseUser),
      ],
    );
  }

  Widget _buildAdminInfo(BaseUser admin) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Email: ${admin.email}'),
            Text('Level: ${admin.level}'),
            // ignore: unrelated_type_equality_checks
            Text('Status: ${admin.status == 0 ? "Active" : "Inactive"}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMzeeInfo(BaseUser mzee) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mzee Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Eneo: ${mzee.eneo}'),
            Text('Jumuiya: ${mzee.jumuiya}'),
            Text('Mwaka: ${mzee.mwaka}'),
            Text('Status: ${mzee.status}'),
          ],
        ),
      ),
    );
  }

  Widget _buildKatibuInfo(BaseUser katibu) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Katibu Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Jumuiya: ${katibu.jumuiya}'),
            Text('Mwaka: ${katibu.mwaka}'),
            Text('Status: ${katibu.status}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMsharikaInfo(BaseUser msharika) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Msharika Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Jinsia: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].jinsia : ''}'),
            Text(
                'Umri: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].umri : ''}'),
            Text(
                'Hali ya Ndoa: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].haliYaNdoa : ''}'),
            Text(
                'Jumuiya: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].jinaLaJumuiya : ''}'),
            Text(
                'Kazi: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].kazi : ''}'),
            Text(
                'Ahadi: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].ahadi : ''}'),
          ],
        ),
      ),
    );
  }
}
