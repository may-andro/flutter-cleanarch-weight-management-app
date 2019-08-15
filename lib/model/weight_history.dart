import 'dart:convert';

WeightHistory userFromJson(String str) {
	final jsonData = json.decode(str);
	return WeightHistory.fromJson(jsonData);
}

String userToJson(WeightHistory data) {
	final dyn = data.toJson();
	return json.encode(dyn);
}

class WeightHistory {
	double weight;
	String difference;
	String date;
	String time;

	WeightHistory({this.weight, this.difference, this.date, this.time});


	factory WeightHistory.fromJson(Map<String, dynamic> json) => new WeightHistory(
		weight: json["history_weight"],
		difference: json["history_weight_difference"],
		date: json["history_date"],
		time: json["history_time"],
	);

	Map<String, dynamic> toJson() => {
		"history_weight": weight,
		"history_weight_difference": difference,
		"history_date": date,
		"history_time": time,
	};
}