import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await seedData();
  print('✅ Seed data complete!');
}

Future<void> seedData() async {
  final firestore = FirebaseFirestore.instance;

  // ============================================================
  // ==================== RESTAURANTS ====================
  // แก้ไขข้อมูลร้านอาหารตรงนี้
  // id: รหัสร้าน (ใช้อ้างอิงใน restaurant_data)
  // ============================================================
  final restaurants = [
    {
      'id': '1',
      'name': 'ร้านลุยเลย999',
      'cuisine': 'ร้านอาหารตามสั่ง',
      'location': 'D1',
      'image': '1-1-1.jpg',
      'price_min': 40,
      'price_max': 70,
      'time_open_hour': 10,
      'time_close_hour': 20,
    },
    {
      'id': '3',
      'name': 'ร้านคนรักชา',
      'cuisine': 'ร้านเครื่องดื่ม',
      'location': 'S1',
      'image': '3-1-2.jpg',
      'price_min': 30,
      'price_max': 45,
      'time_open_hour': 7,
      'time_close_hour': 16,
    },
    {
      'id': '4',
      'name': 'เพื่อนยามท้องว่าง',
      'cuisine': 'อาหารทานเล่น',
      'location': 'S1',
      'image': '4-1-5.jpg',
      'price_min': 5,
      'price_max': 60,
      'time_open_hour': 9,
      'time_close_hour': 18,
    },
    // เพิ่มร้านอาหารเพิ่มเติมตรงนี้...
    // {
    //   'id': '3',
    //   'name': 'ชื่อร้าน',
    //   'cuisine': 'ประเภทร้าน',
    //   'location': 'โลเคชั่น',
    //   'image': 'ชื่อไฟล์รูป.jpg',
    //   'price_min': ราคาต่ำสุด,
    //   'price_max': ราคาสูงสุด,
    //   'time_open_hour': ชั่วโมงเปิด (0-23),
    //   'time_close_hour': ชั่วโมงปิด (0-24),
    // },
  ];

  // ============================================================
  // ==================== RESTAURANT DATA (เมนูอาหาร) ====================
  // แก้ไขเมนูอาหารตรงนี้
  // restaurant_id: ต้องตรงกับ id ของร้านด้านบน
  // Document ID จะเป็น X_Y โดย X = restaurant_id, Y = ลำดับเมนูของร้านนั้น (เริ่มจาก 0)
  // ============================================================
  final restaurant_data = [
    // === เมนูของร้าน 2 (ก๋วยเตี๋ยว) ===
    {'restaurant_id': '2', 'food_menu_name': 'ก๋วยเตี๋ยวต้มยํา', 'price': 45, 'food_image': '2-1-2.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'เกาเหลานํ้าตก', 'price': 45, 'food_image': '2-2-2.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'เกาเหลานํ้าตกต้มยํา', 'price': 35, 'food_image': '2-2-1.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'ก๋วยเตี๋ยวเเห้ง', 'price': 40, 'food_image': '2-5-1.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'เนื้อ(สั่งเพิ่มรายระเอียดเมนู)', 'price': 10, 'food_image': '2-6-1.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'ข้าวหุ่งเปล่า', 'price': 10, 'food_image': '2-4-1.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'แคปหมู', 'price': 10, 'food_image': '2-3-1.jpg'},
    {'restaurant_id': '2', 'food_menu_name': 'พิเศษ', 'price': 10, 'food_image': ''},
    
    // === เมนูของร้าน 0 (ร้านข้าวราดเเกง) ===
    {'restaurant_id': '0', 'food_menu_name': 'ผัดกระเพรา', 'price': 25, 'food_image': '0-1-2.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'ไก่ระเบิด', 'price': 25, 'food_image': '0-1-1.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'ผัดวุ้นเส้น', 'price': 25, 'food_image': '0-1-3.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'พะแนง', 'price': 25, 'food_image': '0-1-4.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'เเกงเขียวหวาน', 'price': 25, 'food_image': '0-1-5.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'นํ้าพริกอ่อง', 'price': 25, 'food_image': '0-1-6.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'ผัดเผ็ดปลาดุก', 'price': 25, 'food_image': '0-1-7.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'ข้าวหุ่ง', 'price': 10, 'food_image': '0-1-8.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'ไข่ดาว', 'price': 5, 'food_image': '0-1-9.jpg'},
    {'restaurant_id': '0', 'food_menu_name': 'เอาเเค่กับ', 'price': 10, 'food_image': '0-1-10.jpg'},
    
    // === เมนูของร้าน 1 (ร้านอาหารตามสั่ง) ===
    {'restaurant_id': '1', 'food_menu_name': 'ผัดกระเพรา', 'price': 40, 'food_image': '1-1-1.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ผัดพริกเกลือ', 'price': 40, 'food_image': '1-1-2.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ผัดวุ้นเส้น', 'price': 40, 'food_image': '1-1-3.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'พะแนง', 'price': 40, 'food_image': '1-1-4.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'เเกงเขียวหวาน', 'price': 40, 'food_image': '1-1-5.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ผัดเปรี้ยวหวาน', 'price': 40, 'food_image': '1-1-6.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ข้าวหมูกรอบ', 'price': 10, 'food_image': '1-1-15.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ข้าวผัด', 'price': 40, 'food_image': '1-1-7.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ข้าวหุ่ง', 'price': 10, 'food_image': '1-1-8.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ไข่ดาว', 'price': 10, 'food_image': '1-1-9.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'หมู(สั่งเพิ่มรายระเอียดเมนู)', 'price': 0, 'food_image': '1-1-10.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'ไก่(สั่งเพิ่มรายระเอียดเมนู)', 'price': 0, 'food_image': '1-1-11.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'กุ้ง(สั่งเพิ่มรายระเอียดเมนู)', 'price': 10, 'food_image': '1-1-12.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'หมูกรอบ(สั่งเพิ่มรายระเอียดเมนู)', 'price': 10, 'food_image': '1-1-13.jpg'},
    {'restaurant_id': '1', 'food_menu_name': 'เนื้อ(สั่งเพิ่มรายระเอียดเมนู)', 'price': 10, 'food_image': '1-1-14.jpg'},
    // เพิ่มเมนูเพิ่มเติมตรงนี้...
    // {'restaurant_id': 'รหัสร้าน', 'food_menu_name': 'ชื่อเมนู', 'price': ราคา, 'food_image': 'ชื่อรูป.jpg'},
    // === เมนูของร้าน 3 (ร้านเครื่องดื่ม) === 
    {'restaurant_id': '3', 'food_menu_name': 'ชาเขียวมะนาวโซดา', 'price': 30, 'food_image': '3-1-1.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'ชาเขียวนม', 'price': 40, 'food_image': '3-1-2.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'นมสด', 'price': 35, 'food_image': '3-1-3.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'กาเเฟ', 'price': 40, 'food_image': '3-1-4.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'ชานมเย็น', 'price': 35, 'food_image': '3-1-5.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'นมชมพู', 'price': 35, 'food_image': '3-1-6.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'น้ำผึ้งมะนาวโซดา', 'price': 30, 'food_image': '3-1-7.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'บรูฮาวายโซดา', 'price': 30, 'food_image': '3-1-8.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'เฉาก้วยนมสด', 'price': 40, 'food_image': '3-1-9.jpg'},
    {'restaurant_id': '3', 'food_menu_name': 'ไข่มุข(สั่งเพิ่มรายระเอียดเมนู)', 'price': 5, 'food_image': '3-1-10.jpg'},

    // === เมนูของร้าน 4 (อาหารทานเล่น) ===

    {'restaurant_id': '4', 'food_menu_name': 'ใส้กรอกชีต', 'price': 5, 'food_image': '4-1-1.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'ใส้กรอกเเดง', 'price': 5, 'food_image': '4-1-2.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'ลูกชิ้นปลา', 'price': 5, 'food_image': '4-1-3.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'เต้าหู้ปลา', 'price': 5, 'food_image': '4-1-4.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'เฟนฟราย', 'price': 20, 'food_image': '4-1-5.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'เเสนวิส', 'price': 25, 'food_image': '4-1-6.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'ชุดทอดรวม', 'price': 30, 'food_image': '4-1-7.jpg'},
    {'restaurant_id': '4', 'food_menu_name': 'ไก่อย่างสอดใส้ชีต', 'price': 60, 'food_image': '4-1-8.jpg'},
  ];

  // ============================================================
  // ==================== อย่าแก้ไขส่วนด้านล่างนี้ ====================
  // ============================================================
  
  print('🔄 Adding restaurants...');
  for (var restaurant in restaurants) {
    final id = restaurant['id'] as String;
    final data = Map<String, dynamic>.from(restaurant);
    data.remove('id'); // ลบ id ออกจาก data เพราะใช้เป็น document ID
    
    await firestore.collection('restaurants').doc(id).set(data);
    print('  ✅ Added restaurant: ${restaurant['name']} (ID: $id)');
  }
  
  print('\n🔄 Adding menu items...');
  
  // นับลำดับเมนูของแต่ละร้าน
  Map<String, int> menuCountPerRestaurant = {};
  
  for (var menu in restaurant_data) {
    final restaurantId = menu['restaurant_id'] as String;
    
    // หาลำดับ Y สำหรับร้านนี้
    final y = menuCountPerRestaurant[restaurantId] ?? 0;
    menuCountPerRestaurant[restaurantId] = y + 1;
    
    // สร้าง Document ID ในรูปแบบ X_Y
    final docId = '${restaurantId}_$y';
    
    await firestore.collection('restaurant_data').doc(docId).set({
      'restaurant_id': restaurantId,
      'food_menu_name': menu['food_menu_name'],
      'price': menu['price'],
      'food_image': menu['food_image'],
    });
    print('  ✅ Added menu: ${menu['food_menu_name']} (ID: $docId)');
  }
  
  print('\n🎉 All data added successfully!');
  print('📊 Total: ${restaurants.length} restaurants, ${restaurant_data.length} menu items');
}
