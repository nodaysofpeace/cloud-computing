# Notities Labo 1

## 1. Waarom stopte je hello-world -container vanzelf, terwijl je nginx -container blijft draaien?

Een container kan alleen maar blijven draaien zolang het hoofdproces aan het draaien is. het doel van hello-world is om een bericht te maken, en het moment dat dit compleet is, einddigd het hoofdprocess, en sluit de container. Nginx blijft draaien omdat het als webserver aan het wachten is op verzoeken. 

## 2. Je draaide docker run hello-world twee keer. Wat was er de tweede keer anders, en waarom?

Wanneer ik hello-world draaide voor de eerste keer, moest ik de image van hello-world nog downloaden. Dde tweede keer was de image al gedownload. Hierdoor was de 2de run sneller dan de 1ste run.

## 3. Bij ps aux in de container zag je maar een paar processen. Verklaar dat.

Containers hebben normaal een eigen PID namespace dat een beperkte overvieuw van processen is. Daardoor zien ze hun eigen processen, niet alle processen van mijn laptop. Daarom gebruikte ik ```docker top labo1-nginx``` op mijn laptop om de containerprocessen te bekijken. Ik heb dit moeten gebruiken omdat op de images van de container zelf, het ps commando niet stond.

## 4. /etc/os-release in de container toont een andere distributie dan je laptop. Toch draait die container op jouw machine. Hoe kan dat?

Op mijn laptop draai ik Arch. Elk image dat je download bevat een eigen bestandsysteem met bijvoorbeeld een Debian programma en library . Een container maakt geen eigen kernel, maar gebruikt de kernel van zijn docker host. De VM wordt gebruikt dus omdat ik Docker Desktop gebruik

## 5. Start twee nginx-containers tegelijk, allebei bereikbaar in je browser, op een andere poort. Welk commando gebruikte je? Waarom kan je niet twee keer dezelfde poort nemen?

- ```docker run -d --name labo1-nginx -p 8080:80 nginx```
- ```docker run -d --name labo1-nginx2 -p 8081:80 nginx```

Je kan beide containers op dezelfde interne poort gebruiken (80), omdat ze elk hun eigen netwerkruimte hebben, maar ik gebruik verschillende poorten zodat Docker zou weten naar welke poort welk verkeer gaat.

## 6. Zoek uit wat het verschil is tussen docker stop en docker kill .

- docker stop probeert het hoofdproces eerst mooi af te sluiten (met SIGTERM), en indien dat niet snel genoeg gebeurt volgens de wachttijd, dan word het signaal SIGKILL gebruikt.
- docker kill forceerdt het hoofdproces om meteen te eindigen door het SIGKILL signaal, SIGKILL is een soort van optie om ervoor te zorgen dat het proces dit niet kan opvangen, tegenhouden of handelen. Dit is meestal een last-resort indien het proces niet mooi wil afsluiten na al te hebben geprobeerd.

## 7. Hoeveel plaats nemen je images samen in? Zoek het commando dat je dat toont.
Door ```docker system df``` kan ik zien dat mijn images 243.2MB in nemen:

| TYPE          | TOTAL | ACTIVE | SIZE    | RECLAIMABLE |
| ------------- | ----- | ------ | ------- | ----------- |
| Images        | 2     | 2      | 243.2MB | 0B (0%)     |
| Containers    | 4     | 2      | 172kB   | 8.192kB (4%) |
| Local Volumes | 0     | 0      | 0B      | 0B          |
| Build Cache   | 0     | 0      | 0B      | 0B          |

(Dit is met de hello-world images die ik had proberen testen erbij.)