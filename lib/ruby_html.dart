import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:ruby_text/ruby_text.dart';

/// A Flutter widget to display HTML ruby tags
class RubyHtml extends StatelessWidget {
  /// Constructor
  const RubyHtml(this.html,
      {super.key,
        this.style,
        this.mainStyle,
        this.rubyStyle,
        this.textAlign,
        this.softWrap,
        this.overflow,
        this.maxLines,
        this.speechText});

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

  final String? speechText;

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
              if (speechText != null &&
                  mainStyle != null &&
                  rubyStyle != null &&
                  speechText != "" &&
                  speechText!.contains(
                      _removeJapaneseKana(_removePunctuation(node.text)))) {
                TextStyle markedStyle =
                mainStyle!.copyWith(color: Color(0xff000000));
                TextStyle markedRubyStyle =
                rubyStyle!.copyWith(color: Color(0x00ffffff));
                rubyTexts.add(
                  RubyTextData(
                    mainText,
                    ruby: rubyText,
                    style: markedStyle,
                    rubyStyle: markedRubyStyle,
                  ),
                );
              } else {
                rubyTexts.add(
                  RubyTextData(
                    mainText,
                    ruby: rubyText,
                    style: mainStyle,
                    rubyStyle: rubyStyle,
                  ),
                );
              }

              mainText = '';
              rubyText = '';
            }
          }

          // last text
          if (mainText.isNotEmpty) {
            if (speechText != null &&
                mainStyle != null &&
                rubyStyle != null &&
                speechText != "" &&
                speechText!.contains(_removePunctuation(node.text))) {
              TextStyle markedStyle = style!.copyWith(color: Color(0xff000000));
              TextStyle markedRubyStyle =
              rubyStyle!.copyWith(color: Color(0x00000000));
              rubyTexts.add(
                RubyTextData(
                  mainText,
                  ruby: rubyText,
                  style: markedStyle,
                  rubyStyle: markedRubyStyle,
                ),
              );
            } else {
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
    }

    final List<RubyTextData> rubyTextsSeparated =
    _processRubyTextList(rubyTexts);

    return RubyText(
      rubyTextsSeparated,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  String _removePunctuation(String text) {
    return text.replaceAll(RegExp(r'[、。！？（）「」『』【】]'), '');
  }

  String _removeJapaneseKana(String input) {
    final regex = RegExp(r'[\u3040-\u309F\u30A0-\u30FF]');
    return input.replaceAll(regex, '');
  }

  String _removeKanji(String input) {
    return input.replaceAll(RegExp(r'[\u4E00-\u9FFF\u3400-\u4DBF]'), '');
  }

  bool _isJapanesePunctuation(String char) {
    return RegExp(
        r'[\u3000-\u303F\uFF01-\uFF0F\uFF1A-\uFF20\uFF3B-\uFF40\uFF5B-\uFF60\u30FBー.,?!:;(){}[\]<>-]')
        .hasMatch(char);
  }

  List<RubyTextData> _processRubyTextList(List<RubyTextData> list) {
    String kana = _removeKanji(speechText ?? "");
    String pureKana = _removePunctuation(kana);
    if (kana.isEmpty) {
      return list;
    }

    int targetIndex = 0;

    List<RubyTextData> slices = list.expand((item) {
      if (item.ruby == null) {
        return [item];
      } else if (item.ruby!.isEmpty) {
        return item.text.split('').map((char) {
          return item.copyWith(text: char);
        }).toList();
      } else {
        return [item];
      }
    }).toList();

    TextStyle markedStyle = (style ?? TextStyle()).copyWith(
        color: Color(0xff000000));

    for (String char in pureKana.split('')) {
      while (targetIndex < slices.length && (slices[targetIndex].ruby != "" ||
          _isJapanesePunctuation(slices[targetIndex].text))
      ) {
        targetIndex++;
      }
      if (targetIndex >= slices.length) break;
      for (int i = targetIndex; i < slices.length; i++) {
        if (slices[i].text == char) {
          slices[i] =
              slices[i].copyWith(style: markedStyle);
          targetIndex = i + 1;
          break;
        }
      }
    }
    return slices.map((e) {
      if (_isJapanesePunctuation(e.text)) {
        return e.copyWith(style: markedStyle);
      } else {
        return e;
      }
    }).toList();
  }
}
