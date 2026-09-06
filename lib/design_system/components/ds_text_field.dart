import 'package:design_system_flutter/design_system/components/ds_gap.dart';
import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DSTextField extends StatelessWidget {
  const DSTextField({
    required this.label,
    this.controller,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.enabled = true,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? placeholder;

  final String? helperText;

  final String? errorText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool enabled;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  bool get _hasError => errorText != null;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Semantics(
      textField: true,
      label: label,
      child: ds.isCupertino
          ? _buildCupertino(context)
          : _buildMaterial(context),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: context.ds.typography.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        helperText: helperText,
        errorText: errorText,
      ),
    );
  }

  Widget _buildCupertino(BuildContext context) {
    final ds = context.ds;
    final borderColor = _hasError ? ds.colors.danger : ds.colors.border;
    final footnote = errorText ?? helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSText(
          label,
          role: DSTextRole.caption,
          color: ds.colors.onSurfaceMuted,
        ),
        const DSGap.xs(),
        CupertinoTextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          placeholder: placeholder,
          padding: const EdgeInsets.all(DSSpacing.md),
          style: ds.typography.body,
          placeholderStyle: ds.typography.body.copyWith(
            color: ds.colors.onSurfaceMuted,
          ),
          decoration: BoxDecoration(
            color: enabled
                ? ds.colors.surfaceElevated
                : ds.colors.surfaceSunken,
            borderRadius: ds.radii.controlAll,
            border: Border.all(color: borderColor),
          ),
        ),
        if (footnote != null) ...[
          const DSGap.xs(),
          DSText(
            footnote,
            role: DSTextRole.caption,
            color: _hasError ? ds.colors.danger : ds.colors.onSurfaceMuted,
          ),
        ],
      ],
    );
  }
}
