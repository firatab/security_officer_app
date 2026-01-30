// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TenantConfigTable extends TenantConfig
    with TableInfo<$TenantConfigTable, TenantConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantNameMeta = const VerificationMeta(
    'tenantName',
  );
  @override
  late final GeneratedColumn<String> tenantName = GeneratedColumn<String>(
    'tenant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantCodeMeta = const VerificationMeta(
    'tenantCode',
  );
  @override
  late final GeneratedColumn<String> tenantCode = GeneratedColumn<String>(
    'tenant_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apiBaseUrlMeta = const VerificationMeta(
    'apiBaseUrl',
  );
  @override
  late final GeneratedColumn<String> apiBaseUrl = GeneratedColumn<String>(
    'api_base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wsBaseUrlMeta = const VerificationMeta(
    'wsBaseUrl',
  );
  @override
  late final GeneratedColumn<String> wsBaseUrl = GeneratedColumn<String>(
    'ws_base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _environmentMeta = const VerificationMeta(
    'environment',
  );
  @override
  late final GeneratedColumn<String> environment = GeneratedColumn<String>(
    'environment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('prod'),
  );
  static const VerificationMeta _brandingJsonMeta = const VerificationMeta(
    'brandingJson',
  );
  @override
  late final GeneratedColumn<String> brandingJson = GeneratedColumn<String>(
    'branding_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    tenantName,
    tenantCode,
    apiBaseUrl,
    wsBaseUrl,
    environment,
    brandingJson,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenant_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<TenantConfigData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('tenant_name')) {
      context.handle(
        _tenantNameMeta,
        tenantName.isAcceptableOrUnknown(data['tenant_name']!, _tenantNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantNameMeta);
    }
    if (data.containsKey('tenant_code')) {
      context.handle(
        _tenantCodeMeta,
        tenantCode.isAcceptableOrUnknown(data['tenant_code']!, _tenantCodeMeta),
      );
    }
    if (data.containsKey('api_base_url')) {
      context.handle(
        _apiBaseUrlMeta,
        apiBaseUrl.isAcceptableOrUnknown(
          data['api_base_url']!,
          _apiBaseUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_apiBaseUrlMeta);
    }
    if (data.containsKey('ws_base_url')) {
      context.handle(
        _wsBaseUrlMeta,
        wsBaseUrl.isAcceptableOrUnknown(data['ws_base_url']!, _wsBaseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_wsBaseUrlMeta);
    }
    if (data.containsKey('environment')) {
      context.handle(
        _environmentMeta,
        environment.isAcceptableOrUnknown(
          data['environment']!,
          _environmentMeta,
        ),
      );
    }
    if (data.containsKey('branding_json')) {
      context.handle(
        _brandingJsonMeta,
        brandingJson.isAcceptableOrUnknown(
          data['branding_json']!,
          _brandingJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TenantConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantConfigData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      tenantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_name'],
      )!,
      tenantCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_code'],
      ),
      apiBaseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_base_url'],
      )!,
      wsBaseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ws_base_url'],
      )!,
      environment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}environment'],
      )!,
      brandingJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branding_json'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TenantConfigTable createAlias(String alias) {
    return $TenantConfigTable(attachedDatabase, alias);
  }
}

class TenantConfigData extends DataClass
    implements Insertable<TenantConfigData> {
  /// Primary key
  final int id;

  /// Tenant identifier from backend
  final String tenantId;

  /// Tenant display name
  final String tenantName;

  /// Short tenant code for easy setup
  final String? tenantCode;

  /// Base URL for REST API
  final String apiBaseUrl;

  /// Base URL for WebSocket connection
  final String wsBaseUrl;

  /// Environment (prod, stage, dev)
  final String environment;

  /// Branding configuration JSON (logo, theme colors, etc.)
  final String? brandingJson;

  /// Whether this tenant config is currently active
  final bool isActive;

  /// Timestamp when config was created
  final DateTime createdAt;

  /// Timestamp when config was last updated
  final DateTime updatedAt;
  const TenantConfigData({
    required this.id,
    required this.tenantId,
    required this.tenantName,
    this.tenantCode,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.environment,
    this.brandingJson,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['tenant_name'] = Variable<String>(tenantName);
    if (!nullToAbsent || tenantCode != null) {
      map['tenant_code'] = Variable<String>(tenantCode);
    }
    map['api_base_url'] = Variable<String>(apiBaseUrl);
    map['ws_base_url'] = Variable<String>(wsBaseUrl);
    map['environment'] = Variable<String>(environment);
    if (!nullToAbsent || brandingJson != null) {
      map['branding_json'] = Variable<String>(brandingJson);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TenantConfigCompanion toCompanion(bool nullToAbsent) {
    return TenantConfigCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      tenantName: Value(tenantName),
      tenantCode: tenantCode == null && nullToAbsent
          ? const Value.absent()
          : Value(tenantCode),
      apiBaseUrl: Value(apiBaseUrl),
      wsBaseUrl: Value(wsBaseUrl),
      environment: Value(environment),
      brandingJson: brandingJson == null && nullToAbsent
          ? const Value.absent()
          : Value(brandingJson),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TenantConfigData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantConfigData(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      tenantName: serializer.fromJson<String>(json['tenantName']),
      tenantCode: serializer.fromJson<String?>(json['tenantCode']),
      apiBaseUrl: serializer.fromJson<String>(json['apiBaseUrl']),
      wsBaseUrl: serializer.fromJson<String>(json['wsBaseUrl']),
      environment: serializer.fromJson<String>(json['environment']),
      brandingJson: serializer.fromJson<String?>(json['brandingJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'tenantName': serializer.toJson<String>(tenantName),
      'tenantCode': serializer.toJson<String?>(tenantCode),
      'apiBaseUrl': serializer.toJson<String>(apiBaseUrl),
      'wsBaseUrl': serializer.toJson<String>(wsBaseUrl),
      'environment': serializer.toJson<String>(environment),
      'brandingJson': serializer.toJson<String?>(brandingJson),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TenantConfigData copyWith({
    int? id,
    String? tenantId,
    String? tenantName,
    Value<String?> tenantCode = const Value.absent(),
    String? apiBaseUrl,
    String? wsBaseUrl,
    String? environment,
    Value<String?> brandingJson = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TenantConfigData(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    tenantName: tenantName ?? this.tenantName,
    tenantCode: tenantCode.present ? tenantCode.value : this.tenantCode,
    apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
    wsBaseUrl: wsBaseUrl ?? this.wsBaseUrl,
    environment: environment ?? this.environment,
    brandingJson: brandingJson.present ? brandingJson.value : this.brandingJson,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TenantConfigData copyWithCompanion(TenantConfigCompanion data) {
    return TenantConfigData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      tenantName: data.tenantName.present
          ? data.tenantName.value
          : this.tenantName,
      tenantCode: data.tenantCode.present
          ? data.tenantCode.value
          : this.tenantCode,
      apiBaseUrl: data.apiBaseUrl.present
          ? data.apiBaseUrl.value
          : this.apiBaseUrl,
      wsBaseUrl: data.wsBaseUrl.present ? data.wsBaseUrl.value : this.wsBaseUrl,
      environment: data.environment.present
          ? data.environment.value
          : this.environment,
      brandingJson: data.brandingJson.present
          ? data.brandingJson.value
          : this.brandingJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantConfigData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('tenantName: $tenantName, ')
          ..write('tenantCode: $tenantCode, ')
          ..write('apiBaseUrl: $apiBaseUrl, ')
          ..write('wsBaseUrl: $wsBaseUrl, ')
          ..write('environment: $environment, ')
          ..write('brandingJson: $brandingJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    tenantName,
    tenantCode,
    apiBaseUrl,
    wsBaseUrl,
    environment,
    brandingJson,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantConfigData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.tenantName == this.tenantName &&
          other.tenantCode == this.tenantCode &&
          other.apiBaseUrl == this.apiBaseUrl &&
          other.wsBaseUrl == this.wsBaseUrl &&
          other.environment == this.environment &&
          other.brandingJson == this.brandingJson &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TenantConfigCompanion extends UpdateCompanion<TenantConfigData> {
  final Value<int> id;
  final Value<String> tenantId;
  final Value<String> tenantName;
  final Value<String?> tenantCode;
  final Value<String> apiBaseUrl;
  final Value<String> wsBaseUrl;
  final Value<String> environment;
  final Value<String?> brandingJson;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TenantConfigCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.tenantName = const Value.absent(),
    this.tenantCode = const Value.absent(),
    this.apiBaseUrl = const Value.absent(),
    this.wsBaseUrl = const Value.absent(),
    this.environment = const Value.absent(),
    this.brandingJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TenantConfigCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String tenantName,
    this.tenantCode = const Value.absent(),
    required String apiBaseUrl,
    required String wsBaseUrl,
    this.environment = const Value.absent(),
    this.brandingJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : tenantId = Value(tenantId),
       tenantName = Value(tenantName),
       apiBaseUrl = Value(apiBaseUrl),
       wsBaseUrl = Value(wsBaseUrl);
  static Insertable<TenantConfigData> custom({
    Expression<int>? id,
    Expression<String>? tenantId,
    Expression<String>? tenantName,
    Expression<String>? tenantCode,
    Expression<String>? apiBaseUrl,
    Expression<String>? wsBaseUrl,
    Expression<String>? environment,
    Expression<String>? brandingJson,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (tenantName != null) 'tenant_name': tenantName,
      if (tenantCode != null) 'tenant_code': tenantCode,
      if (apiBaseUrl != null) 'api_base_url': apiBaseUrl,
      if (wsBaseUrl != null) 'ws_base_url': wsBaseUrl,
      if (environment != null) 'environment': environment,
      if (brandingJson != null) 'branding_json': brandingJson,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TenantConfigCompanion copyWith({
    Value<int>? id,
    Value<String>? tenantId,
    Value<String>? tenantName,
    Value<String?>? tenantCode,
    Value<String>? apiBaseUrl,
    Value<String>? wsBaseUrl,
    Value<String>? environment,
    Value<String?>? brandingJson,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TenantConfigCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      tenantCode: tenantCode ?? this.tenantCode,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      wsBaseUrl: wsBaseUrl ?? this.wsBaseUrl,
      environment: environment ?? this.environment,
      brandingJson: brandingJson ?? this.brandingJson,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (tenantName.present) {
      map['tenant_name'] = Variable<String>(tenantName.value);
    }
    if (tenantCode.present) {
      map['tenant_code'] = Variable<String>(tenantCode.value);
    }
    if (apiBaseUrl.present) {
      map['api_base_url'] = Variable<String>(apiBaseUrl.value);
    }
    if (wsBaseUrl.present) {
      map['ws_base_url'] = Variable<String>(wsBaseUrl.value);
    }
    if (environment.present) {
      map['environment'] = Variable<String>(environment.value);
    }
    if (brandingJson.present) {
      map['branding_json'] = Variable<String>(brandingJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantConfigCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('tenantName: $tenantName, ')
          ..write('tenantCode: $tenantCode, ')
          ..write('apiBaseUrl: $apiBaseUrl, ')
          ..write('wsBaseUrl: $wsBaseUrl, ')
          ..write('environment: $environment, ')
          ..write('brandingJson: $brandingJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppConfigTable extends AppConfig
    with TableInfo<$AppConfigTable, AppConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_config';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppConfigData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppConfigData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppConfigTable createAlias(String alias) {
    return $AppConfigTable(attachedDatabase, alias);
  }
}

class AppConfigData extends DataClass implements Insertable<AppConfigData> {
  /// Configuration key
  final String key;

  /// Configuration value (JSON-encoded for complex values)
  final String value;

  /// Timestamp when config was updated
  final DateTime updatedAt;
  const AppConfigData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppConfigCompanion toCompanion(bool nullToAbsent) {
    return AppConfigCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppConfigData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppConfigData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppConfigData copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppConfigData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppConfigData copyWithCompanion(AppConfigCompanion data) {
    return AppConfigData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppConfigData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppConfigCompanion extends UpdateCompanion<AppConfigData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppConfigCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppConfigCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppConfigData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppConfigCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppConfigCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteNameMeta = const VerificationMeta(
    'siteName',
  );
  @override
  late final GeneratedColumn<String> siteName = GeneratedColumn<String>(
    'site_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteAddressMeta = const VerificationMeta(
    'siteAddress',
  );
  @override
  late final GeneratedColumn<String> siteAddress = GeneratedColumn<String>(
    'site_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteLatitudeMeta = const VerificationMeta(
    'siteLatitude',
  );
  @override
  late final GeneratedColumn<double> siteLatitude = GeneratedColumn<double>(
    'site_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _siteLongitudeMeta = const VerificationMeta(
    'siteLongitude',
  );
  @override
  late final GeneratedColumn<double> siteLongitude = GeneratedColumn<double>(
    'site_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftDateMeta = const VerificationMeta(
    'shiftDate',
  );
  @override
  late final GeneratedColumn<DateTime> shiftDate = GeneratedColumn<DateTime>(
    'shift_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _checkCallEnabledMeta = const VerificationMeta(
    'checkCallEnabled',
  );
  @override
  late final GeneratedColumn<bool> checkCallEnabled = GeneratedColumn<bool>(
    'check_call_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("check_call_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkCallFrequencyMeta =
      const VerificationMeta('checkCallFrequency');
  @override
  late final GeneratedColumn<int> checkCallFrequency = GeneratedColumn<int>(
    'check_call_frequency',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    employeeId,
    siteId,
    clientId,
    siteName,
    siteAddress,
    siteLatitude,
    siteLongitude,
    clientName,
    shiftDate,
    startTime,
    endTime,
    breakMinutes,
    status,
    checkCallEnabled,
    checkCallFrequency,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('site_name')) {
      context.handle(
        _siteNameMeta,
        siteName.isAcceptableOrUnknown(data['site_name']!, _siteNameMeta),
      );
    } else if (isInserting) {
      context.missing(_siteNameMeta);
    }
    if (data.containsKey('site_address')) {
      context.handle(
        _siteAddressMeta,
        siteAddress.isAcceptableOrUnknown(
          data['site_address']!,
          _siteAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_siteAddressMeta);
    }
    if (data.containsKey('site_latitude')) {
      context.handle(
        _siteLatitudeMeta,
        siteLatitude.isAcceptableOrUnknown(
          data['site_latitude']!,
          _siteLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('site_longitude')) {
      context.handle(
        _siteLongitudeMeta,
        siteLongitude.isAcceptableOrUnknown(
          data['site_longitude']!,
          _siteLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    } else if (isInserting) {
      context.missing(_clientNameMeta);
    }
    if (data.containsKey('shift_date')) {
      context.handle(
        _shiftDateMeta,
        shiftDate.isAcceptableOrUnknown(data['shift_date']!, _shiftDateMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('check_call_enabled')) {
      context.handle(
        _checkCallEnabledMeta,
        checkCallEnabled.isAcceptableOrUnknown(
          data['check_call_enabled']!,
          _checkCallEnabledMeta,
        ),
      );
    }
    if (data.containsKey('check_call_frequency')) {
      context.handle(
        _checkCallFrequencyMeta,
        checkCallFrequency.isAcceptableOrUnknown(
          data['check_call_frequency']!,
          _checkCallFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      siteName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_name'],
      )!,
      siteAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_address'],
      )!,
      siteLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}site_latitude'],
      ),
      siteLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}site_longitude'],
      ),
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      )!,
      shiftDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}shift_date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      checkCallEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}check_call_enabled'],
      )!,
      checkCallFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}check_call_frequency'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final String id;
  final String tenantId;
  final String employeeId;
  final String siteId;
  final String clientId;
  final String siteName;
  final String siteAddress;
  final double? siteLatitude;
  final double? siteLongitude;
  final String clientName;
  final DateTime shiftDate;
  final DateTime startTime;
  final DateTime endTime;
  final int breakMinutes;
  final String status;
  final bool checkCallEnabled;
  final int? checkCallFrequency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const Shift({
    required this.id,
    required this.tenantId,
    required this.employeeId,
    required this.siteId,
    required this.clientId,
    required this.siteName,
    required this.siteAddress,
    this.siteLatitude,
    this.siteLongitude,
    required this.clientName,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    required this.status,
    required this.checkCallEnabled,
    this.checkCallFrequency,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['employee_id'] = Variable<String>(employeeId);
    map['site_id'] = Variable<String>(siteId);
    map['client_id'] = Variable<String>(clientId);
    map['site_name'] = Variable<String>(siteName);
    map['site_address'] = Variable<String>(siteAddress);
    if (!nullToAbsent || siteLatitude != null) {
      map['site_latitude'] = Variable<double>(siteLatitude);
    }
    if (!nullToAbsent || siteLongitude != null) {
      map['site_longitude'] = Variable<double>(siteLongitude);
    }
    map['client_name'] = Variable<String>(clientName);
    map['shift_date'] = Variable<DateTime>(shiftDate);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['status'] = Variable<String>(status);
    map['check_call_enabled'] = Variable<bool>(checkCallEnabled);
    if (!nullToAbsent || checkCallFrequency != null) {
      map['check_call_frequency'] = Variable<int>(checkCallFrequency);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      employeeId: Value(employeeId),
      siteId: Value(siteId),
      clientId: Value(clientId),
      siteName: Value(siteName),
      siteAddress: Value(siteAddress),
      siteLatitude: siteLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(siteLatitude),
      siteLongitude: siteLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(siteLongitude),
      clientName: Value(clientName),
      shiftDate: Value(shiftDate),
      startTime: Value(startTime),
      endTime: Value(endTime),
      breakMinutes: Value(breakMinutes),
      status: Value(status),
      checkCallEnabled: Value(checkCallEnabled),
      checkCallFrequency: checkCallFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(checkCallFrequency),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Shift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      siteName: serializer.fromJson<String>(json['siteName']),
      siteAddress: serializer.fromJson<String>(json['siteAddress']),
      siteLatitude: serializer.fromJson<double?>(json['siteLatitude']),
      siteLongitude: serializer.fromJson<double?>(json['siteLongitude']),
      clientName: serializer.fromJson<String>(json['clientName']),
      shiftDate: serializer.fromJson<DateTime>(json['shiftDate']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      status: serializer.fromJson<String>(json['status']),
      checkCallEnabled: serializer.fromJson<bool>(json['checkCallEnabled']),
      checkCallFrequency: serializer.fromJson<int?>(json['checkCallFrequency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'employeeId': serializer.toJson<String>(employeeId),
      'siteId': serializer.toJson<String>(siteId),
      'clientId': serializer.toJson<String>(clientId),
      'siteName': serializer.toJson<String>(siteName),
      'siteAddress': serializer.toJson<String>(siteAddress),
      'siteLatitude': serializer.toJson<double?>(siteLatitude),
      'siteLongitude': serializer.toJson<double?>(siteLongitude),
      'clientName': serializer.toJson<String>(clientName),
      'shiftDate': serializer.toJson<DateTime>(shiftDate),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'status': serializer.toJson<String>(status),
      'checkCallEnabled': serializer.toJson<bool>(checkCallEnabled),
      'checkCallFrequency': serializer.toJson<int?>(checkCallFrequency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Shift copyWith({
    String? id,
    String? tenantId,
    String? employeeId,
    String? siteId,
    String? clientId,
    String? siteName,
    String? siteAddress,
    Value<double?> siteLatitude = const Value.absent(),
    Value<double?> siteLongitude = const Value.absent(),
    String? clientName,
    DateTime? shiftDate,
    DateTime? startTime,
    DateTime? endTime,
    int? breakMinutes,
    String? status,
    bool? checkCallEnabled,
    Value<int?> checkCallFrequency = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => Shift(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    employeeId: employeeId ?? this.employeeId,
    siteId: siteId ?? this.siteId,
    clientId: clientId ?? this.clientId,
    siteName: siteName ?? this.siteName,
    siteAddress: siteAddress ?? this.siteAddress,
    siteLatitude: siteLatitude.present ? siteLatitude.value : this.siteLatitude,
    siteLongitude: siteLongitude.present
        ? siteLongitude.value
        : this.siteLongitude,
    clientName: clientName ?? this.clientName,
    shiftDate: shiftDate ?? this.shiftDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    status: status ?? this.status,
    checkCallEnabled: checkCallEnabled ?? this.checkCallEnabled,
    checkCallFrequency: checkCallFrequency.present
        ? checkCallFrequency.value
        : this.checkCallFrequency,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      siteName: data.siteName.present ? data.siteName.value : this.siteName,
      siteAddress: data.siteAddress.present
          ? data.siteAddress.value
          : this.siteAddress,
      siteLatitude: data.siteLatitude.present
          ? data.siteLatitude.value
          : this.siteLatitude,
      siteLongitude: data.siteLongitude.present
          ? data.siteLongitude.value
          : this.siteLongitude,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      shiftDate: data.shiftDate.present ? data.shiftDate.value : this.shiftDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      status: data.status.present ? data.status.value : this.status,
      checkCallEnabled: data.checkCallEnabled.present
          ? data.checkCallEnabled.value
          : this.checkCallEnabled,
      checkCallFrequency: data.checkCallFrequency.present
          ? data.checkCallFrequency.value
          : this.checkCallFrequency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('employeeId: $employeeId, ')
          ..write('siteId: $siteId, ')
          ..write('clientId: $clientId, ')
          ..write('siteName: $siteName, ')
          ..write('siteAddress: $siteAddress, ')
          ..write('siteLatitude: $siteLatitude, ')
          ..write('siteLongitude: $siteLongitude, ')
          ..write('clientName: $clientName, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('status: $status, ')
          ..write('checkCallEnabled: $checkCallEnabled, ')
          ..write('checkCallFrequency: $checkCallFrequency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    employeeId,
    siteId,
    clientId,
    siteName,
    siteAddress,
    siteLatitude,
    siteLongitude,
    clientName,
    shiftDate,
    startTime,
    endTime,
    breakMinutes,
    status,
    checkCallEnabled,
    checkCallFrequency,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.employeeId == this.employeeId &&
          other.siteId == this.siteId &&
          other.clientId == this.clientId &&
          other.siteName == this.siteName &&
          other.siteAddress == this.siteAddress &&
          other.siteLatitude == this.siteLatitude &&
          other.siteLongitude == this.siteLongitude &&
          other.clientName == this.clientName &&
          other.shiftDate == this.shiftDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.breakMinutes == this.breakMinutes &&
          other.status == this.status &&
          other.checkCallEnabled == this.checkCallEnabled &&
          other.checkCallFrequency == this.checkCallFrequency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> employeeId;
  final Value<String> siteId;
  final Value<String> clientId;
  final Value<String> siteName;
  final Value<String> siteAddress;
  final Value<double?> siteLatitude;
  final Value<double?> siteLongitude;
  final Value<String> clientName;
  final Value<DateTime> shiftDate;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> breakMinutes;
  final Value<String> status;
  final Value<bool> checkCallEnabled;
  final Value<int?> checkCallFrequency;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.siteName = const Value.absent(),
    this.siteAddress = const Value.absent(),
    this.siteLatitude = const Value.absent(),
    this.siteLongitude = const Value.absent(),
    this.clientName = const Value.absent(),
    this.shiftDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.checkCallEnabled = const Value.absent(),
    this.checkCallFrequency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsCompanion.insert({
    required String id,
    required String tenantId,
    required String employeeId,
    required String siteId,
    required String clientId,
    required String siteName,
    required String siteAddress,
    this.siteLatitude = const Value.absent(),
    this.siteLongitude = const Value.absent(),
    required String clientName,
    required DateTime shiftDate,
    required DateTime startTime,
    required DateTime endTime,
    this.breakMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.checkCallEnabled = const Value.absent(),
    this.checkCallFrequency = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       employeeId = Value(employeeId),
       siteId = Value(siteId),
       clientId = Value(clientId),
       siteName = Value(siteName),
       siteAddress = Value(siteAddress),
       clientName = Value(clientName),
       shiftDate = Value(shiftDate),
       startTime = Value(startTime),
       endTime = Value(endTime),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Shift> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? employeeId,
    Expression<String>? siteId,
    Expression<String>? clientId,
    Expression<String>? siteName,
    Expression<String>? siteAddress,
    Expression<double>? siteLatitude,
    Expression<double>? siteLongitude,
    Expression<String>? clientName,
    Expression<DateTime>? shiftDate,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? breakMinutes,
    Expression<String>? status,
    Expression<bool>? checkCallEnabled,
    Expression<int>? checkCallFrequency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (employeeId != null) 'employee_id': employeeId,
      if (siteId != null) 'site_id': siteId,
      if (clientId != null) 'client_id': clientId,
      if (siteName != null) 'site_name': siteName,
      if (siteAddress != null) 'site_address': siteAddress,
      if (siteLatitude != null) 'site_latitude': siteLatitude,
      if (siteLongitude != null) 'site_longitude': siteLongitude,
      if (clientName != null) 'client_name': clientName,
      if (shiftDate != null) 'shift_date': shiftDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (status != null) 'status': status,
      if (checkCallEnabled != null) 'check_call_enabled': checkCallEnabled,
      if (checkCallFrequency != null)
        'check_call_frequency': checkCallFrequency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? employeeId,
    Value<String>? siteId,
    Value<String>? clientId,
    Value<String>? siteName,
    Value<String>? siteAddress,
    Value<double?>? siteLatitude,
    Value<double?>? siteLongitude,
    Value<String>? clientName,
    Value<DateTime>? shiftDate,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int>? breakMinutes,
    Value<String>? status,
    Value<bool>? checkCallEnabled,
    Value<int?>? checkCallFrequency,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      employeeId: employeeId ?? this.employeeId,
      siteId: siteId ?? this.siteId,
      clientId: clientId ?? this.clientId,
      siteName: siteName ?? this.siteName,
      siteAddress: siteAddress ?? this.siteAddress,
      siteLatitude: siteLatitude ?? this.siteLatitude,
      siteLongitude: siteLongitude ?? this.siteLongitude,
      clientName: clientName ?? this.clientName,
      shiftDate: shiftDate ?? this.shiftDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      status: status ?? this.status,
      checkCallEnabled: checkCallEnabled ?? this.checkCallEnabled,
      checkCallFrequency: checkCallFrequency ?? this.checkCallFrequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (siteName.present) {
      map['site_name'] = Variable<String>(siteName.value);
    }
    if (siteAddress.present) {
      map['site_address'] = Variable<String>(siteAddress.value);
    }
    if (siteLatitude.present) {
      map['site_latitude'] = Variable<double>(siteLatitude.value);
    }
    if (siteLongitude.present) {
      map['site_longitude'] = Variable<double>(siteLongitude.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (shiftDate.present) {
      map['shift_date'] = Variable<DateTime>(shiftDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (checkCallEnabled.present) {
      map['check_call_enabled'] = Variable<bool>(checkCallEnabled.value);
    }
    if (checkCallFrequency.present) {
      map['check_call_frequency'] = Variable<int>(checkCallFrequency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('employeeId: $employeeId, ')
          ..write('siteId: $siteId, ')
          ..write('clientId: $clientId, ')
          ..write('siteName: $siteName, ')
          ..write('siteAddress: $siteAddress, ')
          ..write('siteLatitude: $siteLatitude, ')
          ..write('siteLongitude: $siteLongitude, ')
          ..write('clientName: $clientName, ')
          ..write('shiftDate: $shiftDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('status: $status, ')
          ..write('checkCallEnabled: $checkCallEnabled, ')
          ..write('checkCallFrequency: $checkCallFrequency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendancesTable extends Attendances
    with TableInfo<$AttendancesTable, Attendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookOnTimeMeta = const VerificationMeta(
    'bookOnTime',
  );
  @override
  late final GeneratedColumn<DateTime> bookOnTime = GeneratedColumn<DateTime>(
    'book_on_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOnLatitudeMeta = const VerificationMeta(
    'bookOnLatitude',
  );
  @override
  late final GeneratedColumn<double> bookOnLatitude = GeneratedColumn<double>(
    'book_on_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOnLongitudeMeta = const VerificationMeta(
    'bookOnLongitude',
  );
  @override
  late final GeneratedColumn<double> bookOnLongitude = GeneratedColumn<double>(
    'book_on_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOnMethodMeta = const VerificationMeta(
    'bookOnMethod',
  );
  @override
  late final GeneratedColumn<String> bookOnMethod = GeneratedColumn<String>(
    'book_on_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOffTimeMeta = const VerificationMeta(
    'bookOffTime',
  );
  @override
  late final GeneratedColumn<DateTime> bookOffTime = GeneratedColumn<DateTime>(
    'book_off_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOffLatitudeMeta = const VerificationMeta(
    'bookOffLatitude',
  );
  @override
  late final GeneratedColumn<double> bookOffLatitude = GeneratedColumn<double>(
    'book_off_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOffLongitudeMeta = const VerificationMeta(
    'bookOffLongitude',
  );
  @override
  late final GeneratedColumn<double> bookOffLongitude = GeneratedColumn<double>(
    'book_off_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookOffMethodMeta = const VerificationMeta(
    'bookOffMethod',
  );
  @override
  late final GeneratedColumn<String> bookOffMethod = GeneratedColumn<String>(
    'book_off_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _totalHoursMeta = const VerificationMeta(
    'totalHours',
  );
  @override
  late final GeneratedColumn<double> totalHours = GeneratedColumn<double>(
    'total_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLateMeta = const VerificationMeta('isLate');
  @override
  late final GeneratedColumn<bool> isLate = GeneratedColumn<bool>(
    'is_late',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_late" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lateMinutesMeta = const VerificationMeta(
    'lateMinutes',
  );
  @override
  late final GeneratedColumn<int> lateMinutes = GeneratedColumn<int>(
    'late_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoBookedOffMeta = const VerificationMeta(
    'autoBookedOff',
  );
  @override
  late final GeneratedColumn<bool> autoBookedOff = GeneratedColumn<bool>(
    'auto_booked_off',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_booked_off" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    employeeId,
    tenantId,
    bookOnTime,
    bookOnLatitude,
    bookOnLongitude,
    bookOnMethod,
    bookOffTime,
    bookOffLatitude,
    bookOffLongitude,
    bookOffMethod,
    status,
    totalHours,
    isLate,
    lateMinutes,
    autoBookedOff,
    createdAt,
    updatedAt,
    syncedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attendance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('book_on_time')) {
      context.handle(
        _bookOnTimeMeta,
        bookOnTime.isAcceptableOrUnknown(
          data['book_on_time']!,
          _bookOnTimeMeta,
        ),
      );
    }
    if (data.containsKey('book_on_latitude')) {
      context.handle(
        _bookOnLatitudeMeta,
        bookOnLatitude.isAcceptableOrUnknown(
          data['book_on_latitude']!,
          _bookOnLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('book_on_longitude')) {
      context.handle(
        _bookOnLongitudeMeta,
        bookOnLongitude.isAcceptableOrUnknown(
          data['book_on_longitude']!,
          _bookOnLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('book_on_method')) {
      context.handle(
        _bookOnMethodMeta,
        bookOnMethod.isAcceptableOrUnknown(
          data['book_on_method']!,
          _bookOnMethodMeta,
        ),
      );
    }
    if (data.containsKey('book_off_time')) {
      context.handle(
        _bookOffTimeMeta,
        bookOffTime.isAcceptableOrUnknown(
          data['book_off_time']!,
          _bookOffTimeMeta,
        ),
      );
    }
    if (data.containsKey('book_off_latitude')) {
      context.handle(
        _bookOffLatitudeMeta,
        bookOffLatitude.isAcceptableOrUnknown(
          data['book_off_latitude']!,
          _bookOffLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('book_off_longitude')) {
      context.handle(
        _bookOffLongitudeMeta,
        bookOffLongitude.isAcceptableOrUnknown(
          data['book_off_longitude']!,
          _bookOffLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('book_off_method')) {
      context.handle(
        _bookOffMethodMeta,
        bookOffMethod.isAcceptableOrUnknown(
          data['book_off_method']!,
          _bookOffMethodMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_hours')) {
      context.handle(
        _totalHoursMeta,
        totalHours.isAcceptableOrUnknown(data['total_hours']!, _totalHoursMeta),
      );
    }
    if (data.containsKey('is_late')) {
      context.handle(
        _isLateMeta,
        isLate.isAcceptableOrUnknown(data['is_late']!, _isLateMeta),
      );
    }
    if (data.containsKey('late_minutes')) {
      context.handle(
        _lateMinutesMeta,
        lateMinutes.isAcceptableOrUnknown(
          data['late_minutes']!,
          _lateMinutesMeta,
        ),
      );
    }
    if (data.containsKey('auto_booked_off')) {
      context.handle(
        _autoBookedOffMeta,
        autoBookedOff.isAcceptableOrUnknown(
          data['auto_booked_off']!,
          _autoBookedOffMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attendance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      bookOnTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}book_on_time'],
      ),
      bookOnLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}book_on_latitude'],
      ),
      bookOnLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}book_on_longitude'],
      ),
      bookOnMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_on_method'],
      ),
      bookOffTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}book_off_time'],
      ),
      bookOffLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}book_off_latitude'],
      ),
      bookOffLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}book_off_longitude'],
      ),
      bookOffMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_off_method'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_hours'],
      ),
      isLate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_late'],
      )!,
      lateMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}late_minutes'],
      ),
      autoBookedOff: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_booked_off'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $AttendancesTable createAlias(String alias) {
    return $AttendancesTable(attachedDatabase, alias);
  }
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final String id;
  final String shiftId;
  final String employeeId;
  final String tenantId;
  final DateTime? bookOnTime;
  final double? bookOnLatitude;
  final double? bookOnLongitude;
  final String? bookOnMethod;
  final DateTime? bookOffTime;
  final double? bookOffLatitude;
  final double? bookOffLongitude;
  final String? bookOffMethod;
  final String status;
  final double? totalHours;
  final bool isLate;
  final int? lateMinutes;
  final bool autoBookedOff;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool needsSync;
  const Attendance({
    required this.id,
    required this.shiftId,
    required this.employeeId,
    required this.tenantId,
    this.bookOnTime,
    this.bookOnLatitude,
    this.bookOnLongitude,
    this.bookOnMethod,
    this.bookOffTime,
    this.bookOffLatitude,
    this.bookOffLongitude,
    this.bookOffMethod,
    required this.status,
    this.totalHours,
    required this.isLate,
    this.lateMinutes,
    required this.autoBookedOff,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift_id'] = Variable<String>(shiftId);
    map['employee_id'] = Variable<String>(employeeId);
    map['tenant_id'] = Variable<String>(tenantId);
    if (!nullToAbsent || bookOnTime != null) {
      map['book_on_time'] = Variable<DateTime>(bookOnTime);
    }
    if (!nullToAbsent || bookOnLatitude != null) {
      map['book_on_latitude'] = Variable<double>(bookOnLatitude);
    }
    if (!nullToAbsent || bookOnLongitude != null) {
      map['book_on_longitude'] = Variable<double>(bookOnLongitude);
    }
    if (!nullToAbsent || bookOnMethod != null) {
      map['book_on_method'] = Variable<String>(bookOnMethod);
    }
    if (!nullToAbsent || bookOffTime != null) {
      map['book_off_time'] = Variable<DateTime>(bookOffTime);
    }
    if (!nullToAbsent || bookOffLatitude != null) {
      map['book_off_latitude'] = Variable<double>(bookOffLatitude);
    }
    if (!nullToAbsent || bookOffLongitude != null) {
      map['book_off_longitude'] = Variable<double>(bookOffLongitude);
    }
    if (!nullToAbsent || bookOffMethod != null) {
      map['book_off_method'] = Variable<String>(bookOffMethod);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || totalHours != null) {
      map['total_hours'] = Variable<double>(totalHours);
    }
    map['is_late'] = Variable<bool>(isLate);
    if (!nullToAbsent || lateMinutes != null) {
      map['late_minutes'] = Variable<int>(lateMinutes);
    }
    map['auto_booked_off'] = Variable<bool>(autoBookedOff);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      employeeId: Value(employeeId),
      tenantId: Value(tenantId),
      bookOnTime: bookOnTime == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOnTime),
      bookOnLatitude: bookOnLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOnLatitude),
      bookOnLongitude: bookOnLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOnLongitude),
      bookOnMethod: bookOnMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOnMethod),
      bookOffTime: bookOffTime == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOffTime),
      bookOffLatitude: bookOffLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOffLatitude),
      bookOffLongitude: bookOffLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOffLongitude),
      bookOffMethod: bookOffMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(bookOffMethod),
      status: Value(status),
      totalHours: totalHours == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHours),
      isLate: Value(isLate),
      lateMinutes: lateMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(lateMinutes),
      autoBookedOff: Value(autoBookedOff),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      needsSync: Value(needsSync),
    );
  }

  factory Attendance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attendance(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      bookOnTime: serializer.fromJson<DateTime?>(json['bookOnTime']),
      bookOnLatitude: serializer.fromJson<double?>(json['bookOnLatitude']),
      bookOnLongitude: serializer.fromJson<double?>(json['bookOnLongitude']),
      bookOnMethod: serializer.fromJson<String?>(json['bookOnMethod']),
      bookOffTime: serializer.fromJson<DateTime?>(json['bookOffTime']),
      bookOffLatitude: serializer.fromJson<double?>(json['bookOffLatitude']),
      bookOffLongitude: serializer.fromJson<double?>(json['bookOffLongitude']),
      bookOffMethod: serializer.fromJson<String?>(json['bookOffMethod']),
      status: serializer.fromJson<String>(json['status']),
      totalHours: serializer.fromJson<double?>(json['totalHours']),
      isLate: serializer.fromJson<bool>(json['isLate']),
      lateMinutes: serializer.fromJson<int?>(json['lateMinutes']),
      autoBookedOff: serializer.fromJson<bool>(json['autoBookedOff']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String>(shiftId),
      'employeeId': serializer.toJson<String>(employeeId),
      'tenantId': serializer.toJson<String>(tenantId),
      'bookOnTime': serializer.toJson<DateTime?>(bookOnTime),
      'bookOnLatitude': serializer.toJson<double?>(bookOnLatitude),
      'bookOnLongitude': serializer.toJson<double?>(bookOnLongitude),
      'bookOnMethod': serializer.toJson<String?>(bookOnMethod),
      'bookOffTime': serializer.toJson<DateTime?>(bookOffTime),
      'bookOffLatitude': serializer.toJson<double?>(bookOffLatitude),
      'bookOffLongitude': serializer.toJson<double?>(bookOffLongitude),
      'bookOffMethod': serializer.toJson<String?>(bookOffMethod),
      'status': serializer.toJson<String>(status),
      'totalHours': serializer.toJson<double?>(totalHours),
      'isLate': serializer.toJson<bool>(isLate),
      'lateMinutes': serializer.toJson<int?>(lateMinutes),
      'autoBookedOff': serializer.toJson<bool>(autoBookedOff),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  Attendance copyWith({
    String? id,
    String? shiftId,
    String? employeeId,
    String? tenantId,
    Value<DateTime?> bookOnTime = const Value.absent(),
    Value<double?> bookOnLatitude = const Value.absent(),
    Value<double?> bookOnLongitude = const Value.absent(),
    Value<String?> bookOnMethod = const Value.absent(),
    Value<DateTime?> bookOffTime = const Value.absent(),
    Value<double?> bookOffLatitude = const Value.absent(),
    Value<double?> bookOffLongitude = const Value.absent(),
    Value<String?> bookOffMethod = const Value.absent(),
    String? status,
    Value<double?> totalHours = const Value.absent(),
    bool? isLate,
    Value<int?> lateMinutes = const Value.absent(),
    bool? autoBookedOff,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
    bool? needsSync,
  }) => Attendance(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    employeeId: employeeId ?? this.employeeId,
    tenantId: tenantId ?? this.tenantId,
    bookOnTime: bookOnTime.present ? bookOnTime.value : this.bookOnTime,
    bookOnLatitude: bookOnLatitude.present
        ? bookOnLatitude.value
        : this.bookOnLatitude,
    bookOnLongitude: bookOnLongitude.present
        ? bookOnLongitude.value
        : this.bookOnLongitude,
    bookOnMethod: bookOnMethod.present ? bookOnMethod.value : this.bookOnMethod,
    bookOffTime: bookOffTime.present ? bookOffTime.value : this.bookOffTime,
    bookOffLatitude: bookOffLatitude.present
        ? bookOffLatitude.value
        : this.bookOffLatitude,
    bookOffLongitude: bookOffLongitude.present
        ? bookOffLongitude.value
        : this.bookOffLongitude,
    bookOffMethod: bookOffMethod.present
        ? bookOffMethod.value
        : this.bookOffMethod,
    status: status ?? this.status,
    totalHours: totalHours.present ? totalHours.value : this.totalHours,
    isLate: isLate ?? this.isLate,
    lateMinutes: lateMinutes.present ? lateMinutes.value : this.lateMinutes,
    autoBookedOff: autoBookedOff ?? this.autoBookedOff,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  Attendance copyWithCompanion(AttendancesCompanion data) {
    return Attendance(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      bookOnTime: data.bookOnTime.present
          ? data.bookOnTime.value
          : this.bookOnTime,
      bookOnLatitude: data.bookOnLatitude.present
          ? data.bookOnLatitude.value
          : this.bookOnLatitude,
      bookOnLongitude: data.bookOnLongitude.present
          ? data.bookOnLongitude.value
          : this.bookOnLongitude,
      bookOnMethod: data.bookOnMethod.present
          ? data.bookOnMethod.value
          : this.bookOnMethod,
      bookOffTime: data.bookOffTime.present
          ? data.bookOffTime.value
          : this.bookOffTime,
      bookOffLatitude: data.bookOffLatitude.present
          ? data.bookOffLatitude.value
          : this.bookOffLatitude,
      bookOffLongitude: data.bookOffLongitude.present
          ? data.bookOffLongitude.value
          : this.bookOffLongitude,
      bookOffMethod: data.bookOffMethod.present
          ? data.bookOffMethod.value
          : this.bookOffMethod,
      status: data.status.present ? data.status.value : this.status,
      totalHours: data.totalHours.present
          ? data.totalHours.value
          : this.totalHours,
      isLate: data.isLate.present ? data.isLate.value : this.isLate,
      lateMinutes: data.lateMinutes.present
          ? data.lateMinutes.value
          : this.lateMinutes,
      autoBookedOff: data.autoBookedOff.present
          ? data.autoBookedOff.value
          : this.autoBookedOff,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('tenantId: $tenantId, ')
          ..write('bookOnTime: $bookOnTime, ')
          ..write('bookOnLatitude: $bookOnLatitude, ')
          ..write('bookOnLongitude: $bookOnLongitude, ')
          ..write('bookOnMethod: $bookOnMethod, ')
          ..write('bookOffTime: $bookOffTime, ')
          ..write('bookOffLatitude: $bookOffLatitude, ')
          ..write('bookOffLongitude: $bookOffLongitude, ')
          ..write('bookOffMethod: $bookOffMethod, ')
          ..write('status: $status, ')
          ..write('totalHours: $totalHours, ')
          ..write('isLate: $isLate, ')
          ..write('lateMinutes: $lateMinutes, ')
          ..write('autoBookedOff: $autoBookedOff, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    shiftId,
    employeeId,
    tenantId,
    bookOnTime,
    bookOnLatitude,
    bookOnLongitude,
    bookOnMethod,
    bookOffTime,
    bookOffLatitude,
    bookOffLongitude,
    bookOffMethod,
    status,
    totalHours,
    isLate,
    lateMinutes,
    autoBookedOff,
    createdAt,
    updatedAt,
    syncedAt,
    needsSync,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.employeeId == this.employeeId &&
          other.tenantId == this.tenantId &&
          other.bookOnTime == this.bookOnTime &&
          other.bookOnLatitude == this.bookOnLatitude &&
          other.bookOnLongitude == this.bookOnLongitude &&
          other.bookOnMethod == this.bookOnMethod &&
          other.bookOffTime == this.bookOffTime &&
          other.bookOffLatitude == this.bookOffLatitude &&
          other.bookOffLongitude == this.bookOffLongitude &&
          other.bookOffMethod == this.bookOffMethod &&
          other.status == this.status &&
          other.totalHours == this.totalHours &&
          other.isLate == this.isLate &&
          other.lateMinutes == this.lateMinutes &&
          other.autoBookedOff == this.autoBookedOff &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.needsSync == this.needsSync);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<String> id;
  final Value<String> shiftId;
  final Value<String> employeeId;
  final Value<String> tenantId;
  final Value<DateTime?> bookOnTime;
  final Value<double?> bookOnLatitude;
  final Value<double?> bookOnLongitude;
  final Value<String?> bookOnMethod;
  final Value<DateTime?> bookOffTime;
  final Value<double?> bookOffLatitude;
  final Value<double?> bookOffLongitude;
  final Value<String?> bookOffMethod;
  final Value<String> status;
  final Value<double?> totalHours;
  final Value<bool> isLate;
  final Value<int?> lateMinutes;
  final Value<bool> autoBookedOff;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const AttendancesCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.bookOnTime = const Value.absent(),
    this.bookOnLatitude = const Value.absent(),
    this.bookOnLongitude = const Value.absent(),
    this.bookOnMethod = const Value.absent(),
    this.bookOffTime = const Value.absent(),
    this.bookOffLatitude = const Value.absent(),
    this.bookOffLongitude = const Value.absent(),
    this.bookOffMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.isLate = const Value.absent(),
    this.lateMinutes = const Value.absent(),
    this.autoBookedOff = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendancesCompanion.insert({
    required String id,
    required String shiftId,
    required String employeeId,
    required String tenantId,
    this.bookOnTime = const Value.absent(),
    this.bookOnLatitude = const Value.absent(),
    this.bookOnLongitude = const Value.absent(),
    this.bookOnMethod = const Value.absent(),
    this.bookOffTime = const Value.absent(),
    this.bookOffLatitude = const Value.absent(),
    this.bookOffLongitude = const Value.absent(),
    this.bookOffMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.isLate = const Value.absent(),
    this.lateMinutes = const Value.absent(),
    this.autoBookedOff = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shiftId = Value(shiftId),
       employeeId = Value(employeeId),
       tenantId = Value(tenantId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Attendance> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<String>? employeeId,
    Expression<String>? tenantId,
    Expression<DateTime>? bookOnTime,
    Expression<double>? bookOnLatitude,
    Expression<double>? bookOnLongitude,
    Expression<String>? bookOnMethod,
    Expression<DateTime>? bookOffTime,
    Expression<double>? bookOffLatitude,
    Expression<double>? bookOffLongitude,
    Expression<String>? bookOffMethod,
    Expression<String>? status,
    Expression<double>? totalHours,
    Expression<bool>? isLate,
    Expression<int>? lateMinutes,
    Expression<bool>? autoBookedOff,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (employeeId != null) 'employee_id': employeeId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (bookOnTime != null) 'book_on_time': bookOnTime,
      if (bookOnLatitude != null) 'book_on_latitude': bookOnLatitude,
      if (bookOnLongitude != null) 'book_on_longitude': bookOnLongitude,
      if (bookOnMethod != null) 'book_on_method': bookOnMethod,
      if (bookOffTime != null) 'book_off_time': bookOffTime,
      if (bookOffLatitude != null) 'book_off_latitude': bookOffLatitude,
      if (bookOffLongitude != null) 'book_off_longitude': bookOffLongitude,
      if (bookOffMethod != null) 'book_off_method': bookOffMethod,
      if (status != null) 'status': status,
      if (totalHours != null) 'total_hours': totalHours,
      if (isLate != null) 'is_late': isLate,
      if (lateMinutes != null) 'late_minutes': lateMinutes,
      if (autoBookedOff != null) 'auto_booked_off': autoBookedOff,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendancesCompanion copyWith({
    Value<String>? id,
    Value<String>? shiftId,
    Value<String>? employeeId,
    Value<String>? tenantId,
    Value<DateTime?>? bookOnTime,
    Value<double?>? bookOnLatitude,
    Value<double?>? bookOnLongitude,
    Value<String?>? bookOnMethod,
    Value<DateTime?>? bookOffTime,
    Value<double?>? bookOffLatitude,
    Value<double?>? bookOffLongitude,
    Value<String?>? bookOffMethod,
    Value<String>? status,
    Value<double?>? totalHours,
    Value<bool>? isLate,
    Value<int?>? lateMinutes,
    Value<bool>? autoBookedOff,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return AttendancesCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      employeeId: employeeId ?? this.employeeId,
      tenantId: tenantId ?? this.tenantId,
      bookOnTime: bookOnTime ?? this.bookOnTime,
      bookOnLatitude: bookOnLatitude ?? this.bookOnLatitude,
      bookOnLongitude: bookOnLongitude ?? this.bookOnLongitude,
      bookOnMethod: bookOnMethod ?? this.bookOnMethod,
      bookOffTime: bookOffTime ?? this.bookOffTime,
      bookOffLatitude: bookOffLatitude ?? this.bookOffLatitude,
      bookOffLongitude: bookOffLongitude ?? this.bookOffLongitude,
      bookOffMethod: bookOffMethod ?? this.bookOffMethod,
      status: status ?? this.status,
      totalHours: totalHours ?? this.totalHours,
      isLate: isLate ?? this.isLate,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      autoBookedOff: autoBookedOff ?? this.autoBookedOff,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (bookOnTime.present) {
      map['book_on_time'] = Variable<DateTime>(bookOnTime.value);
    }
    if (bookOnLatitude.present) {
      map['book_on_latitude'] = Variable<double>(bookOnLatitude.value);
    }
    if (bookOnLongitude.present) {
      map['book_on_longitude'] = Variable<double>(bookOnLongitude.value);
    }
    if (bookOnMethod.present) {
      map['book_on_method'] = Variable<String>(bookOnMethod.value);
    }
    if (bookOffTime.present) {
      map['book_off_time'] = Variable<DateTime>(bookOffTime.value);
    }
    if (bookOffLatitude.present) {
      map['book_off_latitude'] = Variable<double>(bookOffLatitude.value);
    }
    if (bookOffLongitude.present) {
      map['book_off_longitude'] = Variable<double>(bookOffLongitude.value);
    }
    if (bookOffMethod.present) {
      map['book_off_method'] = Variable<String>(bookOffMethod.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalHours.present) {
      map['total_hours'] = Variable<double>(totalHours.value);
    }
    if (isLate.present) {
      map['is_late'] = Variable<bool>(isLate.value);
    }
    if (lateMinutes.present) {
      map['late_minutes'] = Variable<int>(lateMinutes.value);
    }
    if (autoBookedOff.present) {
      map['auto_booked_off'] = Variable<bool>(autoBookedOff.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('tenantId: $tenantId, ')
          ..write('bookOnTime: $bookOnTime, ')
          ..write('bookOnLatitude: $bookOnLatitude, ')
          ..write('bookOnLongitude: $bookOnLongitude, ')
          ..write('bookOnMethod: $bookOnMethod, ')
          ..write('bookOffTime: $bookOffTime, ')
          ..write('bookOffLatitude: $bookOffLatitude, ')
          ..write('bookOffLongitude: $bookOffLongitude, ')
          ..write('bookOffMethod: $bookOffMethod, ')
          ..write('status: $status, ')
          ..write('totalHours: $totalHours, ')
          ..write('isLate: $isLate, ')
          ..write('lateMinutes: $lateMinutes, ')
          ..write('autoBookedOff: $autoBookedOff, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationLogsTable extends LocationLogs
    with TableInfo<$LocationLogsTable, LocationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    shiftId,
    tenantId,
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    timestamp,
    syncedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'location_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      ),
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      ),
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $LocationLogsTable createAlias(String alias) {
    return $LocationLogsTable(attachedDatabase, alias);
  }
}

class LocationLog extends DataClass implements Insertable<LocationLog> {
  final String id;
  final String employeeId;
  final String? shiftId;
  final String tenantId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final DateTime timestamp;
  final DateTime? syncedAt;
  final bool needsSync;
  const LocationLog({
    required this.id,
    required this.employeeId,
    this.shiftId,
    required this.tenantId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    required this.timestamp,
    this.syncedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<String>(shiftId);
    }
    map['tenant_id'] = Variable<String>(tenantId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<double>(speed);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  LocationLogsCompanion toCompanion(bool nullToAbsent) {
    return LocationLogsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      tenantId: Value(tenantId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      speed: speed == null && nullToAbsent
          ? const Value.absent()
          : Value(speed),
      timestamp: Value(timestamp),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      needsSync: Value(needsSync),
    );
  }

  factory LocationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationLog(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      shiftId: serializer.fromJson<String?>(json['shiftId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      speed: serializer.fromJson<double?>(json['speed']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'shiftId': serializer.toJson<String?>(shiftId),
      'tenantId': serializer.toJson<String>(tenantId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracy': serializer.toJson<double?>(accuracy),
      'altitude': serializer.toJson<double?>(altitude),
      'speed': serializer.toJson<double?>(speed),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  LocationLog copyWith({
    String? id,
    String? employeeId,
    Value<String?> shiftId = const Value.absent(),
    String? tenantId,
    double? latitude,
    double? longitude,
    Value<double?> accuracy = const Value.absent(),
    Value<double?> altitude = const Value.absent(),
    Value<double?> speed = const Value.absent(),
    DateTime? timestamp,
    Value<DateTime?> syncedAt = const Value.absent(),
    bool? needsSync,
  }) => LocationLog(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    tenantId: tenantId ?? this.tenantId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    altitude: altitude.present ? altitude.value : this.altitude,
    speed: speed.present ? speed.value : this.speed,
    timestamp: timestamp ?? this.timestamp,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  LocationLog copyWithCompanion(LocationLogsCompanion data) {
    return LocationLog(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      speed: data.speed.present ? data.speed.value : this.speed,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationLog(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('tenantId: $tenantId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('speed: $speed, ')
          ..write('timestamp: $timestamp, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    shiftId,
    tenantId,
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    timestamp,
    syncedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationLog &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.shiftId == this.shiftId &&
          other.tenantId == this.tenantId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.altitude == this.altitude &&
          other.speed == this.speed &&
          other.timestamp == this.timestamp &&
          other.syncedAt == this.syncedAt &&
          other.needsSync == this.needsSync);
}

class LocationLogsCompanion extends UpdateCompanion<LocationLog> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String?> shiftId;
  final Value<String> tenantId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> accuracy;
  final Value<double?> altitude;
  final Value<double?> speed;
  final Value<DateTime> timestamp;
  final Value<DateTime?> syncedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const LocationLogsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationLogsCompanion.insert({
    required String id,
    required String employeeId,
    this.shiftId = const Value.absent(),
    required String tenantId,
    required double latitude,
    required double longitude,
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.speed = const Value.absent(),
    required DateTime timestamp,
    this.syncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       tenantId = Value(tenantId),
       latitude = Value(latitude),
       longitude = Value(longitude),
       timestamp = Value(timestamp);
  static Insertable<LocationLog> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? shiftId,
    Expression<String>? tenantId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<double>? altitude,
    Expression<double>? speed,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? syncedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (shiftId != null) 'shift_id': shiftId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (altitude != null) 'altitude': altitude,
      if (speed != null) 'speed': speed,
      if (timestamp != null) 'timestamp': timestamp,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? employeeId,
    Value<String?>? shiftId,
    Value<String>? tenantId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? accuracy,
    Value<double?>? altitude,
    Value<double?>? speed,
    Value<DateTime>? timestamp,
    Value<DateTime?>? syncedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return LocationLogsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      shiftId: shiftId ?? this.shiftId,
      tenantId: tenantId ?? this.tenantId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
      syncedAt: syncedAt ?? this.syncedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationLogsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('tenantId: $tenantId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('speed: $speed, ')
          ..write('timestamp: $timestamp, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckCallsTable extends CheckCalls
    with TableInfo<$CheckCallsTable, CheckCall> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckCallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledTime =
      GeneratedColumn<DateTime>(
        'scheduled_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _respondedAtMeta = const VerificationMeta(
    'respondedAt',
  );
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
    'responded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    employeeId,
    tenantId,
    scheduledTime,
    respondedAt,
    latitude,
    longitude,
    status,
    notes,
    createdAt,
    syncedAt,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckCall> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('responded_at')) {
      context.handle(
        _respondedAtMeta,
        respondedAt.isAcceptableOrUnknown(
          data['responded_at']!,
          _respondedAtMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckCall map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckCall(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_time'],
      )!,
      respondedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}responded_at'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
    );
  }

  @override
  $CheckCallsTable createAlias(String alias) {
    return $CheckCallsTable(attachedDatabase, alias);
  }
}

class CheckCall extends DataClass implements Insertable<CheckCall> {
  final String id;
  final String shiftId;
  final String employeeId;
  final String tenantId;
  final DateTime scheduledTime;
  final DateTime? respondedAt;
  final double? latitude;
  final double? longitude;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final bool needsSync;
  const CheckCall({
    required this.id,
    required this.shiftId,
    required this.employeeId,
    required this.tenantId,
    required this.scheduledTime,
    this.respondedAt,
    this.latitude,
    this.longitude,
    required this.status,
    this.notes,
    required this.createdAt,
    this.syncedAt,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift_id'] = Variable<String>(shiftId);
    map['employee_id'] = Variable<String>(employeeId);
    map['tenant_id'] = Variable<String>(tenantId);
    map['scheduled_time'] = Variable<DateTime>(scheduledTime);
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  CheckCallsCompanion toCompanion(bool nullToAbsent) {
    return CheckCallsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      employeeId: Value(employeeId),
      tenantId: Value(tenantId),
      scheduledTime: Value(scheduledTime),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      needsSync: Value(needsSync),
    );
  }

  factory CheckCall.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckCall(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      scheduledTime: serializer.fromJson<DateTime>(json['scheduledTime']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String>(shiftId),
      'employeeId': serializer.toJson<String>(employeeId),
      'tenantId': serializer.toJson<String>(tenantId),
      'scheduledTime': serializer.toJson<DateTime>(scheduledTime),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  CheckCall copyWith({
    String? id,
    String? shiftId,
    String? employeeId,
    String? tenantId,
    DateTime? scheduledTime,
    Value<DateTime?> respondedAt = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
    bool? needsSync,
  }) => CheckCall(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    employeeId: employeeId ?? this.employeeId,
    tenantId: tenantId ?? this.tenantId,
    scheduledTime: scheduledTime ?? this.scheduledTime,
    respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    needsSync: needsSync ?? this.needsSync,
  );
  CheckCall copyWithCompanion(CheckCallsCompanion data) {
    return CheckCall(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      respondedAt: data.respondedAt.present
          ? data.respondedAt.value
          : this.respondedAt,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckCall(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('tenantId: $tenantId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shiftId,
    employeeId,
    tenantId,
    scheduledTime,
    respondedAt,
    latitude,
    longitude,
    status,
    notes,
    createdAt,
    syncedAt,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckCall &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.employeeId == this.employeeId &&
          other.tenantId == this.tenantId &&
          other.scheduledTime == this.scheduledTime &&
          other.respondedAt == this.respondedAt &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt &&
          other.needsSync == this.needsSync);
}

class CheckCallsCompanion extends UpdateCompanion<CheckCall> {
  final Value<String> id;
  final Value<String> shiftId;
  final Value<String> employeeId;
  final Value<String> tenantId;
  final Value<DateTime> scheduledTime;
  final Value<DateTime?> respondedAt;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> needsSync;
  final Value<int> rowid;
  const CheckCallsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckCallsCompanion.insert({
    required String id,
    required String shiftId,
    required String employeeId,
    required String tenantId,
    required DateTime scheduledTime,
    this.respondedAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shiftId = Value(shiftId),
       employeeId = Value(employeeId),
       tenantId = Value(tenantId),
       scheduledTime = Value(scheduledTime),
       createdAt = Value(createdAt);
  static Insertable<CheckCall> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<String>? employeeId,
    Expression<String>? tenantId,
    Expression<DateTime>? scheduledTime,
    Expression<DateTime>? respondedAt,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? needsSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (employeeId != null) 'employee_id': employeeId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (respondedAt != null) 'responded_at': respondedAt,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckCallsCompanion copyWith({
    Value<String>? id,
    Value<String>? shiftId,
    Value<String>? employeeId,
    Value<String>? tenantId,
    Value<DateTime>? scheduledTime,
    Value<DateTime?>? respondedAt,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<bool>? needsSync,
    Value<int>? rowid,
  }) {
    return CheckCallsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      employeeId: employeeId ?? this.employeeId,
      tenantId: tenantId ?? this.tenantId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      respondedAt: respondedAt ?? this.respondedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      needsSync: needsSync ?? this.needsSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<DateTime>(scheduledTime.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckCallsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('tenantId: $tenantId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endpointMeta = const VerificationMeta(
    'endpoint',
  );
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
    'endpoint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxRetriesMeta = const VerificationMeta(
    'maxRetries',
  );
  @override
  late final GeneratedColumn<int> maxRetries = GeneratedColumn<int>(
    'max_retries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    endpoint,
    method,
    payload,
    priority,
    retryCount,
    maxRetries,
    status,
    errorMessage,
    entityType,
    entityId,
    createdAt,
    lastAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(
        _endpointMeta,
        endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta),
      );
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('max_retries')) {
      context.handle(
        _maxRetriesMeta,
        maxRetries.isAcceptableOrUnknown(data['max_retries']!, _maxRetriesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      endpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endpoint'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      maxRetries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_retries'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String operation;
  final String endpoint;
  final String method;
  final String payload;

  /// Priority level for sync order (higher = synced first)
  /// 0 = normal, 1 = high (check calls), 2 = critical (panic alerts)
  final int priority;
  final int retryCount;
  final int maxRetries;
  final String status;
  final String? errorMessage;

  /// Entity type for conflict resolution (e.g., 'attendance', 'check_call', 'incident')
  final String? entityType;

  /// Entity ID for conflict resolution
  final String? entityId;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  const SyncQueueData({
    required this.id,
    required this.operation,
    required this.endpoint,
    required this.method,
    required this.payload,
    required this.priority,
    required this.retryCount,
    required this.maxRetries,
    required this.status,
    this.errorMessage,
    this.entityType,
    this.entityId,
    required this.createdAt,
    this.lastAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation'] = Variable<String>(operation);
    map['endpoint'] = Variable<String>(endpoint);
    map['method'] = Variable<String>(method);
    map['payload'] = Variable<String>(payload);
    map['priority'] = Variable<int>(priority);
    map['retry_count'] = Variable<int>(retryCount);
    map['max_retries'] = Variable<int>(maxRetries);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      endpoint: Value(endpoint),
      method: Value(method),
      payload: Value(payload),
      priority: Value(priority),
      retryCount: Value(retryCount),
      maxRetries: Value(maxRetries),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      method: serializer.fromJson<String>(json['method']),
      payload: serializer.fromJson<String>(json['payload']),
      priority: serializer.fromJson<int>(json['priority']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      maxRetries: serializer.fromJson<int>(json['maxRetries']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operation': serializer.toJson<String>(operation),
      'endpoint': serializer.toJson<String>(endpoint),
      'method': serializer.toJson<String>(method),
      'payload': serializer.toJson<String>(payload),
      'priority': serializer.toJson<int>(priority),
      'retryCount': serializer.toJson<int>(retryCount),
      'maxRetries': serializer.toJson<int>(maxRetries),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? operation,
    String? endpoint,
    String? method,
    String? payload,
    int? priority,
    int? retryCount,
    int? maxRetries,
    String? status,
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> entityType = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    endpoint: endpoint ?? this.endpoint,
    method: method ?? this.method,
    payload: payload ?? this.payload,
    priority: priority ?? this.priority,
    retryCount: retryCount ?? this.retryCount,
    maxRetries: maxRetries ?? this.maxRetries,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    createdAt: createdAt ?? this.createdAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      method: data.method.present ? data.method.value : this.method,
      payload: data.payload.present ? data.payload.value : this.payload,
      priority: data.priority.present ? data.priority.value : this.priority,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      maxRetries: data.maxRetries.present
          ? data.maxRetries.value
          : this.maxRetries,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('endpoint: $endpoint, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operation,
    endpoint,
    method,
    payload,
    priority,
    retryCount,
    maxRetries,
    status,
    errorMessage,
    entityType,
    entityId,
    createdAt,
    lastAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.endpoint == this.endpoint &&
          other.method == this.method &&
          other.payload == this.payload &&
          other.priority == this.priority &&
          other.retryCount == this.retryCount &&
          other.maxRetries == this.maxRetries &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> operation;
  final Value<String> endpoint;
  final Value<String> method;
  final Value<String> payload;
  final Value<int> priority;
  final Value<int> retryCount;
  final Value<int> maxRetries;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.method = const Value.absent(),
    this.payload = const Value.absent(),
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String operation,
    required String endpoint,
    required String method,
    required String payload,
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    required DateTime createdAt,
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operation = Value(operation),
       endpoint = Value(endpoint),
       method = Value(method),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? operation,
    Expression<String>? endpoint,
    Expression<String>? method,
    Expression<String>? payload,
    Expression<int>? priority,
    Expression<int>? retryCount,
    Expression<int>? maxRetries,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (payload != null) 'payload': payload,
      if (priority != null) 'priority': priority,
      if (retryCount != null) 'retry_count': retryCount,
      if (maxRetries != null) 'max_retries': maxRetries,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? operation,
    Value<String>? endpoint,
    Value<String>? method,
    Value<String>? payload,
    Value<int>? priority,
    Value<int>? retryCount,
    Value<int>? maxRetries,
    Value<String>? status,
    Value<String?>? errorMessage,
    Value<String?>? entityType,
    Value<String?>? entityId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastAttemptAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      payload: payload ?? this.payload,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (maxRetries.present) {
      map['max_retries'] = Variable<int>(maxRetries.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('endpoint: $endpoint, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncidentReportsTable extends IncidentReports
    with TableInfo<$IncidentReportsTable, IncidentReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidentReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incidentDateMeta = const VerificationMeta(
    'incidentDate',
  );
  @override
  late final GeneratedColumn<DateTime> incidentDate = GeneratedColumn<DateTime>(
    'incident_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportTimeMeta = const VerificationMeta(
    'reportTime',
  );
  @override
  late final GeneratedColumn<DateTime> reportTime = GeneratedColumn<DateTime>(
    'report_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incidentTypeMeta = const VerificationMeta(
    'incidentType',
  );
  @override
  late final GeneratedColumn<String> incidentType = GeneratedColumn<String>(
    'incident_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionTakenMeta = const VerificationMeta(
    'actionTaken',
  );
  @override
  late final GeneratedColumn<String> actionTaken = GeneratedColumn<String>(
    'action_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _policeNotifiedMeta = const VerificationMeta(
    'policeNotified',
  );
  @override
  late final GeneratedColumn<bool> policeNotified = GeneratedColumn<bool>(
    'police_notified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("police_notified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _policeRefMeta = const VerificationMeta(
    'policeRef',
  );
  @override
  late final GeneratedColumn<String> policeRef = GeneratedColumn<String>(
    'police_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaFilePathsMeta = const VerificationMeta(
    'mediaFilePaths',
  );
  @override
  late final GeneratedColumn<String> mediaFilePaths = GeneratedColumn<String>(
    'media_file_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaUrlsMeta = const VerificationMeta(
    'mediaUrls',
  );
  @override
  late final GeneratedColumn<String> mediaUrls = GeneratedColumn<String>(
    'media_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    shiftId,
    siteId,
    employeeId,
    tenantId,
    title,
    incidentDate,
    reportTime,
    latitude,
    longitude,
    location,
    incidentType,
    description,
    severity,
    actionTaken,
    policeNotified,
    policeRef,
    mediaFilePaths,
    mediaUrls,
    needsSync,
    syncedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incident_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncidentReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('incident_date')) {
      context.handle(
        _incidentDateMeta,
        incidentDate.isAcceptableOrUnknown(
          data['incident_date']!,
          _incidentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incidentDateMeta);
    }
    if (data.containsKey('report_time')) {
      context.handle(
        _reportTimeMeta,
        reportTime.isAcceptableOrUnknown(data['report_time']!, _reportTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_reportTimeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('incident_type')) {
      context.handle(
        _incidentTypeMeta,
        incidentType.isAcceptableOrUnknown(
          data['incident_type']!,
          _incidentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incidentTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('action_taken')) {
      context.handle(
        _actionTakenMeta,
        actionTaken.isAcceptableOrUnknown(
          data['action_taken']!,
          _actionTakenMeta,
        ),
      );
    }
    if (data.containsKey('police_notified')) {
      context.handle(
        _policeNotifiedMeta,
        policeNotified.isAcceptableOrUnknown(
          data['police_notified']!,
          _policeNotifiedMeta,
        ),
      );
    }
    if (data.containsKey('police_ref')) {
      context.handle(
        _policeRefMeta,
        policeRef.isAcceptableOrUnknown(data['police_ref']!, _policeRefMeta),
      );
    }
    if (data.containsKey('media_file_paths')) {
      context.handle(
        _mediaFilePathsMeta,
        mediaFilePaths.isAcceptableOrUnknown(
          data['media_file_paths']!,
          _mediaFilePathsMeta,
        ),
      );
    }
    if (data.containsKey('media_urls')) {
      context.handle(
        _mediaUrlsMeta,
        mediaUrls.isAcceptableOrUnknown(data['media_urls']!, _mediaUrlsMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncidentReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncidentReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      incidentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}incident_date'],
      )!,
      reportTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}report_time'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      incidentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}incident_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      actionTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_taken'],
      ),
      policeNotified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}police_notified'],
      )!,
      policeRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}police_ref'],
      ),
      mediaFilePaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_file_paths'],
      ),
      mediaUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_urls'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IncidentReportsTable createAlias(String alias) {
    return $IncidentReportsTable(attachedDatabase, alias);
  }
}

class IncidentReport extends DataClass implements Insertable<IncidentReport> {
  final String id;
  final String? serverId;
  final String shiftId;
  final String siteId;
  final String employeeId;
  final String tenantId;
  final String title;
  final DateTime incidentDate;
  final DateTime reportTime;
  final double latitude;
  final double longitude;
  final String? location;
  final String incidentType;
  final String description;
  final String severity;
  final String? actionTaken;
  final bool policeNotified;
  final String? policeRef;
  final String? mediaFilePaths;
  final String? mediaUrls;
  final bool needsSync;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IncidentReport({
    required this.id,
    this.serverId,
    required this.shiftId,
    required this.siteId,
    required this.employeeId,
    required this.tenantId,
    required this.title,
    required this.incidentDate,
    required this.reportTime,
    required this.latitude,
    required this.longitude,
    this.location,
    required this.incidentType,
    required this.description,
    required this.severity,
    this.actionTaken,
    required this.policeNotified,
    this.policeRef,
    this.mediaFilePaths,
    this.mediaUrls,
    required this.needsSync,
    this.syncedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['shift_id'] = Variable<String>(shiftId);
    map['site_id'] = Variable<String>(siteId);
    map['employee_id'] = Variable<String>(employeeId);
    map['tenant_id'] = Variable<String>(tenantId);
    map['title'] = Variable<String>(title);
    map['incident_date'] = Variable<DateTime>(incidentDate);
    map['report_time'] = Variable<DateTime>(reportTime);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['incident_type'] = Variable<String>(incidentType);
    map['description'] = Variable<String>(description);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || actionTaken != null) {
      map['action_taken'] = Variable<String>(actionTaken);
    }
    map['police_notified'] = Variable<bool>(policeNotified);
    if (!nullToAbsent || policeRef != null) {
      map['police_ref'] = Variable<String>(policeRef);
    }
    if (!nullToAbsent || mediaFilePaths != null) {
      map['media_file_paths'] = Variable<String>(mediaFilePaths);
    }
    if (!nullToAbsent || mediaUrls != null) {
      map['media_urls'] = Variable<String>(mediaUrls);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IncidentReportsCompanion toCompanion(bool nullToAbsent) {
    return IncidentReportsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      shiftId: Value(shiftId),
      siteId: Value(siteId),
      employeeId: Value(employeeId),
      tenantId: Value(tenantId),
      title: Value(title),
      incidentDate: Value(incidentDate),
      reportTime: Value(reportTime),
      latitude: Value(latitude),
      longitude: Value(longitude),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      incidentType: Value(incidentType),
      description: Value(description),
      severity: Value(severity),
      actionTaken: actionTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(actionTaken),
      policeNotified: Value(policeNotified),
      policeRef: policeRef == null && nullToAbsent
          ? const Value.absent()
          : Value(policeRef),
      mediaFilePaths: mediaFilePaths == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaFilePaths),
      mediaUrls: mediaUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrls),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IncidentReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncidentReport(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      title: serializer.fromJson<String>(json['title']),
      incidentDate: serializer.fromJson<DateTime>(json['incidentDate']),
      reportTime: serializer.fromJson<DateTime>(json['reportTime']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      location: serializer.fromJson<String?>(json['location']),
      incidentType: serializer.fromJson<String>(json['incidentType']),
      description: serializer.fromJson<String>(json['description']),
      severity: serializer.fromJson<String>(json['severity']),
      actionTaken: serializer.fromJson<String?>(json['actionTaken']),
      policeNotified: serializer.fromJson<bool>(json['policeNotified']),
      policeRef: serializer.fromJson<String?>(json['policeRef']),
      mediaFilePaths: serializer.fromJson<String?>(json['mediaFilePaths']),
      mediaUrls: serializer.fromJson<String?>(json['mediaUrls']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'shiftId': serializer.toJson<String>(shiftId),
      'siteId': serializer.toJson<String>(siteId),
      'employeeId': serializer.toJson<String>(employeeId),
      'tenantId': serializer.toJson<String>(tenantId),
      'title': serializer.toJson<String>(title),
      'incidentDate': serializer.toJson<DateTime>(incidentDate),
      'reportTime': serializer.toJson<DateTime>(reportTime),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'location': serializer.toJson<String?>(location),
      'incidentType': serializer.toJson<String>(incidentType),
      'description': serializer.toJson<String>(description),
      'severity': serializer.toJson<String>(severity),
      'actionTaken': serializer.toJson<String?>(actionTaken),
      'policeNotified': serializer.toJson<bool>(policeNotified),
      'policeRef': serializer.toJson<String?>(policeRef),
      'mediaFilePaths': serializer.toJson<String?>(mediaFilePaths),
      'mediaUrls': serializer.toJson<String?>(mediaUrls),
      'needsSync': serializer.toJson<bool>(needsSync),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IncidentReport copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? shiftId,
    String? siteId,
    String? employeeId,
    String? tenantId,
    String? title,
    DateTime? incidentDate,
    DateTime? reportTime,
    double? latitude,
    double? longitude,
    Value<String?> location = const Value.absent(),
    String? incidentType,
    String? description,
    String? severity,
    Value<String?> actionTaken = const Value.absent(),
    bool? policeNotified,
    Value<String?> policeRef = const Value.absent(),
    Value<String?> mediaFilePaths = const Value.absent(),
    Value<String?> mediaUrls = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> syncedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IncidentReport(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    shiftId: shiftId ?? this.shiftId,
    siteId: siteId ?? this.siteId,
    employeeId: employeeId ?? this.employeeId,
    tenantId: tenantId ?? this.tenantId,
    title: title ?? this.title,
    incidentDate: incidentDate ?? this.incidentDate,
    reportTime: reportTime ?? this.reportTime,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    location: location.present ? location.value : this.location,
    incidentType: incidentType ?? this.incidentType,
    description: description ?? this.description,
    severity: severity ?? this.severity,
    actionTaken: actionTaken.present ? actionTaken.value : this.actionTaken,
    policeNotified: policeNotified ?? this.policeNotified,
    policeRef: policeRef.present ? policeRef.value : this.policeRef,
    mediaFilePaths: mediaFilePaths.present
        ? mediaFilePaths.value
        : this.mediaFilePaths,
    mediaUrls: mediaUrls.present ? mediaUrls.value : this.mediaUrls,
    needsSync: needsSync ?? this.needsSync,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IncidentReport copyWithCompanion(IncidentReportsCompanion data) {
    return IncidentReport(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      title: data.title.present ? data.title.value : this.title,
      incidentDate: data.incidentDate.present
          ? data.incidentDate.value
          : this.incidentDate,
      reportTime: data.reportTime.present
          ? data.reportTime.value
          : this.reportTime,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      location: data.location.present ? data.location.value : this.location,
      incidentType: data.incidentType.present
          ? data.incidentType.value
          : this.incidentType,
      description: data.description.present
          ? data.description.value
          : this.description,
      severity: data.severity.present ? data.severity.value : this.severity,
      actionTaken: data.actionTaken.present
          ? data.actionTaken.value
          : this.actionTaken,
      policeNotified: data.policeNotified.present
          ? data.policeNotified.value
          : this.policeNotified,
      policeRef: data.policeRef.present ? data.policeRef.value : this.policeRef,
      mediaFilePaths: data.mediaFilePaths.present
          ? data.mediaFilePaths.value
          : this.mediaFilePaths,
      mediaUrls: data.mediaUrls.present ? data.mediaUrls.value : this.mediaUrls,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncidentReport(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('shiftId: $shiftId, ')
          ..write('siteId: $siteId, ')
          ..write('employeeId: $employeeId, ')
          ..write('tenantId: $tenantId, ')
          ..write('title: $title, ')
          ..write('incidentDate: $incidentDate, ')
          ..write('reportTime: $reportTime, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('location: $location, ')
          ..write('incidentType: $incidentType, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('policeNotified: $policeNotified, ')
          ..write('policeRef: $policeRef, ')
          ..write('mediaFilePaths: $mediaFilePaths, ')
          ..write('mediaUrls: $mediaUrls, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    shiftId,
    siteId,
    employeeId,
    tenantId,
    title,
    incidentDate,
    reportTime,
    latitude,
    longitude,
    location,
    incidentType,
    description,
    severity,
    actionTaken,
    policeNotified,
    policeRef,
    mediaFilePaths,
    mediaUrls,
    needsSync,
    syncedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncidentReport &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.shiftId == this.shiftId &&
          other.siteId == this.siteId &&
          other.employeeId == this.employeeId &&
          other.tenantId == this.tenantId &&
          other.title == this.title &&
          other.incidentDate == this.incidentDate &&
          other.reportTime == this.reportTime &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.location == this.location &&
          other.incidentType == this.incidentType &&
          other.description == this.description &&
          other.severity == this.severity &&
          other.actionTaken == this.actionTaken &&
          other.policeNotified == this.policeNotified &&
          other.policeRef == this.policeRef &&
          other.mediaFilePaths == this.mediaFilePaths &&
          other.mediaUrls == this.mediaUrls &&
          other.needsSync == this.needsSync &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IncidentReportsCompanion extends UpdateCompanion<IncidentReport> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> shiftId;
  final Value<String> siteId;
  final Value<String> employeeId;
  final Value<String> tenantId;
  final Value<String> title;
  final Value<DateTime> incidentDate;
  final Value<DateTime> reportTime;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> location;
  final Value<String> incidentType;
  final Value<String> description;
  final Value<String> severity;
  final Value<String?> actionTaken;
  final Value<bool> policeNotified;
  final Value<String?> policeRef;
  final Value<String?> mediaFilePaths;
  final Value<String?> mediaUrls;
  final Value<bool> needsSync;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IncidentReportsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.title = const Value.absent(),
    this.incidentDate = const Value.absent(),
    this.reportTime = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.location = const Value.absent(),
    this.incidentType = const Value.absent(),
    this.description = const Value.absent(),
    this.severity = const Value.absent(),
    this.actionTaken = const Value.absent(),
    this.policeNotified = const Value.absent(),
    this.policeRef = const Value.absent(),
    this.mediaFilePaths = const Value.absent(),
    this.mediaUrls = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncidentReportsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String shiftId,
    required String siteId,
    required String employeeId,
    required String tenantId,
    required String title,
    required DateTime incidentDate,
    required DateTime reportTime,
    required double latitude,
    required double longitude,
    this.location = const Value.absent(),
    required String incidentType,
    required String description,
    required String severity,
    this.actionTaken = const Value.absent(),
    this.policeNotified = const Value.absent(),
    this.policeRef = const Value.absent(),
    this.mediaFilePaths = const Value.absent(),
    this.mediaUrls = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shiftId = Value(shiftId),
       siteId = Value(siteId),
       employeeId = Value(employeeId),
       tenantId = Value(tenantId),
       title = Value(title),
       incidentDate = Value(incidentDate),
       reportTime = Value(reportTime),
       latitude = Value(latitude),
       longitude = Value(longitude),
       incidentType = Value(incidentType),
       description = Value(description),
       severity = Value(severity);
  static Insertable<IncidentReport> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? shiftId,
    Expression<String>? siteId,
    Expression<String>? employeeId,
    Expression<String>? tenantId,
    Expression<String>? title,
    Expression<DateTime>? incidentDate,
    Expression<DateTime>? reportTime,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? location,
    Expression<String>? incidentType,
    Expression<String>? description,
    Expression<String>? severity,
    Expression<String>? actionTaken,
    Expression<bool>? policeNotified,
    Expression<String>? policeRef,
    Expression<String>? mediaFilePaths,
    Expression<String>? mediaUrls,
    Expression<bool>? needsSync,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (shiftId != null) 'shift_id': shiftId,
      if (siteId != null) 'site_id': siteId,
      if (employeeId != null) 'employee_id': employeeId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (title != null) 'title': title,
      if (incidentDate != null) 'incident_date': incidentDate,
      if (reportTime != null) 'report_time': reportTime,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (location != null) 'location': location,
      if (incidentType != null) 'incident_type': incidentType,
      if (description != null) 'description': description,
      if (severity != null) 'severity': severity,
      if (actionTaken != null) 'action_taken': actionTaken,
      if (policeNotified != null) 'police_notified': policeNotified,
      if (policeRef != null) 'police_ref': policeRef,
      if (mediaFilePaths != null) 'media_file_paths': mediaFilePaths,
      if (mediaUrls != null) 'media_urls': mediaUrls,
      if (needsSync != null) 'needs_sync': needsSync,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncidentReportsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? shiftId,
    Value<String>? siteId,
    Value<String>? employeeId,
    Value<String>? tenantId,
    Value<String>? title,
    Value<DateTime>? incidentDate,
    Value<DateTime>? reportTime,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? location,
    Value<String>? incidentType,
    Value<String>? description,
    Value<String>? severity,
    Value<String?>? actionTaken,
    Value<bool>? policeNotified,
    Value<String?>? policeRef,
    Value<String?>? mediaFilePaths,
    Value<String?>? mediaUrls,
    Value<bool>? needsSync,
    Value<DateTime?>? syncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return IncidentReportsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      shiftId: shiftId ?? this.shiftId,
      siteId: siteId ?? this.siteId,
      employeeId: employeeId ?? this.employeeId,
      tenantId: tenantId ?? this.tenantId,
      title: title ?? this.title,
      incidentDate: incidentDate ?? this.incidentDate,
      reportTime: reportTime ?? this.reportTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      incidentType: incidentType ?? this.incidentType,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      actionTaken: actionTaken ?? this.actionTaken,
      policeNotified: policeNotified ?? this.policeNotified,
      policeRef: policeRef ?? this.policeRef,
      mediaFilePaths: mediaFilePaths ?? this.mediaFilePaths,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      needsSync: needsSync ?? this.needsSync,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (incidentDate.present) {
      map['incident_date'] = Variable<DateTime>(incidentDate.value);
    }
    if (reportTime.present) {
      map['report_time'] = Variable<DateTime>(reportTime.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (incidentType.present) {
      map['incident_type'] = Variable<String>(incidentType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (actionTaken.present) {
      map['action_taken'] = Variable<String>(actionTaken.value);
    }
    if (policeNotified.present) {
      map['police_notified'] = Variable<bool>(policeNotified.value);
    }
    if (policeRef.present) {
      map['police_ref'] = Variable<String>(policeRef.value);
    }
    if (mediaFilePaths.present) {
      map['media_file_paths'] = Variable<String>(mediaFilePaths.value);
    }
    if (mediaUrls.present) {
      map['media_urls'] = Variable<String>(mediaUrls.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentReportsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('shiftId: $shiftId, ')
          ..write('siteId: $siteId, ')
          ..write('employeeId: $employeeId, ')
          ..write('tenantId: $tenantId, ')
          ..write('title: $title, ')
          ..write('incidentDate: $incidentDate, ')
          ..write('reportTime: $reportTime, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('location: $location, ')
          ..write('incidentType: $incidentType, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('policeNotified: $policeNotified, ')
          ..write('policeRef: $policeRef, ')
          ..write('mediaFilePaths: $mediaFilePaths, ')
          ..write('mediaUrls: $mediaUrls, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolsTable extends Patrols with TableInfo<$PatrolsTable, Patrol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, siteId, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrols';
  @override
  VerificationContext validateIntegrity(
    Insertable<Patrol> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patrol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patrol(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $PatrolsTable createAlias(String alias) {
    return $PatrolsTable(attachedDatabase, alias);
  }
}

class Patrol extends DataClass implements Insertable<Patrol> {
  final String id;
  final String siteId;
  final String name;
  final String? description;
  const Patrol({
    required this.id,
    required this.siteId,
    required this.name,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['site_id'] = Variable<String>(siteId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  PatrolsCompanion toCompanion(bool nullToAbsent) {
    return PatrolsCompanion(
      id: Value(id),
      siteId: Value(siteId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Patrol.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patrol(
      id: serializer.fromJson<String>(json['id']),
      siteId: serializer.fromJson<String>(json['siteId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'siteId': serializer.toJson<String>(siteId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
    };
  }

  Patrol copyWith({
    String? id,
    String? siteId,
    String? name,
    Value<String?> description = const Value.absent(),
  }) => Patrol(
    id: id ?? this.id,
    siteId: siteId ?? this.siteId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
  );
  Patrol copyWithCompanion(PatrolsCompanion data) {
    return Patrol(
      id: data.id.present ? data.id.value : this.id,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patrol(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, siteId, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patrol &&
          other.id == this.id &&
          other.siteId == this.siteId &&
          other.name == this.name &&
          other.description == this.description);
}

class PatrolsCompanion extends UpdateCompanion<Patrol> {
  final Value<String> id;
  final Value<String> siteId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> rowid;
  const PatrolsCompanion({
    this.id = const Value.absent(),
    this.siteId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolsCompanion.insert({
    required String id,
    required String siteId,
    required String name,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       siteId = Value(siteId),
       name = Value(name);
  static Insertable<Patrol> custom({
    Expression<String>? id,
    Expression<String>? siteId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siteId != null) 'site_id': siteId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolsCompanion copyWith({
    Value<String>? id,
    Value<String>? siteId,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return PatrolsCompanion(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      name: name ?? this.name,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolsCompanion(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckpointsTable extends Checkpoints
    with TableInfo<$CheckpointsTable, Checkpoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckpointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patrolIdMeta = const VerificationMeta(
    'patrolId',
  );
  @override
  late final GeneratedColumn<String> patrolId = GeneratedColumn<String>(
    'patrol_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patrolId,
    name,
    instructions,
    latitude,
    longitude,
    qrCode,
    completed,
    completedAt,
    needsSync,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkpoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<Checkpoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patrol_id')) {
      context.handle(
        _patrolIdMeta,
        patrolId.isAcceptableOrUnknown(data['patrol_id']!, _patrolIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patrolIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checkpoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checkpoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patrolId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CheckpointsTable createAlias(String alias) {
    return $CheckpointsTable(attachedDatabase, alias);
  }
}

class Checkpoint extends DataClass implements Insertable<Checkpoint> {
  final String id;
  final String patrolId;
  final String name;
  final String? instructions;
  final double? latitude;
  final double? longitude;
  final String? qrCode;
  final bool completed;
  final DateTime? completedAt;
  final bool needsSync;
  final DateTime? syncedAt;
  const Checkpoint({
    required this.id,
    required this.patrolId,
    required this.name,
    this.instructions,
    this.latitude,
    this.longitude,
    this.qrCode,
    required this.completed,
    this.completedAt,
    required this.needsSync,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patrol_id'] = Variable<String>(patrolId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || qrCode != null) {
      map['qr_code'] = Variable<String>(qrCode);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CheckpointsCompanion toCompanion(bool nullToAbsent) {
    return CheckpointsCompanion(
      id: Value(id),
      patrolId: Value(patrolId),
      name: Value(name),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      qrCode: qrCode == null && nullToAbsent
          ? const Value.absent()
          : Value(qrCode),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Checkpoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checkpoint(
      id: serializer.fromJson<String>(json['id']),
      patrolId: serializer.fromJson<String>(json['patrolId']),
      name: serializer.fromJson<String>(json['name']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      qrCode: serializer.fromJson<String?>(json['qrCode']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patrolId': serializer.toJson<String>(patrolId),
      'name': serializer.toJson<String>(name),
      'instructions': serializer.toJson<String?>(instructions),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'qrCode': serializer.toJson<String?>(qrCode),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Checkpoint copyWith({
    String? id,
    String? patrolId,
    String? name,
    Value<String?> instructions = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> qrCode = const Value.absent(),
    bool? completed,
    Value<DateTime?> completedAt = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => Checkpoint(
    id: id ?? this.id,
    patrolId: patrolId ?? this.patrolId,
    name: name ?? this.name,
    instructions: instructions.present ? instructions.value : this.instructions,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    qrCode: qrCode.present ? qrCode.value : this.qrCode,
    completed: completed ?? this.completed,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    needsSync: needsSync ?? this.needsSync,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  Checkpoint copyWithCompanion(CheckpointsCompanion data) {
    return Checkpoint(
      id: data.id.present ? data.id.value : this.id,
      patrolId: data.patrolId.present ? data.patrolId.value : this.patrolId,
      name: data.name.present ? data.name.value : this.name,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checkpoint(')
          ..write('id: $id, ')
          ..write('patrolId: $patrolId, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('qrCode: $qrCode, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patrolId,
    name,
    instructions,
    latitude,
    longitude,
    qrCode,
    completed,
    completedAt,
    needsSync,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checkpoint &&
          other.id == this.id &&
          other.patrolId == this.patrolId &&
          other.name == this.name &&
          other.instructions == this.instructions &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.qrCode == this.qrCode &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt &&
          other.needsSync == this.needsSync &&
          other.syncedAt == this.syncedAt);
}

class CheckpointsCompanion extends UpdateCompanion<Checkpoint> {
  final Value<String> id;
  final Value<String> patrolId;
  final Value<String> name;
  final Value<String?> instructions;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> qrCode;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<bool> needsSync;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CheckpointsCompanion({
    this.id = const Value.absent(),
    this.patrolId = const Value.absent(),
    this.name = const Value.absent(),
    this.instructions = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckpointsCompanion.insert({
    required String id,
    required String patrolId,
    required String name,
    this.instructions = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patrolId = Value(patrolId),
       name = Value(name);
  static Insertable<Checkpoint> custom({
    Expression<String>? id,
    Expression<String>? patrolId,
    Expression<String>? name,
    Expression<String>? instructions,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? qrCode,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<bool>? needsSync,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patrolId != null) 'patrol_id': patrolId,
      if (name != null) 'name': name,
      if (instructions != null) 'instructions': instructions,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (qrCode != null) 'qr_code': qrCode,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckpointsCompanion copyWith({
    Value<String>? id,
    Value<String>? patrolId,
    Value<String>? name,
    Value<String?>? instructions,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? qrCode,
    Value<bool>? completed,
    Value<DateTime?>? completedAt,
    Value<bool>? needsSync,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CheckpointsCompanion(
      id: id ?? this.id,
      patrolId: patrolId ?? this.patrolId,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      qrCode: qrCode ?? this.qrCode,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      needsSync: needsSync ?? this.needsSync,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patrolId.present) {
      map['patrol_id'] = Variable<String>(patrolId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckpointsCompanion(')
          ..write('id: $id, ')
          ..write('patrolId: $patrolId, ')
          ..write('name: $name, ')
          ..write('instructions: $instructions, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('qrCode: $qrCode, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolToursTable extends PatrolTours
    with TableInfo<$PatrolToursTable, PatrolTour> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolToursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyTypeMeta = const VerificationMeta(
    'frequencyType',
  );
  @override
  late final GeneratedColumn<String> frequencyType = GeneratedColumn<String>(
    'frequency_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('per_shift'),
  );
  static const VerificationMeta _intervalMinutesMeta = const VerificationMeta(
    'intervalMinutes',
  );
  @override
  late final GeneratedColumn<int> intervalMinutes = GeneratedColumn<int>(
    'interval_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledTimesMeta = const VerificationMeta(
    'scheduledTimes',
  );
  @override
  late final GeneratedColumn<String> scheduledTimes = GeneratedColumn<String>(
    'scheduled_times',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sequenceRequiredMeta = const VerificationMeta(
    'sequenceRequired',
  );
  @override
  late final GeneratedColumn<bool> sequenceRequired = GeneratedColumn<bool>(
    'sequence_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sequence_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _estimatedDurationMeta = const VerificationMeta(
    'estimatedDuration',
  );
  @override
  late final GeneratedColumn<int> estimatedDuration = GeneratedColumn<int>(
    'estimated_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    clientId,
    siteId,
    name,
    description,
    frequencyType,
    intervalMinutes,
    scheduledTimes,
    startTime,
    endTime,
    sequenceRequired,
    estimatedDuration,
    isActive,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrol_tours';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatrolTour> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('frequency_type')) {
      context.handle(
        _frequencyTypeMeta,
        frequencyType.isAcceptableOrUnknown(
          data['frequency_type']!,
          _frequencyTypeMeta,
        ),
      );
    }
    if (data.containsKey('interval_minutes')) {
      context.handle(
        _intervalMinutesMeta,
        intervalMinutes.isAcceptableOrUnknown(
          data['interval_minutes']!,
          _intervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_times')) {
      context.handle(
        _scheduledTimesMeta,
        scheduledTimes.isAcceptableOrUnknown(
          data['scheduled_times']!,
          _scheduledTimesMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('sequence_required')) {
      context.handle(
        _sequenceRequiredMeta,
        sequenceRequired.isAcceptableOrUnknown(
          data['sequence_required']!,
          _sequenceRequiredMeta,
        ),
      );
    }
    if (data.containsKey('estimated_duration')) {
      context.handle(
        _estimatedDurationMeta,
        estimatedDuration.isAcceptableOrUnknown(
          data['estimated_duration']!,
          _estimatedDurationMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatrolTour map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatrolTour(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      frequencyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_type'],
      )!,
      intervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_minutes'],
      ),
      scheduledTimes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_times'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      sequenceRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sequence_required'],
      )!,
      estimatedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_duration'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $PatrolToursTable createAlias(String alias) {
    return $PatrolToursTable(attachedDatabase, alias);
  }
}

class PatrolTour extends DataClass implements Insertable<PatrolTour> {
  final String id;
  final String tenantId;
  final String clientId;
  final String siteId;
  final String name;
  final String? description;
  final String frequencyType;
  final int? intervalMinutes;
  final String? scheduledTimes;
  final String? startTime;
  final String? endTime;
  final bool sequenceRequired;
  final int? estimatedDuration;
  final bool isActive;
  final DateTime? syncedAt;
  const PatrolTour({
    required this.id,
    required this.tenantId,
    required this.clientId,
    required this.siteId,
    required this.name,
    this.description,
    required this.frequencyType,
    this.intervalMinutes,
    this.scheduledTimes,
    this.startTime,
    this.endTime,
    required this.sequenceRequired,
    this.estimatedDuration,
    required this.isActive,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['client_id'] = Variable<String>(clientId);
    map['site_id'] = Variable<String>(siteId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['frequency_type'] = Variable<String>(frequencyType);
    if (!nullToAbsent || intervalMinutes != null) {
      map['interval_minutes'] = Variable<int>(intervalMinutes);
    }
    if (!nullToAbsent || scheduledTimes != null) {
      map['scheduled_times'] = Variable<String>(scheduledTimes);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    map['sequence_required'] = Variable<bool>(sequenceRequired);
    if (!nullToAbsent || estimatedDuration != null) {
      map['estimated_duration'] = Variable<int>(estimatedDuration);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PatrolToursCompanion toCompanion(bool nullToAbsent) {
    return PatrolToursCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      clientId: Value(clientId),
      siteId: Value(siteId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      frequencyType: Value(frequencyType),
      intervalMinutes: intervalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMinutes),
      scheduledTimes: scheduledTimes == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTimes),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      sequenceRequired: Value(sequenceRequired),
      estimatedDuration: estimatedDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedDuration),
      isActive: Value(isActive),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PatrolTour.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatrolTour(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      clientId: serializer.fromJson<String>(json['clientId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      frequencyType: serializer.fromJson<String>(json['frequencyType']),
      intervalMinutes: serializer.fromJson<int?>(json['intervalMinutes']),
      scheduledTimes: serializer.fromJson<String?>(json['scheduledTimes']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      sequenceRequired: serializer.fromJson<bool>(json['sequenceRequired']),
      estimatedDuration: serializer.fromJson<int?>(json['estimatedDuration']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'clientId': serializer.toJson<String>(clientId),
      'siteId': serializer.toJson<String>(siteId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'frequencyType': serializer.toJson<String>(frequencyType),
      'intervalMinutes': serializer.toJson<int?>(intervalMinutes),
      'scheduledTimes': serializer.toJson<String?>(scheduledTimes),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'sequenceRequired': serializer.toJson<bool>(sequenceRequired),
      'estimatedDuration': serializer.toJson<int?>(estimatedDuration),
      'isActive': serializer.toJson<bool>(isActive),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PatrolTour copyWith({
    String? id,
    String? tenantId,
    String? clientId,
    String? siteId,
    String? name,
    Value<String?> description = const Value.absent(),
    String? frequencyType,
    Value<int?> intervalMinutes = const Value.absent(),
    Value<String?> scheduledTimes = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    bool? sequenceRequired,
    Value<int?> estimatedDuration = const Value.absent(),
    bool? isActive,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => PatrolTour(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    clientId: clientId ?? this.clientId,
    siteId: siteId ?? this.siteId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    frequencyType: frequencyType ?? this.frequencyType,
    intervalMinutes: intervalMinutes.present
        ? intervalMinutes.value
        : this.intervalMinutes,
    scheduledTimes: scheduledTimes.present
        ? scheduledTimes.value
        : this.scheduledTimes,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    sequenceRequired: sequenceRequired ?? this.sequenceRequired,
    estimatedDuration: estimatedDuration.present
        ? estimatedDuration.value
        : this.estimatedDuration,
    isActive: isActive ?? this.isActive,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  PatrolTour copyWithCompanion(PatrolToursCompanion data) {
    return PatrolTour(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      frequencyType: data.frequencyType.present
          ? data.frequencyType.value
          : this.frequencyType,
      intervalMinutes: data.intervalMinutes.present
          ? data.intervalMinutes.value
          : this.intervalMinutes,
      scheduledTimes: data.scheduledTimes.present
          ? data.scheduledTimes.value
          : this.scheduledTimes,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      sequenceRequired: data.sequenceRequired.present
          ? data.sequenceRequired.value
          : this.sequenceRequired,
      estimatedDuration: data.estimatedDuration.present
          ? data.estimatedDuration.value
          : this.estimatedDuration,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTour(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('clientId: $clientId, ')
          ..write('siteId: $siteId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('scheduledTimes: $scheduledTimes, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('sequenceRequired: $sequenceRequired, ')
          ..write('estimatedDuration: $estimatedDuration, ')
          ..write('isActive: $isActive, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    clientId,
    siteId,
    name,
    description,
    frequencyType,
    intervalMinutes,
    scheduledTimes,
    startTime,
    endTime,
    sequenceRequired,
    estimatedDuration,
    isActive,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatrolTour &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.clientId == this.clientId &&
          other.siteId == this.siteId &&
          other.name == this.name &&
          other.description == this.description &&
          other.frequencyType == this.frequencyType &&
          other.intervalMinutes == this.intervalMinutes &&
          other.scheduledTimes == this.scheduledTimes &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.sequenceRequired == this.sequenceRequired &&
          other.estimatedDuration == this.estimatedDuration &&
          other.isActive == this.isActive &&
          other.syncedAt == this.syncedAt);
}

class PatrolToursCompanion extends UpdateCompanion<PatrolTour> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> clientId;
  final Value<String> siteId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> frequencyType;
  final Value<int?> intervalMinutes;
  final Value<String?> scheduledTimes;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<bool> sequenceRequired;
  final Value<int?> estimatedDuration;
  final Value<bool> isActive;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PatrolToursCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.scheduledTimes = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.sequenceRequired = const Value.absent(),
    this.estimatedDuration = const Value.absent(),
    this.isActive = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolToursCompanion.insert({
    required String id,
    required String tenantId,
    required String clientId,
    required String siteId,
    required String name,
    this.description = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.scheduledTimes = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.sequenceRequired = const Value.absent(),
    this.estimatedDuration = const Value.absent(),
    this.isActive = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       clientId = Value(clientId),
       siteId = Value(siteId),
       name = Value(name);
  static Insertable<PatrolTour> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? clientId,
    Expression<String>? siteId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? frequencyType,
    Expression<int>? intervalMinutes,
    Expression<String>? scheduledTimes,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<bool>? sequenceRequired,
    Expression<int>? estimatedDuration,
    Expression<bool>? isActive,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (clientId != null) 'client_id': clientId,
      if (siteId != null) 'site_id': siteId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (frequencyType != null) 'frequency_type': frequencyType,
      if (intervalMinutes != null) 'interval_minutes': intervalMinutes,
      if (scheduledTimes != null) 'scheduled_times': scheduledTimes,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (sequenceRequired != null) 'sequence_required': sequenceRequired,
      if (estimatedDuration != null) 'estimated_duration': estimatedDuration,
      if (isActive != null) 'is_active': isActive,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolToursCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? clientId,
    Value<String>? siteId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? frequencyType,
    Value<int?>? intervalMinutes,
    Value<String?>? scheduledTimes,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<bool>? sequenceRequired,
    Value<int?>? estimatedDuration,
    Value<bool>? isActive,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return PatrolToursCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      clientId: clientId ?? this.clientId,
      siteId: siteId ?? this.siteId,
      name: name ?? this.name,
      description: description ?? this.description,
      frequencyType: frequencyType ?? this.frequencyType,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      sequenceRequired: sequenceRequired ?? this.sequenceRequired,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isActive: isActive ?? this.isActive,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequencyType.present) {
      map['frequency_type'] = Variable<String>(frequencyType.value);
    }
    if (intervalMinutes.present) {
      map['interval_minutes'] = Variable<int>(intervalMinutes.value);
    }
    if (scheduledTimes.present) {
      map['scheduled_times'] = Variable<String>(scheduledTimes.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (sequenceRequired.present) {
      map['sequence_required'] = Variable<bool>(sequenceRequired.value);
    }
    if (estimatedDuration.present) {
      map['estimated_duration'] = Variable<int>(estimatedDuration.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolToursCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('clientId: $clientId, ')
          ..write('siteId: $siteId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('scheduledTimes: $scheduledTimes, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('sequenceRequired: $sequenceRequired, ')
          ..write('estimatedDuration: $estimatedDuration, ')
          ..write('isActive: $isActive, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolTourPointsTable extends PatrolTourPoints
    with TableInfo<$PatrolTourPointsTable, PatrolTourPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolTourPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patrolTourIdMeta = const VerificationMeta(
    'patrolTourId',
  );
  @override
  late final GeneratedColumn<String> patrolTourId = GeneratedColumn<String>(
    'patrol_tour_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkpointIdMeta = const VerificationMeta(
    'checkpointId',
  );
  @override
  late final GeneratedColumn<String> checkpointId = GeneratedColumn<String>(
    'checkpoint_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceNumberMeta = const VerificationMeta(
    'sequenceNumber',
  );
  @override
  late final GeneratedColumn<int> sequenceNumber = GeneratedColumn<int>(
    'sequence_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _requireScanMeta = const VerificationMeta(
    'requireScan',
  );
  @override
  late final GeneratedColumn<bool> requireScan = GeneratedColumn<bool>(
    'require_scan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("require_scan" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _requirePhotoMeta = const VerificationMeta(
    'requirePhoto',
  );
  @override
  late final GeneratedColumn<bool> requirePhoto = GeneratedColumn<bool>(
    'require_photo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("require_photo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requireNotesMeta = const VerificationMeta(
    'requireNotes',
  );
  @override
  late final GeneratedColumn<bool> requireNotes = GeneratedColumn<bool>(
    'require_notes',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("require_notes" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedDurationMeta = const VerificationMeta(
    'expectedDuration',
  );
  @override
  late final GeneratedColumn<int> expectedDuration = GeneratedColumn<int>(
    'expected_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _checkpointNameMeta = const VerificationMeta(
    'checkpointName',
  );
  @override
  late final GeneratedColumn<String> checkpointName = GeneratedColumn<String>(
    'checkpoint_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkpointCodeMeta = const VerificationMeta(
    'checkpointCode',
  );
  @override
  late final GeneratedColumn<String> checkpointCode = GeneratedColumn<String>(
    'checkpoint_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geofenceRadiusMeta = const VerificationMeta(
    'geofenceRadius',
  );
  @override
  late final GeneratedColumn<int> geofenceRadius = GeneratedColumn<int>(
    'geofence_radius',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    patrolTourId,
    checkpointId,
    sequenceNumber,
    requireScan,
    requirePhoto,
    requireNotes,
    instructions,
    expectedDuration,
    isActive,
    checkpointName,
    checkpointCode,
    latitude,
    longitude,
    geofenceRadius,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrol_tour_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatrolTourPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('patrol_tour_id')) {
      context.handle(
        _patrolTourIdMeta,
        patrolTourId.isAcceptableOrUnknown(
          data['patrol_tour_id']!,
          _patrolTourIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patrolTourIdMeta);
    }
    if (data.containsKey('checkpoint_id')) {
      context.handle(
        _checkpointIdMeta,
        checkpointId.isAcceptableOrUnknown(
          data['checkpoint_id']!,
          _checkpointIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkpointIdMeta);
    }
    if (data.containsKey('sequence_number')) {
      context.handle(
        _sequenceNumberMeta,
        sequenceNumber.isAcceptableOrUnknown(
          data['sequence_number']!,
          _sequenceNumberMeta,
        ),
      );
    }
    if (data.containsKey('require_scan')) {
      context.handle(
        _requireScanMeta,
        requireScan.isAcceptableOrUnknown(
          data['require_scan']!,
          _requireScanMeta,
        ),
      );
    }
    if (data.containsKey('require_photo')) {
      context.handle(
        _requirePhotoMeta,
        requirePhoto.isAcceptableOrUnknown(
          data['require_photo']!,
          _requirePhotoMeta,
        ),
      );
    }
    if (data.containsKey('require_notes')) {
      context.handle(
        _requireNotesMeta,
        requireNotes.isAcceptableOrUnknown(
          data['require_notes']!,
          _requireNotesMeta,
        ),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('expected_duration')) {
      context.handle(
        _expectedDurationMeta,
        expectedDuration.isAcceptableOrUnknown(
          data['expected_duration']!,
          _expectedDurationMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('checkpoint_name')) {
      context.handle(
        _checkpointNameMeta,
        checkpointName.isAcceptableOrUnknown(
          data['checkpoint_name']!,
          _checkpointNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkpointNameMeta);
    }
    if (data.containsKey('checkpoint_code')) {
      context.handle(
        _checkpointCodeMeta,
        checkpointCode.isAcceptableOrUnknown(
          data['checkpoint_code']!,
          _checkpointCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkpointCodeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('geofence_radius')) {
      context.handle(
        _geofenceRadiusMeta,
        geofenceRadius.isAcceptableOrUnknown(
          data['geofence_radius']!,
          _geofenceRadiusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatrolTourPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatrolTourPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      patrolTourId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_tour_id'],
      )!,
      checkpointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint_id'],
      )!,
      sequenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_number'],
      )!,
      requireScan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}require_scan'],
      )!,
      requirePhoto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}require_photo'],
      )!,
      requireNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}require_notes'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      expectedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_duration'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      checkpointName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint_name'],
      )!,
      checkpointCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkpoint_code'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      geofenceRadius: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}geofence_radius'],
      )!,
    );
  }

  @override
  $PatrolTourPointsTable createAlias(String alias) {
    return $PatrolTourPointsTable(attachedDatabase, alias);
  }
}

class PatrolTourPoint extends DataClass implements Insertable<PatrolTourPoint> {
  final String id;
  final String tenantId;
  final String patrolTourId;
  final String checkpointId;
  final int sequenceNumber;
  final bool requireScan;
  final bool requirePhoto;
  final bool requireNotes;
  final String? instructions;
  final int expectedDuration;
  final bool isActive;
  final String checkpointName;
  final String checkpointCode;
  final double? latitude;
  final double? longitude;
  final int geofenceRadius;
  const PatrolTourPoint({
    required this.id,
    required this.tenantId,
    required this.patrolTourId,
    required this.checkpointId,
    required this.sequenceNumber,
    required this.requireScan,
    required this.requirePhoto,
    required this.requireNotes,
    this.instructions,
    required this.expectedDuration,
    required this.isActive,
    required this.checkpointName,
    required this.checkpointCode,
    this.latitude,
    this.longitude,
    required this.geofenceRadius,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['patrol_tour_id'] = Variable<String>(patrolTourId);
    map['checkpoint_id'] = Variable<String>(checkpointId);
    map['sequence_number'] = Variable<int>(sequenceNumber);
    map['require_scan'] = Variable<bool>(requireScan);
    map['require_photo'] = Variable<bool>(requirePhoto);
    map['require_notes'] = Variable<bool>(requireNotes);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['expected_duration'] = Variable<int>(expectedDuration);
    map['is_active'] = Variable<bool>(isActive);
    map['checkpoint_name'] = Variable<String>(checkpointName);
    map['checkpoint_code'] = Variable<String>(checkpointCode);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['geofence_radius'] = Variable<int>(geofenceRadius);
    return map;
  }

  PatrolTourPointsCompanion toCompanion(bool nullToAbsent) {
    return PatrolTourPointsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      patrolTourId: Value(patrolTourId),
      checkpointId: Value(checkpointId),
      sequenceNumber: Value(sequenceNumber),
      requireScan: Value(requireScan),
      requirePhoto: Value(requirePhoto),
      requireNotes: Value(requireNotes),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      expectedDuration: Value(expectedDuration),
      isActive: Value(isActive),
      checkpointName: Value(checkpointName),
      checkpointCode: Value(checkpointCode),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      geofenceRadius: Value(geofenceRadius),
    );
  }

  factory PatrolTourPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatrolTourPoint(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      patrolTourId: serializer.fromJson<String>(json['patrolTourId']),
      checkpointId: serializer.fromJson<String>(json['checkpointId']),
      sequenceNumber: serializer.fromJson<int>(json['sequenceNumber']),
      requireScan: serializer.fromJson<bool>(json['requireScan']),
      requirePhoto: serializer.fromJson<bool>(json['requirePhoto']),
      requireNotes: serializer.fromJson<bool>(json['requireNotes']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      expectedDuration: serializer.fromJson<int>(json['expectedDuration']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      checkpointName: serializer.fromJson<String>(json['checkpointName']),
      checkpointCode: serializer.fromJson<String>(json['checkpointCode']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      geofenceRadius: serializer.fromJson<int>(json['geofenceRadius']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'patrolTourId': serializer.toJson<String>(patrolTourId),
      'checkpointId': serializer.toJson<String>(checkpointId),
      'sequenceNumber': serializer.toJson<int>(sequenceNumber),
      'requireScan': serializer.toJson<bool>(requireScan),
      'requirePhoto': serializer.toJson<bool>(requirePhoto),
      'requireNotes': serializer.toJson<bool>(requireNotes),
      'instructions': serializer.toJson<String?>(instructions),
      'expectedDuration': serializer.toJson<int>(expectedDuration),
      'isActive': serializer.toJson<bool>(isActive),
      'checkpointName': serializer.toJson<String>(checkpointName),
      'checkpointCode': serializer.toJson<String>(checkpointCode),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'geofenceRadius': serializer.toJson<int>(geofenceRadius),
    };
  }

  PatrolTourPoint copyWith({
    String? id,
    String? tenantId,
    String? patrolTourId,
    String? checkpointId,
    int? sequenceNumber,
    bool? requireScan,
    bool? requirePhoto,
    bool? requireNotes,
    Value<String?> instructions = const Value.absent(),
    int? expectedDuration,
    bool? isActive,
    String? checkpointName,
    String? checkpointCode,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    int? geofenceRadius,
  }) => PatrolTourPoint(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    patrolTourId: patrolTourId ?? this.patrolTourId,
    checkpointId: checkpointId ?? this.checkpointId,
    sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    requireScan: requireScan ?? this.requireScan,
    requirePhoto: requirePhoto ?? this.requirePhoto,
    requireNotes: requireNotes ?? this.requireNotes,
    instructions: instructions.present ? instructions.value : this.instructions,
    expectedDuration: expectedDuration ?? this.expectedDuration,
    isActive: isActive ?? this.isActive,
    checkpointName: checkpointName ?? this.checkpointName,
    checkpointCode: checkpointCode ?? this.checkpointCode,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    geofenceRadius: geofenceRadius ?? this.geofenceRadius,
  );
  PatrolTourPoint copyWithCompanion(PatrolTourPointsCompanion data) {
    return PatrolTourPoint(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      patrolTourId: data.patrolTourId.present
          ? data.patrolTourId.value
          : this.patrolTourId,
      checkpointId: data.checkpointId.present
          ? data.checkpointId.value
          : this.checkpointId,
      sequenceNumber: data.sequenceNumber.present
          ? data.sequenceNumber.value
          : this.sequenceNumber,
      requireScan: data.requireScan.present
          ? data.requireScan.value
          : this.requireScan,
      requirePhoto: data.requirePhoto.present
          ? data.requirePhoto.value
          : this.requirePhoto,
      requireNotes: data.requireNotes.present
          ? data.requireNotes.value
          : this.requireNotes,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      expectedDuration: data.expectedDuration.present
          ? data.expectedDuration.value
          : this.expectedDuration,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      checkpointName: data.checkpointName.present
          ? data.checkpointName.value
          : this.checkpointName,
      checkpointCode: data.checkpointCode.present
          ? data.checkpointCode.value
          : this.checkpointCode,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      geofenceRadius: data.geofenceRadius.present
          ? data.geofenceRadius.value
          : this.geofenceRadius,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTourPoint(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolTourId: $patrolTourId, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('requireScan: $requireScan, ')
          ..write('requirePhoto: $requirePhoto, ')
          ..write('requireNotes: $requireNotes, ')
          ..write('instructions: $instructions, ')
          ..write('expectedDuration: $expectedDuration, ')
          ..write('isActive: $isActive, ')
          ..write('checkpointName: $checkpointName, ')
          ..write('checkpointCode: $checkpointCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('geofenceRadius: $geofenceRadius')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    patrolTourId,
    checkpointId,
    sequenceNumber,
    requireScan,
    requirePhoto,
    requireNotes,
    instructions,
    expectedDuration,
    isActive,
    checkpointName,
    checkpointCode,
    latitude,
    longitude,
    geofenceRadius,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatrolTourPoint &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.patrolTourId == this.patrolTourId &&
          other.checkpointId == this.checkpointId &&
          other.sequenceNumber == this.sequenceNumber &&
          other.requireScan == this.requireScan &&
          other.requirePhoto == this.requirePhoto &&
          other.requireNotes == this.requireNotes &&
          other.instructions == this.instructions &&
          other.expectedDuration == this.expectedDuration &&
          other.isActive == this.isActive &&
          other.checkpointName == this.checkpointName &&
          other.checkpointCode == this.checkpointCode &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.geofenceRadius == this.geofenceRadius);
}

class PatrolTourPointsCompanion extends UpdateCompanion<PatrolTourPoint> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> patrolTourId;
  final Value<String> checkpointId;
  final Value<int> sequenceNumber;
  final Value<bool> requireScan;
  final Value<bool> requirePhoto;
  final Value<bool> requireNotes;
  final Value<String?> instructions;
  final Value<int> expectedDuration;
  final Value<bool> isActive;
  final Value<String> checkpointName;
  final Value<String> checkpointCode;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> geofenceRadius;
  final Value<int> rowid;
  const PatrolTourPointsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.patrolTourId = const Value.absent(),
    this.checkpointId = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.requireScan = const Value.absent(),
    this.requirePhoto = const Value.absent(),
    this.requireNotes = const Value.absent(),
    this.instructions = const Value.absent(),
    this.expectedDuration = const Value.absent(),
    this.isActive = const Value.absent(),
    this.checkpointName = const Value.absent(),
    this.checkpointCode = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.geofenceRadius = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolTourPointsCompanion.insert({
    required String id,
    required String tenantId,
    required String patrolTourId,
    required String checkpointId,
    this.sequenceNumber = const Value.absent(),
    this.requireScan = const Value.absent(),
    this.requirePhoto = const Value.absent(),
    this.requireNotes = const Value.absent(),
    this.instructions = const Value.absent(),
    this.expectedDuration = const Value.absent(),
    this.isActive = const Value.absent(),
    required String checkpointName,
    required String checkpointCode,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.geofenceRadius = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       patrolTourId = Value(patrolTourId),
       checkpointId = Value(checkpointId),
       checkpointName = Value(checkpointName),
       checkpointCode = Value(checkpointCode);
  static Insertable<PatrolTourPoint> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? patrolTourId,
    Expression<String>? checkpointId,
    Expression<int>? sequenceNumber,
    Expression<bool>? requireScan,
    Expression<bool>? requirePhoto,
    Expression<bool>? requireNotes,
    Expression<String>? instructions,
    Expression<int>? expectedDuration,
    Expression<bool>? isActive,
    Expression<String>? checkpointName,
    Expression<String>? checkpointCode,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? geofenceRadius,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (patrolTourId != null) 'patrol_tour_id': patrolTourId,
      if (checkpointId != null) 'checkpoint_id': checkpointId,
      if (sequenceNumber != null) 'sequence_number': sequenceNumber,
      if (requireScan != null) 'require_scan': requireScan,
      if (requirePhoto != null) 'require_photo': requirePhoto,
      if (requireNotes != null) 'require_notes': requireNotes,
      if (instructions != null) 'instructions': instructions,
      if (expectedDuration != null) 'expected_duration': expectedDuration,
      if (isActive != null) 'is_active': isActive,
      if (checkpointName != null) 'checkpoint_name': checkpointName,
      if (checkpointCode != null) 'checkpoint_code': checkpointCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (geofenceRadius != null) 'geofence_radius': geofenceRadius,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolTourPointsCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? patrolTourId,
    Value<String>? checkpointId,
    Value<int>? sequenceNumber,
    Value<bool>? requireScan,
    Value<bool>? requirePhoto,
    Value<bool>? requireNotes,
    Value<String?>? instructions,
    Value<int>? expectedDuration,
    Value<bool>? isActive,
    Value<String>? checkpointName,
    Value<String>? checkpointCode,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<int>? geofenceRadius,
    Value<int>? rowid,
  }) {
    return PatrolTourPointsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      patrolTourId: patrolTourId ?? this.patrolTourId,
      checkpointId: checkpointId ?? this.checkpointId,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      requireScan: requireScan ?? this.requireScan,
      requirePhoto: requirePhoto ?? this.requirePhoto,
      requireNotes: requireNotes ?? this.requireNotes,
      instructions: instructions ?? this.instructions,
      expectedDuration: expectedDuration ?? this.expectedDuration,
      isActive: isActive ?? this.isActive,
      checkpointName: checkpointName ?? this.checkpointName,
      checkpointCode: checkpointCode ?? this.checkpointCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geofenceRadius: geofenceRadius ?? this.geofenceRadius,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (patrolTourId.present) {
      map['patrol_tour_id'] = Variable<String>(patrolTourId.value);
    }
    if (checkpointId.present) {
      map['checkpoint_id'] = Variable<String>(checkpointId.value);
    }
    if (sequenceNumber.present) {
      map['sequence_number'] = Variable<int>(sequenceNumber.value);
    }
    if (requireScan.present) {
      map['require_scan'] = Variable<bool>(requireScan.value);
    }
    if (requirePhoto.present) {
      map['require_photo'] = Variable<bool>(requirePhoto.value);
    }
    if (requireNotes.present) {
      map['require_notes'] = Variable<bool>(requireNotes.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (expectedDuration.present) {
      map['expected_duration'] = Variable<int>(expectedDuration.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (checkpointName.present) {
      map['checkpoint_name'] = Variable<String>(checkpointName.value);
    }
    if (checkpointCode.present) {
      map['checkpoint_code'] = Variable<String>(checkpointCode.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (geofenceRadius.present) {
      map['geofence_radius'] = Variable<int>(geofenceRadius.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTourPointsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolTourId: $patrolTourId, ')
          ..write('checkpointId: $checkpointId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('requireScan: $requireScan, ')
          ..write('requirePhoto: $requirePhoto, ')
          ..write('requireNotes: $requireNotes, ')
          ..write('instructions: $instructions, ')
          ..write('expectedDuration: $expectedDuration, ')
          ..write('isActive: $isActive, ')
          ..write('checkpointName: $checkpointName, ')
          ..write('checkpointCode: $checkpointCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('geofenceRadius: $geofenceRadius, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolTasksTable extends PatrolTasks
    with TableInfo<$PatrolTasksTable, PatrolTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patrolPointIdMeta = const VerificationMeta(
    'patrolPointId',
  );
  @override
  late final GeneratedColumn<String> patrolPointId = GeneratedColumn<String>(
    'patrol_point_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('checkbox'),
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    patrolPointId,
    title,
    description,
    taskType,
    options,
    isRequired,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrol_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatrolTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('patrol_point_id')) {
      context.handle(
        _patrolPointIdMeta,
        patrolPointId.isAcceptableOrUnknown(
          data['patrol_point_id']!,
          _patrolPointIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patrolPointIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatrolTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatrolTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      patrolPointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_point_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      ),
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $PatrolTasksTable createAlias(String alias) {
    return $PatrolTasksTable(attachedDatabase, alias);
  }
}

class PatrolTask extends DataClass implements Insertable<PatrolTask> {
  final String id;
  final String tenantId;
  final String patrolPointId;
  final String title;
  final String? description;
  final String taskType;
  final String? options;
  final bool isRequired;
  final int sortOrder;
  final bool isActive;
  const PatrolTask({
    required this.id,
    required this.tenantId,
    required this.patrolPointId,
    required this.title,
    this.description,
    required this.taskType,
    this.options,
    required this.isRequired,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['patrol_point_id'] = Variable<String>(patrolPointId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['task_type'] = Variable<String>(taskType);
    if (!nullToAbsent || options != null) {
      map['options'] = Variable<String>(options);
    }
    map['is_required'] = Variable<bool>(isRequired);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PatrolTasksCompanion toCompanion(bool nullToAbsent) {
    return PatrolTasksCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      patrolPointId: Value(patrolPointId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      taskType: Value(taskType),
      options: options == null && nullToAbsent
          ? const Value.absent()
          : Value(options),
      isRequired: Value(isRequired),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory PatrolTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatrolTask(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      patrolPointId: serializer.fromJson<String>(json['patrolPointId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      taskType: serializer.fromJson<String>(json['taskType']),
      options: serializer.fromJson<String?>(json['options']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'patrolPointId': serializer.toJson<String>(patrolPointId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'taskType': serializer.toJson<String>(taskType),
      'options': serializer.toJson<String?>(options),
      'isRequired': serializer.toJson<bool>(isRequired),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PatrolTask copyWith({
    String? id,
    String? tenantId,
    String? patrolPointId,
    String? title,
    Value<String?> description = const Value.absent(),
    String? taskType,
    Value<String?> options = const Value.absent(),
    bool? isRequired,
    int? sortOrder,
    bool? isActive,
  }) => PatrolTask(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    patrolPointId: patrolPointId ?? this.patrolPointId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    taskType: taskType ?? this.taskType,
    options: options.present ? options.value : this.options,
    isRequired: isRequired ?? this.isRequired,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  PatrolTask copyWithCompanion(PatrolTasksCompanion data) {
    return PatrolTask(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      patrolPointId: data.patrolPointId.present
          ? data.patrolPointId.value
          : this.patrolPointId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      options: data.options.present ? data.options.value : this.options,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTask(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolPointId: $patrolPointId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('taskType: $taskType, ')
          ..write('options: $options, ')
          ..write('isRequired: $isRequired, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    patrolPointId,
    title,
    description,
    taskType,
    options,
    isRequired,
    sortOrder,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatrolTask &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.patrolPointId == this.patrolPointId &&
          other.title == this.title &&
          other.description == this.description &&
          other.taskType == this.taskType &&
          other.options == this.options &&
          other.isRequired == this.isRequired &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class PatrolTasksCompanion extends UpdateCompanion<PatrolTask> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> patrolPointId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> taskType;
  final Value<String?> options;
  final Value<bool> isRequired;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const PatrolTasksCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.patrolPointId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.taskType = const Value.absent(),
    this.options = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolTasksCompanion.insert({
    required String id,
    required String tenantId,
    required String patrolPointId,
    required String title,
    this.description = const Value.absent(),
    this.taskType = const Value.absent(),
    this.options = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       patrolPointId = Value(patrolPointId),
       title = Value(title);
  static Insertable<PatrolTask> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? patrolPointId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? taskType,
    Expression<String>? options,
    Expression<bool>? isRequired,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (patrolPointId != null) 'patrol_point_id': patrolPointId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (taskType != null) 'task_type': taskType,
      if (options != null) 'options': options,
      if (isRequired != null) 'is_required': isRequired,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? patrolPointId,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? taskType,
    Value<String?>? options,
    Value<bool>? isRequired,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return PatrolTasksCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      patrolPointId: patrolPointId ?? this.patrolPointId,
      title: title ?? this.title,
      description: description ?? this.description,
      taskType: taskType ?? this.taskType,
      options: options ?? this.options,
      isRequired: isRequired ?? this.isRequired,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (patrolPointId.present) {
      map['patrol_point_id'] = Variable<String>(patrolPointId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTasksCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolPointId: $patrolPointId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('taskType: $taskType, ')
          ..write('options: $options, ')
          ..write('isRequired: $isRequired, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolInstancesTable extends PatrolInstances
    with TableInfo<$PatrolInstancesTable, PatrolInstance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patrolTourIdMeta = const VerificationMeta(
    'patrolTourId',
  );
  @override
  late final GeneratedColumn<String> patrolTourId = GeneratedColumn<String>(
    'patrol_tour_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledStartMeta = const VerificationMeta(
    'scheduledStart',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledStart =
      GeneratedColumn<DateTime>(
        'scheduled_start',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actualStartMeta = const VerificationMeta(
    'actualStart',
  );
  @override
  late final GeneratedColumn<DateTime> actualStart = GeneratedColumn<DateTime>(
    'actual_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualEndMeta = const VerificationMeta(
    'actualEnd',
  );
  @override
  late final GeneratedColumn<DateTime> actualEnd = GeneratedColumn<DateTime>(
    'actual_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _totalPointsMeta = const VerificationMeta(
    'totalPoints',
  );
  @override
  late final GeneratedColumn<int> totalPoints = GeneratedColumn<int>(
    'total_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedPointsMeta = const VerificationMeta(
    'completedPoints',
  );
  @override
  late final GeneratedColumn<int> completedPoints = GeneratedColumn<int>(
    'completed_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startLatitudeMeta = const VerificationMeta(
    'startLatitude',
  );
  @override
  late final GeneratedColumn<double> startLatitude = GeneratedColumn<double>(
    'start_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startLongitudeMeta = const VerificationMeta(
    'startLongitude',
  );
  @override
  late final GeneratedColumn<double> startLongitude = GeneratedColumn<double>(
    'start_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    tenantId,
    patrolTourId,
    scheduleId,
    shiftId,
    employeeId,
    scheduledStart,
    actualStart,
    actualEnd,
    status,
    totalPoints,
    completedPoints,
    startLatitude,
    startLongitude,
    notes,
    needsSync,
    syncedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrol_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatrolInstance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('patrol_tour_id')) {
      context.handle(
        _patrolTourIdMeta,
        patrolTourId.isAcceptableOrUnknown(
          data['patrol_tour_id']!,
          _patrolTourIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patrolTourIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
        _scheduledStartMeta,
        scheduledStart.isAcceptableOrUnknown(
          data['scheduled_start']!,
          _scheduledStartMeta,
        ),
      );
    }
    if (data.containsKey('actual_start')) {
      context.handle(
        _actualStartMeta,
        actualStart.isAcceptableOrUnknown(
          data['actual_start']!,
          _actualStartMeta,
        ),
      );
    }
    if (data.containsKey('actual_end')) {
      context.handle(
        _actualEndMeta,
        actualEnd.isAcceptableOrUnknown(data['actual_end']!, _actualEndMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_points')) {
      context.handle(
        _totalPointsMeta,
        totalPoints.isAcceptableOrUnknown(
          data['total_points']!,
          _totalPointsMeta,
        ),
      );
    }
    if (data.containsKey('completed_points')) {
      context.handle(
        _completedPointsMeta,
        completedPoints.isAcceptableOrUnknown(
          data['completed_points']!,
          _completedPointsMeta,
        ),
      );
    }
    if (data.containsKey('start_latitude')) {
      context.handle(
        _startLatitudeMeta,
        startLatitude.isAcceptableOrUnknown(
          data['start_latitude']!,
          _startLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('start_longitude')) {
      context.handle(
        _startLongitudeMeta,
        startLongitude.isAcceptableOrUnknown(
          data['start_longitude']!,
          _startLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatrolInstance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatrolInstance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      patrolTourId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_tour_id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      ),
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      ),
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      scheduledStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_start'],
      ),
      actualStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_start'],
      ),
      actualEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_end'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_points'],
      )!,
      completedPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_points'],
      )!,
      startLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_latitude'],
      ),
      startLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_longitude'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PatrolInstancesTable createAlias(String alias) {
    return $PatrolInstancesTable(attachedDatabase, alias);
  }
}

class PatrolInstance extends DataClass implements Insertable<PatrolInstance> {
  final String id;
  final String? serverId;
  final String tenantId;
  final String patrolTourId;
  final String? scheduleId;
  final String? shiftId;
  final String employeeId;
  final DateTime? scheduledStart;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final String status;
  final int totalPoints;
  final int completedPoints;
  final double? startLatitude;
  final double? startLongitude;
  final String? notes;
  final bool needsSync;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PatrolInstance({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.patrolTourId,
    this.scheduleId,
    this.shiftId,
    required this.employeeId,
    this.scheduledStart,
    this.actualStart,
    this.actualEnd,
    required this.status,
    required this.totalPoints,
    required this.completedPoints,
    this.startLatitude,
    this.startLongitude,
    this.notes,
    required this.needsSync,
    this.syncedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['tenant_id'] = Variable<String>(tenantId);
    map['patrol_tour_id'] = Variable<String>(patrolTourId);
    if (!nullToAbsent || scheduleId != null) {
      map['schedule_id'] = Variable<String>(scheduleId);
    }
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<String>(shiftId);
    }
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || scheduledStart != null) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    }
    if (!nullToAbsent || actualStart != null) {
      map['actual_start'] = Variable<DateTime>(actualStart);
    }
    if (!nullToAbsent || actualEnd != null) {
      map['actual_end'] = Variable<DateTime>(actualEnd);
    }
    map['status'] = Variable<String>(status);
    map['total_points'] = Variable<int>(totalPoints);
    map['completed_points'] = Variable<int>(completedPoints);
    if (!nullToAbsent || startLatitude != null) {
      map['start_latitude'] = Variable<double>(startLatitude);
    }
    if (!nullToAbsent || startLongitude != null) {
      map['start_longitude'] = Variable<double>(startLongitude);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PatrolInstancesCompanion toCompanion(bool nullToAbsent) {
    return PatrolInstancesCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      patrolTourId: Value(patrolTourId),
      scheduleId: scheduleId == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      employeeId: Value(employeeId),
      scheduledStart: scheduledStart == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledStart),
      actualStart: actualStart == null && nullToAbsent
          ? const Value.absent()
          : Value(actualStart),
      actualEnd: actualEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEnd),
      status: Value(status),
      totalPoints: Value(totalPoints),
      completedPoints: Value(completedPoints),
      startLatitude: startLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(startLatitude),
      startLongitude: startLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(startLongitude),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PatrolInstance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatrolInstance(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      patrolTourId: serializer.fromJson<String>(json['patrolTourId']),
      scheduleId: serializer.fromJson<String?>(json['scheduleId']),
      shiftId: serializer.fromJson<String?>(json['shiftId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      scheduledStart: serializer.fromJson<DateTime?>(json['scheduledStart']),
      actualStart: serializer.fromJson<DateTime?>(json['actualStart']),
      actualEnd: serializer.fromJson<DateTime?>(json['actualEnd']),
      status: serializer.fromJson<String>(json['status']),
      totalPoints: serializer.fromJson<int>(json['totalPoints']),
      completedPoints: serializer.fromJson<int>(json['completedPoints']),
      startLatitude: serializer.fromJson<double?>(json['startLatitude']),
      startLongitude: serializer.fromJson<double?>(json['startLongitude']),
      notes: serializer.fromJson<String?>(json['notes']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'tenantId': serializer.toJson<String>(tenantId),
      'patrolTourId': serializer.toJson<String>(patrolTourId),
      'scheduleId': serializer.toJson<String?>(scheduleId),
      'shiftId': serializer.toJson<String?>(shiftId),
      'employeeId': serializer.toJson<String>(employeeId),
      'scheduledStart': serializer.toJson<DateTime?>(scheduledStart),
      'actualStart': serializer.toJson<DateTime?>(actualStart),
      'actualEnd': serializer.toJson<DateTime?>(actualEnd),
      'status': serializer.toJson<String>(status),
      'totalPoints': serializer.toJson<int>(totalPoints),
      'completedPoints': serializer.toJson<int>(completedPoints),
      'startLatitude': serializer.toJson<double?>(startLatitude),
      'startLongitude': serializer.toJson<double?>(startLongitude),
      'notes': serializer.toJson<String?>(notes),
      'needsSync': serializer.toJson<bool>(needsSync),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PatrolInstance copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? tenantId,
    String? patrolTourId,
    Value<String?> scheduleId = const Value.absent(),
    Value<String?> shiftId = const Value.absent(),
    String? employeeId,
    Value<DateTime?> scheduledStart = const Value.absent(),
    Value<DateTime?> actualStart = const Value.absent(),
    Value<DateTime?> actualEnd = const Value.absent(),
    String? status,
    int? totalPoints,
    int? completedPoints,
    Value<double?> startLatitude = const Value.absent(),
    Value<double?> startLongitude = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> syncedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PatrolInstance(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    tenantId: tenantId ?? this.tenantId,
    patrolTourId: patrolTourId ?? this.patrolTourId,
    scheduleId: scheduleId.present ? scheduleId.value : this.scheduleId,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    employeeId: employeeId ?? this.employeeId,
    scheduledStart: scheduledStart.present
        ? scheduledStart.value
        : this.scheduledStart,
    actualStart: actualStart.present ? actualStart.value : this.actualStart,
    actualEnd: actualEnd.present ? actualEnd.value : this.actualEnd,
    status: status ?? this.status,
    totalPoints: totalPoints ?? this.totalPoints,
    completedPoints: completedPoints ?? this.completedPoints,
    startLatitude: startLatitude.present
        ? startLatitude.value
        : this.startLatitude,
    startLongitude: startLongitude.present
        ? startLongitude.value
        : this.startLongitude,
    notes: notes.present ? notes.value : this.notes,
    needsSync: needsSync ?? this.needsSync,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PatrolInstance copyWithCompanion(PatrolInstancesCompanion data) {
    return PatrolInstance(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      patrolTourId: data.patrolTourId.present
          ? data.patrolTourId.value
          : this.patrolTourId,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      actualStart: data.actualStart.present
          ? data.actualStart.value
          : this.actualStart,
      actualEnd: data.actualEnd.present ? data.actualEnd.value : this.actualEnd,
      status: data.status.present ? data.status.value : this.status,
      totalPoints: data.totalPoints.present
          ? data.totalPoints.value
          : this.totalPoints,
      completedPoints: data.completedPoints.present
          ? data.completedPoints.value
          : this.completedPoints,
      startLatitude: data.startLatitude.present
          ? data.startLatitude.value
          : this.startLatitude,
      startLongitude: data.startLongitude.present
          ? data.startLongitude.value
          : this.startLongitude,
      notes: data.notes.present ? data.notes.value : this.notes,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatrolInstance(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolTourId: $patrolTourId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('actualStart: $actualStart, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('status: $status, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('completedPoints: $completedPoints, ')
          ..write('startLatitude: $startLatitude, ')
          ..write('startLongitude: $startLongitude, ')
          ..write('notes: $notes, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    tenantId,
    patrolTourId,
    scheduleId,
    shiftId,
    employeeId,
    scheduledStart,
    actualStart,
    actualEnd,
    status,
    totalPoints,
    completedPoints,
    startLatitude,
    startLongitude,
    notes,
    needsSync,
    syncedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatrolInstance &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.patrolTourId == this.patrolTourId &&
          other.scheduleId == this.scheduleId &&
          other.shiftId == this.shiftId &&
          other.employeeId == this.employeeId &&
          other.scheduledStart == this.scheduledStart &&
          other.actualStart == this.actualStart &&
          other.actualEnd == this.actualEnd &&
          other.status == this.status &&
          other.totalPoints == this.totalPoints &&
          other.completedPoints == this.completedPoints &&
          other.startLatitude == this.startLatitude &&
          other.startLongitude == this.startLongitude &&
          other.notes == this.notes &&
          other.needsSync == this.needsSync &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatrolInstancesCompanion extends UpdateCompanion<PatrolInstance> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> tenantId;
  final Value<String> patrolTourId;
  final Value<String?> scheduleId;
  final Value<String?> shiftId;
  final Value<String> employeeId;
  final Value<DateTime?> scheduledStart;
  final Value<DateTime?> actualStart;
  final Value<DateTime?> actualEnd;
  final Value<String> status;
  final Value<int> totalPoints;
  final Value<int> completedPoints;
  final Value<double?> startLatitude;
  final Value<double?> startLongitude;
  final Value<String?> notes;
  final Value<bool> needsSync;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PatrolInstancesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.patrolTourId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.actualStart = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.completedPoints = const Value.absent(),
    this.startLatitude = const Value.absent(),
    this.startLongitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolInstancesCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String tenantId,
    required String patrolTourId,
    this.scheduleId = const Value.absent(),
    this.shiftId = const Value.absent(),
    required String employeeId,
    this.scheduledStart = const Value.absent(),
    this.actualStart = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.completedPoints = const Value.absent(),
    this.startLatitude = const Value.absent(),
    this.startLongitude = const Value.absent(),
    this.notes = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       patrolTourId = Value(patrolTourId),
       employeeId = Value(employeeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PatrolInstance> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? tenantId,
    Expression<String>? patrolTourId,
    Expression<String>? scheduleId,
    Expression<String>? shiftId,
    Expression<String>? employeeId,
    Expression<DateTime>? scheduledStart,
    Expression<DateTime>? actualStart,
    Expression<DateTime>? actualEnd,
    Expression<String>? status,
    Expression<int>? totalPoints,
    Expression<int>? completedPoints,
    Expression<double>? startLatitude,
    Expression<double>? startLongitude,
    Expression<String>? notes,
    Expression<bool>? needsSync,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (patrolTourId != null) 'patrol_tour_id': patrolTourId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (shiftId != null) 'shift_id': shiftId,
      if (employeeId != null) 'employee_id': employeeId,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (actualStart != null) 'actual_start': actualStart,
      if (actualEnd != null) 'actual_end': actualEnd,
      if (status != null) 'status': status,
      if (totalPoints != null) 'total_points': totalPoints,
      if (completedPoints != null) 'completed_points': completedPoints,
      if (startLatitude != null) 'start_latitude': startLatitude,
      if (startLongitude != null) 'start_longitude': startLongitude,
      if (notes != null) 'notes': notes,
      if (needsSync != null) 'needs_sync': needsSync,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolInstancesCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? tenantId,
    Value<String>? patrolTourId,
    Value<String?>? scheduleId,
    Value<String?>? shiftId,
    Value<String>? employeeId,
    Value<DateTime?>? scheduledStart,
    Value<DateTime?>? actualStart,
    Value<DateTime?>? actualEnd,
    Value<String>? status,
    Value<int>? totalPoints,
    Value<int>? completedPoints,
    Value<double?>? startLatitude,
    Value<double?>? startLongitude,
    Value<String?>? notes,
    Value<bool>? needsSync,
    Value<DateTime?>? syncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PatrolInstancesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      patrolTourId: patrolTourId ?? this.patrolTourId,
      scheduleId: scheduleId ?? this.scheduleId,
      shiftId: shiftId ?? this.shiftId,
      employeeId: employeeId ?? this.employeeId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      actualStart: actualStart ?? this.actualStart,
      actualEnd: actualEnd ?? this.actualEnd,
      status: status ?? this.status,
      totalPoints: totalPoints ?? this.totalPoints,
      completedPoints: completedPoints ?? this.completedPoints,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      notes: notes ?? this.notes,
      needsSync: needsSync ?? this.needsSync,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (patrolTourId.present) {
      map['patrol_tour_id'] = Variable<String>(patrolTourId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (actualStart.present) {
      map['actual_start'] = Variable<DateTime>(actualStart.value);
    }
    if (actualEnd.present) {
      map['actual_end'] = Variable<DateTime>(actualEnd.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalPoints.present) {
      map['total_points'] = Variable<int>(totalPoints.value);
    }
    if (completedPoints.present) {
      map['completed_points'] = Variable<int>(completedPoints.value);
    }
    if (startLatitude.present) {
      map['start_latitude'] = Variable<double>(startLatitude.value);
    }
    if (startLongitude.present) {
      map['start_longitude'] = Variable<double>(startLongitude.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolInstancesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolTourId: $patrolTourId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('actualStart: $actualStart, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('status: $status, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('completedPoints: $completedPoints, ')
          ..write('startLatitude: $startLatitude, ')
          ..write('startLongitude: $startLongitude, ')
          ..write('notes: $notes, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolPointCompletionsTable extends PatrolPointCompletions
    with TableInfo<$PatrolPointCompletionsTable, PatrolPointCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolPointCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patrolInstanceIdMeta = const VerificationMeta(
    'patrolInstanceId',
  );
  @override
  late final GeneratedColumn<String> patrolInstanceId = GeneratedColumn<String>(
    'patrol_instance_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patrolPointIdMeta = const VerificationMeta(
    'patrolPointId',
  );
  @override
  late final GeneratedColumn<String> patrolPointId = GeneratedColumn<String>(
    'patrol_point_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivedAtMeta = const VerificationMeta(
    'arrivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> arrivedAt = GeneratedColumn<DateTime>(
    'arrived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scanVerifiedMeta = const VerificationMeta(
    'scanVerified',
  );
  @override
  late final GeneratedColumn<bool> scanVerified = GeneratedColumn<bool>(
    'scan_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("scan_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scanMethodMeta = const VerificationMeta(
    'scanMethod',
  );
  @override
  late final GeneratedColumn<String> scanMethod = GeneratedColumn<String>(
    'scan_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _withinGeofenceMeta = const VerificationMeta(
    'withinGeofence',
  );
  @override
  late final GeneratedColumn<bool> withinGeofence = GeneratedColumn<bool>(
    'within_geofence',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("within_geofence" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _photoLocalPathMeta = const VerificationMeta(
    'photoLocalPath',
  );
  @override
  late final GeneratedColumn<String> photoLocalPath = GeneratedColumn<String>(
    'photo_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    tenantId,
    patrolInstanceId,
    patrolPointId,
    arrivedAt,
    completedAt,
    duration,
    scanVerified,
    scanMethod,
    latitude,
    longitude,
    withinGeofence,
    photoLocalPath,
    photoUrl,
    notes,
    status,
    needsSync,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrol_point_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatrolPointCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('patrol_instance_id')) {
      context.handle(
        _patrolInstanceIdMeta,
        patrolInstanceId.isAcceptableOrUnknown(
          data['patrol_instance_id']!,
          _patrolInstanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patrolInstanceIdMeta);
    }
    if (data.containsKey('patrol_point_id')) {
      context.handle(
        _patrolPointIdMeta,
        patrolPointId.isAcceptableOrUnknown(
          data['patrol_point_id']!,
          _patrolPointIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patrolPointIdMeta);
    }
    if (data.containsKey('arrived_at')) {
      context.handle(
        _arrivedAtMeta,
        arrivedAt.isAcceptableOrUnknown(data['arrived_at']!, _arrivedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('scan_verified')) {
      context.handle(
        _scanVerifiedMeta,
        scanVerified.isAcceptableOrUnknown(
          data['scan_verified']!,
          _scanVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('scan_method')) {
      context.handle(
        _scanMethodMeta,
        scanMethod.isAcceptableOrUnknown(data['scan_method']!, _scanMethodMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('within_geofence')) {
      context.handle(
        _withinGeofenceMeta,
        withinGeofence.isAcceptableOrUnknown(
          data['within_geofence']!,
          _withinGeofenceMeta,
        ),
      );
    }
    if (data.containsKey('photo_local_path')) {
      context.handle(
        _photoLocalPathMeta,
        photoLocalPath.isAcceptableOrUnknown(
          data['photo_local_path']!,
          _photoLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatrolPointCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatrolPointCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      patrolInstanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_instance_id'],
      )!,
      patrolPointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_point_id'],
      )!,
      arrivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrived_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      scanVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}scan_verified'],
      )!,
      scanMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scan_method'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      withinGeofence: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}within_geofence'],
      )!,
      photoLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_local_path'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $PatrolPointCompletionsTable createAlias(String alias) {
    return $PatrolPointCompletionsTable(attachedDatabase, alias);
  }
}

class PatrolPointCompletion extends DataClass
    implements Insertable<PatrolPointCompletion> {
  final String id;
  final String? serverId;
  final String tenantId;
  final String patrolInstanceId;
  final String patrolPointId;
  final DateTime? arrivedAt;
  final DateTime? completedAt;
  final int? duration;
  final bool scanVerified;
  final String? scanMethod;
  final double? latitude;
  final double? longitude;
  final bool withinGeofence;
  final String? photoLocalPath;
  final String? photoUrl;
  final String? notes;
  final String status;
  final bool needsSync;
  final DateTime? syncedAt;
  const PatrolPointCompletion({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.patrolInstanceId,
    required this.patrolPointId,
    this.arrivedAt,
    this.completedAt,
    this.duration,
    required this.scanVerified,
    this.scanMethod,
    this.latitude,
    this.longitude,
    required this.withinGeofence,
    this.photoLocalPath,
    this.photoUrl,
    this.notes,
    required this.status,
    required this.needsSync,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['tenant_id'] = Variable<String>(tenantId);
    map['patrol_instance_id'] = Variable<String>(patrolInstanceId);
    map['patrol_point_id'] = Variable<String>(patrolPointId);
    if (!nullToAbsent || arrivedAt != null) {
      map['arrived_at'] = Variable<DateTime>(arrivedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    map['scan_verified'] = Variable<bool>(scanVerified);
    if (!nullToAbsent || scanMethod != null) {
      map['scan_method'] = Variable<String>(scanMethod);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['within_geofence'] = Variable<bool>(withinGeofence);
    if (!nullToAbsent || photoLocalPath != null) {
      map['photo_local_path'] = Variable<String>(photoLocalPath);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PatrolPointCompletionsCompanion toCompanion(bool nullToAbsent) {
    return PatrolPointCompletionsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      patrolInstanceId: Value(patrolInstanceId),
      patrolPointId: Value(patrolPointId),
      arrivedAt: arrivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      scanVerified: Value(scanVerified),
      scanMethod: scanMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(scanMethod),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      withinGeofence: Value(withinGeofence),
      photoLocalPath: photoLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoLocalPath),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PatrolPointCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatrolPointCompletion(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      patrolInstanceId: serializer.fromJson<String>(json['patrolInstanceId']),
      patrolPointId: serializer.fromJson<String>(json['patrolPointId']),
      arrivedAt: serializer.fromJson<DateTime?>(json['arrivedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      duration: serializer.fromJson<int?>(json['duration']),
      scanVerified: serializer.fromJson<bool>(json['scanVerified']),
      scanMethod: serializer.fromJson<String?>(json['scanMethod']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      withinGeofence: serializer.fromJson<bool>(json['withinGeofence']),
      photoLocalPath: serializer.fromJson<String?>(json['photoLocalPath']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'tenantId': serializer.toJson<String>(tenantId),
      'patrolInstanceId': serializer.toJson<String>(patrolInstanceId),
      'patrolPointId': serializer.toJson<String>(patrolPointId),
      'arrivedAt': serializer.toJson<DateTime?>(arrivedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'duration': serializer.toJson<int?>(duration),
      'scanVerified': serializer.toJson<bool>(scanVerified),
      'scanMethod': serializer.toJson<String?>(scanMethod),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'withinGeofence': serializer.toJson<bool>(withinGeofence),
      'photoLocalPath': serializer.toJson<String?>(photoLocalPath),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'needsSync': serializer.toJson<bool>(needsSync),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PatrolPointCompletion copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? tenantId,
    String? patrolInstanceId,
    String? patrolPointId,
    Value<DateTime?> arrivedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    bool? scanVerified,
    Value<String?> scanMethod = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    bool? withinGeofence,
    Value<String?> photoLocalPath = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? status,
    bool? needsSync,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => PatrolPointCompletion(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    tenantId: tenantId ?? this.tenantId,
    patrolInstanceId: patrolInstanceId ?? this.patrolInstanceId,
    patrolPointId: patrolPointId ?? this.patrolPointId,
    arrivedAt: arrivedAt.present ? arrivedAt.value : this.arrivedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    duration: duration.present ? duration.value : this.duration,
    scanVerified: scanVerified ?? this.scanVerified,
    scanMethod: scanMethod.present ? scanMethod.value : this.scanMethod,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    withinGeofence: withinGeofence ?? this.withinGeofence,
    photoLocalPath: photoLocalPath.present
        ? photoLocalPath.value
        : this.photoLocalPath,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    needsSync: needsSync ?? this.needsSync,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  PatrolPointCompletion copyWithCompanion(
    PatrolPointCompletionsCompanion data,
  ) {
    return PatrolPointCompletion(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      patrolInstanceId: data.patrolInstanceId.present
          ? data.patrolInstanceId.value
          : this.patrolInstanceId,
      patrolPointId: data.patrolPointId.present
          ? data.patrolPointId.value
          : this.patrolPointId,
      arrivedAt: data.arrivedAt.present ? data.arrivedAt.value : this.arrivedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      duration: data.duration.present ? data.duration.value : this.duration,
      scanVerified: data.scanVerified.present
          ? data.scanVerified.value
          : this.scanVerified,
      scanMethod: data.scanMethod.present
          ? data.scanMethod.value
          : this.scanMethod,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      withinGeofence: data.withinGeofence.present
          ? data.withinGeofence.value
          : this.withinGeofence,
      photoLocalPath: data.photoLocalPath.present
          ? data.photoLocalPath.value
          : this.photoLocalPath,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatrolPointCompletion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolInstanceId: $patrolInstanceId, ')
          ..write('patrolPointId: $patrolPointId, ')
          ..write('arrivedAt: $arrivedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('duration: $duration, ')
          ..write('scanVerified: $scanVerified, ')
          ..write('scanMethod: $scanMethod, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('withinGeofence: $withinGeofence, ')
          ..write('photoLocalPath: $photoLocalPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    tenantId,
    patrolInstanceId,
    patrolPointId,
    arrivedAt,
    completedAt,
    duration,
    scanVerified,
    scanMethod,
    latitude,
    longitude,
    withinGeofence,
    photoLocalPath,
    photoUrl,
    notes,
    status,
    needsSync,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatrolPointCompletion &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.patrolInstanceId == this.patrolInstanceId &&
          other.patrolPointId == this.patrolPointId &&
          other.arrivedAt == this.arrivedAt &&
          other.completedAt == this.completedAt &&
          other.duration == this.duration &&
          other.scanVerified == this.scanVerified &&
          other.scanMethod == this.scanMethod &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.withinGeofence == this.withinGeofence &&
          other.photoLocalPath == this.photoLocalPath &&
          other.photoUrl == this.photoUrl &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.needsSync == this.needsSync &&
          other.syncedAt == this.syncedAt);
}

class PatrolPointCompletionsCompanion
    extends UpdateCompanion<PatrolPointCompletion> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> tenantId;
  final Value<String> patrolInstanceId;
  final Value<String> patrolPointId;
  final Value<DateTime?> arrivedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> duration;
  final Value<bool> scanVerified;
  final Value<String?> scanMethod;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> withinGeofence;
  final Value<String?> photoLocalPath;
  final Value<String?> photoUrl;
  final Value<String?> notes;
  final Value<String> status;
  final Value<bool> needsSync;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PatrolPointCompletionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.patrolInstanceId = const Value.absent(),
    this.patrolPointId = const Value.absent(),
    this.arrivedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.duration = const Value.absent(),
    this.scanVerified = const Value.absent(),
    this.scanMethod = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.withinGeofence = const Value.absent(),
    this.photoLocalPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolPointCompletionsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String tenantId,
    required String patrolInstanceId,
    required String patrolPointId,
    this.arrivedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.duration = const Value.absent(),
    this.scanVerified = const Value.absent(),
    this.scanMethod = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.withinGeofence = const Value.absent(),
    this.photoLocalPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       patrolInstanceId = Value(patrolInstanceId),
       patrolPointId = Value(patrolPointId);
  static Insertable<PatrolPointCompletion> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? tenantId,
    Expression<String>? patrolInstanceId,
    Expression<String>? patrolPointId,
    Expression<DateTime>? arrivedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? duration,
    Expression<bool>? scanVerified,
    Expression<String>? scanMethod,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? withinGeofence,
    Expression<String>? photoLocalPath,
    Expression<String>? photoUrl,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<bool>? needsSync,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (patrolInstanceId != null) 'patrol_instance_id': patrolInstanceId,
      if (patrolPointId != null) 'patrol_point_id': patrolPointId,
      if (arrivedAt != null) 'arrived_at': arrivedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (duration != null) 'duration': duration,
      if (scanVerified != null) 'scan_verified': scanVerified,
      if (scanMethod != null) 'scan_method': scanMethod,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (withinGeofence != null) 'within_geofence': withinGeofence,
      if (photoLocalPath != null) 'photo_local_path': photoLocalPath,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (needsSync != null) 'needs_sync': needsSync,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolPointCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? tenantId,
    Value<String>? patrolInstanceId,
    Value<String>? patrolPointId,
    Value<DateTime?>? arrivedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? duration,
    Value<bool>? scanVerified,
    Value<String?>? scanMethod,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<bool>? withinGeofence,
    Value<String?>? photoLocalPath,
    Value<String?>? photoUrl,
    Value<String?>? notes,
    Value<String>? status,
    Value<bool>? needsSync,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return PatrolPointCompletionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      patrolInstanceId: patrolInstanceId ?? this.patrolInstanceId,
      patrolPointId: patrolPointId ?? this.patrolPointId,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
      scanVerified: scanVerified ?? this.scanVerified,
      scanMethod: scanMethod ?? this.scanMethod,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      withinGeofence: withinGeofence ?? this.withinGeofence,
      photoLocalPath: photoLocalPath ?? this.photoLocalPath,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      needsSync: needsSync ?? this.needsSync,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (patrolInstanceId.present) {
      map['patrol_instance_id'] = Variable<String>(patrolInstanceId.value);
    }
    if (patrolPointId.present) {
      map['patrol_point_id'] = Variable<String>(patrolPointId.value);
    }
    if (arrivedAt.present) {
      map['arrived_at'] = Variable<DateTime>(arrivedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (scanVerified.present) {
      map['scan_verified'] = Variable<bool>(scanVerified.value);
    }
    if (scanMethod.present) {
      map['scan_method'] = Variable<String>(scanMethod.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (withinGeofence.present) {
      map['within_geofence'] = Variable<bool>(withinGeofence.value);
    }
    if (photoLocalPath.present) {
      map['photo_local_path'] = Variable<String>(photoLocalPath.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolPointCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('patrolInstanceId: $patrolInstanceId, ')
          ..write('patrolPointId: $patrolPointId, ')
          ..write('arrivedAt: $arrivedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('duration: $duration, ')
          ..write('scanVerified: $scanVerified, ')
          ..write('scanMethod: $scanMethod, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('withinGeofence: $withinGeofence, ')
          ..write('photoLocalPath: $photoLocalPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatrolTaskResponsesTable extends PatrolTaskResponses
    with TableInfo<$PatrolTaskResponsesTable, PatrolTaskResponse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatrolTaskResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointCompletionIdMeta = const VerificationMeta(
    'pointCompletionId',
  );
  @override
  late final GeneratedColumn<String> pointCompletionId =
      GeneratedColumn<String>(
        'point_completion_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _patrolTaskIdMeta = const VerificationMeta(
    'patrolTaskId',
  );
  @override
  late final GeneratedColumn<String> patrolTaskId = GeneratedColumn<String>(
    'patrol_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseValueMeta = const VerificationMeta(
    'responseValue',
  );
  @override
  late final GeneratedColumn<String> responseValue = GeneratedColumn<String>(
    'response_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    tenantId,
    pointCompletionId,
    patrolTaskId,
    responseValue,
    isCompleted,
    completedAt,
    needsSync,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patrol_task_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatrolTaskResponse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('point_completion_id')) {
      context.handle(
        _pointCompletionIdMeta,
        pointCompletionId.isAcceptableOrUnknown(
          data['point_completion_id']!,
          _pointCompletionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pointCompletionIdMeta);
    }
    if (data.containsKey('patrol_task_id')) {
      context.handle(
        _patrolTaskIdMeta,
        patrolTaskId.isAcceptableOrUnknown(
          data['patrol_task_id']!,
          _patrolTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patrolTaskIdMeta);
    }
    if (data.containsKey('response_value')) {
      context.handle(
        _responseValueMeta,
        responseValue.isAcceptableOrUnknown(
          data['response_value']!,
          _responseValueMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatrolTaskResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatrolTaskResponse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      pointCompletionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_completion_id'],
      )!,
      patrolTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patrol_task_id'],
      )!,
      responseValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_value'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $PatrolTaskResponsesTable createAlias(String alias) {
    return $PatrolTaskResponsesTable(attachedDatabase, alias);
  }
}

class PatrolTaskResponse extends DataClass
    implements Insertable<PatrolTaskResponse> {
  final String id;
  final String? serverId;
  final String tenantId;
  final String pointCompletionId;
  final String patrolTaskId;
  final String? responseValue;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool needsSync;
  final DateTime? syncedAt;
  const PatrolTaskResponse({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.pointCompletionId,
    required this.patrolTaskId,
    this.responseValue,
    required this.isCompleted,
    this.completedAt,
    required this.needsSync,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['tenant_id'] = Variable<String>(tenantId);
    map['point_completion_id'] = Variable<String>(pointCompletionId);
    map['patrol_task_id'] = Variable<String>(patrolTaskId);
    if (!nullToAbsent || responseValue != null) {
      map['response_value'] = Variable<String>(responseValue);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PatrolTaskResponsesCompanion toCompanion(bool nullToAbsent) {
    return PatrolTaskResponsesCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      pointCompletionId: Value(pointCompletionId),
      patrolTaskId: Value(patrolTaskId),
      responseValue: responseValue == null && nullToAbsent
          ? const Value.absent()
          : Value(responseValue),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PatrolTaskResponse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatrolTaskResponse(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      pointCompletionId: serializer.fromJson<String>(json['pointCompletionId']),
      patrolTaskId: serializer.fromJson<String>(json['patrolTaskId']),
      responseValue: serializer.fromJson<String?>(json['responseValue']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'tenantId': serializer.toJson<String>(tenantId),
      'pointCompletionId': serializer.toJson<String>(pointCompletionId),
      'patrolTaskId': serializer.toJson<String>(patrolTaskId),
      'responseValue': serializer.toJson<String?>(responseValue),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'needsSync': serializer.toJson<bool>(needsSync),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PatrolTaskResponse copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? tenantId,
    String? pointCompletionId,
    String? patrolTaskId,
    Value<String?> responseValue = const Value.absent(),
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => PatrolTaskResponse(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    tenantId: tenantId ?? this.tenantId,
    pointCompletionId: pointCompletionId ?? this.pointCompletionId,
    patrolTaskId: patrolTaskId ?? this.patrolTaskId,
    responseValue: responseValue.present
        ? responseValue.value
        : this.responseValue,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    needsSync: needsSync ?? this.needsSync,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  PatrolTaskResponse copyWithCompanion(PatrolTaskResponsesCompanion data) {
    return PatrolTaskResponse(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      pointCompletionId: data.pointCompletionId.present
          ? data.pointCompletionId.value
          : this.pointCompletionId,
      patrolTaskId: data.patrolTaskId.present
          ? data.patrolTaskId.value
          : this.patrolTaskId,
      responseValue: data.responseValue.present
          ? data.responseValue.value
          : this.responseValue,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTaskResponse(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('pointCompletionId: $pointCompletionId, ')
          ..write('patrolTaskId: $patrolTaskId, ')
          ..write('responseValue: $responseValue, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    tenantId,
    pointCompletionId,
    patrolTaskId,
    responseValue,
    isCompleted,
    completedAt,
    needsSync,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatrolTaskResponse &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.pointCompletionId == this.pointCompletionId &&
          other.patrolTaskId == this.patrolTaskId &&
          other.responseValue == this.responseValue &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.needsSync == this.needsSync &&
          other.syncedAt == this.syncedAt);
}

class PatrolTaskResponsesCompanion extends UpdateCompanion<PatrolTaskResponse> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> tenantId;
  final Value<String> pointCompletionId;
  final Value<String> patrolTaskId;
  final Value<String?> responseValue;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<bool> needsSync;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PatrolTaskResponsesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.pointCompletionId = const Value.absent(),
    this.patrolTaskId = const Value.absent(),
    this.responseValue = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatrolTaskResponsesCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String tenantId,
    required String pointCompletionId,
    required String patrolTaskId,
    this.responseValue = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       pointCompletionId = Value(pointCompletionId),
       patrolTaskId = Value(patrolTaskId);
  static Insertable<PatrolTaskResponse> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? tenantId,
    Expression<String>? pointCompletionId,
    Expression<String>? patrolTaskId,
    Expression<String>? responseValue,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<bool>? needsSync,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (pointCompletionId != null) 'point_completion_id': pointCompletionId,
      if (patrolTaskId != null) 'patrol_task_id': patrolTaskId,
      if (responseValue != null) 'response_value': responseValue,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatrolTaskResponsesCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? tenantId,
    Value<String>? pointCompletionId,
    Value<String>? patrolTaskId,
    Value<String?>? responseValue,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<bool>? needsSync,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return PatrolTaskResponsesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      pointCompletionId: pointCompletionId ?? this.pointCompletionId,
      patrolTaskId: patrolTaskId ?? this.patrolTaskId,
      responseValue: responseValue ?? this.responseValue,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      needsSync: needsSync ?? this.needsSync,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (pointCompletionId.present) {
      map['point_completion_id'] = Variable<String>(pointCompletionId.value);
    }
    if (patrolTaskId.present) {
      map['patrol_task_id'] = Variable<String>(patrolTaskId.value);
    }
    if (responseValue.present) {
      map['response_value'] = Variable<String>(responseValue.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatrolTaskResponsesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('pointCompletionId: $pointCompletionId, ')
          ..write('patrolTaskId: $patrolTaskId, ')
          ..write('responseValue: $responseValue, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEventsTable extends OutboxEvents
    with TableInfo<$OutboxEventsTable, OutboxEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    tenantId,
    type,
    entityType,
    entityId,
    payloadJson,
    createdAt,
    status,
    retryCount,
    publishedAt,
    lastError,
    nextRetryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  OutboxEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEvent(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
    );
  }

  @override
  $OutboxEventsTable createAlias(String alias) {
    return $OutboxEventsTable(attachedDatabase, alias);
  }
}

class OutboxEvent extends DataClass implements Insertable<OutboxEvent> {
  final String eventId;
  final String tenantId;
  final String type;
  final String? entityType;
  final String? entityId;
  final String payloadJson;
  final DateTime createdAt;
  final String status;
  final int retryCount;
  final DateTime? publishedAt;
  final String? lastError;
  final DateTime? nextRetryAt;
  const OutboxEvent({
    required this.eventId,
    required this.tenantId,
    required this.type,
    this.entityType,
    this.entityId,
    required this.payloadJson,
    required this.createdAt,
    required this.status,
    required this.retryCount,
    this.publishedAt,
    this.lastError,
    this.nextRetryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['tenant_id'] = Variable<String>(tenantId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  OutboxEventsCompanion toCompanion(bool nullToAbsent) {
    return OutboxEventsCompanion(
      eventId: Value(eventId),
      tenantId: Value(tenantId),
      type: Value(type),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      status: Value(status),
      retryCount: Value(retryCount),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory OutboxEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEvent(
      eventId: serializer.fromJson<String>(json['eventId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      type: serializer.fromJson<String>(json['type']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'tenantId': serializer.toJson<String>(tenantId),
      'type': serializer.toJson<String>(type),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'lastError': serializer.toJson<String?>(lastError),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  OutboxEvent copyWith({
    String? eventId,
    String? tenantId,
    String? type,
    Value<String?> entityType = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    String? payloadJson,
    DateTime? createdAt,
    String? status,
    int? retryCount,
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> nextRetryAt = const Value.absent(),
  }) => OutboxEvent(
    eventId: eventId ?? this.eventId,
    tenantId: tenantId ?? this.tenantId,
    type: type ?? this.type,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
  );
  OutboxEvent copyWithCompanion(OutboxEventsCompanion data) {
    return OutboxEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      type: data.type.present ? data.type.value : this.type,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEvent(')
          ..write('eventId: $eventId, ')
          ..write('tenantId: $tenantId, ')
          ..write('type: $type, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('lastError: $lastError, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    tenantId,
    type,
    entityType,
    entityId,
    payloadJson,
    createdAt,
    status,
    retryCount,
    publishedAt,
    lastError,
    nextRetryAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEvent &&
          other.eventId == this.eventId &&
          other.tenantId == this.tenantId &&
          other.type == this.type &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.publishedAt == this.publishedAt &&
          other.lastError == this.lastError &&
          other.nextRetryAt == this.nextRetryAt);
}

class OutboxEventsCompanion extends UpdateCompanion<OutboxEvent> {
  final Value<String> eventId;
  final Value<String> tenantId;
  final Value<String> type;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime?> publishedAt;
  final Value<String?> lastError;
  final Value<DateTime?> nextRetryAt;
  final Value<int> rowid;
  const OutboxEventsCompanion({
    this.eventId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.type = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEventsCompanion.insert({
    required String eventId,
    required String tenantId,
    required String type,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    required String payloadJson,
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       tenantId = Value(tenantId),
       type = Value(type),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<OutboxEvent> custom({
    Expression<String>? eventId,
    Expression<String>? tenantId,
    Expression<String>? type,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? publishedAt,
    Expression<String>? lastError,
    Expression<DateTime>? nextRetryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (type != null) 'type': type,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (publishedAt != null) 'published_at': publishedAt,
      if (lastError != null) 'last_error': lastError,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEventsCompanion copyWith({
    Value<String>? eventId,
    Value<String>? tenantId,
    Value<String>? type,
    Value<String?>? entityType,
    Value<String?>? entityId,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime?>? publishedAt,
    Value<String?>? lastError,
    Value<DateTime?>? nextRetryAt,
    Value<int>? rowid,
  }) {
    return OutboxEventsCompanion(
      eventId: eventId ?? this.eventId,
      tenantId: tenantId ?? this.tenantId,
      type: type ?? this.type,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      publishedAt: publishedAt ?? this.publishedAt,
      lastError: lastError ?? this.lastError,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('tenantId: $tenantId, ')
          ..write('type: $type, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('lastError: $lastError, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _watermarkMeta = const VerificationMeta(
    'watermark',
  );
  @override
  late final GeneratedColumn<String> watermark = GeneratedColumn<String>(
    'watermark',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordsSyncedMeta = const VerificationMeta(
    'recordsSynced',
  );
  @override
  late final GeneratedColumn<int> recordsSynced = GeneratedColumn<int>(
    'records_synced',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('idle'),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entity,
    tenantId,
    watermark,
    lastSyncAt,
    recordsSynced,
    syncStatus,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('watermark')) {
      context.handle(
        _watermarkMeta,
        watermark.isAcceptableOrUnknown(data['watermark']!, _watermarkMeta),
      );
    } else if (isInserting) {
      context.missing(_watermarkMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncAtMeta);
    }
    if (data.containsKey('records_synced')) {
      context.handle(
        _recordsSyncedMeta,
        recordsSynced.isAcceptableOrUnknown(
          data['records_synced']!,
          _recordsSyncedMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entity, tenantId};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      watermark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}watermark'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      )!,
      recordsSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_synced'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String entity;
  final String tenantId;
  final String watermark;
  final DateTime lastSyncAt;
  final int recordsSynced;
  final String syncStatus;
  final String? lastError;
  const SyncStateData({
    required this.entity,
    required this.tenantId,
    required this.watermark,
    required this.lastSyncAt,
    required this.recordsSynced,
    required this.syncStatus,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity'] = Variable<String>(entity);
    map['tenant_id'] = Variable<String>(tenantId);
    map['watermark'] = Variable<String>(watermark);
    map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    map['records_synced'] = Variable<int>(recordsSynced);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      entity: Value(entity),
      tenantId: Value(tenantId),
      watermark: Value(watermark),
      lastSyncAt: Value(lastSyncAt),
      recordsSynced: Value(recordsSynced),
      syncStatus: Value(syncStatus),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      entity: serializer.fromJson<String>(json['entity']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      watermark: serializer.fromJson<String>(json['watermark']),
      lastSyncAt: serializer.fromJson<DateTime>(json['lastSyncAt']),
      recordsSynced: serializer.fromJson<int>(json['recordsSynced']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity': serializer.toJson<String>(entity),
      'tenantId': serializer.toJson<String>(tenantId),
      'watermark': serializer.toJson<String>(watermark),
      'lastSyncAt': serializer.toJson<DateTime>(lastSyncAt),
      'recordsSynced': serializer.toJson<int>(recordsSynced),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncStateData copyWith({
    String? entity,
    String? tenantId,
    String? watermark,
    DateTime? lastSyncAt,
    int? recordsSynced,
    String? syncStatus,
    Value<String?> lastError = const Value.absent(),
  }) => SyncStateData(
    entity: entity ?? this.entity,
    tenantId: tenantId ?? this.tenantId,
    watermark: watermark ?? this.watermark,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    recordsSynced: recordsSynced ?? this.recordsSynced,
    syncStatus: syncStatus ?? this.syncStatus,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      entity: data.entity.present ? data.entity.value : this.entity,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      watermark: data.watermark.present ? data.watermark.value : this.watermark,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      recordsSynced: data.recordsSynced.present
          ? data.recordsSynced.value
          : this.recordsSynced,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('entity: $entity, ')
          ..write('tenantId: $tenantId, ')
          ..write('watermark: $watermark, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('recordsSynced: $recordsSynced, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entity,
    tenantId,
    watermark,
    lastSyncAt,
    recordsSynced,
    syncStatus,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.entity == this.entity &&
          other.tenantId == this.tenantId &&
          other.watermark == this.watermark &&
          other.lastSyncAt == this.lastSyncAt &&
          other.recordsSynced == this.recordsSynced &&
          other.syncStatus == this.syncStatus &&
          other.lastError == this.lastError);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> entity;
  final Value<String> tenantId;
  final Value<String> watermark;
  final Value<DateTime> lastSyncAt;
  final Value<int> recordsSynced;
  final Value<String> syncStatus;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.entity = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.watermark = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.recordsSynced = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String entity,
    required String tenantId,
    required String watermark,
    required DateTime lastSyncAt,
    this.recordsSynced = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entity = Value(entity),
       tenantId = Value(tenantId),
       watermark = Value(watermark),
       lastSyncAt = Value(lastSyncAt);
  static Insertable<SyncStateData> custom({
    Expression<String>? entity,
    Expression<String>? tenantId,
    Expression<String>? watermark,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? recordsSynced,
    Expression<String>? syncStatus,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entity != null) 'entity': entity,
      if (tenantId != null) 'tenant_id': tenantId,
      if (watermark != null) 'watermark': watermark,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (recordsSynced != null) 'records_synced': recordsSynced,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? entity,
    Value<String>? tenantId,
    Value<String>? watermark,
    Value<DateTime>? lastSyncAt,
    Value<int>? recordsSynced,
    Value<String>? syncStatus,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      entity: entity ?? this.entity,
      tenantId: tenantId ?? this.tenantId,
      watermark: watermark ?? this.watermark,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      recordsSynced: recordsSynced ?? this.recordsSynced,
      syncStatus: syncStatus ?? this.syncStatus,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (watermark.present) {
      map['watermark'] = Variable<String>(watermark.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (recordsSynced.present) {
      map['records_synced'] = Variable<int>(recordsSynced.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('entity: $entity, ')
          ..write('tenantId: $tenantId, ')
          ..write('watermark: $watermark, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('recordsSynced: $recordsSynced, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InAppNotificationsTable extends InAppNotifications
    with TableInfo<$InAppNotificationsTable, InAppNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InAppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _relatedEntityTypeMeta = const VerificationMeta(
    'relatedEntityType',
  );
  @override
  late final GeneratedColumn<String> relatedEntityType =
      GeneratedColumn<String>(
        'related_entity_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _relatedEntityIdMeta = const VerificationMeta(
    'relatedEntityId',
  );
  @override
  late final GeneratedColumn<String> relatedEntityId = GeneratedColumn<String>(
    'related_entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconTypeMeta = const VerificationMeta(
    'iconType',
  );
  @override
  late final GeneratedColumn<String> iconType = GeneratedColumn<String>(
    'icon_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionLabelMeta = const VerificationMeta(
    'actionLabel',
  );
  @override
  late final GeneratedColumn<String> actionLabel = GeneratedColumn<String>(
    'action_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionRouteMeta = const VerificationMeta(
    'actionRoute',
  );
  @override
  late final GeneratedColumn<String> actionRoute = GeneratedColumn<String>(
    'action_route',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    tenantId,
    employeeId,
    title,
    body,
    type,
    priority,
    relatedEntityType,
    relatedEntityId,
    iconType,
    actionLabel,
    actionRoute,
    isRead,
    isArchived,
    isDismissed,
    receivedAt,
    readAt,
    expiresAt,
    needsSync,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'in_app_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<InAppNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('related_entity_type')) {
      context.handle(
        _relatedEntityTypeMeta,
        relatedEntityType.isAcceptableOrUnknown(
          data['related_entity_type']!,
          _relatedEntityTypeMeta,
        ),
      );
    }
    if (data.containsKey('related_entity_id')) {
      context.handle(
        _relatedEntityIdMeta,
        relatedEntityId.isAcceptableOrUnknown(
          data['related_entity_id']!,
          _relatedEntityIdMeta,
        ),
      );
    }
    if (data.containsKey('icon_type')) {
      context.handle(
        _iconTypeMeta,
        iconType.isAcceptableOrUnknown(data['icon_type']!, _iconTypeMeta),
      );
    }
    if (data.containsKey('action_label')) {
      context.handle(
        _actionLabelMeta,
        actionLabel.isAcceptableOrUnknown(
          data['action_label']!,
          _actionLabelMeta,
        ),
      );
    }
    if (data.containsKey('action_route')) {
      context.handle(
        _actionRouteMeta,
        actionRoute.isAcceptableOrUnknown(
          data['action_route']!,
          _actionRouteMeta,
        ),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InAppNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InAppNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      relatedEntityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_entity_type'],
      ),
      relatedEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_entity_id'],
      ),
      iconType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_type'],
      ),
      actionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_label'],
      ),
      actionRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_route'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      needsSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_sync'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $InAppNotificationsTable createAlias(String alias) {
    return $InAppNotificationsTable(attachedDatabase, alias);
  }
}

class InAppNotification extends DataClass
    implements Insertable<InAppNotification> {
  final String id;
  final String? serverId;
  final String tenantId;
  final String employeeId;
  final String title;
  final String body;
  final String type;
  final String priority;
  final String? relatedEntityType;
  final String? relatedEntityId;
  final String? iconType;
  final String? actionLabel;
  final String? actionRoute;
  final bool isRead;
  final bool isArchived;
  final bool isDismissed;
  final DateTime receivedAt;
  final DateTime? readAt;
  final DateTime? expiresAt;
  final bool needsSync;
  final DateTime? syncedAt;
  const InAppNotification({
    required this.id,
    this.serverId,
    required this.tenantId,
    required this.employeeId,
    required this.title,
    required this.body,
    required this.type,
    required this.priority,
    this.relatedEntityType,
    this.relatedEntityId,
    this.iconType,
    this.actionLabel,
    this.actionRoute,
    required this.isRead,
    required this.isArchived,
    required this.isDismissed,
    required this.receivedAt,
    this.readAt,
    this.expiresAt,
    required this.needsSync,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['tenant_id'] = Variable<String>(tenantId);
    map['employee_id'] = Variable<String>(employeeId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['type'] = Variable<String>(type);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || relatedEntityType != null) {
      map['related_entity_type'] = Variable<String>(relatedEntityType);
    }
    if (!nullToAbsent || relatedEntityId != null) {
      map['related_entity_id'] = Variable<String>(relatedEntityId);
    }
    if (!nullToAbsent || iconType != null) {
      map['icon_type'] = Variable<String>(iconType);
    }
    if (!nullToAbsent || actionLabel != null) {
      map['action_label'] = Variable<String>(actionLabel);
    }
    if (!nullToAbsent || actionRoute != null) {
      map['action_route'] = Variable<String>(actionRoute);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    map['received_at'] = Variable<DateTime>(receivedAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  InAppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return InAppNotificationsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      employeeId: Value(employeeId),
      title: Value(title),
      body: Value(body),
      type: Value(type),
      priority: Value(priority),
      relatedEntityType: relatedEntityType == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedEntityType),
      relatedEntityId: relatedEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedEntityId),
      iconType: iconType == null && nullToAbsent
          ? const Value.absent()
          : Value(iconType),
      actionLabel: actionLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(actionLabel),
      actionRoute: actionRoute == null && nullToAbsent
          ? const Value.absent()
          : Value(actionRoute),
      isRead: Value(isRead),
      isArchived: Value(isArchived),
      isDismissed: Value(isDismissed),
      receivedAt: Value(receivedAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      needsSync: Value(needsSync),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory InAppNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InAppNotification(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      type: serializer.fromJson<String>(json['type']),
      priority: serializer.fromJson<String>(json['priority']),
      relatedEntityType: serializer.fromJson<String?>(
        json['relatedEntityType'],
      ),
      relatedEntityId: serializer.fromJson<String?>(json['relatedEntityId']),
      iconType: serializer.fromJson<String?>(json['iconType']),
      actionLabel: serializer.fromJson<String?>(json['actionLabel']),
      actionRoute: serializer.fromJson<String?>(json['actionRoute']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'tenantId': serializer.toJson<String>(tenantId),
      'employeeId': serializer.toJson<String>(employeeId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'type': serializer.toJson<String>(type),
      'priority': serializer.toJson<String>(priority),
      'relatedEntityType': serializer.toJson<String?>(relatedEntityType),
      'relatedEntityId': serializer.toJson<String?>(relatedEntityId),
      'iconType': serializer.toJson<String?>(iconType),
      'actionLabel': serializer.toJson<String?>(actionLabel),
      'actionRoute': serializer.toJson<String?>(actionRoute),
      'isRead': serializer.toJson<bool>(isRead),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isDismissed': serializer.toJson<bool>(isDismissed),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'needsSync': serializer.toJson<bool>(needsSync),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  InAppNotification copyWith({
    String? id,
    Value<String?> serverId = const Value.absent(),
    String? tenantId,
    String? employeeId,
    String? title,
    String? body,
    String? type,
    String? priority,
    Value<String?> relatedEntityType = const Value.absent(),
    Value<String?> relatedEntityId = const Value.absent(),
    Value<String?> iconType = const Value.absent(),
    Value<String?> actionLabel = const Value.absent(),
    Value<String?> actionRoute = const Value.absent(),
    bool? isRead,
    bool? isArchived,
    bool? isDismissed,
    DateTime? receivedAt,
    Value<DateTime?> readAt = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    bool? needsSync,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => InAppNotification(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    tenantId: tenantId ?? this.tenantId,
    employeeId: employeeId ?? this.employeeId,
    title: title ?? this.title,
    body: body ?? this.body,
    type: type ?? this.type,
    priority: priority ?? this.priority,
    relatedEntityType: relatedEntityType.present
        ? relatedEntityType.value
        : this.relatedEntityType,
    relatedEntityId: relatedEntityId.present
        ? relatedEntityId.value
        : this.relatedEntityId,
    iconType: iconType.present ? iconType.value : this.iconType,
    actionLabel: actionLabel.present ? actionLabel.value : this.actionLabel,
    actionRoute: actionRoute.present ? actionRoute.value : this.actionRoute,
    isRead: isRead ?? this.isRead,
    isArchived: isArchived ?? this.isArchived,
    isDismissed: isDismissed ?? this.isDismissed,
    receivedAt: receivedAt ?? this.receivedAt,
    readAt: readAt.present ? readAt.value : this.readAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    needsSync: needsSync ?? this.needsSync,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  InAppNotification copyWithCompanion(InAppNotificationsCompanion data) {
    return InAppNotification(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      type: data.type.present ? data.type.value : this.type,
      priority: data.priority.present ? data.priority.value : this.priority,
      relatedEntityType: data.relatedEntityType.present
          ? data.relatedEntityType.value
          : this.relatedEntityType,
      relatedEntityId: data.relatedEntityId.present
          ? data.relatedEntityId.value
          : this.relatedEntityId,
      iconType: data.iconType.present ? data.iconType.value : this.iconType,
      actionLabel: data.actionLabel.present
          ? data.actionLabel.value
          : this.actionLabel,
      actionRoute: data.actionRoute.present
          ? data.actionRoute.value
          : this.actionRoute,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InAppNotification(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('employeeId: $employeeId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('relatedEntityType: $relatedEntityType, ')
          ..write('relatedEntityId: $relatedEntityId, ')
          ..write('iconType: $iconType, ')
          ..write('actionLabel: $actionLabel, ')
          ..write('actionRoute: $actionRoute, ')
          ..write('isRead: $isRead, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('readAt: $readAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    tenantId,
    employeeId,
    title,
    body,
    type,
    priority,
    relatedEntityType,
    relatedEntityId,
    iconType,
    actionLabel,
    actionRoute,
    isRead,
    isArchived,
    isDismissed,
    receivedAt,
    readAt,
    expiresAt,
    needsSync,
    syncedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InAppNotification &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.employeeId == this.employeeId &&
          other.title == this.title &&
          other.body == this.body &&
          other.type == this.type &&
          other.priority == this.priority &&
          other.relatedEntityType == this.relatedEntityType &&
          other.relatedEntityId == this.relatedEntityId &&
          other.iconType == this.iconType &&
          other.actionLabel == this.actionLabel &&
          other.actionRoute == this.actionRoute &&
          other.isRead == this.isRead &&
          other.isArchived == this.isArchived &&
          other.isDismissed == this.isDismissed &&
          other.receivedAt == this.receivedAt &&
          other.readAt == this.readAt &&
          other.expiresAt == this.expiresAt &&
          other.needsSync == this.needsSync &&
          other.syncedAt == this.syncedAt);
}

class InAppNotificationsCompanion extends UpdateCompanion<InAppNotification> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> tenantId;
  final Value<String> employeeId;
  final Value<String> title;
  final Value<String> body;
  final Value<String> type;
  final Value<String> priority;
  final Value<String?> relatedEntityType;
  final Value<String?> relatedEntityId;
  final Value<String?> iconType;
  final Value<String?> actionLabel;
  final Value<String?> actionRoute;
  final Value<bool> isRead;
  final Value<bool> isArchived;
  final Value<bool> isDismissed;
  final Value<DateTime> receivedAt;
  final Value<DateTime?> readAt;
  final Value<DateTime?> expiresAt;
  final Value<bool> needsSync;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const InAppNotificationsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.relatedEntityType = const Value.absent(),
    this.relatedEntityId = const Value.absent(),
    this.iconType = const Value.absent(),
    this.actionLabel = const Value.absent(),
    this.actionRoute = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InAppNotificationsCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String tenantId,
    required String employeeId,
    required String title,
    required String body,
    required String type,
    this.priority = const Value.absent(),
    this.relatedEntityType = const Value.absent(),
    this.relatedEntityId = const Value.absent(),
    this.iconType = const Value.absent(),
    this.actionLabel = const Value.absent(),
    this.actionRoute = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDismissed = const Value.absent(),
    required DateTime receivedAt,
    this.readAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.needsSync = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       employeeId = Value(employeeId),
       title = Value(title),
       body = Value(body),
       type = Value(type),
       receivedAt = Value(receivedAt);
  static Insertable<InAppNotification> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? tenantId,
    Expression<String>? employeeId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? type,
    Expression<String>? priority,
    Expression<String>? relatedEntityType,
    Expression<String>? relatedEntityId,
    Expression<String>? iconType,
    Expression<String>? actionLabel,
    Expression<String>? actionRoute,
    Expression<bool>? isRead,
    Expression<bool>? isArchived,
    Expression<bool>? isDismissed,
    Expression<DateTime>? receivedAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? expiresAt,
    Expression<bool>? needsSync,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (employeeId != null) 'employee_id': employeeId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (relatedEntityType != null) 'related_entity_type': relatedEntityType,
      if (relatedEntityId != null) 'related_entity_id': relatedEntityId,
      if (iconType != null) 'icon_type': iconType,
      if (actionLabel != null) 'action_label': actionLabel,
      if (actionRoute != null) 'action_route': actionRoute,
      if (isRead != null) 'is_read': isRead,
      if (isArchived != null) 'is_archived': isArchived,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (receivedAt != null) 'received_at': receivedAt,
      if (readAt != null) 'read_at': readAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (needsSync != null) 'needs_sync': needsSync,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InAppNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? serverId,
    Value<String>? tenantId,
    Value<String>? employeeId,
    Value<String>? title,
    Value<String>? body,
    Value<String>? type,
    Value<String>? priority,
    Value<String?>? relatedEntityType,
    Value<String?>? relatedEntityId,
    Value<String?>? iconType,
    Value<String?>? actionLabel,
    Value<String?>? actionRoute,
    Value<bool>? isRead,
    Value<bool>? isArchived,
    Value<bool>? isDismissed,
    Value<DateTime>? receivedAt,
    Value<DateTime?>? readAt,
    Value<DateTime?>? expiresAt,
    Value<bool>? needsSync,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return InAppNotificationsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      employeeId: employeeId ?? this.employeeId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      iconType: iconType ?? this.iconType,
      actionLabel: actionLabel ?? this.actionLabel,
      actionRoute: actionRoute ?? this.actionRoute,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      isDismissed: isDismissed ?? this.isDismissed,
      receivedAt: receivedAt ?? this.receivedAt,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt ?? this.expiresAt,
      needsSync: needsSync ?? this.needsSync,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (relatedEntityType.present) {
      map['related_entity_type'] = Variable<String>(relatedEntityType.value);
    }
    if (relatedEntityId.present) {
      map['related_entity_id'] = Variable<String>(relatedEntityId.value);
    }
    if (iconType.present) {
      map['icon_type'] = Variable<String>(iconType.value);
    }
    if (actionLabel.present) {
      map['action_label'] = Variable<String>(actionLabel.value);
    }
    if (actionRoute.present) {
      map['action_route'] = Variable<String>(actionRoute.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InAppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('employeeId: $employeeId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('relatedEntityType: $relatedEntityType, ')
          ..write('relatedEntityId: $relatedEntityId, ')
          ..write('iconType: $iconType, ')
          ..write('actionLabel: $actionLabel, ')
          ..write('actionRoute: $actionRoute, ')
          ..write('isRead: $isRead, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('readAt: $readAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('needsSync: $needsSync, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TenantConfigTable tenantConfig = $TenantConfigTable(this);
  late final $AppConfigTable appConfig = $AppConfigTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $AttendancesTable attendances = $AttendancesTable(this);
  late final $LocationLogsTable locationLogs = $LocationLogsTable(this);
  late final $CheckCallsTable checkCalls = $CheckCallsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $IncidentReportsTable incidentReports = $IncidentReportsTable(
    this,
  );
  late final $PatrolsTable patrols = $PatrolsTable(this);
  late final $CheckpointsTable checkpoints = $CheckpointsTable(this);
  late final $PatrolToursTable patrolTours = $PatrolToursTable(this);
  late final $PatrolTourPointsTable patrolTourPoints = $PatrolTourPointsTable(
    this,
  );
  late final $PatrolTasksTable patrolTasks = $PatrolTasksTable(this);
  late final $PatrolInstancesTable patrolInstances = $PatrolInstancesTable(
    this,
  );
  late final $PatrolPointCompletionsTable patrolPointCompletions =
      $PatrolPointCompletionsTable(this);
  late final $PatrolTaskResponsesTable patrolTaskResponses =
      $PatrolTaskResponsesTable(this);
  late final $OutboxEventsTable outboxEvents = $OutboxEventsTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $InAppNotificationsTable inAppNotifications =
      $InAppNotificationsTable(this);
  late final TenantConfigDao tenantConfigDao = TenantConfigDao(
    this as AppDatabase,
  );
  late final ShiftsDao shiftsDao = ShiftsDao(this as AppDatabase);
  late final AttendancesDao attendancesDao = AttendancesDao(
    this as AppDatabase,
  );
  late final LocationLogsDao locationLogsDao = LocationLogsDao(
    this as AppDatabase,
  );
  late final CheckCallsDao checkCallsDao = CheckCallsDao(this as AppDatabase);
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  late final IncidentReportsDao incidentReportsDao = IncidentReportsDao(
    this as AppDatabase,
  );
  late final PatrolsDao patrolsDao = PatrolsDao(this as AppDatabase);
  late final PatrolToursDao patrolToursDao = PatrolToursDao(
    this as AppDatabase,
  );
  late final PatrolInstancesDao patrolInstancesDao = PatrolInstancesDao(
    this as AppDatabase,
  );
  late final OutboxDao outboxDao = OutboxDao(this as AppDatabase);
  late final InAppNotificationsDao inAppNotificationsDao =
      InAppNotificationsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tenantConfig,
    appConfig,
    shifts,
    attendances,
    locationLogs,
    checkCalls,
    syncQueue,
    incidentReports,
    patrols,
    checkpoints,
    patrolTours,
    patrolTourPoints,
    patrolTasks,
    patrolInstances,
    patrolPointCompletions,
    patrolTaskResponses,
    outboxEvents,
    syncState,
    inAppNotifications,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$TenantConfigTableCreateCompanionBuilder =
    TenantConfigCompanion Function({
      Value<int> id,
      required String tenantId,
      required String tenantName,
      Value<String?> tenantCode,
      required String apiBaseUrl,
      required String wsBaseUrl,
      Value<String> environment,
      Value<String?> brandingJson,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TenantConfigTableUpdateCompanionBuilder =
    TenantConfigCompanion Function({
      Value<int> id,
      Value<String> tenantId,
      Value<String> tenantName,
      Value<String?> tenantCode,
      Value<String> apiBaseUrl,
      Value<String> wsBaseUrl,
      Value<String> environment,
      Value<String?> brandingJson,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TenantConfigTableFilterComposer
    extends Composer<_$AppDatabase, $TenantConfigTable> {
  $$TenantConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantName => $composableBuilder(
    column: $table.tenantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantCode => $composableBuilder(
    column: $table.tenantCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiBaseUrl => $composableBuilder(
    column: $table.apiBaseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wsBaseUrl => $composableBuilder(
    column: $table.wsBaseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandingJson => $composableBuilder(
    column: $table.brandingJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TenantConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantConfigTable> {
  $$TenantConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantName => $composableBuilder(
    column: $table.tenantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantCode => $composableBuilder(
    column: $table.tenantCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiBaseUrl => $composableBuilder(
    column: $table.apiBaseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wsBaseUrl => $composableBuilder(
    column: $table.wsBaseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandingJson => $composableBuilder(
    column: $table.brandingJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantConfigTable> {
  $$TenantConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get tenantName => $composableBuilder(
    column: $table.tenantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tenantCode => $composableBuilder(
    column: $table.tenantCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apiBaseUrl => $composableBuilder(
    column: $table.apiBaseUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wsBaseUrl =>
      $composableBuilder(column: $table.wsBaseUrl, builder: (column) => column);

  GeneratedColumn<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandingJson => $composableBuilder(
    column: $table.brandingJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TenantConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantConfigTable,
          TenantConfigData,
          $$TenantConfigTableFilterComposer,
          $$TenantConfigTableOrderingComposer,
          $$TenantConfigTableAnnotationComposer,
          $$TenantConfigTableCreateCompanionBuilder,
          $$TenantConfigTableUpdateCompanionBuilder,
          (
            TenantConfigData,
            BaseReferences<_$AppDatabase, $TenantConfigTable, TenantConfigData>,
          ),
          TenantConfigData,
          PrefetchHooks Function()
        > {
  $$TenantConfigTableTableManager(_$AppDatabase db, $TenantConfigTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> tenantName = const Value.absent(),
                Value<String?> tenantCode = const Value.absent(),
                Value<String> apiBaseUrl = const Value.absent(),
                Value<String> wsBaseUrl = const Value.absent(),
                Value<String> environment = const Value.absent(),
                Value<String?> brandingJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TenantConfigCompanion(
                id: id,
                tenantId: tenantId,
                tenantName: tenantName,
                tenantCode: tenantCode,
                apiBaseUrl: apiBaseUrl,
                wsBaseUrl: wsBaseUrl,
                environment: environment,
                brandingJson: brandingJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tenantId,
                required String tenantName,
                Value<String?> tenantCode = const Value.absent(),
                required String apiBaseUrl,
                required String wsBaseUrl,
                Value<String> environment = const Value.absent(),
                Value<String?> brandingJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TenantConfigCompanion.insert(
                id: id,
                tenantId: tenantId,
                tenantName: tenantName,
                tenantCode: tenantCode,
                apiBaseUrl: apiBaseUrl,
                wsBaseUrl: wsBaseUrl,
                environment: environment,
                brandingJson: brandingJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TenantConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantConfigTable,
      TenantConfigData,
      $$TenantConfigTableFilterComposer,
      $$TenantConfigTableOrderingComposer,
      $$TenantConfigTableAnnotationComposer,
      $$TenantConfigTableCreateCompanionBuilder,
      $$TenantConfigTableUpdateCompanionBuilder,
      (
        TenantConfigData,
        BaseReferences<_$AppDatabase, $TenantConfigTable, TenantConfigData>,
      ),
      TenantConfigData,
      PrefetchHooks Function()
    >;
typedef $$AppConfigTableCreateCompanionBuilder =
    AppConfigCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppConfigTableUpdateCompanionBuilder =
    AppConfigCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppConfigTableFilterComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppConfigTable> {
  $$AppConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppConfigTable,
          AppConfigData,
          $$AppConfigTableFilterComposer,
          $$AppConfigTableOrderingComposer,
          $$AppConfigTableAnnotationComposer,
          $$AppConfigTableCreateCompanionBuilder,
          $$AppConfigTableUpdateCompanionBuilder,
          (
            AppConfigData,
            BaseReferences<_$AppDatabase, $AppConfigTable, AppConfigData>,
          ),
          AppConfigData,
          PrefetchHooks Function()
        > {
  $$AppConfigTableTableManager(_$AppDatabase db, $AppConfigTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConfigCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConfigCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppConfigTable,
      AppConfigData,
      $$AppConfigTableFilterComposer,
      $$AppConfigTableOrderingComposer,
      $$AppConfigTableAnnotationComposer,
      $$AppConfigTableCreateCompanionBuilder,
      $$AppConfigTableUpdateCompanionBuilder,
      (
        AppConfigData,
        BaseReferences<_$AppDatabase, $AppConfigTable, AppConfigData>,
      ),
      AppConfigData,
      PrefetchHooks Function()
    >;
typedef $$ShiftsTableCreateCompanionBuilder =
    ShiftsCompanion Function({
      required String id,
      required String tenantId,
      required String employeeId,
      required String siteId,
      required String clientId,
      required String siteName,
      required String siteAddress,
      Value<double?> siteLatitude,
      Value<double?> siteLongitude,
      required String clientName,
      required DateTime shiftDate,
      required DateTime startTime,
      required DateTime endTime,
      Value<int> breakMinutes,
      Value<String> status,
      Value<bool> checkCallEnabled,
      Value<int?> checkCallFrequency,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$ShiftsTableUpdateCompanionBuilder =
    ShiftsCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> employeeId,
      Value<String> siteId,
      Value<String> clientId,
      Value<String> siteName,
      Value<String> siteAddress,
      Value<double?> siteLatitude,
      Value<double?> siteLongitude,
      Value<String> clientName,
      Value<DateTime> shiftDate,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int> breakMinutes,
      Value<String> status,
      Value<bool> checkCallEnabled,
      Value<int?> checkCallFrequency,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteName => $composableBuilder(
    column: $table.siteName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteAddress => $composableBuilder(
    column: $table.siteAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get siteLatitude => $composableBuilder(
    column: $table.siteLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get siteLongitude => $composableBuilder(
    column: $table.siteLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checkCallEnabled => $composableBuilder(
    column: $table.checkCallEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkCallFrequency => $composableBuilder(
    column: $table.checkCallFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteName => $composableBuilder(
    column: $table.siteName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteAddress => $composableBuilder(
    column: $table.siteAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get siteLatitude => $composableBuilder(
    column: $table.siteLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get siteLongitude => $composableBuilder(
    column: $table.siteLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get shiftDate => $composableBuilder(
    column: $table.shiftDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checkCallEnabled => $composableBuilder(
    column: $table.checkCallEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkCallFrequency => $composableBuilder(
    column: $table.checkCallFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get siteName =>
      $composableBuilder(column: $table.siteName, builder: (column) => column);

  GeneratedColumn<String> get siteAddress => $composableBuilder(
    column: $table.siteAddress,
    builder: (column) => column,
  );

  GeneratedColumn<double> get siteLatitude => $composableBuilder(
    column: $table.siteLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get siteLongitude => $composableBuilder(
    column: $table.siteLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get shiftDate =>
      $composableBuilder(column: $table.shiftDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get checkCallEnabled => $composableBuilder(
    column: $table.checkCallEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get checkCallFrequency => $composableBuilder(
    column: $table.checkCallFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$ShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftsTable,
          Shift,
          $$ShiftsTableFilterComposer,
          $$ShiftsTableOrderingComposer,
          $$ShiftsTableAnnotationComposer,
          $$ShiftsTableCreateCompanionBuilder,
          $$ShiftsTableUpdateCompanionBuilder,
          (Shift, BaseReferences<_$AppDatabase, $ShiftsTable, Shift>),
          Shift,
          PrefetchHooks Function()
        > {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> siteId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> siteName = const Value.absent(),
                Value<String> siteAddress = const Value.absent(),
                Value<double?> siteLatitude = const Value.absent(),
                Value<double?> siteLongitude = const Value.absent(),
                Value<String> clientName = const Value.absent(),
                Value<DateTime> shiftDate = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> checkCallEnabled = const Value.absent(),
                Value<int?> checkCallFrequency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                tenantId: tenantId,
                employeeId: employeeId,
                siteId: siteId,
                clientId: clientId,
                siteName: siteName,
                siteAddress: siteAddress,
                siteLatitude: siteLatitude,
                siteLongitude: siteLongitude,
                clientName: clientName,
                shiftDate: shiftDate,
                startTime: startTime,
                endTime: endTime,
                breakMinutes: breakMinutes,
                status: status,
                checkCallEnabled: checkCallEnabled,
                checkCallFrequency: checkCallFrequency,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String employeeId,
                required String siteId,
                required String clientId,
                required String siteName,
                required String siteAddress,
                Value<double?> siteLatitude = const Value.absent(),
                Value<double?> siteLongitude = const Value.absent(),
                required String clientName,
                required DateTime shiftDate,
                required DateTime startTime,
                required DateTime endTime,
                Value<int> breakMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> checkCallEnabled = const Value.absent(),
                Value<int?> checkCallFrequency = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion.insert(
                id: id,
                tenantId: tenantId,
                employeeId: employeeId,
                siteId: siteId,
                clientId: clientId,
                siteName: siteName,
                siteAddress: siteAddress,
                siteLatitude: siteLatitude,
                siteLongitude: siteLongitude,
                clientName: clientName,
                shiftDate: shiftDate,
                startTime: startTime,
                endTime: endTime,
                breakMinutes: breakMinutes,
                status: status,
                checkCallEnabled: checkCallEnabled,
                checkCallFrequency: checkCallFrequency,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftsTable,
      Shift,
      $$ShiftsTableFilterComposer,
      $$ShiftsTableOrderingComposer,
      $$ShiftsTableAnnotationComposer,
      $$ShiftsTableCreateCompanionBuilder,
      $$ShiftsTableUpdateCompanionBuilder,
      (Shift, BaseReferences<_$AppDatabase, $ShiftsTable, Shift>),
      Shift,
      PrefetchHooks Function()
    >;
typedef $$AttendancesTableCreateCompanionBuilder =
    AttendancesCompanion Function({
      required String id,
      required String shiftId,
      required String employeeId,
      required String tenantId,
      Value<DateTime?> bookOnTime,
      Value<double?> bookOnLatitude,
      Value<double?> bookOnLongitude,
      Value<String?> bookOnMethod,
      Value<DateTime?> bookOffTime,
      Value<double?> bookOffLatitude,
      Value<double?> bookOffLongitude,
      Value<String?> bookOffMethod,
      Value<String> status,
      Value<double?> totalHours,
      Value<bool> isLate,
      Value<int?> lateMinutes,
      Value<bool> autoBookedOff,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$AttendancesTableUpdateCompanionBuilder =
    AttendancesCompanion Function({
      Value<String> id,
      Value<String> shiftId,
      Value<String> employeeId,
      Value<String> tenantId,
      Value<DateTime?> bookOnTime,
      Value<double?> bookOnLatitude,
      Value<double?> bookOnLongitude,
      Value<String?> bookOnMethod,
      Value<DateTime?> bookOffTime,
      Value<double?> bookOffLatitude,
      Value<double?> bookOffLongitude,
      Value<String?> bookOffMethod,
      Value<String> status,
      Value<double?> totalHours,
      Value<bool> isLate,
      Value<int?> lateMinutes,
      Value<bool> autoBookedOff,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

class $$AttendancesTableFilterComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bookOnTime => $composableBuilder(
    column: $table.bookOnTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bookOnLatitude => $composableBuilder(
    column: $table.bookOnLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bookOnLongitude => $composableBuilder(
    column: $table.bookOnLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookOnMethod => $composableBuilder(
    column: $table.bookOnMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bookOffTime => $composableBuilder(
    column: $table.bookOffTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bookOffLatitude => $composableBuilder(
    column: $table.bookOffLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bookOffLongitude => $composableBuilder(
    column: $table.bookOffLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookOffMethod => $composableBuilder(
    column: $table.bookOffMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLate => $composableBuilder(
    column: $table.isLate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lateMinutes => $composableBuilder(
    column: $table.lateMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoBookedOff => $composableBuilder(
    column: $table.autoBookedOff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendancesTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bookOnTime => $composableBuilder(
    column: $table.bookOnTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bookOnLatitude => $composableBuilder(
    column: $table.bookOnLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bookOnLongitude => $composableBuilder(
    column: $table.bookOnLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookOnMethod => $composableBuilder(
    column: $table.bookOnMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bookOffTime => $composableBuilder(
    column: $table.bookOffTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bookOffLatitude => $composableBuilder(
    column: $table.bookOffLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bookOffLongitude => $composableBuilder(
    column: $table.bookOffLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookOffMethod => $composableBuilder(
    column: $table.bookOffMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLate => $composableBuilder(
    column: $table.isLate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lateMinutes => $composableBuilder(
    column: $table.lateMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoBookedOff => $composableBuilder(
    column: $table.autoBookedOff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<DateTime> get bookOnTime => $composableBuilder(
    column: $table.bookOnTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bookOnLatitude => $composableBuilder(
    column: $table.bookOnLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bookOnLongitude => $composableBuilder(
    column: $table.bookOnLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookOnMethod => $composableBuilder(
    column: $table.bookOnMethod,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get bookOffTime => $composableBuilder(
    column: $table.bookOffTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bookOffLatitude => $composableBuilder(
    column: $table.bookOffLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bookOffLongitude => $composableBuilder(
    column: $table.bookOffLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookOffMethod => $composableBuilder(
    column: $table.bookOffMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLate =>
      $composableBuilder(column: $table.isLate, builder: (column) => column);

  GeneratedColumn<int> get lateMinutes => $composableBuilder(
    column: $table.lateMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoBookedOff => $composableBuilder(
    column: $table.autoBookedOff,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$AttendancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendancesTable,
          Attendance,
          $$AttendancesTableFilterComposer,
          $$AttendancesTableOrderingComposer,
          $$AttendancesTableAnnotationComposer,
          $$AttendancesTableCreateCompanionBuilder,
          $$AttendancesTableUpdateCompanionBuilder,
          (
            Attendance,
            BaseReferences<_$AppDatabase, $AttendancesTable, Attendance>,
          ),
          Attendance,
          PrefetchHooks Function()
        > {
  $$AttendancesTableTableManager(_$AppDatabase db, $AttendancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<DateTime?> bookOnTime = const Value.absent(),
                Value<double?> bookOnLatitude = const Value.absent(),
                Value<double?> bookOnLongitude = const Value.absent(),
                Value<String?> bookOnMethod = const Value.absent(),
                Value<DateTime?> bookOffTime = const Value.absent(),
                Value<double?> bookOffLatitude = const Value.absent(),
                Value<double?> bookOffLongitude = const Value.absent(),
                Value<String?> bookOffMethod = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> totalHours = const Value.absent(),
                Value<bool> isLate = const Value.absent(),
                Value<int?> lateMinutes = const Value.absent(),
                Value<bool> autoBookedOff = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesCompanion(
                id: id,
                shiftId: shiftId,
                employeeId: employeeId,
                tenantId: tenantId,
                bookOnTime: bookOnTime,
                bookOnLatitude: bookOnLatitude,
                bookOnLongitude: bookOnLongitude,
                bookOnMethod: bookOnMethod,
                bookOffTime: bookOffTime,
                bookOffLatitude: bookOffLatitude,
                bookOffLongitude: bookOffLongitude,
                bookOffMethod: bookOffMethod,
                status: status,
                totalHours: totalHours,
                isLate: isLate,
                lateMinutes: lateMinutes,
                autoBookedOff: autoBookedOff,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shiftId,
                required String employeeId,
                required String tenantId,
                Value<DateTime?> bookOnTime = const Value.absent(),
                Value<double?> bookOnLatitude = const Value.absent(),
                Value<double?> bookOnLongitude = const Value.absent(),
                Value<String?> bookOnMethod = const Value.absent(),
                Value<DateTime?> bookOffTime = const Value.absent(),
                Value<double?> bookOffLatitude = const Value.absent(),
                Value<double?> bookOffLongitude = const Value.absent(),
                Value<String?> bookOffMethod = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> totalHours = const Value.absent(),
                Value<bool> isLate = const Value.absent(),
                Value<int?> lateMinutes = const Value.absent(),
                Value<bool> autoBookedOff = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesCompanion.insert(
                id: id,
                shiftId: shiftId,
                employeeId: employeeId,
                tenantId: tenantId,
                bookOnTime: bookOnTime,
                bookOnLatitude: bookOnLatitude,
                bookOnLongitude: bookOnLongitude,
                bookOnMethod: bookOnMethod,
                bookOffTime: bookOffTime,
                bookOffLatitude: bookOffLatitude,
                bookOffLongitude: bookOffLongitude,
                bookOffMethod: bookOffMethod,
                status: status,
                totalHours: totalHours,
                isLate: isLate,
                lateMinutes: lateMinutes,
                autoBookedOff: autoBookedOff,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendancesTable,
      Attendance,
      $$AttendancesTableFilterComposer,
      $$AttendancesTableOrderingComposer,
      $$AttendancesTableAnnotationComposer,
      $$AttendancesTableCreateCompanionBuilder,
      $$AttendancesTableUpdateCompanionBuilder,
      (
        Attendance,
        BaseReferences<_$AppDatabase, $AttendancesTable, Attendance>,
      ),
      Attendance,
      PrefetchHooks Function()
    >;
typedef $$LocationLogsTableCreateCompanionBuilder =
    LocationLogsCompanion Function({
      required String id,
      required String employeeId,
      Value<String?> shiftId,
      required String tenantId,
      required double latitude,
      required double longitude,
      Value<double?> accuracy,
      Value<double?> altitude,
      Value<double?> speed,
      required DateTime timestamp,
      Value<DateTime?> syncedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$LocationLogsTableUpdateCompanionBuilder =
    LocationLogsCompanion Function({
      Value<String> id,
      Value<String> employeeId,
      Value<String?> shiftId,
      Value<String> tenantId,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> accuracy,
      Value<double?> altitude,
      Value<double?> speed,
      Value<DateTime> timestamp,
      Value<DateTime?> syncedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

class $$LocationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationLogsTable> {
  $$LocationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationLogsTable> {
  $$LocationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationLogsTable> {
  $$LocationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$LocationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationLogsTable,
          LocationLog,
          $$LocationLogsTableFilterComposer,
          $$LocationLogsTableOrderingComposer,
          $$LocationLogsTableAnnotationComposer,
          $$LocationLogsTableCreateCompanionBuilder,
          $$LocationLogsTableUpdateCompanionBuilder,
          (
            LocationLog,
            BaseReferences<_$AppDatabase, $LocationLogsTable, LocationLog>,
          ),
          LocationLog,
          PrefetchHooks Function()
        > {
  $$LocationLogsTableTableManager(_$AppDatabase db, $LocationLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String?> shiftId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationLogsCompanion(
                id: id,
                employeeId: employeeId,
                shiftId: shiftId,
                tenantId: tenantId,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                altitude: altitude,
                speed: speed,
                timestamp: timestamp,
                syncedAt: syncedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String employeeId,
                Value<String?> shiftId = const Value.absent(),
                required String tenantId,
                required double latitude,
                required double longitude,
                Value<double?> accuracy = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                required DateTime timestamp,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationLogsCompanion.insert(
                id: id,
                employeeId: employeeId,
                shiftId: shiftId,
                tenantId: tenantId,
                latitude: latitude,
                longitude: longitude,
                accuracy: accuracy,
                altitude: altitude,
                speed: speed,
                timestamp: timestamp,
                syncedAt: syncedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationLogsTable,
      LocationLog,
      $$LocationLogsTableFilterComposer,
      $$LocationLogsTableOrderingComposer,
      $$LocationLogsTableAnnotationComposer,
      $$LocationLogsTableCreateCompanionBuilder,
      $$LocationLogsTableUpdateCompanionBuilder,
      (
        LocationLog,
        BaseReferences<_$AppDatabase, $LocationLogsTable, LocationLog>,
      ),
      LocationLog,
      PrefetchHooks Function()
    >;
typedef $$CheckCallsTableCreateCompanionBuilder =
    CheckCallsCompanion Function({
      required String id,
      required String shiftId,
      required String employeeId,
      required String tenantId,
      required DateTime scheduledTime,
      Value<DateTime?> respondedAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String> status,
      Value<String?> notes,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });
typedef $$CheckCallsTableUpdateCompanionBuilder =
    CheckCallsCompanion Function({
      Value<String> id,
      Value<String> shiftId,
      Value<String> employeeId,
      Value<String> tenantId,
      Value<DateTime> scheduledTime,
      Value<DateTime?> respondedAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<bool> needsSync,
      Value<int> rowid,
    });

class $$CheckCallsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckCallsTable> {
  $$CheckCallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckCallsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckCallsTable> {
  $$CheckCallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckCallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckCallsTable> {
  $$CheckCallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$CheckCallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckCallsTable,
          CheckCall,
          $$CheckCallsTableFilterComposer,
          $$CheckCallsTableOrderingComposer,
          $$CheckCallsTableAnnotationComposer,
          $$CheckCallsTableCreateCompanionBuilder,
          $$CheckCallsTableUpdateCompanionBuilder,
          (
            CheckCall,
            BaseReferences<_$AppDatabase, $CheckCallsTable, CheckCall>,
          ),
          CheckCall,
          PrefetchHooks Function()
        > {
  $$CheckCallsTableTableManager(_$AppDatabase db, $CheckCallsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckCallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckCallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckCallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<DateTime> scheduledTime = const Value.absent(),
                Value<DateTime?> respondedAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckCallsCompanion(
                id: id,
                shiftId: shiftId,
                employeeId: employeeId,
                tenantId: tenantId,
                scheduledTime: scheduledTime,
                respondedAt: respondedAt,
                latitude: latitude,
                longitude: longitude,
                status: status,
                notes: notes,
                createdAt: createdAt,
                syncedAt: syncedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shiftId,
                required String employeeId,
                required String tenantId,
                required DateTime scheduledTime,
                Value<DateTime?> respondedAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckCallsCompanion.insert(
                id: id,
                shiftId: shiftId,
                employeeId: employeeId,
                tenantId: tenantId,
                scheduledTime: scheduledTime,
                respondedAt: respondedAt,
                latitude: latitude,
                longitude: longitude,
                status: status,
                notes: notes,
                createdAt: createdAt,
                syncedAt: syncedAt,
                needsSync: needsSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckCallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckCallsTable,
      CheckCall,
      $$CheckCallsTableFilterComposer,
      $$CheckCallsTableOrderingComposer,
      $$CheckCallsTableAnnotationComposer,
      $$CheckCallsTableCreateCompanionBuilder,
      $$CheckCallsTableUpdateCompanionBuilder,
      (CheckCall, BaseReferences<_$AppDatabase, $CheckCallsTable, CheckCall>),
      CheckCall,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String operation,
      required String endpoint,
      required String method,
      required String payload,
      Value<int> priority,
      Value<int> retryCount,
      Value<int> maxRetries,
      Value<String> status,
      Value<String?> errorMessage,
      Value<String?> entityType,
      Value<String?> entityId,
      required DateTime createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> operation,
      Value<String> endpoint,
      Value<String> method,
      Value<String> payload,
      Value<int> priority,
      Value<int> retryCount,
      Value<int> maxRetries,
      Value<String> status,
      Value<String?> errorMessage,
      Value<String?> entityType,
      Value<String?> entityId,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> endpoint = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> maxRetries = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                operation: operation,
                endpoint: endpoint,
                method: method,
                payload: payload,
                priority: priority,
                retryCount: retryCount,
                maxRetries: maxRetries,
                status: status,
                errorMessage: errorMessage,
                entityType: entityType,
                entityId: entityId,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operation,
                required String endpoint,
                required String method,
                required String payload,
                Value<int> priority = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> maxRetries = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                operation: operation,
                endpoint: endpoint,
                method: method,
                payload: payload,
                priority: priority,
                retryCount: retryCount,
                maxRetries: maxRetries,
                status: status,
                errorMessage: errorMessage,
                entityType: entityType,
                entityId: entityId,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$IncidentReportsTableCreateCompanionBuilder =
    IncidentReportsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String shiftId,
      required String siteId,
      required String employeeId,
      required String tenantId,
      required String title,
      required DateTime incidentDate,
      required DateTime reportTime,
      required double latitude,
      required double longitude,
      Value<String?> location,
      required String incidentType,
      required String description,
      required String severity,
      Value<String?> actionTaken,
      Value<bool> policeNotified,
      Value<String?> policeRef,
      Value<String?> mediaFilePaths,
      Value<String?> mediaUrls,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$IncidentReportsTableUpdateCompanionBuilder =
    IncidentReportsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> shiftId,
      Value<String> siteId,
      Value<String> employeeId,
      Value<String> tenantId,
      Value<String> title,
      Value<DateTime> incidentDate,
      Value<DateTime> reportTime,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> location,
      Value<String> incidentType,
      Value<String> description,
      Value<String> severity,
      Value<String?> actionTaken,
      Value<bool> policeNotified,
      Value<String?> policeRef,
      Value<String?> mediaFilePaths,
      Value<String?> mediaUrls,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$IncidentReportsTableFilterComposer
    extends Composer<_$AppDatabase, $IncidentReportsTable> {
  $$IncidentReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reportTime => $composableBuilder(
    column: $table.reportTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incidentType => $composableBuilder(
    column: $table.incidentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get policeNotified => $composableBuilder(
    column: $table.policeNotified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get policeRef => $composableBuilder(
    column: $table.policeRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaFilePaths => $composableBuilder(
    column: $table.mediaFilePaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrls => $composableBuilder(
    column: $table.mediaUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IncidentReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $IncidentReportsTable> {
  $$IncidentReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reportTime => $composableBuilder(
    column: $table.reportTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incidentType => $composableBuilder(
    column: $table.incidentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get policeNotified => $composableBuilder(
    column: $table.policeNotified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get policeRef => $composableBuilder(
    column: $table.policeRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaFilePaths => $composableBuilder(
    column: $table.mediaFilePaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrls => $composableBuilder(
    column: $table.mediaUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncidentReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidentReportsTable> {
  $$IncidentReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get incidentDate => $composableBuilder(
    column: $table.incidentDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reportTime => $composableBuilder(
    column: $table.reportTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get incidentType => $composableBuilder(
    column: $table.incidentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get policeNotified => $composableBuilder(
    column: $table.policeNotified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get policeRef =>
      $composableBuilder(column: $table.policeRef, builder: (column) => column);

  GeneratedColumn<String> get mediaFilePaths => $composableBuilder(
    column: $table.mediaFilePaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaUrls =>
      $composableBuilder(column: $table.mediaUrls, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$IncidentReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncidentReportsTable,
          IncidentReport,
          $$IncidentReportsTableFilterComposer,
          $$IncidentReportsTableOrderingComposer,
          $$IncidentReportsTableAnnotationComposer,
          $$IncidentReportsTableCreateCompanionBuilder,
          $$IncidentReportsTableUpdateCompanionBuilder,
          (
            IncidentReport,
            BaseReferences<
              _$AppDatabase,
              $IncidentReportsTable,
              IncidentReport
            >,
          ),
          IncidentReport,
          PrefetchHooks Function()
        > {
  $$IncidentReportsTableTableManager(
    _$AppDatabase db,
    $IncidentReportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidentReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncidentReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncidentReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> siteId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> incidentDate = const Value.absent(),
                Value<DateTime> reportTime = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String> incidentType = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> actionTaken = const Value.absent(),
                Value<bool> policeNotified = const Value.absent(),
                Value<String?> policeRef = const Value.absent(),
                Value<String?> mediaFilePaths = const Value.absent(),
                Value<String?> mediaUrls = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncidentReportsCompanion(
                id: id,
                serverId: serverId,
                shiftId: shiftId,
                siteId: siteId,
                employeeId: employeeId,
                tenantId: tenantId,
                title: title,
                incidentDate: incidentDate,
                reportTime: reportTime,
                latitude: latitude,
                longitude: longitude,
                location: location,
                incidentType: incidentType,
                description: description,
                severity: severity,
                actionTaken: actionTaken,
                policeNotified: policeNotified,
                policeRef: policeRef,
                mediaFilePaths: mediaFilePaths,
                mediaUrls: mediaUrls,
                needsSync: needsSync,
                syncedAt: syncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String shiftId,
                required String siteId,
                required String employeeId,
                required String tenantId,
                required String title,
                required DateTime incidentDate,
                required DateTime reportTime,
                required double latitude,
                required double longitude,
                Value<String?> location = const Value.absent(),
                required String incidentType,
                required String description,
                required String severity,
                Value<String?> actionTaken = const Value.absent(),
                Value<bool> policeNotified = const Value.absent(),
                Value<String?> policeRef = const Value.absent(),
                Value<String?> mediaFilePaths = const Value.absent(),
                Value<String?> mediaUrls = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncidentReportsCompanion.insert(
                id: id,
                serverId: serverId,
                shiftId: shiftId,
                siteId: siteId,
                employeeId: employeeId,
                tenantId: tenantId,
                title: title,
                incidentDate: incidentDate,
                reportTime: reportTime,
                latitude: latitude,
                longitude: longitude,
                location: location,
                incidentType: incidentType,
                description: description,
                severity: severity,
                actionTaken: actionTaken,
                policeNotified: policeNotified,
                policeRef: policeRef,
                mediaFilePaths: mediaFilePaths,
                mediaUrls: mediaUrls,
                needsSync: needsSync,
                syncedAt: syncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IncidentReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncidentReportsTable,
      IncidentReport,
      $$IncidentReportsTableFilterComposer,
      $$IncidentReportsTableOrderingComposer,
      $$IncidentReportsTableAnnotationComposer,
      $$IncidentReportsTableCreateCompanionBuilder,
      $$IncidentReportsTableUpdateCompanionBuilder,
      (
        IncidentReport,
        BaseReferences<_$AppDatabase, $IncidentReportsTable, IncidentReport>,
      ),
      IncidentReport,
      PrefetchHooks Function()
    >;
typedef $$PatrolsTableCreateCompanionBuilder =
    PatrolsCompanion Function({
      required String id,
      required String siteId,
      required String name,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$PatrolsTableUpdateCompanionBuilder =
    PatrolsCompanion Function({
      Value<String> id,
      Value<String> siteId,
      Value<String> name,
      Value<String?> description,
      Value<int> rowid,
    });

class $$PatrolsTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolsTable> {
  $$PatrolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolsTable> {
  $$PatrolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolsTable> {
  $$PatrolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$PatrolsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolsTable,
          Patrol,
          $$PatrolsTableFilterComposer,
          $$PatrolsTableOrderingComposer,
          $$PatrolsTableAnnotationComposer,
          $$PatrolsTableCreateCompanionBuilder,
          $$PatrolsTableUpdateCompanionBuilder,
          (Patrol, BaseReferences<_$AppDatabase, $PatrolsTable, Patrol>),
          Patrol,
          PrefetchHooks Function()
        > {
  $$PatrolsTableTableManager(_$AppDatabase db, $PatrolsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatrolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatrolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> siteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolsCompanion(
                id: id,
                siteId: siteId,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String siteId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolsCompanion.insert(
                id: id,
                siteId: siteId,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolsTable,
      Patrol,
      $$PatrolsTableFilterComposer,
      $$PatrolsTableOrderingComposer,
      $$PatrolsTableAnnotationComposer,
      $$PatrolsTableCreateCompanionBuilder,
      $$PatrolsTableUpdateCompanionBuilder,
      (Patrol, BaseReferences<_$AppDatabase, $PatrolsTable, Patrol>),
      Patrol,
      PrefetchHooks Function()
    >;
typedef $$CheckpointsTableCreateCompanionBuilder =
    CheckpointsCompanion Function({
      required String id,
      required String patrolId,
      required String name,
      Value<String?> instructions,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> qrCode,
      Value<bool> completed,
      Value<DateTime?> completedAt,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CheckpointsTableUpdateCompanionBuilder =
    CheckpointsCompanion Function({
      Value<String> id,
      Value<String> patrolId,
      Value<String> name,
      Value<String?> instructions,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> qrCode,
      Value<bool> completed,
      Value<DateTime?> completedAt,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CheckpointsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckpointsTable> {
  $$CheckpointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolId => $composableBuilder(
    column: $table.patrolId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckpointsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckpointsTable> {
  $$CheckpointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolId => $composableBuilder(
    column: $table.patrolId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckpointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckpointsTable> {
  $$CheckpointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patrolId =>
      $composableBuilder(column: $table.patrolId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CheckpointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckpointsTable,
          Checkpoint,
          $$CheckpointsTableFilterComposer,
          $$CheckpointsTableOrderingComposer,
          $$CheckpointsTableAnnotationComposer,
          $$CheckpointsTableCreateCompanionBuilder,
          $$CheckpointsTableUpdateCompanionBuilder,
          (
            Checkpoint,
            BaseReferences<_$AppDatabase, $CheckpointsTable, Checkpoint>,
          ),
          Checkpoint,
          PrefetchHooks Function()
        > {
  $$CheckpointsTableTableManager(_$AppDatabase db, $CheckpointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckpointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckpointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckpointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patrolId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> qrCode = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckpointsCompanion(
                id: id,
                patrolId: patrolId,
                name: name,
                instructions: instructions,
                latitude: latitude,
                longitude: longitude,
                qrCode: qrCode,
                completed: completed,
                completedAt: completedAt,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patrolId,
                required String name,
                Value<String?> instructions = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> qrCode = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckpointsCompanion.insert(
                id: id,
                patrolId: patrolId,
                name: name,
                instructions: instructions,
                latitude: latitude,
                longitude: longitude,
                qrCode: qrCode,
                completed: completed,
                completedAt: completedAt,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckpointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckpointsTable,
      Checkpoint,
      $$CheckpointsTableFilterComposer,
      $$CheckpointsTableOrderingComposer,
      $$CheckpointsTableAnnotationComposer,
      $$CheckpointsTableCreateCompanionBuilder,
      $$CheckpointsTableUpdateCompanionBuilder,
      (
        Checkpoint,
        BaseReferences<_$AppDatabase, $CheckpointsTable, Checkpoint>,
      ),
      Checkpoint,
      PrefetchHooks Function()
    >;
typedef $$PatrolToursTableCreateCompanionBuilder =
    PatrolToursCompanion Function({
      required String id,
      required String tenantId,
      required String clientId,
      required String siteId,
      required String name,
      Value<String?> description,
      Value<String> frequencyType,
      Value<int?> intervalMinutes,
      Value<String?> scheduledTimes,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<bool> sequenceRequired,
      Value<int?> estimatedDuration,
      Value<bool> isActive,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$PatrolToursTableUpdateCompanionBuilder =
    PatrolToursCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> clientId,
      Value<String> siteId,
      Value<String> name,
      Value<String?> description,
      Value<String> frequencyType,
      Value<int?> intervalMinutes,
      Value<String?> scheduledTimes,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<bool> sequenceRequired,
      Value<int?> estimatedDuration,
      Value<bool> isActive,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$PatrolToursTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolToursTable> {
  $$PatrolToursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledTimes => $composableBuilder(
    column: $table.scheduledTimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sequenceRequired => $composableBuilder(
    column: $table.sequenceRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedDuration => $composableBuilder(
    column: $table.estimatedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolToursTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolToursTable> {
  $$PatrolToursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTimes => $composableBuilder(
    column: $table.scheduledTimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sequenceRequired => $composableBuilder(
    column: $table.sequenceRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedDuration => $composableBuilder(
    column: $table.estimatedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolToursTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolToursTable> {
  $$PatrolToursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledTimes => $composableBuilder(
    column: $table.scheduledTimes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get sequenceRequired => $composableBuilder(
    column: $table.sequenceRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedDuration => $composableBuilder(
    column: $table.estimatedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PatrolToursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolToursTable,
          PatrolTour,
          $$PatrolToursTableFilterComposer,
          $$PatrolToursTableOrderingComposer,
          $$PatrolToursTableAnnotationComposer,
          $$PatrolToursTableCreateCompanionBuilder,
          $$PatrolToursTableUpdateCompanionBuilder,
          (
            PatrolTour,
            BaseReferences<_$AppDatabase, $PatrolToursTable, PatrolTour>,
          ),
          PatrolTour,
          PrefetchHooks Function()
        > {
  $$PatrolToursTableTableManager(_$AppDatabase db, $PatrolToursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolToursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatrolToursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatrolToursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> siteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> frequencyType = const Value.absent(),
                Value<int?> intervalMinutes = const Value.absent(),
                Value<String?> scheduledTimes = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<bool> sequenceRequired = const Value.absent(),
                Value<int?> estimatedDuration = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolToursCompanion(
                id: id,
                tenantId: tenantId,
                clientId: clientId,
                siteId: siteId,
                name: name,
                description: description,
                frequencyType: frequencyType,
                intervalMinutes: intervalMinutes,
                scheduledTimes: scheduledTimes,
                startTime: startTime,
                endTime: endTime,
                sequenceRequired: sequenceRequired,
                estimatedDuration: estimatedDuration,
                isActive: isActive,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String clientId,
                required String siteId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> frequencyType = const Value.absent(),
                Value<int?> intervalMinutes = const Value.absent(),
                Value<String?> scheduledTimes = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<bool> sequenceRequired = const Value.absent(),
                Value<int?> estimatedDuration = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolToursCompanion.insert(
                id: id,
                tenantId: tenantId,
                clientId: clientId,
                siteId: siteId,
                name: name,
                description: description,
                frequencyType: frequencyType,
                intervalMinutes: intervalMinutes,
                scheduledTimes: scheduledTimes,
                startTime: startTime,
                endTime: endTime,
                sequenceRequired: sequenceRequired,
                estimatedDuration: estimatedDuration,
                isActive: isActive,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolToursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolToursTable,
      PatrolTour,
      $$PatrolToursTableFilterComposer,
      $$PatrolToursTableOrderingComposer,
      $$PatrolToursTableAnnotationComposer,
      $$PatrolToursTableCreateCompanionBuilder,
      $$PatrolToursTableUpdateCompanionBuilder,
      (
        PatrolTour,
        BaseReferences<_$AppDatabase, $PatrolToursTable, PatrolTour>,
      ),
      PatrolTour,
      PrefetchHooks Function()
    >;
typedef $$PatrolTourPointsTableCreateCompanionBuilder =
    PatrolTourPointsCompanion Function({
      required String id,
      required String tenantId,
      required String patrolTourId,
      required String checkpointId,
      Value<int> sequenceNumber,
      Value<bool> requireScan,
      Value<bool> requirePhoto,
      Value<bool> requireNotes,
      Value<String?> instructions,
      Value<int> expectedDuration,
      Value<bool> isActive,
      required String checkpointName,
      required String checkpointCode,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> geofenceRadius,
      Value<int> rowid,
    });
typedef $$PatrolTourPointsTableUpdateCompanionBuilder =
    PatrolTourPointsCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> patrolTourId,
      Value<String> checkpointId,
      Value<int> sequenceNumber,
      Value<bool> requireScan,
      Value<bool> requirePhoto,
      Value<bool> requireNotes,
      Value<String?> instructions,
      Value<int> expectedDuration,
      Value<bool> isActive,
      Value<String> checkpointName,
      Value<String> checkpointCode,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<int> geofenceRadius,
      Value<int> rowid,
    });

class $$PatrolTourPointsTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolTourPointsTable> {
  $$PatrolTourPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolTourId => $composableBuilder(
    column: $table.patrolTourId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkpointId => $composableBuilder(
    column: $table.checkpointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requireScan => $composableBuilder(
    column: $table.requireScan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requirePhoto => $composableBuilder(
    column: $table.requirePhoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requireNotes => $composableBuilder(
    column: $table.requireNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedDuration => $composableBuilder(
    column: $table.expectedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkpointName => $composableBuilder(
    column: $table.checkpointName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkpointCode => $composableBuilder(
    column: $table.checkpointCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get geofenceRadius => $composableBuilder(
    column: $table.geofenceRadius,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolTourPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolTourPointsTable> {
  $$PatrolTourPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolTourId => $composableBuilder(
    column: $table.patrolTourId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkpointId => $composableBuilder(
    column: $table.checkpointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requireScan => $composableBuilder(
    column: $table.requireScan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requirePhoto => $composableBuilder(
    column: $table.requirePhoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requireNotes => $composableBuilder(
    column: $table.requireNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedDuration => $composableBuilder(
    column: $table.expectedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkpointName => $composableBuilder(
    column: $table.checkpointName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkpointCode => $composableBuilder(
    column: $table.checkpointCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get geofenceRadius => $composableBuilder(
    column: $table.geofenceRadius,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolTourPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolTourPointsTable> {
  $$PatrolTourPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get patrolTourId => $composableBuilder(
    column: $table.patrolTourId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkpointId => $composableBuilder(
    column: $table.checkpointId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requireScan => $composableBuilder(
    column: $table.requireScan,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requirePhoto => $composableBuilder(
    column: $table.requirePhoto,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requireNotes => $composableBuilder(
    column: $table.requireNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedDuration => $composableBuilder(
    column: $table.expectedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get checkpointName => $composableBuilder(
    column: $table.checkpointName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkpointCode => $composableBuilder(
    column: $table.checkpointCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get geofenceRadius => $composableBuilder(
    column: $table.geofenceRadius,
    builder: (column) => column,
  );
}

class $$PatrolTourPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolTourPointsTable,
          PatrolTourPoint,
          $$PatrolTourPointsTableFilterComposer,
          $$PatrolTourPointsTableOrderingComposer,
          $$PatrolTourPointsTableAnnotationComposer,
          $$PatrolTourPointsTableCreateCompanionBuilder,
          $$PatrolTourPointsTableUpdateCompanionBuilder,
          (
            PatrolTourPoint,
            BaseReferences<
              _$AppDatabase,
              $PatrolTourPointsTable,
              PatrolTourPoint
            >,
          ),
          PatrolTourPoint,
          PrefetchHooks Function()
        > {
  $$PatrolTourPointsTableTableManager(
    _$AppDatabase db,
    $PatrolTourPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolTourPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatrolTourPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatrolTourPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> patrolTourId = const Value.absent(),
                Value<String> checkpointId = const Value.absent(),
                Value<int> sequenceNumber = const Value.absent(),
                Value<bool> requireScan = const Value.absent(),
                Value<bool> requirePhoto = const Value.absent(),
                Value<bool> requireNotes = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<int> expectedDuration = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> checkpointName = const Value.absent(),
                Value<String> checkpointCode = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> geofenceRadius = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolTourPointsCompanion(
                id: id,
                tenantId: tenantId,
                patrolTourId: patrolTourId,
                checkpointId: checkpointId,
                sequenceNumber: sequenceNumber,
                requireScan: requireScan,
                requirePhoto: requirePhoto,
                requireNotes: requireNotes,
                instructions: instructions,
                expectedDuration: expectedDuration,
                isActive: isActive,
                checkpointName: checkpointName,
                checkpointCode: checkpointCode,
                latitude: latitude,
                longitude: longitude,
                geofenceRadius: geofenceRadius,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String patrolTourId,
                required String checkpointId,
                Value<int> sequenceNumber = const Value.absent(),
                Value<bool> requireScan = const Value.absent(),
                Value<bool> requirePhoto = const Value.absent(),
                Value<bool> requireNotes = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<int> expectedDuration = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required String checkpointName,
                required String checkpointCode,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<int> geofenceRadius = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolTourPointsCompanion.insert(
                id: id,
                tenantId: tenantId,
                patrolTourId: patrolTourId,
                checkpointId: checkpointId,
                sequenceNumber: sequenceNumber,
                requireScan: requireScan,
                requirePhoto: requirePhoto,
                requireNotes: requireNotes,
                instructions: instructions,
                expectedDuration: expectedDuration,
                isActive: isActive,
                checkpointName: checkpointName,
                checkpointCode: checkpointCode,
                latitude: latitude,
                longitude: longitude,
                geofenceRadius: geofenceRadius,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolTourPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolTourPointsTable,
      PatrolTourPoint,
      $$PatrolTourPointsTableFilterComposer,
      $$PatrolTourPointsTableOrderingComposer,
      $$PatrolTourPointsTableAnnotationComposer,
      $$PatrolTourPointsTableCreateCompanionBuilder,
      $$PatrolTourPointsTableUpdateCompanionBuilder,
      (
        PatrolTourPoint,
        BaseReferences<_$AppDatabase, $PatrolTourPointsTable, PatrolTourPoint>,
      ),
      PatrolTourPoint,
      PrefetchHooks Function()
    >;
typedef $$PatrolTasksTableCreateCompanionBuilder =
    PatrolTasksCompanion Function({
      required String id,
      required String tenantId,
      required String patrolPointId,
      required String title,
      Value<String?> description,
      Value<String> taskType,
      Value<String?> options,
      Value<bool> isRequired,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$PatrolTasksTableUpdateCompanionBuilder =
    PatrolTasksCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> patrolPointId,
      Value<String> title,
      Value<String?> description,
      Value<String> taskType,
      Value<String?> options,
      Value<bool> isRequired,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$PatrolTasksTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolTasksTable> {
  $$PatrolTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolPointId => $composableBuilder(
    column: $table.patrolPointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolTasksTable> {
  $$PatrolTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolPointId => $composableBuilder(
    column: $table.patrolPointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolTasksTable> {
  $$PatrolTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get patrolPointId => $composableBuilder(
    column: $table.patrolPointId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$PatrolTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolTasksTable,
          PatrolTask,
          $$PatrolTasksTableFilterComposer,
          $$PatrolTasksTableOrderingComposer,
          $$PatrolTasksTableAnnotationComposer,
          $$PatrolTasksTableCreateCompanionBuilder,
          $$PatrolTasksTableUpdateCompanionBuilder,
          (
            PatrolTask,
            BaseReferences<_$AppDatabase, $PatrolTasksTable, PatrolTask>,
          ),
          PatrolTask,
          PrefetchHooks Function()
        > {
  $$PatrolTasksTableTableManager(_$AppDatabase db, $PatrolTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatrolTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatrolTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> patrolPointId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<String?> options = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolTasksCompanion(
                id: id,
                tenantId: tenantId,
                patrolPointId: patrolPointId,
                title: title,
                description: description,
                taskType: taskType,
                options: options,
                isRequired: isRequired,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String patrolPointId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<String?> options = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolTasksCompanion.insert(
                id: id,
                tenantId: tenantId,
                patrolPointId: patrolPointId,
                title: title,
                description: description,
                taskType: taskType,
                options: options,
                isRequired: isRequired,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolTasksTable,
      PatrolTask,
      $$PatrolTasksTableFilterComposer,
      $$PatrolTasksTableOrderingComposer,
      $$PatrolTasksTableAnnotationComposer,
      $$PatrolTasksTableCreateCompanionBuilder,
      $$PatrolTasksTableUpdateCompanionBuilder,
      (
        PatrolTask,
        BaseReferences<_$AppDatabase, $PatrolTasksTable, PatrolTask>,
      ),
      PatrolTask,
      PrefetchHooks Function()
    >;
typedef $$PatrolInstancesTableCreateCompanionBuilder =
    PatrolInstancesCompanion Function({
      required String id,
      Value<String?> serverId,
      required String tenantId,
      required String patrolTourId,
      Value<String?> scheduleId,
      Value<String?> shiftId,
      required String employeeId,
      Value<DateTime?> scheduledStart,
      Value<DateTime?> actualStart,
      Value<DateTime?> actualEnd,
      Value<String> status,
      Value<int> totalPoints,
      Value<int> completedPoints,
      Value<double?> startLatitude,
      Value<double?> startLongitude,
      Value<String?> notes,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PatrolInstancesTableUpdateCompanionBuilder =
    PatrolInstancesCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> tenantId,
      Value<String> patrolTourId,
      Value<String?> scheduleId,
      Value<String?> shiftId,
      Value<String> employeeId,
      Value<DateTime?> scheduledStart,
      Value<DateTime?> actualStart,
      Value<DateTime?> actualEnd,
      Value<String> status,
      Value<int> totalPoints,
      Value<int> completedPoints,
      Value<double?> startLatitude,
      Value<double?> startLongitude,
      Value<String?> notes,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PatrolInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolInstancesTable> {
  $$PatrolInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolTourId => $composableBuilder(
    column: $table.patrolTourId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedPoints => $composableBuilder(
    column: $table.completedPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolInstancesTable> {
  $$PatrolInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolTourId => $composableBuilder(
    column: $table.patrolTourId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedPoints => $composableBuilder(
    column: $table.completedPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolInstancesTable> {
  $$PatrolInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get patrolTourId => $composableBuilder(
    column: $table.patrolTourId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualEnd =>
      $composableBuilder(column: $table.actualEnd, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedPoints => $composableBuilder(
    column: $table.completedPoints,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PatrolInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolInstancesTable,
          PatrolInstance,
          $$PatrolInstancesTableFilterComposer,
          $$PatrolInstancesTableOrderingComposer,
          $$PatrolInstancesTableAnnotationComposer,
          $$PatrolInstancesTableCreateCompanionBuilder,
          $$PatrolInstancesTableUpdateCompanionBuilder,
          (
            PatrolInstance,
            BaseReferences<
              _$AppDatabase,
              $PatrolInstancesTable,
              PatrolInstance
            >,
          ),
          PatrolInstance,
          PrefetchHooks Function()
        > {
  $$PatrolInstancesTableTableManager(
    _$AppDatabase db,
    $PatrolInstancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatrolInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatrolInstancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> patrolTourId = const Value.absent(),
                Value<String?> scheduleId = const Value.absent(),
                Value<String?> shiftId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<DateTime?> scheduledStart = const Value.absent(),
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> completedPoints = const Value.absent(),
                Value<double?> startLatitude = const Value.absent(),
                Value<double?> startLongitude = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolInstancesCompanion(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                patrolTourId: patrolTourId,
                scheduleId: scheduleId,
                shiftId: shiftId,
                employeeId: employeeId,
                scheduledStart: scheduledStart,
                actualStart: actualStart,
                actualEnd: actualEnd,
                status: status,
                totalPoints: totalPoints,
                completedPoints: completedPoints,
                startLatitude: startLatitude,
                startLongitude: startLongitude,
                notes: notes,
                needsSync: needsSync,
                syncedAt: syncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String tenantId,
                required String patrolTourId,
                Value<String?> scheduleId = const Value.absent(),
                Value<String?> shiftId = const Value.absent(),
                required String employeeId,
                Value<DateTime?> scheduledStart = const Value.absent(),
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> completedPoints = const Value.absent(),
                Value<double?> startLatitude = const Value.absent(),
                Value<double?> startLongitude = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PatrolInstancesCompanion.insert(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                patrolTourId: patrolTourId,
                scheduleId: scheduleId,
                shiftId: shiftId,
                employeeId: employeeId,
                scheduledStart: scheduledStart,
                actualStart: actualStart,
                actualEnd: actualEnd,
                status: status,
                totalPoints: totalPoints,
                completedPoints: completedPoints,
                startLatitude: startLatitude,
                startLongitude: startLongitude,
                notes: notes,
                needsSync: needsSync,
                syncedAt: syncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolInstancesTable,
      PatrolInstance,
      $$PatrolInstancesTableFilterComposer,
      $$PatrolInstancesTableOrderingComposer,
      $$PatrolInstancesTableAnnotationComposer,
      $$PatrolInstancesTableCreateCompanionBuilder,
      $$PatrolInstancesTableUpdateCompanionBuilder,
      (
        PatrolInstance,
        BaseReferences<_$AppDatabase, $PatrolInstancesTable, PatrolInstance>,
      ),
      PatrolInstance,
      PrefetchHooks Function()
    >;
typedef $$PatrolPointCompletionsTableCreateCompanionBuilder =
    PatrolPointCompletionsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String tenantId,
      required String patrolInstanceId,
      required String patrolPointId,
      Value<DateTime?> arrivedAt,
      Value<DateTime?> completedAt,
      Value<int?> duration,
      Value<bool> scanVerified,
      Value<String?> scanMethod,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> withinGeofence,
      Value<String?> photoLocalPath,
      Value<String?> photoUrl,
      Value<String?> notes,
      Value<String> status,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$PatrolPointCompletionsTableUpdateCompanionBuilder =
    PatrolPointCompletionsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> tenantId,
      Value<String> patrolInstanceId,
      Value<String> patrolPointId,
      Value<DateTime?> arrivedAt,
      Value<DateTime?> completedAt,
      Value<int?> duration,
      Value<bool> scanVerified,
      Value<String?> scanMethod,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<bool> withinGeofence,
      Value<String?> photoLocalPath,
      Value<String?> photoUrl,
      Value<String?> notes,
      Value<String> status,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$PatrolPointCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolPointCompletionsTable> {
  $$PatrolPointCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolInstanceId => $composableBuilder(
    column: $table.patrolInstanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolPointId => $composableBuilder(
    column: $table.patrolPointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrivedAt => $composableBuilder(
    column: $table.arrivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get scanVerified => $composableBuilder(
    column: $table.scanVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scanMethod => $composableBuilder(
    column: $table.scanMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get withinGeofence => $composableBuilder(
    column: $table.withinGeofence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoLocalPath => $composableBuilder(
    column: $table.photoLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolPointCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolPointCompletionsTable> {
  $$PatrolPointCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolInstanceId => $composableBuilder(
    column: $table.patrolInstanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolPointId => $composableBuilder(
    column: $table.patrolPointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrivedAt => $composableBuilder(
    column: $table.arrivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get scanVerified => $composableBuilder(
    column: $table.scanVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scanMethod => $composableBuilder(
    column: $table.scanMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get withinGeofence => $composableBuilder(
    column: $table.withinGeofence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoLocalPath => $composableBuilder(
    column: $table.photoLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolPointCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolPointCompletionsTable> {
  $$PatrolPointCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get patrolInstanceId => $composableBuilder(
    column: $table.patrolInstanceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patrolPointId => $composableBuilder(
    column: $table.patrolPointId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get arrivedAt =>
      $composableBuilder(column: $table.arrivedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get scanVerified => $composableBuilder(
    column: $table.scanVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scanMethod => $composableBuilder(
    column: $table.scanMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get withinGeofence => $composableBuilder(
    column: $table.withinGeofence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoLocalPath => $composableBuilder(
    column: $table.photoLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PatrolPointCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolPointCompletionsTable,
          PatrolPointCompletion,
          $$PatrolPointCompletionsTableFilterComposer,
          $$PatrolPointCompletionsTableOrderingComposer,
          $$PatrolPointCompletionsTableAnnotationComposer,
          $$PatrolPointCompletionsTableCreateCompanionBuilder,
          $$PatrolPointCompletionsTableUpdateCompanionBuilder,
          (
            PatrolPointCompletion,
            BaseReferences<
              _$AppDatabase,
              $PatrolPointCompletionsTable,
              PatrolPointCompletion
            >,
          ),
          PatrolPointCompletion,
          PrefetchHooks Function()
        > {
  $$PatrolPointCompletionsTableTableManager(
    _$AppDatabase db,
    $PatrolPointCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolPointCompletionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PatrolPointCompletionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PatrolPointCompletionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> patrolInstanceId = const Value.absent(),
                Value<String> patrolPointId = const Value.absent(),
                Value<DateTime?> arrivedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<bool> scanVerified = const Value.absent(),
                Value<String?> scanMethod = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> withinGeofence = const Value.absent(),
                Value<String?> photoLocalPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolPointCompletionsCompanion(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                patrolInstanceId: patrolInstanceId,
                patrolPointId: patrolPointId,
                arrivedAt: arrivedAt,
                completedAt: completedAt,
                duration: duration,
                scanVerified: scanVerified,
                scanMethod: scanMethod,
                latitude: latitude,
                longitude: longitude,
                withinGeofence: withinGeofence,
                photoLocalPath: photoLocalPath,
                photoUrl: photoUrl,
                notes: notes,
                status: status,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String tenantId,
                required String patrolInstanceId,
                required String patrolPointId,
                Value<DateTime?> arrivedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<bool> scanVerified = const Value.absent(),
                Value<String?> scanMethod = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<bool> withinGeofence = const Value.absent(),
                Value<String?> photoLocalPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolPointCompletionsCompanion.insert(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                patrolInstanceId: patrolInstanceId,
                patrolPointId: patrolPointId,
                arrivedAt: arrivedAt,
                completedAt: completedAt,
                duration: duration,
                scanVerified: scanVerified,
                scanMethod: scanMethod,
                latitude: latitude,
                longitude: longitude,
                withinGeofence: withinGeofence,
                photoLocalPath: photoLocalPath,
                photoUrl: photoUrl,
                notes: notes,
                status: status,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolPointCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolPointCompletionsTable,
      PatrolPointCompletion,
      $$PatrolPointCompletionsTableFilterComposer,
      $$PatrolPointCompletionsTableOrderingComposer,
      $$PatrolPointCompletionsTableAnnotationComposer,
      $$PatrolPointCompletionsTableCreateCompanionBuilder,
      $$PatrolPointCompletionsTableUpdateCompanionBuilder,
      (
        PatrolPointCompletion,
        BaseReferences<
          _$AppDatabase,
          $PatrolPointCompletionsTable,
          PatrolPointCompletion
        >,
      ),
      PatrolPointCompletion,
      PrefetchHooks Function()
    >;
typedef $$PatrolTaskResponsesTableCreateCompanionBuilder =
    PatrolTaskResponsesCompanion Function({
      required String id,
      Value<String?> serverId,
      required String tenantId,
      required String pointCompletionId,
      required String patrolTaskId,
      Value<String?> responseValue,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$PatrolTaskResponsesTableUpdateCompanionBuilder =
    PatrolTaskResponsesCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> tenantId,
      Value<String> pointCompletionId,
      Value<String> patrolTaskId,
      Value<String?> responseValue,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$PatrolTaskResponsesTableFilterComposer
    extends Composer<_$AppDatabase, $PatrolTaskResponsesTable> {
  $$PatrolTaskResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointCompletionId => $composableBuilder(
    column: $table.pointCompletionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patrolTaskId => $composableBuilder(
    column: $table.patrolTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseValue => $composableBuilder(
    column: $table.responseValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatrolTaskResponsesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatrolTaskResponsesTable> {
  $$PatrolTaskResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointCompletionId => $composableBuilder(
    column: $table.pointCompletionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patrolTaskId => $composableBuilder(
    column: $table.patrolTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseValue => $composableBuilder(
    column: $table.responseValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatrolTaskResponsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatrolTaskResponsesTable> {
  $$PatrolTaskResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get pointCompletionId => $composableBuilder(
    column: $table.pointCompletionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patrolTaskId => $composableBuilder(
    column: $table.patrolTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responseValue => $composableBuilder(
    column: $table.responseValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PatrolTaskResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatrolTaskResponsesTable,
          PatrolTaskResponse,
          $$PatrolTaskResponsesTableFilterComposer,
          $$PatrolTaskResponsesTableOrderingComposer,
          $$PatrolTaskResponsesTableAnnotationComposer,
          $$PatrolTaskResponsesTableCreateCompanionBuilder,
          $$PatrolTaskResponsesTableUpdateCompanionBuilder,
          (
            PatrolTaskResponse,
            BaseReferences<
              _$AppDatabase,
              $PatrolTaskResponsesTable,
              PatrolTaskResponse
            >,
          ),
          PatrolTaskResponse,
          PrefetchHooks Function()
        > {
  $$PatrolTaskResponsesTableTableManager(
    _$AppDatabase db,
    $PatrolTaskResponsesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatrolTaskResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatrolTaskResponsesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PatrolTaskResponsesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> pointCompletionId = const Value.absent(),
                Value<String> patrolTaskId = const Value.absent(),
                Value<String?> responseValue = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolTaskResponsesCompanion(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                pointCompletionId: pointCompletionId,
                patrolTaskId: patrolTaskId,
                responseValue: responseValue,
                isCompleted: isCompleted,
                completedAt: completedAt,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String tenantId,
                required String pointCompletionId,
                required String patrolTaskId,
                Value<String?> responseValue = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatrolTaskResponsesCompanion.insert(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                pointCompletionId: pointCompletionId,
                patrolTaskId: patrolTaskId,
                responseValue: responseValue,
                isCompleted: isCompleted,
                completedAt: completedAt,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatrolTaskResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatrolTaskResponsesTable,
      PatrolTaskResponse,
      $$PatrolTaskResponsesTableFilterComposer,
      $$PatrolTaskResponsesTableOrderingComposer,
      $$PatrolTaskResponsesTableAnnotationComposer,
      $$PatrolTaskResponsesTableCreateCompanionBuilder,
      $$PatrolTaskResponsesTableUpdateCompanionBuilder,
      (
        PatrolTaskResponse,
        BaseReferences<
          _$AppDatabase,
          $PatrolTaskResponsesTable,
          PatrolTaskResponse
        >,
      ),
      PatrolTaskResponse,
      PrefetchHooks Function()
    >;
typedef $$OutboxEventsTableCreateCompanionBuilder =
    OutboxEventsCompanion Function({
      required String eventId,
      required String tenantId,
      required String type,
      Value<String?> entityType,
      Value<String?> entityId,
      required String payloadJson,
      required DateTime createdAt,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime?> publishedAt,
      Value<String?> lastError,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });
typedef $$OutboxEventsTableUpdateCompanionBuilder =
    OutboxEventsCompanion Function({
      Value<String> eventId,
      Value<String> tenantId,
      Value<String> type,
      Value<String?> entityType,
      Value<String?> entityId,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime?> publishedAt,
      Value<String?> lastError,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });

class $$OutboxEventsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEventsTable> {
  $$OutboxEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEventsTable> {
  $$OutboxEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEventsTable> {
  $$OutboxEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );
}

class $$OutboxEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEventsTable,
          OutboxEvent,
          $$OutboxEventsTableFilterComposer,
          $$OutboxEventsTableOrderingComposer,
          $$OutboxEventsTableAnnotationComposer,
          $$OutboxEventsTableCreateCompanionBuilder,
          $$OutboxEventsTableUpdateCompanionBuilder,
          (
            OutboxEvent,
            BaseReferences<_$AppDatabase, $OutboxEventsTable, OutboxEvent>,
          ),
          OutboxEvent,
          PrefetchHooks Function()
        > {
  $$OutboxEventsTableTableManager(_$AppDatabase db, $OutboxEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEventsCompanion(
                eventId: eventId,
                tenantId: tenantId,
                type: type,
                entityType: entityType,
                entityId: entityId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
                publishedAt: publishedAt,
                lastError: lastError,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String tenantId,
                required String type,
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                required String payloadJson,
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEventsCompanion.insert(
                eventId: eventId,
                tenantId: tenantId,
                type: type,
                entityType: entityType,
                entityId: entityId,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
                publishedAt: publishedAt,
                lastError: lastError,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEventsTable,
      OutboxEvent,
      $$OutboxEventsTableFilterComposer,
      $$OutboxEventsTableOrderingComposer,
      $$OutboxEventsTableAnnotationComposer,
      $$OutboxEventsTableCreateCompanionBuilder,
      $$OutboxEventsTableUpdateCompanionBuilder,
      (
        OutboxEvent,
        BaseReferences<_$AppDatabase, $OutboxEventsTable, OutboxEvent>,
      ),
      OutboxEvent,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String entity,
      required String tenantId,
      required String watermark,
      required DateTime lastSyncAt,
      Value<int> recordsSynced,
      Value<String> syncStatus,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> entity,
      Value<String> tenantId,
      Value<String> watermark,
      Value<DateTime> lastSyncAt,
      Value<int> recordsSynced,
      Value<String> syncStatus,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get watermark => $composableBuilder(
    column: $table.watermark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsSynced => $composableBuilder(
    column: $table.recordsSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get watermark => $composableBuilder(
    column: $table.watermark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsSynced => $composableBuilder(
    column: $table.recordsSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get watermark =>
      $composableBuilder(column: $table.watermark, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsSynced => $composableBuilder(
    column: $table.recordsSynced,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entity = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> watermark = const Value.absent(),
                Value<DateTime> lastSyncAt = const Value.absent(),
                Value<int> recordsSynced = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                entity: entity,
                tenantId: tenantId,
                watermark: watermark,
                lastSyncAt: lastSyncAt,
                recordsSynced: recordsSynced,
                syncStatus: syncStatus,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entity,
                required String tenantId,
                required String watermark,
                required DateTime lastSyncAt,
                Value<int> recordsSynced = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                entity: entity,
                tenantId: tenantId,
                watermark: watermark,
                lastSyncAt: lastSyncAt,
                recordsSynced: recordsSynced,
                syncStatus: syncStatus,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;
typedef $$InAppNotificationsTableCreateCompanionBuilder =
    InAppNotificationsCompanion Function({
      required String id,
      Value<String?> serverId,
      required String tenantId,
      required String employeeId,
      required String title,
      required String body,
      required String type,
      Value<String> priority,
      Value<String?> relatedEntityType,
      Value<String?> relatedEntityId,
      Value<String?> iconType,
      Value<String?> actionLabel,
      Value<String?> actionRoute,
      Value<bool> isRead,
      Value<bool> isArchived,
      Value<bool> isDismissed,
      required DateTime receivedAt,
      Value<DateTime?> readAt,
      Value<DateTime?> expiresAt,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$InAppNotificationsTableUpdateCompanionBuilder =
    InAppNotificationsCompanion Function({
      Value<String> id,
      Value<String?> serverId,
      Value<String> tenantId,
      Value<String> employeeId,
      Value<String> title,
      Value<String> body,
      Value<String> type,
      Value<String> priority,
      Value<String?> relatedEntityType,
      Value<String?> relatedEntityId,
      Value<String?> iconType,
      Value<String?> actionLabel,
      Value<String?> actionRoute,
      Value<bool> isRead,
      Value<bool> isArchived,
      Value<bool> isDismissed,
      Value<DateTime> receivedAt,
      Value<DateTime?> readAt,
      Value<DateTime?> expiresAt,
      Value<bool> needsSync,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$InAppNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $InAppNotificationsTable> {
  $$InAppNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedEntityType => $composableBuilder(
    column: $table.relatedEntityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedEntityId => $composableBuilder(
    column: $table.relatedEntityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconType => $composableBuilder(
    column: $table.iconType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionLabel => $composableBuilder(
    column: $table.actionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionRoute => $composableBuilder(
    column: $table.actionRoute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InAppNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $InAppNotificationsTable> {
  $$InAppNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedEntityType => $composableBuilder(
    column: $table.relatedEntityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedEntityId => $composableBuilder(
    column: $table.relatedEntityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconType => $composableBuilder(
    column: $table.iconType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionLabel => $composableBuilder(
    column: $table.actionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionRoute => $composableBuilder(
    column: $table.actionRoute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InAppNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InAppNotificationsTable> {
  $$InAppNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get relatedEntityType => $composableBuilder(
    column: $table.relatedEntityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedEntityId => $composableBuilder(
    column: $table.relatedEntityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconType =>
      $composableBuilder(column: $table.iconType, builder: (column) => column);

  GeneratedColumn<String> get actionLabel => $composableBuilder(
    column: $table.actionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionRoute => $composableBuilder(
    column: $table.actionRoute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$InAppNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InAppNotificationsTable,
          InAppNotification,
          $$InAppNotificationsTableFilterComposer,
          $$InAppNotificationsTableOrderingComposer,
          $$InAppNotificationsTableAnnotationComposer,
          $$InAppNotificationsTableCreateCompanionBuilder,
          $$InAppNotificationsTableUpdateCompanionBuilder,
          (
            InAppNotification,
            BaseReferences<
              _$AppDatabase,
              $InAppNotificationsTable,
              InAppNotification
            >,
          ),
          InAppNotification,
          PrefetchHooks Function()
        > {
  $$InAppNotificationsTableTableManager(
    _$AppDatabase db,
    $InAppNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InAppNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InAppNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InAppNotificationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String?> relatedEntityType = const Value.absent(),
                Value<String?> relatedEntityId = const Value.absent(),
                Value<String?> iconType = const Value.absent(),
                Value<String?> actionLabel = const Value.absent(),
                Value<String?> actionRoute = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InAppNotificationsCompanion(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                employeeId: employeeId,
                title: title,
                body: body,
                type: type,
                priority: priority,
                relatedEntityType: relatedEntityType,
                relatedEntityId: relatedEntityId,
                iconType: iconType,
                actionLabel: actionLabel,
                actionRoute: actionRoute,
                isRead: isRead,
                isArchived: isArchived,
                isDismissed: isDismissed,
                receivedAt: receivedAt,
                readAt: readAt,
                expiresAt: expiresAt,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> serverId = const Value.absent(),
                required String tenantId,
                required String employeeId,
                required String title,
                required String body,
                required String type,
                Value<String> priority = const Value.absent(),
                Value<String?> relatedEntityType = const Value.absent(),
                Value<String?> relatedEntityId = const Value.absent(),
                Value<String?> iconType = const Value.absent(),
                Value<String?> actionLabel = const Value.absent(),
                Value<String?> actionRoute = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                required DateTime receivedAt,
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InAppNotificationsCompanion.insert(
                id: id,
                serverId: serverId,
                tenantId: tenantId,
                employeeId: employeeId,
                title: title,
                body: body,
                type: type,
                priority: priority,
                relatedEntityType: relatedEntityType,
                relatedEntityId: relatedEntityId,
                iconType: iconType,
                actionLabel: actionLabel,
                actionRoute: actionRoute,
                isRead: isRead,
                isArchived: isArchived,
                isDismissed: isDismissed,
                receivedAt: receivedAt,
                readAt: readAt,
                expiresAt: expiresAt,
                needsSync: needsSync,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InAppNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InAppNotificationsTable,
      InAppNotification,
      $$InAppNotificationsTableFilterComposer,
      $$InAppNotificationsTableOrderingComposer,
      $$InAppNotificationsTableAnnotationComposer,
      $$InAppNotificationsTableCreateCompanionBuilder,
      $$InAppNotificationsTableUpdateCompanionBuilder,
      (
        InAppNotification,
        BaseReferences<
          _$AppDatabase,
          $InAppNotificationsTable,
          InAppNotification
        >,
      ),
      InAppNotification,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TenantConfigTableTableManager get tenantConfig =>
      $$TenantConfigTableTableManager(_db, _db.tenantConfig);
  $$AppConfigTableTableManager get appConfig =>
      $$AppConfigTableTableManager(_db, _db.appConfig);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$AttendancesTableTableManager get attendances =>
      $$AttendancesTableTableManager(_db, _db.attendances);
  $$LocationLogsTableTableManager get locationLogs =>
      $$LocationLogsTableTableManager(_db, _db.locationLogs);
  $$CheckCallsTableTableManager get checkCalls =>
      $$CheckCallsTableTableManager(_db, _db.checkCalls);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$IncidentReportsTableTableManager get incidentReports =>
      $$IncidentReportsTableTableManager(_db, _db.incidentReports);
  $$PatrolsTableTableManager get patrols =>
      $$PatrolsTableTableManager(_db, _db.patrols);
  $$CheckpointsTableTableManager get checkpoints =>
      $$CheckpointsTableTableManager(_db, _db.checkpoints);
  $$PatrolToursTableTableManager get patrolTours =>
      $$PatrolToursTableTableManager(_db, _db.patrolTours);
  $$PatrolTourPointsTableTableManager get patrolTourPoints =>
      $$PatrolTourPointsTableTableManager(_db, _db.patrolTourPoints);
  $$PatrolTasksTableTableManager get patrolTasks =>
      $$PatrolTasksTableTableManager(_db, _db.patrolTasks);
  $$PatrolInstancesTableTableManager get patrolInstances =>
      $$PatrolInstancesTableTableManager(_db, _db.patrolInstances);
  $$PatrolPointCompletionsTableTableManager get patrolPointCompletions =>
      $$PatrolPointCompletionsTableTableManager(
        _db,
        _db.patrolPointCompletions,
      );
  $$PatrolTaskResponsesTableTableManager get patrolTaskResponses =>
      $$PatrolTaskResponsesTableTableManager(_db, _db.patrolTaskResponses);
  $$OutboxEventsTableTableManager get outboxEvents =>
      $$OutboxEventsTableTableManager(_db, _db.outboxEvents);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$InAppNotificationsTableTableManager get inAppNotifications =>
      $$InAppNotificationsTableTableManager(_db, _db.inAppNotifications);
}

mixin _$TenantConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantConfigTable get tenantConfig => attachedDatabase.tenantConfig;
  $AppConfigTable get appConfig => attachedDatabase.appConfig;
}
mixin _$ShiftsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShiftsTable get shifts => attachedDatabase.shifts;
}
mixin _$AttendancesDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttendancesTable get attendances => attachedDatabase.attendances;
}
mixin _$LocationLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocationLogsTable get locationLogs => attachedDatabase.locationLogs;
}
mixin _$CheckCallsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CheckCallsTable get checkCalls => attachedDatabase.checkCalls;
}
mixin _$SyncQueueDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncQueueTable get syncQueue => attachedDatabase.syncQueue;
}
mixin _$IncidentReportsDaoMixin on DatabaseAccessor<AppDatabase> {
  $IncidentReportsTable get incidentReports => attachedDatabase.incidentReports;
}
mixin _$PatrolsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PatrolsTable get patrols => attachedDatabase.patrols;
  $CheckpointsTable get checkpoints => attachedDatabase.checkpoints;
}
mixin _$PatrolToursDaoMixin on DatabaseAccessor<AppDatabase> {
  $PatrolToursTable get patrolTours => attachedDatabase.patrolTours;
  $PatrolTourPointsTable get patrolTourPoints =>
      attachedDatabase.patrolTourPoints;
  $PatrolTasksTable get patrolTasks => attachedDatabase.patrolTasks;
}
mixin _$PatrolInstancesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PatrolInstancesTable get patrolInstances => attachedDatabase.patrolInstances;
  $PatrolPointCompletionsTable get patrolPointCompletions =>
      attachedDatabase.patrolPointCompletions;
  $PatrolTaskResponsesTable get patrolTaskResponses =>
      attachedDatabase.patrolTaskResponses;
}
mixin _$OutboxDaoMixin on DatabaseAccessor<AppDatabase> {
  $OutboxEventsTable get outboxEvents => attachedDatabase.outboxEvents;
  $SyncStateTable get syncState => attachedDatabase.syncState;
}
mixin _$InAppNotificationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $InAppNotificationsTable get inAppNotifications =>
      attachedDatabase.inAppNotifications;
}
