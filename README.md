# Influence of state subsidies and local conditions on the development of public EV charging infrastructure within Europe.
## Case Study Research on the example of France, Germany and Italy

<table>
  <tr>
    <td><b>Index:</b><br>
      <a href="https://github.com/realkemon/thesis/blob/main/README.md">Home</a><br>
      <ul>
        <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#preamble">Preamble</a></li>
        <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#procedure">Procedure</a></li>
        <ul>
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#1-removing-undesired-localities">1. Removing undesired localities</a></li>
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#2-specifying-appropriate-CRS">2. Specifying appropriate CRS</a></li>
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#3-simplifying geometries">3. Enforcing geometric validity</a></li>
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#3-simplifying geometries">4. Simplifying geometries</a></li>
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#4-removing-redundant-localities">5. Removing redundant localities</a></li>
        </ul>
      </ul>
    </td>
  </tr>
</table>

---

<a href="https://www.uni-bamberg.de/en/"><img src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/logo-uni-blau.png" alt="University of Bamberg" width="256"/></a>

## Preamble
This repository contains the Master's Thesis of my *'Information Systems'* M.Sc. degree programme. As part of that thesis, I built a framework in *'R'* that enables the automatic categorisation of any desired longitude/latitude locations based on their individual surrounding features in [OpenStreetMap](https://www.openstreetmap.org). In the thesis, the desired locations are charging stations for electric vehicles in Germany, France and Italy as provided by [Open Charge Map](https://openchargemap.org/site). The goal was to categorise these charging stations and compare them with the respective country's subsidy programme. In other words: investigate which surrounding locality features exist for each charging station in the [OpenStreetMap](https://www.openstreetmap.org) database, make an assumption towards the location category *(e.g. in residential areas, rest stop along motorways, etc.)*, investigate how each location category evolves over the years and compare that evolution with the timeframe of state subsidy programmes. This enables the drawing of conclusions regarding which category of charging stations are impacted by state subsidies and which categories evolve independently.<br>
This framework is universally applicable and does not depend on the kind of locations you want to investigate. However, there was no time to build a UI for it, so it will require manual adjustments in the code. To simplify that, I provided the [thesis itself](https://github.com/realkemon/thesis/blob/main/Thesis.pdf) in this repository for an exhaustive explanation and will try to explain the procedure in general below.

## Procedure
The framework relies on [OpenStreetMap](https://www.openstreetmap.org) exports provided by [

](http://download.geofabrik.de/) for the most comprehensive database of local features. Those exports are preferred, because they are provided in a uniform, consistent and well-structured manner and are pre-filtered to reduce noice. The datasets for Germany, France and Italy are downloaded automatically in the code and go through various cleaning and preparation stages.

### 1. Removing undesired localities
This stage is based on the [feature catalogue](https://github.com/realkemon/thesis/blob/main/feature_catalogue.R) which, in turn, is based on [this documentation](http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf) *(version 7 from 2019-05-21)*. This catalogue contains all possible local features included in the [Geofabrik](http://download.geofabrik.de/) exports and further includes a **group** value for each possible local feature, which defaults to **0**. If a feature is undesired, it is specified as group: **NA** and subsequently dropped from the dataset. This can be due to the following reasons:

<table>
  <tr>
    <td><b>NO_TARGET</b></td>
    <td>feature unlikely to be target of car ride or duration of stay/use doesn't facilitate a charging event.</td>
    <td>e.g. <i>'public_telephone'</i>, <i>'misc_bench'</i></td>
  </tr>
  <tr>
    <td><b>NO_IMPLICATION</b></td>
    <td>feature doesn't provide any useful information on the location. <i>(e.g. demographic, economics, etc.)</i></td>
    <td>e.g. <i>'places_region'</i>, <i>'natural_tree'</i></td>
  </tr>
  <tr>
    <td><b>NO_ACCESS</b></td>
    <td>feature generally not accessible to the public or does not provide (public) parking.</td>
    <td>e.g. <i>'railways_rail'</i>, <i>'landuse_military'</i></td>
  </tr>
  <tr>
    <td><b>TEMPORARY</b></td>
    <td>feature is likely to be only temporary.</td>
    <td>e.g. <i>'tourism_archaeological'</i>, <i>'building_construction'</i></td>
  </tr>
</table>


> Other values for **group** can be possible for localities that are semantic duplicates like <i>'building_public'</i>, <i>'public_public_building'</i>, <i>'building_civic'</i>, <i>'building_government'</i>.

### 2. Specifying appropriate CRS

<a href="https://epsg.io/4839"><img align="left" src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/EPSG4839.png" width="256"/></a>
By default, all geometries are <i>unprojected</i> and formatted in the <a href="https://epsg.io/4326">'World Geodetic System from 1984'</a>. For easier processing, the geometries are converted to a <i>projected</i> Coordinate Reference System. As all considered countries are in mainland Europe, the decision fell on the <a href="https://epsg.io/4839">'European Terrestrial Reference System from 1989'</a>, which specifies <i>metres</i> as the base unit simplifying future processing. Depending on the countries of your choosing, a different CRS might be necessary, which can be found in the <a href="https://epsg.io/">EPSG Geodetic Parameter Database</a>.
> For more information about the difference between projected and unprojected, please refer to [this article](https://www.esri.com/arcgis-blog/products/arcgis-pro/mapping/gcs_vs_pcs/). 

### 3. Enforcing geometric validity
On one occasion a [Geofabrik](http://download.geofabrik.de/) dataset contained an invalid geometry which caused the error below and subsequently crashed the framework. Therefore, before conducting geometric calculations, the validity of all geometries is enforced in this stage.
```
Error in CPL geos binop(st geometry(x), st geometry(y), op, par, pattern, : Evaluation error: TopologyException: side location conflict at [LONGITUDE] [LATITUDE]
```

### 4. Simplifying geometries
This is an optional stage in the preparation procedure and can be enabled if the amount of geometries becomes unbearably large or memory limits are reached.

<a href="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/geometry_original.png"><img align="left" src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/geometry_original.png" width="256"/></a>
<a href="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/geometry_simplified.png"><img align="right" src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/geometry_simplified.png" width="256"/></a>
Depending on the radius around the desired longitude/latitude locations in which local features are used for the categorisation, the amount of geometries can be overwhelming and their 'resolution' overly detailed. Therefore, the geometric shape can be simplified by reducing the number of vertices defining the polygon with a certain distance threshold.
> The images provide an example of this simplification in action for the <i>'Zoologische Stadtgarten'</i> in Karlsruhe, Germany with a distance threshold of 75 metres.

### 5. Removing redundant geometries
This stage relies on the semantic grouping, which was already hinted at in the first preparation stage. Some locality features are semantically similar and since [OpenStreetMap](https://www.openstreetmap.org) is a community project, different contributors might have different ways of filing localities, leading to one locality feature being represented by multiple instances with different specifications. For example, a city's town hall can be either <i>'building_public'</i>, <i>'public_public_building'</i>, <i>'building_civic'</i> or <i>'building_government'</i>. Therefore, semantic groups are defined in the [feature catalogue](https://github.com/realkemon/thesis/blob/main/feature_catalogue.R) to remove (semantic) duplicates.

<a href="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/polygon_nolabel.png"><img align="left" src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/polygon_nolabel.png" width="256"/></a>
<a href="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/polygon_label.png"><img align="right" src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/polygon_label.png" width="256"/></a>
Another aspect is that [OpenStreetMap](https://www.openstreetmap.org) generates label points for polygon geometries at which the title is printed on the map. This is visible on the example of the city of Cottbus, Germany in the images to the side. Both the polygon shape and the label point are filed as a city in the [OpenStreetMap](https://www.openstreetmap.org) database, which leads the framework to assuming that a charging station in Cottbus is in the vicinity of two cities instead of one. Therefore, all point labels that intersect with a polygon geometry of the same class are considered to be label points and dropped from the dataset.
