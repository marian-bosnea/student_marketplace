import 'package:equatable/equatable.dart';

abstract class FacultyEntity extends Equatable {
  final int? id;
  final String? name;
  final String? image;

  const FacultyEntity({this.id, this.name, this.image});

  @override
  List<Object?> get props => [id, name];
}
