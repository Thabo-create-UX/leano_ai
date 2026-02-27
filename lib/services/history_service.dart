import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_model.dart';

class HistoryService {
  static const String key = 'chat_history';

  // Load history
  static Future<List<HistoryItem>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(key);
    if (jsonStr == null) return [];
    List<HistoryItem> list = HistoryItem.listFromJson(jsonStr);
    
    // Auto-delete items older than 7 days
    final now = DateTime.now();
    list = list.where((item) => now.difference(item.timestamp).inDays <= 7).toList();
    await saveHistory(list);
    return list;
  }

  // Save history
  static Future<void> saveHistory(List<HistoryItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, HistoryItem.listToJson(list));
  }

  // Add new entry
  static Future<void> addHistory(String question, String answer) async {
    final list = await loadHistory();
    list.add(HistoryItem(question: question, answer: answer, timestamp: DateTime.now()));
    await saveHistory(list);
  }

  // Clear all history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}