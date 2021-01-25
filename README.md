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
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#removing-undesired-localities">Removing undesired localities</a></li>
          <li><a href="https://github.com/realkemon/thesis/blob/main/README.md#specifying-appropriate-CRS">Specifying appropriate CRS</a></li>
        </ul>
      </ul>
    </td>
  </tr>
</table>

---

<img src="https://raw.githubusercontent.com/realkemon/thesis/main/gfx/logo-uni-blau.png" alt="University of Bamberg" width="256"/> 

## Preamble
This repository contains the Master's Thesis of my *'Information Systems'* M.Sc. degree programme. As part of that thesis, I built a framework in *'R'* that enables the automatic categorisation of any desired longitude/latitude locations based on their individual surrounding features in [OpenStreetMap](https://www.openstreetmap.org). In the thesis, the desired locations are charging stations for electric vehicles in Germany, France and Italy as provided by [Open Charge Map](https://openchargemap.org/site). The goal was to categorise these charging stations and compare them with the respective country's subsidy programme. In other words, check which categories of charging stations exist *(e.g. in residential areas, near motorways, etc.)*, investigate how they evolve over the years and compare that evolution with the timeframe of state subsidy programmes. This enables the drawing of conclusions regarding which category of charging stations are impacted by state subsidies and which categories evolve independently.<br>
This framework is universally applicable and does not depend on the kind of locations you want to investigate. However, there was no time to build a UI for it, so it will require manual adjustments in the code. To simplify that, I provided the thesis in this repository for an exhaustive explanation and will try to explain the procedure in general below.

## Procedure
The framework relies on [OpenStreetMap](https://www.openstreetmap.org) exports provided by [Geofabrik](http://download.geofabrik.de/) for the most comprehensive database of local features. Those exports are preferred, because they are provided in a uniform, consistent and well-structured manner and are pre-filtered to reduce noice. The datasets for Germany, France and Italy are downloaded automatically in the code and go through various cleaning and preparation stages.

### Removing undesired localities
This step is based on the [feature catalogue](https://github.com/realkemon/thesis/blob/main/feature_catalogue.R) which, in turn, is based on [this documentation](http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf) *(version 7 from 2019-05-21)*. This catalogue includes a **group** value for each possible locality. By default, all possible localities are in group: **0**. If a feature is undesired, it is specified as group: **NA** and subsequently dropped. This can be due to the following reasons:

<table>
  <tr>
    <td><b>NO_TARGET:</b></td>
    <td>feature unlikely to be target of car ride or duration of stay/use doesn't facilitate a charging event.</td>
    <td>e.g. <i>'public_telephone'</i>, <i>'misc_bench'</i></td>
  </tr>
  <tr>
    <td><b>NO_IMPLICATION:</b></td>
    <td>feature doesn't provide any useful information on the location. <i>(e.g. demographic, economics, etc.)</i></td>
    <td>e.g. <i>'places_region'</i>, <i>'natural_tree'</i></td>
  </tr>
  <tr>
    <td><b>NO_ACCESS:</b></td>
    <td>feature generally not accessible to the public or does not provide (public) parking.</td>
    <td>e.g. <i>'railways_rail'</i>, <i>'landuse_military'</i></td>
  </tr>
  <tr>
    <td><b>TEMPORARY:</b></td>
    <td>feature is likely to be only temporary.</td>
    <td>e.g. <i>'tourism_archaeological'</i>, <i>'building_construction'</i></td>
  </tr>
</table>

> Other values for **group** can be possible for localities that are semantic duplicates like <i>'building_public'</i>, <i>'public_public_building'</i>, <i>'building_civic'</i>, <i>'building_government'</i>. Adjust 'feature_catalogue.R' to fit your needs. To disable semantic grouping and removal of features, set all localities to group: <b>0</b>.

### Specifying appropriate CRS
