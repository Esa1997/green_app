class DeliveryItem {
  String id;
  String senderId;
  String senderName;
  String senderEmail;
  String receiverName;
  String receiverPhone;
  String receiverAddress;
  String date;
  String total;

  DeliveryItem({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverAddress,
    required this.date,
    required this.total,
  });
}