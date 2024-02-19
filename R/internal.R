#' Agregar repeticiones basadas en expresiones regulares
#'
#' Esta función busca valores que coinciden con un patrón de expresión regular en una columna de un dataframe
#' y agrega repeticiones de esos valores en una nueva columna.
#'
#' @param data El dataframe original.
#' @param column_name El nombre de la columna donde se realizará la búsqueda.
#' @param regex_pattern El patrón de expresión regular a buscar en la columna especificada.
#' @param n_repetitions El número de repeticiones que se agregarán después de cada coincidencia.
#' @param new_column_name El nombre de la nueva columna donde se agregarán las repeticiones.
#' @return El dataframe resultante con la nueva columna agregada.
#' @examples
#' \dontrun{
#' df <-  tibble::tibble(
#'   var1 = c("a_1", "d", "d", "a_2", "d", "f", "a_3", "g", "u")
#' )
#' df_result <- add_repetitions_regex(df, "var1", "^(a|f)", 2, "new_var")
#' print(df_result)
#' }
#' @importFrom rlang `:=`
#' @keywords internal
add_repetitions_regex <- function(data, column_name, regex_pattern, n_repetitions, new_column_name) {
  # Copiar el dataframe original
  df <- data

  # Crear la nueva variable y establecer valores en NULL
  df <- df |>
    dplyr::mutate(!!new_column_name := NA_character_)

  # Iterar sobre las filas y asignar los valores según la condición
  for (i in seq_len(nrow(df))) {
    if (grepl(regex_pattern, df[[column_name]][i])) {
      for (j in 1:n_repetitions) {
        if ((i + j) <= nrow(df)) {
          df <- df |>
            dplyr::mutate(!!new_column_name := dplyr::if_else(dplyr::row_number() == (i + j),
                                                              df[[column_name]][i],
                                                              !!dplyr::sym(new_column_name)))
        }
      }
    }
  }

  # Devolver el dataframe resultante
  return(df)
}
