# RubyHtml

A Flutter widget to display HTML ruby tags.
![](./screenshot.png)

## Install
```yaml
dependencies:
    ruby_html: 1.0.0
```

## Example

```dart
  RubyHtml(
    '<ruby>日本<rt>にほん</rt>はさむいです。</ruby>'
  );
```

## Other

```dart
const RubyHtml(
  '<ruby>日本<rt>にほん</rt>はさむいです。</ruby>', {
  TextStyle? style,
  TextStyle? mainStyle,
  TextStyle? rubyStyle,
  bool? softWrap,
  TextOverflow? overflow,
  int? maxLines,
});

```