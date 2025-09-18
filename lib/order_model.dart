class inputbox {
  String title;
  String shortdescription;
  String longdescription;
  String Date;
  String status;
  String? imagePath;

  inputbox({
    required this.title,
    required this.shortdescription,
    required this.longdescription,
    required this.Date,
    required this.status,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'shortdescription': shortdescription,
    'longdescription': longdescription,
    'Date': Date,
    'status': status,
    'imagePath': imagePath,
  };

  factory inputbox.fromJson(Map<String, dynamic> json) => inputbox(
    title: json['title'],
    shortdescription: json['shortdescription'],
    longdescription: json['longdescription'],
    Date: json['Date'],
    status: json['status'],
    imagePath: json['imagePath'],
  );
}
