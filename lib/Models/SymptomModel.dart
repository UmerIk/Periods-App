class SymptomModel{
  late String key , note , date;
  late int symptom , sex , vd , mood;

  SymptomModel(this.key, this.note, this.symptom, this.sex, this.vd, this.mood , this.date);

  SymptomModel.fromData(Map<String , dynamic> data){
   key = data["key"];
   note = data["note"];
   date = data["date"];

   symptom = data["symptom"];
   sex = data["sex"];
   vd = data["vd"];
   mood = data["mood"];
  }


  Map<String , dynamic> toMap(){
    return{
      "key" : key,
      "note" : note,
      "date" : date,

      "symptom" : symptom ,
      "sex" : sex ,
      "vd" : vd ,
      "mood" : mood,
    };
  }
}