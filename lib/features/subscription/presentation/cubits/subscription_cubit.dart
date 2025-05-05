// Cubit
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_result.dart';
import 'package:sanad_school/features/subscription/domain/use_cases/get_codes_use_case.dart';
import 'package:sanad_school/features/subscription/presentation/cubits/subscription_state.dart';

import '../../../../core/databases/params/params.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/use_cases/check_code_use_case.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetCodesUseCase getCodesUseCase;
  final CheckCodeUseCase checkCodeUseCase;

  SubscriptionCubit()
      : getCodesUseCase = getIt(),
        checkCodeUseCase = getIt(),
        super(SubscriptionInitial()) {
    loadSubscriptions();
  }

  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void loadSubscriptions() async {
    emit(SubscriptionLoading());

    emit(SubscriptionLoading());
    final result = await getCodesUseCase.call();
    result.fold(
      (failure) => emit(SubscriptionError(failure.errMessage)),
      (codeData) => emit(SubscriptionLoaded(
        count: codeData.count ?? 0,
        codes: codeData.codes ?? [],
      )),
    );
  }

  Future<void> checkCode() async {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;
      emit(AddCodeLoading(
        count: currentState.count,
        codes: currentState.codes,
        subscriptionCode: currentState.subscriptionCode,
      ));

      final params = CodeBody(code: codeController.text);
      // log("from check code ${params.toMap()}");
      final result = await checkCodeUseCase.call(params);
      // log("from check code ${result.fold((failure) => failure.errMessage, (code) => code.code)}");
      result.fold(
        (failure) => emit(AddCodeFailure(
          count: currentState.count,
          codes: currentState.codes,
          errMessage: failure.errMessage,
          subscriptionCode: currentState.subscriptionCode,
        )),
        (code) => emit(AddCodeLoaded(
          codeEntity: code,
          count: currentState.count,
          codes: currentState.codes,
          subscriptionCode: currentState.subscriptionCode,
        )),
      );
    }
  }

  void setSubscriptionCode(String code) {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;
      emit(currentState.copyWith(subscriptionCode: code));
    }
  }

  void handleQrResult(QrCodeResult? result) {
    // log("from handle result ${result?.code ?? " code not found"}");
    codeController.text = result?.code ?? "";
  }
}
