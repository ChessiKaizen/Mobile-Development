import 'package:flutter/material.dart';
 
import '../model/score.dart';
import '../data/repositories/scores_repository.dart';
import '../data/services/auth_service.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  List<Score>? scores;
  String? error;

  @override
  void initState() {
    super.initState();
 
    fetchSCores();
  }

  void fetchSCores() async {
    try {
      // Ask the ScoresRepository instance to fetch the scores 
      final fetchedScores = await ScoresRepository.instance.getSCores();
      
      // if succes, update the scores list and refresh
      setState(() {
        scores = fetchedScores;
        error = null;
      });
    } catch (e) {
      // If failure, update the error and refresh
      setState(() {
        error = e.toString();
      });
    }
  }

  String? get userName {
    // Ask the AuthenticationService instance the current user nale (if any)
    return AuthenticationService.instance.session?.user.name;
  }

  Widget get content {
    // if error, dispaly the erro in red, centered
    if (error != null) {
      return Center(
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    // If scores list => dispaly the list using the ScoreTile
    if (scores != null) {
      return ListView.builder(
        itemCount: scores!.length,
        itemBuilder: (context, index) {
          return ScoreTile(score: scores![index]);
        },
      );
    }

    // otherwise, we disaply the  CircularProgressIndicator 
    return const CircularProgressIndicator();
  }

  String get welcomeLabel => "Welcome ${userName != null ? userName! : ""} !";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(welcomeLabel)),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20.0), child: content),
      ),
    );
  }
}

class ScoreTile extends StatelessWidget {
  const ScoreTile({super.key, required this.score});

  final Score score;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(score.title),
        trailing: Text(score.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}
