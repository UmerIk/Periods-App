class UserModel{
  late String id , password , email , name , dateofbirth , image;


  UserModel(this.id, this.password, this.email, this.name, this.dateofbirth , this.image);

  UserModel.fromMap(Map<String , dynamic> data){
    id = data['id'];
    email = data['email'];
    name = data['name'];
    password = data['password'];
    dateofbirth = data['dateofbirth'];
    image = data['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name,
      'email' : email,
      'dateofbirth' : dateofbirth,
      'password' : password,
      'image' : image,
    };
  }
}