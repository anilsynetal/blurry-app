import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/utils/export.dart';

class CommonDropDown<T> extends StatefulWidget {
  final String title;
  final String? hintText;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;
  final String? Function(T?)? validator;
  final hideBorder;
  final buttonHeight;
  final bool isLoading;
  final bool enableSearch;
  final double ?borderRadius;
  final Color ?fillColor;
  final Widget ?prefixIcon;

  const CommonDropDown({
    super.key,
    required this.title,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.validator,
    this.hideBorder = false,
    this.buttonHeight = 48.0,
    this.isLoading = false,
    this.enableSearch = false,
    this.borderRadius,
    this.fillColor,
    this.prefixIcon
  });

  @override
  State<CommonDropDown<T>> createState() => _CommonDropDownState<T>();
}

class _CommonDropDownState<T> extends State<CommonDropDown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          return widget.itemLabelBuilder(item)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(
            Icons.search,
            color: AppThemeNotifier.textSecondary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: AppThemeNotifier.textSecondary,
              size: 20,
            ),
            onPressed: () {
              _searchController.clear();
              _filterItems('');
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius??8),
            borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius??8),
            borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius??8),
            borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          filled: true,
          fillColor:widget.fillColor?? AppThemeNotifier.background,
          hintStyle: TextStyles.bodySmall.copyWith(color: AppThemeNotifier.textDisabled,fontSize: 13),
        ),
        style: TextStyles.bodyMedium.copyWith(
          color: AppThemeNotifier.textPrimary,
        ),
        onChanged: _filterItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title == "" ? SizedBox() : Text(
          widget.title,
          style: TextStyles.titleMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),
        widget.title == "" ? SizedBox() : const SizedBox(height: 5),
        DropdownButtonFormField2<T>(
          value: widget.value,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: BoxConstraints(maxWidth: 40),
            filled: true,
            isDense: widget.hideBorder,
            fillColor: widget.fillColor??AppThemeNotifier.background,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            hintText: null,
            border: widget.hideBorder ? InputBorder.none : OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius??8),
              borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
            ),
            enabledBorder: widget.hideBorder ? InputBorder.none : OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius??8),
              borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
            ),
            focusedBorder: widget.hideBorder ? InputBorder.none : OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius??8),
              borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
            ),
            errorBorder: widget.hideBorder ? InputBorder.none : OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius??8),
              borderSide: BorderSide(color: AppThemeNotifier.error, width: 1),
            ),
            focusedErrorBorder: widget.hideBorder ? InputBorder.none : OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius??8),
              borderSide: BorderSide(color: AppThemeNotifier.error, width: 1),
            ),
            errorStyle: TextStyles.labelSmall.copyWith(
              color: AppThemeNotifier.error,
            ),
          ),
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.only(
                right: widget.hideBorder ? 0 : 0,
                left: widget.hideBorder ? 0 : 0
            ),
            height: widget.buttonHeight,
            width: Get.width,
          ),
          iconStyleData: IconStyleData(
            icon: widget.isLoading ? SizedBox(
              height: 24,
              width: 24,
              child: CupertinoActivityIndicator(
                color: AppThemeNotifier.primary,
              ),
            ) : Icon(
                Icons.arrow_drop_down_rounded,
                color: widget.hideBorder
                    ? AppThemeNotifier.textPrimary
                    : AppThemeNotifier.textDisabled
            ),
            iconSize: widget.hideBorder ? 24 : 28,

          ),
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, -5),
            maxHeight: Get.height * 0.4,
            decoration: BoxDecoration(
              color: AppThemeNotifier.background,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          hint: Text(
            widget.hintText ?? "Select ${widget.title}",
            style: widget.hideBorder
                ? TextStyles.titleSmall.copyWith(
              color: AppThemeNotifier.textSecondaryAlpha,
            )
                : TextStyles.bodySmall.copyWith(color: AppThemeNotifier.textDisabled,fontSize: 13),
          ),

          isDense: widget.hideBorder,
         menuItemStyleData: MenuItemStyleData(height: 35),
          items: _filteredItems.map((item) => DropdownMenuItem<T>(
            value: item,

            enabled: true,
            child: Text(
              widget.itemLabelBuilder(item),
              style: widget.hideBorder
                  ? TextStyles.titleSmall.copyWith(
                color: AppThemeNotifier.textPrimary,
              )
                  : TextStyles.bodyMedium.copyWith(
                color: AppThemeNotifier.textPrimary,
              ),
            ),
          )).toList(),
          onChanged: widget.onChanged,
          validator: widget.validator,
          // Fixed search functionality
          dropdownSearchData: widget.enableSearch ? DropdownSearchData<T>(
            searchController: _searchController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: _buildSearchField(),
            searchMatchFn: (item, searchValue) {
              // Extract the actual value from DropdownMenuItem
              final T actualItem = item.value as T;
              return widget.itemLabelBuilder(actualItem)
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ) : null,
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              _searchController.clear();
              setState(() {
                _filteredItems = widget.items;
              });
            }
          },
        ),
      ],
    );
  }
}


class EnhancedDropDown<T> extends StatefulWidget {
  final String hintText;
  final bool enableSearch;
  final bool isLoading;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  const EnhancedDropDown({
    Key? key,
    required this.hintText,
    this.enableSearch = false,
    this.isLoading = false,
    this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.validator,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<EnhancedDropDown<T>> createState() => _EnhancedDropDownState<T>();
}

class _EnhancedDropDownState<T> extends State<EnhancedDropDown<T>> {
  bool _isExpanded = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<T> get filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items.where((item) {
      return widget.itemLabelBuilder(item)
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.isLoading ? null : () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppThemeNotifier.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isExpanded
                    ? AppThemeNotifier.primary.withOpacity(0.5)
                    : AppThemeNotifier.border.withOpacity(0.3),
                width: _isExpanded ? 1 : 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: widget.value != null
                        ? AppThemeNotifier.primary
                        : AppThemeNotifier.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: widget.isLoading
                      ? Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppThemeNotifier.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Loading...',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppThemeNotifier.textSecondary,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    widget.value != null
                        ? widget.itemLabelBuilder(widget.value!)
                        : widget.hintText,
                    style: TextStyles.bodyMedium.copyWith(
                        color: widget.value != null
                            ? AppThemeNotifier.textPrimary
                            : AppThemeNotifier.textSecondary,
                        fontSize: widget.value != null?14:12
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppThemeNotifier.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dropdown List
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isExpanded ? null : 0,
          child: _isExpanded
              ? Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppThemeNotifier.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppThemeNotifier.border.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppThemeNotifier.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Field
                if (widget.enableSearch) ...[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppThemeNotifier.textSecondary,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemeNotifier.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppThemeNotifier.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: AppThemeNotifier.primary.withOpacity(0.5),
                              width: 1
                          ),

                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      style: TextStyles.bodySmall,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppThemeNotifier.border.withOpacity(0.2),
                  ),
                ],

                // Items List
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = widget.value == item;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            setState(() {
                              _isExpanded = false;
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppThemeNotifier.primary.withOpacity(0.05)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: AppThemeNotifier.primary,
                                    size: 18,
                                  )
                                else
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: AppThemeNotifier.textSecondary,
                                    size: 18,
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.itemLabelBuilder(item),
                                    style: TextStyles.bodyMedium.copyWith(
                                      color: isSelected
                                          ? AppThemeNotifier.primary
                                          : AppThemeNotifier.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}