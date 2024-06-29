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
  'how can i find a playground near me',
  'how do i book a playground',
  'how can i find and book a trainer',
  'how do i leave a review for a playground or trainer',
  'how do i update my profile information',
  'can i see a history of my bookings',
  'how do i know if a playground or trainer is available'
];

final List<String> responses = [
  'I am a Mobile application used to book playgrounds and search for experienced trainers that make it easy to book and play more than type of sports',
  'You can find nearby playgrounds by using the (Search For Playgrounds) feature on the main screen. Just enter your City  or Region and Filter your category, and we will show you all available playgrounds in your area',
  'First select the desired play ground and then the available time will be shown to you, you can press on the time and the order details will be ready on screen then you will be redirected to payment process then you will be able to see your book order on your profile',
  'You can find trainers by browsing the (Trainers) section. Select a trainer to view their profile and availability, then book a session that suits you',
  'First you can choose Feedback Section and write your Review about Trainer or playground then you will get the response in short time',
  'You can go to the Profile screen from the bottom navigation bar and select edite profile from the menu then you can easly update your profile informatoion',
  'First you will go to your profile page and the tab bar will be shown to you with all categories, you can select the desired category to see your book Order',
  'PlayHub automatically show the available playgrounds and trainers for you '
];
