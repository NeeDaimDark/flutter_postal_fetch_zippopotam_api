import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tech_test_model.dart';
export 'tech_test_model.dart';

// API Imports
import 'dart:convert';
import 'package:http/http.dart' as http;

class TechTestWidget extends StatefulWidget {
  const TechTestWidget({super.key});

  static String routeName = 'Tech_Test';
  static String routePath = '/techTest';

  @override
  State<TechTestWidget> createState() => _TechTestWidgetState();
}

class _TechTestWidgetState extends State<TechTestWidget> {
  late TechTestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> paginatedDataTableRecordList = [];

  Future<void> fetchPostalData() async {
    final country = _model.textController1?.text.trim().toLowerCase() ?? '';
    final postal = _model.textController2?.text.trim() ?? '';

    if (country.isEmpty || postal.isEmpty) {
      showSnackbar(context, 'Please enter both country and postal code');
      return;
    }

    final url = Uri.parse('https://api.zippopotam.us/$country/$postal');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final places = data['places'] as List;

        setState(() {
          paginatedDataTableRecordList = places.map((place) {
            return {
              'Postal Code': postal,
              'Country': data['country'],
              'Place Name': place['place name'],
              'State': place['state'],
              'Longitude': place['longitude'],
              'Latitude': place['latitude'],
            };
          }).toList();
        });
      } else {
        showSnackbar(context, 'No data found for this code');
      }
    } catch (e) {
      showSnackbar(context, 'Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TechTestModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GenZ Builders',
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: 'Roboto Mono',
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 28.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          decoration: const InputDecoration(
                            hintText: 'Country Code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(
                        child: TextFormField(
                          controller: _model.textController2,
                          focusNode: _model.textFieldFocusNode2,
                          decoration: const InputDecoration(
                            hintText: 'Postal Code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  FFButtonWidget(
                    onPressed: fetchPostalData,
                    text: 'Fetch',
                    options: FFButtonOptions(
                      height: 40.0,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Inter Tight',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 620,
                      height: 400,
                      child: FlutterFlowDataTable<dynamic>(
                        controller: _model.paginatedDataTableController,
                        data: paginatedDataTableRecordList,
                        columnsBuilder: (onSortChanged) => [
                          DataColumn2(label: const Text('Postal Code'), fixedWidth: 100),
                          DataColumn2(label: const Text('Country'), fixedWidth: 80),
                          DataColumn2(label: const Text('State'), fixedWidth: 100),
                          DataColumn2(label: const Text('Place Name'), fixedWidth: 120),
                          DataColumn2(label: const Text('Longitude'), fixedWidth: 100),
                          DataColumn2(label: const Text('Latitude'), fixedWidth: 100),
                        ],
                        dataRowBuilder: (item, index, selected, onSelectChanged) => DataRow(
                          cells: [
                            DataCell(Text(item['Postal Code'].toString(), textAlign: TextAlign.center)),
                            DataCell(Text(item['Country'].toString(), textAlign: TextAlign.center)),
                            DataCell(Text(item['State'].toString(), textAlign: TextAlign.center)),
                            DataCell(Text(item['Place Name'].toString(), textAlign: TextAlign.center)),
                            DataCell(Text(item['Longitude'].toString(), textAlign: TextAlign.center)),
                            DataCell(Text(item['Latitude'].toString(), textAlign: TextAlign.center)),
                          ],
                        ),
                        paginated: true,
                        headingRowHeight: 56.0,
                        dataRowHeight: 48.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
