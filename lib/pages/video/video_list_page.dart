import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:fyp_yzj/config/graphqlClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:video_player/video_player.dart';

class VideoListPage extends StatefulWidget {
  static const String routeName = '/video_list';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => VideoListPage());
  }

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  VideoPlayerController _controller;

  List _elements;

  List _videos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVideos();
  }

  void _getVideos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await GraphqlClient.getNewClient().query(
      QueryOptions(
        documentNode: gql('''
            query getVideosList(\$username:String!) {
              getVideosList(username: \$username) {
                url
                date
              }
            }
          '''),
        variables: {'username': prefs.getString('name')},
      ),
    );
    if (result.hasException) throw result.exception;
    print("result.data");
    print(result.data["getVideosList"]);
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _elements = result.data["getVideosList"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff102439),
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildBody() {
    if (_elements == null) {
      return SkeletonLoader(
        builder: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        items: 8,
        period: Duration(seconds: 2),
        highlightColor: Colors.lightBlue[300],
        direction: SkeletonDirection.ltr,
      );
    } else {
      return GroupedListView<dynamic, String>(
        elements: _elements,
        groupBy: (element) => element['date'].substring(0, 15),
        groupComparator: (value1, value2) => value2.compareTo(value1),
        // itemComparator: (item1, item2) =>
        //     item1['name'].compareTo(item2['name']),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: false,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        itemBuilder: (c, element) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Icon(
                  Icons.movie,
                  size: 45,
                ),
                title: Text(element['date']),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  _controller = VideoPlayerController.network(element['url'])
                    ..initialize().then((_) {
                      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                      setState(() {
                        showCupertinoModalBottomSheet(
                          expand: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => _getVideoWidget(),
                        );
                      });
                    });
                },
              ),
            ),
          );
        },
      );
    }
  }

  Widget _getVideoWidget() {
    return Material(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: Text(""),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Get.back();
                })
          ],
        ),
        body: Container(
          child: Scaffold(
            body: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
