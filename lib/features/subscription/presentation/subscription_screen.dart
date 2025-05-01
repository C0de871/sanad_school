import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanad_school/core/Routes/app_routes.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_result.dart';
import 'package:sanad_school/core/utils/services/qr_service/scanner_cubit.dart';
import 'package:sanad_school/features/subscription/presentation/cubits/subscription_cubit.dart';
import 'package:sanad_school/features/subscription/presentation/cubits/subscription_state.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubscriptionScreenContent();
  }
}

class _SubscriptionScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'اشتراكاتي',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
      ),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SubscriptionError) {
            return Center(child: Text(state.message));
          } else if (state is SubscriptionLoaded) {
            return _buildSubscriptionList(context, state.subscriptions);
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: AnimatedRaisedButton(
          onPressed: () => _showSubscriptionDialog(context),
          text: 'اضف اشتراك',
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
        ),
      ),
    );
  }

  Widget _buildSubscriptionList(BuildContext context, List<Map<String, dynamic>> subscriptions) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'الاشتراكات السارية',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 600 + (index * 100)),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Card(
                      elevation: 2,
                      shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subscriptions[index]['subject'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الكود: ${subscriptions[index]['code']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  subscriptions[index]['price'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: subscriptions.length,
            ),
          ),
        ),
      ],
    );
  }

  void _showSubscriptionDialog(BuildContext parentContext) {
    showGeneralDialog(
      context: parentContext,
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return BlocProvider.value(
          value: parentContext.read<SubscriptionCubit>(),
          child: BackdropFilter(
            filter: ColorFilter.mode(
              Colors.black.withOpacity(animation1.value * 0.5),
              BlendMode.srcOver,
            ),
            child: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                builder: (context, state) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'اضف اشتراك جديد',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: context.read<SubscriptionCubit>().codeController,
                            onChanged: (value) {
                              context.read<SubscriptionCubit>().setSubscriptionCode(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'ادخل رمز الاشتراك',
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(height: 20),
                          AnimatedRaisedButton(
                            onPressed: () async {
                              QrCodeResult? result = await Navigator.pushNamed<QrCodeResult>(context, AppRoutes.qrScanner);
                              log(result?.code ?? "where is the code");
                              parentContext.read<SubscriptionCubit>().handleQrResult(result);
                            },
                            text: 'امسح رمز الاشتراك',
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'الغاء',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AnimatedRaisedButton(
                        onPressed: () {
                          context.read<SubscriptionCubit>().addSubscription();
                          Navigator.pop(context);
                        },
                        text: 'تأكيد',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
    );
  }
}
