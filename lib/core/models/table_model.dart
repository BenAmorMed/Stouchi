enum TableShape { rectangle, circle }
enum TableStatus { free, occupied, billed }

class TableModel {
  final String id;
  final String name;
  final double x;
  final double y;
  final double width;
  final double height;
  final TableShape shape;
  final TableStatus status;

  TableModel({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.shape = TableShape.rectangle,
    this.status = TableStatus.free,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] as String,
      name: json['name'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      shape: TableShape.values.firstWhere(
        (e) => e.name == json['shape'],
        orElse: () => TableShape.rectangle,
      ),
      status: TableStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TableStatus.free,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'shape': shape.name,
      'status': status.name,
    };
  }

  TableModel copyWith({
    String? id,
    String? name,
    double? x,
    double? y,
    double? width,
    double? height,
    TableShape? shape,
    TableStatus? status,
  }) {
    return TableModel(
      id: id ?? this.id,
      name: name ?? this.name,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      shape: shape ?? this.shape,
      status: status ?? this.status,
    );
  }
}
