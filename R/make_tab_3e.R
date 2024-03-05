#' @title get_tab_3_edu
#'
#' @description
#' Esta funcion permite organizar los datos del Cuadro 3 relacionado con el tema de educacion
#' del Tomo VI de los Resultados del Censo Nacional de 2017, el cual tiene el siguiente titulo:
#' "POBLACION CENSADA DE 3 Y MAS ANOS DE EDAD, POR GRUPOS DE EDAD, SEGUN PROVINCIA, DISTRITO,
#' AREA URBANA Y RURAL, SEXO Y NIVEL EDUCATIVO ALCANZADO"
#'
#' @param file Ruta del archivo Excel del Tomo VI de los datos descargados desde la pagina del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#' @export
get_tab_3_edu <- function(file, dep_name = NULL){
  df <- readxl::read_xlsx(file,
                          sheet = 2,
                          skip = 4,
                          col_names = FALSE) |>
    dplyr::select(-2) |>
    purrr::set_names(paste0("var_", 1:9)) |>
    dplyr::filter(!stringr::str_detect(var_1, "^Fuente:")) |>
    dplyr::mutate(distrito = dplyr::if_else(stringr::str_detect(var_1, "^DISTRITO"),
                                            var_1,
                                            NA_character_)) |>
    dplyr::mutate(provincia = dplyr::if_else(stringr::str_detect(var_1, "^PROVINCIA"),
                                             var_1,
                                             NA_character_)) |>
    dplyr::mutate(tag = dplyr::case_when(
      stringr::str_detect(var_1, "DISTRITO") ~ var_1,
      stringr::str_detect(var_1, "PROVINCIA") ~ var_1,
      stringr::str_detect(var_1, "DEPARTA") ~ var_1,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(tag, .direction = "down") |>
    tidyr::fill(provincia, .direction = "down") |>
    tidyr::fill(distrito, .direction = "down") |>
    dplyr::mutate(distribucion = dplyr::case_when(
      stringr::str_detect(var_1, "^URBANA") ~ var_1,
      stringr::str_detect(var_1, "^RURAL") ~ var_1,
      stringr::str_detect(var_1, "^DISTRITO") ~ var_1,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(distribucion, .direction = "down") |>
    dplyr::mutate(sexo = dplyr::case_when(
      stringr::str_detect(var_1, "^Hombres") ~ var_1,
      stringr::str_detect(var_1, "^Mujeres") ~ var_1,
      stringr::str_detect(var_1, "^URBANA") ~ var_1,
      stringr::str_detect(var_1, "^RURAL") ~ var_1,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(sexo, .direction = "down") |>
    dplyr::filter(!is.na(distrito)) |>
    dplyr::filter(distribucion %in% c("URBANA", "RURAL")) |>
    dplyr::filter(!is.na(var_1)) |>
    dplyr::filter(sexo %in% c("Hombres", "Mujeres")) |>
    dplyr::filter(var_1 != sexo) |>
    dplyr::filter(stringr::str_detect(tag, "^DISTRITO")) |>
    dplyr::mutate(
      provincia = stringr::str_remove(provincia, "PROVINCIA "),
      distrito = stringr::str_remove(distrito, "^DISTRITO ")
    ) |>
    dplyr::mutate_all(as.character) |>
    dplyr::select(-tag) |>
    tidyr::pivot_longer(
      -c(provincia, distrito, distribucion, sexo, var_1),
      names_to = "rango_etareo",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |> as.numeric()) |>
    dplyr::mutate(rango_etareo = dplyr::case_when(
      rango_etareo == "var_2" ~ "3 a 4",
      rango_etareo == "var_3" ~ "5 a 9",
      rango_etareo == "var_4" ~ "10 a 14",
      rango_etareo == "var_5" ~ "15 a 19",
      rango_etareo == "var_6" ~ "20 a 29",
      rango_etareo == "var_7" ~ "30 a 39",
      rango_etareo == "var_8" ~ "40 a 64",
      rango_etareo == "var_9" ~ "65 a mas"
    )) |>
    dplyr::rename(nivel_educacion = var_1) |>
    dplyr::relocate(nivel_educacion, .after = "rango_etareo") |>
    dplyr::relocate(distrito, .after = "provincia") |>
    dplyr::mutate(departamento = {{dep_name}}) |>
    dplyr::relocate(departamento)
  return(df)
}
