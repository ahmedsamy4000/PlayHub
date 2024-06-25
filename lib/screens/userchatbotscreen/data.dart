import 'package:flutter/material.dart';
import 'package:ikchatbot/ikchatbot.dart';
import 'package:playhub/core/app_colors.dart';

class ChatbotData {
  IkChatBotConfig? chatbotConfig;
  ChatbotData() {
    chatbotConfig = IkChatBotConfig(
      useAsset: false,
      backgroundAssetimage: "assets/images/peakpx.jpg",
      ratingIconYes: const Icon(Icons.star),
      ratingIconNo: const Icon(Icons.star_border),
      ratingIconColor: Colors.black,
      ratingBackgroundColor: Colors.white,
      ratingButtonText: 'Submit Rating',
      thankyouText: 'Thanks for your rating!',
      ratingText: 'Rate your experience:',
      ratingTitle: 'Thank you for using the chatbot!',
      body: 'This is a test email sent from Flutter and Dart.',
      subject: 'Test Rating',
      recipient: 'recipient@example.com',
      isSecure: false,
      senderName: 'Your Name',
      smtpUsername: 'Your Email',
      smtpPassword: 'your password',
      smtpServer: 'stmp.gmail.com',
      smtpPort: 587,
      //Settings to your system Configurations
      sendIcon: const Icon(Icons.send, color: Colors.black),
      userIcon: const Icon(Icons.person, color: Colors.white),
      botIcon: const Icon(Icons.bubble_chart, color: Colors.white),
      botChatColor: const Color.fromARGB(255, 81, 80, 80),
      delayBot: 100,
      closingTime: 1,
      delayResponse: 1,
      userChatColor: AppColors.darkGreen,
      waitingTime: 1,
      keywords: keywords,
      responses: responses,
      backgroundColor: Colors.white,
      backgroundImage: 'https://cdn.wallpapersafari.com/54/0/HluF7g.jpg',
      initialGreeting:
          "👋 Hello! \nWelcome to IkBot\nHow can I assist you today?",
      defaultResponse: "Sorry, I didn't understand your response.",
      inactivityMessage: "Is there anything else you need help with?",
      closingMessage: "This conversation will now close.",
      inputHint: 'Send a message',
      waitingText: 'Please wait...',
    );
  }
}

final List<String> keywords = [
  'who are you',
  'what is flutter',
  'what is your name',
  'sorry'
];

final List<String> responses = [
  'I am a bot created by Iksoft Original, a proud Ghanaian',
  'Flutter transforms the app development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded apps from a single codebase.',
  'my name is Chatbot , iam here to help you',
  'Good! i have forgiven you. dont do that again!'
];
