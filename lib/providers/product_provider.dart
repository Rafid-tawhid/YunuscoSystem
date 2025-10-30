import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/buyer_wise_material_model.dart';
import 'package:yunusco_group/models/production_dashboard_model.dart';
import 'package:yunusco_group/service_class/api_services.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../models/cs_requisation_model.dart';
import '../models/master_lc_model.dart';
import '../models/production_efficiency_model.dart';
import '../models/production_goods_model.dart';
import '../models/purchase_dashboard_analytics_model.dart';
import '../models/purchase_order_model.dart';
import '../models/purchase_requisation_list_model.dart';
import '../models/requisation_products_model.dart';
import '../models/requisition_details_model.dart';
import '../models/stylewise_efficiency_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> countryList = [
    {"id": 1, "code": "COU001", "name": "USA"},
    {"id": 2, "code": "COU002", "name": "Canada"},
    {"id": 3, "code": "COU003", "name": "Afghanistan"},
    {"id": 4, "code": "COU004", "name": "Albania"},
    {"id": 5, "code": "COU005", "name": "Algeria"},
    {"id": 6, "code": "COU006", "name": "American Samoa"},
    {"id": 7, "code": "COU007", "name": "Andorra"},
    {"id": 8, "code": "COU008", "name": "Angola"},
    {"id": 9, "code": "COU009", "name": "Anguilla"},
    {"id": 10, "code": "COU010", "name": "Antarctica"},
    {"id": 11, "code": "COU011", "name": "Antigua and/or Barbuda"},
    {"id": 12, "code": "COU012", "name": "Argentina"},
    {"id": 13, "code": "COU013", "name": "Armenia"},
    {"id": 14, "code": "COU014", "name": "Aruba"},
    {"id": 15, "code": "COU015", "name": "Australia"},
    {"id": 16, "code": "COU016", "name": "Austria"},
    {"id": 17, "code": "COU017", "name": "Azerbaijan"},
    {"id": 18, "code": "COU018", "name": "Bahamas"},
    {"id": 19, "code": "COU019", "name": "Bahrain"},
    {"id": 20, "code": "COU020", "name": "Bangladesh"},
    {"id": 21, "code": "COU021", "name": "Barbados"},
    {"id": 22, "code": "COU022", "name": "Belarus"},
    {"id": 23, "code": "COU023", "name": "Belgium"},
    {"id": 24, "code": "COU024", "name": "Belize"},
    {"id": 25, "code": "COU025", "name": "Benin"},
    {"id": 26, "code": "COU026", "name": "Bermuda"},
    {"id": 27, "code": "COU027", "name": "Bhutan"},
    {"id": 28, "code": "COU028", "name": "Bolivia"},
    {"id": 29, "code": "COU029", "name": "Bosnia and Herzegovina"},
    {"id": 30, "code": "COU030", "name": "Botswana"},
    {"id": 31, "code": "COU031", "name": "Bouvet Island"},
    {"id": 32, "code": "COU032", "name": "Brazil"},
    {"id": 33, "code": "COU033", "name": "British lndian Ocean Territory"},
    {"id": 34, "code": "COU034", "name": "Brunei Darussalam"},
    {"id": 35, "code": "COU035", "name": "Bulgaria"},
    {"id": 36, "code": "COU036", "name": "Burkina Faso"},
    {"id": 37, "code": "COU037", "name": "Burundi"},
    {"id": 38, "code": "COU038", "name": "Cambodia"},
    {"id": 39, "code": "COU039", "name": "Cameroon"},
    {"id": 40, "code": "COU040", "name": "Cape Verde"},
    {"id": 41, "code": "COU041", "name": "Cayman Islands"},
    {"id": 42, "code": "COU042", "name": "Central African Republic"},
    {"id": 43, "code": "COU043", "name": "Chad"},
    {"id": 44, "code": "COU044", "name": "Chile"},
    {"id": 45, "code": "COU045", "name": "China"},
    {"id": 46, "code": "COU046", "name": "Christmas Island"},
    {"id": 47, "code": "COU047", "name": "Cocos (Keeling) Islands"},
    {"id": 48, "code": "COU048", "name": "Colombia"},
    {"id": 49, "code": "COU049", "name": "Comoros"},
    {"id": 50, "code": "COU050", "name": "Congo"},
    {"id": 51, "code": "COU051", "name": "Cook Islands"},
    {"id": 52, "code": "COU052", "name": "Costa Rica"},
    {"id": 53, "code": "COU053", "name": "Croatia (Hrvatska)"},
    {"id": 54, "code": "COU054", "name": "Cuba"},
    {"id": 55, "code": "COU055", "name": "Cyprus"},
    {"id": 56, "code": "COU056", "name": "Czech Republic"},
    {"id": 57, "code": "COU057", "name": "Denmark"},
    {"id": 58, "code": "COU058", "name": "Djibouti"},
    {"id": 59, "code": "COU059", "name": "Dominica"},
    {"id": 60, "code": "COU060", "name": "Dominican Republic"},
    {"id": 61, "code": "COU061", "name": "East Timor"},
    {"id": 62, "code": "COU062", "name": "Ecudaor"},
    {"id": 63, "code": "COU063", "name": "Egypt"},
    {"id": 64, "code": "COU064", "name": "El Salvador"},
    {"id": 65, "code": "COU065", "name": "Equatorial Guinea"},
    {"id": 66, "code": "COU066", "name": "Eritrea"},
    {"id": 67, "code": "COU067", "name": "Estonia"},
    {"id": 68, "code": "COU068", "name": "Ethiopia"},
    {"id": 69, "code": "COU069", "name": "Falkland Islands (Malvinas)"},
    {"id": 70, "code": "COU070", "name": "Faroe Islands"},
    {"id": 71, "code": "COU071", "name": "Fiji"},
    {"id": 72, "code": "COU072", "name": "Finland"},
    {"id": 73, "code": "COU073", "name": "France"},
    {"id": 74, "code": "COU074", "name": "France, Metropolitan"},
    {"id": 75, "code": "COU075", "name": "French Guiana"},
    {"id": 76, "code": "COU076", "name": "French Polynesia"},
    {"id": 77, "code": "COU077", "name": "French Southern Territories"},
    {"id": 78, "code": "COU078", "name": "Gabon"},
    {"id": 79, "code": "COU079", "name": "Gambia"},
    {"id": 80, "code": "COU080", "name": "Georgia"},
    {"id": 81, "code": "COU081", "name": "Germany"},
    {"id": 82, "code": "COU082", "name": "Ghana"},
    {"id": 83, "code": "COU083", "name": "Gibraltar"},
    {"id": 84, "code": "COU084", "name": "Greece"},
    {"id": 85, "code": "COU085", "name": "Greenland"},
    {"id": 86, "code": "COU086", "name": "Grenada"},
    {"id": 87, "code": "COU087", "name": "Guadeloupe"},
    {"id": 88, "code": "COU088", "name": "Guam"},
    {"id": 89, "code": "COU089", "name": "Guatemala"},
    {"id": 90, "code": "COU090", "name": "Guinea"},
    {"id": 91, "code": "COU091", "name": "Guinea-Bissau"},
    {"id": 92, "code": "COU092", "name": "Guyana"},
    {"id": 93, "code": "COU093", "name": "Haiti"},
    {"id": 94, "code": "COU094", "name": "Heard and Mc Donald Islands"},
    {"id": 95, "code": "COU095", "name": "Honduras"},
    {"id": 96, "code": "COU096", "name": "Hong Kong"},
    {"id": 97, "code": "COU097", "name": "Hungary"},
    {"id": 98, "code": "COU098", "name": "Iceland"},
    {"id": 99, "code": "COU099", "name": "India"},
    {"id": 100, "code": "COU100", "name": "Indonesia"},
    {"id": 101, "code": "COU101", "name": "Iran (Islamic Republic of)"},
    {"id": 102, "code": "COU102", "name": "Iraq"},
    {"id": 103, "code": "COU103", "name": "Ireland"},
    {"id": 104, "code": "COU104", "name": "Israel"},
    {"id": 105, "code": "COU105", "name": "Italy"},
    {"id": 106, "code": "COU106", "name": "Ivory Coast"},
    {"id": 107, "code": "COU107", "name": "Jamaica"},
    {"id": 108, "code": "COU108", "name": "Japan"},
    {"id": 109, "code": "COU109", "name": "Jordan"},
    {"id": 110, "code": "COU110", "name": "Kazakhstan"},
    {"id": 111, "code": "COU111", "name": "Kenya"},
    {"id": 112, "code": "COU112", "name": "Kiribati"},
    {"id": 113, "code": "COU113", "name": "Korea, Democratic People's Republic of"},
    {"id": 114, "code": "COU114", "name": "Korea, Republic of"},
    {"id": 115, "code": "COU115", "name": "Kuwait"},
    {"id": 116, "code": "COU116", "name": "Kyrgyzstan"},
    {"id": 117, "code": "COU117", "name": "Lao People's Democratic Republic"},
    {"id": 118, "code": "COU118", "name": "Latvia"},
    {"id": 119, "code": "COU119", "name": "Lebanon"},
    {"id": 120, "code": "COU120", "name": "Lesotho"},
    {"id": 121, "code": "COU121", "name": "Liberia"},
    {"id": 122, "code": "COU122", "name": "Libyan Arab Jamahiriya"},
    {"id": 123, "code": "COU123", "name": "Liechtenstein"},
    {"id": 124, "code": "COU124", "name": "Lithuania"},
    {"id": 125, "code": "COU125", "name": "Luxembourg"},
    {"id": 126, "code": "COU126", "name": "Macau"},
    {"id": 127, "code": "COU127", "name": "Macedonia"},
    {"id": 128, "code": "COU128", "name": "Madagascar"},
    {"id": 129, "code": "COU129", "name": "Malawi"},
    {"id": 130, "code": "COU130", "name": "Malaysia"},
    {"id": 131, "code": "COU131", "name": "Maldives"},
    {"id": 132, "code": "COU132", "name": "Mali"},
    {"id": 133, "code": "COU133", "name": "Malta"},
    {"id": 134, "code": "COU134", "name": "Marshall Islands"},
    {"id": 135, "code": "COU135", "name": "Martinique"},
    {"id": 136, "code": "COU136", "name": "Mauritania"},
    {"id": 137, "code": "COU137", "name": "Mauritius"},
    {"id": 138, "code": "COU138", "name": "Mayotte"},
    {"id": 139, "code": "COU139", "name": "Mexico"},
    {"id": 140, "code": "COU140", "name": "Micronesia, Federated States of"},
    {"id": 141, "code": "COU141", "name": "Moldova, Republic of"},
    {"id": 142, "code": "COU142", "name": "Monaco"},
    {"id": 143, "code": "COU143", "name": "Mongolia"},
    {"id": 144, "code": "COU144", "name": "Montserrat"},
    {"id": 145, "code": "COU145", "name": "Morocco"},
    {"id": 146, "code": "COU146", "name": "Mozambique"},
    {"id": 147, "code": "COU147", "name": "Myanmar"},
    {"id": 148, "code": "COU148", "name": "Namibia"},
    {"id": 149, "code": "COU149", "name": "Nauru"},
    {"id": 150, "code": "COU150", "name": "Nepal"},
    {"id": 151, "code": "COU151", "name": "Netherlands"},
    {"id": 152, "code": "COU152", "name": "Netherlands Antilles"},
    {"id": 153, "code": "COU153", "name": "New Caledonia"},
    {"id": 154, "code": "COU154", "name": "New Zealand"},
    {"id": 155, "code": "COU155", "name": "Nicaragua"},
    {"id": 156, "code": "COU156", "name": "Niger"},
    {"id": 157, "code": "COU157", "name": "Nigeria"},
    {"id": 158, "code": "COU158", "name": "Niue"},
    {"id": 159, "code": "COU159", "name": "Norfork Island"},
    {"id": 160, "code": "COU160", "name": "Northern Mariana Islands"},
    {"id": 161, "code": "COU161", "name": "Norway"},
    {"id": 162, "code": "COU162", "name": "Oman"},
    {"id": 163, "code": "COU163", "name": "Pakistan"},
    {"id": 164, "code": "COU164", "name": "Palau"},
    {"id": 165, "code": "COU165", "name": "Panama"},
    {"id": 166, "code": "COU166", "name": "Papua New Guinea"},
    {"id": 167, "code": "COU167", "name": "Paraguay"},
    {"id": 168, "code": "COU168", "name": "Peru"},
    {"id": 169, "code": "COU169", "name": "Philippines"},
    {"id": 170, "code": "COU170", "name": "Pitcairn"},
    {"id": 171, "code": "COU171", "name": "Poland"},
    {"id": 172, "code": "COU172", "name": "Portugal"},
    {"id": 173, "code": "COU173", "name": "Puerto Rico"},
    {"id": 174, "code": "COU174", "name": "Qatar"},
    {"id": 175, "code": "COU175", "name": "Reunion"},
    {"id": 176, "code": "COU176", "name": "Romania"},
    {"id": 177, "code": "COU177", "name": "Russian Federation"},
    {"id": 178, "code": "COU178", "name": "Rwanda"},
    {"id": 179, "code": "COU179", "name": "Saint Kitts and Nevis"},
    {"id": 180, "code": "COU180", "name": "Saint Lucia"},
    {"id": 181, "code": "COU181", "name": "Saint Vincent and the Grenadines"},
    {"id": 182, "code": "COU182", "name": "Samoa"},
    {"id": 183, "code": "COU183", "name": "San Marino"},
    {"id": 184, "code": "COU184", "name": "Sao Tome and Principe"},
    {"id": 185, "code": "COU185", "name": "Saudi Arabia"},
    {"id": 186, "code": "COU186", "name": "Senegal"},
    {"id": 187, "code": "COU187", "name": "Seychelles"},
    {"id": 188, "code": "COU188", "name": "Sierra Leone"},
    {"id": 189, "code": "COU189", "name": "Singapore"},
    {"id": 190, "code": "COU190", "name": "Slovakia"},
    {"id": 191, "code": "COU191", "name": "Slovenia"},
    {"id": 192, "code": "COU192", "name": "Solomon Islands"},
    {"id": 193, "code": "COU193", "name": "Somalia"},
    {"id": 194, "code": "COU194", "name": "South Africa"},
    {"id": 195, "code": "COU195", "name": "South Georgia South Sandwich Islands"},
    {"id": 196, "code": "COU196", "name": "Spain"},
    {"id": 197, "code": "COU197", "name": "Sri Lanka"},
    {"id": 198, "code": "COU198", "name": "St. Helena"},
    {"id": 199, "code": "COU199", "name": "St. Pierre and Miquelon"},
    {"id": 200, "code": "COU200", "name": "Sudan"},
    {"id": 201, "code": "COU201", "name": "Suriname"},
    {"id": 202, "code": "COU202", "name": "Svalbarn and Jan Mayen Islands"},
    {"id": 203, "code": "COU203", "name": "Swaziland"},
    {"id": 204, "code": "COU204", "name": "Sweden"},
    {"id": 205, "code": "COU205", "name": "Switzerland"},
    {"id": 206, "code": "COU206", "name": "Syrian Arab Republic"},
    {"id": 207, "code": "COU207", "name": "Taiwan"},
    {"id": 208, "code": "COU208", "name": "Tajikistan"},
    {"id": 209, "code": "COU209", "name": "Tanzania, United Republic of"},
    {"id": 210, "code": "COU210", "name": "Thailand"},
    {"id": 211, "code": "COU211", "name": "Togo"},
    {"id": 212, "code": "COU212", "name": "Tokelau"},
    {"id": 213, "code": "COU213", "name": "Tonga"},
    {"id": 214, "code": "COU214", "name": "Trinidad and Tobago"},
    {"id": 215, "code": "COU215", "name": "Tunisia"},
    {"id": 216, "code": "COU216", "name": "Turkey"},
    {"id": 217, "code": "COU217", "name": "Turkmenistan"},
    {"id": 218, "code": "COU218", "name": "Turks and Caicos Islands"},
    {"id": 219, "code": "COU219", "name": "Tuvalu"},
    {"id": 220, "code": "COU220", "name": "Uganda"},
    {"id": 221, "code": "COU221", "name": "Ukraine"},
    {"id": 222, "code": "COU222", "name": "United Arab Emirates"},
    {"id": 223, "code": "COU223", "name": "United Kingdom"},
    {"id": 224, "code": "COU224", "name": "United States minor outlying islands"},
    {"id": 225, "code": "COU225", "name": "Uruguay"},
    {"id": 226, "code": "COU226", "name": "Uzbekistan"},
    {"id": 227, "code": "COU227", "name": "Vanuatu"},
    {"id": 228, "code": "COU228", "name": "Vatican City State"},
    {"id": 229, "code": "COU229", "name": "Venezuela"},
    {"id": 230, "code": "COU230", "name": "Vietnam"},
    {"id": 231, "code": "COU231", "name": "Virigan Islands (British)"},
    {"id": 232, "code": "COU232", "name": "Virgin Islands (U.S.)"},
    {"id": 233, "code": "COU233", "name": "Wallis and Futuna Islands"},
    {"id": 234, "code": "COU234", "name": "Western Sahara"},
    {"id": 235, "code": "COU235", "name": "Yemen"},
    {"id": 236, "code": "COU236", "name": "Yugoslavia"},
    {"id": 237, "code": "COU237", "name": "Zaire"},
    {"id": 238, "code": "COU238", "name": "Zambia"},
    {"id": 239, "code": "COU239", "name": "Zimbabwe"},
    {"id": 240, "code": "COU240", "name": "Unknown"},
    {"id": 241, "code": "COU241", "name": "UAE"},
    {"id": 242, "code": "COU242", "name": "South Korea"},
    {"id": 243, "code": "COU243", "name": "North Korea"},
    {"id": 244, "code": "COU244", "name": "Russia"},
    {"id": 245, "code": "COU245", "name": "Great Britain"},
    {"id": 246, "code": "COU246", "name": "IX-65"},
    {"id": 247, "code": "COU247", "name": "Serbia"},
    {"id": 248, "code": "COU248", "name": "Montenegro"},
    {"id": 249, "code": "COU249", "name": "Valencia"},
    {"id": 250, "code": "COU250", "name": "Third part"},
    {"id": 251, "code": "COU251", "name": "Form"},
    {"id": 252, "code": "COU252", "name": "3th P-Mex"},
    {"id": 253, "code": "COU253", "name": "France-North"},
    {"id": 254, "code": "COU254", "name": "France-South"},
    {"id": 255, "code": "COU240", "name": "Unknown"},
    {"id": 256, "code": "COU256", "name": "Netherland/Great Britain"},
    {"id": 257, "code": "COU257", "name": "German/Poland"},
    {"id": 258, "code": "COU258", "name": "Netherland/Poland"},
    {"id": 259, "code": "COU259", "name": "Germany/Spain"},
    {"id": 260, "code": "COU099", "name": "India"},
    {"id": 261, "code": "COU261", "name": "Scandinavia"},
    {"id": 262, "code": "COU262", "name": "Poland DEW255"},
    {"id": 263, "code": "COU263", "name": "Poland PLW067"},
    {"id": 264, "code": "COU264", "name": "Poland PLW237"},
    {"id": 265, "code": "COU265", "name": "Poland PLW256"},
    {"id": 266, "code": "COU266", "name": "Great Britain GBW159"},
    {"id": 267, "code": "COU267", "name": "Great Britain GBW264"},
    {"id": 268, "code": "COU268", "name": "Indonesia IDW262"},
    {"id": 269, "code": "COU269", "name": "Indonesia THW263"},
    {"id": 270, "code": "COU270", "name": "France ESW267"},
    {"id": 271, "code": "COU271", "name": "France ITW128"},
    {"id": 272, "code": "COU272", "name": "Netherlands DEW255"},
    {"id": 273, "code": "COU273", "name": "Netherlands NLW174"},
    {"id": 274, "code": "COU274", "name": "Poland NLW174"},
    {"id": 275, "code": "COU275", "name": "Poland-LH (OLEEU)"},
    {"id": 276, "code": "COU276", "name": "Thailand-Indonesia"},
    {"id": 277, "code": "COU277", "name": "Thailand-Indonesia IDW262"},
    {"id": 278, "code": "COU278", "name": "Thailand-Indonesia THW263"},
    {"id": 279, "code": "COU279", "name": "Poland OLEEU"},
    {"id": 280, "code": "COU280", "name": "Poland-OE OLCEU"},
    {"id": 281, "code": "COU201", "name": "DC"},
    {"id": 282, "code": "Com47", "name": "North Africa"},
    {"id": 283, "code": "COU283", "name": "TBC"},
    {"id": 284, "code": "COU284", "name": "NH"},
  ];
  ApiService apiService = ApiService();

  final List<dynamic> _allCategoryList = [];
  List<dynamic> get allCategoryList => _allCategoryList;

  Future<bool> getAllCategoryList() async {
    var data = await apiService.getData('api/PreSalesApi/GetStyleCategoryList');
    if (data != null) {
      _allCategoryList.clear();
      for (var i in data['returnvalue']) {
        _allCategoryList.add(i);
      }
      notifyListeners();
      debugPrint('_allCategoryList ${_allCategoryList.length}');
      return true;
    } else {
      return false;
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  final List<dynamic> _allBuyerList = [];
  List<dynamic> get allBuyerList => _allBuyerList;

  Future<bool> getAllBuyerInfo() async {
    var data = await apiService.getData('api/Merchandising/AllActiveOrderdBuyer');
    if (data != null) {
      _allBuyerList.clear();
      for (var i in data['returnvalue']['Result']) {
        _allBuyerList.add(i);
      }
      notifyListeners();
      debugPrint('_allBuyerList ${_allBuyerList.length}');
      return true;
    } else {
      return false;
    }
  }

  bool _isSelectCat = true;
  bool get isSelectCat => _isSelectCat;
  void setSelector(bool bool) {
    _isSelectCat = bool;
    notifyListeners();
  }

  final List<BuyerWiseMaterialModel> _buyerMaterialList = [];
  List<BuyerWiseMaterialModel> get buyerMaterialList => _buyerMaterialList;

  Future<bool> getBuyerWiseMaterialList(String code) async {
    setLoading(true);
    var data = await apiService.getData('api/Merchandising/MaterialListBuyerWise?buyerId=$code');
    setLoading(false);
    if (data != null) {
      _buyerMaterialList.clear();
      for (var i in data['returnvalue']['Result']) {
        _buyerMaterialList.add(BuyerWiseMaterialModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_buyerMaterialList ${_buyerMaterialList.length}');
      return _buyerMaterialList.isNotEmpty ? true : false;
    } else {
      return false;
    }
  }

  final List<Map<String, dynamic>> _productionSummaryList = [];
  List<Map<String, dynamic>> get productionSummaryList => _productionSummaryList;

  Future<bool> getProductionSummary(String month, String year, String section) async {
    setLoading(true);
    var data = await apiService.getData('api/Merchandising/ProductionSummary?section=$section&month=$month&year=$year');
    setLoading(false);
    if (data != null) {
      _productionSummaryList.clear();
      for (var i in data['returnvalue']) {
        _productionSummaryList.add(i);
      }
      notifyListeners();
      debugPrint('_productionSummaryList ${_productionSummaryList.length}');
      return _productionSummaryList.isNotEmpty ? true : false;
    } else {
      return false;
    }
  }

  ProductionDashboardModel? _productionDashboardModel;
  ProductionDashboardModel? get productionDashboardModel => _productionDashboardModel;
  //dashboard
  Future<bool> getAllProductionDashboard() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/dashboard/ProductionDashBoard');
    EasyLoading.dismiss();
    if (data != null) {
      _productionDashboardModel = ProductionDashboardModel.fromJson(data['returnvalue']);
      notifyListeners();
      debugPrint('_allCategoryList ${_productionDashboardModel!.unitWiseSewing!.length}');
      return true;
    } else {
      return false;
    }
  }

  final List<ProductionEfficiencyModel> _productionEfficiencyList = [];

  List<ProductionEfficiencyModel> get productionEfficiencyList => _productionEfficiencyList;

  Future<bool> getProductionEfficiencyReport(String dateTime) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    setLoading(true);
    var data = await apiService
        .postData('api/Merchandising/ProductionEffiReport', {"ProductionDate": dateTime, "BuyerId": 0, "Style": "", "BuyerPO": "", "SectionId": 0, "AchieveEfficiency": 0, "LineId": 0});
    setLoading(false);
    EasyLoading.dismiss();
    if (data != null) {
      _productionEfficiencyList.clear();
      for (var i in data['Data']) {
        _productionEfficiencyList.add(ProductionEfficiencyModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_productionEfficiencyList ${_productionEfficiencyList.length}');
      return true;
    } else {
      return false;
    }
  }

  List<ProductionEfficiencyModel> getFilteredList({
    int? buyerId,
    int? sectionId,
    int? lineId,
    String? styleNo,
  }) {
    return _productionEfficiencyList.where((item) {
      final buyerMatch = buyerId == null || item.buyerId == buyerId;
      final sectionMatch = sectionId == null || item.sectionId == sectionId;
      final lineMatch = lineId == null || item.lineId == lineId;
      final styleMatch = styleNo == null || item.styleNo == styleNo;
      return buyerMatch && sectionMatch && lineMatch && styleMatch;
    }).toList();
  }

  List<DropdownMenuItem<int>> get buyerDropdownItems {
    // Create a map to ensure unique buyerId-buyerName pairs
    final uniqueBuyers = <int, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.buyerId != null && item.buyerName != null) {
        uniqueBuyers[item.buyerId!.toInt()] = item.buyerName!;
      }
    }

    return uniqueBuyers.entries
        .map((entry) => DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList();
  }

  List<DropdownMenuItem<int>> get sectionDropdownItems {
    final uniqueEntries = <int, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.sectionId != null && item.sectionName != null && !uniqueEntries.containsKey(item.sectionId)) {
        uniqueEntries[item.sectionId!.toInt()] = item.sectionName!;
      }
    }

    return uniqueEntries.entries
        .map((entry) => DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList();
  }

  List<DropdownMenuItem<int>> get lineDropdownItems {
    final uniqueEntries = <int, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.lineId != null && item.lineName != null && !uniqueEntries.containsKey(item.lineId)) {
        uniqueEntries[item.lineId!.toInt()] = item.lineName!;
      }
    }

    return uniqueEntries.entries
        .map((entry) => DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> get styleDropdownItems {
    final uniqueEntries = <String, String>{};

    for (final item in _productionEfficiencyList) {
      if (item.styleNo != null && !uniqueEntries.containsKey(item.styleNo)) {
        uniqueEntries[item.styleNo!] = item.styleNo!;
      }
    }

    return uniqueEntries.entries
        .map((entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ))
        .toList();
  }
  //

  final List<StylewiseEfficiencyModel> _styleWiseEfficiencyList = [];
  List<StylewiseEfficiencyModel> get styleWiseEfficiencyList => _styleWiseEfficiencyList;

  Future<bool> getStyleWiseEfficiency(String style) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    setLoading(true);
    var data = await apiService.getData('api/Merchandising/StyleWiseEffi?styleName=$style');
    setLoading(false);
    EasyLoading.dismiss();
    if (data != null) {
      _styleWiseEfficiencyList.clear();
      for (var i in data['returnvalue']['Result']) {
        _styleWiseEfficiencyList.add(StylewiseEfficiencyModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_styleWiseEfficiencyList ${_styleWiseEfficiencyList.length}');
      return true;
    } else {
      return false;
    }
  }

  void searchInStyleList(String query) {
    if (query.isEmpty) {
      // If search query is empty, restore original list
      _filteredBuyerStyleList = List.from(_buyerStyleList);
    } else {
      // Filter the list based on search query
      _filteredBuyerStyleList = _buyerStyleList.where((item) {
        // Convert all comparisons to lowercase for case-insensitive search
        final searchLower = query.toLowerCase();
        // Search in all relevant fields
        return (item.toString().toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    notifyListeners();
  }

  final List<String> _buyerStyleList = [];

  List<String> get buyerStyleList => _buyerStyleList;

  List<String> _filteredBuyerStyleList = [];

  List<String> get filteredStyleList => _filteredBuyerStyleList;

  Future<bool> getAllStyleData() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/Merchandising/StyleForEffiRpt');
    EasyLoading.dismiss();
    if (data != null) {
      _buyerStyleList.clear();
      _filteredBuyerStyleList.clear();
      for (var i in data['returnvalue']) {
        _buyerStyleList.add(i);
      }
      _filteredBuyerStyleList.addAll(_buyerStyleList);
      debugPrint('_buyerStyleList ${_buyerStyleList.length}');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  bool _showFilter = true;
  bool get showFilter => _showFilter;
  void showhideFilterSection(String? value) {
    if (value == null || value.isEmpty || value == '') {
      _showFilter = true;
    } else {
      _showFilter = false;
    }
    notifyListeners();
  }

  final List<MasterLcModel> _masterLcList = [];
  List<MasterLcModel> get masterLcList => _masterLcList;

  Future<bool> getMasterLcData(String query, int pgNum, int pgSize) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/Merchandising/MasterLcListPages?searchText=$query&pageNumber=$pgNum&pageSize=10');
    EasyLoading.dismiss();
    if (data != null) {
      _masterLcList.clear();

      for (var i in data['data']) {
        _masterLcList.add(MasterLcModel.fromJson(i));
      }
      debugPrint('_masterLcList ${_masterLcList.length}');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> _lcDetailsData = {};
  Map<String, dynamic> get lcDetailsData => _lcDetailsData;

  Future<bool> getLcDetails(num? masterLCId) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/Merchandising/GetMasterLCDetails?id=$masterLCId');
    _lcDetailsData = data['returnvalue'];
    EasyLoading.dismiss();
    return data == null ? false : true;
  }

  final List<RequisationProductsModel> _requisationProductList = [];
  List<RequisationProductsModel> get requisationProductList => _requisationProductList;

  Future<void> getAllRequisationProduct() async {
    setLoading(true);
    var data = await apiService.getData('api/Inventory/G&AReqProductList');
    setLoading(false);
    if (data != null) {
      _requisationProductList.clear();
      for (var i in data['returnvalue']) {
        _requisationProductList.add(RequisationProductsModel.fromJson(i));
      }
    }
    notifyListeners();
    debugPrint('_requisationProductList ${_requisationProductList.length}');
  }

  Future<bool> submitGeneralRequisation(Map<String, Object> data) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    setLoading(true);
    var response = await apiService.postData('api/Inventory/SavePurchaseRequisition', data);
    setLoading(false);
    EasyLoading.dismiss();
    debugPrint('Return Response : ${response.toString()}');

    return true;
  }

  List<PurchaseRequisationListModel> _requisitions = [];

  List<PurchaseRequisationListModel> get requisitions => _requisitions;

  Future<void> getAllRequisitions({required int pageNo}) async {
    setLoading(true);
    var data = await apiService.getData(
      'api/Inventory/PurchaseRequisitionList?pageNumber=$pageNo&pageSize=100',
    );
    setLoading(false);

    if (data != null && data['returnvalue']?['Data'] != null) {
      List<PurchaseRequisationListModel> fetchedList = [];

      for (var i in data['returnvalue']['Data']) {
        fetchedList.add(PurchaseRequisationListModel.fromJson(i));
      }

      // 🧠 For page 1: clear existing list. Otherwise, append.
      if (pageNo == 1) {
        _requisitions.clear();
      }

      // 🧩 Avoid duplicates when appending
      for (var item in fetchedList) {
        bool alreadyExists = _requisitions.any(
              (e) => e.purchaseRequisitionCode == item.purchaseRequisitionCode,
        );
        if (!alreadyExists) {
          _requisitions.add(item);
        }
      }

      // Optional: sort if needed (remove .reversed)
      // _requisitions = _requisitions.reversed.toList();

      // Update filtered list (for UI)
      _filteredRequisitions = List.from(_requisitions);
    }

    debugPrint('_requisitions count: ${_requisitions.length}');
    debugPrint('_filteredRequisitions count: ${_filteredRequisitions.length}');
    notifyListeners();
  }


  updateReqListAfterAcceptOrRej(String reqCode) {
    int index = _filteredRequisitions.indexWhere((e) => e.purchaseRequisitionCode == reqCode);
    if (index != -1) {
      // Get the current value and flip it

      _filteredRequisitions[index] = _filteredRequisitions[index].copyWith(isComplete: true);
      notifyListeners();
    }
  }

  List<RequisitionDetailsModel> requisationProductDetails = [];

  Future<bool> getRequisationProductDetails(String? purchaseRequisitionCode) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.getData('api/Inventory/SingleGenPurReqMaster&Detail?Code=$purchaseRequisitionCode');
    EasyLoading.dismiss();
    if (data != null) {
      requisationProductDetails.clear();
      for (var i in data['returnvalue']) {
        requisationProductDetails.add(RequisitionDetailsModel.fromJson(i));
      }
      notifyListeners();

      debugPrint('requisationProductDetails ${requisationProductDetails.length}');
      return true;
    } else {
      return false;
    }
  }

  //NEW
  final List<ProductionGoodsModel> _requisitionList = [];
  List<ProductionGoodsModel> _filteredRequisitionList = [];
  String _searchQuery = '';

  List<ProductionGoodsModel> get requisitionList => _requisitionList;
  List<ProductionGoodsModel> get filteredRequisitionList => _filteredRequisitionList;

  Future<void> fetchRequisitionList({String? fromDate, String? toDate}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace with your actual API call
      final data = await apiService.getData('api/Inventory/ProductionGoodsRequisition?FromDate=$fromDate&ToDate=$toDate');

      if (data != null) {
        for (var i in data['returnvalue']) {
          _requisitionList.add(ProductionGoodsModel.fromJson(i));
        }
      }

      debugPrint('_requisitionList ${_requisitionList.length}');

      _filteredRequisitionList = _applyFilters(_requisitionList);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchRequisitions(String query) {
    _searchQuery = query.toLowerCase();
    _filteredRequisitionList = _applyFilters(_requisitionList);
    notifyListeners();
  }

  List<ProductionGoodsModel> _applyFilters(List<ProductionGoodsModel> list) {
    return list.where((req) {
      return _searchQuery.isEmpty ||
          (req.requisitionCode?.toLowerCase().contains(_searchQuery) == true) ||
          (req.buyerOrderCode?.toLowerCase().contains(_searchQuery) == true) ||
          (req.buyerPo?.toLowerCase().contains(_searchQuery) == true) ||
          (req.styleCode?.toLowerCase().contains(_searchQuery) == true) ||
          (req.bomcode?.toLowerCase().contains(_searchQuery) == true);
    }).toList();
  }

  // final List<Map<String, dynamic>> countryList = [
  //   {"id": 1, "name": "USA"},
  //   {"id": 2, "name": "Canada"},
  //   {"id": 3, "name": "Afghanistan"},
  //   {"id": 4, "name": "Bangladesh"},
  //   {"id": 5, "name": "India"},
  // ];

  Future<List<Map<String, dynamic>>> searchStuffList(String query) async {
    if (query.isEmpty) return countryList;
    final lower = query.toLowerCase();
    return countryList.where((c) => c['name'].toLowerCase().contains(lower)).toList();
  }

  Future<void> createSupplier(Map<String, dynamic> supplierData) async {
    var data = await apiService.postData('api/inventory/CreateSupplier', supplierData);

    debugPrint('RESPONSE $data');
  }

  final List<Map<String, dynamic>> _sectionWiseDhu = [];
  List<Map<String, dynamic>> get sectionWiseDhu => _sectionWiseDhu;

  final List<Map<String, dynamic>> _lineWiseDHU = [];
  List<Map<String, dynamic>> get lineWiseDHU => _lineWiseDHU;
  String _totalDhu = '';
  String get totalDhu => _totalDhu;

  Future<void> getAllDhuInfo(DateTime dateTime) async {
    var dateFormat = DashboardHelpers.convertDateTime2(dateTime);
    debugPrint('dateFormat $dateFormat');
    var data = await apiService.getData('api/QMS/GetDHU?qmsDate=$dateFormat');
    if (data != null) {
      _sectionWiseDhu.clear();
      _lineWiseDHU.clear();
      for (var i in data['Data']['SectionWiseDHU']) {
        _sectionWiseDhu.add(i);
      }
      for (var i in data['Data']['LineWiseDHU']) {
        _lineWiseDHU.add(i);
      }
      _totalDhu = data['Data']['TotalDHU']['TotalDHU'].toString();

      debugPrint('_sectionWiseDhu ${_sectionWiseDhu.length}');
      debugPrint('_lineWiseDHU ${_lineWiseDHU.length}');
      debugPrint('_totalDhu $_totalDhu');
    }
    notifyListeners();
  }

  // Future<List<Map<String, dynamic>>> searchStuffList(String query) async {
  //   if (query.isEmpty) {
  //     return countryList; // return full list if no search
  //   }
  //
  //   debugPrint('HELLO $query');
  //   final lowerQuery = query.toLowerCase();
  //   var data= countryList.where((country) {
  //     final name = country["name"].toString().toLowerCase();
  //     final code = country["code"].toString().toLowerCase();
  //     return name.contains(lowerQuery) || code.contains(lowerQuery);
  //   }).toList();
  //
  //   notifyListeners();
  //
  //   return data;
  // }

  List<PurchaseRequisationListModel> _filteredRequisitions = [];

  List<PurchaseRequisationListModel> get filteredRequisitions => _filteredRequisitions;

  // Your existing getAllRequisitions method should populate _allRequisitions

  void filterRequisitions(String query) {
    if (query.isEmpty) {
      _filteredRequisitions = _requisitions;
    } else {
      _filteredRequisitions = _requisitions.where((requisition) {
        return (requisition.purchaseRequisitionCode ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (requisition.userName ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (requisition.productType ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (requisition.remarks ?? '').toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> acceptItem(PurchaseRequisationListModel code, String? remarks, bool isAccept) async {

    debugPrint('THIS IS CALLING ... ');
    debugPrint('Dept IS CALLING ... ${DashboardHelpers.currentUser!.department}');
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService.patchData('api/Inventory/AprvOrRejPurchaseReq', {'remarks': remarks, 'requisitionId': code.purchaseRequisitionId, 'isApprove': isAccept, 'status': getStatus(isAccept)});

    EasyLoading.dismiss();

    return data != null ? true : false;
  }

  PurchaseAnalyticsResponse? _purchaseAnalyticsResponse;
  PurchaseAnalyticsResponse? get purchaseAnalyticsResponse => _purchaseAnalyticsResponse;
  Future<void> getAllPurchaseDashboardInfo() async {
    setLoading(true);
    var data = await apiService.getData('api/Dashboard/PurchaseDashboard');
    setLoading(false);
    if (data != null) {
      _purchaseAnalyticsResponse = PurchaseAnalyticsResponse.fromJson(data['Data']);
    }
    notifyListeners();
  }

  //
  final List<PurchaseOrderModel> _purchaseList = [];
  List<PurchaseOrderModel> get purchaseList => _purchaseList;
  int _countPage = 0;
  int get coutPage => _countPage;
  // List<PurchaseOrderModel> _filteredRequisitionList = [];
  Future<void> getAllPurchaseList(String pageNo, String size) async {
    setLoading(true);
    var data = await apiService.getData('api/Inventory/PurchaseOrderList?pageNumber=$pageNo&pageSize=$size');
    setLoading(false);
    if (data != null) {
      _purchaseList.clear();
      for (var i in data['Data']['Items']) {
        _purchaseList.add(PurchaseOrderModel.fromJson(i));
      }
      _countPage = data['Data']['TotalCount'];

      debugPrint('_purchaseList ${_purchaseList.length}');
    }
    notifyListeners();
  }

  String getStatus(bool isAccept) {

    if (DashboardHelpers.currentUser!.department == '15') //Management
    {
      if (isAccept) {
        return PurchaseStatus.managementApproved;
      } else {
        return PurchaseStatus.managementRejected;
      }
    } else {
      if (isAccept) {
        if (DashboardHelpers.currentUser!.isDepartmentHead == true) {
          return PurchaseStatus.deptHeadApproved;
        } else {
          return PurchaseStatus.deptHeadRejected;
        }
      } else {
        // Add a default return when not accepted and not in management
        return PurchaseStatus.deptHeadRejected;
      }
    }
  }


  List<CsRequisationModel> _csRequisationList=[];
  List<CsRequisationModel> get  csRequisationList=>_csRequisationList;


  Future<bool> getSingleCSInfoByCode(String? purchaseRequisitionCode) async{
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    var data = await apiService
        .postFormData('api/inventory/GetReqWithCS', {
          "CSCode":purchaseRequisitionCode
    });
    EasyLoading.dismiss();

    if (data != null) {
      _csRequisationList.clear();
      for (var i in data['returnvalue']) {
        _csRequisationList.add(CsRequisationModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('_csRequisationList ${_csRequisationList.length}');
      return true;
    } else {
      return false;
    }
  }
}
