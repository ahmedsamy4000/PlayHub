import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikchatbot/ikchatbot.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/screens/userchatbotscreen/data.dart';

class UserChatBotScreen extends StatefulWidget {
  const UserChatBotScreen({super.key});

  @override
  State<UserChatBotScreen> createState() => _UserChatBotScreenState();
}

class _UserChatBotScreenState extends State<UserChatBotScreen> {
  ChatbotData data = ChatbotData();
  @override
  Widget build(BuildContext context) {
    final IkChatBotConfig config = data.chatbotConfig!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chatbot",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkGreen,
      ),
      body: ikchatbot(config: config),
    );
  }
}
