# J&G V1 — Release Ready Gate

Ziel: eine veröffentlichungsfähige V1, nicht ein dauerhaft „fertiges“ Produkt.

## Kritische Release-Gates

- [ ] Registrierung mit vollständigen Kundendaten erfolgreich
- [ ] Login / Logout / Session-Wiederherstellung stabil
- [ ] Kundendaten erscheinen korrekt im Admin
- [ ] Executive-Fahrservice-Anfrage funktioniert End-to-End
- [ ] Kalkulator liefert nachvollziehbaren Richtpreis und kennzeichnet ihn als Richtpreis
- [ ] Anfrage kann administrativ geprüft und bestätigt werden
- [ ] Offerte kann erstellt, geöffnet und dem Kunden zugeordnet werden
- [ ] Angenommene Offerte kann in Rechnung überführt werden
- [ ] Rechnung und Dokumentenarchiv funktionieren
- [ ] Rollen und Kundendatenschutz sind geprüft
- [ ] Keine sichtbaren Platzhalter, Testtexte oder falschen Service-Begriffe
- [ ] Mobile Nutzung auf iPhone/Safari geprüft
- [ ] Desktop-Nutzung geprüft
- [ ] Fehlerzustände sind verständlich und blockieren keine Navigation
- [ ] Finale Unternehmens-, Zahlungs- und Kontaktdaten vor öffentlichem Launch eingetragen

## Marken-Gate

Die V1 muss sich seriös, diskret, luxuriös, extravagant und eigenständig anfühlen. Keine Taxi-, CRM- oder Personenschutz-Sprache. Mitgliedschaften: Diamant, Black, Private. Hauptservice: Executive Fahrservice.

## Deployment

`main` ist mit Vercel verbunden. Release-Kandidaten werden erst nach bestandenem End-to-End-Test als veröffentlichungsfähig betrachtet.

## Definition „Release Ready“

Release Ready bedeutet: Ein realer Neukunde kann ohne interne Hilfe ein Konto eröffnen, eine Kernleistung anfragen und den Kundenprozess bis zur Abrechnung nachvollziehbar durchlaufen; J&G kann denselben Vorgang administrativ vollständig bearbeiten.
