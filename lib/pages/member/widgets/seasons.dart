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
          padding: const EdgeInsets.only(bottom: 12, right: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 4),
                child: Row(
                  children: [
                    Text(
                      item.meta!.name!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                    const SizedBox(width: 10),
                    PBadge(
                      stack: 'relative',
                      size: 'small',
                      text: item.meta!.total.toString(),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        onPressed: () => Get.toNamed(
                            '/memberSeasons?mid=${item.meta!.mid}&seasonId=${item.meta!.seasonId}'),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              LayoutBuilder(
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
            ],
          ),
        );
      },
    );
  }
}
