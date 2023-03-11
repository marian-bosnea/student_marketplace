import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class FacultyEntity extends Equatable {
  final int? id;
  final String? name;
  final String? shortName;
  final Uint8List? imageBytes;

  const FacultyEntity({this.id, this.name, this.shortName, this.imageBytes});

  @override
  List<Object?> get props => [id, name, shortName];
}
