class Typing {
  final bool isTyping;

  Typing.fromJson(Map<dynamic, dynamic> json) : isTyping = json['isTyping'];

  Typing(this.isTyping);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'isTyping': isTyping,
      };
}
