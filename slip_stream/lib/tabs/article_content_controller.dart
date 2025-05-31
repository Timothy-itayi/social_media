import 'package:html/parser.dart' show parse;

class ArticleContentController {
  final String rawHtml;

  ArticleContentController(this.rawHtml);

  /// Cleans HTML and splits into readable paragraphs
  List<String> getParagraphs() {
    // Parse HTML to plain text
    final document = parse(rawHtml);
    final plainText = document.body?.text ?? '';

    // Split by double newlines or sentence ends for paragraphs
    final paragraphs = plainText
        .split(RegExp(r'\n{2,}|(?<=\.)\s+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return paragraphs;
  }
}
