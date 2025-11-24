class ChatModel {
  String? name;
  String? currentMessage;
  String? imageIcon;
  String? time;
  bool? isGroup;
  String? status;
  int? id;

  ChatModel({
    this.name,
    this.id,
    this.currentMessage,
    this.imageIcon,
    this.isGroup,
    this.status,
    this.time,
  });
}
