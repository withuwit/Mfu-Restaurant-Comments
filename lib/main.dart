import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ==================== FIREBASE CONFIG ====================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final firestore = FirebaseFirestore.instance;

// Helper function to load images (local assets or network)
Widget loadImage(String? imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover, Widget? placeholder}) {
  final defaultPlaceholder = placeholder ?? const Icon(Icons.restaurant, size: 50, color: Color(0xFFFF6B35));
  
  if (imagePath == null || imagePath.isEmpty) {
    return defaultPlaceholder;
  }
  
  // Check if it's a network URL
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => defaultPlaceholder,
    );
  }
  
  // Otherwise, load from local assets
  return Image.asset(
    'assets/images/$imagePath',
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, __, ___) => defaultPlaceholder,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: 'Roboto'),
      home: const LoginPage(),
    );
  }
}

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  String _message = '';
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() { _isLoading = true; _message = ''; });
    try {
      final snapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: _username.text)
          .where('password', isEqualTo: _password.text)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final userId = snapshot.docs.first.id;
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage(userId: userId)));
      } else {
        setState(() { _message = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'; });
      }
    } catch (e) {
      setState(() { _message = 'ไม่สามารถเชื่อมต่อได้: $e'; });
    }
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42), Color(0xFFFFF5E1)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: const Icon(Icons.restaurant_menu, size: 80, color: Color(0xFFFF6B35)),
                ),
                const SizedBox(height: 24),
                const Text('Mfu Restaurant Comments', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('ยินดีต้อนรับ', style: TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 15))],
                  ),
                  child: Column(
                    children: [
                      const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A))),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _username,
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้', hintText: 'กรอกชื่อผู้ใช้',
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFFF6B35)),
                          filled: true, fillColor: const Color(0xFFFFF5E1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _password, obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน', hintText: 'กรอกรหัสผ่าน',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF6B35)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF8B7355)),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true, fillColor: const Color(0xFFFFF5E1),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity, height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      if (_message.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(_message, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== HOMEPAGE ====================
class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _restaurants = [];
  List<Map<String, dynamic>> _filteredRestaurants = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;
  String? _selectedLocation;
  String? _selectedCuisine;
  int? _selectedOpenHour;
  bool _showOpenNow = false;

  final _locations = ['D1', 'E1', 'M', 'S1'];
  final _openHours = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
  final _cuisines = ['ร้านก๋วยเตี๋ยว', 'ร้านอาหารตามสั่ง', 'ร้านข้าวราดแกง', 'อาหารทานเล่น', 'ร้านเครื่องดื่ม'];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
    _fetchFavoriteIds();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _fetchRestaurants() async {
    try {
      final snapshot = await firestore.collection('restaurants').get();
      setState(() {
        _restaurants = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        _filteredRestaurants = _restaurants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _fetchFavoriteIds() async {
    try {
      final snapshot = await firestore
          .collection('favorites')
          .where('user_id', isEqualTo: widget.userId)
          .get();
      setState(() {
        _favoriteIds = snapshot.docs.map((doc) => doc.data()['restaurant_id'] as String).toSet();
      });
    } catch (e) { /* Silent */ }
  }

  Future<void> _toggleFavorite(String restaurantId) async {
    final isFavorite = _favoriteIds.contains(restaurantId);
    try {
      if (isFavorite) {
        final snapshot = await firestore
            .collection('favorites')
            .where('user_id', isEqualTo: widget.userId)
            .where('restaurant_id', isEqualTo: restaurantId)
            .get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        setState(() { _favoriteIds.remove(restaurantId); });
      } else {
        await firestore.collection('favorites').add({
          'user_id': widget.userId,
          'restaurant_id': restaurantId,
          'created_at': FieldValue.serverTimestamp(),
        });
        setState(() { _favoriteIds.add(restaurantId); });
      }
    } catch (e) { /* Handle error */ }
  }

  void _applyFilters() {
    final currentHour = DateTime.now().hour;
    setState(() {
      _filteredRestaurants = _restaurants.where((r) {
        final query = _searchController.text.toLowerCase();
        final name = (r['name'] ?? '').toString().toLowerCase();
        final matchSearch = query.isEmpty || name.contains(query);
        final matchLocation = _selectedLocation == null || r['location'] == _selectedLocation;
        final matchCuisine = _selectedCuisine == null || r['cuisine'] == _selectedCuisine;
        
        // Time filter
        final openHour = (r['time_open_hour'] ?? 0) as int;
        final closeHour = (r['time_close_hour'] ?? 24) as int;
        bool matchTime = true;
        
        if (_showOpenNow) {
          matchTime = currentHour >= openHour && currentHour < closeHour;
        } else if (_selectedOpenHour != null) {
          matchTime = _selectedOpenHour! >= openHour && _selectedOpenHour! < closeHour;
        }
        
        return matchSearch && matchLocation && matchCuisine && matchTime;
      }).toList();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('ตัวกรอง', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
              ]),
              const SizedBox(height: 16),
              const Text('สถานที่', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: _locations.map((loc) => ChoiceChip(
                label: Text(loc), selected: _selectedLocation == loc,
                onSelected: (s) { setModalState(() => _selectedLocation = s ? loc : null); setState(() {}); },
                selectedColor: const Color(0xFFFF6B35), labelStyle: TextStyle(color: _selectedLocation == loc ? Colors.white : null),
              )).toList()),
              const SizedBox(height: 16),
              const Text('ประเภทอาหาร', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: _cuisines.map((c) => ChoiceChip(
                label: Text(c), selected: _selectedCuisine == c,
                onSelected: (s) { setModalState(() => _selectedCuisine = s ? c : null); setState(() {}); },
                selectedColor: const Color(0xFFFF6B35), labelStyle: TextStyle(color: _selectedCuisine == c ? Colors.white : null),
              )).toList()),
              const SizedBox(height: 16),
              const Text('เวลาเปิด', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(children: [
                ChoiceChip(
                  label: const Text('เปิดอยู่ตอนนี้'),
                  selected: _showOpenNow,
                  onSelected: (s) {
                    setModalState(() {
                      _showOpenNow = s;
                      if (s) _selectedOpenHour = null;
                    });
                    setState(() {});
                  },
                  selectedColor: const Color(0xFFFF6B35),
                  labelStyle: TextStyle(color: _showOpenNow ? Colors.white : null),
                ),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _openHours.length,
                  itemBuilder: (_, i) {
                    final hour = _openHours[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('$hour:00'),
                        selected: _selectedOpenHour == hour && !_showOpenNow,
                        onSelected: (s) {
                          setModalState(() {
                            _selectedOpenHour = s ? hour : null;
                            if (s) _showOpenNow = false;
                          });
                          setState(() {});
                        },
                        selectedColor: const Color(0xFFFF6B35),
                        labelStyle: TextStyle(color: _selectedOpenHour == hour && !_showOpenNow ? Colors.white : null),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                onPressed: () { Navigator.pop(ctx); _applyFilters(); },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
                child: const Text('ใช้ตัวกรอง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: TextButton(
                onPressed: () { setModalState(() { _selectedLocation = null; _selectedCuisine = null; _selectedOpenHour = null; _showOpenNow = false; }); _applyFilters(); },
                child: const Text('ล้างตัวกรอง'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.restaurant_menu, size: 32, color: Color(0xFFFF6B35)),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Mfu Restaurant Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('ค้นหาร้านอาหารที่คุณชอบ', style: TextStyle(color: Colors.white70)),
                    ])),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(userId: widget.userId))),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'ค้นหาร้านอาหาร...', prefixIcon: Icon(Icons.search, color: Color(0xFFFF6B35)),
                          border: InputBorder.none, contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    )),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.tune, color: Color(0xFFFF6B35)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            // Restaurant Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)))
                  : _filteredRestaurants.isEmpty
                      ? const Center(child: Text('ไม่พบร้านอาหาร'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.7,
                          ),
                          itemCount: _filteredRestaurants.length,
                          itemBuilder: (ctx, i) {
                            final r = _filteredRestaurants[i];
                            final id = r['id'] as String;
                            final isFav = _favoriteIds.contains(id);
                            return GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => RestaurantDetailPage(restaurant: r, userId: widget.userId),
                              )).then((_) => _fetchFavoriteIds()),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)],
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Stack(children: [
                                      Container(
                                        height: 100, width: double.infinity, color: const Color(0xFFFFE4D6),
                                        child: loadImage(r['image']?.toString(), fit: BoxFit.cover),
                                      ),
                                      Positioned(top: 8, right: 8, child: GestureDetector(
                                        onTap: () => _toggleFavorite(id),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                          child: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 18, color: isFav ? Colors.pink : const Color(0xFFFF6B35)),
                                        ),
                                      )),
                                    ]),
                                  ),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(r['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text(r['cuisine'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF8B7355))),
                                      const Spacer(),
                                      Text('฿${r['price_min'] ?? 0}-${r['price_max'] ?? 0}', style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w600)),
                                      Row(children: [
                                        const Icon(Icons.location_on, size: 14, color: Color(0xFFB0A090)),
                                        Text(r['location'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFFB0A090))),
                                      ]),
                                    ]),
                                  )),
                                ]),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))]),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _navItem(Icons.home, 'หน้าหลัก', true, () {}),
            _navItem(Icons.favorite_border, 'รายการโปรด', false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesPage(userId: widget.userId))).then((_) => _fetchFavoriteIds())),
            _navItem(Icons.person_outline, 'โปรไฟล์', false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(userId: widget.userId)))),
          ]),
        )),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: selected ? const Color(0xFFFF6B35) : const Color(0xFFB0A090)),
        Text(label, style: TextStyle(fontSize: 12, color: selected ? const Color(0xFFFF6B35) : const Color(0xFFB0A090))),
      ]),
    );
  }
}

// ==================== RESTAURANT DETAIL PAGE ====================
class RestaurantDetailPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final String userId;
  const RestaurantDetailPage({super.key, required this.restaurant, required this.userId});
  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  List<Map<String, dynamic>> _menuItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final snapshot = await firestore
          .collection('restaurant_data')
          .where('restaurant_id', isEqualTo: widget.restaurant['id'])
          .get();
      setState(() {
        _menuItems = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF5E1), Color(0xFFFFEDD8)])),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250, pinned: true, backgroundColor: const Color(0xFFFF6B35),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35), size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: const Color(0xFFFFE4D6),
                    child: loadImage(r['image']?.toString(), fit: BoxFit.cover, placeholder: const Icon(Icons.restaurant, size: 80, color: Color(0xFFFF6B35))),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: Container(
                margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(r['cuisine'] ?? '', style: const TextStyle(color: Color(0xFF8B7355))),
                  const SizedBox(height: 16),
                  Wrap(spacing: 8, children: [
                    Chip(avatar: const Icon(Icons.location_on, size: 16), label: Text(r['location'] ?? '')),
                    Chip(avatar: const Icon(Icons.attach_money, size: 16), label: Text('${r['price_min'] ?? 0}-${r['price_max'] ?? 0}')),
                    Chip(avatar: const Icon(Icons.access_time, size: 16), label: Text('${r['time_open_hour'] ?? 0}:00 - ${r['time_close_hour'] ?? 24}:00')),
                  ]),
                ]),
              )),
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  const Icon(Icons.restaurant_menu, color: Color(0xFFFF6B35)),
                  const SizedBox(width: 8),
                  const Text('เมนูอาหาร', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${_menuItems.length} รายการ', style: const TextStyle(color: Color(0xFF8B7355))),
                ]),
              )),
              _isLoading
                  ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35))))
                  : _menuItems.isEmpty
                      ? const SliverFillRemaining(child: Center(child: Text('ยังไม่มีเมนู')))
                      : SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              final m = _menuItems[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                child: Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 80, height: 80, color: const Color(0xFFFFE4D6),
                                      child: loadImage(m['food_image']?.toString(), fit: BoxFit.cover, placeholder: const Icon(Icons.fastfood, color: Color(0xFFFF6B35))),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(m['food_menu_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('฿${m['price'] ?? 0}', style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w600)),
                                  ])),
                                ]),
                              );
                            },
                            childCount: _menuItems.length,
                          )),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== FAVORITES PAGE ====================
class FavoritesPage extends StatefulWidget {
  final String userId;
  const FavoritesPage({super.key, required this.userId});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      final favSnapshot = await firestore
          .collection('favorites')
          .where('user_id', isEqualTo: widget.userId)
          .get();
      
      List<Map<String, dynamic>> restaurants = [];
      for (var favDoc in favSnapshot.docs) {
        final restaurantId = favDoc.data()['restaurant_id'] as String;
        final restaurantDoc = await firestore.collection('restaurants').doc(restaurantId).get();
        if (restaurantDoc.exists) {
          final data = restaurantDoc.data()!;
          data['id'] = restaurantDoc.id;
          restaurants.add(data);
        }
      }
      
      setState(() {
        _favorites = restaurants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _removeFavorite(String restaurantId) async {
    try {
      final snapshot = await firestore
          .collection('favorites')
          .where('user_id', isEqualTo: widget.userId)
          .where('restaurant_id', isEqualTo: restaurantId)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      setState(() { _favorites.removeWhere((r) => r['id'] == restaurantId); });
    } catch (e) { /* Handle */ }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF5E1), Color(0xFFFFEDD8)])),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('รายการโปรด', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFFF6B35).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      const Icon(Icons.favorite, color: Color(0xFFFF6B35), size: 20),
                      const SizedBox(width: 6),
                      Text('${_favorites.length}', style: const TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ]),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)))
                    : _favorites.isEmpty
                        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('ยังไม่มีร้านในรายการโปรด'),
                          ]))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _favorites.length,
                            itemBuilder: (_, i) {
                              final r = _favorites[i];
                              return GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => RestaurantDetailPage(restaurant: r, userId: widget.userId),
                                )).then((_) => _fetchFavorites()),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                  child: Row(children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                                      child: Container(
                                        width: 120, height: 120, color: const Color(0xFFFFE4D6),
                                        child: loadImage(r['image']?.toString(), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Expanded(child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(r['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(r['cuisine'] ?? '', style: const TextStyle(color: Color(0xFF8B7355))),
                                        const SizedBox(height: 8),
                                        Text('฿${r['price_min'] ?? 0}-${r['price_max'] ?? 0}', style: const TextStyle(color: Color(0xFFFF6B35))),
                                      ]),
                                    )),
                                    GestureDetector(
                                      onTap: () => _removeFavorite(r['id']),
                                      child: Container(
                                        padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(color: const Color(0xFFFFE4E4), borderRadius: BorderRadius.circular(12)),
                                        child: const Icon(Icons.favorite, color: Colors.pink),
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== PROFILE PAGE ====================
class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailController = TextEditingController();
  String _username = '';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final doc = await firestore.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _username = data['username'] ?? '';
          _emailController.text = data['email'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() { _isLoading = false; });
      }
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _updateEmail() async {
    setState(() { _isSaving = true; });
    try {
      await firestore.collection('users').doc(widget.userId).update({'email': _emailController.text});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกสำเร็จ'), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('เกิดข้อผิดพลาด'), backgroundColor: Colors.red));
    }
    setState(() { _isSaving = false; });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
            child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF5E1), Color(0xFFFFEDD8)])),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text('โปรไฟล์', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Container(
                        width: 120, height: 120,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(Icons.person, size: 60, color: Color(0xFFFF6B35)),
                      ),
                      const SizedBox(height: 16),
                      Text(_username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('ชื่อผู้ใช้', style: TextStyle(color: Color(0xFF8B7355))),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [const Icon(Icons.person_outline, color: Color(0xFFB0A090)), const SizedBox(width: 12), Text(_username)]),
                          ),
                          const SizedBox(height: 20),
                          const Text('อีเมล', style: TextStyle(color: Color(0xFF8B7355))),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController, keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'กรอกอีเมล', prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFFF6B35)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFFFF6B35).withOpacity(0.3))),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
                            onPressed: _isSaving ? null : _updateEmail,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('บันทึกอีเมล', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          )),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20), width: double.infinity, height: 56,
                        child: OutlinedButton.icon(
                          onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text('ออกจากระบบ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}