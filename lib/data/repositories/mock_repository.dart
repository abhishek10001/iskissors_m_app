import '../models/models.dart';
import 'mock_data.dart';

class MockRepository {
  // Auth
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.currentUser;
  }

  Future<UserModel> signUp(String name, String email, String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockData.currentUser;
  }

  Future<void> sendOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return otp == '4251';
  }

  Future<void> resetPassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Salons
  Future<List<SalonModel>> getFeaturedSalons() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.featuredSalons;
  }

  Future<List<SalonModel>> getNearbySalons() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.nearbySalons;
  }

  Future<SalonModel> getSalonById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = [...MockData.featuredSalons, ...MockData.nearbySalons];
    return all.firstWhere((s) => s.id == id, orElse: () => MockData.featuredSalons[1]);
  }

  Stream<List<SalonModel>> watchFeaturedSalons() async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield MockData.featuredSalons;
  }

  Stream<List<SalonModel>> watchNearbySalons() async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield MockData.nearbySalons;
  }

  // Services
  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    switch (category.toLowerCase()) {
      case 'haircut':
        return MockData.hairServices;
      case 'facial':
        return MockData.facialServices;
      case 'nails':
        return MockData.nailServices;
      default:
        return MockData.hairServices;
    }
  }

  Future<List<ServiceModel>> getAllServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [...MockData.hairServices, ...MockData.facialServices, ...MockData.nailServices];
  }

  // Specialists
  Future<List<SpecialistModel>> getSpecialists() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.specialists;
  }

  // Reviews
  Future<List<ReviewModel>> getReviews(String salonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.reviews;
  }

  // Messages
  Stream<List<MessageModel>> watchMessages() async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield MockData.messages;
  }

  Future<List<ChatMessageModel>> getChatMessages(String salonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.chatMessages;
  }

  // Notifications
  Stream<List<NotificationModel>> watchNotifications() async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield MockData.notifications;
  }

  // Gallery
  Future<List<String>> getGallery(String salonId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.galleryImages;
  }

  // Bookings
  Future<BookingModel> createBooking({
    required SalonModel salon,
    required List<ServiceModel> services,
    required SpecialistModel specialist,
    required DateTime date,
    required String time,
    String notes = '',
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final subTotal = services.fold<double>(0, (sum, s) => sum + s.originalPrice);
    final discountAmount = services.fold<double>(0, (sum, s) => sum + (s.originalPrice - s.price));
    return BookingModel(
      id: 'b${DateTime.now().millisecondsSinceEpoch}',
      salon: salon,
      services: services,
      specialist: specialist,
      date: date,
      time: time,
      notes: notes,
      subTotal: subTotal,
      discount: discountAmount,
      total: subTotal - discountAmount,
    );
  }

  /// Realtime seat availability stream.
  /// Simulates data from OpenCV + Raspberry Pi cameras.
  /// Emits new data every 5 seconds with slight fluctuations.
  Stream<Map<String, SeatAvailabilityModel>> watchSeatAvailability() async* {
    // Initial seed data per salon
    final salonSeats = {
      '1': (total: 8, occupied: 3),
      '2': (total: 10, occupied: 6),
      '3': (total: 6, occupied: 4),
      '4': (total: 5, occupied: 2),
      '5': (total: 8, occupied: 7),
      '6': (total: 4, occupied: 1),
    };

    var tick = 0;
    while (true) {
      final now = DateTime.now();
      final result = <String, SeatAvailabilityModel>{};

      for (final entry in salonSeats.entries) {
        // Simulate minor fluctuations (+/-1) every tick
        final baseOccupied = entry.value.occupied;
        final total = entry.value.total;
        final delta = (tick % 3 == 0) ? 1 : (tick % 5 == 0 ? -1 : 0);
        final occupied = (baseOccupied + delta).clamp(0, total);

        result[entry.key] = SeatAvailabilityModel(
          salonId: entry.key,
          totalSeats: total,
          occupiedSeats: occupied,
          lastUpdated: now,
        );
      }

      yield result;
      tick++;
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
