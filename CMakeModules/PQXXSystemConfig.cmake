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


CHECK_INCLUDE_FILE_CXX("sys/select.h" HAVE_SYS_SELECT_H)
CHECK_INCLUDE_FILE_CXX("sys/time.h"   HAVE_SYS_TIME_H  )
CHECK_INCLUDE_FILE_CXX("sys/types.h"  HAVE_SYS_TYPES_H )
CHECK_INCLUDE_FILE_CXX("unistd.h"     HAVE_UNISTD_H    )

CHECK_FUNCTION_EXISTS("poll" HAVE_POLL)

CMAKE_DETERMINE_COMPILE_FEATURES(CXX)
IF("cxx_attribute_deprecated" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
  SET(PQXX_HAVE_DEPRECATED)
ENDIF()

CHECK_CXX_SOURCE_COMPILES(
    "#include <optional>\nint main() { std::optional<int> o; }"
    PQXX_HAVE_OPTIONAL
    FAIL_REGEX "warning|error"
)
CHECK_CXX_SOURCE_COMPILES(
    "#include <optional>\nint main() { std::experimental::optional<int> o; }"
    PQXX_HAVE_EXP_OPTIONAL
    FAIL_REGEX "warning|error"
)

PQXX_DETECT_ATTRIBUTE("const" PQXX_HAVE_GCC_CONST)
PQXX_DETECT_ATTRIBUTE("pure" PQXX_HAVE_GCC_PURE)
PQXX_DETECT_ATTRIBUTE(
    "visibility(\"default\")"
    PQXX_HAVE_GCC_VISIBILITY
    "visibility"
)


SET(PQXX_PRIVATE_COMPILE_DEFINITIONS)
SET(PQXX_PUBLIC_COMPILE_DEFINITIONS)

FOREACH(DEFINE
    HAVE_SYS_SELECT_H
    HAVE_SYS_TIME_H
    HAVE_SYS_TYPES_H
    HAVE_UNISTD_H
    HAVE_POLL
)
    IF(${DEFINE})
        LIST(APPEND PQXX_PRIVATE_COMPILE_DEFINITIONS "${DEFINE}")
    ENDIF()
ENDFOREACH()

FOREACH(DEFINE
    PQXX_HAVE_OPTIONAL
    PQXX_HAVE_EXP_OPTIONAL
    PQXX_HAVE_GCC_CONST
    PQXX_HAVE_GCC_PURE
    PQXX_HAVE_GCC_VISIBILITY
)
    IF(${DEFINE})
        LIST(APPEND PQXX_PUBLIC_COMPILE_DEFINITIONS "${DEFINE}")
    ENDIF()
ENDFOREACH()