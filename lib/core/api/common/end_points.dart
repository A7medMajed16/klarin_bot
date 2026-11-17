import 'env.dart';

class EndPoints {
  static const String baseIp = Env.baseUrl;
  static const String apiUrl = '$baseIp/api/v1';
  static const String baseImageUrl = '$baseIp/uploads/images/';
  static const String baseVideoUrl = '$baseIp/uploads/videos/';
  static const String baseFileUrl = '$baseIp/uploads/files/';
  static const String refreshToken = "/auth/refresh";
  static const String uploadOneFile = "/upload/document";
  static const String uploadOneImage = "/upload/image";
  static const String uploadImages = "/upload/images";

  //!================ AUTH ================
  static const String sendOtp = "/auth/send-otp";
  static const String verifyOtp = "/auth/verify-otp";
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String forgotPassword = "/auth/forgot-password";
  static const String changePassword = "/auth/change-password";

  //!================ GOVERNORATES & REGIONS ================
  static const String governorates = "/governorate";
  static const String regions = "/region";

  //!================USER======================
  //?================HOME======================
  static const String homeSlider = "/sliders";
  static const String categories = "/category";
  static const String lasers = "/laser";
  static const String violins = "/songs";
  //?================PRODUCTS=================
  static const String products = "/product";
  //?================VIP======================
  static const String users = "/users";
  //?================PROFILE==================
  static const String userProfile = "/users/profile";
  //?================CART=====================
  static const String createOrder = "/order";
  static const String productCheckout = "/product/checkout";
  static const String featureCheckout = "/features/checkout";
  static const String applyCoupon = "/coupon/apply";

  //!================ DELIVERY ================
  static const String orders = "/order";
  static const String orderCount = "/order/count";
  static const String profile = "/auth/profile";
  static const String editProfile = "/users/profile";
  static const String product = "/product";
  static const String review = "/review";
  static const String rewards = "/rewards";
  static const String contacts = "/contacts";
  static const String features = "/features";
  static const String transactionsHistory = "/transactions/my-history";

  //!================ NOTIFICATIONS ================
  static const String notifications = "/notification";
  static const String notificationsReadAll = "/notification/read-all";

  //!================ TRANSACTIONS ================
  static const String redeemReward = "/transactions/redeem-reward";
}
