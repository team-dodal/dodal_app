import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class SelectInput extends StatefulWidget {
  const SelectInput({
    super.key,
    this.onChanged,
    this.title = '',
    this.required = false,
    this.placeholder = '',
  });

  final bool required;
  final String? title;
  final void Function(String)? onChanged;
  final String placeholder;

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  final GlobalKey _selectBoxKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isFocused = false;

  final List<int> _arr = [1, 2, 3, 4];
  int? _selectedIdx;

  void _onTextFieldFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    _focusNode.addListener(_onTextFieldFocusChange);
    super.initState();
  }

  _createOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildSelectMenu(_selectBoxKey, _arr, _selectedIdx);
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onTextFieldFocusChange);
    _focusNode.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text(
                widget.title!,
                style: Typo(context)
                    .body1()!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              if (widget.required)
                Text(
                  '*',
                  style: Typo(context)
                      .body1()!
                      .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                )
            ]),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              _isFocused
                  ? const BoxShadow(
                      color: AppColors.systemGrey3,
                      offset: Offset(0, 0),
                      blurRadius: 8,
                      blurStyle: BlurStyle.outer,
                    )
                  : const BoxShadow()
            ],
          ),
          child: Row(
            children: [
              Expanded(
                key: _selectBoxKey,
                child: Focus(
                  focusNode: _focusNode,
                  onFocusChange: (value) {
                    setState(() {
                      _isFocused = value;
                    });
                    value ? _createOverlay() : _removeOverlay();
                  },
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isFocused = true;
                      });
                      _focusNode.requestFocus();
                      _createOverlay();
                    },
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: 58,
                        decoration: BoxDecoration(
                          color: _isFocused
                              ? AppColors.systemWhite
                              : AppColors.systemGrey4,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            color: _isFocused
                                ? AppColors.systemBlack
                                : AppColors.systemGrey4,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  _selectedIdx != null
                                      ? '${_arr[_selectedIdx!]}'
                                      : '빈도수를 선택해주세요.',
                                  style: Typo(context).body2()),
                              Transform.rotate(
                                angle: _isFocused ? 0 : math.pi,
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_icon.svg',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  OverlayEntry _buildSelectMenu(
      GlobalKey selectBoxKey, List<dynamic> list, int? selected) {
    final RenderBox renderBox =
        selectBoxKey.currentContext?.findRenderObject() as RenderBox;

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: renderBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 8),
          child: SafeArea(
            child: Material(
              color: Colors.white,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.systemGrey3,
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        blurStyle: BlurStyle.outer,
                      ),
                    ]),
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, idx) => ListTile(
                      onTap: () {
                        setState(() {
                          _selectedIdx = idx;
                          _isFocused = false;
                        });
                        _removeOverlay();
                      },
                      title: Text(
                        '${list[idx]}',
                        style: Typo(context).body2()!.copyWith(
                              fontWeight: _selectedIdx == idx
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedIdx == idx
                                  ? AppColors.orange
                                  : AppColors.systemBlack,
                            ),
                      ),
                      trailing: _selectedIdx == idx
                          ? SvgPicture.asset(
                              'assets/icons/check_icon.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.orange,
                                BlendMode.srcIn,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
