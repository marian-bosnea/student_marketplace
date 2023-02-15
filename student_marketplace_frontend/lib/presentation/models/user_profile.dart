class UserProfile {
  final String firstName;

  final String lastName;

  final String? secondaryLastName;

  final String avatarImage;

  final String facultyName;

  UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.secondaryLastName,
      required this.avatarImage,
      required this.facultyName});

  static UserProfile? fromJson(Object? json) {
    if (json == null) {
      return null;
    }

    assert(json is Map);
    final map = json as Map<String, dynamic>;

    return UserProfile(
        firstName: map["firstName"] as String,
        lastName: map["lastName"] as String,
        secondaryLastName: map["secondaryLastName"] as String?,
        avatarImage: map["avatarImage"] as String,
        facultyName: map["facultyName"] as String);
  }
}
