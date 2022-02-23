import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateFieldInFirestore {
  final String collection;
  final String? secondCollection;
  final String doc;
  final String? secondDoc;
  final String fieldNameToUpdate;
  final dynamic value;

  UpdateFieldInFirestore({
    required this.collection,
    this.secondCollection,
    required this.doc,
    this.secondDoc,
    required this.fieldNameToUpdate,
    required this.value,
  });

  void updateValue() {
    FirebaseFirestore.instance.collection(collection).doc(doc).update(
      {fieldNameToUpdate: value},
    ).catchError(
      (error) => debugPrint('$error'),
    );
  }

  void updateValueInSecondCollection() {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(doc)
        .collection(secondCollection!)
        .doc(secondDoc)
        .update(
      {fieldNameToUpdate: value},
    ).catchError(
      (error) => debugPrint('error'),
    );
  }
}
