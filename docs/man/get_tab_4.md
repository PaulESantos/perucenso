

# Procesar datos del cuadro de población censada en viviendas particulares

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/make_tab_4.R#L15)

## Description

Esta función lee y procesa los datos del cuadro de población censada en
viviendas particulares, según provincia, distrito, área urbana y rural,
sexo y relación de parentesco con el jefe o jefa del hogar.

## Usage

<pre><code class='language-R'>get_tab_4(file, sheet, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_4_:_file">file</code>
</td>
<td>
Ruta del archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_4_:_sheet">sheet</code>
</td>
<td>
Número de la hoja en el archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_4_:_dep_name">dep_name</code>
</td>
<td>
Nombre del departamento al que pertenecen los datos.
</td>
</tr>
</table>

## Value

Un tibble con los datos procesados.

## Examples

``` r
library(perucenso)

df <-  get_tab_4("rawdata/08TOMO_01.xlsx", sheet = 4)
```
