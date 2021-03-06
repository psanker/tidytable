#' Nest data.tables
#'
#' @description
#' Nest data.tables by group
#'
#' Supports enhanced selection
#'
#' @param .data A data.frame or data.table
#' @param ... bare column names to group by. If empty nests the entire data.table
#' @param .key Name of the new column created by nesting
#'
#' @export
#'
#' @examples
#' test_df <- data.table::data.table(a = 1:10,
#'   b = 11:20,
#'   c = c(rep("a", 6), rep("b", 4)),
#'   d = c(rep("a", 4), rep("b", 6)))
#'
#' test_df %>%
#'   dt_group_nest()
#'
#' test_df %>%
#'   dt_group_nest(c, d)
#'
#' test_df %>%
#'   dt_group_nest(is.character)
dt_group_nest <- function(.data, ..., .key = "data") {
  if (!is.data.frame(.data)) stop(".data must be a data.frame or data.table")
  if (!is.data.table(.data)) .data <- as.data.table(.data)

  dots <- enexprs(...)

  if (length(dots) == 0) {
    .data <- eval_tidy(expr(.data[, list(data = list(.SD))]))

    .data <- .data %>%
      dt_rename(!!.key := data)
  } else {
    dots <- dots_selector(.data, ...)

    .data <- eval_tidy(expr(.data[, list(data = list(.SD)), by = list(!!!dots)]))

    .data <- .data %>%
      dt_rename(!!.key := data)
  }
  .data
}

