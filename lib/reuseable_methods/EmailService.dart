import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:bookred/All_API_List/API_constants.dart'; // You can keep your constants here if needed

class EmailService {
  final String senderEmail = 'email_address@gmail.com'; // Your Gmail address
  final String appPassword = ApiConstants.password  ;    // Replace with your App Password from Google

  // Generate a 6-digit verification code
  String generateVerificationCode() {
    return (Random().nextInt(900000) + 100000).toString();
  }

  // Send email using Gmail SMTP and App Password
  Future<bool> sendEmail(String recipientEmail, String code) async {
    final smtpServer = gmail(senderEmail, appPassword);

    final message = Message()
      ..from = Address(senderEmail, 'BookRed') // Sender info
      ..recipients.add(recipientEmail)         // Who you're sending to
      ..subject = 'Your Verification Code'
      ..text = 'Your 6-digit verification code is: $code';

    try {
      final sendReport = await send(message, smtpServer);

      debugPrint('✅ Email sent successfully to $recipientEmail!');
      debugPrint('Send report: $sendReport');

      return true;
    } on MailerException catch (e) {
      debugPrint('❌ Failed to send email: $e');

      // Optional: Print out detailed problems for debugging
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }

      return false;
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return false;
    }
  }
}
