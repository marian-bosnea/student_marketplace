import '../../domain/entities/faculty_entity.dart';

class FacultyModel extends FacultyEntity {
  FacultyModel({super.id, super.name, super.shortName, super.imageBytes});

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    return FacultyModel(
        id: json['id'] as int,
        name: json['name'] as String,
        shortName: json['shortName'] as String);
  }
}
