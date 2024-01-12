import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
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
  bool? isChecked = false;
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
      backgroundColor: bgColor,
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
                          height: 35,
                        ))),
                actions: !_searchBoolean
                    ? [
                        IconButton(
                            iconSize: 35,
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
                  preferredSize: Size(MediaQuery.of(context).size.width, 115),
                  child: Container(
                      color: bgColor,
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      child: Column(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
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
                                          (BuildContext context) => AlertDialog(
                                                backgroundColor: elementColor,
                                                title: Text(
                                                  'Сортировка',
                                                  style: TextStyle(
                                                      color: Color(0xFAFAFAFF),
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
                                                              child: Container(
                                                                  child: Row(
                                                                children: [
                                                                  sort !=
                                                                          SortLabel
                                                                              .cheap
                                                                              .value
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_box_outline_blank,
                                                                          color:
                                                                              selectColor,
                                                                          size:
                                                                              35,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check_box,
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
                                                                            color:
                                                                                Color(0xFAFAFAFF),
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 15),
                                                                      ))
                                                                ],
                                                              )),
                                                              onTap: () {
                                                                sort = SortLabel
                                                                    .cheap
                                                                    .value;
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              })),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 15),
                                                          child: InkWell(
                                                              child: Container(
                                                                  child: Row(
                                                                children: [
                                                                  sort !=
                                                                          SortLabel
                                                                              .expensive
                                                                              .value
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_box_outline_blank,
                                                                          color:
                                                                              selectColor,
                                                                          size:
                                                                              35,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check_box,
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
                                                                            color:
                                                                                Color(0xFAFAFAFF),
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 15),
                                                                      ))
                                                                ],
                                                              )),
                                                              onTap: () {
                                                                sort = SortLabel
                                                                    .expensive
                                                                    .value;
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              })),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 15),
                                                          child: InkWell(
                                                              child: Container(
                                                                  child: Row(
                                                                children: [
                                                                  sort !=
                                                                          SortLabel
                                                                              .popular
                                                                              .value
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_box_outline_blank,
                                                                          color:
                                                                              selectColor,
                                                                          size:
                                                                              35,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check_box,
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
                                                                            color:
                                                                                Color(0xFAFAFAFF),
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 15),
                                                                      ))
                                                                ],
                                                              )),
                                                              onTap: () {
                                                                sort = SortLabel
                                                                    .popular
                                                                    .value;
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              })),
                                                      Container(
                                                          child: InkWell(
                                                              child: Container(
                                                                  child: Row(
                                                                children: [
                                                                  sort !=
                                                                          SortLabel
                                                                              .sale
                                                                              .value
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_box_outline_blank,
                                                                          color:
                                                                              selectColor,
                                                                          size:
                                                                              35,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .check_box,
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
                                                                            color:
                                                                                Color(0xFAFAFAFF),
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 15),
                                                                      ))
                                                                ],
                                                              )),
                                                              onTap: () {
                                                                sort = SortLabel
                                                                    .sale.value;
                                                                setState(() {});
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
                                      borderRadius: BorderRadius.circular(22)),
                                  child: Row(children: [
                                    InkWell(
                                      child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              13, 10, 7, 10),
                                          child: SvgPicture.asset(
                                            'icons/List.svg',
                                            height: 22,
                                            color: !_bigCard
                                                ? Colors.white
                                                : selectColor,
                                          )),
                                      onTap: _bigCard
                                          ? null
                                          : () {
                                              _bigCard = true;
                                              _refreshJournals();
                                            },
                                    ),
                                    InkWell(
                                      child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              7, 10, 13, 10),
                                          child: SvgPicture.asset(
                                            'icons/Grid.svg',
                                            height: 23,
                                            color: _bigCard
                                                ? Colors.white
                                                : selectColor,
                                          )),
                                      onTap: !_bigCard
                                          ? null
                                          : () {
                                              _bigCard = false;
                                              _refreshJournals();
                                            },
                                    ),
                                  ]),
                                )
                              ],
                            ))
                      ])),
                )),
            !_bigCard
                ? SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.64),
                    itemCount: _journals.length,
                    itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFA7CF9B),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(9, 7, 9, 2),
                                  child: Container(
                                      height: 145,
                                      width: 175,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFF567B59),
                                              width: 3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child:
                                              _journals[index]['image'] != null
                                                  ? Image.memory(
                                                      _journals[index]['image'],
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Container())),
                                ),
                                Flexible(
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(left: 9, right: 9),
                                        margin:
                                            EdgeInsets.only(top: 1, bottom: 25),
                                        child: AutoSizeText(
                                            _journals[index]['title'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFAFAFAFF),
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center))),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF567B59),
                                              width: 2)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, right: 10),
                                            child: Row(children: <Widget>[
                                              SvgPicture.asset(
                                                  'icons/Rating.svg',
                                                  height: 25),
                                              SvgPicture.asset(
                                                  'icons/Rating.svg',
                                                  height: 25),
                                              SvgPicture.asset(
                                                  'icons/Rating.svg',
                                                  height: 25),
                                              SvgPicture.asset(
                                                  'icons/Rating.svg',
                                                  height: 25),
                                              SvgPicture.asset(
                                                  'icons/Rating.svg',
                                                  height: 25)
                                            ]),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 15),
                                            child: Text(
                                              _journals[index]['rating']
                                                  .round()
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xFAFAFAFF)),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 8),
                                    //height: 53,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF2FFEB),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 7, top: 5),
                                                    child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          _journals[index]
                                                                      ['price']
                                                                  .toString() +
                                                              '₽',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xFF567B59)),
                                                        ))),
                                                Transform.translate(
                                                    offset: Offset(0, -4),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 6, bottom: 3),
                                                      child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                            'От ' +
                                                                (_journals[index][
                                                                            'price'] /
                                                                        12)
                                                                    .round()
                                                                    .toString() +
                                                                '₽/ в мес.',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Color(
                                                                    0xFF567B59),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ))
                                              ])),
                                          Container(
                                              child: IconButton(
                                                  iconSize: 30,
                                                  icon: Icon(
                                                    Icons.info,
                                                    color: Color(0xFFA7CF9B),
                                                  ),
                                                  onPressed: () {}))
                                        ]))
                              ],
                            ))),
                  )
                : SliverList.builder(
                    itemCount: _journals.length,
                    itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFA7CF9B),
                            ),
                            child: Column(children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(12, 20, 9, 0),
                                        child: Container(
                                            height: 145,
                                            width: 125,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFF567B59),
                                                    width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: _journals[index]
                                                            ['image'] !=
                                                        null
                                                    ? Image.memory(
                                                        _journals[index]
                                                            ['image'],
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Container()))),
                                    Flexible(
                                        child: Column(
                                      children: [
                                        Container(
                                            height: 50,
                                            width: 200,
                                            padding: EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
                                            child: Text(
                                              _journals[index]['title'],
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  color: Color(0xFAFAFAFF),
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            height: 100,
                                            width: 200,
                                            child: Text(
                                              _journals[index]['description'],
                                              maxLines: 4,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFAFAFAFF),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )),
                                      ],
                                    ))
                                  ]),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      height: 42,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF567B59),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              height: 30,
                                              width: 30,
                                              child: Checkbox(
                                                  value: isChecked,
                                                  checkColor: Color(0xFAFAFAFF),
                                                  side: const BorderSide(
                                                      width: 1.7,
                                                      color: Color(0xFAFAFAFF)),
                                                  onChanged: (newBool) {
                                                    setState(() {
                                                      isChecked = newBool;
                                                    });
                                                  })),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: AutoSizeText('Сравнить',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFAFAFAFF))),
                                          )
                                        ],
                                      )),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      child: Container(
                                        height: 42,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xFF567B59),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 4, right: 10),
                                              child: Row(children: <Widget>[
                                                SvgPicture.asset(
                                                    'icons/Rating.svg',
                                                    width: 30,
                                                    height: 25),
                                                SvgPicture.asset(
                                                    'icons/Rating.svg',
                                                    width: 30,
                                                    height: 25),
                                                SvgPicture.asset(
                                                    'icons/Rating.svg',
                                                    width: 30,
                                                    height: 25),
                                                SvgPicture.asset(
                                                    'icons/Rating.svg',
                                                    width: 30,
                                                    height: 25),
                                                SvgPicture.asset(
                                                    'icons/Rating.svg',
                                                    width: 30,
                                                    height: 25)
                                              ]),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Text(
                                                _journals[index]['rating']
                                                    .round()
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFAFAFAFF)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 10),
                                        //height: 50,
                                        width: 190,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF2FFEB),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 7,
                                                                top: 5),
                                                        child: FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                              _journals[index][
                                                                          'price']
                                                                      .toString() +
                                                                  '₽',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF567B59)),
                                                            ))),
                                                    Transform.translate(
                                                        offset: Offset(0, -4),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6,
                                                                  bottom: 3),
                                                          child: FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                                'От ' +
                                                                    (_journals[index]['price'] /
                                                                            12)
                                                                        .round()
                                                                        .toString() +
                                                                    '₽/ в мес.',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color(
                                                                        0xFF567B59),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ))
                                                  ])),
                                              Container(
                                                  child: IconButton(
                                                      iconSize: 30,
                                                      icon: Icon(
                                                        Icons.info,
                                                        color:
                                                            Color(0xFFA7CF9B),
                                                      ),
                                                      onPressed: () {}))
                                            ])),
                                    Container(
                                      margin: EdgeInsets.only(left: 8, top: 10),
                                      //height: 50,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFF2FFEB),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: IconButton(
                                        padding: EdgeInsets.all(1),
                                        iconSize: 50,
                                        icon: Icon(
                                          Icons.favorite_outline_sharp,
                                          color: Color(0xFF567B59),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {},
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(left: 8, top: 10),
                                          height: 50,
                                          width: 86,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF567B59),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: AutoSizeText('Купить',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFAFAFAFF))),
                                          padding:
                                              EdgeInsets.fromLTRB(5, 10, 0, 10),
                                        ))
                                  ]),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 170,
                                          margin:
                                              EdgeInsets.fromLTRB(25, 20, 0, 0),
                                          child: Text(
                                            'В наличии:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFAFAFAFF)),
                                          )),
                                      Container(
                                          height: 30,
                                          width: 170,
                                          margin:
                                              EdgeInsets.fromLTRB(25, 0, 0, 0),
                                          child: Text(
                                            'в 8 магазинах',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFAFAFAFF)),
                                          )),
                                    ],
                                  )),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 170,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: Text(
                                            'Доставим на дом:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFAFAFAFF)),
                                          )),
                                      Container(
                                          height: 30,
                                          width: 170,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Text(
                                            'Послезавтра',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFAFAFAFF)),
                                          )),
                                    ],
                                  ))
                                ],
                              )
                            ]))))
          ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFA7CF9B),
        focusColor: Color(0xFF567B59),
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
