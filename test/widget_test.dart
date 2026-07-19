import 'package:flutter_test/flutter_test.dart';
import 'package:taekwondo_azuay/src/app/taekwondo_azuay_app.dart';

void main() {
  testWidgets('renders the home screen and bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaekwondoAzuayApp());

    expect(find.text('TAEKWONDO AZUAY'), findsOneWidget);
    expect(find.text('Open Cuenca\n2024:'), findsOneWidget);
    expect(find.text('La Gloria te Espera'), findsOneWidget);
    expect(find.text('Ranking'), findsWidgets);
    expect(find.text('Torneos'), findsWidgets);
    expect(find.text('Academias'), findsWidgets);
    expect(find.text('Noticias'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
