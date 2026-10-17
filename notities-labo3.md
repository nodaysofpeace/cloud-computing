# Notities labo 3

## 1. Waarom werkt localhost niet als host in je DATABASE_URL, en wat werkt wel?

In de webcontainer wijst localhost naar de webcontainer zelf. PostgreSQL draait in een andere container, dus daar vind ik geen database.

Ik gebruik db als host, want dat is de naam van de PostgreSQL-service in compose.yaml. Compose zorgt ervoor dat die naam in het netwerk naar de databasecontainer gaat.

Met localhost kreeg ik deze fout:

```text
connection to server at "127.0.0.1", port 5432 failed: Connection refused
```

## 2. Je hebt nergens een netwerk aangemaakt, en toch vinden je twee containers elkaar. Hoe komt dat?

Compose maakt zelf al een standaardnetwerk aan voor het project. Web en db zitten daar allebei in, dus ze kunnen elkaar bereiken via de servicenaam.

Bij mijn project heet dat netwerk cloud-computing_default.

## 3. Wat is het verschil tussen docker compose down en docker compose down -v ?

- ```docker compose down``` verwijdert de containers en het Compose-netwerk. Het named volume blijft staan, dus de databasegegevens blijven bewaard.

- ```docker compose down -v``` verwijdert ook het named volume dat in mijn Compose-bestand staat. Hierdoor ben ik de databasegegevens kwijt.

## 4. Waarom publiceer je poort 5432 niet?

Enkel de applicatiecontainer moet met PostgreSQL verbinden. Dat kan je dit gewoon via db:5432 op het interne Compose-netwerk.

Een poort publiceren op mijn laptop is hiervoor dus niet nodig. Enkel de webapplicatie publiceert poort 8000.

## 5. depends_on zorgde er niet voor dat je applicatie wachtte tot de database klaar was. Wat doet het dan wel?

depends_on in de korte notatie zorgt ervoor dat Compose de databasecontainer start voor de applicatiecontainer.

Het wacht wel niet tot PostgreSQL klaar is om verbindingen te accepteren. Daarom gebruik ik bij web ook restart: on-failure. Als de applicatie te vroeg start en crasht, start ze gewoon opnieuw op.

## 6. Aan welke map heb je het volume van de database gehangen, en waar heb je dat gevonden

Ik gebruik postgres:18 en hang het named volume postgres-data aan: ```/var/lib/postgresql```

Ik had dit gevonden op: [hub.docker.com](https://hub.docker.com/_/postgres) vanonder bij dde documentatie over postgresql 18

## 7. Je collega cloont je repo en doet docker compose up . Wat moet hij zelf nog doen voor het werkt, en hoe weet hij dat?

Die persoon moet .env.example kopiëren naar .env en de waarden invullen voor:

- POSTGRES_USER
- POSTGRES_PASSWORD
- POSTGRES_DB

Daarna kan alles gestart worden met: ```docker compose up -d --build```

De exacte stappen staan in mijn README. Mijn eigen .env zit niet in Git, dus die heb ik niet meegestuurd.

## Mijn resultaten van mijn Testen
- De SQLite-melding bleef bewaard nadat ik de container verwijderd en opnieuw aangemaakt had met hetzelfde volume.
- De applicatie werkte via Compose met PostgreSQL: /health gaf ```{"opslag":"PostgreSQL","status":"ok"}```.
- Twee PostgreSQL-meldingen bleven bewaard na ```docker compose down``` en daarna ```docker compose up -d```.