import 'dart:convert';

class GroupModel {
  final String name, id;

  GroupModel({
    required this.name,
    required this.id,
  });

  factory GroupModel.fromJson(Map<String, dynamic> jsonData) {
    return GroupModel(
      name: jsonData['name'],
      id: jsonData['id'],
    );
  }

  static Map<String, dynamic> toMap(GroupModel groupModel) => {
        'name': groupModel.name,
        'id': groupModel.id,
      };

  static String encode(List<GroupModel> groupModel) => json.encode(
        groupModel
            .map<Map<String, dynamic>>(
                (groupModel) => GroupModel.toMap(groupModel))
            .toList(),
      );

  static List<GroupModel> decode(String groupModel) =>
      (json.decode(groupModel) as List<dynamic>)
          .map<GroupModel>((item) => GroupModel.fromJson(item))
          .toList();
}
