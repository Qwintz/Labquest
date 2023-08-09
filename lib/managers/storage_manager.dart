import 'package:hive_flutter/hive_flutter.dart';

abstract class StorageBoxNames {
  static const settings = 'settings';
  static const courses = 'courses';
  static const tasks = 'tasks';
}

class StorageManager {
  static Future<Box<T>> _openBox<T>(
    String boxName, {
    TypeAdapter<T>? adapter,
  }) async {
    if (adapter != null && !Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
    return await Hive.openBox(boxName);
  }

  static Future<void> _closeBox(Box box) async {
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
  }

  static Future<dynamic> readFromStorage<T>(
    String boxName, {
    TypeAdapter<T>? adapter,
    dynamic key,
  }) async {
    var box = await _openBox<T>(
      boxName,
      adapter: adapter,
    );
    var value = key != null ? box.get(key) : box.values.toList();
    await _closeBox(box);
    return value;
  }

  static Future<void> writeToStorage<T>(
    String boxName, {
    TypeAdapter<T>? adapter,
    required dynamic key,
    required T value,
  }) async {
    var box = await _openBox<T>(
      boxName,
      adapter: adapter,
    );
    await box.put(key, value);
    await _closeBox(box);
  }

  static Future<void> removeFromStorage<T>(
    String boxName, {
    TypeAdapter<T>? adapter,
    required dynamic key,
  }) async {
    var box = await _openBox<T>(
      boxName,
      adapter: adapter,
    );
    await box.delete(key);
    await _closeBox(box);
  }

  static Future<void> removeAllFromStorage<T>(
    String boxName, {
    TypeAdapter<T>? adapter,
    Iterable<dynamic>? keys,
  }) async {
    if (keys == null) return;
    var box = await _openBox<T>(
      boxName,
      adapter: adapter,
    );
    await box.deleteAll(keys);
    await _closeBox(box);
  }
}
