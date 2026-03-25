import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/models.dart';
import '../data/repositories/mock_repository.dart';
import '../data/repositories/mock_data.dart';

// Repository provider
final repositoryProvider = Provider<MockRepository>((ref) => MockRepository());

// Auth state
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.read(repositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final MockRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String name, String email, String phone, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signUp(name, email, phone, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }

  // For demo: login without backend
  void mockLogin() {
    state = const AsyncValue.data(MockData.currentUser);
  }
}

// Salon providers
final featuredSalonsProvider = FutureProvider<List<SalonModel>>((ref) {
  return ref.read(repositoryProvider).getFeaturedSalons();
});

final nearbySalonsProvider = FutureProvider<List<SalonModel>>((ref) {
  return ref.read(repositoryProvider).getNearbySalons();
});

final salonDetailProvider = FutureProvider.family<SalonModel, String>((ref, id) {
  return ref.read(repositoryProvider).getSalonById(id);
});

// Service providers
final servicesByCategoryProvider = FutureProvider.family<List<ServiceModel>, String>((ref, category) {
  return ref.read(repositoryProvider).getServicesByCategory(category);
});

final selectedServicesProvider = StateNotifierProvider<SelectedServicesNotifier, List<ServiceModel>>((ref) {
  return SelectedServicesNotifier();
});

class SelectedServicesNotifier extends StateNotifier<List<ServiceModel>> {
  SelectedServicesNotifier() : super([]);

  void addService(ServiceModel service) {
    if (!state.any((s) => s.id == service.id)) {
      state = [...state, service];
    }
  }

  void removeService(ServiceModel service) {
    state = state.where((s) => s.id != service.id).toList();
  }

  bool isSelected(ServiceModel service) {
    return state.any((s) => s.id == service.id);
  }

  void clear() {
    state = [];
  }

  double get totalPrice => state.fold(0, (sum, s) => sum + s.price);
  double get totalOriginalPrice => state.fold(0, (sum, s) => sum + s.originalPrice);
  double get totalDiscount => totalOriginalPrice - totalPrice;
}

// Specialist provider
final specialistsProvider = FutureProvider<List<SpecialistModel>>((ref) {
  return ref.read(repositoryProvider).getSpecialists();
});

final selectedSpecialistProvider = StateProvider<SpecialistModel?>((ref) => null);

// Booking state
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedTimeProvider = StateProvider<String?>((ref) => null);
final bookingNotesProvider = StateProvider<String>((ref) => '');

// Messages
final messagesProvider = StreamProvider<List<MessageModel>>((ref) {
  return ref.read(repositoryProvider).watchMessages();
});

final chatMessagesProvider = FutureProvider.family<List<ChatMessageModel>, String>((ref, salonId) {
  return ref.read(repositoryProvider).getChatMessages(salonId);
});

// Notifications
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  return ref.read(repositoryProvider).watchNotifications();
});

// Reviews
final reviewsProvider = FutureProvider.family<List<ReviewModel>, String>((ref, salonId) {
  return ref.read(repositoryProvider).getReviews(salonId);
});

// Gallery
final galleryProvider = FutureProvider.family<List<String>, String>((ref, salonId) {
  return ref.read(repositoryProvider).getGallery(salonId);
});

// Bottom nav index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Search
final searchQueryProvider = StateProvider<String>((ref) => '');

// Realtime Seat Availability (OpenCV + Raspberry Pi backend - mock for now)
final seatAvailabilityProvider = StreamProvider<Map<String, SeatAvailabilityModel>>((ref) {
  return ref.read(repositoryProvider).watchSeatAvailability();
});
