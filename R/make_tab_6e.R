#' @title get_tab_6_edu
#'
#' @description
#' Esta funcion permite organizar los datos del Cuadro 6 relacionado con el tema de educacion
#' del Tomo VI de los Resultados del Censo Nacional de 2017, el cual tiene el siguiente titulo:
#' "POBLACION CENSADA DE 5 Y MAS ANOS DE EDAD, POR NIVEL EDUCATIVO ALCANZADO, SEGUN
#' LUGAR DE RESIDENCIA PERMANENTE HACE CINCO ANOS, DENTRO Y FUERA DEL PAIS"
#'
#'
#' @param file Ruta del archivo Excel del Tomo VI de los datos descargados desde la pagina del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#' @export
#'

get_tab_6_edu <- function(file, dep_name = NULL){

  df <- readxl::read_xlsx(file,
                          sheet = 5,
                          skip = 4,
                          col_names = FALSE) |>
    dplyr::select(-2) |>
    purrr::set_names(paste0("var_", 1:11)) |>
    dplyr::filter(!stringr::str_detect(var_1, "^1/")) |>
    dplyr::mutate(departamento = dplyr::case_when(
      stringr::str_detect(var_1, "^DEP|^DPT") ~ var_1,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(departamento, .direction = "down") |>
    dplyr::relocate(departamento) |>
    dplyr::filter(!stringr::str_detect(var_1, "^DEP|^DPTO\\.|^REG")) |>
    dplyr::mutate(departamento = dplyr::case_when(
      stringr::str_detect(var_1, "^EX") ~ var_1,
      stringr::str_detect(var_1, "PROV\\.") ~ var_1,
      TRUE ~ departamento
    )) |>
    dplyr::mutate(departamento = dplyr::if_else(dplyr::row_number() == dplyr::n(),
                                                "EXTRANJERO",
                                                departamento)) |>
    dplyr::mutate(departamento = stringr::str_remove(departamento, "^DPTO\\.") |>
                    stringr::str_squish()) |>
    tidyr::pivot_longer(
      cols = var_2:var_11,
      names_to = "nivel_educacion",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |> as.numeric()) |>
    dplyr::mutate(nivel_educacion = dplyr::case_when(
      nivel_educacion == "var_2" ~ "Sin nivel",
      nivel_educacion == "var_3" ~ "Inicial",
      nivel_educacion == "var_4" ~ "Primaria",
      nivel_educacion == "var_5" ~ "Secundaria",
      nivel_educacion == "var_6" ~ "Basica especial",
      nivel_educacion == "var_7" ~ "Sup. no univ. incompleta",
      nivel_educacion == "var_8" ~ "Sup. no univ. completa",
      nivel_educacion == "var_9" ~ "Sup. univ. incompleta",
      nivel_educacion == "var_10" ~ "Sup. univ. completa",
      nivel_educacion == "var_11" ~ "Maestria / Doctorado",
    )) |>
    dplyr::filter(!is.na(poblacion)) |>
    dplyr::mutate(var_1 = stringr::str_remove_all(var_1,
                                                  "PROVINCIA DE|PROVINCIA|1\\/") |>
                    stringr::str_squish()) |>
    dplyr::rename(provincia = var_1) |>
    dplyr::relocate(provincia, .after = "departamento") |>
    dplyr::mutate(dep_name = {{dep_name}}) |>
    dplyr::relocate(dep_name)
  return(df)
}
