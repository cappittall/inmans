import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/a1/instagramAccounts/globals.dart';
import 'package:inmans/a1/localization/strings.dart';

LanguageController languageController = LanguageController();

class LanguageController with ChangeNotifier {
  static Locale locale;

  List<String> supportedLocalCodes = ['en', 'tr'];

  static String stringsJson = "";

  void initialize() async {
    interactionStrings.forEach((key, value) async {
      Map<String, String> values = _localizedValues[key];
      values.addAll(value);
    });
  }

  LanguageController() {
    String localeCode = "tr";

    final String defaultLocale = Platform.localeName.split("_").first;

    if (supportedLocalCodes.contains(defaultLocale)) {
      localeCode = defaultLocale;
    } else {
      localeCode = 'tr';
    }

    if (localDataBox.containsKey('langCode')) {
      locale = Locale(localDataBox.get('langCode'));
    } else {
      localDataBox.put('langCode', localeCode);
      locale = Locale(localeCode);
    }
  }

  void getStrings() async {
    stringsJson =
        await rootBundle.loadString('language_controller/strings.json');
  }

  static LanguageController of(BuildContext context) {
    return Localizations.of<LanguageController>(context, LanguageController);
  }

  void changeLocale(String langCode) {
    locale = Locale(langCode);
    localDataBox.put('langCode', langCode);
    DataBaseManager.updateLangCode(langCode);
    notifyListeners();
  }

  String getLocale() {
    return locale.languageCode;
  }

  static final Map<String, dynamic> _localizedValues = {
    "tr": {
      "email": "email",
      "password": "şifre",
      "passwordConfirm": "şifre tekrar",
      "login": "Giriş",
      "logout": "Çıkış",
      "register": "Kaydol.",
      "noAccount?": "Hesabın yok mu?",
      "privacyPolicy": "Gizlilik Politikası",
      "forgotPassword?": "Şifreni mi unuttun?",
      "phone": "Telefon",
      "termsOfUse": "Kullanım sözleşmesini",
      "IAccept": "kabul ediyorum",
      "balance": "Kazanç",
      "addInstaAccount": "Hesap ekle",
      "username": "Kullanıcı adı",
      "add": "Ekle",
      "instaAccounts": "İnstagram hesaplarım",
      "products": "Ürünler",
      "account": "Hesap",
      "earningTable": "Kazanç tablosu",
      "penalties": "Cezalar",
      "settings": "Ayarlar",
      "mostEarnings": "En çok kazananlar",
      "name": "İsim",
      "lastName": "Soyisim",
      "birth_date": "Doğum tarihi",
      "basicInfo": "Temel bilgiler",
      "paymentInfo": "Ödeme bilgileri",
      "iban": "IBAN",
      "bank": "Banka",
      "save": "Kaydet",
      "appLanguage": "Uygulama dili",
      "moneyUnit": "Para birimi",
      "tr": "Türkçe",
      "en": "İngilizce",
      "fl": "Flemenkçe",
      "addInstagramAccountToStart":
          "Kazanmaya başlamak için bir instagram hesabı bağla",
      "termsShouldBeAccepted": "Kullanım koşullarını kabul etmediniz!",
      "passwordsNotEqual": "Şifreler eşleşmiyor!",
      "somethingWentWrong": "Bir şeyler ters gitti!",
      "fieldsEmpty": "Bilgiler boş bırakılamaz",
      "wrongPassword": "Şifre yanlış",
      "userNotFound": "Kullanıcı bulunamadı",
      "logOut": "Çıkış yap",
      "resetPassword": "Şifre sıfırla",
      "enterMailForReset":
          "Şifresini sıfırlamak istediğin hesabın mailini gir. Eğer böyle bir hesap varsa şifre sıfırlama bağlantısını göndereceğiz.",
      "send": "Gönder",
      "passwordResetSent": "Şifre sıfırlama bağlantısı gönderildi.",
      "invalidIBAN": "Geçersiz IBAN",
      "instaAccountAdded": "Instagram hesabı eklendi",
      "instaAccountAdFail": "Instagram hesabı eklenemedi.",
      "quantity": "Miktar",
      "price": "Tutar",
      "invalidQuantity": "Geçersiz miktar",
      "buy": "Satın al",
      "insufficientBalance": "Yetersiz bakiye!",
      "operationSuccess": "İşlem başarılı!",
      "operationHistory": "İşlem Geçmişi",
      "last10OP": "Son 10 işlem",
      "deposit": "Bakiye yükle",
      "buy-follow": "Takipçi satın alma",
      "amount": "Miktar",
      "invalidDepositAmount": "Geçersiz miktar (en az 10₺)",
      "remainingBalance": "Kalan bakiye",
      "withdraw": "Ödeme",
      "requestWithdraw": "Ödeme talep et",
      "invalidWithdrawAmount": "Geçersiz miktar (min 100₺)",
      "earning": "Kazanç",
      "mediaLink": "Medya linki",
      "invalidLink": "Geçersiz link",
      "noBroadcast": "Hesaba ait canlı yayın bulunamadı",
      "unfollowPenalty": "{username} hesabını takipten çıkardın.",
      "likePenalty": "{username} kullanıcısından beğeniyi geri aldın.",
      "commentPenalty": "{username} kullanıcısından yorumunu sildin.",
      "penaltyCount": "Ceza sayısı",
      "noPenalty": "Hiç cezan yok!",
      "reason": "Sebep",
      "newPenalty": "Bir ceza aldın!",
      "actionRequired": "İşlem gerekli",
      "actionRequiredAccount":
          r"'{username}' için tekrar giriş yapman gerekiyor.",
      "buy-liveLike": "Canlı yayın beğeni satın alımı",
      "winMoreWithLocation":
          "Daha çok kazanmak için konum izni vermelisin. (İzin verdiysen uygulamayı yeniden başlat.)",
      "selectGender": "Cinsiyet seç",
      "Kadın": "Kadın",
      "Erkek": "Erkek",
      "Both": "Her ikisi",
      "selectLocations": "Konumları belirle",
      "leaveLocationsEmpty": "Her bölgeden etkileşim istiyorsan boş bırak.",
      "searchLocations": "Konum ara",
      "challengeRequired": "{username} hesabı için işlem gerekli",
      "challengeRequiredDetail":
          "Bu hesap için acilen tekrar instagram uygulaması üzerinden işlemleri yapıp daha sonra uygulamamıza tekrar giriş yapman gerekiyor.",
      "withFollower": "{follower} takipçisi olanlar",
      "emailExists": "Bu emaille kayıtlı bir hesap zaten var.",
      "enterCommentTexts": "Yorumları alt alta giriniz.",
      "enterDMText": "Mesajları alt alta giriniz",
      "enterUserText": "Kullanıcı adlarını alt alta giriniz",
      "messageEmptyWarn": "Mesaj boş bırakılamaz.",
      "usernameEmptyWarn": "Kullanıcı adı boş bırakılamaz",
      "justAddOpenAccounts":
          "Sadece Instagram uygulamanızda açık olan hesapları ekleyebilirsiniz.",
      "total": "Toplam",
      "commission": "Komisyon",
      "fee": "Vergi",
      "youGet": "Alacağınız",
      "locations": "Konumlar",
      "userCount": "Kullanıcı sayısı",
      "updateRequired": "Güncelleme gerekli!",
      "updateAppToUse":
          "Uygulamayı kullanmaya devam etmek için uygulamayı güncellemeniz gerekmektedir.",
      "update": "Güncelle",
      "bills": "Faturalarım",
      "amountB": "Tutar: ",
      "opID": "İşlem ID: ",
      "date": "Tarih: ",
      "touchToSeeBill": "Detayını görmek istediğiniz faturaya dokunun.",
      "billNotReady": "Faturanız henüz hazır değil",
      "noBill": "Hiç faturan yok",
      "enterPhoneNumber": "Telefon numaranızı girin.",
      "phoneCannotBeEmpty": "Telefon no boş bırakılamaz",
      "verificationSuccess": "Doğrulama başarılı!",
      "invalidCode": "Geçersiz kod",
      "invalidPhone": "Geçersiz telefon numarası",
      "enterCode": "Doğrulama kodunu girin.",
      "code": "Kod",
      "verify": "Doğrula",
      "verificationRequired": "Doğrulama gerekli!",
      "verificationDescription":
          "Yapılan işlemlerin güvenliği için telefon doğrulaması gerekli. Telefon numaranı güvenlik sorunu olmadığı sürece kullanmayacağız.",
      "verificationEmailSent": "Email doğrulaması gönderildi.",
      "continue": "Devam et",
      "check": "Kontrol et",
      "penaltyWarn":
          "Eğer bizim yaptığımız takip,beğeni vb. işlemleri geri çekerseniz, ödeme talep etme durumunda sistem bu kontrolleri yapacak ve eğer böyle bir işlem yapılmadıysa ödemeniz hesabınıza yatırılacaktır.",
      "checkPaymentInfo":
          "Ödeme talep etmeden önce 'hesap' sayfasından ödeme bilgilerinizi kontrol ediniz",
      "nameShouldBeSame":
          "Hesap sahibi ismi ile temel bilgiler kısmındaki isim aynı olmalı",
      "tcRequired": "Ödeme talebi için TC No Bilgisi gereklidir.",
      "checkPaymentInfoWarn": "Ödeme bilgilerinizi kontrol edin!",
      "interaction": "Etkileşim",
      "gotWithdrawRequest": "Ödeme talebini aldık.",
      "gotWithdrawRequestError": "Ödeme talebini daha önce aldık.",
      "minWithdraw":"Minimum ödeme tutarı 50\$'dir.",
      "invalidQuantityLocation":
          "En fazla seçilen konumlardaki toplam kişi sayısı veya toplam kullanıcı sayısı kadar etkileşim satın alabilirsin",
      "phoneVRequired":
          "Ödeme talebi için doğrulanmış bir telefon numarası gerekir.",
      "starredFields": "*Yıldızlı alanlar zorunludur.",
      "nosucces": "İşlem başarısız",
      "attention":"Dikkat!",
      "areyousure":"Silmek istediğinizden eminmisiniz? ",
      "yes":"Evet",
      "no":"Hayır",
      "notSignedIn":"Giriş yapmadınız",
      "signIn":"Giris yap",
      "challenge_required": "Lütfen belirtilen instagram hesabınızı silip tekrar ekleyiniz. : ",
      "backroundmessage": "Şuan kazanmaya devam ediyorsunuz. çünkü instagram hesaplarınız aktif ve uygulamanız arka planda çalışıyor."

    },
    "en": {
      "email": "email",
      "password": "password",
      "passwordConfirm": "Confirm password",
      "login": "Login",
      "logout": "Lougout",
      "register": "Register",
      "noAccount?": "Do not have account?",
      "privacyPolicy": "Privacy Policy",
      "forgotPassword?": "Forgot password?",
      "phone": "Phone",
      "termsOfUse": "Terms of use",
      "IAccept": "Accept",
      "balance": "Earnings",
      "addInstaAccount": "Add account",
      "username": "Username",
      "add": "Add",
      "instaAccounts": "Instagram accounts",
      "products": "Products",
      "account": "Account",
      "earningTable": "Earning table",
      "penalties": "Penalties",
      "settings": "Settings",
      "mostEarnings": "Most earners",
      "name": "Name",
      "lastName": "Last name",
      "birth_date": "Birth date",
      "basicInfo": "Basic info",
      "paymentInfo": "Payment info",
      "iban": "IBAN",
      "bank": "Bank",
      "save": "Save",
      "appLanguage": "App language",
      "moneyUnit": "Money unit",
      "tr": "Turkish",
      "en": "English",
      "fl": "Dutch",
      "addInstagramAccountToStart": "Add instagram account to start earning.",
      "termsShouldBeAccepted": "You did not accept the terms of use",
      "passwordsNotEqual": "Passwords does not match",
      "somethingWentWrong": "Something went wrong!",
      "fieldsEmpty": "Fields cannot be empty",
      "wrongPassword": "Wrong password",
      "userNotFound": "User not found",
      "logOut": "Logout",
      "resetPassword": "Reset password",
      "enterMailForReset":
          "Enter the mail for your account. If it exists we will send mail to there.",
      "send": "Send",
      "passwordResetSent": "Password reset link sent.",
      "invalidIBAN": "invalid IBAN",
      "instaAccountAdded": "Instagram account added",
      "instaAccountAdFail": "Instagram account cannot added.",
      "quantity": "Quantity",
      "price": "Price",
      "invalidQuantity": "Invalid quantity",
      "buy": "Buy",
      "insufficientBalance": "Insufficient balance",
      "operationSuccess": "Operation success!",
      "operationHistory": "Operation history",
      "last10OP": "Last 10 operation",
      "deposit": "Deposit",
      "buy-follow": "Buy follower",
      "amount": "Amount",
      "invalidDepositAmount": "Invalid amount (min 10₺)",
      "remainingBalance": "Remaining balance",
      "withdraw": "Withdraw",
      "requestWithdraw": "Request withdraw",
      "invalidWithdrawAmount": "Invalid amount (min 100₺)",
      "earning": "Earning",
      "mediaLink": "Media link",
      "invalidLink": "Invalid link",
      "noBroadcast": "Live broadcast not found in this account",
      "unfollowPenalty": "You unfollowed {username}.",
      "likePenalty": "You unliked post from {username}.",
      "commentPenalty": "You deleted your comment from {username}.",
      "penaltyCount": "Penalty count",
      "noPenalty": "You do not have any penalties!",
      "reason": "Reason",
      "newPenalty": "You got penalty!",
      "actionRequired": "Action required",
      "actionRequiredAccount": r"Relogin required for '{username}'",
      "buy-liveLike": "Buy live like",
      "winMoreWithLocation":
          "You should give location permission to win more. (Restart the app if you did.)",
      "selectGender": "Select gender",
      "Kadın": "Women",
      "Erkek": "Man",
      "Both": "Both",
      "selectLocations": "Select locations",
      "leaveLocationsEmpty":
          "Leave empty if you want interaction from all regions.",
      "searchLocations": "Search locations",
      "challengeRequired": "Challenle required for account {username}",
      "challengeRequiredDetail":
          "Operate challenges from instagram app for this account and re-login to our app ASAP.",
      "withFollower": "has {follower} followers",
      "emailExists": "User exists with this email.",
      "enterCommentTexts": "Enter comments line by line",
      "enterDMText": "Enter dms line by line",
      "enterUserText": "Enter usernames line by line",
      "messageEmptyWarn": "DM cannot be empty",
      "usernameEmptyWarn": "username cannot be empty",
      "justAddOpenAccounts":
          "You can just add accounts that logged in the Instagram app.",
      "total": "Total",
      "commission": "Commission",
      "fee": "Fee",
      "youGet": "You get",
      "locations": "Locations",
      "userCount": "User number",
      "updateRequired": "Update required",
      "updateAppToUse": "Update app to continue using our services",
      "update": "Update",
      "bills": "Bills",
      "amountB": "Amount: ",
      "opID": "ID: ",
      "date": "Date: ",
      "touchToSeeBill": "Touch bill you want to see details.",
      "billNotReady": "Bill not ready yet.",
      "noBill": "You do not have any bill.",
      "enterPhoneNumber": "Enter phone number",
      "phoneCannotBeEmpty": "Phone number cannot be empty",
      "verificationSuccess": "Verification successfull!",
      "invalidCode": "Invalid OTP",
      "invalidPhone": "Invalid phone number",
      "enterCode": "Enter OTP",
      "code": "OTP",
      "verify": "Verify",
      "verificationRequired": "Verification required!",
      "verificationDescription":
          "Phone number verification is required for operation security. We will not use your phone number unless there is a security consern.",
      "verificationEmailSent": "Email verification sent",
      "continue": "Continue",
      "check": "Check",
      "penaltyWarn":
          "If you did not take back any of the operations we make like follow, like etc... our system will check it and your payment will be sent your account.",
      "checkPaymentInfo":
          "Check your payment infor from 'account' page before you request withdraw",
      "nameShouldBeSame":
          "Account owner name and, name in the basic info should be the same.",
      "tcRequired": "TC no is required to request withdraw",
      "checkPaymentInfoWarn": "Check your payment info!",
      "interaction": "Interaction",
      "gotWithdrawRequest": "We got your withdraw request.",
      "gotWithdrawRequestError": "We got your withdraw request already.",
      "minWithdraw":"Minimum withdraw amount is \$50.00",
      "invalidQuantityLocation":
          "You can buy interaction total of locations you selected or total users",
      "phoneVRequired": "Verified phone number is required to request withdraw",
      "starredFields": "*Starred fields are required.",
      "nosucces": "Operation failed",
      "attantion":"Attention! ",
      "areyousure":"Are you sure to delete item? ",
      "yes":"Yes",
      "no":"No",
      "notSignedIn":"You are not signed in",
      "signIn":"Sign in",
      "challenge_required": "Please delete the instagram account from the app and log in again. Account name: ",
      "backroundmessage": "You are still winning. Because your instagram accounts are active and your app is running in the background."
    }
  };

  static String getString(String word) {
    return _localizedValues[locale.languageCode][word];
  }
}
