import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/student.dart';

class AddStudentSheet extends ConsumerStatefulWidget {
  final Student? existingStudent;
  const AddStudentSheet({super.key, this.existingStudent});

  static Future<void> show(BuildContext context, {Student? existingStudent}) {
    return AppBottomSheet.show(
      context,
      title: existingStudent == null ? 'Add Student' : 'Edit Student',
      child: AddStudentSheet(existingStudent: existingStudent),
    );
  }

  @override
  ConsumerState<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends ConsumerState<AddStudentSheet> {
  late TextEditingController _nameController;
  late TextEditingController _subjectController;
  late TextEditingController _feeController;
  late TextEditingController _scheduleController;
  
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final s = widget.existingStudent;
    _nameController = TextEditingController(text: s?.name ?? '');
    _subjectController = TextEditingController(text: s?.subject ?? '');
    _feeController = TextEditingController(text: s != null ? s.feePerSession.toString() : '');
    _scheduleController = TextEditingController(text: s?.schedule ?? '');
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _feeController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final subject = _subjectController.text.trim();
    final feeText = _feeController.text.trim();
    
    if (name.isEmpty || subject.isEmpty || feeText.isEmpty) return;
    
    final fee = double.tryParse(feeText);
    if (fee == null || fee <= 0) return;

    final repo = ref.read(studentRepositoryProvider);
    final student = Student(
      id: widget.existingStudent?.id ?? const Uuid().v4(),
      name: name,
      subject: subject,
      feePerSession: fee,
      schedule: _scheduleController.text.trim(),
      isActive: _isActive,
      createdAt: widget.existingStudent?.createdAt ?? DateTime.now(),
    );

    await repo.save(student);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Student Name',
              labelStyle: TextStyle(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: 'Subject',
              labelStyle: TextStyle(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _feeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textMuted),
              hintText: '0',
              border: InputBorder.none,
              labelText: 'Fee Per Session',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _scheduleController,
            decoration: InputDecoration(
              labelText: 'Schedule (e.g. Mon & Wed 5 PM)',
              labelStyle: TextStyle(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Active Student'),
            subtitle: Text(
              _isActive ? 'Currently taking sessions' : 'Not taking sessions right now',
              style: TextStyle(color: colors.textMuted),
            ),
            value: _isActive,
            activeThumbColor: colors.accentTeal,
            onChanged: (val) => setState(() => _isActive = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          AppButton(
            label: widget.existingStudent == null ? 'Save Student' : 'Update Student',
            onPressed: _submit,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
