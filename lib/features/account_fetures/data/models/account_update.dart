class AccountUpdate {
  final String name;
  final String username;
  final String about;
  final String? profileImage;
  final String? coverImage;

  const AccountUpdate({
    required this.name,
    required this.username,
    required this.about,
    this.profileImage,
    this.coverImage,
  });
}
