import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/transaction.dart';
import '../sms/sms_parser.dart';
import '../../core/constants/app_constants.dart';

class LlmParserService {
  /// Attempts to parse an SMS message using the Gemini API.
  /// Returns a [ParsedSms] if successful, or null if it fails or isn't a valid transaction.
  static Future<ParsedSms?> parseMessage(String sender, String body, String apiKey) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.1,
        ),
      );

      final prompt = '''
You are a financial transaction parser. Extract the transaction details from the following SMS message.
The message might be a standard bank transaction or a UPI mandate creation/cancellation.

Rules:
1. "amount": The amount of money involved as a number (e.g., 199.0). Use 0 if not specified.
2. "direction": "credit" if money was received/added. "debit" if money was spent, sent, or if it's a mandate creation/cancellation (since it's an outbound payment setup).
3. "merchantName": The name of the merchant or person the money was sent to or received from.
4. "upiRefId": The UPI reference ID or UMN if present.
5. "isCardTransaction": true if the SMS mentions "card", "credit card", "debit card", etc., false otherwise.

If the SMS is completely unrelated to finance (e.g., a promotional message or personal text), return {"isValidTransaction": false}.

Respond strictly in JSON format matching this schema:
{
  "isValidTransaction": true/false,
  "amount": number,
  "direction": "credit" | "debit",
  "merchantName": "string or null",
  "upiRefId": "string or null",
  "isCardTransaction": boolean
}

SMS Sender: $sender
SMS Body: $body
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;
      if (text == null) return null;

      final json = jsonDecode(text);
      if (json['isValidTransaction'] != true) return null;

      final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
      if (amount <= 0) return null;

      final directionStr = json['direction'] as String?;
      final direction = directionStr == 'credit' ? TransactionDirection.credit : TransactionDirection.debit;

      return ParsedSms(
        amount: amount,
        direction: direction,
        merchantName: json['merchantName'] as String?,
        upiRefId: json['upiRefId'] as String?,
        bankSource: sender, // We'll just use sender as bankSource for fallback
        confidence: Confidence.high,
        isCardTransaction: json['isCardTransaction'] == true,
      );
    } catch (e) {
      print('LlmParserService error: $e');
      return null;
    }
  }

  /// Attempts to parse a batch of SMS messages using the Gemini API to avoid rate limits.
  static Future<List<ParsedSms?>> parseBatch(List<Map<String, String>> messages, String apiKey) async {
    if (messages.isEmpty) return [];
    
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.1,
        ),
      );

      final messagesJson = jsonEncode(messages.map((m) => {
        "id": m["id"],
        "sender": m["sender"],
        "body": m["body"]
      }).toList());

      final prompt = '''
You are a financial transaction parser. I will provide a JSON array of SMS messages.
Extract the transaction details for each message.
Some messages might be a standard bank transaction or a UPI mandate creation/cancellation.

Rules:
1. "amount": The amount of money involved as a number (e.g., 199.0). Use 0 if not specified.
2. "direction": "credit" if money was received/added. "debit" if money was spent, sent, or if it's a mandate creation/cancellation (since it's an outbound payment setup).
3. "merchantName": The name of the merchant or person the money was sent to or received from.
4. "upiRefId": The UPI reference ID or UMN if present.
5. "isCardTransaction": true if the SMS mentions "card", "credit card", "debit card", etc., false otherwise.

If an SMS is completely unrelated to finance, set "isValidTransaction": false for that item.

Respond strictly with a JSON array where each item matches this schema:
{
  "id": "the exact id from the input",
  "isValidTransaction": true/false,
  "amount": number,
  "direction": "credit" | "debit",
  "merchantName": "string or null",
  "upiRefId": "string or null",
  "isCardTransaction": boolean
}

Input messages:
$messagesJson
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;
      if (text == null) return List.filled(messages.length, null);

      final List<dynamic> jsonList = jsonDecode(text);
      final Map<String, ParsedSms?> resultsMap = {};

      for (var json in jsonList) {
        final id = json['id'] as String?;
        if (id == null) continue;
        
        if (json['isValidTransaction'] != true) {
           resultsMap[id] = null;
           continue;
        }

        final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
        if (amount <= 0) {
           resultsMap[id] = null;
           continue;
        }

        final directionStr = json['direction'] as String?;
        final direction = directionStr == 'credit' ? TransactionDirection.credit : TransactionDirection.debit;

        final sender = messages.firstWhere((m) => m['id'] == id, orElse: () => {'sender': 'Bank'})['sender']!;

        resultsMap[id] = ParsedSms(
          amount: amount,
          direction: direction,
          merchantName: json['merchantName'] as String?,
          upiRefId: json['upiRefId'] as String?,
          bankSource: sender,
          confidence: Confidence.high,
          isCardTransaction: json['isCardTransaction'] == true,
        );
      }

      return messages.map((m) => resultsMap[m['id']]).toList();
    } catch (e) {
      print('LlmParserService batch error: $e');
      return List.filled(messages.length, null);
    }
  }
}
