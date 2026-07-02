import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/user_preferences.dart';
import '../providers/preference_provider.dart';
import '../utils/format_helpers.dart';

/// Pantalla de preferencias del usuario con 5 pestañas:
/// Presupuesto, Ubicación, Servicios, Estilo de vida, Prioridades.
class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    Tab(icon: Icon(Icons.attach_money), text: 'Presupuesto'),
    Tab(icon: Icon(Icons.location_on), text: 'Ubicación'),
    Tab(icon: Icon(Icons.room_service), text: 'Servicios'),
    Tab(icon: Icon(Icons.self_improvement), text: 'Estilo'),
    Tab(icon: Icon(Icons.sort), text: 'Prioridades'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis preferencias'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PresupuestoTab(),
          _UbicacionTab(),
          _ServiciosTab(),
          _EstiloVidaTab(),
          _PrioridadesTab(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAB 1: PRESUPUESTO
// ═══════════════════════════════════════════════════════════════════════

class _PresupuestoTab extends StatefulWidget {
  @override
  State<_PresupuestoTab> createState() => _PresupuestoTabState();
}

class _PresupuestoTabState extends State<_PresupuestoTab> {
  late double _minBudget;
  late double _maxBudget;
  ContractType _contractType = ContractType.semester;

  static const _budgetPresets = [
    ('Económico', 300, 500),
    ('Estándar', 400, 750),
    ('Confortable', 600, 1000),
    ('Premium', 800, 1500),
  ];

  @override
  void initState() {
    super.initState();
    final prefs = context.read<PreferenceProvider>().prefs;
    _minBudget = prefs.minBudget;
    _maxBudget = prefs.maxBudget;
    _contractType = prefs.contractType;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Range label
          Text(
            'Rango de presupuesto mensual',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            F.priceRange(_minBudget, _maxBudget),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: WasiColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          // Range slider
          RangeSlider(
            values: RangeValues(_minBudget, _maxBudget),
            min: 200,
            max: 2000,
            divisions: 36,
            labels: RangeLabels(
              F.price(_minBudget),
              F.price(_maxBudget),
            ),
            onChanged: (values) {
              setState(() {
                _minBudget = values.start;
                _maxBudget = values.end;
              });
              context.read<PreferenceProvider>().updateBudget(
                values.start,
                values.end,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                F.price(200),
                style: const TextStyle(
                  fontSize: 12,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
              Text(
                F.price(2000),
                style: const TextStyle(
                  fontSize: 12,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Presets
          Text(
            'Presets rápidos',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _budgetPresets.map((preset) {
              final isSelected =
                  _minBudget == preset.$2 && _maxBudget == preset.$3;
              return ChoiceChip(
                label: Text(preset.$1),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _minBudget = preset.$2.toDouble();
                    _maxBudget = preset.$3.toDouble();
                  });
                  context.read<PreferenceProvider>().updateBudget(
                    preset.$2.toDouble(),
                    preset.$3.toDouble(),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Contract type
          Text(
            'Tipo de contrato',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...ContractType.values.map((type) {
            return RadioListTile<ContractType>(
              title: Text(_contractTypeLabel(type)),
              subtitle: Text(_contractTypeDesc(type)),
              value: type,
              groupValue: _contractType,
              contentPadding: EdgeInsets.zero,
              dense: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _contractType = value);
                  context.read<PreferenceProvider>().updateContractType(value);
                }
              },
            );
          }),
        ],
      ),
    );
  }

  String _contractTypeLabel(ContractType type) {
    switch (type) {
      case ContractType.monthly:
        return 'Mensual';
      case ContractType.semester:
        return 'Semestral';
      case ContractType.annual:
        return 'Anual';
      case ContractType.flexible:
        return 'Flexible';
    }
  }

  String _contractTypeDesc(ContractType type) {
    switch (type) {
      case ContractType.monthly:
        return 'Renovación mes a mes, mayor flexibilidad';
      case ContractType.semester:
        return 'Por ciclo universitario, precios estables';
      case ContractType.annual:
        return 'Mejor precio, compromiso largo plazo';
      case ContractType.flexible:
        return 'Sin mínimo, ideal para intercambio';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAB 2: UBICACIÓN
// ═══════════════════════════════════════════════════════════════════════

class _UbicacionTab extends StatefulWidget {
  @override
  State<_UbicacionTab> createState() => _UbicacionTabState();
}

class _UbicacionTabState extends State<_UbicacionTab> {
  late double _maxDistance;
  late int _maxWalkingTime;

  static const _universities = [
    'UNSAAC - Universidad Nacional de San Antonio Abad',
    'UANDINA - Universidad Andina del Cusco',
    'UCSP - Universidad Católica San Pablo',
    'UTP - Universidad Tecnológica del Perú',
    'SENATI',
  ];

  static const _districts = [
    'Wanchaq',
    'Santiago',
    'Cusco Centro',
    'San Sebastián',
    'San Jerónimo',
    'Poroy',
  ];

  String _selectedUniversity = 'UNSAAC - Universidad Nacional de San Antonio Abad';

  @override
  void initState() {
    super.initState();
    final prefs = context.read<PreferenceProvider>().prefs;
    _maxDistance = prefs.maxDistance;
    _maxWalkingTime = prefs.maxWalkingTime;
    _selectedUniversity = prefs.university;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferenceProvider>();
    final selectedDistricts = provider.prefs.preferredDistricts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Distance slider
          Text(
            'Distancia máxima',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hasta ${F.distanceKm(_maxDistance)} de la universidad',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: WasiColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _maxDistance,
            min: 0.5,
            max: 10.0,
            divisions: 19,
            label: F.distanceKm(_maxDistance),
            onChanged: (value) {
              setState(() => _maxDistance = value);
              provider.updateMaxDistance(value);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                F.distanceKm(0.5),
                style: const TextStyle(
                  fontSize: 12,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
              Text(
                F.distanceKm(10.0),
                style: const TextStyle(
                  fontSize: 12,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Walking time
          Text(
            'Tiempo máximo caminando',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            F.walkingTimeLabel(_maxWalkingTime.toDouble()),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: WasiColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _maxWalkingTime.toDouble(),
            min: 5,
            max: 60,
            divisions: 11,
            label: F.walkingTime(_maxWalkingTime.toDouble()),
            onChanged: (value) {
              setState(() => _maxWalkingTime = value.round());
              provider.updateMaxWalkingTime(value.round());
            },
          ),
          const SizedBox(height: 24),

          // University selection
          Text(
            'Universidad de referencia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: WasiColors.surfaceVariantLight.withValues(alpha: 0.6),
              borderRadius: WasiRadius.input,
              border: Border.all(color: WasiColors.outlineLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedUniversity,
                isExpanded: true,
                items: _universities.map((uni) {
                  return DropdownMenuItem(
                    value: uni,
                    child: Text(
                      uni,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedUniversity = value);
                    provider.updateUniversity(value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Districts
          Text(
            'Distritos preferidos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _districts.map((district) {
              final isSelected = selectedDistricts.contains(district);
              return FilterChip(
                label: Text(district),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    provider.addPreferredDistrict(district);
                  } else {
                    provider.removePreferredDistrict(district);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAB 3: SERVICIOS
// ═══════════════════════════════════════════════════════════════════════

class _ServiciosTab extends StatelessWidget {
  static const _amenities = [
    ('Wi-Fi', Icons.wifi),
    ('Agua caliente', Icons.hot_tub_outlined),
    ('Cocina compartida', Icons.kitchen_outlined),
    ('Cocina propia', Icons.kitchen),
    ('Lavandería', Icons.local_laundry_service_outlined),
    ('Baño privado', Icons.bathtub_outlined),
    ('Calefacción', Icons.thermostat),
    ('Escritorio', Icons.desk),
    ('Jardín', Icons.yard_outlined),
    ('Estacionamiento', Icons.local_parking),
    ('Seguridad 24/7', Icons.security),
    ('TV', Icons.tv_outlined),
    ('Closet', Icons.checkroom_outlined),
    ('Limpieza', Icons.cleaning_services_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferenceProvider>();
    final selected = provider.prefs.requiredAmenities;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Servicios requeridos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona los servicios que consideras indispensables',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: WasiColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenities.map((amenity) {
              final isSelected = selected.contains(amenity.$1);
              return FilterChip(
                avatar: Icon(
                  amenity.$2,
                  size: 16,
                  color: isSelected
                      ? WasiColors.onPrimaryContainer
                      : WasiColors.textTertiaryLight,
                ),
                label: Text(amenity.$1),
                selected: isSelected,
                onSelected: (selected) {
                  provider.toggleAmenity(amenity.$1);
                },
              );
            }).toList(),
          ),
          if (selected.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: WasiColors.primaryContainer,
                borderRadius: WasiRadius.card,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: WasiColors.onPrimaryContainer,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${selected.length} servicio${selected.length == 1 ? "" : "s"} seleccionado${selected.length == 1 ? "" : "s"}. Las habitaciones que no los tengan serán filtradas.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: WasiColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAB 4: ESTILO DE VIDA
// ═══════════════════════════════════════════════════════════════════════

class _EstiloVidaTab extends StatefulWidget {
  @override
  State<_EstiloVidaTab> createState() => _EstiloVidaTabState();
}

class _EstiloVidaTabState extends State<_EstiloVidaTab> {
  static const _lifestyleTags = [
    'Tranquila',
    'Estudiosa',
    'Creativa',
    'Deportista',
    'Social',
    'Organizada',
    'Amante del café',
    'Gamer',
    'Música',
    'Cocina',
    'Tech',
    'Cultural',
    'Aventurera',
    'Tradicional',
  ];

  bool _smokingOK = false;
  bool _visitorsOK = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferenceProvider>();
    final selectedTags = provider.prefs.lifestyleTags;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags de estilo de vida',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ayuda a encontrar compañeros compatibles',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: WasiColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _lifestyleTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  provider.toggleLifestyleTag(tag);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Toggles
          Text(
            'Preferencias de convivencia',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Se permite fumar'),
            subtitle: const Text('Aceptas que se fume en la vivienda'),
            value: _smokingOK,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() => _smokingOK = value);
              provider.updateSmokingOK(value);
            },
          ),
          SwitchListTile(
            title: const Text('Se permiten visitas'),
            subtitle: const Text('Amigos y familiares pueden visitarte'),
            value: _visitorsOK,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() => _visitorsOK = value);
              provider.updateVisitorsOK(value);
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAB 5: PRIORIDADES
// ═══════════════════════════════════════════════════════════════════════

class _PrioridadesTab extends StatefulWidget {
  @override
  State<_PrioridadesTab> createState() => _PrioridadesTabState();
}

class _PrioridadesTabState extends State<_PrioridadesTab> {
  late List<PriorityItem> _priorities;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<PreferenceProvider>().prefs;
    _priorities = List.from(prefs.priorities);
    if (_priorities.isEmpty) {
      _priorities = List.from(PriorityItem.defaultPriorities);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalWeight = _priorities.fold(0, (sum, p) => sum + p.weight);

    return Column(
      children: [
        // Weight bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: WasiColors.surfaceLight,
            borderRadius: WasiRadius.card,
            border: Border.all(
              color: WasiColors.outlineLight.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Distribución de prioridades',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    'Total: $totalWeight puntos',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: WasiColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 12,
                  child: Row(
                    children: _priorities.map((p) {
                      final fraction =
                          totalWeight > 0 ? p.weight / totalWeight : 0.0;
                      return Expanded(
                        flex: (fraction * 100).round().clamp(1, 100),
                        child: Container(
                          color: _parseHexColor(p.color),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 10,
                runSpacing: 4,
                children: _priorities.map((p) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _parseHexColor(p.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p.label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: WasiColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Reorderable list
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Arrastra para reordenar. Ajusta el peso de cada prioridad.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: WasiColors.textSecondaryLight,
                ),
              ),
            ),
            itemCount: _priorities.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _priorities.removeAt(oldIndex);
                _priorities.insert(newIndex, item);
              });
              context.read<PreferenceProvider>().reorderPriorities(_priorities);
            },
            itemBuilder: (context, index) {
              final priority = _priorities[index];
              return _PriorityTile(
                key: ValueKey(priority.id),
                priority: priority,
                onWeightChanged: (weight) {
                  setState(() {
                    _priorities[index] = priority.copyWith(weight: weight);
                  });
                  context
                      .read<PreferenceProvider>()
                      .updatePriorityWeight(priority.id, weight);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Color _parseHexColor(String hex) {
    final hexStr = hex.replaceFirst('#', '');
    return Color(int.parse('FF$hexStr', radix: 16));
  }
}

class _PriorityTile extends StatelessWidget {
  final PriorityItem priority;
  final ValueChanged<int> onWeightChanged;

  const _PriorityTile({
    super.key,
    required this.priority,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.drag_handle, color: WasiColors.textTertiaryLight),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priority.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: priority.weight.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '${priority.weight}',
                    onChanged: (v) => onWeightChanged(v.round()),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _parseHexColor(priority.color).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${priority.weight}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _parseHexColor(priority.color),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseHexColor(String hex) {
    final hexStr = hex.replaceFirst('#', '');
    return Color(int.parse('FF$hexStr', radix: 16));
  }
}
