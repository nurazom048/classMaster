import 'package:flutter/material.dart';
import 'package:classmate/core/export_core.dart';

class SearchableDropdown extends StatefulWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _SearchBottomSheetContent(
          title: widget.label,
          items: widget.items,
          initialValue: widget.value,
          onSelected: (val) {
            widget.onChanged(val);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppColor.nokiaBlue, // Existing brand color
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _showSearchBottomSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.value ?? widget.hint,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.value != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                      fontWeight: widget.value != null
                          ? FontWeight.w500
                          : FontWeight.w300,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBottomSheetContent extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String> onSelected;

  const _SearchBottomSheetContent({
    required this.title,
    required this.items,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<_SearchBottomSheetContent> createState() => _SearchBottomSheetContentState();
}

class _SearchBottomSheetContentState extends State<_SearchBottomSheetContent> {
  late List<String> filteredItems;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: mediaQuery.size.height * 0.7,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: mediaQuery.viewInsets.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select ${widget.title}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.nokiaBlue, // Existing brand color
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search, color: AppColor.nokiaBlue), // Existing brand color
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = item == widget.initialValue;
                      return ListTile(
                        title: Text(
                          item,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColor.nokiaBlue : Colors.black87, // Existing brand color
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColor.nokiaBlue) // Existing brand color
                            : null,
                        onTap: () => widget.onSelected(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
