import '../models/models.dart';

class MockData {
  MockData._();

  static const currentUser = UserModel(
    id: '1',
    name: 'Samantha',
    email: 'samantha@email.com',
    phone: '+1234567890',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
  );

  static const List<SalonModel> featuredSalons = [
    SalonModel(
      id: '1',
      name: 'Salon de Elegance',
      address: '360 Stillwater Rd. Palm City..',
      rating: 4.8,
      reviewCount: 3100,
      categories: ['Hair', 'Nails', 'Facial'],
      imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
      isFavorite: false,
    ),
    SalonModel(
      id: '2',
      name: 'Plush Beauty Lounge',
      address: '360 Stillwater Rd. Palm City, FL 34990',
      rating: 4.7,
      reviewCount: 2700,
      categories: ['Hair', 'Facial', 'Nails', '2+'],
      imageUrl: 'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=400',
      discount: 58,
      isOpen: true,
      paxAvailable: 6,
      isFavorite: true,
      viewCount: 10000,
      about: 'Living up to our name Plush Beauty Lounge, the team is highly energetic and creative. We believe that if it matters to you, it matters to us.\n\nKeeping up to speed with the market\'s latest trends, Plush Beauty Lounge recognizes the need for constant improvements. Our team receives regular training from hairdressers all around the world.',
      openingHours: {
        'Monday - Friday': '08:00am - 03:00pm',
        'Saturday - Sunday': '09:00am - 02:00pm',
      },
    ),
    SalonModel(
      id: '3',
      name: 'Sophisticated Salon',
      address: '2807 Sherwood Circle, Kern..',
      rating: 4.7,
      reviewCount: 2700,
      categories: ['Hair', 'Facial'],
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
      distance: '1.1km',
      discount: 58,
      isFavorite: true,
    ),
  ];

  static const List<SalonModel> nearbySalons = [
    SalonModel(
      id: '3',
      name: 'Sophisticated Salon',
      address: '2807 Sherwood Circle, Kern..',
      rating: 4.7,
      reviewCount: 2700,
      categories: ['Hair', 'Facial'],
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
      distance: '1.1km',
      discount: 58,
      isFavorite: true,
    ),
    SalonModel(
      id: '4',
      name: 'Lovely Lather',
      address: '360 Stillwater Rd. Palm City..',
      rating: 4.7,
      reviewCount: 2700,
      categories: ['Hair', 'Facial'],
      imageUrl: 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?w=400',
      distance: '1.1km',
      discount: 58,
      isFavorite: false,
    ),
    SalonModel(
      id: '5',
      name: 'Cute Stuff Salon',
      address: '360 Stillwater Rd. Palm City..',
      rating: 4.7,
      reviewCount: 2700,
      categories: ['Hair', 'Facial'],
      imageUrl: 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?w=400',
      distance: '1.1km',
      discount: 58,
      isFavorite: false,
    ),
    SalonModel(
      id: '6',
      name: 'Love Live Salon',
      address: '360 Stillwater Rd. Palm City..',
      rating: 4.7,
      reviewCount: 2700,
      categories: ['Hair', 'Facial'],
      imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400',
      distance: '1.1km',
      discount: 58,
      isFavorite: false,
    ),
  ];

  static const List<ServiceModel> hairServices = [
    ServiceModel(
      id: 's1',
      name: 'Woman Medium Blunt Cut',
      price: 40,
      originalPrice: 50,
      duration: '2 hour',
      description: 'A blunt cut bob is a shorter hairstyle that\'s cut into a straight line at the ends. Bobs have proven themselves to be a versatile cut regardless of hair type or texture.',
      imageUrl: 'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=400',
      discount: 20,
      category: 'Haircut',
    ),
    ServiceModel(
      id: 's2',
      name: 'Bob/ Lob Cut',
      price: 55,
      originalPrice: 55,
      duration: '1.5 hour',
      description: 'lob haircut is a women\'s hairstyle that is cut somewhere between the chin and the collarbone.',
      imageUrl: 'https://images.unsplash.com/photo-1492106087820-71f1a00d2b11?w=400',
      discount: 20,
      category: 'Haircut',
    ),
    ServiceModel(
      id: 's3',
      name: 'Medium Length Layer Cut',
      price: 80,
      originalPrice: 80,
      duration: '1 hour',
      description: 'Layered hair is a hairstyle that gives the illusion of length and volume using long and short layers.',
      imageUrl: 'https://images.unsplash.com/photo-1519699047748-de8e457a634e?w=400',
      discount: 0,
      category: 'Haircut',
    ),
    ServiceModel(
      id: 's4',
      name: 'V-Shaped Cut',
      price: 90,
      originalPrice: 90,
      duration: '2.5 hour',
      description: 'There are a lot of variations between v-shaped cuts from subtle to dramatic.',
      imageUrl: 'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?w=400',
      discount: 5,
      category: 'Haircut',
    ),
  ];

  static const List<ServiceModel> facialServices = [
    ServiceModel(
      id: 's5',
      name: 'Classic Facial',
      price: 60,
      originalPrice: 75,
      duration: '1 hour',
      description: 'A classic facial treatment including cleansing, exfoliation, and moisturizing.',
      imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400',
      discount: 20,
      category: 'Facial',
    ),
    ServiceModel(
      id: 's6',
      name: 'Deep Cleansing Facial',
      price: 85,
      originalPrice: 100,
      duration: '1.5 hour',
      description: 'Deep pore cleansing facial with steam and extraction.',
      imageUrl: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=400',
      discount: 15,
      category: 'Facial',
    ),
  ];

  static const List<ServiceModel> nailServices = [
    ServiceModel(
      id: 's7',
      name: 'Manicure',
      price: 50,
      originalPrice: 50,
      duration: '45 min',
      description: 'Full manicure service including nail shaping, cuticle care, and polish.',
      imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=400',
      discount: 0,
      category: 'Nails',
    ),
  ];

  static const List<SpecialistModel> specialists = [
    SpecialistModel(
      id: 'sp1',
      name: 'Ronald',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
    SpecialistModel(
      id: 'sp2',
      name: 'Merry',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    ),
    SpecialistModel(
      id: 'sp3',
      name: 'Bella',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    ),
    SpecialistModel(
      id: 'sp4',
      name: 'Joseph',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    ),
  ];

  static const List<ReviewModel> reviews = [
    ReviewModel(
      id: 'r1',
      userName: 'Jennie Whang',
      userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      rating: 4,
      comment: 'The place was clean, great serivce, stall are friendly. I will certainly recommend to my friends and visit again! :)',
      time: '2 days ago',
    ),
    ReviewModel(
      id: 'r2',
      userName: 'Nathalie',
      userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      rating: 4.5,
      comment: 'Very nice service from the specialist. I always going here for my treatment.',
      time: '1 weeks ago',
    ),
    ReviewModel(
      id: 'r3',
      userName: 'Julia Martha',
      userImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      rating: 3.5,
      comment: 'This is my favourite place to treat my hair :)',
      time: '2 weeks ago',
    ),
  ];

  static const List<MessageModel> messages = [
    MessageModel(
      id: 'm1',
      salonName: 'Plush Beauty Lounge',
      salonImage: 'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=100',
      lastMessage: 'Good morning, anything we ca...',
      time: '11.32 PM',
      unreadCount: 2,
    ),
    MessageModel(
      id: 'm2',
      salonName: 'Lovely Lather',
      salonImage: 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?w=100',
      lastMessage: 'Good morning, anything we ca...',
      time: '11.32 PM',
      unreadCount: 2,
    ),
    MessageModel(
      id: 'm3',
      salonName: 'Cute Stuff Salon',
      salonImage: 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?w=100',
      lastMessage: 'I would like to book an appoin...',
      time: 'Yesterday',
    ),
    MessageModel(
      id: 'm4',
      salonName: 'Love Live Salon',
      salonImage: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=100',
      lastMessage: 'I would like to book an appoin...',
      time: 'Yesterday',
    ),
    MessageModel(
      id: 'm5',
      salonName: 'Glitter Pop Salon',
      salonImage: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=100',
      lastMessage: 'I would like to book an appoin...',
      time: 'Yesterday',
    ),
  ];

  static const List<ChatMessageModel> chatMessages = [
    ChatMessageModel(
      id: 'c1',
      text: 'Hello, good morning :)',
      isMe: true,
      time: '11:20 PM',
      isRead: true,
    ),
    ChatMessageModel(
      id: 'c2',
      text: 'Good morning, anything we can help at Plush Beauty Longue Salon?',
      isMe: false,
      time: '11:20 PM',
    ),
    ChatMessageModel(
      id: 'c3',
      text: 'This look awesome 😍',
      isMe: true,
      time: '11:20 PM',
      isRead: true,
    ),
    ChatMessageModel(
      id: 'c4',
      imageUrl: 'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=300',
      isMe: true,
      time: '11:20 PM',
      isRead: true,
    ),
    ChatMessageModel(
      id: 'c5',
      text: 'I would like to book an appointment at 2:30 PM today.',
      isMe: true,
      time: '11:20 PM',
      isRead: true,
    ),
  ];

  static const List<NotificationModel> notifications = [
    NotificationModel(
      id: 'n1',
      title: 'Reminder!',
      body: 'Get ready for your appointment at 9am',
      time: 'Just now',
      type: NotificationType.reminder,
      isNew: true,
    ),
    NotificationModel(
      id: 'n2',
      title: 'Payment at Lovely Lather was success!',
      body: '',
      time: '11.32 PM',
      type: NotificationType.payment,
      isNew: true,
    ),
    NotificationModel(
      id: 'n3',
      title: 'You make an appointment with Lovely Lather',
      body: '',
      time: 'Yesterday',
      type: NotificationType.reminder,
    ),
    NotificationModel(
      id: 'n4',
      title: 'Get 20% offers for hair service at Lovely Lather',
      body: '',
      time: '2 days ago',
      type: NotificationType.offer,
    ),
    NotificationModel(
      id: 'n5',
      title: 'Get 10% offers for hair service at Love Live Salon',
      body: '',
      time: '2 days ago',
      type: NotificationType.offer,
    ),
    NotificationModel(
      id: 'n6',
      title: 'Reminder!',
      body: 'Get ready for your appointment at 9am',
      time: '3 Mar',
      type: NotificationType.reminder,
    ),
  ];

  static const List<String> galleryImages = [
    'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=300',
    'https://images.unsplash.com/photo-1492106087820-71f1a00d2b11?w=300',
    'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?w=300',
    'https://images.unsplash.com/photo-1519699047748-de8e457a634e?w=300',
  ];

  static const List<String> salonFollowImages = [
    'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=100',
    'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?w=100',
    'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=100',
    'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?w=100',
    'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=100',
  ];

  static const List<String> recentSearches = [
    'Hair service',
    'Nail',
    'Wax',
  ];

  static const List<String> popularSearches = [
    'Hair',
    'Nails',
    'Coloring',
    'Message',
    'Facials',
  ];

  static const List<String> serviceCategories = [
    'Haircut',
    'Nails',
    'Facial',
    'Coloring',
    'Spa',
    'Waxing',
    'Makeup',
    'Massage',
  ];
}
