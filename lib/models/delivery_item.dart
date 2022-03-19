class DeliveryItem {
  String id;
  String senderName;
  String senderEmail;
  String receiverName;
  String receiverPhone;
  String receiverAddress;
  String date;
  String flowerUrl;
  String flowerName;
  double flowerPrice;

  DeliveryItem({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverAddress,
    required this.date,
    required this.flowerUrl,
    required this.flowerName,
    required this.flowerPrice,
  });
}