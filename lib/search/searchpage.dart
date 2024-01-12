import 'dart:convert';
import 'dart:math';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_build/constants.dart';
import 'package:shop_build/sql_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  bool _searchBoolean = false;
  bool _bigCard = false;
  String sort = SortLabel.cheap.value;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
    print("Количество товаров ${_journals.length}");
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController =
      TextEditingController(); // Добавлено поле discount
  final TextEditingController _inStockController = TextEditingController();
  final TextEditingController _tagsController =
      TextEditingController(); // Добавлено поле tags
  final TextEditingController _ratingController =
      TextEditingController(); // Добавлено поле rating
// Добавлен контроллер для изображения, учитывая, что вы используете BLOB
  final TextEditingController _imageController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  Future<void> _addItem() async {
    await SQLHelper.createItem(
      _titleController.text,
      _descriptionController.text,
      int.parse(_priceController.text),
      int.parse(_discountController.text), // Парсинг discount
      _inStockController.text,
      _tagsController.text,
      double.parse(_ratingController.text), // Парсинг rating
      // Конвертация изображения в Uint8List (зависит от того, как вы храните изображение в приложении)
      _imageController.text.isNotEmpty
          ? base64Decode(_imageController.text)
          : null,
    );
    _refreshJournals();
  }

  Future<void> _search(String id) async {
    await SQLHelper.searchByName(searchController.text);
    final data = await SQLHelper.searchByName(searchController.text);
    _journals = data;
    _isLoading = false;
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
      id,
      _titleController.text,
      _descriptionController.text,
      int.parse(_priceController.text),
      int.parse(_discountController.text),
      _inStockController.text,
      _tagsController.text,
      double.parse(_ratingController.text),
      _imageController.text.isNotEmpty
          ? base64Decode(_imageController.text)
          : null,
    );
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Товар успешно удален'),
    ));
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _priceController.text = existingJournal['price'].toString();
      _discountController.text = existingJournal['discount'].toString();
      _inStockController.text = existingJournal['inStock'];
      _tagsController.text = existingJournal['tags'].toString();
      _ratingController.text = existingJournal['rating'].toString();
      // Предполагается, что изображение хранится в виде строки в формате base64
      _imageController.text = existingJournal['image'] != null
          ? base64Encode(existingJournal['image'])
          : '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: "Название"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: "Описание"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Цена"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _inStockController,
              decoration: const InputDecoration(hintText: "В наличии"),
            ),
            const SizedBox(
              height: 10,
            ),
            // Добавлены новые поля
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Скидка"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(hintText: "Теги"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _ratingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Рейтинг"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
                  }
                  _titleController.text = '';
                  _descriptionController.text = '';
                  _priceController.text = '';
                  _inStockController.text = '';
                  _discountController.text = '';
                  _tagsController.text = '';
                  _ratingController.text = '';
                  Navigator.of(context).pop();
                } catch (e) {
                  // Обработка ошибок при добавлении/обновлении элемента
                  print("Error: $e");
                }
              },
              child: Text(id == null ? 'Добавить товар' : 'Обновить'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final pickedImage =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    final imageBytes = await pickedImage.readAsBytes();
                    _imageController.text = base64Encode(imageBytes);
                  }
                } catch (e) {
                  // Обработка ошибок при выборе изображения
                  print("Error picking image: $e");
                }
              },
              child: const Text('Выбрать изображение'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ColorfulSafeArea(
            color: elementColor,
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                  floating: true,
                  surfaceTintColor: darkbgColor,
                  backgroundColor: elementColor,
                  title: !_searchBoolean
                      ? Text(
                          'Медведи',
                          style: TextStyle(
                              color: Color(0xFAFAFAFF),
                              fontWeight: FontWeight.bold),
                        )
                      : TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "Поиск...",
                              hintStyle: TextStyle(
                                  color: Color(0xFAFAFAFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFAFAFAFF))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFAFAFAFF)))),
                          onChanged: (text) async {
                            await _search(text);
                          },
                        ),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () => {},
                      icon: Transform.flip(
                          flipX: true,
                          child: SvgPicture.asset(
                            'icons/Marker.svg',
                            color: const Color(0xFAFAFAFF),
                            height: 30,
                          ))),
                  actions: !_searchBoolean
                      ? [
                          IconButton(
                              iconSize: 30,
                              icon: Icon(
                                Icons.search,
                                color: Color(0xFAFAFAFF),
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchBoolean = true;
                                });
                              })
                        ]
                      : [
                          IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Color(0xFAFAFAFF),
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchBoolean = false;
                                  searchController.clear();
                                  _refreshJournals();
                                });
                              })
                        ],
                  bottom: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 100),
                    child: Container(
                        color: bgColor,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                              child: Text(
                                            sort,
                                            style: TextStyle(
                                                color: selectColor,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: selectColor,
                                          )
                                        ],
                                      )),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) =>
                                                AlertDialog(
                                                  backgroundColor: elementColor,
                                                  title: Text(
                                                    'Сортировка',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFAFAFAFF),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22),
                                                  ),
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 15),
                                                            child: InkWell(
                                                                child:
                                                                    Container(
                                                                        child:
                                                                            Row(
                                                                  children: [
                                                                    sort != SortLabel.cheap.value
                                                                        ? Icon(
                                                                            Icons.check_box_outline_blank,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          )
                                                                        : Icon(
                                                                            Icons.check_box,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          SortLabel
                                                                              .cheap
                                                                              .value,
                                                                          style: TextStyle(
                                                                              color: Color(0xFAFAFAFF),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ))
                                                                  ],
                                                                )),
                                                                onTap: () {
                                                                  sort =
                                                                      SortLabel
                                                                          .cheap
                                                                          .value;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                })),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 15),
                                                            child: InkWell(
                                                                child:
                                                                    Container(
                                                                        child:
                                                                            Row(
                                                                  children: [
                                                                    sort != SortLabel.expensive.value
                                                                        ? Icon(
                                                                            Icons.check_box_outline_blank,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          )
                                                                        : Icon(
                                                                            Icons.check_box,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          SortLabel
                                                                              .expensive
                                                                              .value,
                                                                          style: TextStyle(
                                                                              color: Color(0xFAFAFAFF),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ))
                                                                  ],
                                                                )),
                                                                onTap: () {
                                                                  sort = SortLabel
                                                                      .expensive
                                                                      .value;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                })),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 15),
                                                            child: InkWell(
                                                                child:
                                                                    Container(
                                                                        child:
                                                                            Row(
                                                                  children: [
                                                                    sort != SortLabel.popular.value
                                                                        ? Icon(
                                                                            Icons.check_box_outline_blank,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          )
                                                                        : Icon(
                                                                            Icons.check_box,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          SortLabel
                                                                              .popular
                                                                              .value,
                                                                          style: TextStyle(
                                                                              color: Color(0xFAFAFAFF),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ))
                                                                  ],
                                                                )),
                                                                onTap: () {
                                                                  sort = SortLabel
                                                                      .popular
                                                                      .value;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                })),
                                                        Container(
                                                            child: InkWell(
                                                                child:
                                                                    Container(
                                                                        child:
                                                                            Row(
                                                                  children: [
                                                                    sort != SortLabel.sale.value
                                                                        ? Icon(
                                                                            Icons.check_box_outline_blank,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          )
                                                                        : Icon(
                                                                            Icons.check_box,
                                                                            color:
                                                                                selectColor,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          SortLabel
                                                                              .sale
                                                                              .value,
                                                                          style: TextStyle(
                                                                              color: Color(0xFAFAFAFF),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ))
                                                                  ],
                                                                )),
                                                                onTap: () {
                                                                  sort =
                                                                      SortLabel
                                                                          .sale
                                                                          .value;
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                })),
                                                      ]),
                                                ));
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, right: 25),
                                    child: Row(children: [
                                      Icon(
                                        Icons.filter_list,
                                        color: selectColor,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 3),
                                        child: Text(
                                          'Фильтры',
                                          style: TextStyle(
                                              color: selectColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]),
                                  ),
                                  onTap: () {},
                                )
                              ]),
                          Container(
                              margin: EdgeInsets.only(top: 15, left: 15),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: elementColor,
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: Row(children: [
                                      IconButton(
                                          onPressed: _bigCard
                                              ? null
                                              : () {
                                                  _bigCard = true;
                                                  print('bigCard: $_bigCard');
                                                  _refreshJournals();
                                                },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          icon: SvgPicture.asset(
                                            'icons/List.svg',
                                            height: 22,
                                            color: !_bigCard
                                                ? Colors.white
                                                : selectColor,
                                          )),
                                      IconButton(
                                          onPressed: !_bigCard
                                              ? null
                                              : () {
                                                  _bigCard = false;
                                                  print('bigCard: $_bigCard');
                                                  _refreshJournals();
                                                },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          icon: SvgPicture.asset(
                                            'icons/Grid.svg',
                                            height: 22,
                                            color: _bigCard
                                                ? Colors.white
                                                : selectColor,
                                          ))
                                    ]),
                                  )
                                ],
                              ))
                        ])),
                  )),
            ])));
  }
}
