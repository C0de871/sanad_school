import 'package:equatable/equatable.dart';

import '../../domain/entities/code_entity.dart';

// State
sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final int count;
  final List<CodeEntity> codes;
  final String? subscriptionCode;

  const SubscriptionLoaded({required this.count, required this.codes, this.subscriptionCode});

  SubscriptionLoaded copyWith({
    int? count,
    List<CodeEntity>? codes,
    String? subscriptionCode,
  }) {
    return SubscriptionLoaded(
      count: count ?? this.count,
      codes: codes ?? this.codes,
      subscriptionCode: subscriptionCode ?? this.subscriptionCode,
    );
  }

  @override
  List<Object?> get props => [count, codes, subscriptionCode];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddCodeLoading extends SubscriptionLoaded {
  const AddCodeLoading({
    required super.count,
    required super.codes,
    required super.subscriptionCode,
  });
}

class AddCodeLoaded extends SubscriptionLoaded {
  final CodeEntity codeEntity;
  const AddCodeLoaded({
    required this.codeEntity,
    required super.count,
    required super.codes,
    required super.subscriptionCode,
  });
}

class AddCodeFailure extends SubscriptionLoaded {
  final String errMessage;
  const AddCodeFailure({
    required super.count,
    required super.codes,
    required this.errMessage,
    required super.subscriptionCode,
  });
}
