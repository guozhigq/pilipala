import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/models/member/seasons.dart';
import 'package:pilipala/pages/member_seasons/widgets/item.dart';

class MemberSeasonsPanel extends StatelessWidget {
  final MemberSeasonsDataModel? data;
  const MemberSeasonsPanel({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data!.seasonsList!.length,
      itemBuilder: (context, index) {
        MemberSeasonsList item = data!.seasonsList![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  final int category = item.meta!.category!;
                  Map<String, String> parameters = {};
                  if (category == 0) {
                    parameters = {
                      'category': '0',
                      'mid': item.meta!.mid.toString(),
                      'seasonId': item.meta!.seasonId.toString(),
                      'seasonName': item.meta!.name!,
                    };
                  }
                  // 2为直播回放
                  if (category == 1 || category == 2) {
                    parameters = {
                      'category': '1',
                      'mid': item.meta!.mid.toString(),
                      'seriesId': item.meta!.seriesId.toString(),
                      'seasonName': item.meta!.name!,
                    };
                  }
                  Get.toNamed('/memberSeasons', parameters: parameters);
                },
                title: Text(
                  item.meta!.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
                dense: true,
                leading: PBadge(
                  stack: 'relative',
                  size: 'small',
                  text: item.meta!.total.toString(),
                ),
                trailing: const Icon(
                  Icons.arrow_forward,
                  size: 20,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  left: StyleString.safeSpace,
                  right: StyleString.safeSpace,
                ),
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Use a fixed count for GridView
                        crossAxisSpacing: StyleString.safeSpace,
                        mainAxisSpacing: StyleString.safeSpace,
                        childAspectRatio: 0.94,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: item.archives!.length,
                      itemBuilder: (context, i) {
                        return MemberSeasonsItem(seasonItem: item.archives![i]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
