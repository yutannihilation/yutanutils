context("sf")

points_sfc <- sf::st_sfc(
  sf::st_point(c(1, 1)),
  sf::st_point(c(2, 2))
)

points_sf <- sf::st_sf(
  value = c(10, 20),
  geometry = points_sfc
)

nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

polygon_sf <- head(nc, 3)
suppressWarnings(polygon_centroids_sfc <- sf::st_centroid(polygon_sf$geometry))


test_that("coordinates_to_column() works", {
  expect_equal(coordinates_to_column(points_sf),
               sf::st_sf(value = c(10, 20), geometry = points_sfc,
                         X = 1:2, Y = 1:2))
  expect_equal(coordinates_to_column(points_sf, col_names = c("x", "y")),
               sf::st_sf(value = c(10, 20), geometry = points_sfc,
                         x = 1:2, y = 1:2))
  # the length of col_names is wrong
  expect_error(coordinates_to_column(points_sf, col_names = c("x")))

  # sf_add_coordinates() accepts other features than POINT
  suppressWarnings(x <- coordinates_to_column(polygon_sf))
  x_sfc <- sf::st_sfc(purrr::pmap(x, function(X, Y, ...) sf::st_point(c(X, Y))))
  sf::st_crs(x_sfc) <- sf::st_crs(polygon_centroids_sfc)
  expect_equal(x_sfc, polygon_centroids_sfc)
})

