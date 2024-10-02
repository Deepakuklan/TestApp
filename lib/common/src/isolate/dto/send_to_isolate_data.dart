import '../child/sync_provider.dart';

class SendToIsolateData<T> {
  final SyncState? syncState;
  final T? data;

  SendToIsolateData({
    required this.syncState,
    required this.data,
  });
}
