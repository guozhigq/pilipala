import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/scrolling.dart';
import 'package:pilipala/utils/subordinate_scroll_controller_scope.dart';
import './controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class PreferredSizePersistentDelegate extends SliverPersistentHeaderDelegate {
  @override
  final TickerProvider vsync;
  final PreferredSizeWidget widget;

  const PreferredSizePersistentDelegate({
    required this.widget,
    required this.vsync,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;

  @override
  bool shouldRebuild(covariant PreferredSizePersistentDelegate oldDelegate) =>
      true;

  // @override
  // FloatingHeaderSnapConfiguration? get snapConfiguration =>
  //     FloatingHeaderSnapConfiguration(
  //         curve: Curves.easeOut, duration: const Duration(milliseconds: 200));
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final HomeController _homeController = Get.put(HomeController());
  List videoList = [];

  @override
  bool get wantKeepAlive => true;

  showUserBottomSheet() {
    feedBack();
    showModalBottomSheet(
      context: context,
      builder: (_) => const SizedBox(
        height: 450,
        child: MinePage(),
      ),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  PreferredSizeWidget _buildTabs() {
    if (_homeController.tabs.length > 1) {
      if (_homeController.enableGradientBg) {
        return const CustomTabs();
      }
      return PreferredSize(
        preferredSize: const Size.fromHeight(42),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          height: 42,
          padding: const EdgeInsets.only(top: 4),
          child: Align(
            alignment: Alignment.center,
            child: TabBar(
              controller: _homeController.tabController,
              tabs: [for (var i in _homeController.tabs) Tab(text: i['label'])],
              isScrollable: true,
              enableFeedback: true,
              splashBorderRadius: BorderRadius.circular(10),
              tabAlignment: TabAlignment.center,
              onTap: (value) {
                feedBack();
                if (_homeController.initialIndex.value == value) {
                  ScrollingUtils.navigateToTop(
                      PrimaryScrollController.of(context),
                      MediaQuery.of(context).size.height);
                }
                _homeController.initialIndex.value = value;
              },
            ),
          ),
        ),
      );
    }
    return const PreferredSize(
        preferredSize: Size.fromHeight(6), child: SizedBox(height: 6));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Platform.isAndroid
            ? SystemUiOverlayStyle(
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
              )
            : Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                delegate: PreferredSizePersistentDelegate(
                    vsync: this,
                    widget: CustomAppBar(
                        ctr: _homeController, callback: showUserBottomSheet)),
                floating: true,
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                    delegate: PreferredSizePersistentDelegate(
                        vsync: this, widget: _buildTabs()),
                    pinned: true),
              ),
            ];
          },
          body: TabBarView(
            controller: _homeController.tabController,
            children: [
              for (final (index, page) in _homeController.tabsPageList.indexed)
                ListenableBuilder(
                  listenable: _homeController.tabController,
                  builder: (context, child) {
                    return SubordinateScrollControllerScope(
                      isActive: _homeController.tabController.index == index,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: NestedScrollView
                                          .sliverOverlapAbsorberHandleFor(
                                              context)
                                      .layoutExtent ??
                                  0),
                          child: page),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final HomeController? ctr;
  final Function? callback;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    this.ctr,
    this.callback,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final RxBool isUserLoggedIn = ctr!.userLogin;
    final double top = MediaQuery.of(context).padding.top;

    return UserInfoWidget(
      top: top,
      ctr: ctr,
      userLogin: isUserLoggedIn,
      userFace: ctr?.userFace.value,
      callback: () => callback!(),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key? key,
    required this.top,
    required this.userLogin,
    required this.userFace,
    required this.callback,
    required this.ctr,
  }) : super(key: key);

  final double top;
  final RxBool userLogin;
  final String? userFace;
  final VoidCallback? callback;
  final HomeController? ctr;

  Widget buildLoggedInWidget(context) {
    return Stack(
      children: [
        NetworkImgLayer(
          type: 'avatar',
          width: 34,
          height: 34,
          src: userFace,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => callback?.call(),
              splashColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.3),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          SearchBar(ctr: ctr),
          if (userLogin.value) ...[
            const SizedBox(width: 4),
            ClipRect(
              child: IconButton(
                onPressed: () => Get.toNamed('/whisper'),
                icon: const Icon(Icons.notifications_none),
              ),
            )
          ],
          const SizedBox(width: 8),
          Obx(
            () => userLogin.value
                ? buildLoggedInWidget(context)
                : DefaultUser(callback: () => callback!()),
          ),
        ],
      ),
    );
  }
}

class DefaultUser extends StatelessWidget {
  const DefaultUser({super.key, this.callback});
  final Function? callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(0.05);
          }),
        ),
        onPressed: () => callback?.call(),
        icon: Icon(
          Icons.person_rounded,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class CustomTabs extends StatefulWidget implements PreferredSizeWidget {
  const CustomTabs({super.key});

  @override
  State<CustomTabs> createState() => _CustomTabsState();

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

class _CustomTabsState extends State<CustomTabs> {
  final HomeController _homeController = Get.put(HomeController());

  void onTap(int index) {
    feedBack();
    if (_homeController.initialIndex.value == index) {
      ScrollingUtils.navigateToTop(PrimaryScrollController.of(context),
          MediaQuery.of(context).size.height);
    }
    _homeController.initialIndex.value = index;
    _homeController.tabController.index = index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(top: 8),
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          scrollDirection: Axis.horizontal,
          itemCount: _homeController.tabs.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 10);
          },
          itemBuilder: (BuildContext context, int index) {
            String label = _homeController.tabs[index]['label'];
            return Obx(
              () => CustomChip(
                onTap: () => onTap(index),
                label: label,
                selected: index == _homeController.initialIndex.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final Function onTap;
  final String label;
  final bool selected;
  const CustomChip({
    super.key,
    required this.onTap,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    final Color secondaryContainer = colorTheme.secondaryContainer;
    final Color onPrimary = colorTheme.onPrimary;
    final Color primary = colorTheme.primary;
    final TextStyle chipTextStyle = selected
        ? TextStyle(fontSize: 13, color: onPrimary)
        : TextStyle(fontSize: 13, color: colorTheme.onSecondaryContainer);
    const VisualDensity visualDensity =
        VisualDensity(horizontal: -4.0, vertical: -2.0);
    return InputChip(
      side: BorderSide.none,
      backgroundColor: secondaryContainer,
      color: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected) ||
            states.contains(MaterialState.hovered)) {
          return primary;
        }
        return colorTheme.secondaryContainer;
      }),
      padding: const EdgeInsets.fromLTRB(6, 1, 6, 1),
      label: Text(label, style: chipTextStyle),
      onPressed: () => onTap(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      selected: selected,
      showCheckmark: false,
      visualDensity: visualDensity,
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.ctr,
  }) : super(key: key);

  final HomeController? ctr;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        width: 250,
        height: 44,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          color: colorScheme.onSecondaryContainer.withOpacity(0.05),
          child: InkWell(
            splashColor: colorScheme.primaryContainer.withOpacity(0.3),
            onTap: () => Get.toNamed('/search',
                parameters: {'hintText': ctr!.defaultSearch.value}),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.search_outlined,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                      ctr!.defaultSearch.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colorScheme.outline),
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
