class GetAllEventModel {
  int? statusCode;
  bool? success;
  String? message;
  EventListData? data;

  GetAllEventModel({this.statusCode, this.success, this.message, this.data});

  factory GetAllEventModel.fromJson(Map<String, dynamic> json) {
    return GetAllEventModel(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? EventListData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class EventListData {
  Meta? meta;
  List<EventData>? data;

  EventListData({this.meta, this.data});

  factory EventListData.fromJson(Map<String, dynamic> json) {
    return EventListData(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? (json['data'] as List).map((v) => EventData.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (meta != null) {
      map['meta'] = meta!.toJson();
    }
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    }..removeWhere((key, value) => value == null);
  }
}

class EventData {
  Location? location;
  String? id;
  String? title;
  String? description;
  String? category;
  List<String>? tags;
  OrganizerId? organizerId;
  String? status;
  String? visibility;
  String? startDate;
  String? startTime;
  String? locationType;
  String? address;
  int? capacity;
  int? ticketsSold;
  int? ticketPrice;
  List<String>? images;       
  List<String>? gallery;      
  int? views;
  int? favorites;
  bool? hasLiveStream;
  String? liveStreamId;
  bool? isStreamingActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  EventData({
    this.location,
    this.id,
    this.title,
    this.description,
    this.category,
    this.tags,
    this.organizerId,
    this.status,
    this.visibility,
    this.startDate,
    this.startTime,
    this.locationType,
    this.address,
    this.capacity,
    this.ticketsSold,
    this.ticketPrice,
    this.images,
    this.gallery,
    this.views,
    this.favorites,
    this.hasLiveStream,
    this.liveStreamId,
    this.isStreamingActive,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      id: json['_id'] ,
      title: json['title'],
      description: json['description'],
      category: json['category'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      organizerId: json['organizerId'] != null ? OrganizerId.fromJson(json['organizerId']) : null,
      status: json['status'],
      visibility: json['visibility'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      locationType: json['locationType'],
      address: json['address'],
      capacity: json['capacity'],
      ticketsSold: json['ticketsSold'],
      ticketPrice: json['ticketPrice'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      gallery: json['gallery'] != null ? List<String>.from(json['gallery']) : [],
      views: json['views'],
      favorites: json['favorites'],
      hasLiveStream: json['hasLiveStream'],
      liveStreamId: json['liveStreamId'],
      isStreamingActive: json['isStreamingActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) map['location'] = location!.toJson();
    map['_id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['category'] = category;
    map['tags'] = tags;
    if (organizerId != null) map['organizerId'] = organizerId!.toJson();
    map['status'] = status;
    map['visibility'] = visibility;
    map['startDate'] = startDate;
    map['startTime'] = startTime;
    map['locationType'] = locationType;
    map['address'] = address;
    map['capacity'] = capacity;
    map['ticketsSold'] = ticketsSold;
    map['ticketPrice'] = ticketPrice;
    map['images'] = images ?? [];
    map['gallery'] = gallery ?? [];
    map['views'] = views;
    map['favorites'] = favorites;
    map['hasLiveStream'] = hasLiveStream;
    map['liveStreamId'] = liveStreamId;
    map['isStreamingActive'] = isStreamingActive;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = iV;
    map['id'] = id;
    return map;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null ? List<double>.from(json['coordinates']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

class OrganizerId {
  String? id;
  String? name;
  String? email;
  String? role;
  String? timezone;

  OrganizerId({this.id, this.name, this.email, this.role, this.timezone});

  factory OrganizerId.fromJson(Map<String, dynamic> json) {
    return OrganizerId(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'role': role,
        'timezone': timezone,
      };
}