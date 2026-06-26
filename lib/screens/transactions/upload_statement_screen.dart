import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../../services/statement_parser.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class UploadStatementScreen extends ConsumerStatefulWidget {
  const UploadStatementScreen({super.key});

  @override
  ConsumerState<UploadStatementScreen> createState() => _UploadStatementScreenState();
}

class _UploadStatementScreenState extends ConsumerState<UploadStatementScreen> {
  final _parser = StatementParser();
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _pickAndParse(bool isPdf) async {
    final type = FileType.custom;
    final allowedExtensions = isPdf ? ['pdf'] : ['csv'];

    final result = await FilePicker.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );

    if (result == null || result.files.single.path == null) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Reading file...';
    });

    try {
      final statementId = const Uuid().v4();
      final path = result.files.single.path!;
      
      List<Transaction> txns = [];

      if (isPdf) {
        setState(() => _statusMessage = 'Parsing PDF locally...');
        txns = await _parser.parsePdfLocal(path, statementId);
        
        if (txns.isEmpty) {
          // Local parsing failed (format unknown), prompt for AI fallback
          setState(() => _isLoading = false);
          final confirm = await _showPdfDisclaimer();
          if (!confirm) return;
          
          setState(() {
            _isLoading = true;
            _statusMessage = 'Parsing PDF via Cloud AI...';
          });
          txns = await _parser.parsePdfCloud(path, statementId, 'GEMINI_API_KEY_HERE'); // Ideally fetched from settings
        }
      } else {
        setState(() => _statusMessage = 'Parsing CSV...');
        txns = await _parser.parseCsv(path, statementId);
      }

      if (txns.isEmpty) {
        _showError('No valid transactions found in this file.');
        return;
      }

      setState(() => _statusMessage = 'Saving \${txns.length} transactions...');
      
      final repo = ref.read(transactionRepositoryProvider);
      await repo.saveAll(txns);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully imported \${txns.length} transactions!', style: const TextStyle(color: Colors.white))),
        );
        context.pop();
      }
    } catch (e) {
      _showError('Failed to parse statement: \$e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = '';
        });
      }
    }
  }

  Future<bool> _showPdfDisclaimer() async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final colors = ctx.colors;
        return AlertDialog(
          backgroundColor: colors.backgroundElevated,
          title: Text('AI Parsing Disclaimer', style: ctx.textStyles.headingMedium),
          content: Text(
            'PDF parsing requires sending the text of the document to a secure Cloud AI (Gemini) for data extraction.\n\nIf you prefer 100% on-device processing to ensure no data leaves your phone, please use a CSV file instead.\n\nDo you want to proceed?',
            style: ctx.textStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false), 
              child: Text('Cancel', style: TextStyle(color: colors.textMuted))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors.accentPurple),
              onPressed: () => Navigator.pop(ctx, true), 
              child: const Text('Proceed', style: TextStyle(color: Colors.white))
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      backgroundColor: context.colors.accentRed,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Statement', style: textStyles.headingLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: _isLoading 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colors.accentPurple),
                  const SizedBox(height: 16),
                  Text(_statusMessage, style: textStyles.bodyMedium),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file_rounded, size: 80, color: colors.accentPurple),
                    const SizedBox(height: 24),
                    Text(
                      'Upload your weekly bank statement to automatically track expenses.', 
                      textAlign: TextAlign.center,
                      style: textStyles.bodyLarge,
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.table_chart_rounded, color: Colors.white),
                        label: const Text('Upload CSV (100% Local)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accentTeal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => _pickAndParse(false),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.picture_as_pdf_rounded, color: colors.accentPurple),
                        label: Text('Upload PDF (Cloud AI)', style: TextStyle(color: colors.accentPurple, fontSize: 16, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.accentPurple, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => _pickAndParse(true),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
