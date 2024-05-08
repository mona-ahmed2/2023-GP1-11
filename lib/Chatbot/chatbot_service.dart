import 'package:ibm_watson_assistant/ibm_watson_assistant.dart';
import 'package:ibm_watson_assistant/models.dart';


class ChatbotService {
  late IbmWatsonAssistant bot;
  late String _sessionId;
  String get sessionId => _sessionId;

  ChatbotService() {
    final auth = IbmWatsonAssistantAuth(
      version: '2021-06-14', //4006e7f3-9ac5-4a92-ae6b-9622bb48532e
      assistantId: "b84cf70e-4299-4055-820a-33e7e6498809",

      url:
          "https://api.au-syd.assistant.watson.cloud.ibm.com/instances/339ffd31-1a97-4bed-b529-f24e4ba8ac3a",
      apikey: "jCg-PB4qj0un1OBCfv477FDywn-FvFKagTo6bMaiw6sp",
    );

    bot = IbmWatsonAssistant(auth);

    print('Initialized Chatbot Service');
  }

  Future<String> createSession() async {
    print('creating session');
    try {
      _sessionId = (await bot.createSession())!;
    } catch (e) {
      print('session error: $e');
      return e.toString();
    }
    print('created session: $_sessionId');
    return _sessionId;
  }

  Future<IbmWatsonAssistantResponse?> sendInput(String input) async {
    print('Sending chatbot input: $input');
    if (_sessionId == null) await createSession();
    try {
      return bot.sendInput(input, sessionId: _sessionId);
    } catch (e) {
      print('Error sending chatbot input: $input.\n$e');
      // return e;
    }
  }

  Future<void> deleteSession() async {
    await bot.deleteSession(_sessionId);
    _sessionId = "";
  }
}
