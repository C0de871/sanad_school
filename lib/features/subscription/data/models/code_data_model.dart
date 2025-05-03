import '../../domain/entities/code_data_entity.dart';
import 'code_model.dart';

class CodeDataModel extends CodeDataEntity {
  static const String countKey = 'count';
  static const String codesKey = 'codes';

  const CodeDataModel({
    super.count,
    super.codes,
  });

  factory CodeDataModel.fromMap(Map<String, dynamic> map) {
    return CodeDataModel(
      count: map[countKey],
      codes: List<CodeModel>.from(
        (map[codesKey] as List?)?.map((e) => CodeModel.fromMap(e)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      countKey: count,
      codesKey: codes?.map((e) => (e as CodeModel).toMap()).toList(),
    };
  }
}
