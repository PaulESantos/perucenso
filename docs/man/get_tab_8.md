

# Procesar datos del cuadro de población censada de 5 y más años de edad por sexo y grupos de edad

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/#L)

## Description

Esta función lee y procesa los datos del cuadro de población censada de
5 y más años de edad por sexo y grupos de edad, según lugar de
residencia permanente hace cinco años, dentro y fuera del país.

## Usage

<pre><code class='language-R'>get_tab_8(file, sheet, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_8_:_file">file</code>
</td>
<td>
Ruta del archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_8_:_sheet">sheet</code>
</td>
<td>
Número de la hoja en el archivo Excel que contiene los datos.
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

Un tibble con los datos procesados.