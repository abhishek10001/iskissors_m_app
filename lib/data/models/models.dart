class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl = '',
  });
}

class SalonModel {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final List<String> categories;
  final String imageUrl;
  final String distance;
  final int discount;
  final bool isOpen;
  final int paxAvailable;
  final String about;
  final int viewCount;
  final Map<String, String> openingHours;
  final bool isFavorite;

  const SalonModel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    required this.imageUrl,
    this.distance = '',
    this.discount = 0,
    this.isOpen = true,
    this.paxAvailable = 0,
    this.about = '',
    this.viewCount = 0,
    this.openingHours = const {},
    this.isFavorite = false,
  });

  SalonModel copyWith({bool? isFavorite}) {
    return SalonModel(
      id: id,
      name: name,
      address: address,
      rating: rating,
      reviewCount: reviewCount,
      categories: categories,
      imageUrl: imageUrl,
      distance: distance,
      discount: discount,
      isOpen: isOpen,
      paxAvailable: paxAvailable,
      about: about,
      viewCount: viewCount,
      openingHours: openingHours,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String duration;
  final String description;
  final String imageUrl;
  final int discount;
  final String category;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.duration,
    required this.description,
    required this.imageUrl,
    this.discount = 0,
    required this.category,
  });
}

class SpecialistModel {
  final String id;
  final String name;
  final String imageUrl;

  const SpecialistModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class BookingModel {
  final String id;
  final SalonModel salon;
  final List<ServiceModel> services;
  final SpecialistModel specialist;
  final DateTime date;
  final String time;
  final String notes;
  final double subTotal;
  final double discount;
  final double total;

  const BookingModel({
    required this.id,
    required this.salon,
    required this.services,
    required this.specialist,
    required this.date,
    required this.time,
    this.notes = '',
    required this.subTotal,
    required this.discount,
    required this.total,
  });
}

class MessageModel {
  final String id;
  final String salonName;
  final String salonImage;
  final String lastMessage;
  final String time;
  final int unreadCount;

  const MessageModel({
    required this.id,
    required this.salonName,
    required this.salonImage,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
  });
}

class ChatMessageModel {
  final String id;
  final String? text;
  final String? imageUrl;
  final bool isMe;
  final String time;
  final bool isRead;

  const ChatMessageModel({
    required this.id,
    this.text,
    this.imageUrl,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final NotificationType type;
  final bool isNew;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isNew = false,
  });
}

enum NotificationType { reminder, payment, offer }

class ReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final String time;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.time,
  });
}

/// Realtime seat/chair availability data.
/// In production, this will come from OpenCV + Raspberry Pi cameras
/// detecting occupied vs empty chairs in each salon.
class SeatAvailabilityModel {
  final String salonId;
  final int totalSeats;
  final int occupiedSeats;
  final DateTime lastUpdated;

  const SeatAvailabilityModel({
    required this.salonId,
    required this.totalSeats,
    required this.occupiedSeats,
    required this.lastUpdated,
  });

  int get availableSeats => totalSeats - occupiedSeats;
  double get occupancyPercent =>
      totalSeats > 0 ? (occupiedSeats / totalSeats) * 100 : 0;
  bool get isFull => availableSeats <= 0;
  bool get isAlmostFull => !isFull && availableSeats <= 2;
}
