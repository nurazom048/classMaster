import '../../../../core/constant/constant.dart';
import '../../../../core/constant/enum.dart';
import '../../../routine/data/models/class_model.dart';

class AllSummaryModel {
  String message;
  List<SummaryModel> summaries;
  int currentPage;
  int totalPages;
  int totalCount;

  AllSummaryModel({
    required this.message,
    required this.summaries,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory AllSummaryModel.fromJson(Map<String, dynamic> json) {
    return AllSummaryModel(
      message: json['message'] ?? '',
      summaries:
          (json['summaries'] as List<dynamic>? ?? [])
              .map((summary) => SummaryModel.fromJson(summary))
              .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
    );
  }

  AllSummaryModel copyWith({
    String? message,
    List<SummaryModel>? summaries,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return AllSummaryModel(
      message: message ?? this.message,
      summaries: summaries ?? this.summaries,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class SummaryModel {
  String? id;
  String? ownerId;
  String? text;
  List<String>? imageLinks; // ✅ This will map from 'fileLinks' from backend
  String? routineId;
  String? classId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Owner? owner;
  ClasssModel? classInfo;
  ImageStorageProvider? imageStorageProvider;

  SummaryModel({
    this.id,
    this.ownerId,
    this.text,
    this.imageLinks,
    this.routineId,
    this.classId,
    this.createdAt,
    this.updatedAt,
    this.owner,
    this.classInfo,
    this.imageStorageProvider,
  });

  /// Create model from API JSON response
  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      id: json['id'],
      ownerId: json['ownerId'],
      text: json['text'],
      // ✅ FIX: Map 'fileLinks' from backend to 'imageLinks' in Flutter
      imageLinks:
          json['fileLinks'] != null ? List<String>.from(json['fileLinks']) : [],
      routineId: json['routineId'],
      classId: json['classId'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
      classInfo:
          json['class'] != null ? ClasssModel.fromJson(json['class']) : null,
      imageStorageProvider:
          json['imageStorageProvider'] != null
              ? ImageStorageProvider.values.firstWhere(
                (e) => e.name == json['imageStorageProvider'],
                orElse: () => ImageStorageProvider.minio,
              )
              : ImageStorageProvider.minio,
    );
  }

  /// Generates the Full Image URLs based on the storage provider
  List<String> get fullImageLinks {
    if (imageLinks == null || imageLinks!.isEmpty) {
      return [];
    }

    return imageLinks!.map((path) {
      // If it already has http (e.g., Firebase URLs or old data), return as is
      if (path.startsWith('http')) {
        return path;
      }

      // MinIO: Prepend base URL and bucket name from your Const file
      if (imageStorageProvider == ImageStorageProvider.minio) {
        // Example: "api.classmaster.top/storageforclassmaster/"  + "ID-xxx/routine/..."
        return "${Const.MINIO_BASE_URL}$path";
      }

      // AWS S3 or other providers
      if (imageStorageProvider == ImageStorageProvider.aws) {
        // If you have AWS base URL
        return "${Const.MINIO_BASE_URL}$path";
      }

      return path;
    }).toList();
  }

  /// Convert to JSON (useful for debugging or local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'text': text,
      'fileLinks': imageLinks, // ✅ Convert back to 'fileLinks' for API
      'routineId': routineId,
      'classId': classId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'owner': owner?.toJson(),
      'class': classInfo?.toJson(),
      'imageStorageProvider': imageStorageProvider?.name,
    };
  }

  SummaryModel copyWith({
    String? id,
    String? ownerId,
    String? text,
    List<String>? imageLinks,
    String? routineId,
    String? classId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Owner? owner,
    ClasssModel? classInfo,
    ImageStorageProvider? imageStorageProvider,
  }) {
    return SummaryModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      text: text ?? this.text,
      imageLinks: imageLinks ?? this.imageLinks,
      routineId: routineId ?? this.routineId,
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      owner: owner ?? this.owner,
      classInfo: classInfo ?? this.classInfo,
      imageStorageProvider: imageStorageProvider ?? this.imageStorageProvider,
    );
  }
}

class Owner {
  String id;
  String username;
  String name;
  String? image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'name': name, 'image': image};
  }
}

// ✅ Add this extension for easier access
extension SummaryModelExtension on SummaryModel {
  bool get hasImages => imageLinks != null && imageLinks!.isNotEmpty;
  bool get hasText => text != null && text!.isNotEmpty;
  String get displayText => text ?? 'No summary text';
  int get imageCount => imageLinks?.length ?? 0;

  String get formattedDate {
    if (createdAt == null) return 'Unknown date';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
