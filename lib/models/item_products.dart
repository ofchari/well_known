class Model1
{
  String? image;
  String? text;
  String? text1;

  Model1(this.image,this.text,this.text1);
}
List stich =  ite.map((e) => Model1(e["image"], e["text"], e["text1"])).toList();
var ite = [
  {"image":"https://i.pinimg.com/736x/6c/69/f9/6c69f9c4aa0bffc48cce9391fc4e4d43.jpg","text":"Item 1","text1":"Light is use for showing brightness to the room or anywhere "},
  {"image":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLmfborbDQkvv19sqAxBDjD1zJG2mAIEMxTi-pe6oiiw&s","text":"Item 2","text1":"Light is use for showing brightness to the room or anywhere  "},
  {"image":"https://s.alicdn.com/@sc04/kf/HTB1efVnXsfrK1RjSszcq6xGGFXaH.jpg_200x200.jpg","text":"Item 3","text1":"Light is use for showing brightness to the room or anywhere "},
  {"image":"https://images5.alphacoders.com/114/1142039.jpg","text":"Item 4","text1":"Light is use for showing brightness to the room or anywhere"},
  {"image":"https://images.unsplash.com/photo-1466027397211-20d0f2449a3f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2V3aW5nJTIwbWFjaGluZXxlbnwwfHwwfHx8MA%3D%3D","text":"Item 5","text1":"Light is use for showing brightness to the room or anywhere "},
  {"image":"https://img.freepik.com/premium-photo/close-up-sewing-machine-with-hands-working_41969-2495.jpg","text":"Item 6","text1":"Light is use for showing brightness to the room or anywhere "},
];