import 'package:flutter/material.dart';

class StickerPackListProvderClass extends ChangeNotifier{
  List<List<String>> stickerPackList = [
  ];
  
  bool addSticker(List<String> stickerPack){
    if(stickerPack.length > 30){
      return false;
    }
    stickerPackList.add(stickerPack);
    notifyListeners();
    return true;
  }
  
  bool isPresent(String stickerPack){
    for(int i = 0; i < stickerPackList.length; i++){
      if(stickerPackList[i][0] == stickerPack){
        return true;
      }
    }
    return false;
  }

  void clearStickerPack(){
    stickerPackList.clear();
    notifyListeners();
  }

  void removeSticker(String sticker){
    for(int i = 0; i < stickerPackList.length; i++){
      if(stickerPackList[i][0] == sticker){
        stickerPackList.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }
  
  void updateStickerPack(List<List<String>> stickerPack){
    stickerPackList = stickerPack;
    notifyListeners();
  }
  
  void clearStickerPackList(){
    stickerPackList.clear();
    notifyListeners();
  }
}