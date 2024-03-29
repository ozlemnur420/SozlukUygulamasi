import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi/Detay_sayfa.dart';
import 'package:sozluk_uygulamasi/Kelimeler.dart';
import 'package:sozluk_uygulamasi/Kelimelerdao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Anasayfa(title: ""),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key, required this.title});

  final String title;

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool arama_yapiliyor_mu=false;
  String arama_kelimesi="";

  Future<List<Kelimeler>>tum_kelimeleri_goster() async{
    var kelimeler_liste=await Kelimelerdao().tum_kelimeler();

    return kelimeler_liste;

  }

  Future<List<Kelimeler>>arama_yap(arama_kelimesi) async{
    var kelimeler_liste=await Kelimelerdao().kelime_ara(arama_kelimesi);

    return kelimeler_liste;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: arama_yapiliyor_mu ?
            TextField(
              decoration: InputDecoration(
                hintText: "Aramak için bir şey yazınız",
              ),
              onChanged: (arama_sonucu){
                print("Arama sonucu: $arama_sonucu");
                setState(() {
                  arama_kelimesi=arama_sonucu;
                });
              },
            )
            : Text("SÖZLÜK UYGULAMASI"),
        actions: [
         arama_yapiliyor_mu ?
       IconButton(     // true durumu
       icon: Icon(Icons.cancel_outlined),
       onPressed: (){
         setState(() {
           arama_yapiliyor_mu=false;
           arama_kelimesi="";

         });
       },
     )
          : IconButton(  // false durumu
            icon: Icon(Icons.search_rounded),
            onPressed: (){
              setState(() {
                arama_yapiliyor_mu=true;

              });
            },
          ),
          

        ],
      ),
      body: FutureBuilder<List<Kelimeler>>(
        future: arama_yapiliyor_mu ? arama_yap(arama_kelimesi): tum_kelimeleri_goster(),
        builder: (context,snapshot){
          if(snapshot.hasData){

            var kelimeler_liste=snapshot.data;
            return ListView.builder(
              itemCount: kelimeler_liste !.length,
              itemBuilder: (context,indeks){
                var kelime=kelimeler_liste[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Detay_sayfa(kelime: kelime,)));
                  },
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                    
                          Text(kelime.ingilizce,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.black),),
                          Text(kelime.turkce,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.indigo),),
                        ],

                      ),
                    ),
                  ),
                );

              },

            );
          }

          else{
            return Center();
          }
        },

      ),

    );
  }
}
