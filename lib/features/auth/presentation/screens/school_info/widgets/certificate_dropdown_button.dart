import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../subject_type/domain/entities/type_entity.dart';
import '../../../cubit/auth_cubit/auth_cubit.dart';

class CertificateDropdownButton extends StatefulWidget {
  const CertificateDropdownButton({super.key});

  @override
  State<CertificateDropdownButton> createState() => _CertificateDropdownButtonState();
}

class _CertificateDropdownButtonState extends State<CertificateDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthCertificateTypesLoaded) {
          return DropdownButtonFormField<int>(
            value: context.read<AuthCubit>().selectedCertificateType,
            decoration: InputDecoration(
              labelText: 'نوع الشهادة',
              prefixIcon: Icon(
                Icons.card_membership_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            items: state.types.map((TypeEntity type) {
              return DropdownMenuItem<int>(
                value: type.id,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                context.read<AuthCubit>().selectedCertificateType = newValue!;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'الرجاء اختيار نوع الشهادة';
              }
              return null;
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
