import '../../../../core/constant/constant.dart';
import '../../../../core/constant/enum.dart';
import '../../../routine_Fetures/data/models/class_model.dart';

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
      message: json['message'],
      summaries:
          (json['summaries'] as List<dynamic>)
              .map((summary) => SummaryModel.fromJson(summary))
              .toList(),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalCount: json['totalCount'],
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
  List<String>? imageLinks;
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
  SummaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    text = json['text'];

    if (json['imageLinks'] != null) {
      imageLinks = List<String>.from(json['imageLinks']);
    } else {
      imageLinks = [];
    }

    routineId = json['routineId'];
    classId = json['classId'];
    createdAt =
        json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null;

    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    classInfo =
        json['class'] != null ? ClasssModel.fromJson(json['class']) : null;

    // Make sure your backend sends imageStorageProvider for summaries too.
    // Defaulting to minio/aws if missing so it doesn't crash.
    imageStorageProvider = ImageStorageProvider.values.firstWhere(
      (e) => e.name == json['imageStorageProvider'],
      orElse: () => ImageStorageProvider.minio,
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

      //  MinIO: Prepend base URL and bucket name from your Const file
      if (imageStorageProvider == ImageStorageProvider.minio) {
        // Example: "api.classmaster.top/storageforclassmaster/"  + "ID-xxx/routine/..."
        return "${Const.MINIO_BASE_URL}$path";
      }

      return path;
    }).toList();
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
      id: json['id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
    );
  }
}
