% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_tab_6e.R
\name{get_tab_6_edu}
\alias{get_tab_6_edu}
\title{get_tab_6_edu}
\usage{
get_tab_6_edu(file, dep_name = NULL)
}
\arguments{
\item{file}{Ruta del archivo Excel del Tomo VI de los datos descargados desde la pagina del INEI
(https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).}

\item{dep_name}{Nombre del departamento al que pertenecen los datos.}
}
\value{
Un tibble con los datos ordenados en formato largo.
}
\description{
Esta funcion permite organizar los datos del Cuadro 6 relacionado con el tema de educacion
del Tomo VI de los Resultados del Censo Nacional de 2017, el cual tiene el siguiente titulo:
"POBLACION CENSADA DE 5 Y MAS ANOS DE EDAD, POR NIVEL EDUCATIVO ALCANZADO, SEGUN
LUGAR DE RESIDENCIA PERMANENTE HACE CINCO ANOS, DENTRO Y FUERA DEL PAIS"
}
