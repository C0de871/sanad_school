// Cubit
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_result.dart';
import 'package:sanad_school/features/subscription/presentation/cubits/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial()) {
    loadSubscriptions();
  }

  final TextEditingController codeController = TextEditingController();

  final List<Map<String, dynamic>> _initialSubscriptions = [
    {
      'subject': 'الرياضيات',
      'code': 'MATH2024',
      'price': '\$49.99',
    },
    {
      'subject': 'الفيزياء',
      'code': 'PHYS2024',
      'price': '\$39.99',
    },
  ];

  void loadSubscriptions() {
    emit(SubscriptionLoading());

    // In a real app, you would fetch this data from a repository/API
    // Here we're using the hardcoded data from the original widget
    emit(SubscriptionLoaded(subscriptions: _initialSubscriptions));
  }

  void setSubscriptionCode(String code) {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;
      emit(currentState.copyWith(subscriptionCode: code));
    }
  }

  void handleQrResult(QrCodeResult? result) {
    log("from handle result ${result?.code ?? " code not found"}");
    codeController.text = result?.code ?? "";
  }

  void addSubscription() {
    // This would typically involve an API call to validate and add the subscription
    // For now, just demonstrate the state management flow
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;

      // Here you would validate the code and add it to the user's subscriptions
      // For this example, we'll just add a dummy subscription
      final newSubscription = {
        'subject': 'اشتراك جديد',
        'code': codeController.text,
        'price': '\$29.99',
      };

      final updatedSubscriptions = List<Map<String, dynamic>>.from(currentState.subscriptions)..add(newSubscription);

      emit(SubscriptionLoaded(subscriptions: updatedSubscriptions));
    }
  }
}
