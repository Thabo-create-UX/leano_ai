import 'dart:convert';

class HistoryItem {
  final String question;
  final String answer;
  final DateTime timestamp;

  HistoryItem({
    required this.question,
    required this.answer,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        question: json['question'],
        answer: json['answer'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  static List<HistoryItem> listFromJson(String jsonStr) {
    final data = json.decode(jsonStr) as List;
    return data.map((e) => HistoryItem.fromJson(e)).toList();
  }

  static String listToJson(List<HistoryItem> list) {
    return json.encode(list.map((e) => e.toJson()).toList());
  }
}