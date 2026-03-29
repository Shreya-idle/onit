import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../models/task_model.dart';
import 'task_details_page.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({super.key});

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Tasks',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.status == TaskStatus.loading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen));
          }
          if (viewModel.status == TaskStatus.empty) {
            return const Center(child: Text("No tasks found"));
          }
          if (viewModel.status == TaskStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(viewModel.errorMessage ?? "Error loading tasks"),
                   const SizedBox(height: 16),
                   ElevatedButton(
                     onPressed: () => viewModel.fetchTasks(),
                     child: const Text('Retry'),
                   ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.tasks.length,
            itemBuilder: (context, index) {
              final task = viewModel.tasks[index];
              return _buildTaskCard(task, viewModel);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, TaskViewModel viewModel) {
    final status = task.status;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailsPage(taskId: task.id),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  _buildStatusChip(status),
                ],
              ),
              const SizedBox(height: 8),
              Text(task.category,
                  style: const TextStyle(
                      color: AppColors.primaryGreen, fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Budget: \$${task.budget}",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text("Deadline: ${task.deadline}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              if (status != 'completed')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final nextStatus =
                          status == 'open' ? 'in_progress' : 'completed';
                      viewModel.updateStatus(task.id, nextStatus);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen),
                    child: Text(
                        status == 'open' ? 'Start Task' : 'Complete Task',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    if (status == 'in_progress') color = Colors.blue;
    if (status == 'completed') color = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
