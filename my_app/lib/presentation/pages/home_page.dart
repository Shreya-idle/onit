import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/home_widgets.dart';
import '../../viewmodels/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
            }

            if (viewModel.status == HomeStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(viewModel.errorMessage ?? 'An error occurred'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.fetchHomeData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final data = viewModel.homeData;
            if (data == null) return const Center(child: Text('No data available'));

            return RefreshIndicator(
              onRefresh: () => viewModel.fetchHomeData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    AddressHeader(address: data.address),
                    const SizedBox(height: 12),

                    const SearchBarWidget(),
                    const SizedBox(height: 4),

                    const HeroBanner(),
                    const FeaturedBanner(),

                    const PromoRow(),
                    const SizedBox(height: 8),

                    const SectionTitle(title: 'Task Templates'),
                    const SizedBox(height: 12),
                    _buildTaskTemplatesRow(data.taskTemplates),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Top Performers'),
                    const SizedBox(height: 12),
                    _buildPerformersRow(data.topPerformers),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text('Testimonials',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    if (data.testimonials.isNotEmpty)
                      TestimonialCard(
                        name: data.testimonials.first.name,
                        role: data.testimonials.first.role,
                        content: data.testimonials.first.content,
                      ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text('Rewards',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    const RewardSection(),
                    const SizedBox(height: 24),

                    const FooterBrand(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskTemplatesRow(List templates) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: templates.map((t) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TaskTemplateCard(
              title: t.title,
              subtitle: t.category,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPerformersRow(List performers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: performers.map((p) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PerformerCard(
              name: p.name,
              role: p.role,
              rating: p.rating,
              description: p.description,
            ),
          );
        }).toList(),
      ),
    );
  }
}
