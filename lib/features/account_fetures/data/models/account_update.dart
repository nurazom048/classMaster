import 'package:image_picker/image_picker.dart';

class AccountUpdate {
  final String name;
  final String username;
  final String about;
  final XFile? profileImage;
  final XFile? coverImage;

  const AccountUpdate({
    required this.name,
    required this.username,
    required this.about,
    this.profileImage,
    this.coverImage,
  });
}
