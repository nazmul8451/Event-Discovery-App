class ChatModel {
  String? name;
  String? currentMessage;
  String? imageIcon;
  String? time;
  bool? isGroup;
  String? status;
  String? id;
  String? otherUserId;

  ChatModel({
    this.name,
    this.id,
    this.otherUserId,
    this.currentMessage,
    this.imageIcon,
    this.isGroup,
    this.status,
    this.time,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      name: json['name'],
      id: json['_id'] ?? json['id'],
      otherUserId: json['otherUserId'],
      currentMessage: json['currentMessage'],
      imageIcon: json['imageIcon'],
      isGroup: json['isGroup'],
      status: json['status'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      '_id': id,
      'otherUserId': otherUserId,
      'currentMessage': currentMessage,
      'imageIcon': imageIcon,
      'isGroup': isGroup,
      'status': status,
      'time': time,
    };
  }
}
