// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $KitsTable extends Kits with TableInfo<$KitsTable, Kit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isArchived, createdAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Kit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Kit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Kit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $KitsTable createAlias(String alias) {
    return $KitsTable(attachedDatabase, alias);
  }
}

class Kit extends DataClass implements Insertable<Kit> {
  final String id;
  final String name;
  final bool isArchived;
  final int createdAtMs;
  const Kit({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  KitsCompanion toCompanion(bool nullToAbsent) {
    return KitsCompanion(
      id: Value(id),
      name: Value(name),
      isArchived: Value(isArchived),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory Kit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Kit(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  Kit copyWith({
    String? id,
    String? name,
    bool? isArchived,
    int? createdAtMs,
  }) => Kit(
    id: id ?? this.id,
    name: name ?? this.name,
    isArchived: isArchived ?? this.isArchived,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  Kit copyWithCompanion(KitsCompanion data) {
    return Kit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Kit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isArchived, createdAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Kit &&
          other.id == this.id &&
          other.name == this.name &&
          other.isArchived == this.isArchived &&
          other.createdAtMs == this.createdAtMs);
}

class KitsCompanion extends UpdateCompanion<Kit> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isArchived;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const KitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KitsCompanion.insert({
    required String id,
    required String name,
    this.isArchived = const Value.absent(),
    required int createdAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAtMs = Value(createdAtMs);
  static Insertable<Kit> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isArchived,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? isArchived,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return KitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isArchived: isArchived ?? this.isArchived,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KitCategoriesTable extends KitCategories
    with TableInfo<$KitCategoriesTable, KitCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitIdMeta = const VerificationMeta('kitId');
  @override
  late final GeneratedColumn<String> kitId = GeneratedColumn<String>(
    'kit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kits (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kitId, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kit_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<KitCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kit_id')) {
      context.handle(
        _kitIdMeta,
        kitId.isAcceptableOrUnknown(data['kit_id']!, _kitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KitCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KitCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kit_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $KitCategoriesTable createAlias(String alias) {
    return $KitCategoriesTable(attachedDatabase, alias);
  }
}

class KitCategory extends DataClass implements Insertable<KitCategory> {
  final String id;
  final String kitId;
  final String name;
  final int sortOrder;
  const KitCategory({
    required this.id,
    required this.kitId,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kit_id'] = Variable<String>(kitId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  KitCategoriesCompanion toCompanion(bool nullToAbsent) {
    return KitCategoriesCompanion(
      id: Value(id),
      kitId: Value(kitId),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory KitCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KitCategory(
      id: serializer.fromJson<String>(json['id']),
      kitId: serializer.fromJson<String>(json['kitId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kitId': serializer.toJson<String>(kitId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  KitCategory copyWith({
    String? id,
    String? kitId,
    String? name,
    int? sortOrder,
  }) => KitCategory(
    id: id ?? this.id,
    kitId: kitId ?? this.kitId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  KitCategory copyWithCompanion(KitCategoriesCompanion data) {
    return KitCategory(
      id: data.id.present ? data.id.value : this.id,
      kitId: data.kitId.present ? data.kitId.value : this.kitId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KitCategory(')
          ..write('id: $id, ')
          ..write('kitId: $kitId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kitId, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KitCategory &&
          other.id == this.id &&
          other.kitId == this.kitId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class KitCategoriesCompanion extends UpdateCompanion<KitCategory> {
  final Value<String> id;
  final Value<String> kitId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const KitCategoriesCompanion({
    this.id = const Value.absent(),
    this.kitId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KitCategoriesCompanion.insert({
    required String id,
    required String kitId,
    required String name,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kitId = Value(kitId),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<KitCategory> custom({
    Expression<String>? id,
    Expression<String>? kitId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kitId != null) 'kit_id': kitId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KitCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? kitId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return KitCategoriesCompanion(
      id: id ?? this.id,
      kitId: kitId ?? this.kitId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kitId.present) {
      map['kit_id'] = Variable<String>(kitId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('kitId: $kitId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KitItemsTable extends KitItems with TableInfo<$KitItemsTable, KitItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kitIdMeta = const VerificationMeta('kitId');
  @override
  late final GeneratedColumn<String> kitId = GeneratedColumn<String>(
    'kit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kit_categories (id) ON DELETE SET NULL',
    ),
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
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kitId,
    categoryId,
    name,
    quantity,
    note,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kit_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<KitItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kit_id')) {
      context.handle(
        _kitIdMeta,
        kitId.isAcceptableOrUnknown(data['kit_id']!, _kitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KitItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KitItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kit_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $KitItemsTable createAlias(String alias) {
    return $KitItemsTable(attachedDatabase, alias);
  }
}

class KitItem extends DataClass implements Insertable<KitItem> {
  final String id;
  final String kitId;
  final String? categoryId;
  final String name;
  final int? quantity;
  final String? note;
  final int sortOrder;
  const KitItem({
    required this.id,
    required this.kitId,
    this.categoryId,
    required this.name,
    this.quantity,
    this.note,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kit_id'] = Variable<String>(kitId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  KitItemsCompanion toCompanion(bool nullToAbsent) {
    return KitItemsCompanion(
      id: Value(id),
      kitId: Value(kitId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      name: Value(name),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      sortOrder: Value(sortOrder),
    );
  }

  factory KitItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KitItem(
      id: serializer.fromJson<String>(json['id']),
      kitId: serializer.fromJson<String>(json['kitId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int?>(json['quantity']),
      note: serializer.fromJson<String?>(json['note']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kitId': serializer.toJson<String>(kitId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int?>(quantity),
      'note': serializer.toJson<String?>(note),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  KitItem copyWith({
    String? id,
    String? kitId,
    Value<String?> categoryId = const Value.absent(),
    String? name,
    Value<int?> quantity = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? sortOrder,
  }) => KitItem(
    id: id ?? this.id,
    kitId: kitId ?? this.kitId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    name: name ?? this.name,
    quantity: quantity.present ? quantity.value : this.quantity,
    note: note.present ? note.value : this.note,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  KitItem copyWithCompanion(KitItemsCompanion data) {
    return KitItem(
      id: data.id.present ? data.id.value : this.id,
      kitId: data.kitId.present ? data.kitId.value : this.kitId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      note: data.note.present ? data.note.value : this.note,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KitItem(')
          ..write('id: $id, ')
          ..write('kitId: $kitId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kitId, categoryId, name, quantity, note, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KitItem &&
          other.id == this.id &&
          other.kitId == this.kitId &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.note == this.note &&
          other.sortOrder == this.sortOrder);
}

class KitItemsCompanion extends UpdateCompanion<KitItem> {
  final Value<String> id;
  final Value<String> kitId;
  final Value<String?> categoryId;
  final Value<String> name;
  final Value<int?> quantity;
  final Value<String?> note;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const KitItemsCompanion({
    this.id = const Value.absent(),
    this.kitId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KitItemsCompanion.insert({
    required String id,
    required String kitId,
    this.categoryId = const Value.absent(),
    required String name,
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kitId = Value(kitId),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<KitItem> custom({
    Expression<String>? id,
    Expression<String>? kitId,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<String>? note,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kitId != null) 'kit_id': kitId,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KitItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? kitId,
    Value<String?>? categoryId,
    Value<String>? name,
    Value<int?>? quantity,
    Value<String?>? note,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return KitItemsCompanion(
      id: id ?? this.id,
      kitId: kitId ?? this.kitId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kitId.present) {
      map['kit_id'] = Variable<String>(kitId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitItemsCompanion(')
          ..write('id: $id, ')
          ..write('kitId: $kitId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $KitsTable kits = $KitsTable(this);
  late final $KitCategoriesTable kitCategories = $KitCategoriesTable(this);
  late final $KitItemsTable kitItems = $KitItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kits,
    kitCategories,
    kitItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kit_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kit_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kit_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kit_items', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$KitsTableCreateCompanionBuilder = KitsCompanion Function({
  required String id,
  required String name,
  Value<bool> isArchived,
  required int createdAtMs,
  Value<int> rowid,
});
typedef $$KitsTableUpdateCompanionBuilder = KitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isArchived,
  Value<int> createdAtMs,
  Value<int> rowid,
});

final class $$KitsTableReferences
    extends BaseReferences<_$LocalDatabase, $KitsTable, Kit> {
  $$KitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KitCategoriesTable, List<KitCategory>>
  _kitCategoriesRefsTable(_$LocalDatabase db) => MultiTypedResultKey.fromTable(
    db.kitCategories,
    aliasName: 'kits__id__kit_categories__kit_id',
  );

  $$KitCategoriesTableProcessedTableManager get kitCategoriesRefs {
    final manager = $$KitCategoriesTableTableManager(
      $_db,
      $_db.kitCategories,
    ).filter((f) => f.kitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_kitCategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KitItemsTable, List<KitItem>> _kitItemsRefsTable(
    _$LocalDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.kitItems,
    aliasName: 'kits__id__kit_items__kit_id',
  );

  $$KitItemsTableProcessedTableManager get kitItemsRefs {
    final manager = $$KitItemsTableTableManager(
      $_db,
      $_db.kitItems,
    ).filter((f) => f.kitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_kitItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KitsTableFilterComposer extends Composer<_$LocalDatabase, $KitsTable> {
  $$KitsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> kitCategoriesRefs(
    Expression<bool> Function($$KitCategoriesTableFilterComposer f) f,
  ) {
    final $$KitCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitCategories,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.kitCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> kitItemsRefs(
    Expression<bool> Function($$KitItemsTableFilterComposer f) f,
  ) {
    final $$KitItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitItems,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitItemsTableFilterComposer(
            $db: $db,
            $table: $db.kitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KitsTableOrderingComposer
    extends Composer<_$LocalDatabase, $KitsTable> {
  $$KitsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KitsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $KitsTable> {
  $$KitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  Expression<T> kitCategoriesRefs<T extends Object>(
    Expression<T> Function($$KitCategoriesTableAnnotationComposer a) f,
  ) {
    final $$KitCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitCategories,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.kitCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> kitItemsRefs<T extends Object>(
    Expression<T> Function($$KitItemsTableAnnotationComposer a) f,
  ) {
    final $$KitItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitItems,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.kitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KitsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $KitsTable,
          Kit,
          $$KitsTableFilterComposer,
          $$KitsTableOrderingComposer,
          $$KitsTableAnnotationComposer,
          $$KitsTableCreateCompanionBuilder,
          $$KitsTableUpdateCompanionBuilder,
          (Kit, $$KitsTableReferences),
          Kit,
          PrefetchHooks Function({bool kitCategoriesRefs, bool kitItemsRefs})
        > {
  $$KitsTableTableManager(_$LocalDatabase db, $KitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitsCompanion(
                id: id,
                name: name,
                isArchived: isArchived,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> isArchived = const Value.absent(),
                required int createdAtMs,
                Value<int> rowid = const Value.absent(),
              }) => KitsCompanion.insert(
                id: id,
                name: name,
                isArchived: isArchived,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KitsTable, Kit>(table),
                  $$KitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({kitCategoriesRefs = false, kitItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (kitCategoriesRefs) db.kitCategories,
                    if (kitItemsRefs) db.kitItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (kitCategoriesRefs)
                        await $_getPrefetchedData<Kit, $KitsTable, KitCategory>(
                          currentTable: table,
                          referencedTable: $$KitsTableReferences
                              ._kitCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) => $$KitsTableReferences(
                            db,
                            table,
                            p0,
                          ).kitCategoriesRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.kitId == item.id),
                          typedResults: items,
                        ),
                      if (kitItemsRefs)
                        await $_getPrefetchedData<Kit, $KitsTable, KitItem>(
                          currentTable: table,
                          referencedTable: $$KitsTableReferences
                              ._kitItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$KitsTableReferences(db, table, p0).kitItemsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.kitId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$KitsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $KitsTable,
      Kit,
      $$KitsTableFilterComposer,
      $$KitsTableOrderingComposer,
      $$KitsTableAnnotationComposer,
      $$KitsTableCreateCompanionBuilder,
      $$KitsTableUpdateCompanionBuilder,
      (Kit, $$KitsTableReferences),
      Kit,
      PrefetchHooks Function({bool kitCategoriesRefs, bool kitItemsRefs})
    >;
typedef $$KitCategoriesTableCreateCompanionBuilder =
    KitCategoriesCompanion Function({
      required String id,
      required String kitId,
      required String name,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$KitCategoriesTableUpdateCompanionBuilder =
    KitCategoriesCompanion Function({
      Value<String> id,
      Value<String> kitId,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$KitCategoriesTableReferences
    extends BaseReferences<_$LocalDatabase, $KitCategoriesTable, KitCategory> {
  $$KitCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KitsTable _kitIdTable(_$LocalDatabase db) =>
      db.kits.createAlias('kit_categories__kit_id__kits__id');

  $$KitsTableProcessedTableManager get kitId {
    final $_column = $_itemColumn<String>('kit_id')!;

    final manager = $$KitsTableTableManager(
      $_db,
      $_db.kits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$KitItemsTable, List<KitItem>> _kitItemsRefsTable(
    _$LocalDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.kitItems,
    aliasName: 'kit_categories__id__kit_items__category_id',
  );

  $$KitItemsTableProcessedTableManager get kitItemsRefs {
    final manager = $$KitItemsTableTableManager(
      $_db,
      $_db.kitItems,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_kitItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KitCategoriesTableFilterComposer
    extends Composer<_$LocalDatabase, $KitCategoriesTable> {
  $$KitCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$KitsTableFilterComposer get kitId {
    final $$KitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.kits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitsTableFilterComposer(
            $db: $db,
            $table: $db.kits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> kitItemsRefs(
    Expression<bool> Function($$KitItemsTableFilterComposer f) f,
  ) {
    final $$KitItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitItems,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitItemsTableFilterComposer(
            $db: $db,
            $table: $db.kitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KitCategoriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $KitCategoriesTable> {
  $$KitCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$KitsTableOrderingComposer get kitId {
    final $$KitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.kits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitsTableOrderingComposer(
            $db: $db,
            $table: $db.kits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitCategoriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $KitCategoriesTable> {
  $$KitCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$KitsTableAnnotationComposer get kitId {
    final $$KitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.kits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitsTableAnnotationComposer(
            $db: $db,
            $table: $db.kits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> kitItemsRefs<T extends Object>(
    Expression<T> Function($$KitItemsTableAnnotationComposer a) f,
  ) {
    final $$KitItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitItems,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.kitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KitCategoriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $KitCategoriesTable,
          KitCategory,
          $$KitCategoriesTableFilterComposer,
          $$KitCategoriesTableOrderingComposer,
          $$KitCategoriesTableAnnotationComposer,
          $$KitCategoriesTableCreateCompanionBuilder,
          $$KitCategoriesTableUpdateCompanionBuilder,
          (KitCategory, $$KitCategoriesTableReferences),
          KitCategory,
          PrefetchHooks Function({bool kitId, bool kitItemsRefs})
        > {
  $$KitCategoriesTableTableManager(
    _$LocalDatabase db,
    $KitCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kitId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitCategoriesCompanion(
                id: id,
                kitId: kitId,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kitId,
                required String name,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => KitCategoriesCompanion.insert(
                id: id,
                kitId: kitId,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KitCategoriesTable, KitCategory>(table),
                  $$KitCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kitId = false, kitItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (kitItemsRefs) db.kitItems],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (kitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.kitId,
                        referencedTable: $$KitCategoriesTableReferences
                            ._kitIdTable(db),
                        referencedColumn: $$KitCategoriesTableReferences
                            ._kitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (kitItemsRefs)
                    await $_getPrefetchedData<
                      KitCategory,
                      $KitCategoriesTable,
                      KitItem
                    >(
                      currentTable: table,
                      referencedTable: $$KitCategoriesTableReferences
                          ._kitItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$KitCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).kitItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KitCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $KitCategoriesTable,
      KitCategory,
      $$KitCategoriesTableFilterComposer,
      $$KitCategoriesTableOrderingComposer,
      $$KitCategoriesTableAnnotationComposer,
      $$KitCategoriesTableCreateCompanionBuilder,
      $$KitCategoriesTableUpdateCompanionBuilder,
      (KitCategory, $$KitCategoriesTableReferences),
      KitCategory,
      PrefetchHooks Function({bool kitId, bool kitItemsRefs})
    >;
typedef $$KitItemsTableCreateCompanionBuilder = KitItemsCompanion Function({
  required String id,
  required String kitId,
  Value<String?> categoryId,
  required String name,
  Value<int?> quantity,
  Value<String?> note,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$KitItemsTableUpdateCompanionBuilder = KitItemsCompanion Function({
  Value<String> id,
  Value<String> kitId,
  Value<String?> categoryId,
  Value<String> name,
  Value<int?> quantity,
  Value<String?> note,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$KitItemsTableReferences
    extends BaseReferences<_$LocalDatabase, $KitItemsTable, KitItem> {
  $$KitItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KitsTable _kitIdTable(_$LocalDatabase db) =>
      db.kits.createAlias('kit_items__kit_id__kits__id');

  $$KitsTableProcessedTableManager get kitId {
    final $_column = $_itemColumn<String>('kit_id')!;

    final manager = $$KitsTableTableManager(
      $_db,
      $_db.kits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $KitCategoriesTable _categoryIdTable(_$LocalDatabase db) => db
      .kitCategories
      .createAlias('kit_items__category_id__kit_categories__id');

  $$KitCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$KitCategoriesTableTableManager(
      $_db,
      $_db.kitCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KitItemsTableFilterComposer
    extends Composer<_$LocalDatabase, $KitItemsTable> {
  $$KitItemsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$KitsTableFilterComposer get kitId {
    final $$KitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.kits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitsTableFilterComposer(
            $db: $db,
            $table: $db.kits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitCategoriesTableFilterComposer get categoryId {
    final $$KitCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.kitCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.kitCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitItemsTableOrderingComposer
    extends Composer<_$LocalDatabase, $KitItemsTable> {
  $$KitItemsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$KitsTableOrderingComposer get kitId {
    final $$KitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.kits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitsTableOrderingComposer(
            $db: $db,
            $table: $db.kits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitCategoriesTableOrderingComposer get categoryId {
    final $$KitCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.kitCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.kitCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitItemsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $KitItemsTable> {
  $$KitItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$KitsTableAnnotationComposer get kitId {
    final $$KitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.kits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitsTableAnnotationComposer(
            $db: $db,
            $table: $db.kits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$KitCategoriesTableAnnotationComposer get categoryId {
    final $$KitCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.kitCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.kitCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitItemsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $KitItemsTable,
          KitItem,
          $$KitItemsTableFilterComposer,
          $$KitItemsTableOrderingComposer,
          $$KitItemsTableAnnotationComposer,
          $$KitItemsTableCreateCompanionBuilder,
          $$KitItemsTableUpdateCompanionBuilder,
          (KitItem, $$KitItemsTableReferences),
          KitItem,
          PrefetchHooks Function({bool kitId, bool categoryId})
        > {
  $$KitItemsTableTableManager(_$LocalDatabase db, $KitItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kitId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> quantity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KitItemsCompanion(
                id: id,
                kitId: kitId,
                categoryId: categoryId,
                name: name,
                quantity: quantity,
                note: note,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kitId,
                Value<String?> categoryId = const Value.absent(),
                required String name,
                Value<int?> quantity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => KitItemsCompanion.insert(
                id: id,
                kitId: kitId,
                categoryId: categoryId,
                name: name,
                quantity: quantity,
                note: note,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KitItemsTable, KitItem>(table),
                  $$KitItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kitId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (kitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.kitId,
                        referencedTable: $$KitItemsTableReferences._kitIdTable(
                          db,
                        ),
                        referencedColumn: $$KitItemsTableReferences
                            ._kitIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$KitItemsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$KitItemsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KitItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $KitItemsTable,
      KitItem,
      $$KitItemsTableFilterComposer,
      $$KitItemsTableOrderingComposer,
      $$KitItemsTableAnnotationComposer,
      $$KitItemsTableCreateCompanionBuilder,
      $$KitItemsTableUpdateCompanionBuilder,
      (KitItem, $$KitItemsTableReferences),
      KitItem,
      PrefetchHooks Function({bool kitId, bool categoryId})
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$KitsTableTableManager get kits => $$KitsTableTableManager(_db, _db.kits);
  $$KitCategoriesTableTableManager get kitCategories =>
      $$KitCategoriesTableTableManager(_db, _db.kitCategories);
  $$KitItemsTableTableManager get kitItems =>
      $$KitItemsTableTableManager(_db, _db.kitItems);
}
