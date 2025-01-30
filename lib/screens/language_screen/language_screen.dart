import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/provider/language_provider.dart';
import 'package:plantas_ai_plant_identifier/utils/app_text.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';
import '../../utils/app_localized_text.dart';
import '../../utils/appfonts.dart';

class LanguageScreen extends StatefulWidget {
  static const routeName = '/languageScreen';
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<LanguageProvider>(context, listen: false).updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> languagesChange = {
      "English": translate(context).english,
      "Arabic": translate(context).arabic,
      "Catalan": translate(context).catalan,
      "Chinese": translate(context).chinese,
      "Croatian": translate(context).croatian,
      "Czech": translate(context).czech,
      "Danish": translate(context).danish,
      "Dutch": translate(context).dutch,
      "Finnish": translate(context).finnish,
      "French": translate(context).french,
      "German": translate(context).german,
      "Greek": translate(context).greek,
      "Hebrew": translate(context).hebrew,
      "Hindi": translate(context).hindi,
      "Hungarian": translate(context).hungarian,
      "Indonesian": translate(context).indonesian,
      "Italian": translate(context).italian,
      "Japanese": translate(context).japanese,
      "Korean": translate(context).korean,
      "Malay": translate(context).malay,
      "Norwegian": translate(context).norwegian,
      "Polish": translate(context).polish,
      "Portuguese": translate(context).portuguese,
      "Romanian": translate(context).romanian,
      "Russian": translate(context).russian,
      "Slovak": translate(context).slovak,
      "Spanish": translate(context).spanish,
      "Swedish": translate(context).swedish,
      "Thai": translate(context).thai,
      "Turkish": translate(context).turkish,
      "Ukrainian": translate(context).ukrainian,
      "Vietnamese": translate(context).vietnamese,
    };

    final width = MediaQuery.of(context).size.width;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Consumer<LanguageProvider>(builder: (context, languageProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          if (currentRoute == LanguageScreen.routeName) {
            await languageProvider.loadSelectedLanguage();
            languageProvider.revertBack();
            Navigator.of(context).pop();
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<LanguageProvider>(builder: (context, languageProvider, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(
                              CupertinoIcons.arrow_uturn_left,
                              color: Colors.white,
                            ),
                          ).paddingOnly(top: 3, bottom: 3),
                        ),
                        const Spacer(),
                        Text(
                          translate(context).mainText,
                          style: poppinsBlack.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: width >= 800 ? 34 : 18,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          highlightColor: AppColors.whiteColor,
                          splashColor: AppColors.whiteColor,
                          onTap: () async {
                            await languageProvider.updateSelectedLanguage(languageProvider.selectedLanguage!).then((onValue) {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            height: 37,
                            width: 37,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.done,
                              size: Dimensions.PADDING_SIZE_LARGE,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT - 3,
                    ),
                    SizedBox(
                      height: 55,
                      child: Center(
                        child: TextField(
                          controller: _searchController,
                          cursorColor: AppColors.primaryColor,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.gray2,
                            suffixIcon: const Icon(
                              Icons.search,
                              size: 28,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: translate(context).textFieldText,
                            hintStyle: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT - 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(context).defaultLanguageText,
                          style: poppinsBlack.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          height: 33,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              languageProvider.currentLanguageName ?? AppText.english,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: languageProvider.filteredLanguages.isEmpty
                          ? Center(
                              child: Text(
                              translate(context).noLanguageText,
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.grey,
                              ),
                            ))
                          : ListView.builder(
                              itemCount: languageProvider.filteredLanguages.length,
                              itemBuilder: (context, index) {
                                final language = languageProvider.filteredLanguages[index];
                                final isSelected = languageProvider.currentLanguageCode == language.languageCode; // Check language code

                                return GestureDetector(
                                  onTap: () {
                                    languageProvider.updateLanguageVariable(
                                      language,
                                    );
                                    print('Selected Language: ${languageProvider.selectedLanguage}');
                                    print('Language Code: ${languageProvider.currentLanguageCode}');
                                    print('currentLanguageName: ${languageProvider.currentLanguageName}');
                                  },
                                  child: Column(
                                    children: [
                                      index == 0
                                          ? const SizedBox(
                                              height: 2,
                                            )
                                          : const SizedBox.shrink(),
                                      Divider(
                                        thickness: isSelected ? 2 : 0,
                                        color: isSelected ? AppColors.primaryColor : Colors.grey,
                                        height: 0,
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                          child: Image.asset(
                                            height: 45,
                                            width: 45,
                                            language.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ).paddingOnly(left: 10),
                                        title: Text(
                                          // language.languageName
                                          languagesChange[language.languageName]!,
                                        ).paddingOnly(left: 08),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            languageProvider.updateLanguageVariable(
                                              language,
                                            );
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                                                width: 2,
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                size: 15,
                                                isSelected ? Icons.check : null,
                                                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: isSelected ? 2 : 0,
                                        color: isSelected ? AppColors.primaryColor : Colors.grey,
                                        height: 0,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
