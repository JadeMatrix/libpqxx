CMAKE_MINIMUM_REQUIRED(VERSION 3.7)


PROJECT(libpqxx VERSION 7.0.0 LANGUAGES CXX)
SET(PROJECT_ABI_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")


SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)

INCLUDE(GNUInstallDirs)
INCLUDE(CMakePackageConfigHelpers)
INCLUDE(CTest)

# Use & mark custom CMake modules for install
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/CMakeModules/")
INSTALL(
    DIRECTORY "CMakeModules"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/libpqxx/"
    COMPONENT cmake
)

INCLUDE(PQXXSystemConfig)


IF(
    "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GCC"
    OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang"
    OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"
)
    SET(PQXX_COMPILE_OPTIONS
        "-fstrict-enums"
        "-Werror"
        "-Wall"
        "-pedantic"
        "-Wcast-align"
        "-Wcast-qual"
        "-Wconversion"
        "-Wctor-dtor-privacy"
        "-Wendif-labels"
        "-Wextra"
        "-Wfloat-equal"
        "-Wformat=2"
        "-Wformat-security"
        "-Wmissing-include-dirs"
        "-Wno-div-by-zero"
        "-Wnon-virtual-dtor"
        "-Wold-style-cast"
        "-Woverlength-strings"
        "-Woverloaded-virtual"
        "-Wpointer-arith"
        "-Wredundant-decls"
        "-Wshadow"
        "-Wsign-promo"
        "-Wwrite-strings"
        "-Wundef"
        "-Wunused"
        "-Wextra-semi"
        "-fvisibility=hidden"
        "-fvisibility-inlines-hidden"
    )
    IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GCC")
        LIST(APPEND PQXX_COMPILE_OPTIONS
            "-fnothrow-opt"
            "-Wattribute-alias"
            "-Wlogical-op"
            "-Wrestrict"
            "-Wstringop-overflow"
            "-Wsuggest-override"
            "-Wzero-as-null-pointer-constant"
        )
    ENDIF()
ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    SET(PQXX_COMPILE_OPTIONS "/Wall" "/WX")
ENDIF()


# Subdirectories
ADD_SUBDIRECTORY("include/")
ADD_SUBDIRECTORY("src/")
IF(BUILD_TESTING)
    ADD_SUBDIRECTORY("test/")
ENDIF()


# Package configuration
WRITE_BASIC_PACKAGE_VERSION_FILE(
    "${CMAKE_CURRENT_BINARY_DIR}/libpqxx-config-version.cmake"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY SameMinorVersion
)
INSTALL(
    FILES
        "config/libpqxx-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/libpqxx-config-version.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/libpqxx"
    COMPONENT cmake
)
EXPORT(EXPORT libpqxx-targets
    NAMESPACE "libpqxx::"
    FILE "${CMAKE_CURRENT_BINARY_DIR}/libpqxx-targets.cmake"
)
INSTALL(
    EXPORT libpqxx-targets
    NAMESPACE "libpqxx::"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/libpqxx"
    COMPONENT cmake
)

SET(PQXX_PKGCONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc")
CONFIGURE_FILE("config/pkg-config.pc.in" "${PQXX_PKGCONFIG_FILE}" @ONLY)
INSTALL(
    FILES "${PQXX_PKGCONFIG_FILE}"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig/"
    COMPONENT pkg-config
)
