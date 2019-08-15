import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/home/widget/dashboard_grid.dart';
import 'package:flutter_weighter/screens/home/widget/user_profile_row.dart';

class DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        //UserProfileRow(),
        Expanded(child: DashboardGrid())
        ],
    );
  }

}
























class DashboardGraphCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color(0xff232d37)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          WeightHeightCard(),
          Expanded(child: GraphCardView())
        ],
      ),
    );
  }
}

class WeightHeightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildData('Current Weight', '75 kg', context),
          _buildData('Last Weight', '70 kg', context),
        ],
      ),
    );
  }

  _buildData(String label, String data, BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Colors.white70, fontWeight: FontWeight.w400),
        ),
        Text(
          data,
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(color: Colors.white70, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

class GraphCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fromDate = DateTime(2018, 11, 22);
    final toDate = DateTime.now();

    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

    final date3 = DateTime.now().subtract(Duration(days: 35));
    final date4 = DateTime.now().subtract(Duration(days: 36));

    final date5 = DateTime.now().subtract(Duration(days: 65));
    final date6 = DateTime.now().subtract(Duration(days: 64));

    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];

    return Center(
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          bezierChartScale: BezierChartScale.MONTHLY,
          fromDate: fromDate,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Duty",
              onMissingValue: (dateTime) {
                if (dateTime.month.isEven) {
                  return 10.0;
                }
                return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: 10, xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
                DataPoint<DateTime>(value: 20, xAxis: date3),
                DataPoint<DateTime>(value: 80, xAxis: date4),
                DataPoint<DateTime>(value: 14, xAxis: date5),
                DataPoint<DateTime>(value: 30, xAxis: date6),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 13.0,
            verticalIndicatorColor: Colors.black,
            showVerticalIndicator: false,
            xAxisTextStyle: Theme.of(context).textTheme.caption.copyWith(
              color: Colors.white
            ),
            yAxisTextStyle: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.white
            ),
            verticalIndicatorFixedPosition: true,
            backgroundColor: Colors.transparent,
            footerHeight: 70.0,
            bubbleIndicatorColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
