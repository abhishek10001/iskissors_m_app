import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/mock_data.dart';
import '../../../providers/providers.dart';
import '../../widgets/salon_list_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<String> _recentSearches = List.from(MockData.recentSearches);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nearbySalons = ref.watch(nearbySalonsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search salon or service..',
                    hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Icon(Icons.search, color: AppColors.textGrey),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            // Recents
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recents', style: AppTextStyles.caption),
                  GestureDetector(
                    onTap: () => setState(() => _recentSearches.clear()),
                    child: Text('Clear all', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...(_recentSearches.map((search) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(search, style: AppTextStyles.body.copyWith(fontSize: 15)),
                  trailing: GestureDetector(
                    onTap: () => setState(() => _recentSearches.remove(search)),
                    child: const Icon(Icons.close, size: 18, color: AppColors.textGrey),
                  ),
                ))),

            const Divider(indent: 20, endIndent: 20),
            const SizedBox(height: 16),

            // Popular Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Popular Search', style: AppTextStyles.subtitle),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: MockData.popularSearches.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(tag, style: AppTextStyles.captionMedium.copyWith(color: AppColors.textDark)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Suggestion for you
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Suggestion for you', style: AppTextStyles.subtitle),
            ),
            const SizedBox(height: 12),
            nearbySalons.when(
              data: (salons) => Column(
                children: salons.take(2).map((salon) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SalonListTile(
                      salon: salon,
                      onTap: () => context.push('/shop/${salon.id}'),
                    ),
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  int _selectedDay = 10;
  final Set<String> _selectedServices = {'Hair', 'Nails'};
  int _rating = 4;
  String _serviceFor = 'All';
  double _distance = 10;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('Cancel', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                    ),
                    Text('Filter', style: AppTextStyles.subtitle),
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedServices.clear();
                        _rating = 0;
                        _serviceFor = 'All';
                        _distance = 50;
                      }),
                      child: Text('Reset', style: AppTextStyles.body.copyWith(color: AppColors.error)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Available on
                Text('Available on', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.chevron_left, color: AppColors.textGrey),
                    Text('March, 2021', style: AppTextStyles.bodySemiBold),
                    const Icon(Icons.chevron_right, color: AppColors.textGrey),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _DayChip(day: 'Wed', date: 9, isSelected: _selectedDay == 9, onTap: () => setState(() => _selectedDay = 9)),
                      _DayChip(day: 'Thu', date: 10, isSelected: _selectedDay == 10, onTap: () => setState(() => _selectedDay = 10)),
                      _DayChip(day: 'Fri', date: 11, isSelected: _selectedDay == 11, onTap: () => setState(() => _selectedDay = 11)),
                      _DayChip(day: 'Sat', date: 12, isSelected: _selectedDay == 12, onTap: () => setState(() => _selectedDay = 12)),
                      _DayChip(day: 'Sun', date: 13, isSelected: _selectedDay == 13, isDisabled: true, onTap: () {}),
                      _DayChip(day: 'Mon', date: 14, isSelected: _selectedDay == 14, onTap: () => setState(() => _selectedDay = 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Service
                Text('Service', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['Hair', 'Nails', 'Coloring', 'Message', 'Facials', 'Waxing', 'Coloring', 'Makeup', 'Spa'].map((s) {
                    final isSelected = _selectedServices.contains(s);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (isSelected) {
                          _selectedServices.remove(s);
                        } else {
                          _selectedServices.add(s);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : Colors.transparent,
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(s, style: AppTextStyles.captionMedium.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                        )),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Rating
                Text('Rating', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ...List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            i < _rating ? Icons.star : Icons.star_border,
                            color: AppColors.star,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                    Text('$_rating Star', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 24),

                // Service for
                Text('Service for', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  children: ['All', 'Woman', 'Men', 'Kids'].map((s) {
                    final isSelected = _serviceFor == s;
                    return GestureDetector(
                      onTap: () => setState(() => _serviceFor = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : Colors.transparent,
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(s, style: AppTextStyles.captionMedium.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                        )),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Distance
                Text('Distance', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.divider,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Slider(
                    value: _distance,
                    min: 0,
                    max: 50,
                    onChanged: (v) => setState(() => _distance = v),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0 km', style: AppTextStyles.small),
                    Text('${_distance.toInt()} km', style: AppTextStyles.small),
                  ],
                ),
                const SizedBox(height: 32),

                // Show Result
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: Text('Show Result', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DayChip extends StatelessWidget {
  final String day;
  final int date;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _DayChip({
    required this.day,
    required this.date,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 56,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isDisabled
                  ? AppColors.inputFill
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected || isDisabled ? null : Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: AppTextStyles.small.copyWith(
                color: isSelected
                    ? AppColors.white
                    : isDisabled
                        ? AppColors.textLight
                        : AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$date',
              style: AppTextStyles.heading3.copyWith(
                color: isSelected
                    ? AppColors.white
                    : isDisabled
                        ? AppColors.textLight
                        : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
