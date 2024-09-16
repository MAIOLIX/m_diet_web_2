import 'package:flutter/material.dart';
import 'models.dart';

class ResultDisplayWidget extends StatefulWidget {
  final Result result;

  ResultDisplayWidget({required this.result});

  @override
  _ResultDisplayWidgetState createState() => _ResultDisplayWidgetState();
}

class _ResultDisplayWidgetState extends State<ResultDisplayWidget> {
  late Result result;
  late List<FoodItem?>
      selectedItems; // Lista per tenere traccia degli elementi selezionati per ogni gruppo

  @override
  void initState() {
    super.initState();
    result = widget.result;

    // Inizializza selectedItems con l'elemento con is_main = true per ogni gruppo
    selectedItems = [];
    for (var group in result.result) {
      FoodItem? mainFoodItem = group.foodFound.firstWhere(
        (item) => item.isMain,
      );
      selectedItems.add(mainFoodItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: result.result.length,
      itemBuilder: (context, groupIndex) {
        FoodGroup group = result.result[groupIndex];

        // Trova l'alimento con is_main = true
        FoodItem? mainFoodItem = group.foodFound.firstWhere(
          (item) => item.isMain,
          orElse: () => group.foodFound.first,
        );

        // Ottieni l'elemento selezionato per questo gruppo
        FoodItem? selectedFoodItem = selectedItems[groupIndex];

        return Card(
          margin: EdgeInsets.all(8.0),
          child: ExpansionTile(
            // Usa il nome dell'alimento principale come titolo
            title: Text(
              mainFoodItem.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            initiallyExpanded: false,
            children: [
              // Mappa degli alimenti nel gruppo
              ...group.foodFound.map((foodItem) {
                return RadioListTile<FoodItem?>(
                  value: foodItem,
                  groupValue: selectedFoodItem,
                  title: Text(foodItem.name),
                  subtitle: Text(
                      'Quantità: ${foodItem.quantity}g - Confidenza: ${(foodItem.confidence * 100).toStringAsFixed(1)}%'),
                  secondary: foodItem.isMain
                      ? Icon(Icons.star, color: Colors.amber)
                      : null,
                  onChanged: (FoodItem? value) {
                    setState(() {
                      selectedItems[groupIndex] = value;
                    });
                  },
                );
              }).toList(),
              // Aggiungi l'opzione "Non presente"
            ],
          ),
        );
      },
    );
  }
}
