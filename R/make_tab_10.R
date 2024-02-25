#' @title get_tab_10
#'
#' @description
#' Ordena los datos del Cuadro Nº 10 del Tomo II de los Resultados del Censo Nacional de 2017.
#'
#' Esta función permite organizar los datos del Cuadro Nº 10 del Tomo II de los
#' Resultados del Censo Nacional de 2017, el cual tiene el siguiente título:
#' "POBLACIÓN CENSADA, POR ALGUNA DIFICULTAD O LIMITACIÓN PERMANENTE, SEGÚN PROVINCIA,
#' DISTRITO, ÁREA URBANA Y RURAL, SEXO Y GRUPOS DE EDAD".
#'
#' @param file Ruta del archivo Excel del Tomo II de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#' @export
#'
get_tab_10 <- function(file, dep_name = NULL){

  suppressWarnings(
    df <- readxl::read_xlsx(file,
                            sheet = 5,
                            skip = 4,
                            col_names = FALSE) )
  df <- df |>
    dplyr::select(-2) |>
    purrr::set_names(paste0("var_", 1:8)) |>
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
      names_to = "dificultad",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |> as.numeric()) |>
    dplyr::mutate(dificultad = dplyr::case_when(
      dificultad == "var_2" ~ "Ver, aún usando anteojos",
      dificultad == "var_3" ~ "Oír, aún usando audífonos",
      dificultad == "var_4" ~ "Hablar o comunicarse, aún usando la lengua de señas u otro",
      dificultad == "var_5" ~ "Moverse o caminar para usar brazos y/o piernas",
      dificultad == "var_6" ~ "Entender o aprender (concentrarse y recordar)",
      dificultad == "var_7" ~ "Relacionarse con los demás por sus pensamientos, sentimientos, emociones o conductas",
      dificultad == "var_8" ~ "Ninguna"
    )) |>
    dplyr::rename(rango_etareo = var_1) |>
    dplyr::relocate(rango_etareo, .after = "sexo") |>
    dplyr::relocate(distrito, .after = "provincia") |>
    dplyr::mutate(dep_name = {{dep_name}}) |>
    dplyr::relocate(dep_name)
  return(df)
}
