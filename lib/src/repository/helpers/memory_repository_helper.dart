/// A mixin that provides simple in-memory caching capabilities to a Repository.
///
/// It manages a single cache entry of type [Info], tracking the timestamp
/// and determining validity based on [refreshDuration].
mixin MemoryCacheHelper<Info> {
  /// The duration for which the cache is considered valid.
  Duration get refreshDuration;

  Info? _internalCache;

  /// The timestamp when the cache was last updated.
  DateTime? timeStamp;

  /// The timestamp of the last attempt to access the cache.
  DateTime? lastRetry;

  /// Clears the cache and resets timestamps.
  void clear() {
    _internalCache = null;
    timeStamp = null;
    lastRetry = null;
  }

  /// Retrieves the cached data if available. Updates [lastRetry].
  Info? get cache {
    lastRetry = DateTime.now();
    return _internalCache;
  }

  /// Updates the cached data and sets the [timeStamp] to now.
  set cache(Info? cache) {
    if (cache != null) {
      timeStamp = DateTime.now();
    }
    _internalCache = cache;
  }

  /// Checks if the cache needs to be refreshed.
  ///
  /// Returns `true` if:
  /// 1. Cache is empty.
  /// 2. The difference between now and [timeStamp] exceeds [refreshDuration].
  bool isRefreshRequired() {
    if (!isCached()) {
      return true;
    }
    final actualTime = DateTime.now();
    final diff = actualTime.difference(timeStamp ?? actualTime);
    if (diff.inMilliseconds >= refreshDuration.inMilliseconds) {
      return true;
    }
    return false;
  }

  /// Returns `true` if there is data in the cache (regardless of expiration).
  bool isCached() => _internalCache != null;
}
