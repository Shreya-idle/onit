import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/home_widgets.dart';

/// Home page that assembles all sections of the OnIT app.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Address Header ──
              const AddressHeader(),
              const SizedBox(height: 12),

              // ── Search Bar ──
              const SearchBarWidget(),
              const SizedBox(height: 4),

              // ── Welcome Hero Banner ──
              const HeroBanner(),

              // ── Featured Banner ──
              const FeaturedBanner(),

              // ── Promo Cards ──
              const PromoRow(),
              const SizedBox(height: 8),

              // ── Task Templates Section ──
              const SectionTitle(title: 'Task Templates'),
              const SizedBox(height: 12),
              _buildTaskTemplatesRow(),
              const SizedBox(height: 24),

              // ── Top Performers Section ──
              const SectionTitle(title: 'Top Performers'),
              const SizedBox(height: 12),
              _buildPerformersRow(),
              const SizedBox(height: 24),

              // ── Testimonials Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text('Testimonials',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              const TestimonialCard(
                name: 'Anu Reddy',
                role: 'Web Designer',
                content:
                    'Posting tasks has never been that easy. I got reliable performers within minutes, and the entire process was smooth and stress-free',
              ),
              const SizedBox(height: 24),

              // ── Rewards Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text('Rewards',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              const RewardSection(),
              const SizedBox(height: 24),

              // ── Footer Branding ──
              const FooterBrand(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Horizontal scrollable row of task template cards.
  Widget _buildTaskTemplatesRow() {
    final templates = [
      {'title': 'Academic\nResearch', 'subtitle': '250+ taskers'},
      {'title': 'Design\nProjects', 'subtitle': '350+ taskers'},
      {'title': 'Literature\nReview', 'subtitle': '150+ taskers'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: templates.map((t) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TaskTemplateCard(
              title: t['title']!,
              subtitle: t['subtitle']!,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Horizontal scrollable row of performer cards.
  Widget _buildPerformersRow() {
    final performers = [
      {
        'name': 'Anu Reddy',
        'role': 'Web Designer',
        'rating': 4.7,
        'desc':
            'He accepts the task as the new which focus on quality of work at efficiency',
      },
      {
        'name': 'Anu Reddy',
        'role': 'Web Designer',
        'rating': 4.7,
        'desc':
            'He accepts the task as the new which focus on quality of work at efficiency',
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: performers.map((p) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PerformerCard(
              name: p['name'] as String,
              role: p['role'] as String,
              rating: p['rating'] as double,
              description: p['desc'] as String,
            ),
          );
        }).toList(),
      ),
    );
  }
}
