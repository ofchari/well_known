class Model3
{
  String? text;
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  String? text5;
  String? text6;
  String? text7;
  Model3(this.text,this.text1,this.text2,this.text3,this.text4,this.text5,this.text6,this.text7);
}
List voice = invo.map((e) => Model3(e["text"],
    e["text1"], e["text2"], e["text3"], e["text4"], e["text5"], e["text6"], e["text7"])).toList();
var invo = [
  {"text":"INV-2324-00008","text1":"Regent Tech","text2":"25-05-2024","text3":"PS - 00004","text4":"30","text5":"RS.5656.0","text6":"null","text7":"null"},
  {"text":"INV-2324-00007","text1":"Anish Garments","text2":"25-03-2024","text3":"PS - 00005","text4":"60","text5":"RS.5625.0","text6":"null","text7":"null"},
  {"text":"INV-2324-00004","text1":" Zoya Garments","text2":"21-05-2024","text3":"PS - 00006","text4":"80","text5":"RS.4503.0","text6":"null","text7":"null"},
  {"text":"INV-2324-00006","text1":"Mernio Garments","text2":"22-06-2024","text3":"PS - 00007","text4":"20","text5":"RS.3003.0","text6":"null","text7":"null"},
  {"text":"INV-2324-00009","text1":"Glen Garments","text2":"25-12-2024","text3":"PS - 00008","text4":"50","text5":"RS.2200.0","text6":"null","text7":"null"},
];