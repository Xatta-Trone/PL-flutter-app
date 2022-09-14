class KeyValueModel {
  String key;
  String value;

  KeyValueModel({required this.key, required this.value});

  // String toString() {
  //   return (value);
  // }

  String keyValueModelAsString() {
    return '$value-$key';
  }
}
