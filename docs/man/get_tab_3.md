

# Ordenar datos del cuadro de poblacion censada en viviendas particulares

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/make_tab_3.R#L15)

## Description

Esta función procesa y ordena adecuadamente los datos obtenidos del
cuadro "POBLACION CENSADA EN VIVIENDAS PARTICULARES, POR GRUPOS DE
EDAD", presentado en el Censo Poblacional del Peru 2017.

## Usage

<pre><code class='language-R'>get_tab_3(file, sheet, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_3_:_file">file</code>
</td>
<td>
Ruta del archivo de Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_3_:_sheet">sheet</code>
</td>
<td>
Numero de la hoja de Excel que contiene los datos del cuadro.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_3_:_dep_name">dep_name</code>
</td>
<td>
Nombre del departamento al que pertenecen los datos.
</td>
</tr>
</table>

## Value

Un tibble ordenado con la informacion procesada.

## Examples

``` r
library(perucenso)

df <- get_tab_3("rawdata/08TOMO_01.xlsx", sheet = 3)
```
