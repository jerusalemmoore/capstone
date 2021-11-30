import '../../../postWidgets/postsBuilder.dart';
import 'package:flutter/cupertino.dart';
import '../../../postWidgets/explorePostsBuilder.dart';

class ExploreWidget extends StatefulWidget {
  const ExploreWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  ExploreWidgetState createState() => ExploreWidgetState();
}

class ExploreWidgetState extends State<ExploreWidget> {
  Widget build(BuildContext context) {
    return Center(
        child: DraggableScrollableSheet(
            initialChildSize: 1,
            builder: (context, scrollController) {
              return ExplorePostsBuilder(user: widget.user);
            }));
  }
}
