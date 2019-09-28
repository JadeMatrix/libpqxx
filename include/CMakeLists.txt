# Generate & configure installation of generated header files
CONFIGURE_FILE(
    "${PROJECT_SOURCE_DIR}/config/version.hxx.in"
    "${PROJECT_BINARY_DIR}/include/pqxx/version.hxx"
    @ONLY
)
INSTALL(
    DIRECTORY "${PROJECT_BINARY_DIR}/include/pqxx"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    COMPONENT headers
)

INSTALL(
    DIRECTORY "pqxx"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    COMPONENT headers
)
