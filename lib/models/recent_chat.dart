class RecentChat {
  final String lastMessage;
  final String fullName;
  final String picUrl;
  final String docUrl;
  final String color;
  final String messageId;
  final Map unseen;
  final String time;
  final String friendId;

  RecentChat({
    this.messageId,
    this.unseen,
    this.docUrl,
    this.time,
    this.picUrl,
    this.fullName,
    this.color,
    this.lastMessage,
    this.friendId,
  });

  Map<String, dynamic> toMap() {
    return {
      "document": docUrl,
      "userId": friendId,
      "fullname": fullName,
      "picture": picUrl,
      "color": "green",
      "lastmessage": lastMessage,
      "unseen": unseen,
      "time": time,
      "messageId":messageId
    };
  }
}
