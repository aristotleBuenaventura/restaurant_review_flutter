import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_review/review_page.dart';
import 'package:restaurant_review/sql_helper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Restaurant Reviews'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _reviews = [];

  bool _isLoading = true;

  void _refreshReviews() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _reviews = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshReviews();
    if (kDebugMode) {
      print('.. number of items ${_reviews.length}');
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        _nameController.text,
        _restaurantController.text,
        _ratingController.text,
        _reviewController.text);
    _refreshReviews();
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(_nameController.text, _restaurantController.text,
        _ratingController.text, _reviewController.text);
    _refreshReviews();
    if (kDebugMode) {
      print('.. number of items ${_reviews.length}');
    }
  }

  void _deleteItem(int id) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete a Review'),
          content: const Text('Are you sure you want to delete this review?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await SQLHelper.deleteItem(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully deleted a restaurant review')));
      _refreshReviews();
    }
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingReview =
          _reviews.firstWhere((element) => element['id'] == id);
      _nameController.text = existingReview['user_name'];
      _restaurantController.text = existingReview['restaurant_name'];
      _ratingController.text = existingReview['rating'];
      _reviewController.text = existingReview['review'];
    } else {
      _nameController.text = '';
      _restaurantController.text = '';
      _ratingController.text = '';
      _reviewController.text = '';
    }
    PickedFile? _imageFile;

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
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Full Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _restaurantController,
                    decoration:
                        const InputDecoration(hintText: 'Restaurant Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<int>(
                    value: _ratingController.text.isNotEmpty
                        ? int.parse(_ratingController.text)
                        : null,
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star_border, color: Colors.amber),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 5,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      _ratingController.text = value.toString();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Rating',
                    ),
                  ),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(hintText: 'Review'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //
                  //   },
                  //   child: Text('Pick Image'),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text == '' ||
                          _restaurantController.text == '' ||
                          _ratingController.text == '' ||
                          _reviewController.text == '') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Missing Information'),
                              content: const Text(
                                  'Please fill in all required fields.'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return; // stop the function execution if there are missing fields
                      } else if (id == null) {
                        await _addItem();
                      } else {
                        await _updateItem(id);
                      }

                      _nameController.text = '';
                      _restaurantController.text = '';
                      _ratingController.text = '';
                      _reviewController.text = '';
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black), // set the background color to red
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

  Widget starIcon(String result) {
    if (result == '1') {
      return Row(
        children: const [
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
        ],
      );
    } else if (result == '2') {
      return Row(
        children: const [
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
        ],
      );
    } else if (result == '3') {
      return Row(
        children: const [
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
        ],
      ); // Return an empty container if the result is not 1 or 2
    } else if (result == '4') {
      return Row(
        children: const [
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star_border, color: Colors.amber),
        ],
      ); // Return an empty container if the result is not 1 or 2
    } else if (result == '5') {
      return Row(
        children: const [
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
        ],
      ); // Return an empty container if the result is not 1 or 2
    } else {
      return Container(); // Return an empty container if the result is not 1 or 2
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: AssetImage('assets/food.jpg'), fit: BoxFit.cover)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.4),
                    Colors.black.withOpacity(.2),
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Center(
                    child: Text(
                      "Where every bite counts - Discover, Review and Savor",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showForm(null);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const SizedBox(
                      width: 200, // Set the desired width here
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Review a Restaurant Now!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: ListTile(
                      title: Text(
                        _reviews[index]['restaurant_name'],
                        style:
                            const TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Rating: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, color: Colors.black),
                              ),
                              starIcon(_reviews[index]['rating']),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Name: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, color: Colors.black),
                              ),
                              Text(
                                _reviews[index]['user_name'],
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Review: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15, color: Colors.black),
                          ),
                          Row(
                            children: [

                              Expanded(child: Text(
                                _reviews[index]['review'],
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),),
                            ],
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () => _showForm(_reviews[index]['id']),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.black),
                              onPressed: () =>
                                  _deleteItem(_reviews[index]['id']),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Review_Page(
                                  reviewName: _reviews[index]
                                      ['restaurant_name'],
                                  reviewRating: _reviews[index]['rating'],
                                  reviewReviewerName: _reviews[index]
                                      ['user_name'],
                                  reviewReview: _reviews[index]['review'])));
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
