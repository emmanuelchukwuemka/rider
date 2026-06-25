import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/custom_auth/auth_util.dart';
import 'd_payment_model.dart';
export 'd_payment_model.dart';

class DPaymentWidget extends StatefulWidget {
  const DPaymentWidget({super.key});

  static String routeName = 'DPayment';
  static String routePath = '/d_payment';

  @override
  State<DPaymentWidget> createState() => _DPaymentWidgetState();
}

class _DPaymentWidgetState extends State<DPaymentWidget> {
  late DPaymentModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DPaymentModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _showCashOutSheet(BuildContext context, double balance) {
    final theme = FlutterFlowTheme.of(context);
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.alternate,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cash Out',
                    style: GoogleFonts.inter(
                      color: theme.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Available: ₦${balance.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                        color: theme.secondaryText, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(
                        color: theme.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: GoogleFonts.inter(
                          color: theme.secondaryText, fontSize: 22),
                      prefixText: '₦  ',
                      prefixStyle: GoogleFonts.inter(
                          color: theme.secondaryText, fontSize: 22),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            BorderSide(color: theme.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quick amount chips
                  Wrap(
                    spacing: 8,
                    children: ['₦1,000', '₦5,000', '₦10,000', 'All'].map((v) {
                      return GestureDetector(
                        onTap: () {
                          if (v == 'All') {
                            controller.text = balance.toStringAsFixed(2);
                          } else {
                            controller.text =
                                v.replaceAll('₦', '').replaceAll(',', '');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: theme.primary.withOpacity(0.3)),
                          ),
                          child: Text(
                            v,
                            style: GoogleFonts.inter(
                              color: theme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Withdrawal request submitted!'),
                          backgroundColor: const Color(0xFF16A34A),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Request Withdrawal',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return StreamBuilder<List<UserDriverRecord>>(
      stream: queryCurrentDriverRecord(),
      builder: (context, snapshot) {
        final driver =
            snapshot.hasData && snapshot.data!.isNotEmpty
                ? snapshot.data!.first
                : null;
        final walletBalance = driver?.walletBalance ?? 0.0;
        final totalTrips = driver?.totalTrips ?? 0;
        final rating = driver?.driverRating?.toStringAsFixed(1) ?? '5.0';

        return StreamBuilder<List<RideRecord>>(
          stream: queryRideRecord(),
          builder: (context, rideSnapshot) {
            final rides = rideSnapshot.data ?? [];
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
            final monthStart = DateTime(now.year, now.month, 1);

            final todayEarnings = rides
                .where((r) => r.completedAt != null && r.completedAt!.isAfter(todayStart))
                .fold<double>(0.0, (sum, r) => sum + r.finalFare);
            final weeklyEarnings = rides
                .where((r) => r.completedAt != null && r.completedAt!.isAfter(weekStart))
                .fold<double>(0.0, (sum, r) => sum + r.finalFare);
            final monthlyEarnings = rides
                .where((r) => r.completedAt != null && r.completedAt!.isAfter(monthStart))
                .fold<double>(0.0, (sum, r) => sum + r.finalFare);
            final recentRides = rides
                .where((r) => r.completedAt != null)
                .toList()
              ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.primaryBackground,
          body: CustomScrollView(
            slivers: [
              // ── Hero header ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primary,
                        theme.primary.withOpacity(0.72),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.arrow_back_rounded,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Earnings & Wallet',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          // Balance label
                          Text(
                            'Available Balance',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Balance amount
                          Text(
                            '₦${walletBalance.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Quick stats row
                          Row(
                            children: [
                              _heroStat('₦${todayEarnings.toStringAsFixed(2)}', 'Today'),
                              _heroDivider(),
                              _heroStat('₦${weeklyEarnings.toStringAsFixed(2)}', 'This Week'),
                              _heroDivider(),
                              _heroStat('$totalTrips', 'Total Trips'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Action buttons ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: theme.alternate),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ActionBtn(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Cash Out',
                          color: theme.primary,
                          onTap: () => _showCashOutSheet(context, walletBalance),
                        ),
                        _ActionBtn(
                          icon: Icons.account_balance_rounded,
                          label: 'Bank Account',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          ),
                        ),
                        _ActionBtn(
                          icon: Icons.insights_rounded,
                          label: 'Analytics',
                          color: const Color(0xFF0EA5E9),
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          ),
                        ),
                        _ActionBtn(
                          icon: Icons.receipt_long_rounded,
                          label: 'Statement',
                          color: const Color(0xFFF59E0B),
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Earnings summary cards ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earnings Overview',
                        style: GoogleFonts.inter(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _EarningsCard(
                              label: 'This Month',
                              value: '₦${monthlyEarnings.toStringAsFixed(2)}',
                              icon: Icons.calendar_month_rounded,
                              trend: '',
                              positive: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _EarningsCard(
                              label: 'Driver Rating',
                              value: '★ $rating',
                              icon: Icons.star_rounded,
                              trend: 'Excellent',
                              positive: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Recent transactions header ─────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: GoogleFonts.inter(
                          color: theme.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'See All',
                        style: GoogleFonts.inter(
                          color: theme.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Transactions list ─────────────────────────────────────
              recentRides.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.alternate),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.receipt_long_rounded,
                                    color: theme.primary, size: 30),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'No transactions yet',
                                style: GoogleFonts.inter(
                                  color: theme.primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Complete trips to see your earnings here',
                                style: GoogleFonts.inter(
                                  color: theme.secondaryText,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final ride = recentRides[index];
                          final dateStr = ride.completedAt != null
                              ? dateTimeFormat('MMM d, h:mm a', ride.completedAt)
                              : '—';
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.alternate),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: theme.primary.withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.directions_car_rounded,
                                            color: theme.primary, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Trip Completed',
                                            style: GoogleFonts.inter(
                                              color: theme.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            dateStr,
                                            style: GoogleFonts.inter(
                                              color: theme.secondaryText,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '+₦${ride.finalFare.toStringAsFixed(2)}',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF16A34A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: recentRides.length,
                      ),
                    ),
            ],
          ),

          // ── Bottom nav ────────────────────────────────────────────────
          bottomNavigationBar: _DriverBottomNav(activeIndex: 1),
        );
      },
    );
  }
    );
  }

  Widget _heroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _heroDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white30,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: theme.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  const _EarningsCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
    required this.positive,
  });

  final String label;
  final String value;
  final IconData icon;
  final String trend;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final trendColor =
        positive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: theme.primary, size: 18),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: trendColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trend,
                  style: GoogleFonts.inter(
                    color: trendColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              color: theme.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: theme.secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared bottom nav ─────────────────────────────────────────────────────────

class _DriverBottomNav extends StatelessWidget {
  const _DriverBottomNav({required this.activeIndex});
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final items = <(IconData, String, VoidCallback)>[
      (Icons.home_rounded, 'Home',
          () => context.pushReplacementNamed('DriverDashboard6')),
      (Icons.insights_rounded, 'Earnings',
          () => context.pushReplacementNamed('DPayment')),
      (Icons.history_rounded, 'Rides',
          () => context.pushNamed('DRideHistory')),
      (Icons.person_outline_rounded, 'Profile',
          () => context.pushNamed('DriverEditProfile')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(top: BorderSide(color: theme.alternate, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < items.length; i++)
                GestureDetector(
                  onTap: items[i].$3,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: i == activeIndex
                              ? theme.primary.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          items[i].$1,
                          color: i == activeIndex
                              ? theme.primary
                              : theme.secondaryText,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$2,
                        style: GoogleFonts.inter(
                          color: i == activeIndex
                              ? theme.primary
                              : theme.secondaryText,
                          fontSize: 11,
                          fontWeight: i == activeIndex
                              ? FontWeight.w600
                              : FontWeight.w400,
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
  }
}
