import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MELODY/core/models/country_code.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'dart:async';

class CountryCodeDropdown extends StatefulWidget {
  final List<CountryCode> countryCodes;
  final CountryCode selectedCountry;
  final Function(CountryCode) onChanged;

  const CountryCodeDropdown({
    super.key,
    required this.countryCodes,
    required this.selectedCountry,
    required this.onChanged,
  });

  @override
  State<CountryCodeDropdown> createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<CountryCode> _filteredCountryCodes = [];
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredCountryCodes = widget.countryCodes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _removeOverlay(calledFromDispose: true);
    super.dispose();
  }

  void _filterCountryCodes(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _filteredCountryCodes =
              query.isEmpty
                  ? widget.countryCodes
                  : widget.countryCodes.where((country) {
                    return country.name.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        country.dialCode.contains(query) ||
                        country.code.toLowerCase().contains(
                          query.toLowerCase(),
                        );
                  }).toList();
        });
        _updateOverlay();
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _removeOverlay({bool calledFromDispose = false}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted && !calledFromDispose) {
      setState(() {
        _isDropdownOpen = false;
      });
    } else {
      _isDropdownOpen = false;
    }
  }

  void _updateOverlay() {
    if (_isDropdownOpen) {
      _removeOverlay();
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: 280,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF8F0FF),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search country or code...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: Colors.grey[400]!,
                                width: 1,
                              ),
                            ),
                          ),
                          onChanged: _filterCountryCodes,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _filteredCountryCodes.length,
                          itemBuilder: (context, index) {
                            final country = _filteredCountryCodes[index];
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  widget.onChanged(country);
                                  _removeOverlay();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0F0F0),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          country.code,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              country.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              country.dialCode,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
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
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleDropdown,
        child: Container(
          height: 53,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCountryFlag(widget.selectedCountry.code.toLowerCase()),
              const SizedBox(width: 8),
              Text(
                widget.selectedCountry.dialCode,
                style: LightTextTheme.paragraph2.copyWith(
                  color: LightColorTheme.black,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                color: LightColorTheme.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryFlag(String countryCode) {
    // Try to load the country flag SVG
    try {
      return SvgPicture.asset(
        'assets/icons/phone_locale/${countryCode}.svg',
        width: 24,
        height: 24,
        placeholderBuilder:
            (BuildContext context) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  countryCode.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
      );
    } catch (e) {
      // Fallback to a text representation of the country code
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            countryCode.toUpperCase(),
            style: const TextStyle(fontSize: 10),
          ),
        ),
      );
    }
  }
}
