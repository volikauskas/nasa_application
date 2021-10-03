class SearchRes {
  SearchRes({
    required this.results,
    required this.averagesPerDay,
    required this.userValues,
  });
  List<Results> results = [];
  AveragesPerDay averagesPerDay = AveragesPerDay(L: 0, T: 0, H: 0, W: 0);
  UserValues userValues = UserValues(L: 0, T: 0, H: 0, W: 0);

  SearchRes.fromJson(Map<String, dynamic> json) {
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
    averagesPerDay = AveragesPerDay.fromJson(json['averages_per_day']);
    userValues = UserValues.fromJson(json['user_values']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['results'] = results.map((e) => e.toJson()).toList();
    _data['averages_per_day'] = averagesPerDay.toJson();
    _data['user_values'] = userValues.toJson();
    return _data;
  }
}

class Results {
  Results({
    required this.values,
  });
  List<String> values = [];

  Results.fromJson(Map<String, dynamic> json) {
    values = List.castFrom<dynamic, String>(json['values']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['values'] = values;
    return _data;
  }
}

class AveragesPerDay {
  AveragesPerDay({
    required this.L,
    required this.T,
    required this.H,
    required this.W,
  });
  late final double L;
  late final double T;
  late final double H;
  late final double W;

  AveragesPerDay.fromJson(Map<String, dynamic> json) {
    L = json['L'];
    T = json['T'];
    H = json['H'];
    W = json['W'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['L'] = L;
    _data['T'] = T;
    _data['H'] = H;
    _data['W'] = W;
    return _data;
  }
}

class UserValues {
  UserValues({
    required this.L,
    required this.T,
    required this.H,
    required this.W,
  });
  late final int L;
  late final int T;
  late final int H;
  late final int W;

  UserValues.fromJson(Map<String, dynamic> json) {
    L = json['L'];
    T = json['T'];
    H = json['H'];
    W = json['W'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['L'] = L;
    _data['T'] = T;
    _data['H'] = H;
    _data['W'] = W;
    return _data;
  }
}
