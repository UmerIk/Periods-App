class JournalModel{
  late String title , image , key , description;
  late int date;

  JournalModel(this.title, this.image, this.key, this.description, this.date);

  JournalModel.fromMap(Map<dynamic , dynamic> data){
    title = data['title'];
    image = data['image'];
    key = data['key'];
    description = data['description'];
    date = data['date'];
  }

  Map<String , dynamic> toMap(){
    return{
      "title" : title,
      "image" : image ,
      "key" : key ,
      "description" : description,
      "date" : date,
    };
  }
}