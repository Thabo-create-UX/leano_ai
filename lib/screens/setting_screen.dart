import 'package:flutter/material.dart';
import 'package:leano_app/main.dart';
import '../services/history_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // We'll implement theme toggle
  bool translateMode = false;
  bool insightsMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text("Clear History"),
            leading: Icon(Icons.delete),
            onTap: () async {
              await HistoryService.clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("History cleared")),
              );
            },
          ),
          SwitchListTile(
  title: Text("Dark Mode"),
  value: isDarkMode,
  onChanged: (val) {
    setState(() => isDarkMode = val);
    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
  },
),
          SwitchListTile(
            title: Text("Translate Mode"),
            value: translateMode,
            onChanged: (val) {
              setState(() => translateMode = val);
              // TODO: integrate translation logic
            },
          ),
          SwitchListTile(
            title: Text("Insights Mode"),
            value: insightsMode,
            onChanged: (val) {
              setState(() => insightsMode = val);
              // TODO: integrate insights logic
            },
          ),
        ],
      ),
    );
  }
}