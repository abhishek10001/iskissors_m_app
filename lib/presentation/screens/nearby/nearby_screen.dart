import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';

class NearbyScreen extends ConsumerStatefulWidget {
  const NearbyScreen({super.key});

  @override
  ConsumerState<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends ConsumerState<NearbyScreen>
    with TickerProviderStateMixin {
  bool _showList = false;
  String _selectedCategory = 'Hair';
  int _selectedPinIndex = 2;

  final List<String> _categories = [
    'Hair',
    'Nails',
    'Facial',
    'Coloring',
    'Spa',
  ];

  @override
  Widget build(BuildContext context) {
    final nearbySalons = ref.watch(nearbySalonsProvider);
    final seatData = ref.watch(seatAvailabilityProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Map background ──────────────────────────────────────────
          SizedBox.expand(
            child: CustomPaint(painter: _MapPlaceholderPainter()),
          ),

          // ── Map pins ────────────────────────────────────────────────
          ..._buildMapPins(size, seatData),

          // ── Top bar (search + categories) ───────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 10),
                _buildCategoryChips(),
              ],
            ),
          ),

          // ── FAB controls ────────────────────────────────────────────
          _buildFabControls(),

          // ── List toggle button ──────────────────────────────────────
          _buildListToggle(),

          // ── Bottom content (card or list) ───────────────────────────
          if (_showList)
            _buildSalonList(nearbySalons, seatData)
          else
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: _buildSalonCard(nearbySalons, seatData),
            ),
        ],
      ),
    );
  }

  // ── Shared category chip builder (used by both map & list views) ─────────
  Widget _buildChip(String label, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTextStyles.captionMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Search bar + filter ──────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your location',
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.textGrey,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '360 Stillwater Rd. Palm',
                              style: AppTextStyles.captionMedium.copyWith(
                                color: AppColors.textDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ── Category chips (shared) ──────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) =>
            _buildChip(_categories[i], _categories[i] == _selectedCategory),
      ),
    );
  }

  // ── Map pins with seat availability indicators ───────────────────────────
  List<Widget> _buildMapPins(
    Size size,
    AsyncValue<Map<String, SeatAvailabilityModel>> seatData,
  ) {
    // Pin positions mapped to salon IDs
    final pins = [
      (0.28, 0.33, '3'),
      (0.62, 0.28, '1'),
      (0.18, 0.48, '4'),
      (0.72, 0.43, '2'),
      (0.50, 0.53, '5'),
      (0.32, 0.62, '6'),
      (0.66, 0.58, '3'),
    ];

    return pins.asMap().entries.map((entry) {
      final i = entry.key;
      final (dx, dy, salonId) = entry.value;
      final isSelected = i == _selectedPinIndex;

      // Get seat availability for this salon
      final seats = seatData.whenData((data) => data[salonId]);

      return Positioned(
        left: size.width * dx,
        top: size.height * dy,
        child: GestureDetector(
          onTap: () => setState(() => _selectedPinIndex = i),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (_, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: isSelected
                ? _SelectedPinWidget(seatAvailability: seats.valueOrNull)
                : _DefaultPinWidget(seatAvailability: seats.valueOrNull),
          ),
        ),
      );
    }).toList();
  }

  // ── FAB controls ─────────────────────────────────────────────────────────
  Widget _buildFabControls() {
    return Positioned(
      bottom: 210,
      right: 16,
      child: Column(
        children: [
          _FabButton(
            color: AppColors.primary,
            icon: Icons.navigation_rounded,
            iconColor: Colors.white,
            size: 56,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 10),
          _FabButton(
            color: Colors.white,
            icon: Icons.my_location_rounded,
            iconColor: AppColors.primary,
            size: 48,
          ),
          const SizedBox(height: 10),
          _FabButton(
            color: Colors.white,
            icon: Icons.add,
            iconColor: AppColors.textDark,
            size: 40,
          ),
          const SizedBox(height: 4),
          _FabButton(
            color: Colors.white,
            icon: Icons.remove,
            iconColor: AppColors.textDark,
            size: 40,
          ),
        ],
      ),
    );
  }

  // ── List toggle ──────────────────────────────────────────────────────────
  Widget _buildListToggle() {
    return Positioned(
      bottom: 210,
      left: 16,
      child: GestureDetector(
        onTap: () => setState(() => _showList = !_showList),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _showList ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showList
                    ? Icons.map_rounded
                    : Icons.format_list_bulleted_rounded,
                color: _showList ? Colors.white : AppColors.textDark,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                _showList ? 'Map' : 'List',
                style: AppTextStyles.captionMedium.copyWith(
                  color: _showList ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Salon card (map mode) ────────────────────────────────────────────────
  Widget _buildSalonCard(
    AsyncValue nearbySalons,
    AsyncValue<Map<String, SeatAvailabilityModel>> seatData,
  ) {
    return nearbySalons.when(
        data: (salons) {
          if (salons.isEmpty) return const SizedBox.shrink();
          final salon = salons[0];
          final seats = seatData.whenData((data) => data[salon.id]);

          return GestureDetector(
            onTap: () => context.push('/shop/${salon.id}'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Image with discount badge
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              salon.imageUrl,
                              width: 100,
                              height: 95,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height: 95,
                                color: AppColors.inputFill,
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  color: AppColors.textGrey,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          if (salon.discount > 0)
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '-${salon.discount}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  salon.categories.take(2).join(' · '),
                                  style: AppTextStyles.small.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                _StatusBadge(isOpen: salon.isOpen),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              salon.name,
                              style: AppTextStyles.bodySemiBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_outlined,
                                  size: 12,
                                  color: AppColors.textGrey,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    salon.address,
                                    style: AppTextStyles.small,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.star,
                                  size: 16,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${salon.rating}',
                                  style: AppTextStyles.smallBold.copyWith(
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  ' (${_fmtCount(salon.reviewCount)})',
                                  style: AppTextStyles.small,
                                ),
                                const Spacer(),
                                _DistanceChip(distance: '0.3 km'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ── Realtime seat availability bar ──────────────────
                  if (seats.valueOrNull != null) ...[
                    const SizedBox(height: 10),
                    _RealtimeSeatBar(seat: seats.valueOrNull!),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
    );
  }

  // ── Salon list (sheet mode) ──────────────────────────────────────────────
  Widget _buildSalonList(
    AsyncValue nearbySalons,
    AsyncValue<Map<String, SeatAvailabilityModel>> seatData,
  ) {
    return DraggableScrollableSheet(
      key: const ValueKey('list'),
      initialChildSize: 0.52,
      minChildSize: 0.14,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.14, 0.52, 0.88],
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 4),
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nearby Salons', style: AppTextStyles.heading3),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Live availability',
                              style: AppTextStyles.small.copyWith(
                                color: const Color(0xFF22C55E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Sort button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.swap_vert_rounded,
                            size: 16,
                            color: AppColors.textDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sort',
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Reused category chips
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => _buildChip(
                    _categories[i],
                    _categories[i] == _selectedCategory,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              // List with seat availability
              Expanded(
                child: nearbySalons.when(
                  data: (salons) => ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: salons.length,
                    separatorBuilder: (_, __) => const Divider(
                      indent: 20,
                      endIndent: 20,
                      height: 1,
                      color: Color(0xFFF1F5F9),
                    ),
                    itemBuilder: (_, i) {
                      final salon = salons[i];
                      final seats = seatData.whenData((data) => data[salon.id]);
                      return _SalonListItemWithSeats(
                        salon: salon,
                        seatAvailability: seats.valueOrNull,
                        onTap: () => context.push('/shop/${salon.id}'),
                      );
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.textGrey,
                          size: 36,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Could not load salons',
                          style: AppTextStyles.captionMedium.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmtCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ── Reusable widgets ────────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

/// Realtime seat availability bar shown on salon cards
class _RealtimeSeatBar extends StatelessWidget {
  final SeatAvailabilityModel seat;
  const _RealtimeSeatBar({required this.seat});

  @override
  Widget build(BuildContext context) {
    final Color barColor;
    final String statusText;
    final IconData statusIcon;

    if (seat.isFull) {
      barColor = const Color(0xFFEF4444);
      statusText = 'Full – No seats';
      statusIcon = Icons.event_busy_rounded;
    } else if (seat.isAlmostFull) {
      barColor = const Color(0xFFF59E0B);
      statusText =
          '${seat.availableSeats} seat${seat.availableSeats > 1 ? 's' : ''} left';
      statusIcon = Icons.event_available_rounded;
    } else {
      barColor = const Color(0xFF22C55E);
      statusText = '${seat.availableSeats} of ${seat.totalSeats} available';
      statusIcon = Icons.event_seat_rounded;
    }

    final progress = seat.totalSeats > 0
        ? seat.occupiedSeats / seat.totalSeats
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: barColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: barColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(statusIcon, size: 16, color: barColor),
              const SizedBox(width: 6),
              Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: barColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: barColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusText,
                  style: AppTextStyles.smallBold.copyWith(color: barColor),
                ),
              ),
              Text(
                '${seat.occupiedSeats}/${seat.totalSeats}',
                style: AppTextStyles.small.copyWith(
                  color: barColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: barColor.withValues(alpha: 0.15),
              color: barColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact seat badge shown on map pins
class _SeatBadge extends StatelessWidget {
  final SeatAvailabilityModel seat;
  const _SeatBadge({required this.seat});

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (seat.isFull) {
      color = const Color(0xFFEF4444);
    } else if (seat.isAlmostFull) {
      color = const Color(0xFFF59E0B);
    } else {
      color = const Color(0xFF22C55E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        seat.isFull ? 'FULL' : '${seat.availableSeats}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Selected map pin with pulsing animation and seat count
class _SelectedPinWidget extends StatefulWidget {
  final SeatAvailabilityModel? seatAvailability;
  const _SelectedPinWidget({this.seatAvailability});

  @override
  State<_SelectedPinWidget> createState() => _SelectedPinWidgetState();
}

class _SelectedPinWidgetState extends State<_SelectedPinWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _pulse = Tween<double>(
    begin: 0.85,
    end: 1.15,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.seatAvailability != null)
            _SeatBadge(seat: widget.seatAvailability!),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Default (unselected) map pin with optional seat badge
class _DefaultPinWidget extends StatelessWidget {
  final SeatAvailabilityModel? seatAvailability;
  const _DefaultPinWidget({this.seatAvailability});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (seatAvailability != null) _SeatBadge(seat: seatAvailability!),
        Icon(
          Icons.location_on_rounded,
          color: AppColors.primary.withValues(alpha: 0.7),
          size: 30,
        ),
      ],
    );
  }
}

/// Open/Closed status badge
class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Distance chip
class _DistanceChip extends StatelessWidget {
  final String distance;
  const _DistanceChip({required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.directions_walk_rounded,
            size: 12,
            color: AppColors.textGrey,
          ),
          const SizedBox(width: 3),
          Text(
            distance,
            style: AppTextStyles.small.copyWith(
              fontSize: 10,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Salon list item with embedded realtime seat availability
class _SalonListItemWithSeats extends StatelessWidget {
  final SalonModel salon;
  final SeatAvailabilityModel? seatAvailability;
  final VoidCallback onTap;

  const _SalonListItemWithSeats({
    required this.salon,
    required this.seatAvailability,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    salon.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.inputFill,
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
                // Seat indicator dot on image
                if (seatAvailability != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: seatAvailability!.isFull
                            ? const Color(0xFFEF4444)
                            : seatAvailability!.isAlmostFull
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    salon.categories.take(2).join(' · '),
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${salon.rating}',
                        style: AppTextStyles.smallBold.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      if (seatAvailability != null) ...[
                        const SizedBox(width: 10),
                        Icon(
                          Icons.event_seat_rounded,
                          size: 14,
                          color: seatAvailability!.isFull
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF22C55E),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          seatAvailability!.isFull
                              ? 'Full'
                              : '${seatAvailability!.availableSeats} seats',
                          style: AppTextStyles.small.copyWith(
                            color: seatAvailability!.isFull
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF22C55E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        salon.distance.isNotEmpty ? salon.distance : '0.3 km',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double size;
  final Color? shadowColor;

  const _FabButton({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.size,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: size * 0.42),
    );
  }
}

// ── Map painter ──────────────────────────────────────────────────────────────

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFEAE6DA),
    );

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFD6D0C4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Minor grid
    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), minorRoadPaint);
    }
    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), minorRoadPaint);
    }

    // Major roads
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width, size.height * 0.65),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.35, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.65, size.height),
      roadPaint,
    );

    // Park block
    final parkPaint = Paint()..color = const Color(0xFFC8DEB8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.42,
          size.width * 0.22,
          size.height * 0.2,
        ),
        const Radius.circular(6),
      ),
      parkPaint,
    );

    // Building blocks
    final blockPaint = Paint()..color = const Color(0xFFCBC5B5);
    final positions = [
      (0.05, 0.1, 0.25, 0.22),
      (0.38, 0.08, 0.22, 0.25),
      (0.68, 0.1, 0.28, 0.22),
      (0.05, 0.44, 0.22, 0.18),
      (0.68, 0.44, 0.28, 0.18),
      (0.05, 0.68, 0.25, 0.22),
      (0.38, 0.68, 0.22, 0.22),
      (0.68, 0.68, 0.28, 0.22),
    ];

    for (final (x, y, w, h) in positions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * x,
            size.height * y,
            size.width * w,
            size.height * h,
          ),
          const Radius.circular(5),
        ),
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
