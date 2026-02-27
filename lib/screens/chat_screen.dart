import 'package:flutter/material.dart';
import 'package:leano_app/screens/setting_screen.dart';
import '../widgets/message_bubble.dart';
import '../services/history_service.dart';
import '../services/ai_router_service.dart';
import '../services/voice_service.dart';
import '../models/history_model.dart';
import 'package:image_picker/image_picker.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<HistoryItem> messages = [];
  final TextEditingController _controller = TextEditingController();
  final VoiceService _voiceService = VoiceService();
  final ImagePicker _picker = ImagePicker();

  // Core toggles
  bool translateMode = false;
  bool insightsMode = false;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Load history from SharedPreferences
  void _loadHistory() async {
    messages = await HistoryService.loadHistory();
    setState(() {});
  }

  // Send message and get AI reply (placeholder)
  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    String ai = AIRouterService.routeQuery(text); // chatgpt or gemini
    String answer = "This is a placeholder reply from $ai";

    // Apply Translate Mode
    if (translateMode) answer = "[Translated] $answer";

    // Apply Insights Mode
    if (insightsMode) answer = "[Insight] $answer";

    await HistoryService.addHistory(text, answer);

    messages = await HistoryService.loadHistory();
    setState(() {});

    // Speak AI answer
    _voiceService.speak(answer);

    _controller.clear();
  }

  // Pick image and simulate vision analysis
  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String analysis = "This image looks amazing!";
      _sendMessage("[Image: ${image.name}] $analysis");
    }
  }

  // Voice input
  void _voiceInput() async {
    bool available = await _voiceService.initSpeech();
    if (available) {
      String text = await _voiceService.listen();
      _sendMessage(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leano Chat"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final msg = messages[messages.length - 1 - i];
                return MessageBubble(
                  message: "${msg.question}\n${msg.answer}",
                  isUser: true,
                );
              },
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.mic), onPressed: _voiceInput),
              IconButton(icon: Icon(Icons.image), onPressed: _pickImage),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Type your question..."),
                  onSubmitted: _sendMessage,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text)),
            ],
          ),
        ],
      ),
    );
  }
}