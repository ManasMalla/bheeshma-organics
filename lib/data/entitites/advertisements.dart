class Advertisement {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String route;
  final Object arguments;
  final String cta;
  const Advertisement({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    this.route = '/product',
    required this.arguments,
    this.cta = 'Know More',
  });
}
