import 'package:flutter/material.dart';

class Prize {
  final String name;
  final Color color;
  final IconData icon;

  const Prize({
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  String toString() {
    return 'Prize(name: $name, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Prize &&
        other.name == name &&
        other.color == color &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return name.hashCode ^ color.hashCode ^ icon.hashCode;
  }
} 