class PlantList {
  PlantList({
    required this.plants,
  });
  late final List<Plants> plants;

  PlantList.fromJson(Map<String, dynamic> json) {
    plants = List.from(json['plants']).map((e) => Plants.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['plants'] = plants.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Plants {
  Plants({
    required this.BotanicalName,
    required this.CommonName,
    required this.L,
    required this.T,
    required this.H,
    required this.W,
    required this.S,
  });
  late final String BotanicalName;
  late final String CommonName;
  late final String L;
  late final String T;
  late final String H;
  late final String W;
  late final String S;

  Plants.fromJson(Map<String, dynamic> json) {
    BotanicalName = json['Botanical_name'];
    CommonName = json['Common_name'];
    L = json['L'];
    T = json['T'];
    H = json['H'];
    W = json['W'];
    S = json['S'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Botanical_name'] = BotanicalName;
    _data['Common_name'] = CommonName;
    _data['L'] = L;
    _data['T'] = T;
    _data['H'] = H;
    _data['W'] = W;
    _data['S'] = S;
    return _data;
  }
}
