import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tpi_programming_club/app/views/pages/drawer/drawer.dart';

class MarkDownOutPut extends StatefulWidget {
  final String markdown;
  final String name;
  final String id;
  const MarkDownOutPut(
      {super.key,
      required this.markdown,
      required this.name,
      required this.id});

  @override
  State<MarkDownOutPut> createState() => _MarkDownOutPutState();
}

class _MarkDownOutPutState extends State<MarkDownOutPut> {
  TocController tocController = TocController();
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text("OUTPUT"),
      ),
      body: MediaQuery.of(context).size.width > 700
          ? Row(
              children: [
                Expanded(
                  child: TocWidget(
                    controller: tocController,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: MarkdownWidget(
                    config: config,
                    data: widget.markdown,
                    tocController: tocController,
                  ),
                ),
              ],
            )
          : MarkdownWidget(
              config: config,
              data: widget.markdown,
              tocController: tocController,
            ),
    );
  }
}
