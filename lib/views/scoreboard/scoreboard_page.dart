import 'dart:async';
import 'dart:convert';
import 'package:live_activities/live_activities.dart';
import 'package:cricket_dynamic_island_app/models/team_response.dart';
import 'package:cricket_dynamic_island_app/views/scoreboard/widgets/scoreboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    String activityId = inputData!["activityId"];
    final _liveActivitiesPlugin = LiveActivities();
    get(Uri.parse("https://prod-public-api.livescore.com/v1/api/app/date/soccer/20230922/5.30?countryCode=IN&locale=en&MD=1")).then((response) async {
      final teamResponse = TeamResponse.fromJson(jsonDecode(response.body)['Stages'][0]);
      _liveActivitiesPlugin.updateActivity(activityId, teamResponse.toJson());
    });
    return Future.value(true);
  });
}


class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  TeamResponse? teamResponse;
  final _liveActivitiesPlugin = LiveActivities();
  late Timer timer;
  String? activityId;

  @override
  void initState() {
    _liveActivitiesPlugin.init(appGroupId: "group.scoreboard");
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      get(Uri.parse("https://prod-public-api.livescore.com/v1/api/app/date/soccer/20230922/5.30?countryCode=IN&locale=en&MD=1")).then((response) async {
        teamResponse = TeamResponse.fromJson(jsonDecode(response.body)['Stages'][0]);
        if(activityId == null) {
          activityId = await _liveActivitiesPlugin.createActivity(teamResponse!.toJson());
          print(activityId);
        } else {
          _liveActivitiesPlugin.updateActivity(activityId!, teamResponse!.toJson());
        }
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade400,
      body: Center(
        child: teamResponse == null
            ? const CircularProgressIndicator()
            : ScoreboardWidget(teamResponse: teamResponse!),
      ),
    );
  }
}
