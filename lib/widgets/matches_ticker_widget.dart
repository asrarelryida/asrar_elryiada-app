import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesTickerWidget extends StatelessWidget {
  const MatchesTickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 75,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('matches').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 2),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد مباريات مضافة حالياً',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: _buildMatchCard(
                      tournament: data['league'] ?? 'بطولة',
                      team1: data['teamA'] ?? 'الفريق الأول',
                      team2: data['teamB'] ?? 'الفريق الثاني',
                      score1: data['scoreA'] ?? '0',
                      score2: data['scoreB'] ?? '0',
                      status: data['status'] ?? 'قريباً',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard({
    required String tournament,
    required String team1,
    required String team2,
    required String score1,
    required String score2,
    required String status,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tournament,
            style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  team1,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$score1 - $score2',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  team2,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}