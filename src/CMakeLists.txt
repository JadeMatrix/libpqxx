FIND_PACKAGE(PostgreSQL REQUIRED COMPONENTS pq)


SET(PQXX_SOURCES
    "array.cxx"
    "binarystring.cxx"
    "connection.cxx"
    "connection_base.cxx"
    "cursor.cxx"
    "dbtransaction.cxx"
    "encodings.cxx"
    "errorhandler.cxx"
    "except.cxx"
    "field.cxx"
    "largeobject.cxx"
    "nontransaction.cxx"
    "notification.cxx"
    "pipeline.cxx"
    "prepared_statement.cxx"
    "result.cxx"
    "robusttransaction.cxx"
    "row.cxx"
    "sql_cursor.cxx"
    "statement_parameters.cxx"
    "strconv.cxx"
    "stream_base.cxx"
    "stream_from.cxx"
    "stream_to.cxx"
    "subtransaction.cxx"
    "tablereader.cxx"
    "tablestream.cxx"
    "tablewriter.cxx"
    "transaction.cxx"
    "transaction_base.cxx"
    "util.cxx"
    "version.cxx"
)


MACRO(PQXX_ADD_LIBRARY NAME TYPE)
    ADD_LIBRARY("${NAME}" ${TYPE} ${PQXX_SOURCES})
    SET_TARGET_PROPERTIES("${NAME}" PROPERTIES OUTPUT_NAME "pqxx")

    TARGET_INCLUDE_DIRECTORIES(
        "${NAME}"
        PUBLIC
            "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
            "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )
    # libpq has to be marked PUBLIC so it's linked when static libpqxx is used
    TARGET_LINK_LIBRARIES("${NAME}" PUBLIC PostgreSQL::pq)
    IF(WIN32)
        TARGET_LINK_LIBRARIES("${NAME}" PUBLIC wsock32 ws2_32)
    ENDIF()
    TARGET_COMPILE_OPTIONS("${NAME}" PRIVATE ${PQXX_COMPILE_OPTIONS})

    INSTALL(
        TARGETS "${NAME}"
        EXPORT libpqxx-targets
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    )
ENDMACRO()


PQXX_ADD_LIBRARY(pqxx STATIC)
PQXX_ADD_LIBRARY(pqxx-shared SHARED)

# Export alias to `pqxx` called `pqxx-static`
ADD_LIBRARY(pqxx-static INTERFACE)
TARGET_LINK_LIBRARIES(pqxx-static INTERFACE pqxx)
INSTALL(TARGETS pqxx-static EXPORT libpqxx-targets)
