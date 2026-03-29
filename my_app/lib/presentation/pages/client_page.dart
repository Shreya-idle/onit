import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/client_viewmodel.dart';
import '../../models/client_details.dart';

class ClientPage extends StatefulWidget {
  final String clientId;
  const ClientPage({super.key, required this.clientId});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientViewModel>().fetchClientDetails(widget.clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Client Details',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ClientViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.status == ClientStatus.loading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen));
          }
          if (viewModel.status == ClientStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage ?? "Error loading client"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchClientDetails(widget.clientId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (viewModel.status == ClientStatus.empty ||
              viewModel.clientData == null) {
            return const Center(child: Text("No client data found"));
          }

          final client = viewModel.clientData!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfile(client),
                const SizedBox(height: 24),
                const Text('Overview',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(client.overview,
                    style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 24),
                const Text('Stats',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildStats(client.stats),
                const SizedBox(height: 24),
                const Text('Categories',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildCategories(client.categories),
                const SizedBox(height: 24),
                const Text('Reviews',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...client.reviews.map((r) => _buildReviewCard(r)).toList(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildProfile(ClientDetails client) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.lightGreenBackground,
          backgroundImage: client.imageUrl != null ? NetworkImage(client.imageUrl!) : null,
          child: client.imageUrl == null
              ? const Icon(Icons.person, color: AppColors.primaryGreen, size: 40)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(client.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(client.rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStats(Map stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.entries
            .map((e) => Column(
                  children: [
                    Text(e.value.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(e.key.toString(),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCategories(List categories) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories
          .map((c) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryGreen),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(c,
                    style: const TextStyle(
                        color: AppColors.primaryGreen, fontSize: 12)),
              ))
          .toList(),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review.author,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    Text(review.rating.toString(),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment,
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Save Task',
                  style: TextStyle(color: AppColors.primaryGreen)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Accept Task',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
