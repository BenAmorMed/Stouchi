import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/table_model.dart';

class TableService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'tables';

  Stream<List<TableModel>> getTables() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TableModel.fromJson(doc.data())).toList();
    });
  }

  Future<void> saveTable(TableModel table) async {
    await _firestore.collection(_collection).doc(table.id).set(table.toJson());
  }

  Future<void> deleteTable(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
  
  Future<void> updateTableStatus(String id, TableStatus status) async {
    await _firestore.collection(_collection).doc(id).update({
      'status': status.name,
    });
  }
}
