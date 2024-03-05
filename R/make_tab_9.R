#' @title get_tab_9
#'
#' @description
#' Ordena los datos del Cuadro N 9 del Tomo II de los Resultados del Censo Nacional de 2017.
#'
#' Esta funcion permite organizar los datos del Cuadro N 9 del Tomo II de los
#' Resultados del Censo Nacional de 2017, el cual tiene el siguiente título:
#' "POBLACION CENSADA, POR SEXO Y GRUPOS DE EDAD, SEGUN LUGAR DE RESIDENCIA DE LA
#' MADRE DENTRO Y FUERA DEL PAÍS CUANDO USTED NACIÓ"
#' @param file Ruta del archivo Excel del Tomo II de los datos descargados desde la pagina del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#' @export
#'
get_tab_9 <- function(file, dep_name = NULL){

  df <- readxl::read_xlsx(file,
                          sheet = 4,
                          skip = 4,
                          col_names = FALSE) |>
    dplyr::select(-c(2, 5)) |>
    purrr::set_names(c(
      "residencia",
      "Hombres",
      "Mujeres",
      "Menores de 1",
      "5 a 14",
      "15 a 29",
      "30 a 44",
      "45 a 64",
      "65 y mas"
    ) |>
      janitor::make_clean_names()) |>
    dplyr::filter(!stringr::str_detect(residencia, "^1/")) |>
    dplyr::mutate(departamento = dplyr::case_when(
      stringr::str_detect(residencia, "^DEP|^DPT") ~ residencia,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(departamento, .direction = "down") |>
    dplyr::relocate(departamento) |>
    dplyr::filter(!stringr::str_detect(residencia, "^DEP|^DPTO\\.|^REG")) |>
    dplyr::mutate(departamento = dplyr::case_when(
      stringr::str_detect(residencia, "^EX") ~ residencia,
      stringr::str_detect(residencia, "PROV\\.") ~ residencia,
      TRUE ~ departamento
    )) |>
    dplyr::mutate(departamento = dplyr::if_else(dplyr::row_number() == dplyr::n(),
                                                "EXTRANJERO",
                                                departamento)) |>
    dplyr::mutate(departamento = stringr::str_remove(departamento, "^DPTO\\.") |>
                    stringr::str_squish()) |>
    dplyr::mutate(dplyr::across(
      .cols = hombres:x65_y_mas_anos,
      ~ dplyr::if_else(. == "-", "0", .) |> as.numeric()
    )) |>
    tidyr::pivot_longer(
      cols = hombres:x65_y_mas_anos,
      names_to = "varname",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(tipo = dplyr::case_when(
      varname %in% c("hombres", "mujeres") ~ "sexo",
      TRUE ~ "rango etareo"
    )) |>
    dplyr::mutate(varname = stringr::str_replace(varname, "^x", "") |>
                    stringr::str_replace_all("_", " ")) |>
    dplyr::mutate(dplyr::across(
      .cols = c(varname, tipo),
      ~ stringr::str_to_sentence(.)
    )) |>
    dplyr::mutate(residencia = stringr::str_remove_all(residencia,
                                                       "PROVINCIA DE|PROVINCIA|1\\/") |>
                    stringr::str_squish()) |>
    dplyr::mutate(dep_name = {{dep_name}}) |>
    dplyr::relocate(dep_name)
  return(df)
}
