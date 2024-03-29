import 'package:sozluk_uygulamasi/Kelimeler.dart';
import 'package:sozluk_uygulamasi/VeritabaniYardimcisi.dart';

class Kelimelerdao{

  Future<List<Kelimeler>>tum_kelimeler() async{
    var db=await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>>maps=await db.rawQuery("SELECT * FROM kelimeler");
    return List.generate(maps.length, (i){

      var satir=maps[i];
      return Kelimeler(satir["kelime_id"], satir["ingilizce"],satir["turkce"]);
      
    });


  }

  Future<List<Kelimeler>>kelime_ara(String arama_kelimesi) async{
    var db=await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>>maps=await db.rawQuery("SELECT * FROM kelimeler WHERE ingilizce like '%$arama_kelimesi%'");
    return List.generate(maps.length, (i){

      var satir=maps[i];
      return Kelimeler(satir["kelime_id"], satir["ingilizce"],satir["turkce"]);

    });


  }


}