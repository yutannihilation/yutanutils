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

test_that("coordinates_to_column() works", {
  expect_equal(coordinates_to_column(points_sf),
               sf::st_sf(value = c(10, 20), geometry = points_sfc,
                         X = 1:2, Y = 1:2))
  expect_equal(coordinates_to_column(points_sf, col_names = c("x", "y")),
               sf::st_sf(value = c(10, 20), geometry = points_sfc,
                         x = 1:2, y = 1:2))
  # the length of col_names is wrong
  expect_error(coordinates_to_column(points_sf, col_names = c("x")))

  # sf_add_coordinates() accepts POINT
  suppressWarnings(x <- coordinates_to_column(polygon_sf))
  suppressWarnings(x2 <- sf::st_centroid(polygon_sf$geometry))
  expect_equal(sf::st_point(c(x$X[1], x$Y[1])), x2[[1]])
  expect_equal(sf::st_point(c(x$X[2], x$Y[2])), x2[[2]])
  expect_equal(sf::st_point(c(x$X[3], x$Y[3])), x2[[3]])
})
