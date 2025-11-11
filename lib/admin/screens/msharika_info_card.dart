import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/msharika_model.dart';
import 'package:kanisaapp/utils/my_colors.dart';

class MsharikaInfoCard extends StatelessWidget {
  final MsharikaData msharika;
  const MsharikaInfoCard({super.key, required this.msharika});

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildInfo(String name, String date, String relation) {
    if (name.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (date.isNotEmpty)
              Text(
                'Tarehe: $date',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            if (relation.isNotEmpty)
              Text(
                'Uhusiano: $relation',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: MyColors.primaryLight, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: MyColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Taarifa Binafsi', Icons.person),
            _buildDetailRow('Jinsia', msharika.jinsia),
            _buildDetailRow('Umri', msharika.umri),
            _buildDetailRow('Hali ya Ndoa', msharika.haliYaNdoa),
            if (msharika.jinaLaMwenziWako.isNotEmpty)
              _buildDetailRow('Mwenzi', msharika.jinaLaMwenziWako),
            _buildDetailRow('Aina ya Ndoa', msharika.ainaNdoa),
            _buildSectionTitle('Watoto', Icons.child_care),
            if (msharika.jinaMtoto1.isNotEmpty)
              _buildChildInfo(
                msharika.jinaMtoto1,
                msharika.tareheMtoto1,
                msharika.uhusianoMtoto1,
              ),
            if (msharika.jinaMtoto2.isNotEmpty)
              _buildChildInfo(
                msharika.jinaMtoto2,
                msharika.tareheMtoto2,
                msharika.uhusianoMtoto2,
              ),
            if (msharika.jinaMtoto3.isNotEmpty)
              _buildChildInfo(
                msharika.jinaMtoto3,
                msharika.tareheMtoto3,
                msharika.uhusianoMtoto3,
              ),
            _buildSectionTitle('Mawasiliano na Kazi', Icons.work),
            _buildDetailRow('Namba ya Simu', msharika.nambaYaSimu),
            _buildDetailRow('Kazi', msharika.kazi),
            _buildDetailRow('Elimu', msharika.elimu),
            _buildDetailRow('Ujuzi', msharika.ujuzi),
            _buildDetailRow('Mahali pa Kazi', msharika.mahaliPakazi),
            _buildSectionTitle('Taarifa za Kanisa', Icons.church),
            _buildDetailRow('Jengo', msharika.jengo),
            _buildDetailRow('Ahadi', msharika.ahadi),
            _buildDetailRow('Jumuiya Ushiriki', msharika.jumuiyaUshiriki),
            _buildDetailRow(
                'Katibu Status',
                msharika.katibuStatus == 'yes'
                    ? 'Amekubaliwa'
                    : msharika.katibuStatus == 'null'
                        ? 'Anasubiri'
                        : 'Haijakubaliwa'),
            _buildDetailRow(
                'Mzee Status',
                msharika.mzeeStatus == 'yes'
                    ? 'Amekubaliwa'
                    : msharika.mzeeStatus == 'null'
                        ? 'Anasubiri'
                        : 'Haijakubaliwa'),
            _buildDetailRow(
                'Usharika Status',
                msharika.usharikaStatus == 'yes'
                    ? 'Amekubaliwa'
                    : msharika.usharikaStatus == 'null'
                        ? 'Anasubiri'
                        : 'Haijakubaliwa'),
            _buildDetailRow('Tarehe ya Usajili', msharika.tarehe),
          ],
        ),
      ),
    );
  }
}
