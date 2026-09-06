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

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKitIdMeta = const VerificationMeta(
    'sourceKitId',
  );
  @override
  late final GeneratedColumn<String> sourceKitId = GeneratedColumn<String>(
    'source_kit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKitNameMeta = const VerificationMeta(
    'sourceKitName',
  );
  @override
  late final GeneratedColumn<String> sourceKitName = GeneratedColumn<String>(
    'source_kit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripNameMeta = const VerificationMeta(
    'tripName',
  );
  @override
  late final GeneratedColumn<String> tripName = GeneratedColumn<String>(
    'trip_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripNoteMeta = const VerificationMeta(
    'tripNote',
  );
  @override
  late final GeneratedColumn<String> tripNote = GeneratedColumn<String>(
    'trip_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedOnMsMeta = const VerificationMeta(
    'startedOnMs',
  );
  @override
  late final GeneratedColumn<int> startedOnMs = GeneratedColumn<int>(
    'started_on_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [
    id,
    sourceKitId,
    sourceKitName,
    tripName,
    tripNote,
    startedOnMs,
    createdAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_kit_id')) {
      context.handle(
        _sourceKitIdMeta,
        sourceKitId.isAcceptableOrUnknown(
          data['source_kit_id']!,
          _sourceKitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceKitIdMeta);
    }
    if (data.containsKey('source_kit_name')) {
      context.handle(
        _sourceKitNameMeta,
        sourceKitName.isAcceptableOrUnknown(
          data['source_kit_name']!,
          _sourceKitNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceKitNameMeta);
    }
    if (data.containsKey('trip_name')) {
      context.handle(
        _tripNameMeta,
        tripName.isAcceptableOrUnknown(data['trip_name']!, _tripNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tripNameMeta);
    }
    if (data.containsKey('trip_note')) {
      context.handle(
        _tripNoteMeta,
        tripNote.isAcceptableOrUnknown(data['trip_note']!, _tripNoteMeta),
      );
    }
    if (data.containsKey('started_on_ms')) {
      context.handle(
        _startedOnMsMeta,
        startedOnMs.isAcceptableOrUnknown(
          data['started_on_ms']!,
          _startedOnMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedOnMsMeta);
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
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceKitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kit_id'],
      )!,
      sourceKitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kit_name'],
      )!,
      tripName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_name'],
      )!,
      tripNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_note'],
      ),
      startedOnMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_on_ms'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final String id;
  final String sourceKitId;
  final String sourceKitName;
  final String tripName;
  final String? tripNote;
  final int startedOnMs;
  final int createdAtMs;
  const Trip({
    required this.id,
    required this.sourceKitId,
    required this.sourceKitName,
    required this.tripName,
    this.tripNote,
    required this.startedOnMs,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_kit_id'] = Variable<String>(sourceKitId);
    map['source_kit_name'] = Variable<String>(sourceKitName);
    map['trip_name'] = Variable<String>(tripName);
    if (!nullToAbsent || tripNote != null) {
      map['trip_note'] = Variable<String>(tripNote);
    }
    map['started_on_ms'] = Variable<int>(startedOnMs);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      sourceKitId: Value(sourceKitId),
      sourceKitName: Value(sourceKitName),
      tripName: Value(tripName),
      tripNote: tripNote == null && nullToAbsent
          ? const Value.absent()
          : Value(tripNote),
      startedOnMs: Value(startedOnMs),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<String>(json['id']),
      sourceKitId: serializer.fromJson<String>(json['sourceKitId']),
      sourceKitName: serializer.fromJson<String>(json['sourceKitName']),
      tripName: serializer.fromJson<String>(json['tripName']),
      tripNote: serializer.fromJson<String?>(json['tripNote']),
      startedOnMs: serializer.fromJson<int>(json['startedOnMs']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceKitId': serializer.toJson<String>(sourceKitId),
      'sourceKitName': serializer.toJson<String>(sourceKitName),
      'tripName': serializer.toJson<String>(tripName),
      'tripNote': serializer.toJson<String?>(tripNote),
      'startedOnMs': serializer.toJson<int>(startedOnMs),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  Trip copyWith({
    String? id,
    String? sourceKitId,
    String? sourceKitName,
    String? tripName,
    Value<String?> tripNote = const Value.absent(),
    int? startedOnMs,
    int? createdAtMs,
  }) => Trip(
    id: id ?? this.id,
    sourceKitId: sourceKitId ?? this.sourceKitId,
    sourceKitName: sourceKitName ?? this.sourceKitName,
    tripName: tripName ?? this.tripName,
    tripNote: tripNote.present ? tripNote.value : this.tripNote,
    startedOnMs: startedOnMs ?? this.startedOnMs,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      sourceKitId: data.sourceKitId.present
          ? data.sourceKitId.value
          : this.sourceKitId,
      sourceKitName: data.sourceKitName.present
          ? data.sourceKitName.value
          : this.sourceKitName,
      tripName: data.tripName.present ? data.tripName.value : this.tripName,
      tripNote: data.tripNote.present ? data.tripNote.value : this.tripNote,
      startedOnMs: data.startedOnMs.present
          ? data.startedOnMs.value
          : this.startedOnMs,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('sourceKitId: $sourceKitId, ')
          ..write('sourceKitName: $sourceKitName, ')
          ..write('tripName: $tripName, ')
          ..write('tripNote: $tripNote, ')
          ..write('startedOnMs: $startedOnMs, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceKitId,
    sourceKitName,
    tripName,
    tripNote,
    startedOnMs,
    createdAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.sourceKitId == this.sourceKitId &&
          other.sourceKitName == this.sourceKitName &&
          other.tripName == this.tripName &&
          other.tripNote == this.tripNote &&
          other.startedOnMs == this.startedOnMs &&
          other.createdAtMs == this.createdAtMs);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<String> id;
  final Value<String> sourceKitId;
  final Value<String> sourceKitName;
  final Value<String> tripName;
  final Value<String?> tripNote;
  final Value<int> startedOnMs;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.sourceKitId = const Value.absent(),
    this.sourceKitName = const Value.absent(),
    this.tripName = const Value.absent(),
    this.tripNote = const Value.absent(),
    this.startedOnMs = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String sourceKitId,
    required String sourceKitName,
    required String tripName,
    this.tripNote = const Value.absent(),
    required int startedOnMs,
    required int createdAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceKitId = Value(sourceKitId),
       sourceKitName = Value(sourceKitName),
       tripName = Value(tripName),
       startedOnMs = Value(startedOnMs),
       createdAtMs = Value(createdAtMs);
  static Insertable<Trip> custom({
    Expression<String>? id,
    Expression<String>? sourceKitId,
    Expression<String>? sourceKitName,
    Expression<String>? tripName,
    Expression<String>? tripNote,
    Expression<int>? startedOnMs,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceKitId != null) 'source_kit_id': sourceKitId,
      if (sourceKitName != null) 'source_kit_name': sourceKitName,
      if (tripName != null) 'trip_name': tripName,
      if (tripNote != null) 'trip_note': tripNote,
      if (startedOnMs != null) 'started_on_ms': startedOnMs,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceKitId,
    Value<String>? sourceKitName,
    Value<String>? tripName,
    Value<String?>? tripNote,
    Value<int>? startedOnMs,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      sourceKitId: sourceKitId ?? this.sourceKitId,
      sourceKitName: sourceKitName ?? this.sourceKitName,
      tripName: tripName ?? this.tripName,
      tripNote: tripNote ?? this.tripNote,
      startedOnMs: startedOnMs ?? this.startedOnMs,
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
    if (sourceKitId.present) {
      map['source_kit_id'] = Variable<String>(sourceKitId.value);
    }
    if (sourceKitName.present) {
      map['source_kit_name'] = Variable<String>(sourceKitName.value);
    }
    if (tripName.present) {
      map['trip_name'] = Variable<String>(tripName.value);
    }
    if (tripNote.present) {
      map['trip_note'] = Variable<String>(tripNote.value);
    }
    if (startedOnMs.present) {
      map['started_on_ms'] = Variable<int>(startedOnMs.value);
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
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('sourceKitId: $sourceKitId, ')
          ..write('sourceKitName: $sourceKitName, ')
          ..write('tripName: $tripName, ')
          ..write('tripNote: $tripNote, ')
          ..write('startedOnMs: $startedOnMs, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripChecklistItemsTable extends TripChecklistItems
    with TableInfo<$TripChecklistItemsTable, TripChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
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
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _omissionNoteMeta = const VerificationMeta(
    'omissionNote',
  );
  @override
  late final GeneratedColumn<String> omissionNote = GeneratedColumn<String>(
    'omission_note',
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
    tripId,
    itemId,
    itemName,
    quantity,
    note,
    categoryName,
    status,
    omissionNote,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
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
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('omission_note')) {
      context.handle(
        _omissionNoteMeta,
        omissionNote.isAcceptableOrUnknown(
          data['omission_note']!,
          _omissionNoteMeta,
        ),
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
  Set<GeneratedColumn> get $primaryKey => {tripId, itemId};
  @override
  TripChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripChecklistItem(
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      omissionNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}omission_note'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TripChecklistItemsTable createAlias(String alias) {
    return $TripChecklistItemsTable(attachedDatabase, alias);
  }
}

class TripChecklistItem extends DataClass
    implements Insertable<TripChecklistItem> {
  final String tripId;
  final String itemId;
  final String itemName;
  final int? quantity;
  final String? note;
  final String? categoryName;
  final String status;
  final String? omissionNote;
  final int sortOrder;
  const TripChecklistItem({
    required this.tripId,
    required this.itemId,
    required this.itemName,
    this.quantity,
    this.note,
    this.categoryName,
    required this.status,
    this.omissionNote,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<String>(tripId);
    map['item_id'] = Variable<String>(itemId);
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || omissionNote != null) {
      map['omission_note'] = Variable<String>(omissionNote);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TripChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return TripChecklistItemsCompanion(
      tripId: Value(tripId),
      itemId: Value(itemId),
      itemName: Value(itemName),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      status: Value(status),
      omissionNote: omissionNote == null && nullToAbsent
          ? const Value.absent()
          : Value(omissionNote),
      sortOrder: Value(sortOrder),
    );
  }

  factory TripChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripChecklistItem(
      tripId: serializer.fromJson<String>(json['tripId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int?>(json['quantity']),
      note: serializer.fromJson<String?>(json['note']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      status: serializer.fromJson<String>(json['status']),
      omissionNote: serializer.fromJson<String?>(json['omissionNote']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tripId': serializer.toJson<String>(tripId),
      'itemId': serializer.toJson<String>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int?>(quantity),
      'note': serializer.toJson<String?>(note),
      'categoryName': serializer.toJson<String?>(categoryName),
      'status': serializer.toJson<String>(status),
      'omissionNote': serializer.toJson<String?>(omissionNote),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TripChecklistItem copyWith({
    String? tripId,
    String? itemId,
    String? itemName,
    Value<int?> quantity = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    String? status,
    Value<String?> omissionNote = const Value.absent(),
    int? sortOrder,
  }) => TripChecklistItem(
    tripId: tripId ?? this.tripId,
    itemId: itemId ?? this.itemId,
    itemName: itemName ?? this.itemName,
    quantity: quantity.present ? quantity.value : this.quantity,
    note: note.present ? note.value : this.note,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    status: status ?? this.status,
    omissionNote: omissionNote.present ? omissionNote.value : this.omissionNote,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TripChecklistItem copyWithCompanion(TripChecklistItemsCompanion data) {
    return TripChecklistItem(
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      note: data.note.present ? data.note.value : this.note,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      status: data.status.present ? data.status.value : this.status,
      omissionNote: data.omissionNote.present
          ? data.omissionNote.value
          : this.omissionNote,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripChecklistItem(')
          ..write('tripId: $tripId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('categoryName: $categoryName, ')
          ..write('status: $status, ')
          ..write('omissionNote: $omissionNote, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tripId,
    itemId,
    itemName,
    quantity,
    note,
    categoryName,
    status,
    omissionNote,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripChecklistItem &&
          other.tripId == this.tripId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.note == this.note &&
          other.categoryName == this.categoryName &&
          other.status == this.status &&
          other.omissionNote == this.omissionNote &&
          other.sortOrder == this.sortOrder);
}

class TripChecklistItemsCompanion extends UpdateCompanion<TripChecklistItem> {
  final Value<String> tripId;
  final Value<String> itemId;
  final Value<String> itemName;
  final Value<int?> quantity;
  final Value<String?> note;
  final Value<String?> categoryName;
  final Value<String> status;
  final Value<String?> omissionNote;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TripChecklistItemsCompanion({
    this.tripId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.status = const Value.absent(),
    this.omissionNote = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripChecklistItemsCompanion.insert({
    required String tripId,
    required String itemId,
    required String itemName,
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.categoryName = const Value.absent(),
    required String status,
    this.omissionNote = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : tripId = Value(tripId),
       itemId = Value(itemId),
       itemName = Value(itemName),
       status = Value(status),
       sortOrder = Value(sortOrder);
  static Insertable<TripChecklistItem> custom({
    Expression<String>? tripId,
    Expression<String>? itemId,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<String>? note,
    Expression<String>? categoryName,
    Expression<String>? status,
    Expression<String>? omissionNote,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tripId != null) 'trip_id': tripId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (categoryName != null) 'category_name': categoryName,
      if (status != null) 'status': status,
      if (omissionNote != null) 'omission_note': omissionNote,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripChecklistItemsCompanion copyWith({
    Value<String>? tripId,
    Value<String>? itemId,
    Value<String>? itemName,
    Value<int?>? quantity,
    Value<String?>? note,
    Value<String?>? categoryName,
    Value<String>? status,
    Value<String?>? omissionNote,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TripChecklistItemsCompanion(
      tripId: tripId ?? this.tripId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      omissionNote: omissionNote ?? this.omissionNote,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (omissionNote.present) {
      map['omission_note'] = Variable<String>(omissionNote.value);
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
    return (StringBuffer('TripChecklistItemsCompanion(')
          ..write('tripId: $tripId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('categoryName: $categoryName, ')
          ..write('status: $status, ')
          ..write('omissionNote: $omissionNote, ')
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
  late final $TripsTable trips = $TripsTable(this);
  late final $TripChecklistItemsTable tripChecklistItems =
      $TripChecklistItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kits,
    kitCategories,
    kitItems,
    trips,
    tripChecklistItems,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trips',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trip_checklist_items', kind: UpdateKind.delete)],
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
typedef $$TripsTableCreateCompanionBuilder = TripsCompanion Function({
  required String id,
  required String sourceKitId,
  required String sourceKitName,
  required String tripName,
  Value<String?> tripNote,
  required int startedOnMs,
  required int createdAtMs,
  Value<int> rowid,
});
typedef $$TripsTableUpdateCompanionBuilder = TripsCompanion Function({
  Value<String> id,
  Value<String> sourceKitId,
  Value<String> sourceKitName,
  Value<String> tripName,
  Value<String?> tripNote,
  Value<int> startedOnMs,
  Value<int> createdAtMs,
  Value<int> rowid,
});

final class $$TripsTableReferences
    extends BaseReferences<_$LocalDatabase, $TripsTable, Trip> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TripChecklistItemsTable, List<TripChecklistItem>>
  _tripChecklistItemsRefsTable(_$LocalDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tripChecklistItems,
        aliasName: 'trips__id__trip_checklist_items__trip_id',
      );

  $$TripChecklistItemsTableProcessedTableManager get tripChecklistItemsRefs {
    final manager = $$TripChecklistItemsTableTableManager(
      $_db,
      $_db.tripChecklistItems,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tripChecklistItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripsTableFilterComposer
    extends Composer<_$LocalDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
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

  ColumnFilters<String> get sourceKitId => $composableBuilder(
    column: $table.sourceKitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKitName => $composableBuilder(
    column: $table.sourceKitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripName => $composableBuilder(
    column: $table.tripName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripNote => $composableBuilder(
    column: $table.tripNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedOnMs => $composableBuilder(
    column: $table.startedOnMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tripChecklistItemsRefs(
    Expression<bool> Function($$TripChecklistItemsTableFilterComposer f) f,
  ) {
    final $$TripChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripChecklistItems,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.tripChecklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$LocalDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
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

  ColumnOrderings<String> get sourceKitId => $composableBuilder(
    column: $table.sourceKitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKitName => $composableBuilder(
    column: $table.sourceKitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripName => $composableBuilder(
    column: $table.tripName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripNote => $composableBuilder(
    column: $table.tripNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedOnMs => $composableBuilder(
    column: $table.startedOnMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceKitId => $composableBuilder(
    column: $table.sourceKitId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceKitName => $composableBuilder(
    column: $table.sourceKitName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tripName =>
      $composableBuilder(column: $table.tripName, builder: (column) => column);

  GeneratedColumn<String> get tripNote =>
      $composableBuilder(column: $table.tripNote, builder: (column) => column);

  GeneratedColumn<int> get startedOnMs => $composableBuilder(
    column: $table.startedOnMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  Expression<T> tripChecklistItemsRefs<T extends Object>(
    Expression<T> Function($$TripChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$TripChecklistItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tripChecklistItems,
          getReferencedColumn: (t) => t.tripId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TripChecklistItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.tripChecklistItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, $$TripsTableReferences),
          Trip,
          PrefetchHooks Function({bool tripChecklistItemsRefs})
        > {
  $$TripsTableTableManager(_$LocalDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceKitId = const Value.absent(),
                Value<String> sourceKitName = const Value.absent(),
                Value<String> tripName = const Value.absent(),
                Value<String?> tripNote = const Value.absent(),
                Value<int> startedOnMs = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                sourceKitId: sourceKitId,
                sourceKitName: sourceKitName,
                tripName: tripName,
                tripNote: tripNote,
                startedOnMs: startedOnMs,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceKitId,
                required String sourceKitName,
                required String tripName,
                Value<String?> tripNote = const Value.absent(),
                required int startedOnMs,
                required int createdAtMs,
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                sourceKitId: sourceKitId,
                sourceKitName: sourceKitName,
                tripName: tripName,
                tripNote: tripNote,
                startedOnMs: startedOnMs,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripsTable, Trip>(table),
                  $$TripsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripChecklistItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tripChecklistItemsRefs) db.tripChecklistItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tripChecklistItemsRefs)
                    await $_getPrefetchedData<
                      Trip,
                      $TripsTable,
                      TripChecklistItem
                    >(
                      currentTable: table,
                      referencedTable: $$TripsTableReferences
                          ._tripChecklistItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TripsTableReferences(
                        db,
                        table,
                        p0,
                      ).tripChecklistItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tripId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, $$TripsTableReferences),
      Trip,
      PrefetchHooks Function({bool tripChecklistItemsRefs})
    >;
typedef $$TripChecklistItemsTableCreateCompanionBuilder =
    TripChecklistItemsCompanion Function({
      required String tripId,
      required String itemId,
      required String itemName,
      Value<int?> quantity,
      Value<String?> note,
      Value<String?> categoryName,
      required String status,
      Value<String?> omissionNote,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$TripChecklistItemsTableUpdateCompanionBuilder =
    TripChecklistItemsCompanion Function({
      Value<String> tripId,
      Value<String> itemId,
      Value<String> itemName,
      Value<int?> quantity,
      Value<String?> note,
      Value<String?> categoryName,
      Value<String> status,
      Value<String?> omissionNote,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TripChecklistItemsTableReferences
    extends
        BaseReferences<
          _$LocalDatabase,
          $TripChecklistItemsTable,
          TripChecklistItem
        > {
  $$TripChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTable _tripIdTable(_$LocalDatabase db) =>
      db.trips.createAlias('trip_checklist_items__trip_id__trips__id');

  $$TripsTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TripChecklistItemsTableFilterComposer
    extends Composer<_$LocalDatabase, $TripChecklistItemsTable> {
  $$TripChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
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

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get omissionNote => $composableBuilder(
    column: $table.omissionNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableFilterComposer get tripId {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripChecklistItemsTableOrderingComposer
    extends Composer<_$LocalDatabase, $TripChecklistItemsTable> {
  $$TripChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
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

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get omissionNote => $composableBuilder(
    column: $table.omissionNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableOrderingComposer get tripId {
    final $$TripsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableOrderingComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripChecklistItemsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $TripChecklistItemsTable> {
  $$TripChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get omissionNote => $composableBuilder(
    column: $table.omissionNote,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TripsTableAnnotationComposer get tripId {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $TripChecklistItemsTable,
          TripChecklistItem,
          $$TripChecklistItemsTableFilterComposer,
          $$TripChecklistItemsTableOrderingComposer,
          $$TripChecklistItemsTableAnnotationComposer,
          $$TripChecklistItemsTableCreateCompanionBuilder,
          $$TripChecklistItemsTableUpdateCompanionBuilder,
          (TripChecklistItem, $$TripChecklistItemsTableReferences),
          TripChecklistItem,
          PrefetchHooks Function({bool tripId})
        > {
  $$TripChecklistItemsTableTableManager(
    _$LocalDatabase db,
    $TripChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripChecklistItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> tripId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<int?> quantity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> omissionNote = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripChecklistItemsCompanion(
                tripId: tripId,
                itemId: itemId,
                itemName: itemName,
                quantity: quantity,
                note: note,
                categoryName: categoryName,
                status: status,
                omissionNote: omissionNote,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tripId,
                required String itemId,
                required String itemName,
                Value<int?> quantity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                required String status,
                Value<String?> omissionNote = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => TripChecklistItemsCompanion.insert(
                tripId: tripId,
                itemId: itemId,
                itemName: itemName,
                quantity: quantity,
                note: note,
                categoryName: categoryName,
                status: status,
                omissionNote: omissionNote,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TripChecklistItemsTable, TripChecklistItem>(
                    table,
                  ),
                  $$TripChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
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
                    if (tripId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tripId,
                        referencedTable: $$TripChecklistItemsTableReferences
                            ._tripIdTable(db),
                        referencedColumn: $$TripChecklistItemsTableReferences
                            ._tripIdTable(db)
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

typedef $$TripChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $TripChecklistItemsTable,
      TripChecklistItem,
      $$TripChecklistItemsTableFilterComposer,
      $$TripChecklistItemsTableOrderingComposer,
      $$TripChecklistItemsTableAnnotationComposer,
      $$TripChecklistItemsTableCreateCompanionBuilder,
      $$TripChecklistItemsTableUpdateCompanionBuilder,
      (TripChecklistItem, $$TripChecklistItemsTableReferences),
      TripChecklistItem,
      PrefetchHooks Function({bool tripId})
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$KitsTableTableManager get kits => $$KitsTableTableManager(_db, _db.kits);
  $$KitCategoriesTableTableManager get kitCategories =>
      $$KitCategoriesTableTableManager(_db, _db.kitCategories);
  $$KitItemsTableTableManager get kitItems =>
      $$KitItemsTableTableManager(_db, _db.kitItems);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$TripChecklistItemsTableTableManager get tripChecklistItems =>
      $$TripChecklistItemsTableTableManager(_db, _db.tripChecklistItems);
}
