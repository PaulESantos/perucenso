#' @title get_tab_1
#'
#' @description
#'
#' Esta función permite organizar los datos del Cuadro Nº 1 del Tomo I de los Resultados del Censo Nacional de 2017,
#' el cual tiene el siguiente título: "POBLACIÓN CENSADA, POR ÁREA URBANA Y RURAL;
#' Y SEXO, SEGÚN PROVINCIA, DISTRITO Y EDADES SIMPLES"
#'
#' @param file Ruta del archivo Excel del Tomo I de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#'
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#'
#' @export
get_tab_1 <- function(file, dep_name = NULL) {

  suppressMessages(df <- readxl::read_excel(file,
                                            sheet = 1,
                                            skip = 4,
                                            col_names = FALSE) |>
                     dplyr::select(1, 6, 7, 9, 10) |>
                     purrr::set_names(c("edad", "varon_urbano", "mujer_urbano",
                                        "varon_rural", "mujer_rural")))
  df |>
    dplyr::filter(!is.na(edad)) |>
    dplyr::filter(!stringr::str_detect(edad, "^De")) |>
    dplyr::mutate(tag = dplyr::if_else(stringr::str_detect(edad, "^Menor"),
                                       dplyr::lag(edad),
                                       NA_character_)) |>
    tidyr::fill(tag, .direction = "down") |>
    dplyr::filter(!is.na(tag)) |>
    dplyr::filter(!stringr::str_detect(edad, "^PROVINCIA|^DISTRITO")) |>
    dplyr::mutate(distrito =  dplyr::if_else(stringr::str_detect(tag, "DISTRITO"),
                                             tag,
                                             NA_character_),
                  provincia =  dplyr::if_else(stringr::str_detect(tag, "PROVINCIA"),
                                              tag,
                                              NA_character_)) |>
    tidyr::fill(provincia, .direction = "down") |>
    dplyr::filter(!is.na(distrito)) |>
    dplyr::mutate(distrito = stringr::str_remove(distrito,
                                                 "DISTRITO "),
                  provincia = stringr::str_remove(provincia,
                                                  "PROVINCIA ")) |>
    tidyr::pivot_longer(cols = varon_urbano: mujer_rural,
                        names_to = "sexo_1",
                        values_to = "poblacion") |>
    dplyr::mutate(sexo = stringr.plus::str_extract_before(sexo_1, "_"),
                  distribucion = stringr.plus::str_extract_after(sexo_1, "_")) |>
    dplyr::select(provincia, distrito, distribucion, sexo, edad, poblacion) |>
    dplyr::mutate(departamento = {{dep_name}}) |>
    dplyr::relocate(departamento) |>
    dplyr::mutate(poblacion = dplyr::if_else(
      stringr::str_detect(poblacion,"-"),
      NA_character_,
      poblacion
    ) |>
      as.numeric())

}
