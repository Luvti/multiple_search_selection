library multiple_search_selection;

import 'package:flutter/material.dart';
import 'package:multiple_search_selection/helpers/jaro.dart';
import 'package:multiple_search_selection/helpers/levenshtein.dart';

enum FuzzySearch {
  levenshtein,
  jaro,
  none,
}

enum ShowedItemsVisibility {
  alwaysOn,
  onType,
  toggle,
}

class MultipleSearchSelection<T> extends StatefulWidget {
  const MultipleSearchSelection({
    Key? key,
    required this.items,
    required this.onPickedChange,
    required this.fieldToCheck,
    required this.itemBuilder,
    required this.pickedItemBuilder,
    this.initialPickedItems,
    this.fuzzySearch = FuzzySearch.none,
    this.padding,
    this.onItemAdded,
    this.onItemRemoved,
    this.onTapShowedItem,
    this.title,
    this.titlePadding,
    this.maximumShowItemsHeight = 150,
    this.showClearAllButton = true,
    this.showSelectAllButton = true,
    this.sortPickedItems = false,
    this.sortShowedItems = false,
    this.showShowedItemsScrollbar = true,
    this.showPickedItemScrollbar = true,
    this.showedItemsScrollbarColor,
    this.showedItemsScrollbarMinOverscrollLength,
    this.showedItemsScrollbarMinThumbLength,
    this.showedItemsScrollbarRadius,
    this.showedItemContainerHeight,
    this.showedItemContainerPadding,
    this.showedItemsBackgroundColor,
    this.showedItemMouseCursor,
    this.showedItemsScrollController,
    this.showedItemsScrollPhysics,
    this.showedItemsBoxDecoration,
    this.searchFieldInputDecoration,
    this.searchItemTextContentPadding,
    this.noResultsWidget,
    this.outerContainerBorderColor,
    this.itemsVisibility = ShowedItemsVisibility.alwaysOn,
    this.pickedItemsBorderColor,
    this.pickedItemSpacing,
    this.pickedItemsContainerMaxHeight,
    this.pickedItemsContainerMinHeight,
    this.pickedItemScrollbarColor,
    this.pickedItemScrollbarThickness,
    this.pickedItemScrollbarMinOverscrollLength,
    this.pickedItemScrollbarRadius,
    this.pickedItemsScrollbarMinThumbLength,
    this.pickedItemsBoxDecoration,
    this.pickedItemsScrollController,
    this.pickedItemsScrollPhysics,
    this.showItemsButton,
    this.selectAllButton,
    this.clearAllButton,
    this.searchItemTextStyle,
    this.onTapClearAll,
    this.onTapSelectAll,
    this.onTapShowItems,
  }) : super(key: key);

  /// The title widget on top of picked items.
  final Widget? title;

  /// The padding of the whole widget.
  final EdgeInsets? padding;

  /// The padding of the title Widget. Defaults to [EdgeInsets.zero].
  final EdgeInsets? titlePadding;

  /// The border color of the picked items container.
  final Color? pickedItemsBorderColor;

  /// The border color of the container that includes the search text field and  the showed items.
  final Color? outerContainerBorderColor;

  /// The maximum height constraints of the items' container.
  final double maximumShowItemsHeight;

  /// The list of items (T) to search and select.
  final List<T> items;

  /// The list of initial picked items.
  final List<T>? initialPickedItems;

  /// The thumb color of the items' scrollbar.
  final Color? showedItemsScrollbarColor;

  /// The background color of the container holding all the items.
  final Color? showedItemsBackgroundColor;

  /// The minimum length of the items' scrollbar thumb.
  final double? showedItemsScrollbarMinThumbLength;

  /// The minimum length of the overscroll for items.
  final double? showedItemsScrollbarMinOverscrollLength;

  /// The radius of the items' scrollbar.
  final Radius? showedItemsScrollbarRadius;

  /// The height of the showed item container. Defaults to 50 pixels.
  final double? showedItemContainerHeight;

  /// The padding of the showed item container.
  final EdgeInsets? showedItemContainerPadding;

  /// The mouse cursor when hovered over showed item container. Defaults to [SystemMouseCursors.click]
  final MouseCursor? showedItemMouseCursor;

  /// Hide or show items' scrollbar, defaults to [true]
  final bool showShowedItemsScrollbar;

  /// Hide or show select all button.
  final bool showSelectAllButton;

  /// Hide or show clear all button.
  final bool showClearAllButton;

  /// A callback when user selects or deselects an item. Always returns the currently picked items.
  final Function(List<T>) onPickedChange;

  /// A callback when an item is removed, returns the item aswell.
  final Function(T)? onItemRemoved;

  /// A callback when an item is added, returns the item aswell.
  final Function(T)? onItemAdded;

  /// The input decoration of the search text field.
  final InputDecoration? searchFieldInputDecoration;

  /// The text style of the search text field.
  final TextStyle? searchItemTextStyle;

  /// What is shown when there are no more results to select.
  final Widget? noResultsWidget;

  /// The spacing of picked item chip. Defaults to 5.
  final double? pickedItemSpacing;

  /// The maximum height of which the picked items container can extend. Defaults to 150 pixels.
  final double? pickedItemsContainerMaxHeight;

  /// The minimum height of which the picked items container can extend. Defaults to 50 pixels.
  final double? pickedItemsContainerMinHeight;

  /// The thumb color of the picked items' scrollbar.
  final Color? pickedItemScrollbarColor;

  /// The thickness of the picked items' scrollbar thumb.
  final double? pickedItemScrollbarThickness;

  /// The minimum length of the overscroll for picked items.
  final double? pickedItemScrollbarMinOverscrollLength;

  /// The radius of the picked items' scrollbar.
  final Radius? pickedItemScrollbarRadius;

  /// The minimum length of the picked items' scrollbar thumb.
  final double? pickedItemsScrollbarMinThumbLength;

  /// The [BoxDecoration] of the picked items container.
  final BoxDecoration? pickedItemsBoxDecoration;

  /// Hide or show picked items' scrollbar, defaults to [true].
  final bool showPickedItemScrollbar;

  /// The content padding of the search item textfield. This is overriden if [searchFieldInputDecoration] is provided.
  final EdgeInsets? searchItemTextContentPadding;

  /// A callback when a showed item is tapped.
  final VoidCallback? onTapShowedItem;

  /// The [ScrollController] of the picked items list.
  final ScrollController? pickedItemsScrollController;

  /// The [ScrollController] of showed items list.
  final ScrollController? showedItemsScrollController;

  /// The [ScrollPhysics] of the picked items list.
  final ScrollPhysics? pickedItemsScrollPhysics;

  /// The [ScrollPhysics] of showed items list.
  final ScrollPhysics? showedItemsScrollPhysics;

  /// The [BoxDecoration] of the showed items container.
  final BoxDecoration? showedItemsBoxDecoration;

  /// Whether the picked items are sorted alphabetically. Defaults to [false].
  final bool sortPickedItems;

  /// Whether the showed items are sorted alphabetically. Defaults to [false].
  final bool sortShowedItems;

  /// How the showed items are displayed.
  ///
  /// There are currently three types :
  ///
  /// ```dart
  /// ShowedItemsVisibility.alwaysOn // The items are always displayed
  /// ShowedItemsVisibility.onType // Items are displayed when user types on search field
  /// ShowedItemsVisibility.toggle // Items are displayed when tapped on toggle button
  /// ```
  ///
  /// Defaults to [ShowedItemsVisibility.alwaysOn].
  final ShowedItemsVisibility itemsVisibility;

  /// Fuzzy search functionality. Defaults to [FuzzySearch.none].
  ///
  /// Currently available fuzzy algorithms :
  ///
  /// ```dart
  /// FuzzySearch.jaro // Measures characters in common, considerating transpositions.
  /// ```
  /// ### Shows results with score higher of 0.8.
  ///
  /// ```dart
  /// FuzzySearch.levenshtein // The number of edits required to convert one string to other.
  /// ```
  /// ### Shows results with minimum 2 edits.
  final FuzzySearch fuzzySearch;

  /// This is the builder of picked items.
  final Widget Function(T) pickedItemBuilder;

  /// This is the field to check when searching & sorting the List<T>.
  ///
  /// ### Example
  ///
  /// If we work with `List<Country>` where Country is
  /// ```dart
  /// class Country {
  ///   String name;
  ///   Srtring iso;
  /// }
  /// ```
  ///
  /// If you want to search by name when then you can use
  ///
  /// ```dart
  /// fieldToCheck: (country) {
  ///   return c.name;
  ///}
  /// ```
  ///
  /// If we work with `List<String>` then
  /// ```dart
  /// fieldToCheck: (country) {
  ///   return country;
  ///}
  /// ```
  final String Function(T) fieldToCheck;

  /// This is the builder of showed items.
  final Widget Function(T) itemBuilder;

  /// The toggle items button when [itemsVisibility] == [ShowedItemsVisibility.toggle]. Ontap logic is already defiend and you can't override it with
  ///
  /// a widget that has onTap, e.g [TextButton]. If you want to do something when you tap the button
  ///
  /// you can use the [onTapShowItems] callback.
  final Widget? showItemsButton;

  /// A callback when the select all button is pressed.
  final VoidCallback? onTapShowItems;

  /// The select all button widget. Ontap logic is already defiend and you can't override it with
  ///
  /// a widget that has onTap, e.g [TextButton]. If you want to do something when you tap the button
  ///
  /// you can use the [onTapSelectAll] callback.
  final Widget? selectAllButton;

  /// A callback when the select all button is pressed.
  final VoidCallback? onTapSelectAll;

  /// The clear all selected items button widget. Ontap logic is already defiend and you can't override it with
  ///
  /// a widget that has onTap, e.g [TextButton]. If you want to do something when you tap the button
  ///
  /// you can use the [onTapClearAll] callback.
  final Widget? clearAllButton;

  /// A callback when the clear all button is pressed.
  final VoidCallback? onTapClearAll;

  @override
  _MultipleSearchSelectionState<T> createState() =>
      _MultipleSearchSelectionState<T>();
}

class _MultipleSearchSelectionState<T>
    extends State<MultipleSearchSelection<T>> {
  late List<T> showedItems;
  late List<T> allItems;

  bool expanded = false;

  List<T> pickedItems = [];
  final ScrollController _pickedItemsController = ScrollController();
  final ScrollController _showedItemsScrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _textFieldFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    showedItems = [...widget.items];
    allItems = [...widget.items];
    if (widget.sortShowedItems) {
      showedItems.sort(
        (a, b) => widget.fieldToCheck(a).compareTo(
              widget.fieldToCheck(b),
            ),
      );
      allItems.sort(
        (a, b) => widget.fieldToCheck(a).compareTo(
              widget.fieldToCheck(b),
            ),
      );
    }

    expanded = widget.itemsVisibility == ShowedItemsVisibility.alwaysOn;

    pickedItems.addAll(widget.initialPickedItems ?? []);
  }

  void _onRemoveItem(T item) {
    pickedItems.remove(item);
    allItems.add(item);
    showedItems = allItems
        .where(
          (item) => widget.fieldToCheck.call(item).contains(
                _textEditingController.text,
              ),
        )
        .toList();
    if (showedItems.isNotEmpty) {
      if (widget.sortShowedItems) {
        showedItems.sort(
          (a, b) => widget.fieldToCheck(a).compareTo(
                widget.fieldToCheck(b),
              ),
        );
      }
    }
    if (widget.sortShowedItems) {
      allItems.sort(
        (a, b) => widget.fieldToCheck(a).compareTo(
              widget.fieldToCheck(b),
            ),
      );
    }

    widget.onPickedChange(pickedItems);
    widget.onItemRemoved?.call(item);
    setState(() {});
    widget.onItemRemoved?.call(item);
  }

  void _onAddItem(T item) {
    widget.onTapShowedItem?.call();
    final T pickedItem = item;
    pickedItems.add(pickedItem);
    if (widget.sortPickedItems) {
      pickedItems.sort(
        (a, b) => widget.fieldToCheck(a).compareTo(
              widget.fieldToCheck(b),
            ),
      );
    }
    allItems.remove(pickedItem);
    showedItems.remove(pickedItem);
    widget.onPickedChange(
      pickedItems,
    );
    widget.onItemAdded?.call(pickedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Padding(
              padding: widget.titlePadding ?? EdgeInsets.zero,
              child: widget.title,
            ),
          ],
          if (pickedItems.isNotEmpty)
            // picked item chips
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                maxHeight: widget.pickedItemsContainerMaxHeight ?? 150,
                minHeight: widget.pickedItemsContainerMinHeight ?? 50,
              ),
              decoration: widget.pickedItemsBoxDecoration ??
                  BoxDecoration(
                    border: pickedItems.isNotEmpty
                        ? Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          )
                        : null,
                  ),
              child: RawScrollbar(
                thumbVisibility: widget.showPickedItemScrollbar,
                thumbColor: widget.pickedItemScrollbarColor,
                minOverscrollLength:
                    widget.pickedItemScrollbarMinOverscrollLength ?? 5,
                minThumbLength: widget.pickedItemsScrollbarMinThumbLength ?? 30,
                thickness: widget.pickedItemScrollbarThickness ?? 10,
                radius: widget.pickedItemScrollbarRadius ??
                    const Radius.circular(5),
                controller: widget.pickedItemsScrollController ??
                    _pickedItemsController,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    controller: widget.pickedItemsScrollController ??
                        _pickedItemsController,
                    physics: widget.pickedItemsScrollPhysics,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: widget.pickedItemSpacing ?? 5,
                        runSpacing: widget.pickedItemSpacing ?? 5,
                        children: [
                          ...pickedItems.map(
                            (e) => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _onRemoveItem(e);
                              },
                              child: IgnorePointer(
                                child: widget.pickedItemBuilder.call(e),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.showClearAllButton ||
              widget.itemsVisibility == ShowedItemsVisibility.toggle) ...[
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.itemsVisibility ==
                        ShowedItemsVisibility.toggle) ...[
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.onTapShowItems?.call();
                          showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, stateSetter) {
                                return Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            top: BorderSide(
                                              color: widget
                                                      .outerContainerBorderColor ??
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            left: BorderSide(
                                              color: widget
                                                      .outerContainerBorderColor ??
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            right: BorderSide(
                                              color: widget
                                                      .outerContainerBorderColor ??
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            bottom: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        child: TextField(
                                          focusNode: _textFieldFocus,
                                          controller: _textEditingController,
                                          style: widget.searchItemTextStyle,
                                          decoration: widget
                                                  .searchFieldInputDecoration ??
                                              InputDecoration(
                                                contentPadding: widget
                                                        .searchItemTextContentPadding ??
                                                    const EdgeInsets.only(
                                                      left: 6,
                                                    ),
                                                hintText: 'Type here to search',
                                                hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                          onChanged: (value) {
                                            if (widget.fuzzySearch ==
                                                FuzzySearch.jaro) {
                                              showedItems = allItems.where(
                                                (item) {
                                                  return widget.fieldToCheck
                                                          .call(item)
                                                          .toLowerCase()
                                                          .contains(value) ||
                                                      (getJaro(
                                                            widget.fieldToCheck
                                                                .call(item),
                                                            value,
                                                          ) >=
                                                          0.8);
                                                },
                                              ).toList();
                                            } else if (widget.fuzzySearch ==
                                                FuzzySearch.levenshtein) {
                                              showedItems = allItems.where(
                                                (item) {
                                                  return widget.fieldToCheck
                                                          .call(item)
                                                          .toLowerCase()
                                                          .contains(value) ||
                                                      (getLevenshtein(
                                                            widget.fieldToCheck
                                                                .call(item),
                                                            value,
                                                          ) <=
                                                          2);
                                                },
                                              ).toList();
                                            } else {
                                              showedItems = allItems
                                                  .where(
                                                    (item) => widget
                                                        .fieldToCheck
                                                        .call(item)
                                                        .toLowerCase()
                                                        .contains(value),
                                                  )
                                                  .toList();
                                            }
                                            setState(() {});
                                            stateSetter(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              widget.maximumShowItemsHeight,
                                        ),
                                        decoration: widget
                                                .showedItemsBoxDecoration ??
                                            BoxDecoration(
                                              color: widget
                                                      .showedItemsBackgroundColor ??
                                                  Colors.grey.withOpacity(0.1),
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: widget
                                                          .outerContainerBorderColor ??
                                                      Colors.grey
                                                          .withOpacity(0.5),
                                                ),
                                                left: BorderSide(
                                                  color: widget
                                                          .outerContainerBorderColor ??
                                                      Colors.grey
                                                          .withOpacity(0.5),
                                                ),
                                                right: BorderSide(
                                                  color: widget
                                                          .outerContainerBorderColor ??
                                                      Colors.grey
                                                          .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                        child: RawScrollbar(
                                          controller: widget
                                                  .showedItemsScrollController ??
                                              _showedItemsScrollController,
                                          thumbColor:
                                              widget.showedItemsScrollbarColor,
                                          thickness: widget
                                                  .showedItemsScrollbarMinThumbLength ??
                                              10,
                                          minThumbLength: widget
                                                  .showedItemsScrollbarMinThumbLength ??
                                              30,
                                          minOverscrollLength: widget
                                                  .showedItemsScrollbarMinOverscrollLength ??
                                              5,
                                          radius: widget
                                                  .showedItemsScrollbarRadius ??
                                              const Radius.circular(5),
                                          thumbVisibility:
                                              widget.showShowedItemsScrollbar,
                                          child: ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
                                                    .copyWith(
                                              scrollbars: false,
                                            ),
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              controller: widget
                                                      .showedItemsScrollController ??
                                                  _showedItemsScrollController,
                                              children: showedItems.isEmpty
                                                  ? [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: widget
                                                                .noResultsWidget ??
                                                            const Text(
                                                              'No results',
                                                            ),
                                                      )
                                                    ]
                                                  : showedItems.map((T item) {
                                                      return GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () {
                                                          _onAddItem(item);
                                                          stateSetter(() {});
                                                          setState(() {});
                                                        },
                                                        child: IgnorePointer(
                                                          child: widget
                                                              .itemBuilder(
                                                            item,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ).whenComplete(() {
                            _textEditingController.clear();
                            showedItems = allItems;
                          });
                        },
                        child: IgnorePointer(
                          child: widget.showItemsButton ??
                              const Text('Show items'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                    if (widget.showSelectAllButton)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          pickedItems.addAll(showedItems);
                          if (widget.sortPickedItems) {
                            pickedItems.sort(
                              (a, b) => widget.fieldToCheck(a).compareTo(
                                    widget.fieldToCheck(b),
                                  ),
                            );
                          }
                          allItems.removeWhere((e) => showedItems.contains(e));

                          showedItems = allItems
                              .where(
                                (item) => widget.fieldToCheck
                                    .call(item)
                                    .toLowerCase()
                                    .contains(_textEditingController.text),
                              )
                              .toList();
                          if (showedItems.isNotEmpty) {
                            if (widget.sortShowedItems) {
                              showedItems.sort(
                                (a, b) => widget.fieldToCheck(a).compareTo(
                                      widget.fieldToCheck(b),
                                    ),
                              );
                            }
                          }

                          widget.onPickedChange(pickedItems);
                          widget.onTapSelectAll?.call();
                          setState(() {});
                        },
                        child: IgnorePointer(
                          child: widget.selectAllButton ??
                              const Text('Select all'),
                        ),
                      ),
                  ],
                ),
                if (pickedItems.isNotEmpty && widget.showClearAllButton)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      allItems.addAll(pickedItems);
                      showedItems = allItems
                          .where(
                            (item) => widget
                                .fieldToCheck(item)
                                .toLowerCase()
                                .contains(_textEditingController.text),
                          )
                          .toList();
                      if (showedItems.isNotEmpty) {
                        if (widget.sortShowedItems) {
                          showedItems.sort(
                            (a, b) => widget.fieldToCheck(a).compareTo(
                                  widget.fieldToCheck(b),
                                ),
                          );
                        }
                      }
                      pickedItems.removeRange(0, pickedItems.length);
                      if (widget.sortShowedItems) {
                        allItems.sort(
                          (a, b) => widget.fieldToCheck(a).compareTo(
                                widget.fieldToCheck(b),
                              ),
                        );
                      }
                      widget.onPickedChange(pickedItems);
                      widget.onTapClearAll?.call();
                      setState(() {});
                    },
                    child: IgnorePointer(
                      child: widget.clearAllButton ?? const Text('Clear all'),
                    ),
                  )
              ],
            )
          ],
          const SizedBox(
            height: 10,
          ),
          if (widget.itemsVisibility != ShowedItemsVisibility.toggle)
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: widget.outerContainerBorderColor ??
                        Colors.grey.withOpacity(0.5),
                  ),
                  left: BorderSide(
                    color: widget.outerContainerBorderColor ??
                        Colors.grey.withOpacity(0.5),
                  ),
                  right: BorderSide(
                    color: widget.outerContainerBorderColor ??
                        Colors.grey.withOpacity(0.5),
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
              child: TextField(
                focusNode: _textFieldFocus,
                controller: _textEditingController,
                style: widget.searchItemTextStyle,
                decoration: widget.searchFieldInputDecoration ??
                    InputDecoration(
                      contentPadding: widget.searchItemTextContentPadding ??
                          const EdgeInsets.only(left: 6),
                      hintText: 'Type here to search',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                onChanged: (value) {
                  if (widget.fuzzySearch == FuzzySearch.jaro) {
                    showedItems = allItems.where(
                      (item) {
                        return widget
                                .fieldToCheck(item)
                                .toLowerCase()
                                .contains(value) ||
                            (getJaro(widget.fieldToCheck(item), value) >= 0.8);
                      },
                    ).toList();
                  } else if (widget.fuzzySearch == FuzzySearch.levenshtein) {
                    showedItems = allItems.where(
                      (item) {
                        return widget
                                .fieldToCheck(item)
                                .toLowerCase()
                                .contains(value) ||
                            (getLevenshtein(widget.fieldToCheck(item), value) <=
                                2);
                      },
                    ).toList();
                  } else {
                    showedItems = allItems
                        .where(
                          (item) => widget
                              .fieldToCheck(item)
                              .toLowerCase()
                              .contains(value),
                        )
                        .toList();
                  }
                  if (expanded &&
                      widget.itemsVisibility == ShowedItemsVisibility.onType) {
                    expanded = widget.itemsVisibility ==
                            ShowedItemsVisibility.onType &&
                        _textEditingController.text.isNotEmpty;
                  }
                  setState(() {});
                },
              ),
            ),
          if (expanded &&
              widget.itemsVisibility != ShowedItemsVisibility.toggle)
            Container(
              constraints: BoxConstraints(
                maxHeight: widget.maximumShowItemsHeight,
              ),
              decoration: widget.showedItemsBoxDecoration ??
                  BoxDecoration(
                    color: widget.showedItemsBackgroundColor ??
                        Colors.grey.withOpacity(0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: widget.outerContainerBorderColor ??
                            Colors.grey.withOpacity(0.5),
                      ),
                      left: BorderSide(
                        color: widget.outerContainerBorderColor ??
                            Colors.grey.withOpacity(0.5),
                      ),
                      right: BorderSide(
                        color: widget.outerContainerBorderColor ??
                            Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
              child: RawScrollbar(
                controller: widget.showedItemsScrollController ??
                    _showedItemsScrollController,
                thumbColor: widget.showedItemsScrollbarColor,
                thickness: widget.showedItemsScrollbarMinThumbLength ?? 10,
                minThumbLength: widget.showedItemsScrollbarMinThumbLength ?? 30,
                minOverscrollLength:
                    widget.showedItemsScrollbarMinOverscrollLength ?? 5,
                radius: widget.showedItemsScrollbarRadius ??
                    const Radius.circular(5),
                thumbVisibility: widget.showShowedItemsScrollbar,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    controller: widget.showedItemsScrollController ??
                        _showedItemsScrollController,
                    children: showedItems.isEmpty
                        ? [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: widget.noResultsWidget ??
                                  const Text('No results'),
                            )
                          ]
                        : showedItems.map((T item) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _onAddItem(item);
                                setState(() {});
                              },
                              child: IgnorePointer(
                                child: widget.itemBuilder(
                                  item,
                                ),
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
