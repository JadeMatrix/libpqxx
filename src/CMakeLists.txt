FIND_PACKAGE(PostgreSQL REQUIRED COMPONENTS pq)


SET(PQXX_INCLUDE_INTERFACES
    PUBLIC
        # Although this shouldn't happen, prefer generated headers over headers
        # in the source tree with the same name.
        "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>"
        "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)


ADD_LIBRARY(_pqxx OBJECT)
TARGET_INCLUDE_DIRECTORIES(_pqxx ${PQXX_INCLUDE_INTERFACES})
TARGET_SOURCES(_pqxx
    PRIVATE
        "array.cxx"
        "binarystring.cxx"
        "connection.cxx"
        "cursor.cxx"
        "encodings.cxx"
        "errorhandler.cxx"
        "except.cxx"
        "field.cxx"
        "largeobject.cxx"
        "notification.cxx"
        "pipeline.cxx"
        "result.cxx"
        "robusttransaction.cxx"
        "row.cxx"
        "sql_cursor.cxx"
        "statement_parameters.cxx"
        "strconv.cxx"
        "stream_from.cxx"
        "stream_to.cxx"
        "subtransaction.cxx"
        "transaction.cxx"
        "transaction_base.cxx"
        "util.cxx"
        "version.cxx"
)
IF(WIN32)
    TARGET_SOURCES(_pqxx PRIVATE "${PROJECT_SOURCE_DIR}/win32/libpqxx.cxx")
    TARGET_LINK_LIBRARIES(_pqxx PUBLIC wsock32 ws2_32)
ENDIF()
TARGET_COMPILE_OPTIONS(_pqxx PRIVATE ${PQXX_COMPILE_OPTIONS})
TARGET_COMPILE_DEFINITIONS(
    _pqxx
    PRIVATE ${PQXX_PRIVATE_COMPILE_DEFINITIONS}
    PUBLIC ${PQXX_PUBLIC_COMPILE_DEFINITIONS}
)


MACRO(PQXX_ADD_LIBRARY NAME TYPE)
    ADD_LIBRARY("${NAME}" "${TYPE}")
    SET_TARGET_PROPERTIES("${NAME}" PROPERTIES
        OUTPUT_NAME "pqxx"
        VERSION "${PROJECT_VERSION}"
        SOVERSION "${PROJECT_ABI_VERSION}"
    )

    TARGET_INCLUDE_DIRECTORIES("${NAME}" ${PQXX_INCLUDE_INTERFACES})
    TARGET_LINK_LIBRARIES("${NAME}" PRIVATE _pqxx)
    TARGET_COMPILE_OPTIONS("${NAME}" PRIVATE ${PQXX_COMPILE_OPTIONS})
    TARGET_COMPILE_DEFINITIONS(
        "${NAME}"
        PUBLIC ${PQXX_PUBLIC_COMPILE_DEFINITIONS}
    )

    STRING(TOLOWER "${TYPE}" TYPE_LOWER)

    INSTALL(
        TARGETS "${NAME}"
        EXPORT libpqxx-targets
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        COMPONENT ${TYPE_LOWER}_libraries
    )
ENDMACRO()


PQXX_ADD_LIBRARY(pqxx STATIC)
PQXX_ADD_LIBRARY(pqxx-shared SHARED)

# libpq has to be marked PUBLIC for static libpqxx for linking purposes but can
# be marked PRIVATE for the shared library
TARGET_LINK_LIBRARIES(pqxx PUBLIC PostgreSQL::pq)
TARGET_LINK_LIBRARIES(pqxx-shared PRIVATE PostgreSQL::pq)

# Export alias to `pqxx` called `pqxx-static`
ADD_LIBRARY(pqxx-static INTERFACE)
TARGET_LINK_LIBRARIES(pqxx-static INTERFACE pqxx)
INSTALL(TARGETS pqxx-static EXPORT libpqxx-targets)
