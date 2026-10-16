# Notities labo 2

## 1. Waarom staat COPY requirements.txt apart, nog voor de COPY van de rest?

Hierdoor kan Docker de installatie van python pakketten uit dde cashe hergebruiken als requirements.txt niet veranderd is.

De pakketten moeten niet opnieuw geinstalleerd worden, wel moet de docker de app files opnieuw kopïeren.

Ik had dit als verschil:
- Code gewijzigd met goede volgorde: 1.2 s
- Code gewijzigd met COPY . . voor de pakketunstallatie: 10.3 s

## 2. Wat doet de punt op het einde van docker build -t storingsmelder . ?

De punt geeft de huidige map op als bouwruimte.

Docker kan bestanden uit die ruimte gebruiken bij COPY-instructies. Bestanden die uitgesloten zijn door .dockerignore worden niet meegenomen.

## 3. Wat is het verschil tussen RUN en CMD?

RUN voert een commando uit tijdens het bouwen van het image. De wijzigingen aan het bestandssysteem worden opgenomen in het image.

Mijn file:

```RUN pip install --no-cache-dir -r requirements.txt```

Dit installeert de Python-pakketten tijdens het bouwen.

CMD bepaalt het standaardcommando dat uitgevoerd wordt wanneer een container van het image start.

Mijn file:
```CMD ["python", "app.py"]```

Dit start de applicatie wanneer ik de container start.

## 4. Werkt de applicatie zonder EXPOSE? Waarom?

Mijn Dockerfile bevatte al geen EXPOSE-instructie en de applicatie werkte...

Van de les:
EXPOSE documenteerd op welke poort je app luistert. Maar het maakt zelf geen poort.

## 5. Wat doet pip install --no-cache-dir en waarom gebruik je dit in een image?

--no-cache-dir schakelt de cache van pip uit. Daardoor bewaart pip geen download- en wheelcache voor later hergebruik.

De cache is nie nodig om de geinstalleerde app uit te voeren. Als je die niet opslaat vermijd je onnodige bestanden in je image.

Da schakelt wel niet de bouwcache van de Docker uit. Docker kan dus de volledige RUN nog steeds hergebruiken.

## 6. Waar stond mijn melding opgeslagen?

De applicatie gebruikte SQLite en bewaarde de melding in /data/storingen.db, in de schrijflaag van mijn container.

Bij een herstart bleef dezelfde container met dezelfde schrijflaag bestaan. Daarom bleef mijn melding bewaard.

Toen ik de container verwijderde, verdween ook die schrijflaag. Een nieuwe container van hetzelfde image begon zonder mijn melding.

## Cacheproef stap 7

| Situatie | Bouwtijd |
|---|---:|
| Eerste build goede volgorde | 11,4 s |
| Opnieuw bouwen | 1,0 s |
| Alleen app.py gewijzigd | 1,2 s |
| Dockerfile met slechte volgorde | 10,3 s |
| Dockerfile met slechte volgorde & app.py wijziging | 10,6 s |

## Vergelijking base images

| Base image | Imagegrootte (DISK USAGE) | CONTENT SIZE | Eerste bouwtijd |
|---|---:|---:|---:|
| python:3.14 | 1,66 GB | 426 MB | 147,3 s |
| python:3.14-slim | 221 MB | 54,1 MB | 11,4 s |
| python:3.14-alpine | 121 MB | 30,2 MB | 22,4 s |

Dit is ook de reden waarom ik alpine gebruikte uiteindelijk, omdat dit veel kleiner is dan de andere.