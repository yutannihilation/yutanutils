#' Utilities for 'sf'
#'
#' @name sf-utils
#' @param x sf object.
#' @param col_names Column names.
#' @param fun Function to calcuate POINT from the geometry.
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
#' # For POINT, add the coordinates of the points.
#' st_add_coordinates(points_sf)
#' st_add_coordinates(points_sf, col_names = c("long", "lat"))
#'
#' # For other features, add the coordinates of the centroids of them.
#' nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' st_add_coordinates(nc)
#'
#' # You can specify other functions that return one POINT per geometry.
#' st_add_coordinates(nc, fun = sf::st_point_ons_surface)
NULL

#' @rdname sf-utils
#' @export
st_add_coordinates <- function(x, col_names = NULL, fun = sf::st_centroid) {
  if (!inherits(x, "sf")) stop("x is not a sf object!", call. = FALSE)

  x_sfc <- sf::st_geometry(x)

  if (inherits(x_sfc, "sfc_POINT")) {
    coordinates <- sf::st_coordinates(x_sfc)
  } else {
    centroids <- fun(x_sfc)
    coordinates <- sf::st_coordinates(centroids)
  }

  if (!is.null(col_names)) {
    len_args <- length(col_names)
    ncol_coordinates <- ncol(coordinates)
    if (len_args != ncol_coordinates) {
      stop(glue::glue("col_names must be length {ncol_coordinates} (ncol of coordinates), not {len_args}"), call. = FALSE)
    }
    colnames(coordinates)[seq_along(col_names)] <- col_names
  }

  cbind(x, coordinates)
}
