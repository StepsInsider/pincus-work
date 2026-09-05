// ignore: avoid_web_libraries_in_flutter
import "dart:html" as html;

void downloadCsv(String fileName, String base64Csv) {
  final anchor = html.AnchorElement(href: "data:text/csv;base64,$base64Csv")
    ..setAttribute("download", fileName)
    ..style.display = "none";
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
