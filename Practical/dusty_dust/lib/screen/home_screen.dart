import 'package:flutter/material.dart';
import 'package:dusty_dust/container/hourly_card.dart';
import 'package:dusty_dust/container/category_card.dart';
import 'package:dusty_dust/component/main_app_bar.dart';
import 'package:dusty_dust/component/main_drawer.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:dusty_dust/const/regions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  ScrollController scrollController = ScrollController();
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final now = DateTime.now();
      final fetchTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      );

      final box = Hive.box<StatModel>(ItemCode.PM10.name);

      if(box.values.isNotEmpty && (box.values.last as StatModel).dateTime.isAtSameMomentAs(fetchTime)) return;

      List<Future> futures = [];

      for (ItemCode itemCode in ItemCode.values) {
        futures.add(StatRepository.fetchData(itemCode: itemCode));
      }

      final results = await Future.wait(futures);

      for (int i = 0; i < results.length; i++) {
        final itemCode = ItemCode.values[i];
        final stat = results[i];

        final box = Hive.box<StatModel>(itemCode.name);

        for (StatModel statModel in stat) {
          box.put(statModel.dateTime.toString(), statModel);
        }

        final allKeys = box.keys.toList();

        if (allKeys.length > 24) {
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);

          box.deleteAll(deleteKeys);
        }
      }
    } on DioError catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인터넷 연결이 원활하지 않습니다.')));
    }
  }

  void scrollListener() {
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
        builder: (context, box, widget) {
          if(box.values.isEmpty) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final recentStat = box.values.toList().last as StatModel;

          final status = DataUtils.getStatusFromItemCodeAndValue(
            value: recentStat.getLevelFromRegion(region),
            itemCode: ItemCode.PM10,
          );

          return Scaffold(
            drawer: MainDrawer(
              onRegionTap: (String region) {
                setState(() {
                  this.region = region;
                });
                Navigator.of(context).pop();
              },
              selectedRegion: region,
              darkColor: status.darkColor,
              lightColor: status.lightColor,
            ),
            body: Container(
              color: status.primaryColor,
              child: RefreshIndicator(
                onRefresh: () async {
                  await fetchData();
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    MainAppBar(
                      status: status,
                      stat: recentStat,
                      region: region,
                      dateTime: recentStat.dateTime,
                      isExpanded: isExpanded,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CategoryCard(
                            region: region,
                            darkColor: status.darkColor,
                            lightColor: status.lightColor,
                          ),
                          const SizedBox(height: 16.0),
                          ...ItemCode.values.map((itemCode) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: HourlyCard(
                                darkColor: status.darkColor,
                                lightColor: status.lightColor,
                                region: region,
                                itemCode: itemCode,
                              ),
                            );
                          }),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
