import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

final channelProvider = Provider.autoDispose<ClientChannel>((ref) {
  final host = dotenv.env['GRPC_HOST'] ?? 'localhost';
  final port = int.tryParse(dotenv.env['GRPC_PORT'] ?? '50051') ?? 50051;
  final channel = ClientChannel(
    host,
    port: port,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );
  ref.onDispose(() async {
    await channel.shutdown();
  });
  return channel;
});
