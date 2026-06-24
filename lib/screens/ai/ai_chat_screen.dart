import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/glass_panel.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: 'Hey! 👋 I\'m your local AI financial assistant. I analyze your data right here on your device!\n\nTry asking:\n• "List my recent transactions"\n• "Summarize my active budgets"\n• "What is my total spending?"\n• "Show my financial goals"',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final gemini = ref.read(geminiServiceProvider);
      final txns = await ref.read(transactionRepositoryProvider).getAll();
      final goals = await ref.read(goalRepositoryProvider).getAll();
      final budgets = await ref.read(budgetRepositoryProvider).getAll();
      final settings = await ref.read(settingsRepositoryProvider).get();

      final response = await gemini.chat(
        text,
        recentTransactions: txns,
        goals: goals,
        budgets: budgets,
        settings: settings,
      );

      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Oops! Something went wrong: $e', isUser: false));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(backgroundColor: colors.backgroundPrimary, 
      
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors.accentPurple, colors.accentTeal]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Text('AI Assistant', style: textStyles.headingLarge),
          ],
        ),
        
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            tooltip: 'New conversation',
            onPressed: () {
              ref.read(geminiServiceProvider).resetChat();
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  text: 'Chat reset! 🔄 Ask me anything about your finances.',
                  isUser: false,
                ));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // No API key banner needed — always online!

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator(colors);
                }
                return _buildMessageBubble(_messages[index], colors, textStyles);
              },
            ),
          ),

          if (_messages.length <= 2)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildQuickAction('📋 List recent transactions', colors),
                  _buildQuickAction('💰 Summarize my budgets', colors),
                  _buildQuickAction('📉 What is my total spending?', colors),
                  _buildQuickAction('🎯 Show my financial goals', colors),
                  _buildQuickAction('🔍 Any large expenses recently?', colors),
                  _buildQuickAction('📊 Give me a brief summary', colors),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),


          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    borderRadius: BorderRadius.circular(24),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask about your finances...',
                        hintStyle: TextStyle(color: colors.textMuted),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colors.accentPurple, colors.accentTeal]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMessageBubble(ChatMessage msg, AppColors colors, AppTextStyles textStyles) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
        left: msg.isUser ? 48 : 0,
        right: msg.isUser ? 0 : 48,
      ),
      child: Align(
        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: msg.isUser
                ? colors.accentPurple.withValues(alpha: 0.25)
                : colors.backgroundElevated.withValues(alpha: 0.6),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
              bottomRight: Radius.circular(msg.isUser ? 4 : 16),
            ),
            border: Border.all(
              color: msg.isUser ? colors.accentPurple.withValues(alpha: 0.3) : colors.borderSubtle,
            ),
          ),
          child: msg.isUser 
            ? Text(
                msg.text,
                style: textStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  height: 1.5,
                ),
              )
            : MarkdownBody(
                data: msg.text,
                styleSheet: _buildMarkdownStyle(colors, textStyles),
              ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }
  MarkdownStyleSheet _buildMarkdownStyle(AppColors colors, AppTextStyles textStyles) {
    return MarkdownStyleSheet(
      p: textStyles.bodyMedium.copyWith(color: colors.textPrimary, height: 1.6, fontSize: 13.5),
      strong: textStyles.bodyMedium.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13.5),
      h2: textStyles.bodyLarge.copyWith(color: colors.accentPurple, fontWeight: FontWeight.w700, fontSize: 14),
      listBullet: textStyles.bodyMedium.copyWith(color: colors.accentTeal, fontSize: 13.5),
      code: textStyles.bodySmall.copyWith(color: colors.accentTeal, fontFamily: 'monospace', fontSize: 12),
      horizontalRuleDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.borderSubtle))),
      tableBorder: TableBorder.all(color: colors.borderSubtle, width: 0.5),
      tableHead: textStyles.bodySmall.copyWith(color: colors.textMuted, fontWeight: FontWeight.w700, fontSize: 11),
      tableBody: textStyles.bodyMedium.copyWith(color: colors.textPrimary, fontSize: 13),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      pPadding: const EdgeInsets.only(bottom: 2),
    );
  }

  Widget _buildTypingIndicator(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 48),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.backgroundElevated.withValues(alpha: 0.6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
            ),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(colors, 0),
              const SizedBox(width: 4),
              _buildDot(colors, 200),
              const SizedBox(width: 4),
              _buildDot(colors, 400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(AppColors colors, int delayMs) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: colors.accentPurple,
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(delay: Duration(milliseconds: delayMs)).scaleXY(end: 1.3);
  }

  Widget _buildQuickAction(String text, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: TextStyle(color: colors.textPrimary, fontSize: 12)),
        backgroundColor: colors.backgroundElevated.withValues(alpha: 0.5),
        side: BorderSide(color: colors.borderSubtle),
        onPressed: () {
          _controller.text = text;
          _sendMessage();
        },
      ),
    );
  }
}
