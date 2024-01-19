import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    await database.execute("""CREATE TABLE favorites(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      productId INTEGER,
      customer TEXT,
      title TEXT,
      description TEXT,
      price INTEGER,
      image BLOB,
      FOREIGN KEY (productId) REFERENCES products (id)
    )""");
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
//регистрация через гугл
  static Future<void> registerUserGoogle(String name, String password, String email) async {
  final db = await SQLHelper.db();

  // Регистрация пользователя через Google
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    // Пользователь отменил вход через Google
    print('Вход через Google отменен');
    return;
  }

  // Дополнительная информация о пользователе
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  String googleIdToken = googleAuth.idToken ?? "";

  // Получаем реальный адрес электронной почты пользователя
  String userEmail = googleUser.email;

  // Проверяем, существует ли пользователь с таким email
  List<Map<String, dynamic>> existingUsers = await db.query('users', where: 'email = ?', whereArgs: [userEmail]);

  if (existingUsers.isNotEmpty) {
    // Пользователь с таким email уже существует
    print('Пользователь с таким email уже существует');
    return;
  }

  // Вставляем нового пользователя
  await db.insert('users', {
    'name': name,
    'password': googleIdToken,
    'email': userEmail,
  });

  print('Пользователь успешно зарегистрирован через Google');
  /**Пример использования
   * class GoogleRegistrationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await registerUserGoogle(nameController.text);//Вызываем функцию
                // После завершения регистрации, переходите на другой экран или выполняйте другие действия
              },
              child: Text('Register via Google'),
            ),
          ],
        ),
      ),
    );
  }
} */

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
 // авторизация через гугл
  static Future<void> loginUserGoogle() async {
  final db = await SQLHelper.db();

  try {
    // Попытка входа через Google
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // Пользователь отменил вход через Google
      print('Вход через Google отменен');
      return;
    }

    // Дополнительная информация о пользователе
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    String googleIdToken = googleAuth.idToken ?? "";

    // Проверяем, существует ли пользователь с таким googleIdToken
    List<Map<String, dynamic>> existingUsers =
        await db.query('users', where: 'password = "$googleIdToken"');

    if (existingUsers.isNotEmpty) {
      // Пользователь с таким googleIdToken уже существует
      print('Пользователь с таким googleIdToken уже существует');
      return;
    }

    // Вход пользователя в ваше приложение. Здесь может потребоваться дополнительная логика.

    print('Пользователь успешно вошел через Google');
  } catch (error) {
    print('Ошибка входа через Google: $error');
  }
  /** Пример использования
   * class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Google Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            loginUserWithGoogle(context);
          },
          child: Text('Login with Google'),
        ),
      ),
    );
  }

  Future<void> loginUserWithGoogle(BuildContext context) async {
    try {
      // Вызов функции loginUserGoogle из QLHelper
      await SQLHelper.loginUserGoogle();

      // Дополнительная логика после успешного входа через Google, если необходимо

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Пользователь успешно вошел через google!'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка: $error'),
      ));
    }
  }
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
//добавление товара в таблицу избранное
 static Future<void> addToFavorites(int productId, String customer) async {
    final db = await SQLHelper.db();

    // Получаем информацию о товаре из таблицы products
    List<Map<String, dynamic>> product = await db.query('products',
        where: 'id = ?', whereArgs: [productId]);

    if (product.isNotEmpty) {
      // Копируем данные товара в таблицу favorites
      await db.insert('favorites', {
        'productId': product[0]['id'],
        'customer': customer,
        'title': product[0]['title'],
        'description': product[0]['description'],
        'price': product[0]['price'],
        'image': product[0]['image'],
      });
    }
    // await SQLHelper.addToFavorites(productId, customer); - пример использования
  }

//получение списка товаров в избранном учитывая переменную customer
  static Future<List<Map<String, dynamic>>> getFavoritesItems(String customer) async {
    final db = await SQLHelper.db();
    return db.query('favorites', where: 'customer = ?', whereArgs: [customer], orderBy: "id");
  }
  //получение id товара в избранном
    static Future<List<Map<String, dynamic>>> getItemFromFavorites(int id) async {
    final db = await SQLHelper.db();
    return db.query('favorites', where: "id = ?", whereArgs: [id], limit: 1);
  }
  //Если пользователь захочет убрать товар из избранного
    static Future<void> deleteItemFromFavorites(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("basket", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Не получилось удалить товар из избранного: $err");
    }
  }
//при клике на товар в избранном открываем страницу товара
  static Future<Map<String, dynamic>?> getFavoriteProduct(int productId) async {
    final db = await SQLHelper.db();

    // Получаем информацию о товаре из таблицы products
    List<Map<String, dynamic>> product = await db.query('products',
        where: 'id = ?', whereArgs: [productId]);

    if (product.isNotEmpty) {
      return product[0];
    } else {
      // Если товар не найден (например, был удален), можно вернуть null или другое значение по умолчанию
      return null;
    }
  }
//Сравнение товаров
  static int compareProducts(Map<String, dynamic> product1, Map<String, dynamic> product2) {
    // Ваша логика сравнения товаров. Например, сравнение по цене.
    // Возвращаем -1, 0 или 1 в зависимости от результата сравнения.

    int price1 = product1['price'];
    int price2 = product2['price'];

    if (price1 < price2) {
      return -1;
    } else if (price1 > price2) {
      return 1;
    } else {
      return 0;
    }
  }
  // ignore: slash_for_doc_comments
  /** Пример использования
   * // Получаем информацию о двух товарах из таблицы products
Map<String, dynamic> product1 = await SQLHelper.getFavoriteProduct(productId1);
Map<String, dynamic> product2 = await SQLHelper.getFavoriteProduct(productId2);

if (product1 != null && product2 != null) {
  // Сравниваем товары
  int result = SQLHelper.compareProducts(product1, product2);

  if (result < 0) {
    print('Товар 1 дешевле чем товар 2');
  } else if (result > 0) {
    print('Товар 1 дороже чем товар 2');
  } else {
    print('Товары имеют одинаковую цену');
  }
} else {
  print('Один из товаров не найден.');
}
  */
 //Нужно для обозначения иконки сердечка если товар в избранном
static Future<bool> isProductFavorited(int productId, String customer) async {
  final db = await SQLHelper.db();

  // Проверяем, существует ли товар с заданным productId и customer в избранных
  List<Map<String, dynamic>> favoritedProducts = await db.query(
    'favorites',
    where: 'productId = ? AND customer = ?',
    whereArgs: [productId, customer],
  );

  // Если найден хотя бы один товар с таким productId и customer, значит, он в избранных
  return favoritedProducts.isNotEmpty;
}

  /** Пример использования
   * class _ProductWidgetState extends State<ProductWidget> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    // Вызываем функцию isProductFavorited при инициализации виджета
    checkIfFavorited();
  }

  Future<void> checkIfFavorited() async {
    // Вызываем функцию isProductFavorited, передавая productId текущего продукта
    bool favorited = await isProductFavorited(widget.productId);

    // Обновляем состояние виджета в зависимости от результата
    setState(() {
      isFavorited = favorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Product Title'),
      trailing: IconButton(
        icon: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          color: isFavorited ? Colors.red : null,
        ),
        onPressed: () {
          // Обработчик нажатия на иконку сердечка
          // Можете добавить здесь логику для добавления/удаления продукта из избранного
        },
      ),
    );
  }
   */
}

