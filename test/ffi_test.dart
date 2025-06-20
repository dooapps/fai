import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'dart:io' show Platform;

ffi.DynamicLibrary _openLib() {
  if (Platform.isMacOS) {
    return ffi.DynamicLibrary.open('native/libs/macos/libfbbl.dylib');
  } else if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('native/libs/windows/fbbl.dll');
  } else if (Platform.isLinux) {
    return ffi.DynamicLibrary.open('native/libs/linux/libfbbl.so');
  } else if (Platform.isAndroid) {
    return ffi.DynamicLibrary.open('native/lib/libfbbl.so');
  } else if (Platform.isIOS) {
    return ffi.DynamicLibrary.open('native/libs/macos/libfbbl.a');
  } else {
    throw UnsupportedError('This platform is not supported.');
  }
}

/// Represents the buffer returned by the Rust FFI code.
final class FbblBuffer extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Uint64()
  external int len;
}

/// Bindings para a biblioteca nativa fbbl
class FbblBindings {
  final ffi.DynamicLibrary _lib;

  FbblBindings(this._lib);

late final _fbblInitialize = _lib.lookupFunction<
    ffi.Int32 Function(ffi.Pointer<Utf8>),
    int Function(ffi.Pointer<Utf8>)>('fbbl_initialize');


late final _fbblGenerateNumericHash = _lib.lookupFunction<
    ffi.Uint64 Function(ffi.Pointer<Utf8>),
    int Function(ffi.Pointer<Utf8>)>('fbbl_generate_numeric_hash');

  late final _fbblEncryptId = _lib.lookupFunction<
      FbblBuffer Function(ffi.Uint64, ffi.Pointer<ffi.Uint8>),
      FbblBuffer Function(int, ffi.Pointer<ffi.Uint8>)>('fbbl_encrypt_id');

  late final _fbblDecryptId = _lib.lookupFunction<
      ffi.Uint64 Function(ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>),
      int Function(ffi.Pointer<ffi.Uint8>, ffi.Pointer<ffi.Uint8>)>(
    'fbbl_decrypt_id',
  );

  late final _fbblFreeBuffer = _lib.lookupFunction<
      ffi.Void Function(FbblBuffer),
      void Function(FbblBuffer)>('fbbl_free_buffer');

  /// Inicializa com uma chave hex de 32 bytes
  int fbblInitialize(String hexKey) {
    final ptr = hexKey.toNativeUtf8();
    final result = _fbblInitialize(ptr);
    malloc.free(ptr);
    return result;
  }

  /// Gera hash numérico seguro
  int fbblGenerateNumericHash(String input) {
    final ptr = input.toNativeUtf8();
    final hash = _fbblGenerateNumericHash(ptr);
    malloc.free(ptr);
    return hash;
  }

  /// Criptografa um ID
  FbblBuffer fbblEncryptId(int id, Uint8List nonce) {
    assert(nonce.length == 12, 'Nonce must be exactly 12 bytes');
    final noncePtr = malloc.allocate<ffi.Uint8>(12);
    noncePtr.asTypedList(12).setAll(0, nonce);

    final result = _fbblEncryptId(id, noncePtr);

    malloc.free(noncePtr);
    return result;
  }

  /// Descriptografa um ID
  int fbblDecryptId(Uint8List data, Uint8List nonce) {
    assert(data.length == 16, 'Data must be exactly 16 bytes');
    assert(nonce.length == 12, 'Nonce must be exactly 12 bytes');

    final dataPtr = malloc.allocate<ffi.Uint8>(16);
    final noncePtr = malloc.allocate<ffi.Uint8>(12);

    dataPtr.asTypedList(16).setAll(0, data);
    noncePtr.asTypedList(12).setAll(0, nonce);

    final result = _fbblDecryptId(dataPtr, noncePtr);

    malloc.free(dataPtr);
    malloc.free(noncePtr);

    return result;
  }

  /// Libera buffer vindo do Rust
  void fbblFreeBuffer(FbblBuffer buffer) {
    _fbblFreeBuffer(buffer);
  }

  /// Converte buffer para Uint8List
  Uint8List bufferToList(FbblBuffer buffer) {
    return buffer.ptr.asTypedList(buffer.len);
  }
}
void main() {
  final lib = _openLib();
  final fbbl = FbblBindings(lib);

  // Use a 64-character hex key (32 bytes) as required by the Rust library
  final initRc = fbbl.fbblInitialize('0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef');
  print('Initialize return code: $initRc');
  assert(initRc == 0, 'Failed to initialize the library, return code: $initRc');

  final hash = fbbl.fbblGenerateNumericHash('hello');
  print('Hash: $hash');

  // Create a proper 12-byte nonce
  final nonce = Uint8List(12);
  // Fill with some test values
  for (var i = 0; i < 12; i++) {
    nonce[i] = i;
  }
  print('Nonce length: ${nonce.length}');
  print('Nonce content: $nonce');
  
  final buffer = fbbl.fbblEncryptId(42, nonce);
  
  final encrypted = fbbl.bufferToList(buffer);
  print('Encrypted data length: ${encrypted.length}');
  print('Encrypted data: $encrypted');
  fbbl.fbblFreeBuffer(buffer);
  
  // Use the exact same nonce for decryption
  final decrypted = fbbl.fbblDecryptId(encrypted, nonce);
  assert(decrypted == 42);
  print('Decrypted ID: $decrypted');
}

