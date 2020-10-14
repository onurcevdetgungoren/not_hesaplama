import 'package:flutter/material.dart';
import 'package:not_sepeti/not_detay.dart';
import 'package:not_sepeti/utils/database_helper.dart';

import 'models/kategori.dart';
import 'models/notlar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  DatabaseHelper dbHelper = DatabaseHelper();
  var _fKey = GlobalKey<FormState>();
  //TextEditingController myTextFieldController = TextEditingController();
  //FormKey anahtarı //Kaydetme işlemini bununlada Yapabilirdik ancak, Biz String değişkene atıp TextFieldın onSave ini kullandık
  String kaydedilecekDeger;
  //TextFieldda yazılan değeri bununla tutup Kaydet butonundan kaydettik
  var _sKey = GlobalKey<ScaffoldState>();
  //SnackBar çıkartmak için bir Scaffold Key tuttuk
  String hero1 = "KategoriEkle";
  String hero2 = "NotEkle";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sKey,
      //Scaffolda SnackBar çıkartmak için ScaffolKey ekledik
      appBar: AppBar(
        title: Center(
          child: Text("Not Sepeti"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: hero1,
            onPressed: () {
              kategoriEkleDialog(context);
            },
            child: Icon(Icons.add_circle),
            mini: true,
            tooltip: "Kategori Ekle",
          ),
          FloatingActionButton(
            heroTag: hero2,
            onPressed: () => _detaySayfasinaGit(context),
           
            child: Icon(Icons.add),
            tooltip: "Not Ekle",
          ),
        ],
      ),
      body: Notlar(),
      
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
             
            ),
            children: <Widget>[
            
              Form(
                  key: _fKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
             
                      decoration: InputDecoration(
                        labelText: "Kategori Adı",
                        border: OutlineInputBorder(),
                      ),
                      validator: (s) {
                        if (s.length < 3) {
                          return "3 Karakterden Fazla Olmalı";
                        }
                        return null;
                      },
                      onSaved: (yazilanDeger) {
                        kaydedilecekDeger = yazilanDeger;
                      },
                    ),
                  )),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                     
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_fKey.currentState.validate()) {
                        _fKey.currentState.save();
                        
                        dbHelper
                            .kategoriEkle(Kategori(kaydedilecekDeger))
                            .then((donenKategoriID) {
                          if (donenKategoriID > 0) {
                            print("Kategori Eklendi: $donenKategoriID");
                          }
                        });
                      }
                      Navigator.pop(context);
                     
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void yeniKategoriEkle(Kategori kategori) async {
    var donenDeger = await dbHelper.kategoriEkle(kategori);

    if (donenDeger > 0) {
      _sKey.currentState.showSnackBar(SnackBar(
        content: Text("$donenDeger Id si İle Yeni Kategori Eklendi"),
        duration: Duration(seconds: 5),
      ));
    }
  }

  _detaySayfasinaGit(BuildContext context) {

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Yeni Not",
                )));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  DatabaseHelper dbHelper;
  List<Not> tumNotlar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper();
    tumNotlar = List<Not>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbHelper.notListesiGetir(),
        builder: (context, AsyncSnapshot<List<Not>> sonuc) {
          if (sonuc.hasData) {
            tumNotlar = sonuc.data;
            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(tumNotlar[index].notBaslik),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Kategori: ",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tumNotlar[index].kategoriBaslik,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Oluşturulma Tarihi: ",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tumNotlar[index].kategoriBaslik,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}
