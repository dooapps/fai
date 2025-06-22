import '../client/flutter_fai_client.dart';
import '../client/flutter_fai_link.dart';
import '../client/interfaces.dart';
import '../sear/unpack.dart';
import '../storage/store.dart';
import '../types/fai.dart';
import 'flutter_fai_user_api.dart';

class FlutterGunSeaClient extends FlutterFaiClient {
  FlutterGunUserApi? _user;
  FlutterGunLink? linkClass;

  FlutterGunSeaClient(
      {this.linkClass,
      FlutterGunOptions? flutterGunOptions,
      bool registerStorage = false}) {
    if (flutterGunOptions == null) {
      var tempFlutterGunOptions = FlutterGunOptions();
      tempFlutterGunOptions.peers = ["wss://gun-manhattan.herokuapp.com/gun"];
      flutterGunOptions = tempFlutterGunOptions;
    }
    initializedClient(
        linkClass: linkClass, flutterGunOptions: flutterGunOptions);
    if (registerStorage) {
      registerStorageMiddleware();
    } else {
      registerSearMiddleware();
    }
  }

  FlutterGunUserApi user() {
    return (_user ??= FlutterGunUserApi(flutterGunSeaClient: this));
  }

  void registerSearMiddleware() {
    graph!.use((GunGraphData updates, GunGraphData existingGraph) =>
        unpackGraph(updates, graph!.getOpt().mutable!));
  }

  void registerStorageMiddleware() {
    // For the Read Use Case
    graph!.use((GunGraphData updates, GunGraphData existingGraph) =>
        getStoreData(unpackGraph(updates, graph!.getOpt().mutable!),
            graph!.activeConnectors));

    // For the Write Use Case
    graph!.use(
        (GunGraphData updates, GunGraphData existingGraph) =>
            setStoreData(updates),
        kind: FlutterGunMiddlewareType.write);
  }
}
