// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'a06f06bef1b9213d7a6fb1458e5a4d32f0c45f7e';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$getFavSongsHash() => r'a87018e84ac4917a7a2b793d0931a0667503c6bb';

/// See also [getFavSongs].
@ProviderFor(getFavSongs)
final getFavSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getFavSongs,
  name: r'getFavSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getFavSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFavSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$getGenreListHash() => r'94e5bef6dff2c1117e713c99d50e89e7b193be35';

/// See also [getGenreList].
@ProviderFor(getGenreList)
final getGenreListProvider = AutoDisposeFutureProvider<List<String>>.internal(
  getGenreList,
  name: r'getGenreListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getGenreListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetGenreListRef = AutoDisposeFutureProviderRef<List<String>>;
String _$getGenreSongListHash() => r'a75dfccc0d96125bce499923a5ad8114e4417a50';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getGenreSongList].
@ProviderFor(getGenreSongList)
const getGenreSongListProvider = GetGenreSongListFamily();

/// See also [getGenreSongList].
class GetGenreSongListFamily extends Family<AsyncValue<List<SongModel>>> {
  /// See also [getGenreSongList].
  const GetGenreSongListFamily();

  /// See also [getGenreSongList].
  GetGenreSongListProvider call(
    String genre,
  ) {
    return GetGenreSongListProvider(
      genre,
    );
  }

  @override
  GetGenreSongListProvider getProviderOverride(
    covariant GetGenreSongListProvider provider,
  ) {
    return call(
      provider.genre,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getGenreSongListProvider';
}

/// See also [getGenreSongList].
class GetGenreSongListProvider
    extends AutoDisposeFutureProvider<List<SongModel>> {
  /// See also [getGenreSongList].
  GetGenreSongListProvider(
    String genre,
  ) : this._internal(
          (ref) => getGenreSongList(
            ref as GetGenreSongListRef,
            genre,
          ),
          from: getGenreSongListProvider,
          name: r'getGenreSongListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getGenreSongListHash,
          dependencies: GetGenreSongListFamily._dependencies,
          allTransitiveDependencies:
              GetGenreSongListFamily._allTransitiveDependencies,
          genre: genre,
        );

  GetGenreSongListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genre,
  }) : super.internal();

  final String genre;

  @override
  Override overrideWith(
    FutureOr<List<SongModel>> Function(GetGenreSongListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetGenreSongListProvider._internal(
        (ref) => create(ref as GetGenreSongListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genre: genre,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SongModel>> createElement() {
    return _GetGenreSongListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetGenreSongListProvider && other.genre == genre;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genre.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetGenreSongListRef on AutoDisposeFutureProviderRef<List<SongModel>> {
  /// The parameter `genre` of this provider.
  String get genre;
}

class _GetGenreSongListProviderElement
    extends AutoDisposeFutureProviderElement<List<SongModel>>
    with GetGenreSongListRef {
  _GetGenreSongListProviderElement(super.provider);

  @override
  String get genre => (origin as GetGenreSongListProvider).genre;
}

String _$getSuggestionsHash() => r'4e9297e8242931635cacba7232221b70a8e32f1e';

/// See also [getSuggestions].
@ProviderFor(getSuggestions)
const getSuggestionsProvider = GetSuggestionsFamily();

/// See also [getSuggestions].
class GetSuggestionsFamily
    extends Family<AsyncValue<Tuple2<List<SongModel>, List<String>>>> {
  /// See also [getSuggestions].
  const GetSuggestionsFamily();

  /// See also [getSuggestions].
  GetSuggestionsProvider call(
    String words,
  ) {
    return GetSuggestionsProvider(
      words,
    );
  }

  @override
  GetSuggestionsProvider getProviderOverride(
    covariant GetSuggestionsProvider provider,
  ) {
    return call(
      provider.words,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getSuggestionsProvider';
}

/// See also [getSuggestions].
class GetSuggestionsProvider
    extends AutoDisposeFutureProvider<Tuple2<List<SongModel>, List<String>>> {
  /// See also [getSuggestions].
  GetSuggestionsProvider(
    String words,
  ) : this._internal(
          (ref) => getSuggestions(
            ref as GetSuggestionsRef,
            words,
          ),
          from: getSuggestionsProvider,
          name: r'getSuggestionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSuggestionsHash,
          dependencies: GetSuggestionsFamily._dependencies,
          allTransitiveDependencies:
              GetSuggestionsFamily._allTransitiveDependencies,
          words: words,
        );

  GetSuggestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.words,
  }) : super.internal();

  final String words;

  @override
  Override overrideWith(
    FutureOr<Tuple2<List<SongModel>, List<String>>> Function(
            GetSuggestionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSuggestionsProvider._internal(
        (ref) => create(ref as GetSuggestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        words: words,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Tuple2<List<SongModel>, List<String>>>
      createElement() {
    return _GetSuggestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSuggestionsProvider && other.words == words;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, words.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetSuggestionsRef
    on AutoDisposeFutureProviderRef<Tuple2<List<SongModel>, List<String>>> {
  /// The parameter `words` of this provider.
  String get words;
}

class _GetSuggestionsProviderElement extends AutoDisposeFutureProviderElement<
    Tuple2<List<SongModel>, List<String>>> with GetSuggestionsRef {
  _GetSuggestionsProviderElement(super.provider);

  @override
  String get words => (origin as GetSuggestionsProvider).words;
}

String _$homeViewmodelHash() => r'86ee7c24222959d8ec41c2312a47bd437135c473';

/// See also [HomeViewmodel].
@ProviderFor(HomeViewmodel)
final homeViewmodelProvider =
    AutoDisposeNotifierProvider<HomeViewmodel, AsyncValue?>.internal(
  HomeViewmodel.new,
  name: r'homeViewmodelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewmodelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewmodel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
