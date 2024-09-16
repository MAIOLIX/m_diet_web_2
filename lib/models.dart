class Result {
  List<FoodGroup> result;

  Result({required this.result});

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['result'] as List;
    List<FoodGroup> foodGroups =
        list.map((i) => FoodGroup.fromJson(i)).toList();
    return Result(result: foodGroups);
  }

  void addFoodGroup(FoodGroup f) {
    result.add(f);
  }
}

class FoodGroup {
  List<FoodItem> foodFound;

  FoodGroup({required this.foodFound});

  factory FoodGroup.fromJson(Map<String, dynamic> json) {
    var list = json['food_found'] as List;
    List<FoodItem> foods = list.map((i) => FoodItem.fromJson(i)).toList();
    return FoodGroup(foodFound: foods);
  }
}

class FoodItem {
  String name;
  int quantity;
  double confidence;
  String imageUrl;
  bool selected;
  bool isMain;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.confidence,
    required this.imageUrl,
    required this.selected,
    required this.isMain,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      quantity: json['quantity'],
      confidence: ((json['confidence'] as num)).toDouble(),
      imageUrl: json['image_url'],
      selected: json['selected'],
      isMain: json['is_main'],
    );
  }
}
