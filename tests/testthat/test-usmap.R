
states_map <- us_map(regions = "states")
counties_map <- us_map(regions = "counties")

test_that("structure of states df is correct", {
  expect_equal(length(unique(states_map$fips)), 51)
})

test_that("correct states are included", {
  include_abbr <- c("AK", "AL", "AZ")
  map_abbr <- us_map(regions = "states", include = include_abbr)

  include_full <- c("Alaska", "Alabama", "Arizona")
  map_full <- us_map(regions = "states", include = include_full)

  include_fips <- c("02", "01", "04")
  map_fips <- us_map(regions = "states", include = include_fips)

  expect_equal(length(unique(map_abbr$fips)), length(include_abbr))
  expect_equal(length(unique(map_full$fips)), length(include_full))
  expect_equal(length(unique(map_fips$fips)), length(include_fips))
})

test_that("correct states are excluded", {
  full_map <- us_map(regions = "states")

  exclude_abbr <- c("AK", "AL", "AZ")
  map_abbr <- us_map(regions = "states", exclude = exclude_abbr)

  exclude_full <- c("Alaska", "Alabama", "Arizona")
  map_full <- us_map(regions = "states", exclude = exclude_full)

  exclude_fips <- c("02", "01", "04")
  map_fips <- us_map(regions = "states", exclude = exclude_fips)

  expect_equal(length(unique(full_map$fips)) - length(unique(map_abbr$fips)), length(exclude_abbr))
  expect_equal(length(unique(full_map$fips)) - length(unique(map_full$fips)), length(exclude_full))
  expect_equal(length(unique(full_map$fips)) - length(unique(map_fips$fips)), length(exclude_fips))
})


test_that("structure of counties df is correct", {
  expect_equal(length(unique(counties_map$fips)), 3144)
})

test_that("correct counties are included", {
  include_fips <- c("34021", "34023", "34025")
  map_fips <- us_map(regions = "counties", include = include_fips)

  expect_equal(length(unique(map_fips$fips)), length(include_fips))
})

test_that("correct counties are excluded", {
  exclude_fips <- c("34021", "34023", "34025")
  map_fips <- us_map(regions = "counties", include = "NJ", exclude = exclude_fips)
  map_nj <- us_map(regions = "counties", include = "NJ")

  expect_equal(length(unique(map_nj$fips)) - length(unique(map_fips$fips)), (length(exclude_fips)))
})

test_that("singular regions value returns same data frames as plural", {
  state_map <- us_map(regions = "state")
  county_map <- us_map(regions = "county")

  expect_identical(states_map, state_map)
  expect_identical(counties_map, county_map)
})

test_that("error occurs for invalid region", {
  expect_error(us_map(regions = "cities"))
})

test_that("centroid labels are loaded", {
  expect_equal(length(centroid_labels("states")[[1]]), 51)
  expect_equal(length(centroid_labels("counties")[[1]]), 3144)
  expect_equal(length(centroid_labels("state")[[1]]), 51)
  expect_equal(length(centroid_labels("county")[[1]]), 3144)
  expect_identical(centroid_labels("counties"), centroid_labels("county"))
  expect_identical(centroid_labels("states"), centroid_labels("state"))
})

test_that("warning produced for unavailable map years", {
  expect_warning(us_map(data_year = 1900))
  expect_warning(us_map(data_year = 2100))
})

test_that("correct year chosen when unavailable year provided", {
  available_years <- usmapdata:::available_map_years()

  expect_equal(usmapdata:::select_map_year(2023), 2023)
  expect_equal(
    suppressWarnings(usmapdata:::select_map_year(1000)),
    min(available_years)
  )
  expect_equal(
    suppressWarnings(usmapdata:::select_map_year(3000)),
    max(available_years)
  )
})
