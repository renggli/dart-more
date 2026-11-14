# Spatial Datasets & Attribution

This visualizer uses open geospatial datasets for real-world R-Tree benchmarking.

## 1. Swiss Municipalities & Villages (`swiss_villages.json`)

- **Count:** 4,053 locations (villages, towns, and municipalities across Switzerland).
- **Source:** [Swiss Post](https://www.post.ch/) (Die Schweizerische Post) and [Swisstopo](https://www.swisstopo.admin.ch/) via the Swiss Federal Geoportal and [Open Government Data Switzerland (opendata.swiss)](https://opendata.swiss/).
- **License:** Freely usable under Open Government Data Switzerland / Creative Commons Zero (CC0).
- **Format:** `[{"name": "Village Name", "lat": 47.1234, "lon": 8.5678}, ...]`

## 2. World Populated Places (`world_cities.json`)

- **Count:** 7,342 major cities worldwide, ordered by population.
- **Source:** [Natural Earth](https://www.naturalearthdata.com/) (`ne_10m_populated_places_simple`).
- **License:** Public Domain.
- **Attribution:** Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.
- **Format:** `[{"name": "City Name", "lat": 35.6870, "lon": 139.7495}, ...]`
