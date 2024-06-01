class Model2
{
  String? image;
  String? text;
  String? text1;
  String? text2;
  String? text3;
  Model2(this.image,this.text,this.text1,this.text2,this.text3);
}
List lis = pcss.map((e) => Model2(e["image"], e["text"], e["text1"], e["text2"], e["text3"])).toList();
var pcss = [
  {"image":"https://img.freepik.com/premium-photo/close-up-sewing-machine-with-hands-working_41969-2495.jpg","text":"Item 1","text1":"Rate : 0.0","text2":"Item group 1","text3":"PCS"},
  {"image":"https://www.shutterstock.com/shutterstock/videos/991390/thumb/1.jpg?ip=x480","text":"Item 2","text1":"Rate : 2.5","text2":"Item group 2","text3":"BOX"},
  {"image":"https://p0.pxfuel.com/preview/30/696/865/sewing-machine-fabric-cloth.jpg","text":"Item 3","text1":"Rate : 3.4","text2":"Item group 3","text3":"SET"},
  {"image":"https://t4.ftcdn.net/jpg/02/90/59/49/360_F_290594960_gR9yFDKLuaEPxR2xJ4VbmdiWE2CDQWEw.jpg","text":"Item 4","text1":"Rate : 4.4","text2":"Item group 4","text3":"PCS"},
  {"image":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9_J7qTBKFZH4KDtGjQBgyeMrvoXFfC3Cm-tdzNtODdz1cDOj21c1VSjGfMwoxylee06c&usqp=CAU","text":"Item 5","text1":"Rate : 7.0","text2":"Item group 5","text3":"BOX"},
  {"image":"https://burst.shopifycdn.com/photos/angled-view-of-sewing-machine-use.jpg?width=1000&format=pjpg&exif=0&iptc=0","text":"Item 6","text1":"Rate : 6.1","text2":"Item group 6","text3":"SET"},
];