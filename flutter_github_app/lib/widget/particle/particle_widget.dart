import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_github_app/widget/particle/particle_painter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_github_app/widget/particle/particle_model.dart';

class ParticleWidget extends StatefulWidget {
  final int numerOfParticles;

  ParticleWidget(this.numerOfParticles);

  @override
  _ParticleWidgetState createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget> {
  final random = Random();
  final particles = List<ParticleModel>();

  @override
  void initState() {
    widget.numerOfParticles.times(() {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation(
      tween: ConstantTween(1),
      builder: (context, child, value) {
        _simulateParticles();
        return CustomPaint(
          painter: ParticlePainter(particles),
        );
      },
    );
  }

  _simulateParticles() {
    particles.forEach((particle) => particle.checkParticleNeedsToBeRestarted());
  }
}
