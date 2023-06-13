/* import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';



class NestedScrollingScreen extends StatefulWidget {
  const NestedScrollingScreen({super.key});

  @override
  State<NestedScrollingScreen> createState() => _NestedScrollingScreenState();
}

class _NestedScrollingScreenState extends State<NestedScrollingScreen> {
  final scrollController = ScrollController();
  int currentPointIndex = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    final currentScrollOffset = scrollController.offset;
    final currentScrollIndex = points.indexWhere(
      (point) => currentScrollOffset < points.indexOf(point),
    );

    if (currentScrollIndex != -1 && currentPointIndex != currentScrollIndex) {
      setState(() {
        currentPointIndex = currentScrollIndex;
      });
    }
    log(currentScrollIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text(points[currentPointIndex].title),
                pinned: true,
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: points
                  .mapIndexed(
                    (i, e) {
                      return [
                        /* SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ), */
                        //                        sliver:
                        SliverAppBar(
                          title: Text(e.title),
                        ),
                        //),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ListTile(
                                title: Text(e.subpoints[index]),
                              );
                            },
                            childCount: e.subpoints.length,
                          ),
                        ),
                      ];
                    },
                  )
                  .toList()
                  .flattened
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';

class Point {
  Point({
    required this.title,
    required this.subpoints,
  });
  final String title;
  final List<String> subpoints;
}

final List<Point> points = List.generate(
  100,
  (index) => Point(
    title: 'Point ${index + 1}',
    subpoints:
        List.generate(50, (index2) => 'Subpoint ${index + 1}.${index2 + 1}'),
  ),
);

class NestedScrollingScreen extends StatefulWidget {
  const NestedScrollingScreen({super.key});
  static const String routeName = 'NestedScrollingScreen';

  @override
  State<NestedScrollingScreen> createState() => _NestedScrollingScreenState();
}

class _NestedScrollingScreenState extends State<NestedScrollingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(points[currentIndex].title),
      ),
      extendBodyBehindAppBar: true,
      body: PageView(
        onPageChanged: _onPageChanged,
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: points
            .map(
              (e) => NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.extentAfter == 0) {
                    _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else if (notification is ScrollEndNotification &&
                      notification.metrics.extentBefore == 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                  return false;
                },
                child: ListView(
                  children:
                      e.subpoints.map((e) => ListTile(title: Text(e))).toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
