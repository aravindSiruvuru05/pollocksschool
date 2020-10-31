class ClassModel {
  String id;
  String name;
  String branch;

  ClassModel({this.id,this.name,this.branch});

  ClassModel.fromJson(Map<String,dynamic> json)
      : this.id = json['id'],
        this.name = json['name'],
        this.branch = json['branch'];
}