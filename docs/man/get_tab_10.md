

# Obtener datos del cuadro de población censada por alguna dificultad o limitación permanente

## Description

Esta función lee y procesa los datos del cuadro de población censada por
alguna dificultad o limitación permanente, según provincia, distrito,
área urbana y rural, sexo y grupos de edad.

## Usage

<pre><code class='language-R'>get_tab_10(file, sheet = 5, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_10_:_file">file</code>
</td>
<td>
Ruta del archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_10_:_sheet">sheet</code>
</td>
<td>
Número de la hoja en el archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_10_:_dep_name">dep_name</code>
</td>
<td>
Nombre del departamento.
</td>
</tr>
</table>

## Value

Un tibble con los datos procesados.
