# Dashboard za pregledavanje isplata iz proračuna Grada Bjelovara

## Uvod

Ovaj projekt nastao je tijekom Dana otvorenih podataka 2020. Cilj je bio
napraviti nekakvu web aplikaciju koja će nadopuniti funkcionalnost koju nudi
(aplikacija)[https://transparentnost.bjelovar.hr/] koju je na raspolaganje
stavio Grad Bjelovar. Web aplikacija se trenutno može naći
(ovdje)[https://dvlasicek.shinyapps.io/proracun-bjelovar/].

Za potrebe izrade ove aplikacije nastala je i objedinjena baza isplata iz
proračuna od 2018. do 20202. Baza (u obliku CSV datoteke), prikupljena
putem API-ja Grada, se može pronaći pod `data/raw`.

## Struktura repozitorija

- `data/`: ovdje se nalaze podaci o isplatama iz proračuna, te skripta korištena
    za njihovo preuzimanje
- `shiny-app/proracun-bjelovar`: folder s datotekama korištenima za izradu web
    `Shiny` aplikacije
- `wrangling`: skripta korištena za pripremu podataka za aplikaciju

## Licenca

Svi materijali pokriveni su CC0 licencom, dakle mogu se slobodno koristiti:

<p xmlns:dct="http://purl.org/dc/terms/">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <span resource="[_:publisher]" rel="dct:publisher">
    <span property="dct:title">Denis Vlašiček</span></span>
  has waived all copyright and related or neighboring rights to
  this work.
</p>
