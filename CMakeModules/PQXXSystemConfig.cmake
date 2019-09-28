INCLUDE(CheckIncludeFileCXX)
INCLUDE(CheckFunctionExists)
INCLUDE(CMakeDetermineCompileFeatures)
INCLUDE(CheckCXXSourceCompiles)


SET(
    CMAKE_REQUIRED_DEFINITIONS
    "${CMAKE_CXX${CMAKE_CXX_STANDARD}_STANDARD_COMPILE_OPTION}"
)

FUNCTION(PQXX_DETECT_ATTRIBUTE ATTRIBUTE OUT)
    CHECK_CXX_SOURCE_COMPILES(
        "int foo() __attribute__ ((${ATTRIBUTE})); int main() { return 0; }"
        "${OUT}"
        FAIL_REGEX "warning|error"
    )
ENDFUNCTION()

FUNCTION(PQXX_CHECK_CXX_FILE_COMPILES TESTNAME OUT)
    FILE(READ "${CMAKE_CURRENT_LIST_DIR}/compile-checks/${TESTNAME}.cxx" SOURCE)
    CHECK_CXX_SOURCE_COMPILES(
        "${SOURCE}"
        "${OUT}"
        FAIL_REGEX "warning|error"
    )
ENDFUNCTION()


CHECK_FUNCTION_EXISTS("poll" PQXX_HAVE_POLL)

CMAKE_DETERMINE_COMPILE_FEATURES(CXX)
IF("cxx_attribute_deprecated" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
    SET(PQXX_HAVE_DEPRECATED)
ENDIF()

# It's early 2019, and gcc's charconv supports integers but not yet floats.
# So for now, we test for int and float conversion... separately.
#
# It's worse for clang, which compiles the integer conversions but then fails
# at link time because of a missing symbol "__muloti4" when compiling
# "long long" code.  I couldn't resolve that symbol by adding -lm either.
PQXX_CHECK_CXX_FILE_COMPILES(
    "charconv_int"
    PQXX_HAVE_CHARCONV_INT
)
PQXX_CHECK_CXX_FILE_COMPILES(
    "charconv_float"
    PQXX_HAVE_CHARCONV_FLOAT
)
PQXX_CHECK_CXX_FILE_COMPILES(
    "cxa_demangle"
    PQXX_HAVE_CXA_DEMANGLE
)

PQXX_DETECT_ATTRIBUTE("pure" PQXX_HAVE_GCC_PURE)
PQXX_DETECT_ATTRIBUTE(
    "visibility(\"default\")"
    PQXX_HAVE_GCC_VISIBILITY
    "visibility"
)


SET(PQXX_PRIVATE_COMPILE_DEFINITIONS)
SET(PQXX_PUBLIC_COMPILE_DEFINITIONS)

FOREACH(DEFINE
    PQXX_HAVE_POLL
    PQXX_HAVE_CHARCONV_INT
    PQXX_HAVE_CHARCONV_FLOAT
    PQXX_HAVE_CXA_DEMANGLE
)
    IF(${DEFINE})
        LIST(APPEND PQXX_PRIVATE_COMPILE_DEFINITIONS "${DEFINE}")
    ENDIF()
ENDFOREACH()

FOREACH(DEFINE
    PQXX_HAVE_GCC_PURE
    PQXX_HAVE_GCC_VISIBILITY
)
    IF(${DEFINE})
        LIST(APPEND PQXX_PUBLIC_COMPILE_DEFINITIONS "${DEFINE}")
    ENDIF()
ENDFOREACH()
