import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/item.dart';
import '../widgets/empty_state.dart';
import '../widgets/run_card.dart';

class RunsScreen extends StatefulWidget {
  const RunsScreen({
    super.key,
    required this.items,
    required this.onFavouriteChanged,
    required this.onRunSelected,
  });

  final List<Item> items;
  final ValueChanged<Item> onFavouriteChanged;
  final ValueChanged<Item> onRunSelected;

  @override
  State<RunsScreen> createState() => _RunsScreenState();
}

class _RunsScreenState extends State<RunsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  RunCategory? _selectedCategory;
  bool _showPastRuns = false;

  List<Item> get _filteredItems {
    final query = _query.trim().toLowerCase();
    final matches = widget.items.where((item) {
      final matchesCategory =
          _selectedCategory == null || item.category == _selectedCategory;
      final matchesPast = _showPastRuns || !item.isPast;
      final matchesSearch =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);
      return matchesCategory && matchesPast && matchesSearch;
    });

    return sortedRunsByDate(matches);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategory = null;
      _showPastRuns = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visibleItems = _filteredItems;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find your next run',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Good miles are better together.',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search runs or locations',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.clear),
                    ),
              filled: true,
              fillColor: colors.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  ),
                ),
                for (final category in RunCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(category.icon, size: 18),
                      label: Text(category.label),
                      selected: _selectedCategory == category,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              FilterChip(
                label: const Text('Include past runs'),
                selected: _showPastRuns,
                onSelected: (selected) =>
                    setState(() => _showPastRuns = selected),
              ),
              const Spacer(),
              Text(
                '${visibleItems.length} runs',
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (visibleItems.isEmpty) {
                  final hasFilters =
                      _query.trim().isNotEmpty ||
                      _selectedCategory != null ||
                      _showPastRuns;
                  return EmptyState(
                    icon: hasFilters ? Icons.search_off : Icons.directions_run,
                    message: hasFilters
                        ? 'No runs match these filters.'
                        : 'No runs are planned yet.',
                    actionLabel: hasFilters ? 'Clear filters' : null,
                    onAction: hasFilters ? _clearFilters : null,
                  );
                }

                if (constraints.maxWidth >= 600) {
                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          mainAxisExtent: 190,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: visibleItems.length,
                    itemBuilder: (context, index) => RunCard(
                      item: visibleItems[index],
                      onFavouriteChanged: widget.onFavouriteChanged,
                      onTap: () => widget.onRunSelected(visibleItems[index]),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: visibleItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) => RunCard(
                    item: visibleItems[index],
                    onFavouriteChanged: widget.onFavouriteChanged,
                    onTap: () => widget.onRunSelected(visibleItems[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
