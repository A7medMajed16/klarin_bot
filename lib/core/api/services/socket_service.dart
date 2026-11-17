// import 'dart:async' show Completer, StreamController, TimeoutException;

// import 'package:flutter/widgets.dart' show AppLifecycleListener;
// import 'package:injectable/injectable.dart' show lazySingleton;
// import 'package:socket_io_client/socket_io_client.dart' as socket_io;

// import '../../helper/core/app_logger.dart';
// import '../common/end_points.dart';
// import 'socket_keep_alive.dart';

// enum SocketConnectionState {
//   disconnected,
//   connecting,
//   connected,
//   reconnecting,
//   error,
//   unauthorized,
// }

// typedef SocketEventHandler = void Function(dynamic data);

// @lazySingleton
// class SocketService {
//   SocketService(this._keepAlive) {
//     _lifecycleListener = AppLifecycleListener(
//       onPause: _handleAppBackgrounded,
//       onHide: _handleAppBackgrounded,
//       onInactive: _handleAppBackgrounded,
//       onResume: _handleAppResumed,
//     );
//   }

//   static const String _tag = 'SocketService';

//   final SocketKeepAlive _keepAlive;
//   late final AppLifecycleListener _lifecycleListener;

//   bool _shouldStayConnected = false;
//   bool _backgroundKeepAliveHeld = false;

//   socket_io.Socket? _socket;
//   String? _activeUrl;
//   SocketConnectionState _connectionState = SocketConnectionState.disconnected;

//   String? _lastUrl;
//   String? _lastNamespace;
//   Map<String, dynamic>? _lastQuery;
//   Map<String, dynamic>? _lastAuth;
//   Map<String, dynamic>? _lastExtraHeaders;

//   final Map<String, List<SocketEventHandler>> _handlers = {};
//   bool _isAnyEventLoggingEnabled = false;
//   dynamic Function(String, dynamic)? _anyEventLogger;

//   StreamController<SocketConnectionState> _connectionStateController =
//       StreamController<SocketConnectionState>.broadcast();

//   Stream<SocketConnectionState> get connectionStateStream {
//     _ensureConnectionController();
//     return _connectionStateController.stream;
//   }

//   SocketConnectionState get connectionState => _connectionState;

//   bool get isConnected =>
//       _connectionState == SocketConnectionState.connected &&
//       (_socket?.connected ?? false);

//   //! ─── Lifecycle ───

//   Future<void> connect({
//     String? url,
//     String? namespace,
//     Map<String, dynamic>? query,
//     Map<String, dynamic>? auth,
//     Map<String, dynamic>? extraHeaders,
//     bool forceNew = false,
//   }) async {
//     _shouldStayConnected = true;
//     final resolvedUrl = _resolveUrl(url, namespace);

//     _lastUrl = url;
//     _lastNamespace = namespace;
//     _lastQuery = query;
//     _lastAuth = auth;
//     _lastExtraHeaders = extraHeaders;

//     if (_socket != null &&
//         !forceNew &&
//         _activeUrl == resolvedUrl &&
//         !_connectionStateController.isClosed) {
//       if (_socket!.connected) {
//         AppLogger.info(
//           'Already connected to $resolvedUrl — skipping connect',
//           tag: _tag,
//         );
//         return;
//       }
//       AppLogger.info('Reconnecting existing socket to $resolvedUrl', tag: _tag);
//       _updateState(SocketConnectionState.connecting);
//       final ready = _waitForConnectionAttempt();
//       _socket!.connect();
//       await ready;
//       return;
//     }

//     final hadExistingSocket = _socket != null;
//     if (hadExistingSocket) {
//       await _tearDownSocket(clearUserHandlers: false);
//     }

//     _ensureConnectionController();
//     _activeUrl = resolvedUrl;
//     _updateState(SocketConnectionState.connecting);

//     try {
//       final options = _buildOptions(
//         query: query,
//         auth: auth,
//         extraHeaders: extraHeaders,
//         forceNew: forceNew || hadExistingSocket,
//       );

//       AppLogger.info('Connecting to $resolvedUrl', tag: _tag);

//       _socket = socket_io.io(resolvedUrl, options);
//       _attachLifecycleListeners();
//       _reattachUserListeners();
//       final ready = _waitForConnectionAttempt();
//       _socket!.connect();
//       await ready;
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to connect to $resolvedUrl: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//       _updateState(SocketConnectionState.error);
//     }
//   }

//   Future<void> _waitForConnectionAttempt({
//     Duration timeout = const Duration(seconds: 20),
//   }) async {
//     final socket = _socket;
//     if (socket == null) return;
//     if (socket.connected) return;

//     final completer = Completer<void>();

//     void complete() {
//       if (!completer.isCompleted) completer.complete();
//     }

//     void onConnect(dynamic _) => complete();
//     void onConnectError(dynamic _) => complete();

//     socket.once('connect', onConnect);
//     socket.once('connect_error', onConnectError);

//     try {
//       await completer.future.timeout(timeout);
//     } on TimeoutException {
//       AppLogger.warning(
//         'Socket connect attempt timed out after $timeout',
//         tag: _tag,
//       );
//       complete();
//     } finally {
//       socket.off('connect', onConnect);
//       socket.off('connect_error', onConnectError);
//     }
//   }

//   /// Disconnects the socket session.
//   ///
//   /// When [disposeSocket] is true the underlying client is fully torn down
//   /// (logout). Soft disconnect only stops the current connection.
//   Future<void> disconnect({bool disposeSocket = false}) async {
//     _shouldStayConnected = false;
//     await _releaseBackgroundKeepAlive();
//     if (disposeSocket) {
//       AppLogger.info('Terminating socket session', tag: _tag);
//       await _tearDownSocket(clearUserHandlers: true);
//       _activeUrl = null;
//       return;
//     }
//     try {
//       if (_socket == null) {
//         _updateState(SocketConnectionState.disconnected);
//         return;
//       }
//       AppLogger.info('Disconnecting socket', tag: _tag);
//       _socket!.disconnect();
//       _updateState(SocketConnectionState.disconnected);
//     } catch (e, st) {
//       AppLogger.error(
//         'Error during disconnect: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   /// Disconnects then connects again using the last [connect] parameters.
//   Future<void> reconnect() async {
//     AppLogger.info('Manual reconnect requested', tag: _tag);
//     if (_socket != null) {
//       try {
//         _updateState(SocketConnectionState.reconnecting);
//         _socket!.disconnect();
//         _socket!.connect();
//       } catch (e, st) {
//         AppLogger.error(
//           'Manual reconnect failed: $e',
//           error: e,
//           stackTrace: st,
//           tag: _tag,
//         );
//         _updateState(SocketConnectionState.error);
//       }
//       return;
//     }

//     await connect(
//       url: _lastUrl,
//       namespace: _lastNamespace,
//       query: _lastQuery,
//       auth: _lastAuth,
//       extraHeaders: _lastExtraHeaders,
//       forceNew: true,
//     );
//   }

//   /// Fully tears down the socket, clears listeners, and closes the state stream.
//   ///
//   /// Call only on logout / app teardown. Safe to call [connect] again afterward.
//   Future<void> dispose() async {
//     AppLogger.info('Disposing socket service', tag: _tag);
//     _shouldStayConnected = false;
//     await _releaseBackgroundKeepAlive();
//     _lifecycleListener.dispose();
//     await _tearDownSocket(clearUserHandlers: true);
//     _activeUrl = null;
//     if (!_connectionStateController.isClosed) {
//       await _connectionStateController.close();
//     }
//     _updateState(SocketConnectionState.disconnected, notify: false);
//   }

//   //! ─── Listeners ───

//   /// Registers [handler] for [event]. Duplicate identical handlers are ignored.
//   void on(String event, SocketEventHandler handler) {
//     final list = _handlers.putIfAbsent(event, () => <SocketEventHandler>[]);
//     if (list.contains(handler)) {
//       AppLogger.warning(
//         'Handler already registered for "$event" — skipping',
//         tag: _tag,
//       );
//       return;
//     }
//     list.add(handler);

//     try {
//       _socket?.on(event, handler);
//       AppLogger.debug('Listening for "$event"', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to listen for "$event": $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   /// Removes [handler] for [event], or all handlers for [event] if [handler] is null.
//   void off(String event, [SocketEventHandler? handler]) {
//     try {
//       if (handler != null) {
//         _handlers[event]?.remove(handler);
//         if (_handlers[event]?.isEmpty ?? false) {
//           _handlers.remove(event);
//         }
//         _socket?.off(event, handler);
//       } else {
//         _handlers.remove(event);
//         _socket?.off(event);
//       }
//       AppLogger.debug(
//         'Removed listener(s) for "$event"${handler == null ? ' (all)' : ''}',
//         tag: _tag,
//       );
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to remove listener for "$event": $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   /// Removes all user-registered event handlers (not connection lifecycle).
//   void offAll() {
//     try {
//       for (final entry in _handlers.entries) {
//         for (final handler in List<SocketEventHandler>.from(entry.value)) {
//           _socket?.off(entry.key, handler);
//         }
//       }
//       _handlers.clear();
//       AppLogger.info('Cleared all user event listeners', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to clear listeners: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   /// Starts logging every incoming socket event with its payload.
//   void startLoggingAllIncomingEvents() {
//     _isAnyEventLoggingEnabled = true;
//     _anyEventLogger ??= (event, payload) {
//       AppLogger.debug(
//         'Socket event received "$event" with payload: \n$payload',
//         tag: _tag,
//       );
//     };

//     final socket = _socket;
//     if (socket == null) return;

//     try {
//       socket.offAny(_anyEventLogger);
//       socket.onAny(_anyEventLogger!);
//       AppLogger.info('Enabled incoming socket event logging', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to enable incoming socket event logging: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   /// Stops logging incoming socket events.
//   void stopLoggingAllIncomingEvents() {
//     _isAnyEventLoggingEnabled = false;
//     final logger = _anyEventLogger;
//     final socket = _socket;
//     if (logger == null || socket == null) return;

//     try {
//       socket.offAny(logger);
//       AppLogger.info('Disabled incoming socket event logging', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to disable incoming socket event logging: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   //! ─── Emit ───

//   /// Emits [event] with optional [data]. Logs a warning if not connected.
//   void emit(String event, [dynamic data]) {
//     final socket = _socket;
//     if (socket == null || !socket.connected) {
//       AppLogger.warning(
//         'Cannot emit "$event" — socket not connected',
//         tag: _tag,
//       );
//       return;
//     }

//     try {
//       socket.emit(event, data);
//       AppLogger.info('Emitted "$event" with data: \n$data', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to emit "$event": $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }

//   /// Emits [event] and waits for a server acknowledgement, or times out.
//   Future<dynamic> emitWithAck(
//     String event, [
//     dynamic data,
//     Duration timeout = const Duration(seconds: 10),
//   ]) async {
//     final socket = _socket;
//     if (socket == null || !socket.connected) {
//       AppLogger.warning(
//         'Cannot emitWithAck "$event" — socket not connected',
//         tag: _tag,
//       );
//       throw StateError('Socket is not connected');
//     }

//     try {
//       AppLogger.debug(
//         'Emitting "$event" with ack (timeout: $timeout)',
//         tag: _tag,
//       );
//       final result = await socket
//           .emitWithAckAsync(event, data)
//           .timeout(timeout);
//       AppLogger.debug('Ack received for "$event"', tag: _tag);
//       return result;
//     } on TimeoutException catch (e, st) {
//       AppLogger.error(
//         'Ack timeout for "$event" after $timeout',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//       rethrow;
//     } catch (e, st) {
//       AppLogger.error(
//         'emitWithAck failed for "$event": $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//       rethrow;
//     }
//   }

//   //! ─── Private ───

//   String _resolveUrl(String? url, String? namespace) {
//     final base = url ?? EndPoints.baseIp;
//     if (namespace == null || namespace.isEmpty) return base;
//     final ns = namespace.startsWith('/') ? namespace : '/$namespace';
//     return '$base$ns';
//   }

//   Map<String, dynamic> _buildOptions({
//     Map<String, dynamic>? query,
//     Map<String, dynamic>? auth,
//     Map<String, dynamic>? extraHeaders,
//     required bool forceNew,
//   }) {
//     final builder = socket_io.OptionBuilder()
//         .setTransports(['websocket'])
//         .disableAutoConnect()
//         .enableReconnection()
//         .setReconnectionAttempts(double.infinity)
//         .setReconnectionDelay(1000)
//         .setReconnectionDelayMax(5000)
//         .setTimeout(20000);

//     if (forceNew) {
//       builder.enableForceNew();
//     }
//     if (query != null && query.isNotEmpty) {
//       builder.setQuery(query);
//     }
//     if (auth != null && auth.isNotEmpty) {
//       builder.setAuth(auth);
//     }
//     if (extraHeaders != null && extraHeaders.isNotEmpty) {
//       builder.setExtraHeaders(
//         extraHeaders.map((key, value) => MapEntry(key, value.toString())),
//       );
//     }

//     return builder.build();
//   }

//   void _attachLifecycleListeners() {
//     final socket = _socket;
//     if (socket == null) return;

//     socket.on('connect', _onConnect);
//     socket.on('disconnect', _onDisconnect);
//     socket.on('connect_error', _onConnectError);
//     socket.on('error', _onError);

//     socket.io.on('reconnect_attempt', _onReconnectAttempt);
//     socket.io.on('reconnect', _onReconnect);
//     socket.io.on('reconnect_error', _onReconnectError);
//     socket.io.on('reconnect_failed', _onReconnectFailed);

//     if (_isAnyEventLoggingEnabled) {
//       startLoggingAllIncomingEvents();
//     }
//   }

//   void _reattachUserListeners() {
//     final socket = _socket;
//     if (socket == null) return;

//     for (final entry in _handlers.entries) {
//       for (final handler in entry.value) {
//         socket.on(entry.key, handler);
//       }
//     }
//   }

//   Future<void> _tearDownSocket({required bool clearUserHandlers}) async {
//     try {
//       final socket = _socket;
//       if (socket != null) {
//         socket.off('connect', _onConnect);
//         socket.off('disconnect', _onDisconnect);
//         socket.off('connect_error', _onConnectError);
//         socket.off('error', _onError);

//         socket.io.off('reconnect_attempt', _onReconnectAttempt);
//         socket.io.off('reconnect', _onReconnect);
//         socket.io.off('reconnect_error', _onReconnectError);
//         socket.io.off('reconnect_failed', _onReconnectFailed);
//         if (_anyEventLogger != null) {
//           socket.offAny(_anyEventLogger);
//         }

//         if (clearUserHandlers) {
//           for (final entry in _handlers.entries) {
//             for (final handler in List<SocketEventHandler>.from(entry.value)) {
//               socket.off(entry.key, handler);
//             }
//           }
//           _handlers.clear();
//         } else {
//           for (final entry in _handlers.entries) {
//             for (final handler in entry.value) {
//               socket.off(entry.key, handler);
//             }
//           }
//         }

//         socket.dispose();
//       }
//     } catch (e, st) {
//       AppLogger.error(
//         'Error tearing down socket: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     } finally {
//       _socket = null;
//       _updateState(SocketConnectionState.disconnected);
//     }
//   }

//   void _ensureConnectionController() {
//     if (_connectionStateController.isClosed) {
//       _connectionStateController =
//           StreamController<SocketConnectionState>.broadcast();
//     }
//   }

//   void _updateState(SocketConnectionState state, {bool notify = true}) {
//     _connectionState = state;
//     if (!notify) return;
//     if (_connectionStateController.isClosed) return;
//     _connectionStateController.add(state);
//   }

//   void _onConnect(dynamic _) {
//     AppLogger.success('Connected to $_activeUrl', tag: _tag);
//     _updateState(SocketConnectionState.connected);
//   }

//   void _onDisconnect(dynamic reason) {
//     AppLogger.warning('Disconnected: $reason', tag: _tag);
//     _updateState(SocketConnectionState.disconnected);
//   }

//   void _onConnectError(dynamic data) {
//     AppLogger.error('Connection error: $data', tag: _tag);
//     final message = switch (data) {
//       final Map map => map['message']?.toString() ?? '',
//       _ => data?.toString() ?? '',
//     };
//     if (message.toLowerCase().contains('unauthorized')) {
//       _shouldStayConnected = false;
//       _updateState(SocketConnectionState.unauthorized);
//     } else {
//       _updateState(SocketConnectionState.error);
//     }
//   }

//   void _onError(dynamic data) {
//     AppLogger.error('Socket error: $data', tag: _tag);
//     _updateState(SocketConnectionState.error);
//   }

//   void _onReconnectAttempt(dynamic attempt) {
//     AppLogger.info('Reconnect attempt: $attempt', tag: _tag);
//     _updateState(SocketConnectionState.reconnecting);
//   }

//   void _onReconnect(dynamic attempt) {
//     AppLogger.success('Reconnected after attempt: $attempt', tag: _tag);
//     _updateState(SocketConnectionState.connected);
//   }

//   void _onReconnectError(dynamic data) {
//     AppLogger.error('Reconnect error: $data', tag: _tag);
//     _updateState(SocketConnectionState.error);
//   }

//   void _onReconnectFailed(dynamic _) {
//     AppLogger.error('Reconnect failed — giving up', tag: _tag);
//     _updateState(SocketConnectionState.error);
//   }

//   Future<void> _handleAppBackgrounded() async {
//     if (!_shouldStayConnected || _backgroundKeepAliveHeld) return;
//     _backgroundKeepAliveHeld = true;
//     try {
//       await _keepAlive.acquire();
//       AppLogger.info('Background keep-alive acquired', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to acquire background keep-alive: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//       _backgroundKeepAliveHeld = false;
//     }
//   }

//   Future<void> _handleAppResumed() async {
//     await _releaseBackgroundKeepAlive();
//     if (!_shouldStayConnected) return;
//     if (!isConnected) {
//       AppLogger.info('App resumed — reconnecting socket', tag: _tag);
//       await reconnect();
//     }
//   }

//   Future<void> _releaseBackgroundKeepAlive() async {
//     if (!_backgroundKeepAliveHeld) return;
//     _backgroundKeepAliveHeld = false;
//     try {
//       await _keepAlive.release();
//       AppLogger.info('Background keep-alive released', tag: _tag);
//     } catch (e, st) {
//       AppLogger.error(
//         'Failed to release background keep-alive: $e',
//         error: e,
//         stackTrace: st,
//         tag: _tag,
//       );
//     }
//   }
// }
