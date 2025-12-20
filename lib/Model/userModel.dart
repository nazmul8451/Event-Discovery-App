class UserProfileModel {
  final Location? location;
  final Settings? settings;
  final String? id;
  final String? name;
  final String? email;
  final List<String>? interest;
  final String? status;
  final bool? verified;
  final bool? subscribe;
  final String? role;
  final String? timezone;
  final String ? description;
  final bool? isOnboardingComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    required this.description,
    required this.location,
    required this.settings,
    required this.id,
    required this.name,
    required this.email,
    required this.interest,
    required this.status,
    required this.verified,
    required this.subscribe,
    required this.role,
    required this.timezone,
    required this.isOnboardingComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  // API response থেকে model বানানো
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      location: Location.fromJson(json['location'] ?? {}),
      settings: Settings.fromJson(json['settings'] ?? {}),
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      interest: List<String>.from(json['interest'] ?? []),
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
      subscribe: json['subscribe'] ?? false,
      role: json['role'] ?? '',
      timezone: json['timezone'] ?? '',
      isOnboardingComplete: json['isOnboardingComplete'] ?? false,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "location": location,
      "settings": settings,
      "name": name,
      "email": email,
      "interest": interest,
      "timezone": timezone,
      "description": description,
      "isOnboardingComplete": isOnboardingComplete,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    var coords = json['coordinates'] ?? [0.0, 0.0];
    List<double> coordinates;
    if (coords is List) {
      coordinates = coords.map((e) => (e as num).toDouble()).toList();
    } else {
      coordinates = [0.0, 0.0];
    }

    return Location(
      type: json['type']?.toString() ?? 'Point',
      coordinates: coordinates,
    );
  }

  Map<String, dynamic> toJson() {
    return {"type": type, "coordinates": coordinates};
  }
}

DateTime _parseDate(String? dateStr) {
  if (dateStr == null) return DateTime.now();
  try {
    return DateTime.parse(dateStr);
  } catch (e) {
    return DateTime.now();
  }
}

class Settings {
  final bool pushNotification;
  final bool emailNotification;
  final bool locationService;
  final String profileStatus;

  Settings({
    required this.pushNotification,
    required this.emailNotification,
    required this.locationService,
    required this.profileStatus,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      pushNotification: json['pushNotification'] ?? true,
      emailNotification: json['emailNotification'] ?? true,
      locationService: json['locationService'] ?? true,
      profileStatus: json['profileStatus'] ?? 'public',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pushNotification": pushNotification,
      "emailNotification": emailNotification,
      "locationService": locationService,
      "profileStatus": profileStatus,
    };
  }
}
