class Score {
  final String title;
  final int value; // on 100
  final int userId;

  Score({required this.title, required this.value, required this.userId});

  static Score fromJson(Map<String, dynamic> json) {
    return Score(userId: json["userId"], title: json["title"], value: json["score"]);
  }
}
