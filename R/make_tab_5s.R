#' @title get_tab_5_salud
#'
#' @description
#' Esta funcion permite organizar los datos del Cuadro 5  relacionado con el tema de salud
#' del Tomo III de los Resultados del Censo Nacional de 2017, el cual tiene el siguiente título:
#' " POBLACION CENSADA DE 3 Y MAS ANOS DE EDAD, POR AFILIACION A ALGUN TIPO DE SEGURO DE SALUD,
#'  SEGUN PROVINCIA, DISTRITO, AREA URBANA Y RURAL, SEXO Y NIVEL EDUCATIVO ALCANZADO".
#'
#' @param file Ruta del archivo Excel del Tomo III de los datos descargados desde la pagina del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#' @export
get_tab_5_salud <- function(file, dep_name = NULL){
  df <- readxl::read_xlsx(file,
                          sheet = 2,
                          skip = 4,
                          col_names = FALSE) |>
    dplyr::select(-2) |>
    purrr::set_names(paste0("var_", 1:7)) |>
    dplyr::filter(!stringr::str_detect(var_1, "^Nota:")) |>
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
      names_to = "tipo_seguro",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |> as.numeric()) |>
    dplyr::mutate(tipo_seguro = dplyr::case_when(
      tipo_seguro == "var_2" ~ "Seguro Integral de Salud (SIS)",
      tipo_seguro == "var_3" ~ "ESSALUD",
      tipo_seguro == "var_4" ~ "Seguro de fuerzas armadas o policiales",
      tipo_seguro == "var_5" ~ "Seguro privado de salud",
      tipo_seguro == "var_6" ~ "Otro seguro",
      tipo_seguro == "var_7" ~ "Ninguno"
    )) |>
    dplyr::rename(nivel_educativo = var_1) |>
    dplyr::relocate(nivel_educativo, .after = "tipo_seguro") |>
    dplyr::relocate(distrito, .after = "provincia") |>
    dplyr::mutate(departamento = {{dep_name}}) |>
    dplyr::relocate(departamento)
  return(df)
}
