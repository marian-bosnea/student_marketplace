// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';

import '../../core/constants/enums.dart';

class UserProfileViewState extends Equatable {
  final String firstName;
  final String lastName;
  final String secondLastName;
  final String emailAdress;
  final String facultyName;
  final Uint8List? avatarBytes;
  final ProfilePageStatus status;

  final List<SalePostEntity> posts;

  const UserProfileViewState(
      {this.firstName = '',
      this.lastName = '',
      this.secondLastName = '',
      this.emailAdress = '',
      this.avatarBytes,
      this.facultyName = '',
      this.posts = const [],
      this.status = ProfilePageStatus.initial});

  UserProfileViewState copyWith(
          {String? firstName,
          String? lastName,
          String? secondLastName,
          String? emailAdress,
          String? facultyName,
          Uint8List? avatarBytes,
          List<SalePostEntity>? posts,
          ProfilePageStatus? status}) =>
      UserProfileViewState(
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          secondLastName: secondLastName ?? this.secondLastName,
          emailAdress: emailAdress ?? this.emailAdress,
          facultyName: facultyName ?? this.facultyName,
          avatarBytes: avatarBytes ?? this.avatarBytes,
          posts: posts ?? this.posts,
          status: status ?? this.status);

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        secondLastName,
        emailAdress,
        facultyName,
        status,
        posts
      ];
}
