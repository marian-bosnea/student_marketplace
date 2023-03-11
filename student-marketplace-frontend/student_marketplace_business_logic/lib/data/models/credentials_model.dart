import '../../domain/entities/credentials_entity.dart';

class CredentialsModel extends CredentialsEntity {
  CredentialsModel({required super.email, required super.password});

  Map<String, dynamic> toJson() =>
      {'email': super.email, 'password': super.password};
}
