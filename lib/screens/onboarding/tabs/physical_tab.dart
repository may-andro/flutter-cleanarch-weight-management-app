import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/height_card.dart';
import 'dart:math';

import 'package:flutter_weighter/widget/weight_card.dart';

class PhysicalTab extends StatelessWidget {

	Color left = Colors.black;
	Color right = Colors.white;

	@override
	Widget build(BuildContext context) {
		return _buildScrollPage(context);
	}

	Widget _buildScrollPage(BuildContext context) {
		return Padding(
			padding: EdgeInsets.only(top: MediaQuery
					.of(context)
					.size
					.height * 0.15),
			child: Column(
				children: <Widget>[
					buildInfoCard(context),
					Expanded(
						child: HeightCard(
							genderCode: OnboardingBlocProvider
									.of(context)
									.genderCode,
							height: OnboardingBlocProvider
									.of(context).height.toInt(),
							onChanged: (val) {
								OnboardingBlocProvider
										.of(context)
										.height = val.toDouble();
								OnboardingBlocProvider
										.of(context)
										.selectedHeightSink
										.add(val.toDouble());
							},
						),
						flex: 1,
					),
					StreamBuilder<double>(
							stream: OnboardingBlocProvider
									.of(context)
									.selectedWeightStream,
							builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
								double selectedWeight = snapshot.hasData ? snapshot.data : OnboardingBlocProvider
										.of(context).weight.toDouble();
								return WeightCard(
									weight: selectedWeight.toInt(),
									onChanged: (val) {
										OnboardingBlocProvider
												.of(context)
												.weight = val.toDouble();
										OnboardingBlocProvider
												.of(context)
												.selectedWeightSink
												.add(val.toDouble());
									},
								);
							}),
				],
			),
		);
	}

	buildInfoCard(BuildContext context) =>
			Container(
				height: MediaQuery
						.of(context)
						.size
						.height * 0.15,
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Row(
							children: <Widget>[
								Spacer(),
								Text(
									'${AppTranslations.of(context).text("height")} (${AppTranslations.of(context).text("cm")})',
									style: TextStyle(fontSize: MediaQuery
											.of(context)
											.size
											.shortestSide * 0.03),
								),
								Spacer(
									flex: 2,
								),
								Text(
									'${AppTranslations.of(context).text("weight")} (${AppTranslations.of(context).text("kg")})',
									style: TextStyle(fontSize: MediaQuery
											.of(context)
											.size
											.shortestSide * 0.03),
								),
								Spacer(),
							],
						),
						Row(
							children: <Widget>[
								Spacer(),
								StreamBuilder<double>(
										stream: OnboardingBlocProvider
												.of(context)
												.selectedHeightStream,
										builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
											double selectedHeight = snapshot.hasData ? snapshot.data : OnboardingBlocProvider.of(context).height;
											return Text(
												'$selectedHeight',
												style: TextStyle(fontSize: MediaQuery
														.of(context)
														.size
														.shortestSide * 0.05),
											);
										}),
								Spacer(
									flex: 2,
								),
								StreamBuilder<double>(
										stream: OnboardingBlocProvider
												.of(context)
												.selectedWeightStream,
										builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
											double selectedWeight = snapshot.hasData ? snapshot.data : OnboardingBlocProvider.of(context).weight;
											return Text(
												'$selectedWeight',
												style: TextStyle(fontSize: MediaQuery
														.of(context)
														.size
														.shortestSide * 0.05),
											);
										}),
								Spacer(),
							],
						)
					],
				),
			);
}
