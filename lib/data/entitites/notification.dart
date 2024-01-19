class BheeshmaNotification {
  final String title;
  final String body;
  final String image;
  final String type;
  final String id;
  final String updatedAt;
  final String cta;
  final String route;
  final Object payload;

  const BheeshmaNotification(
      {required this.title,
      required this.body,
      required this.image,
      required this.type,
      required this.id,
      required this.updatedAt,
      this.cta = 'Explore now',
      this.route = '',
      this.payload = ''});
}
