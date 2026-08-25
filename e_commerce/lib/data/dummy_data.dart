import '../models/cart_item.dart';
import '../models/chat_preview.dart';
import '../models/product.dart';

final List<CartItem> dummyCartItems = [
  CartItem(
    id: '1',
    name: 'Telur gulung pak tan',
    price: 59.99,
    imageUrl: 'assets/images/0230eee1cced79a881276b4be2fb0d30.jpg',
    quantity: 1,
  ),
  CartItem(
    id: '2',
    name: 'Klepon mbak tatik',
    price: 39.5,
    imageUrl: 'assets/images/4d35f40de453901dfa94d86b9f763584.jpg',
    quantity: 2,
  ),
  CartItem(
    id: '3',
    name: 'Papeda Cak pan',
    price: 24.0,
    imageUrl: 'assets/images/503561a2bb1389e32727ad08f39028d9.jpg',
    quantity: 1,
  ),
  CartItem(
    id: '4',
    name: 'Dawet berkah asri',
    price: 89.0,
    imageUrl: 'assets/images/6c1c560f2153368156310ff8594ba4a2.jpg',
    quantity: 1,
  ),
];

// DEVIASI 1 (lihat PRD): modul asli pakai myProductName = kategori itu
// sendiri, harga '$65' dan diskon '-58%' hardcoded sama untuk 4 kartu —
// data stub belum selesai. Di sini tiap Product beda nama/harga/diskon.
final List<Product> dummyProducts = [
  Product(
    id: 'p1',
    name: 'Risol Risky putra',
    price: 65,
    discountPercent: 20,
    imageUrl: 'assets/images/0230eee1cced79a881276b4be2fb0d30.jpg',
    description: 'Risol goreng isi sayuran dan daging ayam, cocok untuk camilan atau bekal',
  ),
  Product(
    id: 'p2',
    name: 'Mie ayam abang adek',
    price: 89,
    discountPercent: 15,
    imageUrl: 'assets/images/4d35f40de453901dfa94d86b9f763584.jpg',
    description: 'mie ayam spesial dengan topping ayam suwir dan pangsit goreng',
  ),
  Product(
    id: 'p3',
    name: 'Gethuk mbah lastri',
    price: 42,
    discountPercent: 0,
    imageUrl: 'assets/images/503561a2bb1389e32727ad08f39028d9.jpg',
    description: 'gethuk tradisional khas Jawa dengan rasa manis dan kenyal',
  ),
  Product(
    id: 'p4',
    name: 'Ban Tambal Bambang',
    price: 120,
    discountPercent: 30,
    imageUrl: 'assets/images/6c1c560f2153368156310ff8594ba4a2.jpg',
    description: 'Ban mobil all-season dengan tapak anti-slip dan daya tahan tinggi',
  ),
  Product(
    id: 'p5',
    name: 'Kristal Agil Jaya',
    price: 15,
    discountPercent: 10,
    imageUrl: 'assets/images/948c78ba269f1265ae1496582acc3441.jpg',
    description: 'Kacamata hitam gaya retro dengan lensa UV400',
  ),
];

// isUnread dipasang per-chat berdasarkan status pesan sungguhan (bukan
// otomatis item pertama seperti modul asli — lihat catatan bug PRD).
final List<ChatPreview> dummyChats = [
  ChatPreview(
    name: 'Klepon Mbak Tatik',
    lastMessage: 'apakah pesanan saya sudah dikirim?',
    time: '09:41',
    avatarAsset: 'assets/images/9d1d428eb91e669fb41a05866037b91f.jpg',
    isUnread: true,
  ),
  ChatPreview(
    name: 'Telur gulung Pak Tan',
    lastMessage: 'Mau pesan lagi telur gulungnya, Pak?',
    time: '08:15',
    avatarAsset: 'assets/images/c741a654deaf5cd3ce8aca3c7064c525.jpg',
  ),
  ChatPreview(
    name: 'Griya Dawet Asri',
    lastMessage: 'dawetnya sudah dikirim, silakan cek resi di email',
    time: 'Kemarin',
    avatarAsset: 'assets/images/car.jpg',
    isUnread: true,
  ),
  ChatPreview(
    name: 'Pak Bambang Tambal Ban',
    lastMessage: 'Terima kasih sudah belanja di toko kami!',
    time: 'Kemarin',
    avatarAsset: 'assets/images/e78cc6d82172d93eb0c4b2e043ddf3f3.jpg',
  ),
];
