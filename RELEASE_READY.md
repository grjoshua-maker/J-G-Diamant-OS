# J&G V1 — Release Ready Gate

Ziel: eine veröffentlichungsfähige V1, nicht ein dauerhaft „fertiges“ Produkt.

Status-Legende:
- ✅ technisch umgesetzt / im Projekt vorhanden
- 🧪 muss noch im echten End-to-End-Test bestätigt werden
- ⏳ vor öffentlichem Launch noch offen

## Kritische Release-Gates

- 🧪 Registrierung mit vollständigen Kundendaten erfolgreich
- 🧪 Login / Logout / Session-Wiederherstellung stabil
- 🧪 Passwort-Reset und bestätigter E-Mail-Wechsel funktionieren ohne Verlust der Kundenzuordnung
- 🧪 Kundendaten erscheinen korrekt im Admin
- 🧪 Executive-Fahrservice-Anfrage funktioniert End-to-End
- ✅ Kalkulator- und Journey-Metadaten sind technisch in den Anfragefluss integriert
- 🧪 Kalkulator liefert im realen Browser nachvollziehbaren Richtpreis und kennzeichnet ihn korrekt
- ✅ Administrative Prüfung und Journey→Offerte-Workflow sind technisch vorhanden
- 🧪 Offerte kann erstellt, geöffnet, versendet und dem richtigen Kunden zugeordnet werden
- ✅ Kundenreaktion auf Offerte und Status-Synchronisierung sind technisch gekoppelt
- ✅ Angenommene Offerte kann technisch in eine Rechnung überführt werden
- 🧪 Rechnung, Zahlungsstatus und Dokumentenarchiv müssen im realen Durchlauf bestätigt werden
- ✅ RLS-/Rollen-Hardening für zentrale Kunden-, Projekt-, Offerten-, Rechnungs- und Journey-Daten ist vorbereitet und angewendet
- 🧪 Rollen und Kundendatenschutz müssen mit mindestens zwei getrennten Testkonten praktisch verifiziert werden
- ✅ Kundenseitige Marken-/Sprachschicht nutzt Executive Fahrservice sowie Diamant, Black, Private
- 🧪 Keine sichtbaren Platzhalter, Testtexte oder falschen Service-Begriffe im vollständigen Browserdurchlauf
- 🧪 Mobile Nutzung auf iPhone/Safari
- 🧪 Desktop-Nutzung
- ✅ Guards für Sessions, Doppelklicks, Offline-Zustand und typische Eingabefehler sind technisch vorhanden
- 🧪 Fehlerzustände müssen im echten Browser provoziert und bewertet werden
- ⏳ Finale Unternehmens-, Zahlungs- und Kontaktdaten vor öffentlichem Launch eintragen
- ⏳ Finale Fahrzeug-/Lifestyle-Bildwelt ergänzen oder bewusst ohne Fremd-Stockbilder veröffentlichen
- ⏳ Vercel-Projekt anlegen/verbinden und echten Preview-/Production-Deploy durchführen

## Marken-Gate

Die V1 soll seriös, diskret, luxuriös, extravagant und eigenständig wirken. Keine Taxi-, CRM- oder Personenschutz-Sprache. Mitgliedschaften: Diamant, Black, Private. Hauptservice: Executive Fahrservice.

Der erste Luxury-Pass, Private-Client-Dashboard, Executive-Journey-Inszenierung, Fleet-Bühne, Membership-Hierarchie, Concierge/Private Client Desk sowie private Dokument-/Korrespondenzsprache sind technisch integriert. Das finale Marken-Gate wird erst im Browser auf Desktop und Mobile abgenommen.

## Deployment

GitHub `main` ist die aktuelle Release-Basis. Im derzeit verbundenen Vercel-Team wurde zuletzt noch kein Projekt gefunden. Deshalb gilt Vercel aktuell als offener Launch-Schritt und nicht als bereits bestandenes Gate.

## Nächste Release-Reihenfolge

1. Lokaler/Preview-Browser-Smoke-Test aller Ansichten und Scripts.
2. Zwei-Testkonten-Test: Kunde vs. Admin/Mitarbeiter.
3. Kompletter Geschäftsfall: Registrierung → Executive Journey → Prüfung → Offerte → Annahme → Durchführung → Rechnung → Zahlung → Archiv.
4. Passwort-Reset, E-Mail-Wechsel, abgelaufene Session und Fehlerfälle testen.
5. iPhone/Safari und Desktop visuell/funktional abnehmen.
6. Finale Unternehmens-/Kontakt-/Zahlungsdaten setzen.
7. Vercel-Projekt verbinden, Preview deployen, nochmals End-to-End testen.
8. Production-Freigabe.

## Definition „Release Ready“

Release Ready bedeutet: Ein realer Neukunde kann ohne interne Hilfe ein Konto eröffnen, eine Kernleistung anfragen und den Kundenprozess bis zur Abrechnung nachvollziehbar durchlaufen; J&G kann denselben Vorgang administrativ vollständig bearbeiten. Keine kritischen Daten-, Rollen-, Session-, Zahlungs- oder Navigationsfehler dürfen offen sein.
