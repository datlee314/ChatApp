import 'package:chat_app/Model/CountryModel.dart';
import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({Key key, this.setCountryData}) : super(key: key);
  final Function setCountryData;

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<CountryModel> countries = [
    CountryModel(name: "India", code: "+91", flag: "๐ฎ๐ณ"),
    CountryModel(name: "Pakistan", code: "+92", flag: "๐ต๐ฐ"),
    CountryModel(name: "United States", code: "+1", flag: "๐บ๐ธ"),
    CountryModel(name: "South Africa", code: "+27", flag: "๐ฟ๐ฆ"),
    CountryModel(name: "Afghanistan", code: "+93", flag: "๐ฆ๐ซ"),
    CountryModel(name: "United Kingdom", code: "+44", flag: "๐ฌ๐ง"),
    CountryModel(name: "Italy", code: "+39", flag: "๐ฎ๐น"),
    CountryModel(name: "India", code: "+91", flag: "๐ฎ๐ณ"),
    CountryModel(name: "Pakistan", code: "+92", flag: "๐ต๐ฐ"),
    CountryModel(name: "United States", code: "+1", flag: "๐บ๐ธ"),
    CountryModel(name: "South Africa", code: "+27", flag: "๐ฟ๐ฆ"),
    CountryModel(name: "Afghanistan", code: "+93", flag: "๐ฆ๐ซ"),
    CountryModel(name: "United Kingdom", code: "+44", flag: "๐ฌ๐ง"),
    CountryModel(name: "Italy", code: "+39", flag: "๐ฎ๐น"),
    CountryModel(name: "Viแปt Nam", code: "+84", flag: "๐ป๐ณ"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            )),
        title: Text(
          "Choose a country",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            wordSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) => card(countries[index])),
    );
  }

  Widget card(CountryModel country) {
    return InkWell(
      onTap: () {
        widget.setCountryData(country);
      },
      child: Card(
        margin: EdgeInsets.all(0.15),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Text(country.flag),
              SizedBox(
                width: 15,
              ),
              Text(country.name),
              Expanded(
                child: Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(country.code),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
