import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  // Ride IDs the driver has already dismissed (timed out / declined) this session
  final Set<String> dismissedRideIds = {};

  Function(dynamic)? onNewRideOffer;
  Function(dynamic)? onRideAccepted;
  Function(dynamic)? onRideStarted;
  Function(dynamic)? onRideCompleted;
  Function(dynamic)? onRideCancelled;
  Function(dynamic)? onDriverLocationUpdated;
  Function(dynamic)? onDriverArrived;
  Function(dynamic)? onChatMessage;

  static const String _serverUrl = 'https://quickbackend-733b.onrender.com';

  bool get isConnected => _socket?.connected ?? false;

  void initSocket(String userId, String role) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('register', {'id': userId, 'role': role});
      return;
    }

    _socket = IO.io(
      _serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.onConnect((_) {
      print('[Socket] Connected as $role ($userId)');
      _socket!.emit('register', {'id': userId, 'role': role});
    });

    _socket!.onDisconnect((_) => print('[Socket] Disconnected'));
    _socket!.onConnectError((e) => print('[Socket] Connect error: $e'));
    _socket!.onError((e) => print('[Socket] Error: $e'));

    _socket!.on('new_ride_offer', (data) {
      print('[Socket] new_ride_offer: $data');
      onNewRideOffer?.call(data);
    });

    _socket!.on('ride_accepted', (data) {
      print('[Socket] ride_accepted: $data');
      onRideAccepted?.call(data);
    });

    _socket!.on('ride_started', (data) {
      print('[Socket] ride_started: $data');
      onRideStarted?.call(data);
    });

    _socket!.on('ride_completed', (data) {
      print('[Socket] ride_completed: $data');
      onRideCompleted?.call(data);
    });

    _socket!.on('driverLocationUpdated', (data) {
      onDriverLocationUpdated?.call(data);
    });

    _socket!.on('driver_arrived', (data) {
      print('[Socket] driver_arrived: $data');
      onDriverArrived?.call(data);
    });
    _socket!.on('driverArrived', (data) {
      print('[Socket] driverArrived: $data');
      onDriverArrived?.call(data);
    });

    _socket!.on('ride_cancelled', (data) {
      print('[Socket] ride_cancelled: $data');
      onRideCancelled?.call(data);
    });

    _socket!.on('chat_message', (data) {
      onChatMessage?.call(data);
    });

    _socket!.connect();
  }

  void updateLocation(double lat, double lng, {String? driverId, String? userId}) {
    if (_socket == null || !_socket!.connected) return;
    if (driverId != null) {
      _socket!.emit('updateLocation', {'driverId': driverId, 'lat': lat, 'lng': lng});
    } else if (userId != null) {
      _socket!.emit('updateUserLocation', {'userId': userId, 'lat': lat, 'lng': lng});
    }
  }

  void sendChatMessage({
    required String rideId,
    required String toId,
    required String toRole,
    required String message,
    required String senderName,
    required String senderId,
  }) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('chat_message', {
      'rideId': rideId,
      'toId': toId,
      'toRole': toRole,
      'message': message,
      'senderName': senderName,
      'senderId': senderId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
