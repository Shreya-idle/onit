import 'performer.dart';
import 'task_model.dart';
import 'testimonial.dart';

class HomeData {
  final String address;
  final List<Performer> topPerformers;
  final List<TaskModel> taskTemplates;
  final List<Testimonial> testimonials;

  HomeData({
    required this.address,
    required this.topPerformers,
    required this.taskTemplates,
    required this.testimonials,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      address: json['address'] ?? "",
      topPerformers: (json['topPerformers'] as List? ?? [])
          .map<Performer>((e) => Performer.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskTemplates: (json['taskTemplates'] as List? ?? [])
          .map<TaskModel>((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      testimonials: (json['testimonials'] as List? ?? [])
          .map<Testimonial>((e) => Testimonial.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
