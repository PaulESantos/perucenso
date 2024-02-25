

# get_tab_8

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/make_tab_8.R#L18)

## Description

Ordena los datos del Cuadro Nº 8 del Tomo II de los Resultados del Censo
Nacional de 2017.

Esta función permite organizar los datos del Cuadro Nº 8 del Tomo II de
los Resultados del Censo Nacional de 2017, el cual tiene el siguiente
título: POBLACIÓN CENSADA DE 5 Y MÁS AÑOS DE EDAD, POR SEXO Y GRUPOS DE
EDAD, SEGÚN LUGAR DE RESIDENCIA PERMANENTE HACE CINCO AÑOS, DENTRO Y
FUERA DEL PAÍS

## Usage

<pre><code class='language-R'>get_tab_8(file, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_8_:_file">file</code>
</td>
<td>
Ruta del archivo Excel del Tomo II de los datos descargados desde la
página del INEI
(https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_8_:_dep_name">dep_name</code>
</td>
<td>
Nombre del departamento al que pertenecen los datos.
</td>
</tr>
</table>

## Value

Un tibble con los datos ordenados en formato largo.
