class Kategori {
  int kategoriID;
  String kategoriBaslik;

  Kategori(this.kategoriBaslik);

  Kategori.withID(this.kategoriID, this.kategoriBaslik);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["kategoriID"] = kategoriID;
    map["kategoriBaslik"] = kategoriBaslik;

    return map;
  }

  Kategori.fromMap(Map<String, dynamic> maptenGelen) {
    this.kategoriID = maptenGelen["kategoriID"];
    this.kategoriBaslik = maptenGelen["kategoriBaslik"];
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Kategori{kategoriID: $kategoriID, kategoriBaslik = $kategoriBaslik}';

  }
}
