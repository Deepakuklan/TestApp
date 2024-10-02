import '../../../model/device.dart';
import '../../discovery/multicast_discovery.dart';
import 'main.dart';
import '../dto/send_to_isolate_data.dart';
import 'package:meta/meta.dart';

@internal
Future<void> setupMulticastDiscoveryIsolate(
  Stream<SendToIsolateData<void>> receiveFromMain,
  void Function(Device) sendToMain,
  InitialData initialData,
) async {
  await setupChildIsolateHelper(
    debugLabel: 'MulticastDiscoveryIsolate',
    receiveFromMain: receiveFromMain,
    sendToMain: sendToMain,
    initialData: initialData,
    init: () async {
      isolateContainer
          .read(multicastDiscoveryProvider)
          .startListener()
          .listen((event) {
        sendToMain(event);
      });
    },
    handler: (_) async {
      await isolateContainer
          .read(multicastDiscoveryProvider)
          .sendAnnouncement();
    },
  );
}
