import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/WaleeeeIcon.jpeg", height: 50,),
  );
}

InputDecoration getTextFieldDeco(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Colors.white60,
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white60)
    ),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white60)
    )
  );
}

TextStyle getTextStyle(){
  return const TextStyle(
    color: Colors.black54,
  );
}

TextStyle simpleTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}
