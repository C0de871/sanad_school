import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class BeautifulEquations extends StatelessWidget {
  const BeautifulEquations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Equations'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Physics Equation Card
              EquationCard(
                title: 'Schrödinger Equation',
                subtitle: 'Quantum Mechanics',
                equation: r'i\hbar\frac{\partial}{\partial t}\Psi(\mathbf{r},t) = \hat H\Psi(\mathbf{r},t) = \left [ \frac{-\hbar^2}{2m}\nabla^2 + V(\mathbf{r},t) \right ] \Psi(\mathbf{r},t)',
                gradientColors: const [Colors.indigo, Colors.purple],
              ),
              const SizedBox(height: 24),

              // Mathematics Equation Card
              EquationCard(
                title: 'Cauchy\'s Integral Formula',
                subtitle: 'Complex Analysis',
                equation: r'f(a) = \frac{1}{2\pi i} \oint_\gamma \frac{f(z)}{z-a} dz',
                gradientColors: const [Colors.teal, Colors.green],
              ),
              const SizedBox(height: 24),

              // Chemistry Equation Card
              EquationCard(
                title: 'Equilibrium Constant',
                subtitle: 'Chemical Thermodynamics',
                equation: r'K_\mathrm{eq} = \frac{[\mathrm{C}]^c[\mathrm{D}]^d}{[\mathrm{A}]^a[\mathrm{B}]^b} \cdot \exp\left(\frac{-\Delta G^{\circ}}{RT}\right)',
                gradientColors: const [Colors.orange, Colors.red],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EquationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String equation;
  final List<Color> gradientColors;

  const EquationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.equation,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: gradientColors[0].withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HtmlWidget(
            "<p><u>Bold Text</u> and <b>Italic Text</b></p>",
            textStyle: const TextStyle(fontSize: 16), // Customize text style
          ),
          // Header with gradient
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Equation container
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Math.tex(
                  equation,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.5,
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
