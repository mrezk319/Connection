class MessageModel {
  String? recieverId;
  String? senderId;
  String? date;
  String? text;

  MessageModel({
    this.recieverId,
    this.senderId,
    this.date,
    this.text,
  });

  Map<String,dynamic> toMap() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'date': date,
      'text': text,

    };
  }

  MessageModel.fromJson(Map<String,dynamic>? json){
    recieverId = json!['recieverId'];
    senderId = json['senderId'];
    date = json['date'];
    text = json['text'];
  }
}