import '/auth/custom_auth/auth_util.dart';
import '/backend/api_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PMyScheduledRidesWidget extends StatefulWidget {
  const PMyScheduledRidesWidget({super.key});

  static String routeName = 'PMyScheduledRides';
  static String routePath = '/pMyScheduledRides';

  @override
  State<PMyScheduledRidesWidget> createState() => _PMyScheduledRidesWidgetState();
}

class _PMyScheduledRidesWidgetState extends State<PMyScheduledRidesWidget> {
  List<Map<String, dynamic>> _rides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final all = await fetchScheduledRides(userId: currentUserUid);
    if (!mounted) return;
    setState(() { _rides = all; _loading = false; });
  }

  Future<void> _cancel(String rideId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text('Are you sure you want to cancel this scheduled ride?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final ok = await cancelScheduledRide(rideId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Ride cancelled.' : 'Failed to cancel. Please try again.'),
      backgroundColor: ok ? const Color(0xFF16A34A) : Colors.red,
    ));
    if (ok) _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'My Scheduled Rides',
          style: GoogleFonts.inter(color: theme.primaryText, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.primaryText),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : _rides.isEmpty
              ? _buildEmpty(theme)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _rides.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _RideCard(
                      ride: _rides[i],
                      theme: theme,
                      onCancel: _cancel,
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmpty(FlutterFlowTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: theme.secondaryText),
          const SizedBox(height: 16),
          Text('No scheduled rides', style: GoogleFonts.inter(color: theme.primaryText, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Rides you schedule will appear here', style: GoogleFonts.inter(color: theme.secondaryText, fontSize: 14)),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({required this.ride, required this.theme, required this.onCancel});
  final Map<String, dynamic> ride;
  final FlutterFlowTheme theme;
  final Future<void> Function(String) onCancel;

  @override
  Widget build(BuildContext context) {
    final rideId = ride['id']?.toString() ?? ride['_id']?.toString() ?? '';
    final pickup = ride['pickup_address']?.toString() ?? '—';
    final dropoff = ride['dropoff_address']?.toString() ?? '—';
    final rawTime = ride['scheduled_time'] ?? ride['scheduledTime'];
    DateTime? scheduledAt;
    if (rawTime != null) scheduledAt = DateTime.tryParse(rawTime.toString());
    final dateStr = scheduledAt != null ? dateTimeFormat('EEE, MMM d · h:mm a', scheduledAt) : '—';
    final fare = ride['estimated_fare'] ?? ride['estimatedFare'];
    final fareStr = fare != null ? '₦${double.tryParse(fare.toString())?.toStringAsFixed(0) ?? fare}' : '—';
    final status = ride['status']?.toString() ?? 'pending';
    final isPending = status.toLowerCase() == 'pending';
    final isCancelled = status.toLowerCase() == 'cancelled';

    Color statusColor;
    if (isCancelled) {
      statusColor = Colors.red;
    } else if (status.toLowerCase() == 'accepted') {
      statusColor = const Color(0xFF16A34A);
    } else {
      statusColor = theme.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: GoogleFonts.inter(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(dateStr, style: GoogleFonts.inter(color: theme.secondaryText, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 14),
            // Route
            Row(
              children: [
                Column(children: [
                  Icon(Icons.radio_button_checked_rounded, color: theme.primary, size: 16),
                  Container(width: 2, height: 28, color: theme.alternate),
                  Icon(Icons.location_on_rounded, color: theme.error, size: 16),
                ]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pickup, style: GoogleFonts.inter(color: theme.primaryText, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 18),
                      Text(dropoff, style: GoogleFonts.inter(color: theme.primaryText, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: theme.alternate, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Est. Fare: $fareStr', style: GoogleFonts.inter(color: theme.primaryText, fontSize: 14, fontWeight: FontWeight.w600)),
                if (isPending && rideId.isNotEmpty)
                  GestureDetector(
                    onTap: () => onCancel(rideId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text('Cancel', style: GoogleFonts.inter(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
