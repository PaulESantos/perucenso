

# Procesar datos del cuadro de población censada por tenencia de documento de identidad

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/#L)

## Description

Esta función lee y procesa los datos del cuadro de población censada por
tenencia de algún tipo de documento de identidad, según provincia,
distrito, área urbana y rural, grupos de edad y sexo.

## Usage

<pre><code class='language-R'>get_tab_5(file, sheet, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_5_:_file">file</code>
</td>
<td>
Ruta del archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_5_:_sheet">sheet</code>
</td>
<td>
Número de la hoja en el archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_5_:_dep_name">dep_name</code>
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

df <- process_identity_data("rawdata/08TOMO_01.xlsx", sheet = 5, )
```
