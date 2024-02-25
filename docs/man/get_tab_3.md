

# get_tab_3

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/make_tab_3.R#L21)

## Description

Esta función permite organizar los datos del Cuadro Nº 3 del Tomo I de
los Resultados del Censo Nacional de 2017, el cual tiene el siguiente
título: "POBLACION CENSADA EN VIVIENDAS PARTICULARES, POR GRUPOS DE EDAD

## Usage

<pre><code class='language-R'>get_tab_3(file, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_3_:_file">file</code>
</td>
<td>
Ruta del archivo Excel del Tomo I de los datos descargados desde la
página del INEI
(https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
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

df <- get_tab_3("rawdata/08TOMO_01.xlsx", dep_name = "CUSCO")
```
