class AIRouterService {
  static String routeQuery(String query) {
    if (query.toLowerCase().contains('code') || query.toLowerCase().contains('flutter')) {
      return 'chatgpt';
    } else {
      return 'gemini';
    }
  }
}