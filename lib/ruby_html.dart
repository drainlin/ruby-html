import 'package:flutter/widgets.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:ruby_text/ruby_text.dart';

/// A Flutter widget to display HTML ruby tags
class RubyHtml extends StatelessWidget {
  /// Constructor
  const RubyHtml(
    this.html, {
    super.key,
    this.style,
    this.mainStyle,
    this.rubyStyle,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
  });

  /// HTML string
  final String html;

  /// Default text style
  final TextStyle? style;

  /// Main text style
  final TextStyle? mainStyle;

  /// Ruby text style
  final TextStyle? rubyStyle;

  /// Text align, same with ruby_text package
  final TextAlign? textAlign;

  /// Same with ruby_text package
  final bool? softWrap;

  /// Same with ruby_text package
  final TextOverflow? overflow;

  /// Same with ruby_text package
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    List<RubyTextData> rubyTexts = [];

    var document = parse(html);
    for (var node in document.body!.nodes) {
      // debugPrint('node type: ${node.nodeType} text: ${node.text}');
      if (node.nodeType == dom.Node.TEXT_NODE) {
        if (node.text != null && node.text!.isNotEmpty) {
          rubyTexts.add(
            RubyTextData(node.text!, ruby: '', style: style),
          );
        }
      } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
        dom.Element element = node as dom.Element;
        // debugPrint('|--element localName: ${element.localName} text: ${element.text}');
        if (element.localName == 'ruby') {
          var mainText = '';
          var rubyText = '';
          for (var subNode in element.nodes) {
            // debugPrint('   |--subNode type: ${subNode.nodeType} text: ${subNode.text}');
            if (subNode.nodeType == dom.Node.TEXT_NODE) {
              mainText = subNode.text ?? '';
            } else if (subNode.nodeType == dom.Node.ELEMENT_NODE) {
              dom.Element element = subNode as dom.Element;
              if (element.localName == 'rt') {
                rubyText = element.text;
              }
            }

            // main text (ruby text) pair
            if (mainText.isNotEmpty && rubyText.isNotEmpty) {
              rubyTexts.add(
                RubyTextData(
                  mainText,
                  ruby: rubyText,
                  style: mainStyle,
                  rubyStyle: rubyStyle,
                ),
              );
              mainText = '';
              rubyText = '';
            }
          }

          // last text
          if (mainText.isNotEmpty) {
            rubyTexts.add(
              RubyTextData(
                mainText,
                ruby: rubyText,
                style: style,
                rubyStyle: rubyStyle,
              ),
            );
          }
        }
      }
    }

    return RubyText(
      rubyTexts,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
