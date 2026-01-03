// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _account_idMeta =
      const VerificationMeta('account_id');
  @override
  late final GeneratedColumn<int> account_id = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [account_id, username, password];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
          _account_idMeta,
          account_id.isAcceptableOrUnknown(
              data['account_id']!, _account_idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {account_id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      account_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int account_id;
  final String username;
  final String password;
  const Account(
      {required this.account_id,
      required this.username,
      required this.password});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(account_id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      account_id: Value(account_id),
      username: Value(username),
      password: Value(password),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      account_id: serializer.fromJson<int>(json['account_id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'account_id': serializer.toJson<int>(account_id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
    };
  }

  Account copyWith({int? account_id, String? username, String? password}) =>
      Account(
        account_id: account_id ?? this.account_id,
        username: username ?? this.username,
        password: password ?? this.password,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      account_id:
          data.account_id.present ? data.account_id.value : this.account_id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('account_id: $account_id, ')
          ..write('username: $username, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(account_id, username, password);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.account_id == this.account_id &&
          other.username == this.username &&
          other.password == this.password);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> account_id;
  final Value<String> username;
  final Value<String> password;
  const AccountsCompanion({
    this.account_id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.account_id = const Value.absent(),
    required String username,
    required String password,
  })  : username = Value(username),
        password = Value(password);
  static Insertable<Account> custom({
    Expression<int>? account_id,
    Expression<String>? username,
    Expression<String>? password,
  }) {
    return RawValuesInsertable({
      if (account_id != null) 'account_id': account_id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? account_id,
      Value<String>? username,
      Value<String>? password}) {
    return AccountsCompanion(
      account_id: account_id ?? this.account_id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (account_id.present) {
      map['account_id'] = Variable<int>(account_id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('account_id: $account_id, ')
          ..write('username: $username, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }
}

class $DucksTable extends Ducks with TableInfo<$DucksTable, Duck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DucksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _duck_idMeta =
      const VerificationMeta('duck_id');
  @override
  late final GeneratedColumn<int> duck_id = GeneratedColumn<int>(
      'duck_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _totalQuackMeta =
      const VerificationMeta('totalQuack');
  @override
  late final GeneratedColumn<int> totalQuack = GeneratedColumn<int>(
      'total_quack', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentQuackMeta =
      const VerificationMeta('currentQuack');
  @override
  late final GeneratedColumn<int> currentQuack = GeneratedColumn<int>(
      'current_quack', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _duckTapsMeta =
      const VerificationMeta('duckTaps');
  @override
  late final GeneratedColumn<int> duckTaps = GeneratedColumn<int>(
      'duck_taps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _moreDucksMeta =
      const VerificationMeta('moreDucks');
  @override
  late final GeneratedColumn<int> moreDucks = GeneratedColumn<int>(
      'more_ducks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fishMeta = const VerificationMeta('fish');
  @override
  late final GeneratedColumn<int> fish = GeneratedColumn<int>(
      'fish', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _watermelonMeta =
      const VerificationMeta('watermelon');
  @override
  late final GeneratedColumn<int> watermelon = GeneratedColumn<int>(
      'watermelon', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pondsMeta = const VerificationMeta('ponds');
  @override
  late final GeneratedColumn<int> ponds = GeneratedColumn<int>(
      'ponds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _account_idMeta =
      const VerificationMeta('account_id');
  @override
  late final GeneratedColumn<int> account_id = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (account_id)'));
  @override
  List<GeneratedColumn> get $columns => [
        duck_id,
        totalQuack,
        currentQuack,
        duckTaps,
        moreDucks,
        fish,
        watermelon,
        ponds,
        account_id
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ducks';
  @override
  VerificationContext validateIntegrity(Insertable<Duck> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('duck_id')) {
      context.handle(_duck_idMeta,
          duck_id.isAcceptableOrUnknown(data['duck_id']!, _duck_idMeta));
    }
    if (data.containsKey('total_quack')) {
      context.handle(
          _totalQuackMeta,
          totalQuack.isAcceptableOrUnknown(
              data['total_quack']!, _totalQuackMeta));
    } else if (isInserting) {
      context.missing(_totalQuackMeta);
    }
    if (data.containsKey('current_quack')) {
      context.handle(
          _currentQuackMeta,
          currentQuack.isAcceptableOrUnknown(
              data['current_quack']!, _currentQuackMeta));
    } else if (isInserting) {
      context.missing(_currentQuackMeta);
    }
    if (data.containsKey('duck_taps')) {
      context.handle(_duckTapsMeta,
          duckTaps.isAcceptableOrUnknown(data['duck_taps']!, _duckTapsMeta));
    } else if (isInserting) {
      context.missing(_duckTapsMeta);
    }
    if (data.containsKey('more_ducks')) {
      context.handle(_moreDucksMeta,
          moreDucks.isAcceptableOrUnknown(data['more_ducks']!, _moreDucksMeta));
    } else if (isInserting) {
      context.missing(_moreDucksMeta);
    }
    if (data.containsKey('fish')) {
      context.handle(
          _fishMeta, fish.isAcceptableOrUnknown(data['fish']!, _fishMeta));
    } else if (isInserting) {
      context.missing(_fishMeta);
    }
    if (data.containsKey('watermelon')) {
      context.handle(
          _watermelonMeta,
          watermelon.isAcceptableOrUnknown(
              data['watermelon']!, _watermelonMeta));
    } else if (isInserting) {
      context.missing(_watermelonMeta);
    }
    if (data.containsKey('ponds')) {
      context.handle(
          _pondsMeta, ponds.isAcceptableOrUnknown(data['ponds']!, _pondsMeta));
    } else if (isInserting) {
      context.missing(_pondsMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
          _account_idMeta,
          account_id.isAcceptableOrUnknown(
              data['account_id']!, _account_idMeta));
    } else if (isInserting) {
      context.missing(_account_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {duck_id};
  @override
  Duck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Duck(
      duck_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duck_id'])!,
      totalQuack: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_quack'])!,
      currentQuack: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_quack'])!,
      duckTaps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duck_taps'])!,
      moreDucks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}more_ducks'])!,
      fish: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fish'])!,
      watermelon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}watermelon'])!,
      ponds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ponds'])!,
      account_id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
    );
  }

  @override
  $DucksTable createAlias(String alias) {
    return $DucksTable(attachedDatabase, alias);
  }
}

class Duck extends DataClass implements Insertable<Duck> {
  final int duck_id;
  final int totalQuack;
  final int currentQuack;
  final int duckTaps;
  final int moreDucks;
  final int fish;
  final int watermelon;
  final int ponds;
  final int account_id;
  const Duck(
      {required this.duck_id,
      required this.totalQuack,
      required this.currentQuack,
      required this.duckTaps,
      required this.moreDucks,
      required this.fish,
      required this.watermelon,
      required this.ponds,
      required this.account_id});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['duck_id'] = Variable<int>(duck_id);
    map['total_quack'] = Variable<int>(totalQuack);
    map['current_quack'] = Variable<int>(currentQuack);
    map['duck_taps'] = Variable<int>(duckTaps);
    map['more_ducks'] = Variable<int>(moreDucks);
    map['fish'] = Variable<int>(fish);
    map['watermelon'] = Variable<int>(watermelon);
    map['ponds'] = Variable<int>(ponds);
    map['account_id'] = Variable<int>(account_id);
    return map;
  }

  DucksCompanion toCompanion(bool nullToAbsent) {
    return DucksCompanion(
      duck_id: Value(duck_id),
      totalQuack: Value(totalQuack),
      currentQuack: Value(currentQuack),
      duckTaps: Value(duckTaps),
      moreDucks: Value(moreDucks),
      fish: Value(fish),
      watermelon: Value(watermelon),
      ponds: Value(ponds),
      account_id: Value(account_id),
    );
  }

  factory Duck.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Duck(
      duck_id: serializer.fromJson<int>(json['duck_id']),
      totalQuack: serializer.fromJson<int>(json['totalQuack']),
      currentQuack: serializer.fromJson<int>(json['currentQuack']),
      duckTaps: serializer.fromJson<int>(json['duckTaps']),
      moreDucks: serializer.fromJson<int>(json['moreDucks']),
      fish: serializer.fromJson<int>(json['fish']),
      watermelon: serializer.fromJson<int>(json['watermelon']),
      ponds: serializer.fromJson<int>(json['ponds']),
      account_id: serializer.fromJson<int>(json['account_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'duck_id': serializer.toJson<int>(duck_id),
      'totalQuack': serializer.toJson<int>(totalQuack),
      'currentQuack': serializer.toJson<int>(currentQuack),
      'duckTaps': serializer.toJson<int>(duckTaps),
      'moreDucks': serializer.toJson<int>(moreDucks),
      'fish': serializer.toJson<int>(fish),
      'watermelon': serializer.toJson<int>(watermelon),
      'ponds': serializer.toJson<int>(ponds),
      'account_id': serializer.toJson<int>(account_id),
    };
  }

  Duck copyWith(
          {int? duck_id,
          int? totalQuack,
          int? currentQuack,
          int? duckTaps,
          int? moreDucks,
          int? fish,
          int? watermelon,
          int? ponds,
          int? account_id}) =>
      Duck(
        duck_id: duck_id ?? this.duck_id,
        totalQuack: totalQuack ?? this.totalQuack,
        currentQuack: currentQuack ?? this.currentQuack,
        duckTaps: duckTaps ?? this.duckTaps,
        moreDucks: moreDucks ?? this.moreDucks,
        fish: fish ?? this.fish,
        watermelon: watermelon ?? this.watermelon,
        ponds: ponds ?? this.ponds,
        account_id: account_id ?? this.account_id,
      );
  Duck copyWithCompanion(DucksCompanion data) {
    return Duck(
      duck_id: data.duck_id.present ? data.duck_id.value : this.duck_id,
      totalQuack:
          data.totalQuack.present ? data.totalQuack.value : this.totalQuack,
      currentQuack: data.currentQuack.present
          ? data.currentQuack.value
          : this.currentQuack,
      duckTaps: data.duckTaps.present ? data.duckTaps.value : this.duckTaps,
      moreDucks: data.moreDucks.present ? data.moreDucks.value : this.moreDucks,
      fish: data.fish.present ? data.fish.value : this.fish,
      watermelon:
          data.watermelon.present ? data.watermelon.value : this.watermelon,
      ponds: data.ponds.present ? data.ponds.value : this.ponds,
      account_id:
          data.account_id.present ? data.account_id.value : this.account_id,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Duck(')
          ..write('duck_id: $duck_id, ')
          ..write('totalQuack: $totalQuack, ')
          ..write('currentQuack: $currentQuack, ')
          ..write('duckTaps: $duckTaps, ')
          ..write('moreDucks: $moreDucks, ')
          ..write('fish: $fish, ')
          ..write('watermelon: $watermelon, ')
          ..write('ponds: $ponds, ')
          ..write('account_id: $account_id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(duck_id, totalQuack, currentQuack, duckTaps,
      moreDucks, fish, watermelon, ponds, account_id);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Duck &&
          other.duck_id == this.duck_id &&
          other.totalQuack == this.totalQuack &&
          other.currentQuack == this.currentQuack &&
          other.duckTaps == this.duckTaps &&
          other.moreDucks == this.moreDucks &&
          other.fish == this.fish &&
          other.watermelon == this.watermelon &&
          other.ponds == this.ponds &&
          other.account_id == this.account_id);
}

class DucksCompanion extends UpdateCompanion<Duck> {
  final Value<int> duck_id;
  final Value<int> totalQuack;
  final Value<int> currentQuack;
  final Value<int> duckTaps;
  final Value<int> moreDucks;
  final Value<int> fish;
  final Value<int> watermelon;
  final Value<int> ponds;
  final Value<int> account_id;
  const DucksCompanion({
    this.duck_id = const Value.absent(),
    this.totalQuack = const Value.absent(),
    this.currentQuack = const Value.absent(),
    this.duckTaps = const Value.absent(),
    this.moreDucks = const Value.absent(),
    this.fish = const Value.absent(),
    this.watermelon = const Value.absent(),
    this.ponds = const Value.absent(),
    this.account_id = const Value.absent(),
  });
  DucksCompanion.insert({
    this.duck_id = const Value.absent(),
    required int totalQuack,
    required int currentQuack,
    required int duckTaps,
    required int moreDucks,
    required int fish,
    required int watermelon,
    required int ponds,
    required int account_id,
  })  : totalQuack = Value(totalQuack),
        currentQuack = Value(currentQuack),
        duckTaps = Value(duckTaps),
        moreDucks = Value(moreDucks),
        fish = Value(fish),
        watermelon = Value(watermelon),
        ponds = Value(ponds),
        account_id = Value(account_id);
  static Insertable<Duck> custom({
    Expression<int>? duck_id,
    Expression<int>? totalQuack,
    Expression<int>? currentQuack,
    Expression<int>? duckTaps,
    Expression<int>? moreDucks,
    Expression<int>? fish,
    Expression<int>? watermelon,
    Expression<int>? ponds,
    Expression<int>? account_id,
  }) {
    return RawValuesInsertable({
      if (duck_id != null) 'duck_id': duck_id,
      if (totalQuack != null) 'total_quack': totalQuack,
      if (currentQuack != null) 'current_quack': currentQuack,
      if (duckTaps != null) 'duck_taps': duckTaps,
      if (moreDucks != null) 'more_ducks': moreDucks,
      if (fish != null) 'fish': fish,
      if (watermelon != null) 'watermelon': watermelon,
      if (ponds != null) 'ponds': ponds,
      if (account_id != null) 'account_id': account_id,
    });
  }

  DucksCompanion copyWith(
      {Value<int>? duck_id,
      Value<int>? totalQuack,
      Value<int>? currentQuack,
      Value<int>? duckTaps,
      Value<int>? moreDucks,
      Value<int>? fish,
      Value<int>? watermelon,
      Value<int>? ponds,
      Value<int>? account_id}) {
    return DucksCompanion(
      duck_id: duck_id ?? this.duck_id,
      totalQuack: totalQuack ?? this.totalQuack,
      currentQuack: currentQuack ?? this.currentQuack,
      duckTaps: duckTaps ?? this.duckTaps,
      moreDucks: moreDucks ?? this.moreDucks,
      fish: fish ?? this.fish,
      watermelon: watermelon ?? this.watermelon,
      ponds: ponds ?? this.ponds,
      account_id: account_id ?? this.account_id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (duck_id.present) {
      map['duck_id'] = Variable<int>(duck_id.value);
    }
    if (totalQuack.present) {
      map['total_quack'] = Variable<int>(totalQuack.value);
    }
    if (currentQuack.present) {
      map['current_quack'] = Variable<int>(currentQuack.value);
    }
    if (duckTaps.present) {
      map['duck_taps'] = Variable<int>(duckTaps.value);
    }
    if (moreDucks.present) {
      map['more_ducks'] = Variable<int>(moreDucks.value);
    }
    if (fish.present) {
      map['fish'] = Variable<int>(fish.value);
    }
    if (watermelon.present) {
      map['watermelon'] = Variable<int>(watermelon.value);
    }
    if (ponds.present) {
      map['ponds'] = Variable<int>(ponds.value);
    }
    if (account_id.present) {
      map['account_id'] = Variable<int>(account_id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DucksCompanion(')
          ..write('duck_id: $duck_id, ')
          ..write('totalQuack: $totalQuack, ')
          ..write('currentQuack: $currentQuack, ')
          ..write('duckTaps: $duckTaps, ')
          ..write('moreDucks: $moreDucks, ')
          ..write('fish: $fish, ')
          ..write('watermelon: $watermelon, ')
          ..write('ponds: $ponds, ')
          ..write('account_id: $account_id')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $DucksTable ducks = $DucksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [accounts, ducks];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> account_id,
  required String username,
  required String password,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> account_id,
  Value<String> username,
  Value<String> password,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DucksTable, List<Duck>> _ducksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.ducks,
          aliasName: $_aliasNameGenerator(
              db.accounts.account_id, db.ducks.account_id));

  $$DucksTableProcessedTableManager get ducksRefs {
    final manager = $$DucksTableTableManager($_db, $_db.ducks).filter((f) =>
        f.account_id.account_id.sqlEquals($_itemColumn<int>('account_id')!));

    final cache = $_typedResult.readTableOrNull(_ducksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get account_id => $composableBuilder(
      column: $table.account_id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  Expression<bool> ducksRefs(
      Expression<bool> Function($$DucksTableFilterComposer f) f) {
    final $$DucksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account_id,
        referencedTable: $db.ducks,
        getReferencedColumn: (t) => t.account_id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DucksTableFilterComposer(
              $db: $db,
              $table: $db.ducks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get account_id => $composableBuilder(
      column: $table.account_id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get account_id => $composableBuilder(
      column: $table.account_id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  Expression<T> ducksRefs<T extends Object>(
      Expression<T> Function($$DucksTableAnnotationComposer a) f) {
    final $$DucksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account_id,
        referencedTable: $db.ducks,
        getReferencedColumn: (t) => t.account_id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DucksTableAnnotationComposer(
              $db: $db,
              $table: $db.ducks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool ducksRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> account_id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
          }) =>
              AccountsCompanion(
            account_id: account_id,
            username: username,
            password: password,
          ),
          createCompanionCallback: ({
            Value<int> account_id = const Value.absent(),
            required String username,
            required String password,
          }) =>
              AccountsCompanion.insert(
            account_id: account_id,
            username: username,
            password: password,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ducksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ducksRefs) db.ducks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ducksRefs)
                    await $_getPrefetchedData<Account, $AccountsTable, Duck>(
                        currentTable: table,
                        referencedTable:
                            $$AccountsTableReferences._ducksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0).ducksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.account_id == item.account_id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool ducksRefs})>;
typedef $$DucksTableCreateCompanionBuilder = DucksCompanion Function({
  Value<int> duck_id,
  required int totalQuack,
  required int currentQuack,
  required int duckTaps,
  required int moreDucks,
  required int fish,
  required int watermelon,
  required int ponds,
  required int account_id,
});
typedef $$DucksTableUpdateCompanionBuilder = DucksCompanion Function({
  Value<int> duck_id,
  Value<int> totalQuack,
  Value<int> currentQuack,
  Value<int> duckTaps,
  Value<int> moreDucks,
  Value<int> fish,
  Value<int> watermelon,
  Value<int> ponds,
  Value<int> account_id,
});

final class $$DucksTableReferences
    extends BaseReferences<_$AppDatabase, $DucksTable, Duck> {
  $$DucksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _account_idTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.ducks.account_id, db.accounts.account_id));

  $$AccountsTableProcessedTableManager get account_id {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.account_id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_account_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DucksTableFilterComposer extends Composer<_$AppDatabase, $DucksTable> {
  $$DucksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get duck_id => $composableBuilder(
      column: $table.duck_id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalQuack => $composableBuilder(
      column: $table.totalQuack, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentQuack => $composableBuilder(
      column: $table.currentQuack, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duckTaps => $composableBuilder(
      column: $table.duckTaps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get moreDucks => $composableBuilder(
      column: $table.moreDucks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fish => $composableBuilder(
      column: $table.fish, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get watermelon => $composableBuilder(
      column: $table.watermelon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ponds => $composableBuilder(
      column: $table.ponds, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get account_id {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account_id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.account_id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DucksTableOrderingComposer
    extends Composer<_$AppDatabase, $DucksTable> {
  $$DucksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get duck_id => $composableBuilder(
      column: $table.duck_id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalQuack => $composableBuilder(
      column: $table.totalQuack, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentQuack => $composableBuilder(
      column: $table.currentQuack,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duckTaps => $composableBuilder(
      column: $table.duckTaps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get moreDucks => $composableBuilder(
      column: $table.moreDucks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fish => $composableBuilder(
      column: $table.fish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get watermelon => $composableBuilder(
      column: $table.watermelon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ponds => $composableBuilder(
      column: $table.ponds, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get account_id {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account_id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.account_id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DucksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DucksTable> {
  $$DucksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get duck_id =>
      $composableBuilder(column: $table.duck_id, builder: (column) => column);

  GeneratedColumn<int> get totalQuack => $composableBuilder(
      column: $table.totalQuack, builder: (column) => column);

  GeneratedColumn<int> get currentQuack => $composableBuilder(
      column: $table.currentQuack, builder: (column) => column);

  GeneratedColumn<int> get duckTaps =>
      $composableBuilder(column: $table.duckTaps, builder: (column) => column);

  GeneratedColumn<int> get moreDucks =>
      $composableBuilder(column: $table.moreDucks, builder: (column) => column);

  GeneratedColumn<int> get fish =>
      $composableBuilder(column: $table.fish, builder: (column) => column);

  GeneratedColumn<int> get watermelon => $composableBuilder(
      column: $table.watermelon, builder: (column) => column);

  GeneratedColumn<int> get ponds =>
      $composableBuilder(column: $table.ponds, builder: (column) => column);

  $$AccountsTableAnnotationComposer get account_id {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.account_id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.account_id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DucksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DucksTable,
    Duck,
    $$DucksTableFilterComposer,
    $$DucksTableOrderingComposer,
    $$DucksTableAnnotationComposer,
    $$DucksTableCreateCompanionBuilder,
    $$DucksTableUpdateCompanionBuilder,
    (Duck, $$DucksTableReferences),
    Duck,
    PrefetchHooks Function({bool account_id})> {
  $$DucksTableTableManager(_$AppDatabase db, $DucksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DucksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DucksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DucksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> duck_id = const Value.absent(),
            Value<int> totalQuack = const Value.absent(),
            Value<int> currentQuack = const Value.absent(),
            Value<int> duckTaps = const Value.absent(),
            Value<int> moreDucks = const Value.absent(),
            Value<int> fish = const Value.absent(),
            Value<int> watermelon = const Value.absent(),
            Value<int> ponds = const Value.absent(),
            Value<int> account_id = const Value.absent(),
          }) =>
              DucksCompanion(
            duck_id: duck_id,
            totalQuack: totalQuack,
            currentQuack: currentQuack,
            duckTaps: duckTaps,
            moreDucks: moreDucks,
            fish: fish,
            watermelon: watermelon,
            ponds: ponds,
            account_id: account_id,
          ),
          createCompanionCallback: ({
            Value<int> duck_id = const Value.absent(),
            required int totalQuack,
            required int currentQuack,
            required int duckTaps,
            required int moreDucks,
            required int fish,
            required int watermelon,
            required int ponds,
            required int account_id,
          }) =>
              DucksCompanion.insert(
            duck_id: duck_id,
            totalQuack: totalQuack,
            currentQuack: currentQuack,
            duckTaps: duckTaps,
            moreDucks: moreDucks,
            fish: fish,
            watermelon: watermelon,
            ponds: ponds,
            account_id: account_id,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DucksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({account_id = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (account_id) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.account_id,
                    referencedTable:
                        $$DucksTableReferences._account_idTable(db),
                    referencedColumn:
                        $$DucksTableReferences._account_idTable(db).account_id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DucksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DucksTable,
    Duck,
    $$DucksTableFilterComposer,
    $$DucksTableOrderingComposer,
    $$DucksTableAnnotationComposer,
    $$DucksTableCreateCompanionBuilder,
    $$DucksTableUpdateCompanionBuilder,
    (Duck, $$DucksTableReferences),
    Duck,
    PrefetchHooks Function({bool account_id})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$DucksTableTableManager get ducks =>
      $$DucksTableTableManager(_db, _db.ducks);
}
