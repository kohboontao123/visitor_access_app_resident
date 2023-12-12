import 'package:flutter/material.dart';
import 'InvitationCard.dart';


class OverViewWidget extends StatefulWidget {
  const OverViewWidget({Key? key}) : super(key: key);

  @override
  State<OverViewWidget> createState() => _OverViewWidgetState();
}

class _OverViewWidgetState extends State<OverViewWidget> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = new TabController(length: 5, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: tabController,
            labelColor: Colors.black,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,

            ),
            padding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.grey.shade400,
            tabs: [
              Tab(
                text: "All",
              ),
              Tab(
                text: "Accepted",
              ),
              Tab(
                text: "Rejected",
              ),
              Tab(
                text: "Pendings",
              ),
              Tab(
                text: "Cancel",
              )
            ],
          ),
          Container(
            height:  MediaQuery.of(context).size.height* 0.68,
            width: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                InvitationCard("All"),
                InvitationCard("Accepted"),
                InvitationCard("Rejected"),
                InvitationCard("Pendings"),
                InvitationCard("Cancel"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CircleTab extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return CirclePainter();
  }
}

class CirclePainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = Colors.black54;
    final Offset CirclePostion =
    Offset(configuration.size!.width - 3.0, configuration.size!.height / 2);
    canvas.drawCircle(offset + CirclePostion, 4, _paint);
  }
}
