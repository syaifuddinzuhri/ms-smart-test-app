import 'package:ms_smart_test/data/models/profile_stats.dart';
import 'package:ms_smart_test/data/models/user_model.dart';

class ProfileModel {
  final ProfileStats stats;
  final User user;

  ProfileModel({
    required this.stats,
    required this.user,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ProfileModel(
      stats: ProfileStats.fromJson(data['stats']),
      user: User.fromJson(data['user']),
    );
  }
}