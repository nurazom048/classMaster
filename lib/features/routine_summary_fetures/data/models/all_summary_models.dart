import '../../../../core/constant/constant.dart';
import '../../../../core/constant/enum.dart';
import '../../../routine/data/models/class_model.dart';

enum SummaryType { TEXT, MEDIA, POLL, SYSTEM }

class PollOption {
  String option;
  List<String> votes; // List of user IDs who voted for this option

  PollOption({required this.option, required this.votes});

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      option: json['option'] ?? '',
      votes: List<String>.from(json['votes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'votes': votes,
    };
  }
}

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
  List<String>? imageLinks; // maps from backend fileLinks
  String? routineId;
  String? classId;
  DateTime? createdAt;
  DateTime? updatedAt;
  SummaryType? type;
  String? fileType; // 'image', 'video', 'document'
  List<PollOption>? pollOptions;

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
    this.type,
    this.fileType,
    this.pollOptions,
    this.owner,
    this.classInfo,
    this.imageStorageProvider,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      id: json['id'],
      ownerId: json['ownerId'],
      text: json['text'],
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
      type: json['type'] != null
          ? SummaryType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => SummaryType.TEXT,
            )
          : SummaryType.TEXT,
      fileType: json['fileType'],
      pollOptions: json['pollOptions'] != null
          ? (json['pollOptions'] as List<dynamic>)
              .map((opt) => PollOption.fromJson(opt))
              .toList()
          : null,
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
      classInfo:
          json['classInfo'] != null ? ClasssModel.fromJson(json['classInfo']) : null,
      imageStorageProvider:
          json['imageStorageProvider'] != null
              ? ImageStorageProvider.values.firstWhere(
                (e) => e.name == json['imageStorageProvider'],
                orElse: () => ImageStorageProvider.minio,
              )
              : ImageStorageProvider.minio,
    );
  }

  List<String> get fullImageLinks {
    if (imageLinks == null || imageLinks!.isEmpty) {
      return [];
    }

    return imageLinks!.map((path) {
      if (path.startsWith('http')) {
        return path;
      }
      if (imageStorageProvider == ImageStorageProvider.minio ||
          imageStorageProvider == ImageStorageProvider.aws ||
          imageStorageProvider == ImageStorageProvider.appwrite) {
        return "${Const.MINIO_BASE_URL}$path";
      }
      return path;
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'text': text,
      'fileLinks': imageLinks,
      'routineId': routineId,
      'classId': classId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'type': type?.name,
      'fileType': fileType,
      'pollOptions': pollOptions?.map((e) => e.toJson()).toList(),
      'owner': owner?.toJson(),
      'classInfo': classInfo?.toJson(),
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
    SummaryType? type,
    String? fileType,
    List<PollOption>? pollOptions,
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
      type: type ?? this.type,
      fileType: fileType ?? this.fileType,
      pollOptions: pollOptions ?? this.pollOptions,
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

extension SummaryModelExtension on SummaryModel {
  bool get hasImages => imageLinks != null && imageLinks!.isNotEmpty;
  bool get hasText => text != null && text!.isNotEmpty;
  String get displayText => text ?? 'No summary text';
  int get imageCount => imageLinks?.length ?? 0;

  int get daysUntilDeletion {
    if (createdAt == null) return 120;
    final deletionDate = createdAt!.add(const Duration(days: 120));
    final difference = deletionDate.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }

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
