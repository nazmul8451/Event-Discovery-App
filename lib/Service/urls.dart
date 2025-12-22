class Urls {
  static const String baseUrl = "http://10.10.7.11:5005";
  static const String registrationUrl = "$baseUrl/api/v1/auth/signup";
  static const String loginUrl = "$baseUrl/api/v1/auth/login";
  static const String forgotpassUrl = "$baseUrl/api/v1/auth/forget-password";
  static const String verifyOtpUrl = "$baseUrl/api/v1/auth/verify-account";
  static const String resetPassUrl = "$baseUrl/api/v1/auth/reset-password";
  static const String getAllEvent = "$baseUrl/api/v1/event";
  static String getSingleEvent(String eventID) =>
      "$baseUrl/api/v1/event/$eventID";
  static const String reviewUrl = "$baseUrl/api/v1/review";
  static const String getAllReviewUrl = "$baseUrl/api/v1/review";
  static String getReviewByEventIdUrl(String eventId) {
    return "$baseUrl/api/v1/review?eventId=$eventId";
  }

  static const String userProfileUrl = "$baseUrl/api/v1/user/profile";
  static const String updateProfileUrl = "$baseUrl/api/v1/user/profile";
  static const String addSaveEvent = "$baseUrl/api/v1/saved";
  static const String getMySaveEvents = '$baseUrl/api/v1/saved?filter=all';
  static String deleteSavedEvent (String id) => "$baseUrl/api/v1/saved/$id";
}
