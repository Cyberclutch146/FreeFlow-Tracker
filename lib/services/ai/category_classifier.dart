import '../../core/constants/app_constants.dart';

/// A pure-Dart keyword dictionary that categorizes merchants offline.
/// No API key, no network, instant results.
class CategoryClassifier {
  static const Map<Category, List<String>> _keywords = {
    Category.food: [
      // Food delivery
      'swiggy', 'zomato', 'dunzo', 'blinkit', 'zepto', 'bigbasket',
      'grofers', 'instamart', 'jiomart', 'milkbasket',
      // Restaurants & cafes
      'restaurant', 'cafe', 'coffee', 'chai', 'dhaba', 'canteen',
      'starbucks', 'mcdonalds', 'mcdonald', 'dominos', 'domino',
      'pizza', 'burger', 'subway', 'kfc', 'burger king', 'pizzahut',
      'haldiram', 'bikanervala', 'wow momo', 'behrouz', 'box8',
      'freshmenu', 'inner chef', 'rebel foods', 'faasos',
      // Generic food
      'grocery', 'vegetable', 'fruit', 'milk', 'bakery', 'sweet shop',
      'meat', 'fish', 'eggs', 'dal', 'rice', 'flour', 'snack',
      'juice', 'tea', 'food', 'eat', 'lunch', 'dinner', 'breakfast',
      'tiffin', 'mess', 'hotel',
    ],
    Category.transport: [
      // Ride-hailing
      'uber', 'ola', 'rapido', 'meru', 'blu smart', 'blusmart',
      'jugnoo', 'savaari', 'quick ride',
      // Public transport
      'metro', 'bus', 'auto', 'rickshaw', 'local train', 'irctc',
      'railways', 'apsrtc', 'ksrtc', 'gsrtc', 'bmtc', 'dtc',
      // Air travel
      'indigo', 'air india', 'spicejet', 'vistara', 'akasa',
      'goair', 'flight', 'airline', 'airport',
      // Fuel & vehicle
      'petrol', 'diesel', 'fuel', 'cng', 'ev charging', 'servo',
      'bpcl', 'hpcl', 'iocl', 'reliance petrol',
      // Parking & tolls
      'parking', 'fastag', 'toll', 'highway',
      // Travel booking
      'makemytrip', 'goibibo', 'yatra', 'cleartrip', 'ixigo',
      'redbus', 'abhibus', 'ticket',
    ],
    Category.subscriptions: [
      // Video streaming
      'netflix', 'hotstar', 'disney', 'prime video', 'amazon prime',
      'zee5', 'sonyliv', 'jiocinema', 'mxplayer', 'voot',
      'apple tv', 'youtube premium', 'crunchyroll',
      // Music
      'spotify', 'gaana', 'jiosaavn', 'wynk', 'amazon music',
      'apple music', 'resso',
      // Cloud storage
      'icloud', 'google one', 'dropbox', 'onedrive',
      // Software subscriptions
      'adobe', 'canva', 'figma', 'notion', 'slack', 'zoom',
      'microsoft 365', 'office 365', 'google workspace',
      'chatgpt', 'openai', 'grammarly', 'loom',
      // Productivity & SaaS
      'todoist', 'trello', 'asana', 'monday', 'linear', 'jira',
      'xero', 'freshbooks', 'quickbooks', 'zoho',
      // Generic
      'subscription', 'membership', 'renewal', 'plan', 'premium',
    ],
    Category.techTools: [
      // Dev tools & hosting
      'github', 'gitlab', 'bitbucket', 'aws', 'amazon web services',
      'google cloud', 'gcp', 'azure', 'digitalocean', 'linode',
      'vultr', 'heroku', 'vercel', 'netlify', 'cloudflare',
      'fastly', 'render', 'railway', 'fly.io',
      // Domains & SSL
      'godaddy', 'namecheap', 'bigrock', 'hostinger', 'bluehost',
      'domain', 'hosting', 'ssl',
      // Dev environments & tools
      'jetbrains', 'cursor', 'copilot', 'postman', 'insomnia',
      'datadog', 'sentry', 'logrocket', 'amplitude', 'mixpanel',
      'segment', 'twilio', 'sendgrid', 'mailchimp',
      // Hardware
      'laptop', 'computer', 'keyboard', 'mouse', 'monitor',
      'hard drive', 'ssd', 'ram', 'router', 'webcam',
    ],
    Category.academic: [
      // Ed-tech platforms
      'udemy', 'coursera', 'unacademy', 'byju', 'vedantu',
      'physicswallah', 'pw app', 'toppr', 'testbook', 'adda247',
      'edureka', 'simplilearn', 'pluralsight', 'linkedin learning',
      'skillshare', 'masterclass', 'khan academy',
      // Educational materials
      'book', 'textbook', 'notebook', 'stationery', 'pen', 'pencil',
      'library', 'xerox', 'photocopy', 'printing',
      // Coaching & tuitions
      'tuition', 'coaching', 'institute', 'class', 'course',
      'exam', 'test series', 'mock test',
      // College fees
      'college', 'university', 'school', 'hostel', 'admission',
      'fee', 'semester',
    ],
    Category.entertainment: [
      // Cinemas
      'pvr', 'inox', 'cinepolis', 'bookmyshow', 'paytm movies',
      'movie', 'cinema', 'theatre',
      // Gaming
      'steam', 'epic games', 'playstation', 'xbox', 'nintendo',
      'google play games', 'pubg', 'valorant', 'gaming',
      // Events & experiences
      'concert', 'event', 'ticket', 'carnival', 'amusement',
      'museum', 'zoo', 'aquarium', 'resort', 'adventure',
      // Shopping (leisure)
      'amazon', 'flipkart', 'myntra', 'nykaa', 'meesho', 'ajio',
      'snapdeal', 'shopify', 'etsy', 'shopping',
      // Sports & fitness
      'gym', 'fitness', 'yoga', 'zumba', 'sports', 'cricket',
      'football', 'badminton', 'swimming',
    ],
    Category.personal: [
      // Health & pharmacy
      'pharmacy', 'chemist', 'medical', 'medicine', 'doctor',
      'hospital', 'clinic', 'apollo', 'fortis', 'medanta',
      'practo', 'cult fit', 'healthkart', '1mg',
      // Beauty & grooming
      'salon', 'barber', 'spa', 'beauty', 'parlour', 'makeup',
      'nykaa', 'myntra beauty', 'mamaearth', 'wow',
      // Clothing
      'clothing', 'clothes', 'apparel', 'fashion', 'shirt', 'jeans',
      'shoes', 'footwear', 'bag', 'accessories',
      // Utilities
      'electricity', 'water bill', 'gas bill', 'internet', 'broadband',
      'wifi', 'jio', 'airtel', 'bsnl', 'vodafone', 'vi',
      'mobile recharge', 'recharge', 'dth', 'tataplay', 'dish tv',
      // Home
      'rent', 'maintenance', 'society', 'furniture', 'home decor',
      'appliance', 'repair', 'plumber', 'electrician',
      // Finance
      'insurance', 'emi', 'loan', 'investment', 'mutual fund',
      'sip', 'zerodha', 'groww', 'upstox', 'coin', 'kuvera',
    ],
    Category.income: [
      'salary', 'freelance', 'payment', 'invoice', 'client',
      'project payment', 'consulting', 'commission', 'bonus',
      'refund', 'cashback', 'reward', 'interest', 'dividend',
      'received', 'credited', 'transfer in', 'income',
    ],
  };

  /// Categorize a single merchant name. Returns [Category.uncategorized] if no match.
  static Category classify(String merchantName) {
    final lower = merchantName.toLowerCase().trim();
    
    Category? bestMatch;
    int bestMatchLength = 0;

    for (final entry in _keywords.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword) && keyword.length > bestMatchLength) {
          bestMatch = entry.key;
          bestMatchLength = keyword.length;
        }
      }
    }

    return bestMatch ?? Category.uncategorized;
  }

  /// Batch categorize a list of merchant names. Returns a map of name → category name.
  static Map<String, String> batchClassify(List<String> merchantNames) {
    final results = <String, String>{};
    for (final name in merchantNames) {
      final category = classify(name);
      if (category != Category.uncategorized) {
        results[name] = category.name;
      }
    }
    return results;
  }
}
