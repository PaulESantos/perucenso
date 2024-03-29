% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_tab_1s.R
\name{get_tab_1_salud}
\alias{get_tab_1_salud}
\title{get_tab_1_salud}
\usage{
get_tab_1_salud(file, dep_name = NULL)
}
\arguments{
\item{file}{Ruta del archivo Excel del Tomo II de los datos descargados desde la página del INEI
(https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).}

\item{dep_name}{Nombre del departamento al que pertenecen los datos.}
}
\value{
Un tibble con los datos ordenados en formato largo.
}
\description{
Esta función permite organizar los datos del Cuadro Nº 1 del Tomo II de los
Resultados del Censo Nacional de 2017, el cual tiene el siguiente título:
"POBLACIÓN CENSADA, POR AFILIACIÓN A ALGÚN TIPO DE SEGURO DE SALUD, SEGÚN PROVINCIA, DISTRITO,
ÁREA URBANA Y RURAL, SEXO Y GRUPOS DE EDAD".
}
