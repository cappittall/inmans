import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/models/instagram_account.model.dart';
import 'package:togetherearn/a1/instagramAccounts/server/server.dart';
import 'package:togetherearn/a1/server/values.dart';

class SpamServer {
  static Future spam({InstagramAccount account, String idToInteract}) async {
    String dsUserID = "2238287305";
    //ignore_for_file: unused_local_variable

    String firstData =
        'trigger_event_type=ig_report_button_clicked&trigger_session_id=$appDeviceID&ig_container_module=profile&entry_point=chevron_button&preloading_enabled=0&_uuid=$guID&ig_object_value=$idToInteract&ig_object_type=5&is_in_holdout=0&bk_client_context=%7B%22bloks_version%22%3A%22$bloksVersionID%22%2C%22styles_id%22%3A%22instagram%22%7D&bloks_versioning_id=$bloksVersionID&location=ig_profile';

    String firstURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.ig.ixt.triggers.bottom_sheet.ig_content/";

    var headersa = Server.createHeader(account, false);

    headersa["X-IG-Nav-Chain"] =
        "1nj:feed_timeline:2,UserDetailFragment:profile:3,ProfileMediaTabFragment:profile:4,616:empty_report_bottom_sheet_fragment:5";

    var firstResponse = await http.post(Uri.parse(firstURL),
        headers: headersa, body: firstData);
    if (firstResponse.statusCode != 200) {
      print("Error on first response");

      print(firstResponse.body);

      return "fail";
    }

    // Second request

    print("Sending second request");

    String secondData =
        "params=%7B%22client_input_params%22%3A%7B%22tags%22%3A%5B%22ig_report_account%22%5D%7D%2C%22server_params%22%3A%7B%22show_tag_search%22%3A0%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiNmM5ZWViMGEtZGMyMi00OGM5LWI0NTgtNTU5YzNjNGFjMTI2XCIsXCJ0YWdzXCI6W10sXCJvYmplY3RcIjpcIntcXFwidXNlcl9pZFxcXCI6XFxcIjIyMzgyODczMDVcXFwifVwiLFwicmVwb3J0ZXJfaWRcIjoxNzg0MTQ0ODg2MTMzODIyMCxcInJlc3BvbnNpYmxlX2lkXCI6MTc4NDE0MDIzNzkxNTk3ODUsXCJsb2NhbGVcIjpcInRyX1RSXCIsXCJhcHBfcGxhdGZvcm1cIjowLFwiZXh0cmFfZGF0YVwiOntcImNvbnRhaW5lcl9tb2R1bGVcIjpcInByb2ZpbGVcIixcImFwcF92ZXJzaW9uXCI6XCIxOTUuMC4wLjMxLjEyM1wiLFwiaXNfZGFya19tb2RlXCI6bnVsbCxcImFwcF9pZFwiOjU2NzA2NzM0MzM1MjQyNyxcInNlbnRyeV9mZWF0dXJlX21hcFwiOm51bGwsXCJzaG9wcGluZ19zZXNzaW9uX2lkXCI6bnVsbCxcImxvZ2dpbmdfZXh0cmFcIjpudWxsLFwiaXNfaW5faG9sZG91dFwiOmZhbHNlLFwicHJlbG9hZGluZ19lbmFibGVkXCI6ZmFsc2V9LFwiZnJ4X2ZlZWRiYWNrX3N1Ym1pdHRlZFwiOmZhbHNlLFwiYWRkaXRpb25hbF9kYXRhXCI6e319Iiwic2NyZWVuIjoiZnJ4X3RhZ19zZWxlY3Rpb25fc2NyZWVuIiwiZmxvd19pbmZvIjoie1wibnRcIjpudWxsLFwiZ3JhcGhxbFwiOm51bGwsXCJlbnJvbGxtZW50X2luZm9cIjpudWxsLFwiaWdcIjpcIntcXFwiaWdfY29udGFpbmVyX21vZHVsZVxcXCI6XFxcInByb2ZpbGVcXFwifVwiLFwic2Vzc2lvbl9pZFwiOlwiZGIxMjY0NjQtYWEzZS00MmZlLWFjY2UtZjA1MDQxOTNmNzJmXCJ9IiwicHJldmlvdXNfc3RhdGUiOm51bGx9%22%2C%22is_bloks%22%3A1%2C%22tag_source%22%3A%22tag_selection_screen%22%7D%7D&_uuid=$guID&bk_client_context=%7B%22bloks_version%22%3A%22$bloksVersionID%22%2C%22styles_id%22%3A%22instagram%22%7D&bloks_versioning_id=$bloksVersionID";
    String secondURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_tag_selection_screen/";
    var secondResponse = await http.post(Uri.parse(secondURL),
        headers: headersa, body: secondData);

    if (secondResponse.statusCode != 200) {
      print("Error on second response");
      print(secondResponse.body);
      return "fail";
    }

    // third request

    print("Sending third request");

    String thirdData =
        "params=%7B%22client_input_params%22%3A%7B%22tags%22%3A%5B%22ig_its_inappropriate%22%2C%22ig_report_account%22%5D%7D%2C%22server_params%22%3A%7B%22show_tag_search%22%3A0%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiNmM5ZWViMGEtZGMyMi00OGM5LWI0NTgtNTU5YzNjNGFjMTI2XCIsXCJ0YWdzXCI6W1wiaWdfcmVwb3J0X2FjY291bnRcIl0sXCJvYmplY3RcIjpcIntcXFwidXNlcl9pZFxcXCI6XFxcIjIyMzgyODczMDVcXFwifVwiLFwicmVwb3J0ZXJfaWRcIjoxNzg0MTQ0ODg2MTMzODIyMCxcInJlc3BvbnNpYmxlX2lkXCI6MTc4NDE0MDIzNzkxNTk3ODUsXCJsb2NhbGVcIjpcInRyX1RSXCIsXCJhcHBfcGxhdGZvcm1cIjowLFwiZXh0cmFfZGF0YVwiOntcImNvbnRhaW5lcl9tb2R1bGVcIjpcInByb2ZpbGVcIixcImFwcF92ZXJzaW9uXCI6XCIxOTUuMC4wLjMxLjEyM1wiLFwiaXNfZGFya19tb2RlXCI6bnVsbCxcImFwcF9pZFwiOjU2NzA2NzM0MzM1MjQyNyxcInNlbnRyeV9mZWF0dXJlX21hcFwiOm51bGwsXCJzaG9wcGluZ19zZXNzaW9uX2lkXCI6bnVsbCxcImxvZ2dpbmdfZXh0cmFcIjpudWxsLFwiaXNfaW5faG9sZG91dFwiOmZhbHNlLFwicHJlbG9hZGluZ19lbmFibGVkXCI6ZmFsc2V9LFwiZnJ4X2ZlZWRiYWNrX3N1Ym1pdHRlZFwiOmZhbHNlLFwiYWRkaXRpb25hbF9kYXRhXCI6e30sXCJ0YWdfc291cmNlXCI6XCJ0YWdfc2VsZWN0aW9uX3NjcmVlblwifSIsInNjcmVlbiI6ImZyeF90YWdfc2VsZWN0aW9uX3NjcmVlbiIsImZsb3dfaW5mbyI6IntcIm50XCI6bnVsbCxcImdyYXBocWxcIjpudWxsLFwiZW5yb2xsbWVudF9pbmZvXCI6bnVsbCxcImlnXCI6XCJ7XFxcImlnX2NvbnRhaW5lcl9tb2R1bGVcXFwiOlxcXCJwcm9maWxlXFxcIn1cIixcInNlc3Npb25faWRcIjpcImRiMTI2NDY0LWFhM2UtNDJmZS1hY2NlLWYwNTA0MTkzZjcyZlwifSIsInByZXZpb3VzX3N0YXRlIjpudWxsfQ%3D%3D%22%2C%22is_bloks%22%3A1%2C%22tag_source%22%3A%22tag_selection_screen%22%7D%7D&_uuid=$guID&bk_client_context=%7B%22bloks_version%22%3A%22$bloksVersionID%22%2C%22styles_id%22%3A%22instagram%22%7D&bloks_versioning_id=$bloksVersionID";
    String thirdURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_tag_selection_screen/";

    var thirdResponse = await http.post(Uri.parse(thirdURL),
        headers: headersa, body: thirdData);

    if (thirdResponse.statusCode != 200) {
      print("Error on third response");
      print(thirdResponse.body);
      return "fail";
    }

    // forth response

    print("Sending forth request");

    String forthData =
        "params=%7B%22client_input_params%22%3A%7B%22tags%22%3A%5B%22ig_spam_v3%22%2C%22ig_report_account%22%2C%22ig_its_inappropriate%22%5D%7D%2C%22server_params%22%3A%7B%22show_tag_search%22%3A0%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiNmM5ZWViMGEtZGMyMi00OGM5LWI0NTgtNTU5YzNjNGFjMTI2XCIsXCJ0YWdzXCI6W1wiaWdfcmVwb3J0X2FjY291bnRcIixcImlnX2l0c19pbmFwcHJvcHJpYXRlXCJdLFwib2JqZWN0XCI6XCJ7XFxcInVzZXJfaWRcXFwiOlxcXCIyMjM4Mjg3MzA1XFxcIn1cIixcInJlcG9ydGVyX2lkXCI6MTc4NDE0NDg4NjEzMzgyMjAsXCJyZXNwb25zaWJsZV9pZFwiOjE3ODQxNDAyMzc5MTU5Nzg1LFwibG9jYWxlXCI6XCJ0cl9UUlwiLFwiYXBwX3BsYXRmb3JtXCI6MCxcImV4dHJhX2RhdGFcIjp7XCJjb250YWluZXJfbW9kdWxlXCI6XCJwcm9maWxlXCIsXCJhcHBfdmVyc2lvblwiOlwiMTk1LjAuMC4zMS4xMjNcIixcImlzX2RhcmtfbW9kZVwiOm51bGwsXCJhcHBfaWRcIjo1NjcwNjczNDMzNTI0MjcsXCJzZW50cnlfZmVhdHVyZV9tYXBcIjpudWxsLFwic2hvcHBpbmdfc2Vzc2lvbl9pZFwiOm51bGwsXCJsb2dnaW5nX2V4dHJhXCI6bnVsbCxcImlzX2luX2hvbGRvdXRcIjpmYWxzZSxcInByZWxvYWRpbmdfZW5hYmxlZFwiOmZhbHNlfSxcImZyeF9mZWVkYmFja19zdWJtaXR0ZWRcIjpmYWxzZSxcImFkZGl0aW9uYWxfZGF0YVwiOnt9LFwidGFnX3NvdXJjZVwiOlwidGFnX3NlbGVjdGlvbl9zY3JlZW5cIn0iLCJzY3JlZW4iOiJmcnhfdGFnX3NlbGVjdGlvbl9zY3JlZW4iLCJmbG93X2luZm8iOiJ7XCJudFwiOm51bGwsXCJncmFwaHFsXCI6bnVsbCxcImVucm9sbG1lbnRfaW5mb1wiOm51bGwsXCJpZ1wiOlwie1xcXCJpZ19jb250YWluZXJfbW9kdWxlXFxcIjpcXFwicHJvZmlsZVxcXCJ9XCIsXCJzZXNzaW9uX2lkXCI6XCJkYjEyNjQ2NC1hYTNlLTQyZmUtYWNjZS1mMDUwNDE5M2Y3MmZcIn0iLCJwcmV2aW91c19zdGF0ZSI6bnVsbH0%3D%22%2C%22is_bloks%22%3A1%2C%22tag_source%22%3A%22tag_selection_screen%22%7D%7D&_uuid=$guID&bk_client_context=%7B%22bloks_version%22%3A%22$bloksVersionID%22%2C%22styles_id%22%3A%22instagram%22%7D&bloks_versioning_id=$bloksVersionID";
    String forthURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_tag_selection_screen/";

    var forthResponse = await http.post(Uri.parse(forthURL),
        headers: headersa, body: forthData);

    if (forthResponse.statusCode != 200) {
      print("Error on forth response");
      print(forthResponse.body);
      return "fail";
    }

    return "success";
  }

  static Future suicideSpam(
      {InstagramAccount account, String idToInteract}) async {
    String firstData =
        'trigger_event_type=ig_report_button_clicked&trigger_session_id=$appDeviceID&ig_container_module=profile&entry_point=chevron_button&preloading_enabled=0&_uuid=$guID&ig_object_value=$idToInteract&ig_object_type=5&is_in_holdout=0&bk_client_context=%7B%22bloks_version%22%3A%22$bloksVersionID%22%2C%22styles_id%22%3A%22instagram%22%7D&bloks_versioning_id=$bloksVersionID&location=ig_profile';

    String firstURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.ig.ixt.triggers.bottom_sheet.ig_content/";

    var headersa = Server.createHeader(account, false);

    headersa["X-IG-Nav-Chain"] =
        "1nj:feed_timeline:2,UserDetailFragment:profile:3,ProfileMediaTabFragment:profile:4,TRUNCATEDx1,9L3:bloks-bottomsheet-:6,9L3:bloks-bottomsheet-:7,9L3:bloks-bottomsheet-:8,9L3:bloks-bottomsheet-:9,9L3:bloks-bottomsheet-:10,ProfileMediaTabFragment:profile:11,616:empty_report_bottom_sheet_fragment:12";
    print("Sending first request");
    var firstResponse = await http.post(Uri.parse(firstURL),
        headers: headersa, body: firstData);
    if (firstResponse.statusCode != 200) {
      print("Error on first response");

      print(firstResponse.body);

      return "fail";
    }

    // Second request

    print("Sending second request");

    String constant =
        "_uuid=$guID&bk_client_context=%7B%22bloks_version%22%3A%22$bloksVersionID%22%2C%22styles_id%22%3A%22instagram%22%7D&bloks_versioning_id=$bloksVersionID";

    String secondData =
        "params=%7B%22client_input_params%22%3A%7B%22tags%22%3A%5B%22ig_report_account%22%5D%7D%2C%22server_params%22%3A%7B%22show_tag_search%22%3A0%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiZDY0ZjRiYTQtZTQ3OC00ZWRjLWFmY2MtYjZiNzQzNGY0NjI2XCIsXCJ0YWdzXCI6W10sXCJvYmplY3RcIjpcIntcXFwidXNlcl9pZFxcXCI6XFxcIjIyMzgyODczMDVcXFwifVwiLFwicmVwb3J0ZXJfaWRcIjoxNzg0MTQ0ODg2MTMzODIyMCxcInJlc3BvbnNpYmxlX2lkXCI6MTc4NDE0MDIzNzkxNTk3ODUsXCJsb2NhbGVcIjpcInRyX1RSXCIsXCJhcHBfcGxhdGZvcm1cIjowLFwiZXh0cmFfZGF0YVwiOntcImNvbnRhaW5lcl9tb2R1bGVcIjpcInByb2ZpbGVcIixcImFwcF92ZXJzaW9uXCI6XCIxOTUuMC4wLjMxLjEyM1wiLFwiaXNfZGFya19tb2RlXCI6bnVsbCxcImFwcF9pZFwiOjU2NzA2NzM0MzM1MjQyNyxcInNlbnRyeV9mZWF0dXJlX21hcFwiOm51bGwsXCJzaG9wcGluZ19zZXNzaW9uX2lkXCI6bnVsbCxcImxvZ2dpbmdfZXh0cmFcIjpudWxsLFwiaXNfaW5faG9sZG91dFwiOmZhbHNlLFwicHJlbG9hZGluZ19lbmFibGVkXCI6ZmFsc2V9LFwiZnJ4X2ZlZWRiYWNrX3N1Ym1pdHRlZFwiOmZhbHNlLFwiYWRkaXRpb25hbF9kYXRhXCI6e319Iiwic2NyZWVuIjoiZnJ4X3RhZ19zZWxlY3Rpb25fc2NyZWVuIiwiZmxvd19pbmZvIjoie1wibnRcIjpudWxsLFwiZ3JhcGhxbFwiOm51bGwsXCJlbnJvbGxtZW50X2luZm9cIjpudWxsLFwiaWdcIjpcIntcXFwiaWdfY29udGFpbmVyX21vZHVsZVxcXCI6XFxcInByb2ZpbGVcXFwifVwiLFwic2Vzc2lvbl9pZFwiOlwiN2ZhYWFhMjQtMGVlNC00ODg4LWFmYWQtNTQ0MzEyNzZkMTg5XCJ9IiwicHJldmlvdXNfc3RhdGUiOm51bGx9%22%2C%22is_bloks%22%3A1%2C%22tag_source%22%3A%22tag_selection_screen%22%7D%7D&" +
            constant;
    String secondURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_tag_selection_screen/";
    var secondResponse = await http.post(Uri.parse(secondURL),
        headers: headersa, body: secondData);

    if (secondResponse.statusCode != 200) {
      print("Error on second response");
      print(secondResponse.body);
      return "fail";
    }

    // third request

    print("Sending third request");

    String thirdData =
        "params=%7B%22client_input_params%22%3A%7B%22tags%22%3A%5B%22ig_its_inappropriate%22%2C%22ig_report_account%22%5D%7D%2C%22server_params%22%3A%7B%22show_tag_search%22%3A0%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiZDY0ZjRiYTQtZTQ3OC00ZWRjLWFmY2MtYjZiNzQzNGY0NjI2XCIsXCJ0YWdzXCI6W1wiaWdfcmVwb3J0X2FjY291bnRcIl0sXCJvYmplY3RcIjpcIntcXFwidXNlcl9pZFxcXCI6XFxcIjIyMzgyODczMDVcXFwifVwiLFwicmVwb3J0ZXJfaWRcIjoxNzg0MTQ0ODg2MTMzODIyMCxcInJlc3BvbnNpYmxlX2lkXCI6MTc4NDE0MDIzNzkxNTk3ODUsXCJsb2NhbGVcIjpcInRyX1RSXCIsXCJhcHBfcGxhdGZvcm1cIjowLFwiZXh0cmFfZGF0YVwiOntcImNvbnRhaW5lcl9tb2R1bGVcIjpcInByb2ZpbGVcIixcImFwcF92ZXJzaW9uXCI6XCIxOTUuMC4wLjMxLjEyM1wiLFwiaXNfZGFya19tb2RlXCI6bnVsbCxcImFwcF9pZFwiOjU2NzA2NzM0MzM1MjQyNyxcInNlbnRyeV9mZWF0dXJlX21hcFwiOm51bGwsXCJzaG9wcGluZ19zZXNzaW9uX2lkXCI6bnVsbCxcImxvZ2dpbmdfZXh0cmFcIjpudWxsLFwiaXNfaW5faG9sZG91dFwiOmZhbHNlLFwicHJlbG9hZGluZ19lbmFibGVkXCI6ZmFsc2V9LFwiZnJ4X2ZlZWRiYWNrX3N1Ym1pdHRlZFwiOmZhbHNlLFwiYWRkaXRpb25hbF9kYXRhXCI6e30sXCJ0YWdfc291cmNlXCI6XCJ0YWdfc2VsZWN0aW9uX3NjcmVlblwifSIsInNjcmVlbiI6ImZyeF90YWdfc2VsZWN0aW9uX3NjcmVlbiIsImZsb3dfaW5mbyI6IntcIm50XCI6bnVsbCxcImdyYXBocWxcIjpudWxsLFwiZW5yb2xsbWVudF9pbmZvXCI6bnVsbCxcImlnXCI6XCJ7XFxcImlnX2NvbnRhaW5lcl9tb2R1bGVcXFwiOlxcXCJwcm9maWxlXFxcIn1cIixcInNlc3Npb25faWRcIjpcIjdmYWFhYTI0LTBlZTQtNDg4OC1hZmFkLTU0NDMxMjc2ZDE4OVwifSIsInByZXZpb3VzX3N0YXRlIjpudWxsfQ%3D%3D%22%2C%22is_bloks%22%3A1%2C%22tag_source%22%3A%22tag_selection_screen%22%7D%7D&" +
            constant;
    String thirdURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_tag_selection_screen/";

    var thirdResponse = await http.post(Uri.parse(thirdURL),
        headers: headersa, body: thirdData);

    if (thirdResponse.statusCode != 200) {
      print("Error on third response");
      print(thirdResponse.body);
      return "fail";
    }

    // forth response

    print("Sending forth request");

    String forthData =
        '''params=%7B%22client_input_params%22%3A%7B%22tags%22%3A%5B%22ig_self_injury_v3%22%2C%22ig_report_account%22%2C%22ig_its_inappropriate%22%5D%7D%2C%22server_params%22%3A%7B%22show_tag_search%22%3A0%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiZDY0ZjRiYTQtZTQ3OC00ZWRjLWFmY2MtYjZiNzQzNGY0NjI2XCIsXCJ0YWdzXCI6W1wiaWdfcmVwb3J0X2FjY291bnRcIixcImlnX2l0c19pbmFwcHJvcHJpYXRlXCJdLFwib2JqZWN0XCI6XCJ7XFxcInVzZXJfaWRcXFwiOlxcXCIyMjM4Mjg3MzA1XFxcIn1cIixcInJlcG9ydGVyX2lkXCI6MTc4NDE0NDg4NjEzMzgyMjAsXCJyZXNwb25zaWJsZV9pZFwiOjE3ODQxNDAyMzc5MTU5Nzg1LFwibG9jYWxlXCI6XCJ0cl9UUlwiLFwiYXBwX3BsYXRmb3JtXCI6MCxcImV4dHJhX2RhdGFcIjp7XCJjb250YWluZXJfbW9kdWxlXCI6XCJwcm9maWxlXCIsXCJhcHBfdmVyc2lvblwiOlwiMTk1LjAuMC4zMS4xMjNcIixcImlzX2RhcmtfbW9kZVwiOm51bGwsXCJhcHBfaWRcIjo1NjcwNjczNDMzNTI0MjcsXCJzZW50cnlfZmVhdHVyZV9tYXBcIjpudWxsLFwic2hvcHBpbmdfc2Vzc2lvbl9pZFwiOm51bGwsXCJsb2dnaW5nX2V4dHJhXCI6bnVsbCxcImlzX2luX2hvbGRvdXRcIjpmYWxzZSxcInByZWxvYWRpbmdfZW5hYmxlZFwiOmZhbHNlfSxcImZyeF9mZWVkYmFja19zdWJtaXR0ZWRcIjpmYWxzZSxcImFkZGl0aW9uYWxfZGF0YVwiOnt9LFwidGFnX3NvdXJjZVwiOlwidGFnX3NlbGVjdGlvbl9zY3JlZW5cIn0iLCJzY3JlZW4iOiJmcnhfdGFnX3NlbGVjdGlvbl9zY3JlZW4iLCJmbG93X2luZm8iOiJ7XCJudFwiOm51bGwsXCJncmFwaHFsXCI6bnVsbCxcImVucm9sbG1lbnRfaW5mb1wiOm51bGwsXCJpZ1wiOlwie1xcXCJpZ19jb250YWluZXJfbW9kdWxlXFxcIjpcXFwicHJvZmlsZVxcXCJ9XCIsXCJzZXNzaW9uX2lkXCI6XCI3ZmFhYWEyNC0wZWU0LTQ4ODgtYWZhZC01NDQzMTI3NmQxODlcIn0iLCJwcmV2aW91c19zdGF0ZSI6bnVsbH0%3D%22%2C%22is_bloks%22%3A1%2C%22tag_source%22%3A%22tag_selection_screen%22%7D%7D&''' +
            constant;
    String forthURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_tag_selection_screen/";

    var request = http.Request("POST", Uri.parse(forthURL));

    request.headers.addAll(headersa);
    request.body = forthData;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("completed");
      print(await response.stream.bytesToString());
    } else {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
    }

    return;

    var forthResponse = await http.post(Uri.parse(forthURL),
        headers: headersa, body: forthData);

    if (forthResponse.statusCode != 200) {
      print("Error on forth response");
      print(forthResponse.statusCode);
      print(forthResponse.body);
      return "fail";
    }

    print("Sending fifth request");
    String fifthData =
        "params=%7B%22server_params%22%3A%7B%22selected_option%22%3A%22report%22%2C%22serialized_state%22%3A%22eyJzY2hlbWEiOiJpZ19mcngiLCJzZXNzaW9uIjoie1wibG9jYXRpb25cIjpcImlnX3Byb2ZpbGVcIixcImVudHJ5X3BvaW50XCI6XCJjaGV2cm9uX2J1dHRvblwiLFwic2Vzc2lvbl9pZFwiOlwiZDY0ZjRiYTQtZTQ3OC00ZWRjLWFmY2MtYjZiNzQzNGY0NjI2XCIsXCJ0YWdzXCI6W1wiaWdfcmVwb3J0X2FjY291bnRcIixcImlnX2l0c19pbmFwcHJvcHJpYXRlXCIsXCJpZ19zZWxmX2luanVyeV92M1wiXSxcIm9iamVjdFwiOlwie1xcXCJ1c2VyX2lkXFxcIjpcXFwiMjIzODI4NzMwNVxcXCJ9XCIsXCJyZXBvcnRlcl9pZFwiOjE3ODQxNDQ4ODYxMzM4MjIwLFwicmVzcG9uc2libGVfaWRcIjoxNzg0MTQwMjM3OTE1OTc4NSxcImxvY2FsZVwiOlwidHJfVFJcIixcImFwcF9wbGF0Zm9ybVwiOjAsXCJleHRyYV9kYXRhXCI6e1wiY29udGFpbmVyX21vZHVsZVwiOlwicHJvZmlsZVwiLFwiYXBwX3ZlcnNpb25cIjpcIjE5NS4wLjAuMzEuMTIzXCIsXCJpc19kYXJrX21vZGVcIjpudWxsLFwiYXBwX2lkXCI6NTY3MDY3MzQzMzUyNDI3LFwic2VudHJ5X2ZlYXR1cmVfbWFwXCI6bnVsbCxcInNob3BwaW5nX3Nlc3Npb25faWRcIjpudWxsLFwibG9nZ2luZ19leHRyYVwiOm51bGwsXCJpc19pbl9ob2xkb3V0XCI6ZmFsc2UsXCJwcmVsb2FkaW5nX2VuYWJsZWRcIjpmYWxzZX0sXCJmcnhfZmVlZGJhY2tfc3VibWl0dGVkXCI6ZmFsc2UsXCJhZGRpdGlvbmFsX2RhdGFcIjp7fSxcInRhZ19zb3VyY2VcIjpcInRhZ19zZWxlY3Rpb25fc2NyZWVuXCJ9Iiwic2NyZWVuIjoiZnJ4X3BvbGljeV9lZHVjYXRpb24iLCJmbG93X2luZm8iOiJ7XCJudFwiOm51bGwsXCJncmFwaHFsXCI6bnVsbCxcImVucm9sbG1lbnRfaW5mb1wiOm51bGwsXCJpZ1wiOlwie1xcXCJpZ19jb250YWluZXJfbW9kdWxlXFxcIjpcXFwicHJvZmlsZVxcXCJ9XCIsXCJzZXNzaW9uX2lkXCI6XCI3ZmFhYWEyNC0wZWU0LTQ4ODgtYWZhZC01NDQzMTI3NmQxODlcIn0iLCJwcmV2aW91c19zdGF0ZSI6bnVsbH0%3D%22%7D%7D&" +
            constant;

    String fifthURL =
        "https://i.instagram.com/api/v1/bloks/apps/com.bloks.www.instagram_bloks_bottom_sheet.ixt.screen.frx_policy_education/";
    var fifthResponse = await http.post(Uri.parse(fifthURL),
        headers: headersa, body: fifthData);

    if (fifthResponse.statusCode != 200) {
      print("Error on fifth response");
      print(fifthResponse.body);
      return "fail";
    }

    return "success";
  }
}
