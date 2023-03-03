import 'package:fairstores/credentials.dart';
import 'package:fairstores/profileScreens/customerCare.dart';
import 'package:fairstores/profileScreens/details.dart';
import 'package:fairstores/providers/securityKeysProvider.dart';
import 'package:fairstores/webview.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Help extends ConsumerWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityKeys = ref.watch(securityKeysProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "Help"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'All topics',
              isMediumWeight: true,
              fontSize: 12,
            ),
            SizedBox(height: 20,),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                    details: securityKeys!.aboutUs,
                    title: 'About Us',
                    )
                  )
                );
              },
              title: CustomText(
                  text: 'About FairStores',
                  isMediumWeight: true
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      details: securityKeys!.vendorDetails,
                      title: 'Vendors',
                    )
                  )
                );
              },
              title: CustomText(
                  text: 'Vendors',
                  isMediumWeight: true
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Details(
                      details: securityKeys!.deliveryDetails,
                      title: 'Delivery',
                    )
                  )
                );
              },
              title: CustomText(
                  text: 'Delivery',
                  isMediumWeight: true
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      details: securityKeys!.eventsDetails,
                      title: 'FairEvents',
                    )
                  )
                );
              },
              title: CustomText(
                  text: 'Events',
                  isMediumWeight: true
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerCare()
                  )
                );
              },
              title: CustomText(
                text: 'Customer Care',
                isMediumWeight: true,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => WebViewExample(
                    title: "Terms and Conditions",
                    url: termsAndConditions
                    )
                  )
                );
              },
              title: CustomText(
                text: 'Terms and Conditions',
                isMediumWeight: true
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => WebViewExample(
                    title: 'Privacy Policy',
                    url: privacyPolicy,)
                  )
                );
              },
              title: CustomText(
                  text: 'Privacy Policy',
                  isMediumWeight: true
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
          ]
        ),
      ),
    );
  }
}

