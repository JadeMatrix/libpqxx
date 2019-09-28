# Push CMAKE_MODULE_PATH so we don't interfere with the importing project
SET(PREVIOUS_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
SET(CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_LIST_DIR}/CMakeModules"
    ${CMAKE_MODULE_PATH}
)

FIND_PACKAGE(PostgreSQL REQUIRED COMPONENTS pq)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/libpqxx-targets.cmake")

# Update libpqxx compile definitions for the current system
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/CMakeModules/PQXXSystemConfig.cmake")
UNSET(PQXX_PRIVATE_COMPILE_DEFINITIONS)
FOREACH(TARGET libpqxx::pqxx libpqxx::pqxx-shared)
    IF(TARGET ${TARGET})
        SET_TARGET_PROPERTIES(
            ${TARGET} PROPERTIES
            INTERFACE_COMPILE_DEFINITIONS "${PQXX_PUBLIC_COMPILE_DEFINITIONS}"
        )
    ENDIF()
ENDFOREACH()

# Pop CMAKE_MODULE_PATH
SET(CMAKE_MODULE_PATH "${PREVIOUS_CMAKE_MODULE_PATH}")
UNSET(PREV_CMAKE_MODULE_PATH)
