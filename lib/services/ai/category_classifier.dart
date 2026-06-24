import '../../core/constants/app_constants.dart';

/// THE single-source-of-truth keyword categorizer.
///
/// Replaces the three previously competing implementations:
///   - `AutoCategorizer` (SMS pipeline, ~30 keywords, if/else)
///   - Old `CategoryClassifier` (AI engine, ~200 keywords)
///   - `CategoryKeywords` (core/constants, unused at runtime)
///
/// Uses a longest-match algorithm: among all keywords that match,
/// the longest one wins. This prevents short words like "plan" from
/// clobbering specific merchant names.
///
/// User corrections are stored in [_overrides] so the app learns from
/// manual re-categorizations and applies them to future SMS auto-parsing.
class CategoryClassifier {
  // ---------------------------------------------------------------------------
  // User correction overrides (merchant name → category)
  // Set via [learnFromCorrection], persisted by the caller.
  // ---------------------------------------------------------------------------
  static final Map<String, Category> _overrides = {};

  /// Record that the user manually assigned [merchantName] to [category].
  /// This overrides the keyword logic for that exact merchant going forward.
  static void learnFromCorrection(String merchantName, Category category) {
    _overrides[merchantName.toLowerCase().trim()] = category;
  }

  /// Clear all learned overrides (e.g. on data reset).
  static void clearOverrides() => _overrides.clear();

  // ---------------------------------------------------------------------------
  // Master keyword dictionary
  // ---------------------------------------------------------------------------
  static const Map<Category, List<String>> _keywords = {
    // ── FOOD & DINING ──────────────────────────────────────────────────────
    Category.food: [
      // Food delivery
      'swiggy', 'zomato', 'dunzo', 'blinkit', 'zepto', 'bigbasket',
      'grofers', 'instamart', 'jiomart', 'milkbasket', 'eatclub', 'freshmenu',
      'box8', 'faasos', 'behrouz', 'inner chef', 'rebel foods', 'wow momo',
      // Restaurants & chains
      'restaurant', 'cafe', 'coffee', 'chai', 'dhaba', 'canteen', 'eatery',
      'starbucks', 'mcdonald', 'mcdonalds', 'dominos', 'domino',
      'pizza', 'burger', 'subway', 'kfc', 'burger king', 'pizzahut',
      'haldiram', 'bikanervala', 'punjab grill', 'mainland china',
      'paradise biryani', 'biryani blues', 'biryani',
      // Groceries & supermarkets
      'grocery', 'vegetable', 'supermarket', 'dmart', 'reliance fresh',
      'more supermarket', 'spar', 'lulu hypermarket', 'nature basket',
      // Generic food items
      'milk', 'bakery', 'sweet shop', 'meat', 'fish', 'eggs', 'dal',
      'rice', 'flour', 'snack', 'juice', 'tea', 'food', 'eat',
      'lunch', 'dinner', 'breakfast', 'tiffin', 'mess', 'hotel',
      'fruit', 'vegetable', 'paneer', 'bread', 'spices', 'ration',
    ],

    // ── TRANSPORT ──────────────────────────────────────────────────────────
    Category.transport: [
      // Ride-hailing
      'uber', 'ola', 'rapido', 'meru', 'blusmart', 'blu smart',
      'jugnoo', 'savaari', 'quick ride', 'namma yatri', 'yatri',
      // Public transport
      'metro', 'local train', 'irctc', 'railways', 'indian railway',
      'apsrtc', 'ksrtc', 'gsrtc', 'bmtc', 'dtc', 'best bus', 'bus pass',
      'auto', 'rickshaw', 'e-rickshaw',
      // Air travel
      'indigo', 'air india', 'spicejet', 'vistara', 'akasa',
      'goair', 'flight', 'airline', 'airport', 'terminal', 'boarding',
      // Fuel & vehicle
      'petrol', 'diesel', 'fuel', 'cng', 'ev charging', 'servo',
      'bpcl', 'hpcl', 'iocl', 'indianoil', 'reliance petrol',
      'vehicle', 'car wash', 'tyre', 'automobile',
      // Parking & tolls
      'parking', 'fastag', 'toll', 'highway',
      // Travel booking
      'makemytrip', 'goibibo', 'yatra', 'cleartrip', 'ixigo',
      'redbus', 'abhibus', 'ticket',
    ],

    // ── SUBSCRIPTIONS ──────────────────────────────────────────────────────
    Category.subscriptions: [
      // Video streaming
      'netflix', 'hotstar', 'disney', 'prime video', 'amazon prime',
      'zee5', 'sonyliv', 'jiocinema', 'jio cinema', 'mxplayer', 'voot',
      'apple tv', 'youtube premium', 'crunchyroll', 'discovery plus',
      // Music
      'spotify', 'gaana', 'jiosaavn', 'wynk', 'amazon music',
      'apple music', 'resso',
      // Cloud storage
      'icloud', 'google one', 'dropbox', 'onedrive',
      // Software SaaS
      'adobe', 'canva', 'figma', 'notion', 'slack', 'zoom',
      'microsoft 365', 'office 365', 'google workspace',
      'chatgpt', 'openai', 'grammarly', 'loom', 'miro',
      'todoist', 'trello', 'asana', 'monday', 'linear', 'jira',
      'xero', 'freshbooks', 'quickbooks', 'zoho',
      // Generic subscription signals
      'subscription', 'membership', 'renewal', 'monthly plan', 'annual plan',
      'premium plan', 'pro plan', 'auto-renew', 'auto renew',
    ],

    // ── TECH TOOLS ─────────────────────────────────────────────────────────
    Category.techTools: [
      // Dev tools & hosting
      'github', 'gitlab', 'bitbucket', 'aws', 'amazon web services',
      'google cloud', 'gcp', 'azure', 'digitalocean', 'linode',
      'vultr', 'heroku', 'vercel', 'netlify', 'cloudflare',
      'fastly', 'render', 'railway', 'fly.io', 'supabase', 'firebase',
      // Domains & SSL
      'godaddy', 'namecheap', 'bigrock', 'hostinger', 'bluehost',
      'domain', 'hosting', 'ssl certificate', 'registrar',
      // Dev tools
      'jetbrains', 'cursor', 'copilot', 'github copilot', 'postman',
      'insomnia', 'datadog', 'sentry', 'logrocket', 'amplitude',
      'mixpanel', 'segment', 'twilio', 'sendgrid', 'mailchimp',
      'pagerduty', 'new relic', 'grafana',
      // Hardware
      'laptop', 'keyboard', 'mouse', 'monitor', 'webcam',
      'hard drive', 'ssd', 'ram', 'router', 'usb hub',
      'mechanical keyboard', 'drawing tablet',
    ],

    // ── ACADEMIC ───────────────────────────────────────────────────────────
    Category.academic: [
      // Ed-tech
      'udemy', 'coursera', 'unacademy', 'byju', 'vedantu',
      'physicswallah', 'pw app', 'toppr', 'testbook', 'adda247',
      'edureka', 'simplilearn', 'pluralsight', 'linkedin learning',
      'skillshare', 'masterclass', 'khan academy', 'brilliant',
      // Study materials
      'textbook', 'stationery', 'pen', 'pencil', 'notebook',
      'library', 'xerox', 'photocopy', 'printing', 'book store',
      // Coaching & fees
      'tuition', 'coaching', 'institute', 'coaching class', 'test series',
      'mock test', 'exam fee', 'registration fee',
      // College/school
      'college', 'university', 'school', 'hostel', 'admission',
      'semester fee', 'lab fee',
    ],

    // ── ENTERTAINMENT ──────────────────────────────────────────────────────
    Category.entertainment: [
      // Cinema
      'pvr', 'inox', 'cinepolis', 'bookmyshow', 'movie', 'cinema', 'theatre',
      // Gaming
      'steam', 'epic games', 'playstation', 'xbox', 'nintendo',
      'google play games', 'pubg', 'valorant', 'gaming', 'game pass',
      // Events
      'concert', 'event ticket', 'carnival', 'amusement', 'theme park',
      'museum', 'zoo', 'aquarium', 'resort', 'adventure', 'escape room',
      // Leisure shopping (not daily essentials)
      'amazon', 'flipkart', 'myntra', 'nykaa', 'meesho', 'ajio',
      'snapdeal', 'shopclues', 'etsy', 'shopping mall',
      // Sports & fitness
      'gym', 'fitness', 'yoga', 'zumba', 'sports', 'cricket',
      'football', 'badminton', 'swimming pool', 'cult fit', 'curefit',
    ],

    // ── PERSONAL CARE & LIFESTYLE ──────────────────────────────────────────
    Category.personal: [
      // Health & pharmacy
      'pharmacy', 'chemist', 'medical', 'medicine', 'doctor',
      'hospital', 'clinic', 'apollo', 'fortis', 'medanta',
      'practo', 'healthkart', '1mg', 'netmeds', 'pharmeasy',
      'diagnostic', 'blood test', 'pathlab',
      // Beauty & grooming
      'salon', 'barber', 'spa', 'beauty', 'parlour', 'makeup',
      'mamaearth', 'minimalist', 'dot & key', 'the body shop',
      // Clothing
      'clothing', 'clothes', 'apparel', 'fashion', 'shirt', 'jeans',
      'shoes', 'footwear', 'bag', 'accessories', 'kurti', 'saree',
      // Utilities & bills
      'electricity', 'water bill', 'gas bill', 'internet', 'broadband',
      'wifi', 'jio', 'airtel', 'bsnl', 'vodafone', 'vi', 'idea',
      'mobile recharge', 'recharge', 'dth', 'tataplay', 'dish tv',
      'd2h', 'tata sky',
      // Home & rent
      'rent', 'maintenance', 'society fee', 'housing',
      'furniture', 'home decor', 'appliance', 'repair',
      'plumber', 'electrician', 'carpenter',
      // Finance bills
      'insurance', 'emi', 'loan', 'sip', 'mutual fund',
      'investment', 'zerodha', 'groww', 'upstox', 'coin', 'kuvera',
      'lic', 'hdfc life', 'icici prudential',
    ],

    // ── INCOME ─────────────────────────────────────────────────────────────
    Category.income: [
      'salary', 'freelance', 'invoice payment', 'client payment',
      'consulting fee', 'commission', 'bonus', 'incentive',
      'refund', 'cashback', 'reward', 'interest', 'dividend',
      'credited', 'transfer in', 'received from', 'income',
      'stipend', 'honorarium', 'royalty', 'settlement',
      'fiverr', 'upwork', 'toptal', 'freelancer', 'guru',
      'paypal', 'payoneer', 'wise transfer', 'remittance',
      'tuition fee received',
    ],
  };

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Categorize a single merchant/description string.
  ///
  /// Priority order:
  /// 1. User-learned overrides (from manual corrections)
  /// 2. Longest-keyword match from [_keywords]
  /// 3. [Category.uncategorized] if nothing matches
  static Category classify(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return Category.uncategorized;

    // 1. Check user overrides first
    if (_overrides.containsKey(lower)) return _overrides[lower]!;

    // 2. Longest-match across all keywords
    Category? bestMatch;
    int bestLength = 0;

    for (final entry in _keywords.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword) && keyword.length > bestLength) {
          bestMatch = entry.key;
          bestLength = keyword.length;
        }
      }
    }

    return bestMatch ?? Category.uncategorized;
  }

  /// Categorize using a direction hint — if direction is [TransactionDirection.credit]
  /// and no keyword match is found, default to [Category.income] instead of uncategorized.
  static Category classifyWithDirection(
    String input,
    TransactionDirection direction,
  ) {
    final result = classify(input);
    if (result == Category.uncategorized &&
        direction == TransactionDirection.credit) {
      return Category.income;
    }
    return result;
  }

  /// Batch categorize a list of merchant names.
  /// Returns a map of name → [Category]. Includes uncategorized entries.
  static Map<String, Category> batchClassify(List<String> merchantNames) {
    return {for (final name in merchantNames) name: classify(name)};
  }

  /// Batch categorize and return only the successfully categorized entries
  /// (excludes [Category.uncategorized]).
  static Map<String, String> batchClassifyNamed(List<String> merchantNames) {
    final results = <String, String>{};
    for (final name in merchantNames) {
      final cat = classify(name);
      if (cat != Category.uncategorized) {
        results[name] = cat.name;
      }
    }
    return results;
  }

  /// Returns the confidence level of a classification result:
  /// - 'high' if 2+ keywords match
  /// - 'medium' if 1 keyword matches
  /// - 'low' if no match (uncategorized)
  static String getConfidence(String input) {
    final lower = input.toLowerCase().trim();
    int matchCount = 0;
    for (final keywords in _keywords.values) {
      for (final keyword in keywords) {
        if (lower.contains(keyword)) matchCount++;
        if (matchCount >= 2) return 'high';
      }
    }
    return matchCount == 1 ? 'medium' : 'low';
  }
}
