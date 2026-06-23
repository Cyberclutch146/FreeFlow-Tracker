import '../../core/constants/app_constants.dart';

class AutoCategorizer {
  static Category categorize(String? merchantName) {
    if (merchantName == null || merchantName.isEmpty) {
      return Category.uncategorized;
    }

    final name = merchantName.toLowerCase();

    // Food
    if (name.contains('swiggy') || 
        name.contains('zomato') || 
        name.contains('dominos') || 
        name.contains('mcd') || 
        name.contains('restaurant') || 
        name.contains('cafe')) {
      return Category.food;
    }

    // Transport
    if (name.contains('uber') || 
        name.contains('ola') || 
        name.contains('rapido') || 
        name.contains('irctc') || 
        name.contains('metro') || 
        name.contains('petrol')) {
      return Category.transport;
    }

    // Personal
    if (name.contains('amazon') || 
        name.contains('flipkart') || 
        name.contains('myntra') || 
        name.contains('ajio') ||
        name.contains('blinkit') ||
        name.contains('zepto') ||
        name.contains('instamart')) {
      return Category.personal;
    }

    // Subscriptions
    if (name.contains('netflix') || 
        name.contains('spotify') || 
        name.contains('youtube') || 
        name.contains('hotstar') || 
        name.contains('prime')) {
      return Category.subscriptions;
    }

    // Academic
    if (name.contains('udemy') || 
        name.contains('coursera') || 
        name.contains('books') || 
        name.contains('college')) {
      return Category.academic;
    }

    // Tech Tools
    if (name.contains('github') || 
        name.contains('figma') || 
        name.contains('notion') || 
        name.contains('aws') || 
        name.contains('vercel') || 
        name.contains('google cloud')) {
      return Category.techTools;
    }

    return Category.uncategorized;
  }
}
