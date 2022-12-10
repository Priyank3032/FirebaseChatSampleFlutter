class Message {
  final String? text;
  final String? date;
  final int user_id;

  Message.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'],
        date = json['date'],
        user_id = json['user_id'];

  Message(this.text, this.date, this.user_id);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': text,
        'date': date,
        'user_id': user_id,
      };
}
