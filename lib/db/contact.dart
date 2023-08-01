class Contact {
  final String id;
  final String name;
  final String phone;
  final String editTime;

  Contact({required this.id, required this.name, required this.phone, required this.editTime});

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'phone' : phone,
      'editTime' : editTime
    };
  }

  @override
  String toString(){
    return 'Contact{id: $id, name : $name, phone : $phone, editTime : $editTime}';
  }
}