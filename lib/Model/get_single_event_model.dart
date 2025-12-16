class SingleEventDataModel {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  SingleEventDataModel(
      {this.statusCode, this.success, this.message, this.data});

  SingleEventDataModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Location? location;
  String? sId;
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
  String? id;

  Data(
      {this.location,
      this.sId,
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
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    category = json['category'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : [];
    organizerId = json['organizerId'] != null
        ? OrganizerId.fromJson(json['organizerId'])
        : null;
    status = json['status'];
    visibility = json['visibility'];
    startDate = json['startDate'];
    startTime = json['startTime'];
    locationType = json['locationType'];
    address = json['address'];
    capacity = json['capacity'];
    ticketsSold = json['ticketsSold'];
    ticketPrice = json['ticketPrice'];
    images = json['images'] != null ? List<String>.from(json['images']) : [];
    gallery = json['gallery'] != null ? List<String>.from(json['gallery']) : [];
    views = json['views'];
    favorites = json['favorites'];
    hasLiveStream = json['hasLiveStream'];
    liveStreamId = json['liveStreamId'];
    isStreamingActive = json['isStreamingActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['category'] = this.category;
    data['tags'] = this.tags;
    if (this.organizerId != null) {
      data['organizerId'] = this.organizerId!.toJson();
    }
    data['status'] = this.status;
    data['visibility'] = this.visibility;
    data['startDate'] = this.startDate;
    data['startTime'] = this.startTime;
    data['locationType'] = this.locationType;
    data['address'] = this.address;
    data['capacity'] = this.capacity;
    data['ticketsSold'] = this.ticketsSold;
    data['ticketPrice'] = this.ticketPrice;
    data['images'] = this.images;
    data['gallery'] = this.gallery ?? [];
    data['views'] = this.views;
    data['favorites'] = this.favorites;
    data['hasLiveStream'] = this.hasLiveStream;
    data['liveStreamId'] = this.liveStreamId;
    data['isStreamingActive'] = this.isStreamingActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class OrganizerId {
  String? sId;
  String? name;
  String? email;
  String? role;
  String? timezone;

  OrganizerId({this.sId, this.name, this.email, this.role, this.timezone});

  OrganizerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['timezone'] = this.timezone;
    return data;
  }
}
