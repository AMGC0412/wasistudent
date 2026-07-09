import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'database.dart';

/// Modelo de contrato de arrendamiento.
class ContractModel {
  final String id;
  final String roomId;
  final String roomTitle;
  final double monthlyRent;
  final DateTime startDate;
  final DateTime endDate;
  final String tenantId;
  final String tenantName;
  final String tenantDni;
  final String tenantEmail;
  final String tenantPhone;
  final String ownerId;
  final String ownerName;
  final List<String> acceptedClauses;
  final DateTime signedAt;
  final String status; // active, completed, cancelled

  const ContractModel({
    required this.id,
    required this.roomId,
    required this.roomTitle,
    required this.monthlyRent,
    required this.startDate,
    required this.endDate,
    required this.tenantId,
    required this.tenantName,
    required this.tenantDni,
    required this.tenantEmail,
    required this.tenantPhone,
    required this.ownerId,
    required this.ownerName,
    required this.acceptedClauses,
    required this.signedAt,
    this.status = 'active',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomId': roomId,
        'roomTitle': roomTitle,
        'monthlyRent': monthlyRent,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'tenantId': tenantId,
        'tenantName': tenantName,
        'tenantDni': tenantDni,
        'tenantEmail': tenantEmail,
        'tenantPhone': tenantPhone,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'acceptedClauses': acceptedClauses,
        'signedAt': signedAt.toIso8601String(),
        'status': status,
      };

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
        id: json['id'] as String? ?? '',
        roomId: json['roomId'] as String? ?? '',
        roomTitle: json['roomTitle'] as String? ?? '',
        monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0.0,
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'] as String)
            : DateTime.now(),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : DateTime.now().add(const Duration(days: 180)),
        tenantId: json['tenantId'] as String? ?? '',
        tenantName: json['tenantName'] as String? ?? '',
        tenantDni: json['tenantDni'] as String? ?? '',
        tenantEmail: json['tenantEmail'] as String? ?? '',
        tenantPhone: json['tenantPhone'] as String? ?? '',
        ownerId: json['ownerId'] as String? ?? '',
        ownerName: json['ownerName'] as String? ?? '',
        acceptedClauses:
            List<String>.from(json['acceptedClauses'] as List? ?? []),
        signedAt: json['signedAt'] != null
            ? DateTime.parse(json['signedAt'] as String)
            : DateTime.now(),
        status: json['status'] as String? ?? 'active',
      );
}

/// Repositorio de contratos.
class ContractRepository {
  static const _uuid = Uuid();

  static List<ContractModel> getAll() {
    return Database.contractsBox.values.map((v) {
      final map = Map<String, dynamic>.from(jsonDecode(v as String));
      return ContractModel.fromJson(map);
    }).toList()
      ..sort((a, b) => b.signedAt.compareTo(a.signedAt));
  }

  static List<ContractModel> getByTenant(String tenantId) {
    return getAll().where((c) => c.tenantId == tenantId).toList();
  }

  static List<ContractModel> getByOwner(String ownerId) {
    return getAll().where((c) => c.ownerId == ownerId).toList();
  }

  static Future<ContractModel> create(ContractModel contract) async {
    final newContract = contract.copyWith(id: _uuid.v4());
    await Database.contractsBox.put(
        newContract.id, jsonEncode(newContract.toJson()));
    return newContract;
  }

  static Future<void> update(ContractModel contract) async {
    await Database.contractsBox.put(
        contract.id, jsonEncode(contract.toJson()));
  }

  static Future<void> delete(String id) async {
    await Database.contractsBox.delete(id);
  }
}

extension on ContractModel {
  ContractModel copyWith({String? id}) => ContractModel(
        id: id ?? this.id,
        roomId: roomId,
        roomTitle: roomTitle,
        monthlyRent: monthlyRent,
        startDate: startDate,
        endDate: endDate,
        tenantId: tenantId,
        tenantName: tenantName,
        tenantDni: tenantDni,
        tenantEmail: tenantEmail,
        tenantPhone: tenantPhone,
        ownerId: ownerId,
        ownerName: ownerName,
        acceptedClauses: acceptedClauses,
        signedAt: signedAt,
        status: status,
      );
}
