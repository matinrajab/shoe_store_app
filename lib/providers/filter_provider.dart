import 'package:flutter/material.dart';
import 'package:shoe_store_app/models/filter_model.dart';
import 'package:shoe_store_app/models/product_model.dart';

class FilterProvider with ChangeNotifier {
  Map<String, List<String>> _filterOptions = {
    'Name': [
      'Is',
      'Is not',
      'Contains',
      'Does not contain',
      'Starts with',
      'Ends with',
    ],
    'Price': [
      '=',
      '!=',
      '>',
      '<',
      '>=',
      '<=',
    ],
    'Create at': [
      'Is',
      'Is before',
      'Is after',
      'Is on or before',
      'Is on or after',
    ],
    'Category': [
      'Is',
      'Is not',
    ],
  };

  Map<String, List<String>> get filterOptions => _filterOptions;

  List<String> logic = ['AND', 'OR'];
  String _logicSelected = 'AND';
  final List<String> _logicGroupSelected = [];
  final List<List<FilterModel>> _filterGroup = [];
  final List<List<TextEditingController>> _textController = [];

  String get logicSelected => _logicSelected;
  set logicSelected(String logicSelected) {
    _logicSelected = logicSelected;
    notifyListeners();
  }

  List<String> get logicGroupSelected => _logicGroupSelected;
  void setLogicGroupSelected(int idx, String value) {
    _logicGroupSelected[idx] = value;
    notifyListeners();
  }

  List<List<FilterModel>> get filterGroup => _filterGroup;
  void setSectionFilterInGroup(int idx1, idx2, String value) {
    _filterGroup[idx1][idx2].section = value;
    notifyListeners();
  }
  void setOperationFilterInGroup(int idx1, idx2, String value) {
    _filterGroup[idx1][idx2].operation = value;
    notifyListeners();
  }
  void setValueFilterInGroup(int idx1, idx2, dynamic value) {
    _filterGroup[idx1][idx2].value = value;
    notifyListeners();
  }

  List<List<TextEditingController>> get textController => _textController;

  void addFilterInGroup(int idx){
    _filterGroup[idx].add(FilterModel(section: 'Name', operation: 'Is', value: ''));
    _textController[idx].add(TextEditingController());
    notifyListeners();
  }

  void addFilterGroup(){
    _filterGroup.add([]);
    _textController.add([]);
    _logicGroupSelected.add('AND');
    notifyListeners();
  }

  void clearFilterGroup(){
    _filterGroup.clear();
    _textController.clear();
    _logicGroupSelected.clear();
    notifyListeners();
  }

  boolIsMatch(ProductModel product, FilterModel filter) {
    if (filter.section == 'Name') {
      final productName = product.name!.toLowerCase();
      final input = filter.value.toLowerCase();
      switch (filter.operation) {
        case 'Is':
          return productName == input;
        case 'Is not':
          return productName != input;
        case 'Contains':
          return productName.contains(input);
        case 'Does not contain':
          return !productName.contains(input);
        case 'Starts with':
          return productName.startsWith(input);
        case 'Ends with':
          return productName.endsWith(input);
      }
    } else if (filter.section == 'Price') {
      final productPrice = product.price!;
      final input = filter.value;
      switch (filter.operation) {
        case '=':
          return productPrice == input;
        case '!=':
          return productPrice != input;
        case '>':
          return productPrice > input;
        case '<':
          return productPrice < input;
        case '>=':
          return productPrice >= input;
        case '<=':
          return productPrice <= input;
      }
    } else if (filter.section == 'Create at') {
      final productDate = DateTime(product.createdAt!.year, product.createdAt!.month, product.createdAt!.day);
      final List<String> arrInput = filter.value.split('-');
      final input = DateTime(int.parse(arrInput[0]), int.parse(arrInput[1]), int.parse(arrInput[2]));
      switch (filter.operation) {
        case 'Is':
          return productDate.isAtSameMomentAs(input);
        case 'Is before':
          return productDate.isBefore(input);
        case 'Is after':
          return productDate.isAfter(input);
        case 'Is on or before':
          return productDate.isAtSameMomentAs(input) || productDate.isBefore(input);
        case 'Is on or after':
          return productDate.isAtSameMomentAs(input) || productDate.isAfter(input);
      }
    } else if (filter.section == 'Category') {
      final productCategory = product.category!.name!.toLowerCase();
      final input = filter.value.toLowerCase();
      switch (filter.operation) {
        case 'Is':
          return productCategory == input;
        case 'Is not':
          return productCategory != input;
      }
    }
  }
}
