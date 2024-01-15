import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static String customer = '';
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      price INTEGER,
      discount INTEGER,
      inStock TEXT,
      tags TEXT,
      rating REAL,
      image BLOB,
      discountTime TEXT
    )""");

    await database.execute("""CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      password TEXT,
      email TEXT
    )""");

    await database.execute("""CREATE TABLE basket(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      price INTEGER,
      discount INTEGER,
      inStock TEXT,
      tags TEXT,
      rating REAL,
      image BLOB,
      customer TEXT 
    )""");
    //поле customer берется из глобальной переменной. При авторизации в нее записывается имя пользователя.

    await database.execute("""CREATE TABLE orders(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      price INTEGER,
      discount INTEGER,
      inStock TEXT,
      tags TEXT,
      rating REAL,
      image BLOB,
      customer TEXT,
      days TEXT
    )""");
    //days - через сколько дней доставят пока что будет стоять 3 дня.
    print("Создание таблиц прошло успешно");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'shop.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("Создание таблиц");
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String title,
      String? description,
      int? price,
      int? discount,
      String? inStock,
      String? tags,
      double? rating,
      Uint8List? image) async {
    final db = await SQLHelper.db();
  DateTime currentTime = DateTime.now();
  DateTime discountExpiration = currentTime.add(Duration(hours: 24));

  String formattedDiscountTime = discountExpiration.toIso8601String(); // пусть пока на все товары скидка 24 часа будет
    final data = {
      'title': title,
      'description': description,
      'price': price,
      'discount': discount,
      'inStock': inStock,
      'tags': tags,
      'rating': rating,
      'image': image,
      'discountTime': formattedDiscountTime
    };

    final id = await db.insert('products', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('products', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('products', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id,
      String title,
      String? description,
      int? price,
      int? discount,
      String? inStock,
      String? tags,
      double? rating,
      Uint8List? image) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'price': price,
      'discount': discount,
      'inStock': inStock,
      'tags': tags,
      'rating': rating,
      'image': image
    };

    final result =
        await db.update('products', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("products", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Не получилось удалить товар: $err");
    }
  }

  static Future<List<Map<String, dynamic>>> searchByName(String title) async {
    final db = await SQLHelper.db();
    return await db
        .query('products', where: 'title LIKE ?', whereArgs: ['%$title%']);
  }

//Новые функции
//сначала недорогие
static Future<List<Map<String, dynamic>>> sortByPriceAscending() async {
  final db = await SQLHelper.db();
  return await db.query('products', orderBy: 'price ASC');
  //List<Map<String, dynamic>> sortedProducts = await SQLHelper.sortByPriceAscending(); - пример вызова

}
//сначала дорогие
static Future<List<Map<String, dynamic>>> sortByPriceDescending() async {
  final db = await SQLHelper.db();
  return await db.query('products', orderBy: 'price DESC');
}

//сначала популярные
static Future<List<Map<String, dynamic>>> sortByRatingDescending() async {
  final db = await SQLHelper.db();
  return await db.query('products', orderBy: 'rating DESC');
}

//по скидке
static Future<List<Map<String, dynamic>>> sortByDiscountDescending() async {
  final db = await SQLHelper.db();
  return await db.query('products', orderBy: 'discount DESC');
}

//по тегам
static Future<List<Map<String, dynamic>>> sortByTag(String tag) async {
  final db = await SQLHelper.db();
  return await db.query('products', where: 'tags LIKE ?', whereArgs: ['%$tag%']);
  //List<Map<String, dynamic>> productsWithBigTag = await SQLHelper.sortByTag('Большие'); - пример использования
}

//регистрация
  static Future<void> registerUser(String name, String password, String email) async {
    final db = await SQLHelper.db();
    
    // Проверяем, существует ли пользователь с таким email
    List<Map<String, dynamic>> existingUsers = await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (existingUsers.isNotEmpty) {
      // Пользователь с таким email уже существует
      print('Пользователь с таким email уже существует');
      return;
    }

    // Вставляем нового пользователя
    await db.insert('users', {
      'name': name,
      'password': password,
      'email': email,
    });
    //await SQLHelper.registerUser('Имя', 'Пароль', 'email@example.com'); - пример использования

  }

//авторизация
  static Future<bool> authenticateUser(String email, String password) async {
    final db = await SQLHelper.db();

    // Проверяем, существует ли пользователь с заданным email и паролем
    List<Map<String, dynamic>> user = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);

    if (user.isNotEmpty) {
      // Пользователь успешно аутентифицирован
      customer = user[0]['name']; // Сохраняем имя пользователя в customer
      return true;
    } else {
      // Пользователь с заданным email и паролем не найден
      return false;
    }

    /** Пример использования
     * bool isAuthenticated = await SQLHelper.authenticateUser('email@example.com', 'password');

if (isAuthenticated) {
  print('Пользователь успешно авторизован. Имя пользователя: ${SQLHelper.customer}');
} else {
  print('Неверный email или пароль');
}

     */
  }

//Добавление в корзину
  static Future<void> addToBasket(int productId) async {
    final db = await SQLHelper.db();

    // Получаем информацию о товаре из таблицы products
    List<Map<String, dynamic>> product = await db.query('products',
        where: 'id = ?', whereArgs: [productId]);

    if (product.isNotEmpty) {
      // Копируем данные товара в таблицу basket
      await db.insert('basket', {
        'title': product[0]['title'],
        'description': product[0]['description'],
        'price': product[0]['price'],
        'discount': product[0]['discount'],
        'inStock': product[0]['inStock'],
        'tags': product[0]['tags'],
        'rating': product[0]['rating'],
        'image': product[0]['image'],
        'customer': customer, // Устанавливаем значение из переменной customer
      });
    }
   // await SQLHelper.addToBasket(productId); пример использования
  }
//получение списка товаров в корзине учитывая переменную customer
  static Future<List<Map<String, dynamic>>> getBasketItems(String customer) async {
    final db = await SQLHelper.db();
    return db.query('basket', where: 'customer = ?', whereArgs: [customer], orderBy: "id");
  }
  //получение id товара в корзине
    static Future<List<Map<String, dynamic>>> getItemFromBasket(int id) async {
    final db = await SQLHelper.db();
    return db.query('basket', where: "id = ?", whereArgs: [id], limit: 1);
  }
  //Если пользователь захочет убрать товар из корзины
    static Future<void> deleteItemFromBasket(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("basket", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Не получилось удалить товар из корзины: $err");
    }
  }

  static Future<void> addToOrdersFromBasket(String customer) async {
    final db = await SQLHelper.db();

    // Получаем все записи из таблицы basket, где customer совпадает
    List<Map<String, dynamic>> basketItems = await db.query('basket',
        where: 'customer = ?', whereArgs: [customer]);

    // Добавляем каждую запись из basket в таблицу orders
    for (var item in basketItems) {
      await db.insert('orders', {
        'title': item['title'],
        'description': item['description'],
        'price': item['price'],
        'discount': item['discount'],
        'inStock': item['inStock'],
        'tags': item['tags'],
        'rating': item['rating'],
        'image': item['image'],
        'customer': customer,
        'days': '3', // Пока неизвестно как будет определяться местоположение поэтому пусть тут будет произвольное значение
      });
    }

    // Очищаем корзину
    await db.delete('basket', where: 'customer = ?', whereArgs: [customer]);
    // пример вызова await SQLHelper.addToOrdersFromBasket(customer);
  }

//получение списка заказов
  static Future<List<Map<String, dynamic>>> getOrdersItems(String customer) async {
    final db = await SQLHelper.db();
    return db.query('orders', where: 'customer = ?', whereArgs: [customer], orderBy: "id");
  }
  //получение id товара в заказах
    static Future<List<Map<String, dynamic>>> getItemFromOrders(int id) async {
    final db = await SQLHelper.db();
    return db.query('orders', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //Это либо по желанию пользователя либо через продавца.
    static Future<void> deleteItemFromOrders(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("orders", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Не получилось удалить товар из заказов: $err");
    }
  }
 //Для карточек товаров с активной скидкой
  static Future<List<Map<String, dynamic>>> getProductsWithActiveDiscount() async {
    final db = await SQLHelper.db();

    // Получаем текущее время
    DateTime currentTime = DateTime.now();
    
    // Получаем все записи из таблицы products, где скидка еще действует
    return db.query('products', where: 'discountTime >= ?', whereArgs: [currentTime.toIso8601String()]);
    /** Вот пример использования
     * class _YourWidgetState extends State<YourWidget> {
  List<Map<String, dynamic>> activeDiscountProducts = [];

  @override
  void initState() {
    super.initState();
    loadActiveDiscountProducts();
  }

  Future<void> loadActiveDiscountProducts() async {
    List<Map<String, dynamic>> products = await SQLHelper.getActiveDiscountProducts();
    
    setState(() {
      activeDiscountProducts = products;
    });
  }

  body: ListView.builder(
        itemCount: activeDiscountProducts.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(activeDiscountProducts[index]['title']),
              // Добавьте другие поля товара, которые вам нужны
            ),
     */
  }
}
