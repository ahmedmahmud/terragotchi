import 'package:flutter/material.dart';
import 'package:terragotchi/sharedPrefs.dart';
import 'colors.dart';
import 'home.dart';

class LeaderboardModel {
  final String name;
  final int score;

  LeaderboardModel({
    required this.name,
    required this.score,
  });

  factory LeaderboardModel.fromJson(Map json, bool isUser) {
    return LeaderboardModel(
        name: isUser ? "You" : json['reference_id'], score: json['score']);
  }
}

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({super.key});

  @override
  State<LeaderboardWidget> createState() => LeaderboardPage();
}

class LeaderboardPage extends State<LeaderboardWidget> {
  final _leaderboardScores = [
    LeaderboardModel(name: "Jon", score: 1),
    LeaderboardModel(name: "ALice", score: 15),
    LeaderboardModel(name: "Bob", score: 85),
    LeaderboardModel(name: "Jeremia", score: 69),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: const EdgeInsets.only(left: 20.0, top: 25.0),
          icon: const Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'leaderboard',
            style: TextStyle(
              fontFamily: 'Space Mono',
              fontSize: 28,
            ),
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 500,
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: 'Space Mono',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  child: DataTable(
                    dataTextStyle: TextStyle(
                      fontFamily: 'Space Mono',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Rank',
                          style: TextStyle(
                            fontFamily: 'Space Mono',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            fontFamily: 'Space Mono',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Score',
                          style: TextStyle(
                            fontFamily: 'Space Mono',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(_leaderboardScores.length, (index) {
                      final leaderboard = _leaderboardScores[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(
                            leaderboard.name,
                          )),
                          DataCell(Text(leaderboard.score.toString())),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
