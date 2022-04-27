import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  String _phone = '';
  get selectedIndex => _selectedIndex;
  get phone => _phone;
  void changeIndex(int index) {
    
    _selectedIndex = index;
    notifyListeners();
  }
  //just to trying send phone number to another page
  void setNewPhone(String phone){
    _phone = phone;
    notifyListeners();
  }

  

  
}
