import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'input_title.dart';

class Select {
  String label;
  dynamic value;
  Select({required this.label, required this.value});
}

class SelectInput extends StatefulWidget {
  const SelectInput({
    super.key,
    required this.onChanged,
    this.title = '',
    this.required = false,
    this.placeholder = '',
    required this.list,
    required this.value,
  });

  final bool required;
  final String? title;
  final void Function(Select) onChanged;
  final Select? value;
  final String placeholder;
  final List<Select> list;

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  final GlobalKey _selectBoxKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isFocused = false;
  int? _selectedIdx;

  void _onTextFieldFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  _createOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry =
          _buildSelectMenu(_selectBoxKey, widget.list, _selectedIdx);
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    _focusNode.addListener(_onTextFieldFocusChange);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectInput oldWidget) {
    if (widget.value != null && widget.value != null) {
      setState(() {
        _selectedIdx = widget.list.indexOf(widget.value!);
      });
    }

    super.didUpdateWidget(oldWidget);
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
        InputTitle(title: widget.title!, required: widget.required),
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
                                  widget.value != null
                                      ? widget.value!.label
                                      : widget.placeholder,
                                  style: context.body2()),
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
      GlobalKey selectBoxKey, List<Select> list, int? selected) {
    final RenderBox renderBox =
        selectBoxKey.currentContext?.findRenderObject() as RenderBox;
    const double listTileHeight = 58;
    final ScrollController scrollController = ScrollController();

    void scrollToIndex(int index) {
      if (scrollController.hasClients) {
        // 해당 인덱스의 위치로 스크롤
        scrollController.jumpTo(index * listTileHeight);
      }
    }

    return OverlayEntry(
        maintainState: true,
        builder: (context) => Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    _removeOverlay();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  width: renderBox.size.width,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    offset: Offset(
                        0, Platform.isIOS ? 8 : renderBox.size.height - 20),
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
                                controller: scrollController,
                                itemCount: list.length,
                                itemBuilder: (context, idx) {
                                  bool isSelected = widget.value == list[idx];
                                  if (isSelected) {
                                    // 스크롤 시 해당 항목으로 포커싱
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      scrollToIndex(idx);
                                    });
                                  }
                                  return SizedBox(
                                    height: listTileHeight,
                                    child: ListTile(
                                      selected: isSelected,
                                      onTap: () {
                                        setState(() {
                                          _isFocused = false;
                                        });
                                        widget.onChanged(list[idx]);
                                        _removeOverlay();
                                      },
                                      title: Text(
                                        list[idx].label,
                                        style: context.body2(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.orange
                                              : AppColors.systemBlack,
                                        ),
                                      ),
                                      trailing: widget.value == list[idx]
                                          ? SvgPicture.asset(
                                              'assets/icons/check_icon.svg',
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.orange,
                                                BlendMode.srcIn,
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }
}
