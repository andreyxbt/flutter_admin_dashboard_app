import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Interface for all repositories that support both remote and local storage
abstract class BaseRepository<T> {
  /// Get all items from the repository
  Future<List<T>> getAll();
  
  /// Get a single item by ID
  Future<T?> getById(String id);
  
  /// Add a new item
  Future<String> add(T item);
  
  /// Update an existing item
  Future<void> update(String id, T item);
  
  /// Delete an item
  Future<void> delete(String id);
  
  /// Clear the local cache
  Future<void> clearCache();
  
  /// Force refresh from remote source
  Future<List<T>> refreshFromRemote();
}

/// Base implementation for Firebase repositories with local caching
abstract class FirebaseRepository<T> implements BaseRepository<T> {
  final FirebaseFirestore _firestore;
  final String _collection;
  final String _cacheKey;
  
  FirebaseRepository({
    required String collection,
    FirebaseFirestore? firestore,
  }) : 
    _collection = collection,
    _cacheKey = 'cache_${collection}',
    _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Convert an item to a map for storage
  Map<String, dynamic> toMap(T item);
  
  /// Create an item from a map
  T fromMap(Map<String, dynamic> map, String id);
  
  /// Get a reference to the collection
  CollectionReference<Map<String, dynamic>> get collection => 
      _firestore.collection(_collection);
  
  @override
  Future<List<T>> getAll() async {
    try {
      // Try to get from Firestore first
      final snapshot = await collection.get();
      final items = snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
      
      // Update cache
      saveToCache(items);
      
      return items;
    } catch (e) {
      // On error, try to get from cache
      if (kDebugMode) {
        print('Error fetching from Firestore: $e');
        print('Falling back to cache...');
      }
      
      return getFromCache();
    }
  }

  @override
  Future<T?> getById(String id) async {
    try {
      // Try to get from Firestore first
      final doc = await collection.doc(id).get();
      if (!doc.exists) return null;
      
      final item = fromMap(doc.data()!, doc.id);
      
      // Update cache for this item
      updateItemInCache(id, item);
      
      return item;
    } catch (e) {
      // On error, try to get from cache
      if (kDebugMode) {
        print('Error fetching item from Firestore: $e');
        print('Falling back to cache...');
      }
      
      return getByIdFromCache(id);
    }
  }

  @override
  Future<String> add(T item) async {
    final docRef = await collection.add(toMap(item));
    final id = docRef.id;
    
    // Update cache
    addItemToCache(id, item);
    
    return id;
  }

  @override
  Future<void> update(String id, T item) async {
    await collection.doc(id).update(toMap(item));
    
    // Update cache
    updateItemInCache(id, item);
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
    
    // Update cache
    removeItemFromCache(id);
  }
  
  @override
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
  
  @override
  Future<List<T>> refreshFromRemote() async {
    // Clear cache first
    await clearCache();
    
    // Force Firestore fetch
    final snapshot = await collection.get();
    final items = snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
    
    // Update cache with fresh data
    saveToCache(items);
    
    return items;
  }
  
  // Protected cache methods - accessible to child classes
  @protected
  Future<void> saveToCache(List<T> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = items.map((item) {
        final map = toMap(item);
        // Find the ID - either it's in the map or we need to add it
        final id = (map['id'] ?? '').toString();
        return {'data': map, 'id': id};
      }).toList();
      
      final jsonData = jsonEncode(cacheData);
      await prefs.setString(_cacheKey, jsonData);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving to cache: $e');
      }
    }
  }
  
  @protected
  Future<List<T>> getFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_cacheKey);
      
      if (jsonData == null) return [];
      
      final List<dynamic> cacheData = jsonDecode(jsonData);
      
      return cacheData.map((item) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(item['data']);
        final String id = item['id'].toString();
        return fromMap(data, id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error reading from cache: $e');
      }
      return [];
    }
  }
  
  @protected
  Future<T?> getByIdFromCache(String id) async {
    try {
      final itemMap = await getCacheAsMap();
      return itemMap[id];
    } catch (e) {
      return null;
    }
  }
  
  @protected
  Future<Map<String, T>> getCacheAsMap() async {
    final items = await getFromCache();
    final Map<String, T> itemMap = {};
    
    for (final item in items) {
      final map = toMap(item);
      final id = map['id']?.toString() ?? '';
      if (id.isNotEmpty) {
        itemMap[id] = item;
      }
    }
    
    return itemMap;
  }
  
  @protected
  Future<void> addItemToCache(String id, T item) async {
    final items = await getFromCache();
    final map = toMap(item);
    // Ensure the ID is in the map
    map['id'] = id;
    items.add(fromMap(map, id));
    await saveToCache(items);
  }
  
  @protected
  Future<void> updateItemInCache(String id, T item) async {
    final items = await getFromCache();
    final index = items.indexWhere((element) {
      final map = toMap(element);
      return map['id'] == id;
    });
    
    if (index >= 0) {
      items[index] = item;
      await saveToCache(items);
    } else {
      await addItemToCache(id, item);
    }
  }
  
  @protected
  Future<void> removeItemFromCache(String id) async {
    final items = await getFromCache();
    items.removeWhere((element) {
      final map = toMap(element);
      return map['id'] == id;
    });
    await saveToCache(items);
  }
}