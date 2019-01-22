# Simple Find script to wrap CMake's built-in FindPostgreSQL variables in a
# component target

# Push & clear CMAKE_MODULE_PATH to use the default FindPostgreSQL, then pop
SET(PREVIOUS_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
SET(CMAKE_MODULE_PATH)
FIND_PACKAGE(PostgreSQL REQUIRED)
SET(CMAKE_MODULE_PATH "${PREVIOUS_CMAKE_MODULE_PATH}")
UNSET(PREV_CMAKE_MODULE_PATH)

IF(
    PostgreSQL_FOUND
    AND "pq" IN_LIST PostgreSQL_FIND_COMPONENTS
    AND NOT TARGET PostgreSQL::pq
)
    ADD_LIBRARY(PostgreSQL::pq SHARED IMPORTED)
    SET_TARGET_PROPERTIES(
        PostgreSQL::pq
        PROPERTIES
            IMPORTED_LOCATION "${PostgreSQL_LIBRARIES}"
            INTERFACE_INCLUDE_DIRECTORIES "${PostgreSQL_INCLUDE_DIRS}"
            VERSION "${PostgreSQL_VERSION_STRING}"
    )
ENDIF()

IF(NOT TARGET PostgreSQL::pq)
    message("unable to find libpq")
ENDIF()
