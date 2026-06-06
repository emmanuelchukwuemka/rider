// socket_service.dart mock
class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  bool isConnected = false;

  Function(dynamic)? onNewRideOffer;
  Function(dynamic)? onRideAccepted;
  Function(dynamic)? onDriverLocationUpdated;
  Function(dynamic)? onRideStarted;
  Function(dynamic)? onRideCompleted;
  Function(dynamic)? onRideCancelled;

  void initSocket(String userId, String role) {}
  void updateLocation(double lat, double lng) {}
  void disconnect() {}
}
