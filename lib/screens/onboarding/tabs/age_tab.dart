import 'package:flutter/material.dart';
import 'package:flutter_weighter/screens/onboarding/bloc/bloc_provider.dart';
import 'package:flutter_weighter/screens/onboarding/widget/onboarding_header_text.dart';
import 'package:flutter_weighter/utility/color_utility.dart';
import 'package:flutter_weighter/utility/constants.dart';
import 'package:flutter_weighter/utility/translation/app_translations.dart';
import 'package:flutter_weighter/widget/auto_complete_textfeild.dart';
import 'package:flutter_weighter/widget/rounded_button.dart';

class AgeTab extends StatefulWidget {
  // Controllers
  @override
  _AgeTabState createState() => _AgeTabState();
}

class _AgeTabState extends State<AgeTab> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
		    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
		    height: MediaQuery.of(context).size.height * 0.7,
		    child: buildFormContainer(context));
  }


  Widget buildFormContainer(BuildContext context) {
    return Stack(
      children: <Widget>[buildTitleLabel(context), buildForm(context)],
    );
  }

  buildTitleLabel(BuildContext context) => Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: OnBoardingHeaderText(text: '${AppTranslations.of(context).text("age_label")}'),
      );

  Widget buildForm(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.1,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
	            buildTextFormAge(),
              SizedBox(
                height: MediaQuery.of(context).size.shortestSide * 0.2,
              ),
              buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormAge() {
	  return Padding(
		  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
		  child: TypeAheadFormField(
			  textFieldConfiguration: TextFieldConfiguration(
					  controller: this.ageController,
					  style: TextStyle(
							  color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
							  fontSize: MediaQuery.of(context).size.shortestSide * 0.05,
							  letterSpacing: 1.2),
					  keyboardType: TextInputType.numberWithOptions(),
					  maxLength: 2,
					  decoration: InputDecoration(
						  border: InputBorder.none,
						  hintText: AppTranslations.of(context).text("age_hint"),
						  helperText: AppTranslations.of(context).text("age_helper"),
						  helperStyle: TextStyle(
								  color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
								  fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
								  letterSpacing: 0.8),
						  errorStyle: TextStyle(
								  color: Theme.of(context).errorColor,
								  fontSize: MediaQuery.of(context).size.shortestSide * 0.03,
								  letterSpacing: 0.8),
					  )),
			  suggestionsCallback: (pattern) {
				  return AgeService.getSuggestions(pattern);
			  },
			  itemBuilder: (context, suggestion) {
				  return ListTile(
					  title: Text(suggestion),
				  );
			  },
			  transitionBuilder: (context, suggestionsBox, controller) {
				  return suggestionsBox;
			  },
			  onSuggestionSelected: (suggestion) {
				  this.ageController.text = suggestion;
			  },
			  validator: (value) =>
			  value.length < 2 ? AppTranslations.of(context).text("age_validation_invalid") : null,
		  ),
	  );
  }



  Widget buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
      child: RoundedButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            OnboardingBlocProvider.of(context).age = int.parse(ageController.value.text);
            OnboardingBlocProvider.of(context).pageNavigationSink.add(NAVIGATE_TO_PHYSICAL_TAB);
          }
        },
        text: AppTranslations.of(context).text("next"),
      ),
    );
  }
}


class AgeService {
	static final List<String> ageList = List<String>.generate(82, (i) => (18 + i).toString());

	static List<String> getSuggestions(String query) {
		List<String> matches = List();
		matches.addAll(ageList);

		matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
		return matches;
	}
}
