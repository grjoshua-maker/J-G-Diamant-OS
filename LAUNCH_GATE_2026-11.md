# J&G DIAMANT — Veröffentlichungsgate (03.11.2026)

**Status:** technische Vorschau ist live, öffentlicher Marktstart noch NICHT freigegeben. Veröffentlichung ist bewusst eine gesonderte Entscheidung des Gründers.

## Vorbereitet
- Responsive Marketing-Website und Login zur J&G OS Plattform.
- Kernprozess Anfrage → Projekt → Offerte → Annahme → Serviceauftrag → Serviceakte → Rechnungsentwurf.
- Rollen-/Kundentrennung, Serviceakte und Mitarbeiterzuweisung (Produktivprüfung erforderlich).
- Rechnungsübergabe: Mehrfachklickschutz und Wiedererkennung bestehender Projektrechnungen im Frontend.
- Investor-Unterlagen 200'000–500'000 CHF als Planungsszenarien; Zahlen sind Annahmen, keine bestätigten Angebote.

## Kritische Go/No-Go-Prüfungen vor öffentlicher Freigabe
- [ ] Test mit zwei unabhängigen Accounts: Kunde sieht niemals interne Notizen oder fremde Daten.
- [ ] Neuregistrierung, E-Mail-Bestätigung, Login, Passwort-Reset, Session-Ablauf.
- [ ] Ende-zu-Ende-Test inkl. Rechnung versenden, Zahlung, PDF und Kundenansicht.
- [ ] Doppelte Rechnungen auch bei parallelen Requests serverseitig ausschließen (aktuell nur Frontend-Prüfung).
- [ ] RLS für neue Serviceakten-Felder, Uploads und Mitarbeiterrechte auditieren.
- [ ] Zahlungsanbieter, Rechnungsnummern, MwSt.-Pflicht und steuerliche Pflichtangaben validieren.
- [ ] Vollständiges Impressum, Datenschutz, AGB, Cookie-/Tracking-Prüfung, Kontakt, Firmendaten.
- [ ] Geschäftskonto/IBAN, UID/Handelsregister und Versicherungsdeckung eintragen.
- [ ] Produktiv-Domäne, E-Mail-Absender, SPF/DKIM/DMARC, Supabase Auth Redirects.
- [ ] Leaked Password Protection, Rate Limits, Monitoring, Backup/Restore-Test.
- [ ] Barrierefreiheit, Mobile Safari, Desktop und Datenschutz-Freigabe.
- [ ] Test-/Demodaten vor öffentlichem Start entfernen oder separieren.

## Offene Gründerentscheidungen
1. Definitiver Firmenname, Rechtsform, Sitz, Handelsregister-/UID-Angaben.
2. Öffentliche Kontakt-E-Mail, Telefon, Geschäftsadresse, Supportzeiten.
3. Zahlungsinformationen, MwSt.-Status und Rechnungsbedingungen.
4. Preislisten und verbindliche Leistungskataloge für J&G Home/Lifestyle/Private.
5. Mitgliedschaften: Leistungen, Laufzeiten, Kündigung, SLA, Preise.
6. Marken- und Bildfreigaben; echte Produkt-Screenshots mit geschwärzten personenbezogenen Daten.
7. Finanzierung: Darlehen/Beteiligung/Kombination, Konditionen und Gründeranteil.
8. Veröffentlichung der Website und Öffnung der Registrierung ausdrücklich freigeben.

## Annahmen im Investor-Paket
- Finanzierungskorridor CHF 200'000–500'000; drei Modelle 200k / 350k / 500k.
- Startgebiet Schaffhausen–Zürich; stufenweise Erweiterung.
- J&G OS ist ein bereits vorhandener, im Testbetrieb genutzter Prototyp; nicht als fertig auditiertes ERP bezeichnen.
- Umsatz-/Margenziele sind Planungshypothesen und noch nicht durch Verträge validiert.
