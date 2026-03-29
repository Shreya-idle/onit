import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/task_viewmodel.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _budgetController = TextEditingController();
  final _deadlineController = TextEditingController();

  Future<void> _submit(TaskViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final taskData = {
        'title': _titleController.text,
        'category': _categoryController.text,
        'budget': double.tryParse(_budgetController.text) ?? 100.0,
        'status': 'open',
        'deadline': _deadlineController.text,
      };

      final success = await viewModel.postTask(taskData);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Task Created Successfully"), backgroundColor: AppColors.primaryGreen));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create New Task', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(_titleController, 'Title', 'e.g. Website Redesign', (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _buildField(_categoryController, 'Category', 'e.g. Web Design', (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _buildField(_budgetController, 'Budget', 'e.g. 500', (v) => v!.isEmpty ? 'Required' : null, type: TextInputType.number),
              const SizedBox(height: 16),
              _buildField(_deadlineController, 'Deadline', 'e.g. 2026-12-31', (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: viewModel.status == TaskStatus.loading ? null : () => _submit(viewModel),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                child: viewModel.status == TaskStatus.loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Post Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, String hint, String? Function(String?)? validator, {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: validator,
      keyboardType: type,
    );
  }
}
