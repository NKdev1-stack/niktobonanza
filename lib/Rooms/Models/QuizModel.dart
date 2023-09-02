import 'dart:convert';
/// category : "music"
/// id : "622a1c397cc59eab6f950bee"
/// correctAnswer : "The Cure"
/// incorrectAnswers : ["Level 42","Deep Purple","Snow Patrol"]
/// question : {"text":"Which English rock band released the studio album 'Kiss Me, Kiss Me, Kiss Me'?"}
/// tags : ["music"]
/// type : "text_choice"
/// difficulty : "hard"
/// regions : []
/// isNiche : false

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));
String quizModelToJson(QuizModel data) => json.encode(data.toJson());
class QuizModel {
  QuizModel({
      String? category, 
      String? id, 
      String? correctAnswer, 
      List<String>? incorrectAnswers, 
      Question? question, 
      List<String>? tags, 
      String? type, 
      String? difficulty, 
      List<dynamic>? regions, 
      bool? isNiche,}){
    _category = category;
    _id = id;
    _correctAnswer = correctAnswer;
    _incorrectAnswers = incorrectAnswers;
    _question = question;
    _tags = tags;
    _type = type;
    _difficulty = difficulty;
    _regions = regions;
    _isNiche = isNiche;
}

  QuizModel.fromJson(dynamic json) {
    _category = json['category'];
    _id = json['id'];
    _correctAnswer = json['correctAnswer'];
    _incorrectAnswers = json['incorrectAnswers'] != null ? json['incorrectAnswers'].cast<String>() : [];
    _question = json['question'] != null ? Question.fromJson(json['question']) : null;
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _type = json['type'];
    _difficulty = json['difficulty'];
    if (json['regions'] != null) {
      _regions = [];
      json['regions'].forEach((v) {
      });
    }
    _isNiche = json['isNiche'];
  }
  String? _category;
  String? _id;
  String? _correctAnswer;
  List<String>? _incorrectAnswers;
  Question? _question;
  List<String>? _tags;
  String? _type;
  String? _difficulty;
  List<dynamic>? _regions;
  bool? _isNiche;
QuizModel copyWith({  String? category,
  String? id,
  String? correctAnswer,
  List<String>? incorrectAnswers,
  Question? question,
  List<String>? tags,
  String? type,
  String? difficulty,
  List<dynamic>? regions,
  bool? isNiche,
}) => QuizModel(  category: category ?? _category,
  id: id ?? _id,
  correctAnswer: correctAnswer ?? _correctAnswer,
  incorrectAnswers: incorrectAnswers ?? _incorrectAnswers,
  question: question ?? _question,
  tags: tags ?? _tags,
  type: type ?? _type,
  difficulty: difficulty ?? _difficulty,
  regions: regions ?? _regions,
  isNiche: isNiche ?? _isNiche,
);
  String? get category => _category;
  String? get id => _id;
  String? get correctAnswer => _correctAnswer;
  List<String>? get incorrectAnswers => _incorrectAnswers;
  Question? get question => _question;
  List<String>? get tags => _tags;
  String? get type => _type;
  String? get difficulty => _difficulty;
  List<dynamic>? get regions => _regions;
  bool? get isNiche => _isNiche;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = _category;
    map['id'] = _id;
    map['correctAnswer'] = _correctAnswer;
    map['incorrectAnswers'] = _incorrectAnswers;
    if (_question != null) {
      map['question'] = _question?.toJson();
    }
    map['tags'] = _tags;
    map['type'] = _type;
    map['difficulty'] = _difficulty;
    if (_regions != null) {
      map['regions'] = _regions?.map((v) => v.toJson()).toList();
    }
    map['isNiche'] = _isNiche;
    return map;
  }

}

/// text : "Which English rock band released the studio album 'Kiss Me, Kiss Me, Kiss Me'?"

Question questionFromJson(String str) => Question.fromJson(json.decode(str));
String questionToJson(Question data) => json.encode(data.toJson());
class Question {
  Question({
      String? text,}){
    _text = text;
}

  Question.fromJson(dynamic json) {
    _text = json['text'];
  }
  String? _text;
Question copyWith({  String? text,
}) => Question(  text: text ?? _text,
);
  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    return map;
  }

}