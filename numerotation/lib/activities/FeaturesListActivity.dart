import 'package:flutter/material.dart';
import 'package:numerotation/model/feature.dart';

class FeaturesListActivity extends StatefulWidget {
  @override
  _FeaturesListActivityState createState() => _FeaturesListActivityState();
}

class _FeaturesListActivityState extends State<FeaturesListActivity> {
  List<Feature> features;

  @override
  void initState() {
    features = Feature.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des fonctionnalités"),
      ),
      body: ListView.builder(
        itemCount: features == null ? 0 : features.length,
        itemBuilder: (context, index) {
          var feature = features[index];
          return GestureDetector(
            onTap: () {
              if (feature.page != null) {
                Navigator.of(context).pushNamed(feature.page);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${index + 1} - ${feature.name}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
