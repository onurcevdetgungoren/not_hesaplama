import 'package:flutter/material.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:not_sepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  NotDetay({this.baslik});
  //Buraya gelirken 1 adet başlık öğesi taşınacak
  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var _fKey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler;
  DatabaseHelper _dbHelper;
  int kategoriID = 1;
  //DropDownda seçilen kategorinin idsini tutmak için
  static var _oncelik = ["düşük", "orta", "yüksek"];
  //Önceliğin belirtileceği DropDownda bunu kullanacağız.
  int secilenOncelik = 0;
  //Öncelik seçerken seçilen önceliğği buraya atacağız.
  String notBaslik, notIcerik;
  var _sKey = GlobalKey<ScaffoldState>();
  //SnackBar için yapıldı

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategori>();
    _dbHelper = DatabaseHelper();
    _dbHelper.kategorileriGetir().then((value) {
      for (Map gezici in value) {
        tumKategoriler.add(Kategori.fromMap(gezici));
      }
      setState(() {});
      //Yapıların Tamamının güncellenmesi için SetState ekledik
    }).catchError((onError) => print("Hata : " + onError));
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sKey,
      resizeToAvoidBottomPadding: false,
    
      appBar: AppBar(
        title: Text(widget.baslik),
        centerTitle: true,
      ),
      body: tumKategoriler.length <= 0
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Form(
                  key: _fKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Kategori:",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 24),
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.redAccent, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: kategoriItemleriOlustur(),
                                    value: kategoriID,
                                    onChanged:
                                        (dropdownItemlardanSecilenKategoriID) {
                                      setState(() {
                                        kategoriID =
                                            dropdownItemlardanSecilenKategoriID;
                                      });
                                    })),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Not Başlığını Giriniz",
                            labelText: "Başlık",
                            border: OutlineInputBorder(),
                          ),
                          validator: (s) {
                            if (s.length < 3) {
                              return "3 Karakterden Fazla Girmelisiniz";
                            } else
                              return null;
                          },
                          onSaved: (kaydedilecekDeger) {
                            setState(() {
                              notBaslik = kaydedilecekDeger;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Not İçeriğini Giriniz",
                            labelText: "İçerik",
                            border: OutlineInputBorder(),
                          ),
                          validator: (s) {
                            if (s.length < 3) {
                              return "3 Karakterden Fazla Girmelisiniz";
                            } else
                              return null;
                          },
                          onSaved: (kaydedilecekDeger) {
                            setState(() {
                              notIcerik = kaydedilecekDeger;
                            });
                          },
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Öncelik :",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 24),
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.redAccent, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: _oncelik.map((e) {
                                      return DropdownMenuItem<int>(
                                        child: Text(e,
                                            style: TextStyle(fontSize: 24)),
                                        value: _oncelik.indexOf(e),
                                      );
                                    }).toList(),
                                    value: secilenOncelik,
                                    onChanged:
                                        (dropdownItemlardanSecilenOncelik) {
                                      setState(() {
                                        secilenOncelik =
                                            dropdownItemlardanSecilenOncelik;
                                      });
                                    })),
                          ),
                        ],
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                     
                        mainAxisSize: MainAxisSize.min,
                      
                        children: <Widget>[
                          RaisedButton(
                              child: Text("Vazgeç"),
                              color: Colors.grey,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          RaisedButton(
                              child: Text("Kaydet",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              color: Colors.redAccent.shade700,
                              onPressed: () {

                                if (_fKey.currentState.validate()) {
                                  _fKey.currentState.save();
                                  var simdi = DateTime.now();
              
                                  _dbHelper
                                      .notEkle(Not(kategoriID, notBaslik,
                                          notIcerik, simdi.toString(), secilenOncelik))
                                      .then((eklenenDegerIDsi) {
                                    if (eklenenDegerIDsi != 0) {
                                      setState(() {
                                        _sKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text("1 Adet Not Eklendi"),
                                          duration: Duration(seconds: 5),
                                        ));
                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                }
                              }),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleriOlustur() {

    return tumKategoriler
        .map((gelenKategori) => DropdownMenuItem(
              child: Text(
                gelenKategori.kategoriBaslik,
                style: TextStyle(fontSize: 24),
              ),
              value: gelenKategori.kategoriID,
            ))
        .toList();
  }
}

