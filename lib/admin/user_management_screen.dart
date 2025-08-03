import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<BaseUser> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchUsers(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      List<BaseUser> results = await UserManager.searchUsersByName(searchTerm);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Usimamizi wa Watumiaji',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyColors.primaryLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Wote'),
            Tab(text: 'Admin'),
            Tab(text: 'Mzee'),
            Tab(text: 'Katibu'),
            Tab(text: 'Msharika'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _searchUsers,
                  decoration: InputDecoration(
                    hintText: 'Tafuta kwa jina...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchUsers('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: MyColors.primaryLight),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSearchResults(),
                ],
              ],
            ),
          ),
          // User Statistics
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FutureBuilder<Map<String, int>>(
              future: UserManager.getUserStatistics(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildStatisticsRow(snapshot.data!);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersList(UserManager.getAllUsers()),
                _buildUsersList(UserManager.getAllAdmins()),
                _buildUsersList(UserManager.getAllMzee()),
                _buildUsersList(UserManager.getAllKatibu()),
                _buildUsersList(UserManager.getAllMsharika()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Container(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(color: MyColors.primaryLight),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            'Hakuna matokeo',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return _buildUserCard(_searchResults[index]);
        },
      ),
    );
  }

  Widget _buildStatisticsRow(Map<String, int> stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('Jumla', stats['total_users']!, Colors.blue),
        _buildStatCard('Admin', stats['admins']!, Colors.red),
        _buildStatCard('Mzee', stats['mzee']!, Colors.orange),
        _buildStatCard('Katibu', stats['katibu']!, Colors.green),
        _buildStatCard('Msharika', stats['msharika']!, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersList(Future<List<BaseUser>> futureUsers) {
    return FutureBuilder<List<BaseUser>>(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/fetching.json',
                  height: 120,
                ),
                Text(
                  'Inapakia watumiaji...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: MyColors.primaryLight,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hitilafu imetokea',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400,
                  ),
                ),
                Text(
                  snapshot.error.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/nodata.json',
                  height: 120,
                ),
                Text(
                  'Hakuna watumiaji',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildUserCard(snapshot.data![index]);
          },
        );
      },
    );
  }

  Widget _buildUserCard(BaseUser user) {
    Color userTypeColor = _getUserTypeColor(user.userType);
    IconData userTypeIcon = _getUserTypeIcon(user.userType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: userTypeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            userTypeIcon,
            color: userTypeColor,
            size: 24,
          ),
        ),
        title: Text(
          UserManager.getUserDisplayName(user),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: userTypeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.userType,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No: ${user.memberNo}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              UserManager.getUserPhoneNumber(user),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              user.kanisaName,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                _showUserDetails(user);
                break;
              case 'edit':
                _editUser(user);
                break;
              case 'delete':
                _deleteUser(user);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 18),
                  SizedBox(width: 8),
                  Text('Tazama'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Hariri'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Futa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserTypeColor(String userType) {
    switch (userType) {
      case 'ADMIN':
        return Colors.red.shade600;
      case 'MZEE':
        return Colors.orange.shade600;
      case 'KATIBU':
        return Colors.green.shade600;
      case 'MSHARIKA':
        return Colors.blue.shade600;
      default:
        return MyColors.primaryLight;
    }
  }

  IconData _getUserTypeIcon(String userType) {
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

  void _showUserDetails(BaseUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Taarifa za ${UserManager.getUserDisplayName(user)}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Jina', UserManager.getUserDisplayName(user)),
              _buildDetailRow('Aina ya Mtumiaji', user.userType),
              _buildDetailRow('Namba ya Ahadi', user.memberNo),
              _buildDetailRow('Simu', UserManager.getUserPhoneNumber(user)),
              _buildDetailRow('Kanisa', user.kanisaName),
              if (user is MsharikaUser) ...[
                _buildDetailRow('Jinsia', user.jinsia),
                _buildDetailRow('Umri', user.umri),
                _buildDetailRow('Hali ya Ndoa', user.haliYaNdoa),
                _buildDetailRow('Jumuiya', user.jinaLaJumuiya),
              ],
              if (user is MzeeUser) ...[
                _buildDetailRow('Eneo', user.eneo),
                _buildDetailRow('Jumuiya', user.jumuiya),
              ],
              if (user is KatibuUser) ...[
                _buildDetailRow('Jumuiya', user.jumuiya),
              ],
              if (user is AdminUser) ...[
                _buildDetailRow('Barua pepe', user.email),
                _buildDetailRow('Kiwango', user.level),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Funga',
              style: GoogleFonts.poppins(
                color: MyColors.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editUser(BaseUser user) {
    // TODO: Implement edit user functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hariri ${UserManager.getUserDisplayName(user)}'),
        backgroundColor: MyColors.primaryLight,
      ),
    );
  }

  void _deleteUser(BaseUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Futa Mtumiaji',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Una uhakika unataka kumfuta ${UserManager.getUserDisplayName(user)}?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hapana',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete user functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mtumiaji amefutwa'),
                  backgroundColor: Colors.red.shade600,
                ),
              );
            },
            child: Text(
              'Ndiyo',
              style: GoogleFonts.poppins(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
