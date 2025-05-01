
import 'package:equatable/equatable.dart';

// State
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
  
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Map<String, dynamic>> subscriptions;
  final String? subscriptionCode;

  const SubscriptionLoaded({
    required this.subscriptions,
    this.subscriptionCode,
  });

  SubscriptionLoaded copyWith({
    List<Map<String, dynamic>>? subscriptions,
    String? subscriptionCode,
  }) {
    return SubscriptionLoaded(
      subscriptions: subscriptions ?? this.subscriptions,
      subscriptionCode: subscriptionCode ?? this.subscriptionCode,
    );
  }

  @override
  List<Object?> get props => [subscriptions, subscriptionCode];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}