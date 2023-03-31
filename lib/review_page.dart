import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_review/sql_helper.dart';

class Review_Page extends StatefulWidget {
  final String reviewName;
  final String reviewRating;
  final String reviewReviewerName;
  final String reviewReview;
  final String reviewImage;
  const Review_Page(
      {Key? key,
      required this.reviewName,
      required this.reviewRating,
      required this.reviewReviewerName,
      required this.reviewReview,
      required this.reviewImage})
      : super(key: key);

  @override
  State<Review_Page> createState() => _review_page();
}

class _review_page extends State<Review_Page> {
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

  List<Map<String, dynamic>> _reviews = [];

  void _refreshReviews() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _reviews = data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Center(
          child: Text(widget.reviewName),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Card(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Image.file(
                        File(widget.reviewImage),
                        width: 250,
                      ),
                    ),
                    ListTile(
                      title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Center(
                            child: Text(
                              widget.reviewName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              children: [
                                const Text(
                                  'Rating: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87),
                                ),
                                starIcon(widget.reviewRating),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              children: [
                                const Text(
                                  'Name: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                Text(
                                  widget.reviewReviewerName,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Review: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.reviewReview,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
