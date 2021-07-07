class PeriodModel{
  late int date;
  late int iwinter , ispring, isummer, ifall;


  PeriodModel(this.date,{this.iwinter = 7, this.ispring = 7 , this.ifall = 7 , this.isummer = 7});

  PeriodModel.fromMap(Map<String , dynamic> data){
    date = data['date'];
    iwinter = data['iwinter'];
    ispring = data['ispring'];
    isummer = data['isummer'];
    ifall = data['ifall'];
  }

  Map<String, dynamic> toMap() {
    return {
      'date' : date,
      'iwinter' : iwinter,
      'ispring' : ispring,
      'isummer' : isummer,
      'ifall' : ifall,

    };
  }
}