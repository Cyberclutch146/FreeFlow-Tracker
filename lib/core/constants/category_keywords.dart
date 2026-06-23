class CategoryKeywords {
  static const Map<String, List<String>> kCategoryKeywords = {
    'food': ['zomato', 'swiggy', 'mcdonalds', 'kfc', 'dominos', 'eatbox', 'cafe', 'restaurant', 'dhaba', 'canteen', 'food', 'biryani', 'tea', 'coffee'],
    'transport': ['uber', 'ola', 'rapido', 'namma yatri', 'irctc', 'redbus', 'metro', 'petrol', 'fuel', 'hpcl', 'indianoil', 'bpcl', 'auto', 'rickshaw'],
    'academic': ['college', 'university', 'tuition', 'course', 'udemy', 'coursera', 'books', 'stationery', 'library', 'exam', 'fees', 'hostel'],
    'techTools': ['aws', 'digitalocean', 'github', 'domain', 'hosting', 'figma', 'adobe', 'jetbrains', 'chatgpt', 'openai', 'midjourney', 'vercel'],
    'subscriptions': ['netflix', 'amazon prime', 'hotstar', 'spotify', 'youtube premium', 'apple music', 'jio', 'airtel', 'vi', 'recharge', 'broadband', 'wifi'],
    'personal': ['amazon', 'flipkart', 'myntra', 'ajio', 'blinkit', 'zepto', 'instamart', 'pharmacy', 'apollo', 'medical', 'salon', 'haircut', 'gym'],
    'entertainment': ['bookmyshow', 'pvr', 'inox', 'gaming', 'steam', 'playstation', 'xbox', 'pub', 'club', 'event', 'concert'],
    'income': ['salary', 'freelance', 'fiverr', 'upwork', 'client', 'payment received', 'credited', 'tuition fee'],
  };

  static String? matchCategory(String text) {
    final lower = text.toLowerCase();
    for (final entry in kCategoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }

  static String getConfidence(String text, String category) {
    final lower = text.toLowerCase();
    final keywords = kCategoryKeywords[category] ?? [];
    int matchCount = 0;
    for (final keyword in keywords) {
      if (lower.contains(keyword)) {
        matchCount++;
      }
    }
    if (matchCount >= 2) return 'high';
    if (matchCount == 1) return 'medium';
    return 'low';
  }
}