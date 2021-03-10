String PickerData2 = '''
[
    ${getPickerDataItem(0, 12, 1)},
    ${getPickerDataItem(0, 60, 1)},
    ${getPickerDataItem(10, 60, 10)}
]
    ''';

String getPickerDataItem(int begin, int max, int gap) {
  String output = "[";
  for (int i = begin; i < max; i += gap) {
    output = output + i.toString() + ',';
  }
  output = output + max.toString() + "]";
  print(output);
  return output;
}
