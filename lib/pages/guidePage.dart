import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  static const routeName = '/guidepage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('After Flood Guide'),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView(
            children: <Widget>[
              Text(
                'Health Management',
                style: TextStyle(fontSize: 35),
              ),
              Padding(
                child:
                    Text('Illness Protection', style: TextStyle(fontSize: 25)),
                padding: EdgeInsets.only(left: 30, top: 20),
              ),
              Padding(
                child: Text(
                    'വെള്ളപ്പൊക്കം മുഖേന, ജലത്തിൽ കാർഷിക വ്യാവസായിക മാലിന്യങ്ങൾ ഉൾപെടാൻ സാധ്യത ഉണ്ട്. ഈ ജലം ശരീരത്തിൽ സ്പർശിച്ചത് കൊണ്ട് ഗുരുതരമായ ആരോഗ്യപ്രശ്നമുണ്ടാകുന്നില്ല എങ്കിലും, വെള്ളപ്പൊക്കത്താൽ മലിനമായ ഭക്ഷണ പാനീയങ്ങൾ ആരോഗ്യ പ്രശ്നങ്ങൾ ഉണ്ടാക്കാം.\n\nനിങ്ങളുടെ വീട്ടിൽ മാലിന്യം പ്രവഹിച്ചിട്ടുണ്ടെങ്കിൽ, റബ്ബർ ബൂട്ട്സ്, കയ്യുറകൾ ഇവ വൃത്തിയാക്കലിനുവേണ്ടി ഉപയോഗിക്കുക. അണുവിമുക്തമാക്കുവാൻ കഴിയാത്ത മാലിന്യവൽക്കരിച്ച ഗാർഹിക സാമഗ്രികൾ നീക്കം ചെയ്യുക.\n\nഏന്തെങ്കിലും മുറിവുകൾ നിങ്ങൾക്ക് ഉണ്ടെങ്കിൽ, അവയെ സോപ്പ് ഉപയോഗിച്ച് കഴുകുകയും രോഗം വരാതിരിക്കാൻ ഒരു ആന്റിബയോട്ടിക് തൈലം ഉപയോഗിക്കുകയും ചെയ്യുക.\n\nവെള്ളപ്പൊക്കം മുഖേന മലിനമാക്കപ്പെട്ട വസ്ത്രങ്ങൾ ചൂടുവെള്ളം, സോപ്പ് എന്നിവ ഉപയോഗിച്ച് പ്രത്യേകം കഴുകുക.',
                    style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20),
              ),
              Padding(
                child: Text('Essential Medicines to be kept after a Flood',
                    style: TextStyle(fontSize: 25)),
                padding: EdgeInsets.only(left: 30, top: 20),
              ),
              Padding(
                child: Text('''    Disinfectant solution-അണുനാശിനി

    Fever medication-പനി മരുന്നുകൾ

    Antibiotics-ആൻറിബയോട്ടിക്

    anti fungal cream-ആന്റി-ഫംഗൽ ക്റീം

    ORS Packets-ഒആർഎസ്സ് പാക്കറ്റുകൾ

    Pain Killers-പെയ്ൻ കില്ലറുകൾ

    antacids-ഗാസ്സിനുളള മരുന്നുകൾ

    laxatives-വയറിളക്ക മരുന്നുകൾ

    Masks-മുഖംമൂടി

    Cotton Rolls-പഞ്ഞി കെട്ടുകൾ

    Bleaching powder-ബ്ളീച്ചിങ് പൊടി

    Chlorine tablets-ക്ലോറിൻ പൊടി''', style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20),
              ),
              Padding(
                  child: Text('Water Sterilization',
                      style: TextStyle(fontSize: 25)),
                  padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                  child: Text(
                      '''നിങ്ങളുടെ കുക്കർ വെള്ളം കൊണ്ട് നിറയ്ക്കുക. ഉയർന്ന ചൂടിൽ 10 മുതൽ 15 വിസിൽ വരെ (15 മിനുട്ട്) ചൂടാക്കുക. ഫിൽറ്റർ ചെയ്യുക, ഉപയോഗിക്കുക. വേണമെങ്കിൽ അൽപ്പം ജീരകം ചേർക്കാം. ഈ രീതിയിൽ വെള്ളം അണുവിമുക്തവും സുരക്ഷിതവുംമാകുന്നു.

Most flooded areas are cut off from bottled/ safe water supplies. Here's what you can do to sterilise ANY water.

Fill up your pressure cooker with water. Pressure cook for 10 to 15 whistles (15 mins) at high heat. Filter and use. You can add a few spoons of cumin if you like.

ANY water becomes safe to drink if sterilized this way.''',style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20),),
              Padding(
                  child: Text('Note for Volunteers',
                      style: TextStyle(fontSize: 25)),
                  padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                  
                  child: Text(
                      '''For most flood clean-up work, use a half-face negative-air respirator with HEPA filters. These respirators have canisters on the sides of your mouth to filter out dust and mold. HEPA filters are magenta coloured.

Use paper or cloth respirators labeled N95 or N100 if you plan to be in the home for short periods of time (less than 15 minutes) and will not disturb much mold. The best N95/N100 dust filters have a valve in the middle and two straps to hold the mask securely on the head.

If you plan to work in many houses with high mold and dust levels, you may want to buy a powered air purifying respirator (PAPR) that has a fan that blows filtered air into the hood. These are especially helpful if you have a beard and cannot get a tight fit from other respirators or masks. PAPR’s provide the highest level of protection, but are expensive. However substitutes are available in Indian market and online.''',style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20),),
              Text(
                'Clean Up Guide',
                style: TextStyle(fontSize: 35),
              ),
              Padding(
                  child: Text('Let us Return Home Safely!',
                      style: TextStyle(fontSize: 25)),
                  padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                child: Text(
                    '''അധികാരികൾ സുരക്ഷിതമാണെന്ന് നിർദ്ദേശിക്കുന്നത് വരെ വീട്ടിലേക്ക് മടങ്ങരുത്

    മേൽക്കൂരകളും ഭിത്തികളും ബലഹീനമല്ലെന്നും വിള്ളലുകളില്ലെന്നും ഉറപ്പാക്കുക

    നിങ്ങളുടെ വീടും ചുറ്റുപാടും വൃത്തിയാക്കാൻ തുടങ്ങുന്നതിനുമുമ്പ് നാശം സംഭവിച്ച വസ്തുവകകളുടെ ഫോട്ടോകളും വീഡിയോകളും എടുക്കുക

    പ്രളയജലം കിണറുകളും ചവറുകളും മാൻഹോളുകളും മൂടിയിരിക്കും, അതിനാൽ സാവധാനവും സൂക്ഷിച്ചും ഡ്രൈവ് ചെയ്യുക

    നിങ്ങളുടെ വീടിന്റെ മെയിൻ സ്വിച്ച് ഓഫാണെന്ന് ഉറപ്പാക്കുക. സോളാർ, ഇൻവെർട്ടർ എന്നിവ സ്ഥാപിച്ചിട്ടുള്ളവർ മുൻകരുതൽ എടുക്കുക

    വൃത്തിയാക്കുന്ന സമയത്ത് എല്ലായ്പ്പോഴും കൈയ്യുറകൾ, പാദരക്ഷകൾ (പ്രത്യേകിച്ച് ബൂട്ട്സ്) ധരിക്കുക

    വെള്ളപ്പൊക്കം പൂർണ്ണമായും മറികടന്നതിനുശേഷം മാത്രമേ നിങ്ങളുടെ വീട്ടിലേക്ക് തിരിച്ചുപോകാവു

    പാമ്പുകളെയും മറ്റു ജീവികളെയും നിങ്ങളുടെ വീടിനകത്തും പുറത്തും കാണാനുള്ള സാധ്യതയുണ്ട്. ജാഗ്രത പുലർത്തുക 🐍''',
                    style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20),
              ),
              Padding(
                  child: Text('Clean Wells', style: TextStyle(fontSize: 25)),
                  padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                child: Text(
                    '''സാധാരണ വാങ്ങാന്‍ ലഭിക്കുന്ന ബ്ലീച്ചിംഗ് പൌഡറില്‍ 30 മുതല്‍ 40 ശതമാനം വരെ ആണ് ക്ലോറിന്‍റെ അളവ്. 33% ക്ലോറിന്‍ ഉണ്ട് എന്ന നിഗമനത്തില്‍ ആണ് ഇനി പറയുന്ന അളവുകള്‍ നിര്‍ദേശിക്കുന്നത്. 
കിണറിലെ വെള്ളത്തിന്‍റെ അളവ് ആദ്യം നമ്മള്‍ കണക്കാക്കണം. അതിനു ആദ്യം കിണറിന്‍റെ വ്യാസം മീറ്ററില്‍ കണക്കാക്കുക (D). തുടര്‍ന്ന് ബക്കറ്റ് കിണറിന്‍റെ ഏറ്റവും അടിയില്‍ വരെ ഇറക്കി നിലവില്‍ ഉള്ള വെള്ളത്തിന്‍റെ ആഴം മീറ്ററില്‍ കണക്കാക്കുക (H) വെള്ളത്തിന്‍റെ അളവ് = 3.14 x D x D x H x 250 ലിറ്റര്‍
സാധാരണ ക്ലോറിനേഷന്‍ നടത്താന്‍ 1000 ലിറ്ററിന് 2.5 ഗ്രാം ബ്ലീച്ചിംഗ് പൌഡര്‍ ആണ് ആവശ്യം വരിക. എന്നാല്‍ വെള്ളപ്പൊക്കത്തിനു ശേഷം വെള്ളം അതീവ മലിനം ആയിരിക്കും എന്നത് കൊണ്ട് സൂപ്പര്‍ ക്ലോറിനേഷന്‍ നടത്തേണ്ടതുണ്ട്. ഇതിനായി 1000 ലിറ്ററിന് 5 ഗ്രാം (ഏകദേശം ഒരു ടീസ്പൂണ്‍ കൂമ്പാരം ആയി) ബ്ലീച്ചിംഗ് പൌഡര്‍ ആണ് ആവശ്യം.
വെള്ളത്തിന്‍റെ അളവ് വച്ച് ആവശ്യം ആയ ബ്ലീച്ചിംഗ് പൌഡര്‍ ഒരു പ്ലാസ്റ്റിക്‌ ബക്കറ്റില്‍ എടുക്കുക. ഇതില്‍ അല്പം വെള്ളം ചേര്‍ത്ത് കുഴമ്പ് പരുവത്തില്‍ ആക്കുക. നന്നായി കുഴമ്പ് ആയ ശേഷം ബക്കറിന്‍റെ മുക്കാല്‍ ഭാഗം വെള്ളം ഒഴിച്ച് ഇളക്കുക. ശേഷം ബക്കറ്റ് 10 മിനിറ്റ് അനക്കാതെ വെക്കുക
10 മിനിറ്റ് കഴിയുമ്പോള്‍ ലായനിയിലെ ചുണ്ണാമ്പ് അടിയില്‍ അടിയും. മുകളില്‍ ഉള്ള വെള്ളത്തില്‍ ക്ലോറിന്‍ ലയിച്ചു ചേര്‍ന്നിരിക്കും. വെള്ളം കോരുന്ന ബക്കറ്റിലേക്ക് ഈ തെളി ഒഴിച്ച ശേഷം ബക്കറ്റ് കിണറിന്‍റെ ഏറ്റവും അടിയിലേക്ക് ഇറക്കി പൊക്കുകയും താഴ്ത്തുകയും ചെയ്തു വെള്ളത്തില്‍ ക്ലോറിന്‍ ലായനി നന്നായി കലര്‍ത്തുക. 
1 മണിക്കൂര്‍ സമയം വെള്ളം അനക്കാതെ വച്ച ശേഷം കിണറിലെ വെള്ളം ഉപയോഗിച്ച് തുടങ്ങാം.''',
                    style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20),
              ),
              Text(
                'Insurance',
                style: TextStyle(fontSize: 35),
              ),
              Padding(
                  child: Text('Tips to Claim Insurance',
                      style: TextStyle(fontSize: 25)),
                  padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                child: Text(
                    '''The PSU general insurance companies have put systems in place to expediate processing of claims for the 2018 Kerala Floods.
PSU Insurer Contact Details

The insurers have contact details established to aid with claims processing. Here they are for your convenience (Source: The News Minute).
National Insurance Co Ltd

    Claim hub: 9188044186

    Email: kro.claimshub@nic.co.in

New India Assurance Co Ltd

    Toll-free number 18002091415

Oriental Insurance Co Ltd

    Toll-free number 1800-11-8485

    Email: kerala.claims@orientalinsurance.co.in

United India Insurance Co Ltd

    Vehicle claims: 8921792522

    Other claims: 9388643066

    Email: uiic.keralaflood@gmail.com''',
                    style: TextStyle(fontSize: 18)),
                padding: EdgeInsets.only(left: 50, right: 20, top: 20,bottom: 20),
              ),
            ],
          )),
    );
  }
}
