import '../../../../core/constant/enum.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constant/constant.dart';

class AccountModels {
  String? id;
  String? username;
  String? name;
  String? password;

  String? image;
  String? coverImage;

  String? position;
  String? about;
  String? accountType;

  bool? isVerified;

  ImageStorageProvider? imageStorageProvider;
  ImageStorageProvider? coverImageStorageProvider;

  // Step 3: Added requestId and requestMessage fields to AccountModels to handle pending join requests.
  String? requestId;
  String? requestMessage;

  AddressModel? address;

  AccountModels({
    this.id,
    this.username,
    this.name,
    this.password,
    this.image,
    this.coverImage,
    this.position,
    this.about,
    this.accountType,
    this.isVerified,
    this.imageStorageProvider,
    this.coverImageStorageProvider,
    this.requestId,
    this.requestMessage,
    this.address,
  });

  /// Create model from API JSON response
  AccountModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];

    // API কখনো "null" string পাঠালে null এ convert করা হচ্ছে
    image = json['image'] == "null" ? null : json['image'];
    coverImage = json['coverImage'] == "null" ? null : json['coverImage'];

    position = json['position'];
    about = json['about'];
    accountType = json['accountType'];

    isVerified = json['isVerified'];

    imageStorageProvider = ImageStorageProvider.values.firstWhere(
      (e) => e.name == json['imageStorageProvider'],
      orElse: () => ImageStorageProvider.others,
    );

    coverImageStorageProvider = ImageStorageProvider.values.firstWhere(
      (e) => e.name == json['coverImageStorageProvider'],
      orElse: () => ImageStorageProvider.others,
    );

    requestId = json['requestId'];
    requestMessage = json['requestMessage'];
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
  }

  /// Full profile image URL
  ///
  /// Example:
  /// AWS    -> https://api.classmaster.top/storage/storageforclassmaster/...
  /// Firebase -> https://firebasestorage.googleapis.com/...
  String? get imageUrl {
    // No image available
    if (image == null || image!.trim().isEmpty) {
      return null;
    }

    // AWS stored image → build full URL
    if (imageStorageProvider == ImageStorageProvider.aws ||
        !image!.startsWith('http')) {
      return "${Const.MINIO_BASE_URL}$image";
    }

    // Firebase / External URL
    return image;
  }

  /// Full cover image URL
  String? get coverImageUrl {
    // No cover image available
    if (coverImage == null || coverImage!.trim().isEmpty) {
      return null;
    }

    // AWS stored image → build full URL
    if (coverImageStorageProvider == ImageStorageProvider.aws) {
      return "${Const.MINIO_BASE_URL}$coverImage";
    }

    // Firebase / External URL
    return coverImage;
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'password': password,
      'image': image,
      'coverImage': coverImage,
      'position': position,
      'about': about,
      'accountType': accountType,
      'isVerified': isVerified,
      'imageStorageProvider': imageStorageProvider?.name,
      'coverImageStorageProvider': coverImageStorageProvider?.name,
      'requestId': requestId,
      'requestMessage': requestMessage,
      'address': address?.toJson(),
    };
  }

  /// Clone model with updated values
  AccountModels copyWith({
    String? id,
    String? username,
    String? name,
    String? password,
    String? image,
    String? coverImage,
    String? position,
    String? about,
    String? accountType,
    bool? isVerified,
    ImageStorageProvider? imageStorageProvider,
    ImageStorageProvider? coverImageStorageProvider,
    String? requestId,
    String? requestMessage,
    AddressModel? address,
  }) {
    return AccountModels(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
      image: image ?? this.image,
      coverImage: coverImage ?? this.coverImage,
      position: position ?? this.position,
      about: about ?? this.about,
      accountType: accountType ?? this.accountType,
      isVerified: isVerified ?? this.isVerified,
      imageStorageProvider: imageStorageProvider ?? this.imageStorageProvider,
      coverImageStorageProvider:
          coverImageStorageProvider ?? this.coverImageStorageProvider,
      requestId: requestId ?? this.requestId,
      requestMessage: requestMessage ?? this.requestMessage,
      address: address ?? this.address,
    );
  }
}

///
///edit account ..dart to json

class AccountEditModel {
  final String name;
  final String username;
  final String about;
  final String? accountType;
  final String? district;
  final String? upazila;
  final String? streetAddress;
  final double? latitude;
  final double? longitude;
  final XFile? image;
  final XFile? coverImage;

  const AccountEditModel({
    required this.name,
    required this.username,
    required this.about,
    this.accountType,
    this.district,
    this.upazila,
    this.streetAddress,
    this.latitude,
    this.longitude,
    this.image,
    this.coverImage,
  });
}

class AddressModel {
  String? id;
  String? district;
  String? upazila;
  String? streetAddress;
  double? latitude;
  double? longitude;

  AddressModel({
    this.id,
    this.district,
    this.upazila,
    this.streetAddress,
    this.latitude,
    this.longitude,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    district = json['district'];
    upazila = json['upazila'];
    streetAddress = json['streetAddress'];
    latitude = json['latitude'] != null ? (json['latitude'] as num).toDouble() : null;
    longitude = json['longitude'] != null ? (json['longitude'] as num).toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'upazila': upazila,
      'streetAddress': streetAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  AddressModel copyWith({
    String? id,
    String? district,
    String? upazila,
    String? streetAddress,
    double? latitude,
    double? longitude,
  }) {
    return AddressModel(
      id: id ?? this.id,
      district: district ?? this.district,
      upazila: upazila ?? this.upazila,
      streetAddress: streetAddress ?? this.streetAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
