import 'package:get/get.dart';

class DisclaimerController extends GetxController{
  var tabs = 1.obs;
  var currentTab = 1.obs;

  increaseTabs()=>tabs++;

  increasecTabs(tab)=>currentTab.value = tab;
}