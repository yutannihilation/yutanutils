#' Utilities for 'sf'
#'
#' @name sf-utils
#' @param x sf object.
#' @param col_names Column names.
#'
#' @examples
#' points_sfc <- sf::st_sfc(
#'   sf::st_point(c(1, 1)),
#'   sf::st_point(c(2, 2))
#' )
#'
#' points_sf <- sf::st_sf(
#'   value = c(10, 20),
#'   geometry = points_sfc
#' )
#'
#' st_add_point_coordinates(points_sf)
#' st_add_point_coordinates(points_sf, col_names = c("long", "lat"))
NULL

#' @rdname sf-utils
#' @export
st_add_point_coordinates <- function(x, col_names = NULL) {
  if (!inherits(x, "sf")) stop("x is not a sf object!")

  x_sfc <- sf::st_geometry(x)

  coordinates <- sf::st_coordinates(x_sfc)
  if (!is.null(col_names)) {
    colnames(coordinates)[seq_along(col_names)] <- col_names
  }

  cbind(x, coordinates)
}
