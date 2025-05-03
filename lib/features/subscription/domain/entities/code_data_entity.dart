import 'package:equatable/equatable.dart';

import 'code_entity.dart';

class CodeDataEntity extends Equatable {
  final int? count;
  final List<CodeEntity>? codes;

  const CodeDataEntity({
    this.count,
    this.codes,
  });

  @override
  List<Object?> get props => [count, codes];
}
