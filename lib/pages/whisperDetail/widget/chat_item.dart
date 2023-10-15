// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

class ChatItem extends StatelessWidget {
  dynamic item;

  ChatItem({
    super.key,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    bool isOwner = item.senderUid == 17340771;
    bool isPic = item.msgType == 2;
    bool isText = item.msgType == 1;
    bool isSystem =
        item.msgType == 18 || item.msgType == 10 || item.msgType == 13;
    int msgType = item.msgType;
    Map content = item.content ?? '';
    return isSystem
        ? (msgType == 10
            ? SystemNotice(item: item)
            : msgType == 13
                ? SystemNotice2(item: item)
                : const SizedBox())
        : Row(
            children: [
              if (!isOwner) const SizedBox(width: 12),
              if (isOwner) const Spacer(),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 300.0, // 设置最大宽度为200.0
                ),
                decoration: BoxDecoration(
                  color: isOwner
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isOwner ? 16 : 6),
                    bottomRight: Radius.circular(isOwner ? 6 : 16),
                  ),
                ),
                margin: const EdgeInsets.only(top: 12),
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 6,
                  left: isPic ? 8 : 12,
                  right: isPic ? 8 : 12,
                ),
                child: Column(
                  crossAxisAlignment: isOwner
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    isText
                        ? Text(
                            content['content'],
                            style: TextStyle(
                                color: isOwner
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer),
                          )
                        : isPic
                            ? NetworkImgLayer(
                                width: 220,
                                height:
                                    220 * content['height'] / content['width'],
                                src: content['url'],
                              )
                            : const SizedBox(),
                    SizedBox(height: isPic ? 7 : 2),
                    Text(
                      Utils.dateFormat(item.timestamp),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: isOwner
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.8)
                              : Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                                  .withOpacity(0.8)),
                    )
                  ],
                ),
              ),
              if (!isOwner) const Spacer(),
              if (isOwner) const SizedBox(width: 12),
            ],
          );
  }
}

class SystemNotice extends StatelessWidget {
  dynamic item;
  SystemNotice({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    Map content = item.content ?? '';
    return Row(
      children: [
        const SizedBox(width: 12),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 300.0, // 设置最大宽度为200.0
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(16),
            ),
          ),
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(content['title'],
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    Utils.dateFormat(item.timestamp),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Theme.of(context).colorScheme.outline),
                  )
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              Text(
                content['text'],
              )
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class SystemNotice2 extends StatelessWidget {
  dynamic item;
  SystemNotice2({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    Map content = item.content ?? '';
    return Row(
      children: [
        const SizedBox(width: 12),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 300.0, // 设置最大宽度为200.0
          ),
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.only(bottom: 6),
          child: NetworkImgLayer(
            width: 320,
            height: 150,
            src: content['pic_url'],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
