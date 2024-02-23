

# Procesar datos del cuadro de poblacion censada por sexo y grupos de edad

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/make_tab_7.R#L16)

## Description

Esta funcion lee y procesa los datos del cuadro de poblacion censada por
sexo y grupos de edad, según lugar de residencia permanente dentro y
fuera del país.

## Usage

<pre><code class='language-R'>get_tab_7(file, sheet, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_7_:_file">file</code>
</td>
<td>
Ruta del archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_7_:_sheet">sheet</code>
</td>
<td>
Numero de la hoja en el archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_7_:_dep_name">dep_name</code>
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

df <- get_tab_7("rawdata/08TOMO_02.xlsx", sheet = 2, skip = 4)
```
